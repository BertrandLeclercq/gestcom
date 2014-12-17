/* base de données MySQL gestcom, interclassement ut8_general_ci, moteur innoDb */

/* table principales */
DROP TABLE IF EXISTS mod_ligne;
DROP TABLE IF EXISTS mod_commande;
DROP TABLE IF EXISTS mod_client;
DROP TABLE IF EXISTS mod_adresse;
DROP TABLE IF EXISTS mod_article;
DROP TABLE IF EXISTS mod_emplacement;
DROP TABLE IF EXISTS mod_utilisateur;

/* table secondaires de référence */
DROP TABLE IF EXISTS mod_unite;
DROP TABLE IF EXISTS mod_tva;
DROP TABLE IF EXISTS mod_paiement;
DROP TABLE IF EXISTS mod_pays;
DROP TABLE IF EXISTS mod_statut;
DROP TABLE IF EXISTS mod_profil;

/* table des articles */
CREATE TABLE mod_article (
    /* identifiant de l'article */
    art_id INT NOT NULL auto_increment,
    /* désignation de l'article */
    art_designation VARCHAR(200) NOT NULL,
    /* référence unique de l'article */
    art_reference VARCHAR(50) NOT NULL UNIQUE,
    /* identifiant de l'emplacement de l'article */
    art_id_emplacement INT NOT NULL,
    /* identifiant de l'unité de quantité */
    art_id_unite INT NOT NULL DEFAULT 1,
    /* quantité disponible en stock */
    art_quantite_disponible FLOAT NOT NULL,
    /* quantité en-cours d'approvisionnement */
    art_quantite_appro FLOAT NOT NULL DEFAULT 0.0,
    /* délai d'approvisionnement en nombre de jours */
    art_delai_appro INT NOT NULL,
    /* identifiant taux de tva applicable à l'article */
    art_id_taux_tva INT NOT NULL DEFAULT 2,
    /* prix unitaire hors taxe de l'article */
    art_prix_unitaire_ht FLOAT NOT NULL DEFAULT 0.0,

    KEY idx_art_id_emplacement (art_id_emplacement),
    KEY idx_art_id_unite (art_id_unite), 
    KEY idx_art_id_taux_tva (art_id_taux_tva),
    PRIMARY KEY (art_id)
);


/* table des unite */
CREATE TABLE mod_unite (
    /* identifiant de l'unité */
    uni_id INT NOT NULL auto_increment,
    /* désignation de l'unité */
    uni_designation VARCHAR(100) NOT NULL,

    PRIMARY KEY (uni_id)
);

/* table des taux de tva */
CREATE TABLE mod_tva (
    /* identifiant du taux de tva */
    tva_id INT NOT NULL auto_increment,
    /* désignation du taux de tva */
    tva_designation VARCHAR(100) NOT NULL,
    /* taux de tva */
    tva_taux FLOAT NOT NULL DEFAULT 0.0,

    PRIMARY KEY (tva_id)
);

/* table des clients */
CREATE TABLE mod_client (
    /* identifiant du client */
    cli_id INT NOT NULL auto_increment,
    /* nom du client */
    cli_nom VARCHAR(100) NOT NULL,
    /* raison sociale du client, facultatif */
    cli_raison_sociale VARCHAR(100),
    /* identifiant de l'adresse de facturation */
    cli_id_adresse_facturation INT NOT NULL,
    /* identifiant de l'adresse de livraison */
    cli_id_adresse_livraison INT NOT NULL,
    /* identifiant du moyen de paiement */
    cli_id_paiement INT NOT NULL,
    /* pourcentage de remise-ristourne accordée au client */
    cli_remise FLOAT NOT NULL DEFAULT 0.0,

    KEY idx_cli_id_adresse_facturation (cli_id_adresse_facturation),
    KEY idx_cli_id_adresse_livraison (cli_id_adresse_livraison),
    KEY idx_cli_id_paiement (cli_id_paiement),
    PRIMARY KEY (cli_id)
);


/* table des adresses */
CREATE TABLE mod_adresse (
    /* identifiant de l'adresse */
    adr_id INT NOT NULL auto_increment,
    /* ligne 1 de l'adresse */
    adr_adresse_1 VARCHAR(100) NOT NULL,
    /* ligne 2 de l'adresse */
    adr_adresse_2 VARCHAR(100),
    /* ligne 3 de l'adresse */
    adr_adresse_3 VARCHAR(100),
    /* ville */
    adr_ville VARCHAR(180) NOT NULL,
    /* code postal */
    adr_code_postal VARCHAR(10) NOT NULL,
    /* identifiant du pays */
    adr_id_pays INT NOT NULL,

    KEY idx_adr_id_pays (adr_id_pays),
    PRIMARY KEY (adr_id)
);

/* table des pays */
/* voir http://www.geonames.org/ */
CREATE TABLE mod_pays (
    /* identifiant du pays */
    pay_id INT NOT NULL auto_increment,
    /* code iso 3166 du pays */
    pay_code_iso VARCHAR(2) NOT NULL UNIQUE,
    /* designation du pays */
    pay_designation VARCHAR(50) NOT NULL,

    PRIMARY KEY (pay_id)
);

/* table des codes postaux */
/* voir http://www.geonames.org/ */

/* table des moyens de paiement */
CREATE TABLE mod_paiement (
    /* identifiant du moyen de paiement */
    pai_id INT NOT NULL auto_increment,
    /* désignation du moyen de paiement */
    pai_designation VARCHAR(100) NOT NULL,
    PRIMARY KEY (pai_id)
);


