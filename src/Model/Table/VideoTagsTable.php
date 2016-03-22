<?php

namespace App\Model\Table;

use App\Model\Entity\VideoTag;
use Cake\ORM\Query;
use Cake\ORM\RulesChecker;
use Cake\ORM\Table;
use Cake\Validation\Validator;

/**
 * VideoTags Model
 *
 * @property \Cake\ORM\Association\BelongsTo $Videos
 * @property \Cake\ORM\Association\BelongsTo $Tags
 * @property \Cake\ORM\Association\BelongsTo $Users
 * @property \Cake\ORM\Association\HasMany $VideoTagPoints
 */
class VideoTagsTable extends Table {

    const MIN_TAG_DURATION = 2; // TODO common with others
    const MAX_TAG_DURATION = 40;
    const SIMILARITY_RATIO_THRESHOLD = 0.6;
    const SIMILARITY_PRECISION_SECONDS = 2;

    /**
     * Initialize method
     *
     * @param array $config The configuration for the Table.
     * @return void
     */
    public function initialize(array $config) {
        parent::initialize($config);

        $this->table('video_tags');
        $this->displayField('id');
        $this->primaryKey('id');

        $this->addBehavior('Timestamp');

        $this->belongsTo('Videos', [
            'foreignKey' => 'video_id',
            'joinType' => 'INNER'
        ]);
        $this->belongsTo('Tags', [
            'foreignKey' => 'tag_id',
            'joinType' => 'INNER'
        ]);
        $this->belongsTo('Riders', [
            'foreignKey' => 'rider_id',
            'joinType' => 'LEFT'
        ]);
        $this->belongsTo('Users', [
            'foreignKey' => 'user_id'
        ]);
        $this->hasMany('VideoTagAccuracyRates', [
            'foreignKey' => 'video_tag_id'
        ]);
    }

    public function findTrending($limit = 5) {
        return $this->findAndJoin()
                        ->order(['VideoTags.count_points DESC'])
                        ->where(['VideoTags.status ' => VideoTag::STATUS_VALIDATED])
                        ->limit($limit)
                        ->cache('videotags', 'oneHourCache');
    }

    /**
     * Find data for tags and do joins 
     * 
     * @param query | null $queryVideo 
     * @param query | null $queryTags
     * @return query
     */
    public function findAndJoin($query = null, $queryVideo = null, $queryTags = null, $queryRiders = null) {
        if ($queryVideo === null) {
            $queryVideo = function($q) {
                return $q;
            };
        }
        if ($queryTags === null) {
            $queryTags = function($q) {
                return $q
                                ->select([
                                    'category_name' => 'Categories.name',
                                    'category_id' => 'Categories.id',
                                    'sport_name' => 'Sports.name',
                                    'sport_id' => 'Sports.id',
                                    'tag_name' => 'Tags.name',
                                ])
                                ->contain(['Sports', 'Categories']);
            };
        }
        if ($queryRiders === null) {
            $queryRiders = function($q) {
                return $q->select([
                            'rider_name' => 'CONCAT(Riders.firstname, \' \', Riders.lastname)',
                            'rider_picture' => 'Riders.picture',
                            'rider_nationality' => 'Riders.nationality',
                            'rider_slug' => 'Riders.slug',
                            'rider_id' => 'Riders.id'
                ]);
            };
        }
        if ($query === null) {
            $query = $this->find('all');
        }
        return $query
                        ->select([
                            'tag_slug' => 'Tags.slug',
                            'tag_name' => 'Tags.name',
                            'tag_id' => 'Tags.id',
                            'count_points' => 'VideoTags.count_points',
                            'id' => 'VideoTags.id',
                            'provider_id' => 'Videos.provider_id',
                            'video_url' => 'Videos.video_url',
                            'video_duration' => 'Videos.duration',
                            'video_id' => 'Videos.id',
                            'begin' => 'VideoTags.begin',
                            'end' => 'VideoTags.end',
                            'user_id' => 'VideoTags.user_id',
                            'status' => 'VideoTags.status'
                        ])
                        ->contain([
                            'Videos' => $queryVideo,
                            'Tags' => $queryTags,
                            'Riders' => $queryRiders
        ]);
    }

    /**
     * Default validation rules.
     *
     * @param \Cake\Validation\Validator $validator Validator instance.
     * @return \Cake\Validation\Validator
     */
    public function validationDefault(Validator $validator) {
        $validator
                ->add('id', 'valid', ['rule' => 'numeric'])
                ->allowEmpty('id', 'create');

        $validator
                ->add('begin', 'decimal', ['rule' => 'decimal'])
                ->add('begin', 'postive', [
                    'rule' => function ($value, $context) {
                return $value >= 0;
            },
                    'message' => 'Begin time must be a positive number.'
                ])
                ->requirePresence('begin', 'create')
                ->notEmpty('begin');

        $validator
                ->add('end', 'trick_duration', [
                    'rule' => function ($value, $context) {
                if ($value < self::MIN_TAG_DURATION) {
                    return false;
                }
                if (isset($context['data']['begin'])) {
                    $duration = $value - $context['data']['begin'];
                    return $duration >= self::MIN_TAG_DURATION &&
                            $duration <= self::MAX_TAG_DURATION;
                }
                return true;
            },
                    'message' => 'The trick duration must be between ' . self::MIN_TAG_DURATION . ' and ' .
                    self::MAX_TAG_DURATION . ' seconds.'
                ])
                ->add('end', 'decimal', ['rule' => 'decimal'])
                ->requirePresence('end', 'create')
                ->notEmpty('end');

        $validator
                ->requirePresence('user_id', 'create')
                ->notEmpty('user_id');

        $validator
                ->requirePresence('video_id', 'create')
                ->notEmpty('video_id');

        $validator
                ->requirePresence('tag_id', 'create')
                ->notEmpty('tag_id');



        return $validator;
    }

