angular
        //.module('app.rider', ['ngFileUpload', 'ngMessages', 'ui.router']);
        .module('app.rider', ['ngMessages', 'ui.router']);
//        .config(ConfigRouting)
//        .controller('RiderProfileController', RiderProfileController);

//ConfigRouting.$inject = ['$stateProvider'];
//function ConfigRouting($stateProvider) {
//    var baseUrl = TEMPLATE_URL + '/rider/partials/';
//    $stateProvider
//            .state('myriderprofile', {
//                url: '',
//                templateUrl: baseUrl + 'profile.html',
//                controller: 'RiderProfileController',
//                data: {
//                    requireLogin: true,
//                    pageLoader: true
//                }
//            })
//            .state('myriderprofile.edit', {
//                url: '/profile/edit',
//                views: {
//                    viewRiderProfile: {
//                        templateUrl: baseUrl + '/profile_edit.html',
//                    }
//                },
//                data: {
//                    requireLogin: true,
//                    pageLoader: false
//                }
//            })
//            .state('myriderprofile.view', {
//                url: '/profile',
//                views: {
//                    viewRiderProfile: {
//                        templateUrl: baseUrl + '/profile_view.html',
//                    }
//                },
//                data: {
//                    requireLogin: true
//                }
//            });
//
//}
//
//function RiderProfileController($scope, $stateParams, AuthenticationService, SharedData, RiderEntity, $state) {
//    // =========================================================================
//    // Properties
//    $scope.isCurrentUserProfile = false;
//    $scope.rider = false;
//    $scope.hasRiderProfile = hasRiderProfile;
//
//    $scope.$on("rider-selected", function(event, rider) {
//        if (rider !== null) {
//            $scope.rider = rider;
//        }
//        $state.go('myriderprofile.view').then(function() {
//            SharedData.pageLoader(false);
//        });
//    });
//
//    init();
//
//    // =========================================================================
//    // Init
//    function loadProfile(riderId) {
//        SharedData.pageLoader(true);
//        RiderEntity.profile({id: riderId}, function(rider) {
//            if (angular.isDefined(rider.id)) {
//                console.log("Profile loaded: ");
//                console.log(rider);
//                $scope.rider = rider;
//            }
//            else {
//                $scope.rider = {id: null};
//            }
//        }).$promise.finally(function() {
//            SharedData.pageLoader(false);
//        });
//    }
//
//    function init() {
//        loadProfile($stateParams.riderId ? $stateParams.riderId : null);
//    }
//
//    // =========================================================================
//    function hasRiderProfile() {
//        return $scope.rider !== false && $scope.rider.id !== null;
//    }
//    $scope.isEditabled = function() {
//        return !hasRiderProfile() || $scope.rider.user_id === AuthenticationService.getCurrentUser().id;
//    };
//}