/* table des commandes */
CREATE TABLE mod_commande (
    /* identifiant de la commande */
    com_id INT NOT NULL auto_increment,
    /* identifiant du client de la commande */
    com_id_client INT NOT NULL,
    /* rabais accordée à la commande en pourcentage du montant hors taxe */
    com_rabais FLOAT NOT NULL DEFAULT 0.0,
    /* date d'enregistrement de la commande */
    com_date_commande date NOT NULL,
    /* date de livraison de la commande */
    com_date_livraison date NOT NULL,
    /* statut de la commande */
    com_id_statut INT NOT NULL,

    KEY idx_com_id_client (com_id_client),
    KEY idx_com_id_statut (com_id_statut),
    PRIMARY KEY (com_id)
);

/* table des lignes de commandes */
CREATE TABLE mod_ligne (
    /* identifiant de la ligne de commande */
    lig_id INT NOT NULL auto_increment,
    /* identifiant de la commande à laquelle cette ligne appartient */
    lig_id_commande INT NOT NULL,
    /* identifiant de l'article de la ligne de commande */
    lig_id_article INT NOT NULL,
    /* quantité commandée */
    lig_quantite FLOAT NOT NULL DEFAULT 0.0,
    /* date de disponibilité de l'article */
    lig_date_disponibilite date NOT NULL,

    KEY idx_lig_id_commande (lig_id_commande),
    KEY idx_lig_id_article (lig_id_article),
    PRIMARY KEY (lig_id)
);


/* table des statuts de commande */
CREATE TABLE mod_statut (
    /* identiifant du statut */
    sta_id INT NOT NULL auto_increment,
    /* désignation du statut */
    sta_designation VARCHAR(100) NOT NULL,

    PRIMARY KEY (sta_id)
);

/* table des emplacements de stock */
CREATE TABLE mod_emplacement (
    /* identifiant de l'emplacement */
    emp_id INT NOT NULL auto_increment,
    /* désignation de l'emplacement */
    emp_designation VARCHAR(100) NOT NULL,
    /* gestionnaire du stock */
    emp_id_utilisateur INT NOT NULL,

    KEY idx_emp_id_utilisateur (emp_id_utilisateur),
    PRIMARY KEY (emp_id)
);

/* table des utilisateurs */
CREATE TABLE mod_utilisateur (
    /* identifiant de l'utilisateur */
    uti_id INT NOT NULL auto_increment,
    /* code de l'utilisateur, sensible à la casse avec utf8_bin */
    uti_code VARCHAR(50) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL UNIQUE,
    /* adresse mail de l'utilisateur */
    uti_mail VARCHAR(255) NOT NULL,
    /* mot de passe de l'utilisateur */
    uti_mot_de_passe VARCHAR(50) NOT NULL,
    /* identifiant du profil de l'utilisateur */
    uti_id_profil INT NOT NULL,

    KEY idx_uti_id_profil (uti_id_profil),
    PRIMARY KEY (uti_id)
);

/* table des profils */
CREATE TABLE mod_profil (
    /* identifiant du profil */
    pro_id INT NOT NULL auto_increment,
    /* désignation du profil */
    pro_designation VARCHAR(100) NOT NULL,

    PRIMARY KEY (pro_id)
);

/* contraintes sur les clés étrangères */

ALTER TABLE mod_article 
    add CONSTRAINT fk_art_id_emplacement
    FOREIGN KEY (art_id_emplacement) 
    REFERENCES mod_emplacement (emp_id);

ALTER TABLE mod_article 
    add CONSTRAINT fk_art_id_unite
    FOREIGN KEY (art_id_unite) 
    REFERENCES mod_unite (uni_id);

ALTER TABLE mod_article 
    add CONSTRAINT fk_art_id_taux_tva
    FOREIGN KEY (art_id_taux_tva) 
    REFERENCES mod_tva (tva_id);

ALTER TABLE mod_client 
    add CONSTRAINT fk_cli_id_adresse_facturation
    FOREIGN KEY (cli_id_adresse_facturation) 
    REFERENCES mod_adresse (adr_id);

ALTER TABLE mod_client 
    add CONSTRAINT fk_cli_id_adresse_livraison
    FOREIGN KEY (cli_id_adresse_livraison) 
    REFERENCES mod_adresse (adr_id);

ALTER TABLE mod_client 
    add CONSTRAINT fk_cli_id_paiement
    FOREIGN KEY (cli_id_paiement) 
    REFERENCES mod_paiement (pai_id);

ALTER TABLE mod_adresse 
    add CONSTRAINT fk_adr_id_pays
    FOREIGN KEY (adr_id_pays) 
    REFERENCES mod_pays (pay_id);

ALTER TABLE mod_commande 
    add CONSTRAINT fk_com_id_client 
    FOREIGN KEY (com_id_client) 
    REFERENCES mod_client (cli_id);

ALTER TABLE mod_commande 
    add CONSTRAINT fk_com_id_statut 
    FOREIGN KEY (com_id_statut) 
    REFERENCES mod_statut (sta_id);

ALTER TABLE mod_ligne
    add CONSTRAINT fk_lig_id_commande 
    FOREIGN KEY (lig_id_commande) 
    REFERENCES mod_commande (com_id);

ALTER TABLE mod_ligne
    add CONSTRAINT fk_lig_id_article 
    FOREIGN KEY (lig_id_article) 
    REFERENCES mod_article (art_id);

ALTER TABLE mod_utilisateur
    add CONSTRAINT fk_uti_id_profil
    FOREIGN KEY (uti_id_profil) 
    REFERENCES mod_profil (pro_id);

ALTER TABLE mod_emplacement
    add CONSTRAINT fk_emp_id_utilisateur
    FOREIGN KEY (emp_id_utilisateur) 
    REFERENCES mod_utilisateur (uti_id);
