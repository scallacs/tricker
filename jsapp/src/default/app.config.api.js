angular.module('app.config.api', [])
        .config(ConfigInterceptor);
        
        
ConfigInterceptor.$inject = ['$httpProvider', '$locationProvider'];
function ConfigInterceptor($httpProvider, $locationProvider) {
    'use strict';
    $locationProvider.html5Mode(true);

    var interceptor = ['$rootScope', '$q', '$injector', '$timeout',
        function(scope, $q, $injector, $timeout) {
            var loginModal, $http, $state;

            // this trick must be done so that we don't receive
            // `Uncaught Error: [$injector:cdep] Circular dependency found`
            $timeout(function() {
                loginModal = $injector.get('loginModal');
                $http = $injector.get('$http');
                $state = $injector.get('$state');
            });

            function requestError(rejection) {
                console.log(rejection);
                return $q.reject(rejection);
            }

            function responseError(rejection) {
                console.log(rejection);
                var status = rejection.status;
                var deferred = $q.defer();
                if (status === 401) {
                    $injector.get('AuthenticationService').logout();
                    loginModal.open()
                            .result
                            .then(function() {
                                return $http(rejection.config);
                            })
                            .catch(function() {
//                                $state.go('home');
                                deferred.reject(rejection);
                            });
//                    alert('ok');
                }
//                else if (status === 404){
//                }
                else if (status >= 500) {
                    alert('This functinality is not available for now, try again later.');
                    return;
                }
                return $q.reject(rejection);
            }

            return {
                request: function(config) {
                    return config;
                },
                responseError: responseError,
                requestError: requestError,
                response: function(response) {
                    return response;
                }
            };
        }];
    $httpProvider.interceptors.push(interceptor);
}