    function findSimilarTags($videoId, $begin, $end) {
        $beginMin = $begin + self::SIMILARITY_PRECISION_SECONDS;
        $endMin = $begin - self::SIMILARITY_PRECISION_SECONDS;
        $beginMax = $begin - self::SIMILARITY_PRECISION_SECONDS;
        $endMax = $end + self::SIMILARITY_PRECISION_SECONDS;
        return $this->findAndJoin()
                        ->where([
                            'video_id' => $videoId,
                            'OR' => [
                                // Include inside bigger tag
                                ['VideoTags.begin <= ' => $beginMin, 'VideoTags.end >= ' => $endMin],
                                // Contain bigger tag
                                ['VideoTags.begin >= ' => $beginMax, 'VideoTags.end <= ' => $endMax]
                            ]
        ]);
    }

    /**
     * Returns a rules checker object that will be used for validating
     * application integrity.
     *
     * @param \Cake\ORM\RulesChecker $rules The rules object to be modified.
     * @return \Cake\ORM\RulesChecker
     */
    public function buildRules(RulesChecker $rules) {
        $rules->add($rules->existsIn(['video_id'], 'Videos'));
        $rules->add($rules->existsIn(['tag_id'], 'Tags'));
        $rules->add($rules->existsIn(['user_id'], 'Users'));
        $rules->add($rules->existsIn(['rider_id'], 'Riders'));

        // Checking similar tags
//        $rules->add(function($entity, $scope) {
//            if ($entity->isNew() || $entity->dirty('begin') || $entity->dirty('end')) {
//                if ($scope['repository']->existsSimilarValidated($entity)) {
//                    $entity->errors('begin', ['There is already a validated trick here']);
//                    return false;
//                }
//            }
//            return true;
//        });
        return $rules;
    }

    /**
     * Returns true if there is a similar tags already validated
     * @param \App\Model\Entity\VideoTag $entity
     * @return boolean
     */
    public function existsSimilarValidated(\App\Model\Entity\VideoTag $entity) {
        $conditions = [
            'VideoTags.video_id' => $entity->video_id,
            'VideoTags.status' => VideoTag::STATUS_VALIDATED,
            '(LEAST(' . $entity->end . ', end) - GREATEST(' . $entity->begin . ', begin))/(end - begin) > '
            . self::SIMILARITY_RATIO_THRESHOLD,
        ];
        if (!$entity->isNew()) {
            $conditions['VideoTags.id !='] = $entity->id;
        }
        return $this->exists($conditions);
    }

    /**
     * @param \Cake\ORM\Entity $entity
     */
    private function createTag($videoTag) {
        // Creating a new tag if needed !
        // Create tag 
        $tagTable = \Cake\ORM\TableRegistry::get('Tags');
        $tagEntity = $tagTable->newEntity($videoTag->tag);
        $tagEntity->user_id = $videoTag->user_id;
        $tagEntity = $tagTable->createOrGet($tagEntity, $tagEntity->user_id);
        if (!$tagEntity) {
            $videoTag->tag_id = null;
            $videoTag->errors('tag_id', ['The new trick could not be created']);
            return false;
        }
        $videoTag->tag_id = $tagEntity->id;
        unset($tagEntity->tag);
        return true;
    }

    /**
     * @param \App\Model\Table\Event $event
     * @param \Cake\ORM\Entity $entity
     * @param \App\Model\Table\ArrayObject $options
     */
    public function beforeSave($event, $entity, $options) {
        if ($entity->status === VideoTag::STATUS_BLOCKED) {
            $event->stopPropagation();
            $entity->errors('status', ['You are not authorized to edit this trick']);
            return false;
        }
        
        if ($entity->tag !== null) {
            if (!$this->createTag($entity)){
                $event->stopPropagation();
            }
        }

        $entity->_delete_accuracy_rates = false;
        $now = date('c');
        $entity->modified = $now;
        if ($entity->isNew() && empty($entity->status)) {
            $entity->created = $now;
            if ($this->existsSimilarValidated($entity)) {
                $entity->status = VideoTag::STATUS_DUPLICATE;
            } else {
                $entity->status = VideoTag::STATUS_PENDING;
            }
        } else if (!$entity->isNew() &&
                ($entity->status === VideoTag::STATUS_REJECTED || $entity->status === VideoTag::STATUS_PENDING)) {
            // Reset counter
            if ($this->existsSimilarValidated($entity)) {
                $entity->status = VideoTag::STATUS_DUPLICATE;
            }
        }
        $this->modified = date('c');
    }

    /**
     * @param \App\Model\Table\Event $event
     * @param \Cake\ORM\Entity $entity
     * @param \App\Model\Table\ArrayObject $options
     */
    public function afterSave($event, $entity, $options) {
        // Delete all user rates
        if ($entity->_delete_accuracy_rates) {
            $accuracyRatesTable = \Cake\ORM\TableRegistry::get('VideoTagAccuracyRates');
            $accuracyRatesTable->deleteAll([
                'video_tag_id' => $entity->id
            ]);
        }
    }

}
