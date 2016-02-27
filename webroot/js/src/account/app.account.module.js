angular.module('app.account', [
    'ngResource',
    'ui.router',
    'ngMessages',
    'satellizer',
    'app.config',
    'app.core',
    'shared.form'])
        .config(ConfigRoute)
        .config(ConfigSocialApi)
        .service('loginModal', loginModal)
        .controller('LoginModalController', LoginModalController)
        .controller('SettingsController', SettingsController)
        .controller('UserLoginController', UserLoginController)
        .controller('SignupController', SignupController);

ConfigRoute.$inject = ['$stateProvider'];
function ConfigRoute($stateProvider) {
    $stateProvider
            .state('login', {
                url: '/login',
                templateUrl: 'js/src/account/partials/login.html',
                controller: 'UserLoginController',
                data: {
                    requireLogin: false
                }
            })
            .state('signup', {
                url: '/signup',
                templateUrl: 'js/src/account/partials/signup.html',
                controller: 'SignupController',
                data: {
                    requireLogin: false
                }
            })
            .state('settings', {
                url: '/settings',
                templateUrl: 'js/src/account/partials/settings.html',
                controller: 'SettingsController',
                data: {
                    requireLogin: true
                }
            });
}

ConfigSocialApi.$inject = ['$authProvider', 'Config'];
function ConfigSocialApi($authProvider, Config) {
    $authProvider.facebook({
        clientId: Config.api.facebook,
        url: API_BASE_URL + '/users/facebook_login.json',
        redirectUri: API_BASE_URL
    });

    $authProvider.withCredentials = true;
    $authProvider.tokenRoot = null;
    $authProvider.cordova = false;
    $authProvider.baseUrl = '/';
//    $authProvider.loginUrl = API_BASE_URL + 'users/login';
//    $authProvider.signupUrl = API_BASE_URL + 'users/signup';
//    $authProvider.unlinkUrl = API_BASE_URL + 'users/unlink';
    $authProvider.tokenName = 'token';
    $authProvider.tokenPrefix = '';//'satellizer';
    $authProvider.authHeader = 'Authorization';
    $authProvider.authToken = 'Bearer';
    $authProvider.storageType = 'localStorage';
//    $authProvider.google({
//        clientId: 'Google Client ID'
//    });
//    $authProvider.instagram({
//        clientId: 'Instagram Client ID'
//    });
}

SettingsController.$inject = ['$scope', 'AuthenticationService', 'UserEntity']
function SettingsController($scope, AuthenticationService, UserEntity) {

    $scope.data = {};
    $scope.password = '';
    $scope.removeAccount = removeAccount;
    $scope.isFormDeleteAccountLoading = false;
    $scope.isSociaLogin = isSocialLogin;
    $scope.data.user = AuthenticationService.getCurrentUser();

    function isSocialLogin() {
        return AuthenticationService.getCurrentUser().provider !== null;
    }

    function removeAccount(password) {
        $scope.isFormDeleteAccountLoading = true;
        $scope.formDeleteAccount.submit(UserEntity.removeAccount({password: password}).$promise).then(function(response) {
            if (response.success) {
                $scope.$parent.logout();
            }
        });
    }
}

UserLoginController.$inject = ['$scope', '$state'];
function UserLoginController($scope, $state) {

    $scope.$on("user-login-success", function() {
        console.log("On user-login-success");
        $state.go('home');
    });

}

SignupController.$inject = ['$scope', '$state', 'AuthenticationService']
function SignupController($scope, $state, AuthenticationService) {

    $scope.signup = signup;

    function signup(data) {
        var promise = $scope.signupForm.submit(AuthenticationService.signup(data));
        promise.then(successCallback);

        function successCallback(response) {
            if (response.success) {
                $state.go('home');
            }
        }
    }
}

loginModal.$inject = ['$uibModal'];
function loginModal($uibModal) {
    var instance = null;

    return {
        isset: function(){ return instance !== null; },
        open: function() {
            if (instance !== null) {
                return instance;
            }
            console.log("LoginModal: Open");
            instance = $uibModal.open({
                templateUrl: 'js/src/account/partials/login_modal.html',
                controller: 'LoginModalController',
                controllerAs: 'LoginModalController'
            });
            return instance;
        },
        dismiss: function() {
            if (instance !== null) {
                console.log("LoginModal: Closing");
                var copy = instance;
                instance = null;
                copy.dismiss();
            }
        }
    };
}

LoginModalController.$inject = ['$scope'];
function LoginModalController($scope) {

    this.cancel = $scope.$dismiss;

    $scope.$on("user-login-success", function(event) {
        console.log("Modal on user-login-success");
        $scope.$close();
    });

}