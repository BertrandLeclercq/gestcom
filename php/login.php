<?php

/**
 * Fonction de contrôle du login utilisateur.
 */

require_once "params.php";

// initialisation de l'objet qui sera retourné par la procédure
$ret = array(
	"error" 	=> false,  	// indique si une erreur est survenue
	"message" 	=> "", 		// message associé aux erreurs
	"profile" 	=> 0		// profil de l'utilisateur
	);

// création d'une instance PDO
$pdo = Params::instance()->pdo();
if ($pdo) {
	
	// la connexion à la base de données a réussi
	// lecture des paramètres du post HTTP au format JSON
	
	$inputs = file_get_contents("php://input");
	$jsonObject = json_decode($inputs);
	
	// requête de vérification du code utilisateur/mot de passe
	
	$query = $pdo->prepare(
		" SELECT uti_id_profil FROM mod_utilisateur " .
		" WHERE uti_code = :code " .
		" AND uti_mot_de_passe = PASSWORD(:password) "
		);

	$query->bindParam(":code", $jsonObject->userId);
	$query->bindParam(":password", $jsonObject->password);
	$query->execute();
	
	$row = $query->fetch(PDO::FETCH_ASSOC);
	
	if (empty($row)){
		$ret["error"] = true;
		$ret["message"] = _("Code utilisateur/mot de passe invalide");
	} else {
		// Le couple utilisateur/mot de passe est valable
    	$ret["profile"] = $row["uti_id_profil"];
	}
	// ne pas oublier de fermer la connexion à la base de données
	$pdo = null;

} else {
	$ret["error"] = true;
	$ret["message"] = _("Erreur de connexion à la base de données. Veuillez contacter votre administrateur.");
}

// Objet renvoyé au format JSON
echo json_encode($ret);

?>