<?php

namespace App\Model\Table;

use App\Model\Entity\Video;
use Cake\ORM\Query;
use Cake\ORM\RulesChecker;
use Cake\ORM\Table;
use Cake\Validation\Validator;
use App\Lib\YoutubeRequest;
use App\Lib\JsonConfigHelper;

/**
 * Videos Model
 *
 * @property \Cake\ORM\Association\BelongsTo $Videos
 * @property \Cake\ORM\Association\BelongsTo $VideoProviders
 * @property \Cake\ORM\Association\BelongsTo $Users
 * @property \Cake\ORM\Association\HasMany $VideoTags
 * @property \Cake\ORM\Association\HasMany $Videos
 */
class VideosTable extends Table {

    private $youtube = null;
    
    /**
     * Initialize method
     *
     * @param array $config The configuration for the Table.
     * @return void
     */
    public function initialize(array $config) {
        parent::initialize($config);

        $this->table('videos');
        $this->displayField('id');
        $this->primaryKey('id');

//        $this->belongsTo('Videos', [
//            'foreignKey' => 'video_id',
//            'joinType' => 'INNER'
//        ]);
//        $this->belongsTo('VideoProviders', [
//            'foreignKey' => 'provider_id',
//            'joinType' => 'INNER'
//        ]);
        $this->belongsTo('Users', [
            'foreignKey' => 'user_id'
        ]);
        
                
        $this->hasMany('VideoTags', [
            'foreignKey' => 'video_id'
        ]);
//        $this->hasMany('Videos', [
//            'foreignKey' => 'video_id'
//        ]);
        

        $this->youtube = new YoutubeRequest(array('key' => \Cake\Core\Configure::read('Youtube.key')));
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
                ->requirePresence('provider_id', 'create')
                ->notEmpty('provider_id')
                ->add('provider_id', 'valid', ['rule' => function ($value){
                    $data = JsonConfigHelper::rules("videos", "provider_id", "values");
                    foreach ($data as $d){
                        if ($d['code'] == $value){
                            return true;
                        }
                    }
                    return false;
                }]);
        
        $validator
                ->requirePresence('user_id', 'create')
                ->notEmpty('user_id');

        $validator
                ->requirePresence('video_url', 'create')
                ->notEmpty('video_url')
                ->add('video_url', 'custom', [
                    'rule' => function ($value, $context) {
                return $this->videoExists($value);
            },
                    'message' => 'The video id is invalid'
        ]);

        return $validator;
    }

    public function videoInfo($url, $provider = 'youtube') {
        switch ($provider) {
            case 'youtube':
                return $this->youtube->getVideoInfo(YoutubeRequest::urlToId($url));
                break;
        }
        return false;
    }

    public function videoExists($url, $provider = 'youtube') {
        // TODO youtube key as global variable
        try {
            $video = $this->videoInfo($url, $provider);
            if (!isset($video->status)) {
                return false;
            }
            $status = $video->status;
            return isset($status->embeddable) && $status->embeddable && isset($status->privacyStatus) && $status->privacyStatus === 'public';
        } catch (Exception $e) {
            
        }
        return false;
    }

    /**
     * Returns a rules checker object that will be used for validating
     * application integrity.
     *
     * @param \Cake\ORM\RulesChecker $rules The rules object to be modified.
     * @return \Cake\ORM\RulesChecker
     */
    public function buildRules(RulesChecker $rules) {
        $rules->add($rules->existsIn(['user_id'], 'Users'));
//        $rules->add($rules->existsIn(['provider_id'], 'VideoProviders'));
        $rules->add($rules->isUnique(['video_url', 'provider_id'], 'This video is already in the database'));
        return $rules;
    }

    /**
     * @param \App\Model\Table\Event $event
     * @param \Cake\ORM\Entity $entity
     * @param \App\Model\Table\ArrayObject $options
     */
    public function beforeSave($event, $entity, $options){
        if ($entity->isNew() && empty($entity->status)){
            $entity->status = Video::STATUS_PUBLIC;
            $entity->duration = $this->youtube->duration($entity->video_url);
        }
    }
    
    public function search($videoId, $provider) {
        return $this->find('all')->where(['video_url' => $videoId, 'provider_id' => $provider])->limit(1);
    }

    public function updateVideoDuration(){
        $videos = $this->find('all')->where(['Videos.duration' => 0]);
        foreach ($videos as $video){
            $video->duration = $this->youtube->duration($video->video_url);
            $this->save($video);
        }
        return true;
    }
}
