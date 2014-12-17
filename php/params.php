<?php

/**
 * Classe de gestion des paramètres de l'application.
 * Cette classe est un singleton permettant de gérer toutes les 
 * constantes d'accès à la base de données.
 * 
 * On utilise PDO pour les accès à la base de données.
 * 
 */
 class Params {

	// paramètres privés d'accès à la base de données
	// à modifier en fonction des paramètres du fournisseur d'accès

    private $dbServer 		= "127.0.0.1";
    private $dbUser			= "root";
    private $dbPassword 	= "";
    private $dbName			= "gestcom";

    private static $instance = null;

    // constructeur privé pour s'assurer qu'on ne puisse pas instancier cette 
    // classe avec new Params()
    private function __construct() {
    	// chargement des paramètres du serveur depuis un fichier de configuration
		if(@file_exists("config.ini")) {
			$config = parse_ini_file("config.ini", true);			
			// on a trouvé des paramètres de configuration sur le serveur
			$this->dbServer   = $config["database"]["server"];
			$this->dbUser     = $config["database"]["user"];
			$this->dbPassword = $config["database"]["password"];
			$this->dbName     = $config["database"]["name"];
		} 
		// si le fichier n'existe pas on utilise les paramètres par défaut (développement)
    }

    // fonction de création de l'instance unique de la classe
	public static function instance() {
		if(is_null(self::$instance)) {
			self::$instance = new Params();
		}
		return self::$instance;
	}    

	// fonction permettant de créer une instance PDO
	public function pdo()
	{
        try{
        	// création de l'instance pdo
        	$pdo = new PDO("mysql:host=$this->dbServer;dbname=$this->dbName", $this->dbUser, $this->dbPassword);
            return $pdo;
        }
        catch(PDOException $e)
        {
        	return null;
        }
	}
}

?>