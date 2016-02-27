(function(window, angular) {
    'use strict';
    angular.module('app.player')
            .factory('VimeoCmdMapper', ['$q', function($q) {

                var factory = {
                    params: {
                        url: null,
                        callback: 'JSON_CALLBACK',
                    }
                };

                factory.create = function(player) {
                    return new VimeoCmdMapper(player);
                };

                factory.onVideoChanged = function() {
                };

                function VimeoCmdMapper(player) {
                    console.log("Setting cmd mapper with video player");
                    this._player = player;
                }
                VimeoCmdMapper.prototype = {
                    seekTo: seekTo,
                    getCurrentTime: getCurrentTime,
                    loadVideo: loadVideo,
                    play: play,
                    stop: stop,
                    pause: pause
                };

                function seekTo(seconds) {
                    this._player.api('seekTo', seconds);
                }
                function getCurrentTime() {
                    var self = this;
                    return $q(function(resolve, reject){
                        self._player.api('getCurrentTime', function(value){
                            return resolve(value);
                        });
                    });
                }
                function loadVideo(data) {
                    factory.onVideoChanged(data.video_url);
                }
                function play() {
                    this._player.api('play');
                }
                function stop() {
                    this._player.api('stop');
                }
                function pause() {
                    this._player.api('pause');
                }

                return factory;

            }])
            .directive('vimeoVideo', vimeoVideoDirective);
//            .factory('VimeoService', VimeoService);

    vimeoVideoDirective.$inject = ['VimeoCmdMapper'];
    function vimeoVideoDirective(VimeoCmdMapper) {
        return {
            restrict: 'EA',
            replace: true,
            scope: {
                playerData: '='
            },
            link: function(scope, element, attrs, ctrl) {
                var playerId = attrs.playerId || element[0].id;
                element[0].id = playerId + 'Container';
                var PlayerData = scope.playerData;

                var url = PlayerData.data.video_url ? PlayerData.data.video_url : null;
                PlayerData.setPlayer('vimeo', VimeoCmdMapper.create(null));



                VimeoCmdMapper.onVideoChanged = function(videoUrl) {
                    PlayerData.resetPlayer('vimeo');

                    var html = '<iframe \n\
                            src="http://player.vimeo.com/video/'+videoUrl+'?api=1&amp;player_id='+playerId+'&amp;callback=JSON_CALLBACK" \n\
                            id="'+playerId+'" width="100%" height="100%" frameborder="0"></iframe>'
                    element.html(html);
                    var iframe = $('#' + playerId)[0];
                    var player = $f(iframe);
                    // When the player is ready, add listeners for pause, finish, and playProgress
                    player.addEvent('ready', function(playerId) {
                        var player = $f(playerId);
                        PlayerData.setPlayer('vimeo', VimeoCmdMapper.create(player));
                        player.addEvent('playProgress', function(data){
                            PlayerData.onPlayProgress(data.seconds);
                        });
                    });
                    // TODO error: 
                    // PlayerData.errorPlayer('vimeo', error);

                };


                if (url !== null) {
                    VimeoCmdMapper.onVideoChanged(VimeoCmdMapper.params);
                }

//                function onPause(id) {
//                    console.log('paused');
//                }
//
//                function onFinish(id) {
//                    console.log('finished');
//                }
//
//                function onPlayProgress(data, id) {
//                    console.log(data.seconds + 's played');
//                }

            }
        };
    }
//
//    VimeoService.$inject = ['$http'];
//    function VimeoService($http) {
//        var endpoint = 'https://vimeo.com/api/oembed.json';
//
//        return {
//            oEmbed: function(params) {
//                return $http.jsonp(endpoint, {params: params})
//                        .then(function(res) {
//                            return res.data;
//                        });
//            }
//        };
//    }

})(window, window.angular);
