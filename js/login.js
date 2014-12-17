/* Connexion à la base de données */

// TODO: Voir ce qu'il faut faire lorsque l'utilisateur rafraichit avec F5
// TODO: Gestion d'une session pour préserver les paramètres associés à l'utilisateur
// TODO: Sécurisation de la connexion

app.controller('LoginController', ['$scope', '$http', function ($scope, $http) {
    
    $scope.message = "Veuillez saisir le code utilisateur et le mot de passe svp.";
    
	$scope.loginCheck = function (form) {

		if (!form.$valid)
		{
			$scope.message = "Veuillez corriger les erreurs svp.";
			return;
		} else {
			$scope.message = "Connexion en-cours...";
		}

		var request = $http({
		    method: "post",
		    // url: window.location.href + "php/login.php",
		    url: "php/login.php",
		    data: {
		        userId: $scope.userId,
		        password: $scope.password
			},
		    headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
		});

		request.success(function (data) {
			console.log(data);
			if (data.error) {
				$scope.message = data.message;
			} else {
				$scope.message = "Connexion réussie";
			}

		});
	}
}]);