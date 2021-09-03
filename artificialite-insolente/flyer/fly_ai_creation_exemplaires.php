#!/usr/bin/php -q
<?php

$OK = true;                                                 // Permet de tester le script "à blanc"

$exemplaires = 1;                                           // combien d'exemplaires réaliser ?
$chemin_dossier_sketch = "flyer_artificialite_insolente";   // repertoire du sketch
$nom_zine = "fly_ai";


/*
   Montage des flyers pour Artificialité Insolente
   Chaque page est créée en appelant deux fois le sketch processing
   Puis elles sont assemblées dans un second temps par un script bash
    en utilisant convert (imagemagick) sous forme de pages comprenant 2 images (format A4 paysage)
   Ces pages sont ensuite assemblées dans un unique fichier pdf
   Le pdf est à imprimer et massicoter

  août 2021 / pierre@lesporteslogiques.net
  PHP 7.0.33 / Debian 9.5 @ kirin

  Chaque exemplaire est caractérisé par un timestamp unique AAAA-MM-JJ_HH:MM:SS

  DEMARRER

  php ./fly_ai_creation_exemplaire.php --exemplaires=100 

  COMMENT IMPRIMER ?

  en paysage, recto-verso sur le bord court (très important pour que les pages soient dans l'ordre et dans le bon sens...)
  massicoter en suivant les traits de coupe
*/




/*
  Fonction pour récupérer des arguments au lancement du script
  sous la forme : php myscript.php --user=nobody --password=secret -p --access="host=127.0.0.1 port=456"
  d'après https://www.php.net/manual/fr/features.commandline.php#78093
*/

function arguments($argv) {
    $_ARG = array();
    foreach ($argv as $arg) {
        if (preg_match('#^-{1,2}([a-zA-Z0-9]*)=?(.*)$#', $arg, $matches)) {
            $key = $matches[1];
            switch ($matches[2]) {
                case '':
                case 'true':
                    $arg = true;
                    break;
                case 'false':
                    $arg = false;
                    break;
                default:
                    $arg = $matches[2];
            }
            $_ARG[$key] = $arg;
        } else {
            $_ARG['input'][] = $arg;
        }
    }
    return $_ARG;
}

function afficher_aide() {
    echo "exemple : php ./fly_ai_creation_exemplaire.php --exemplaires=100 --chemin=\"/chemin/vers/sketch\"" . PHP_EOL;
    echo "--exemplaires=n        : nombre d'exemplaires à fabriquer" . PHP_EOL;
    echo "--chemin=\"chemin\"      : chemin vers le sketch" . PHP_EOL;
}

function afficher_parametres() {
    global $exemplaires, $chemin;

    echo "exemplaires           : " . $exemplaires . PHP_EOL;
    echo "chemin du sketch      : " . $chemin . PHP_EOL;
}

// ***** Etape 0 - Traitement des arguments, initialisation des paramètres *****

$arguments = arguments($argv);

foreach ($arguments as $action => $valeur) {
    if ($action == "aide") {
        afficher_aide();
        exit();
    }
    if ($action == "help") {
        afficher_aide();
        exit();
    }
    if ($action == "exemplaires") {
        $exemplaires = $valeur;
    }
    if ($action == "dossier") {
        $chemin_dossier_sketch = $valeur;
    }
}

$timestamp = date("Ymd_His");
$chemin = getcwd() . "/" . $chemin_dossier_sketch;
$densite = 150;                           // densité en DPI pour la version print
$titre = $nom_zine;
$titre_complet_print = $titre . "_" . $timestamp . "_print_" . $densite . "dpi.pdf" ;
$usleep = 1000000;
$rep = getcwd(); 

afficher_parametres();

// *****************************************************************************
// ********************** Création des différents exemplaires ******************

// ********************* Etape 0 - Montage verso *******************************
// Le verso est un fichier scribus exporté en png à 600 dpi, il est assemblé en double

$cmd = "convert -page +0+0 verso.png -page +2835+0 verso.png -mosaic verso_double.png";
    echo $cmd . PHP_EOL;
    if ($OK)
        echo exec($cmd) . PHP_EOL;

for ($ex = 0; $ex < $exemplaires; $ex++) {


    // ********************* Etape 1 - Création des images *********************
    
    $cmd = "xvfb-run -s \"-ac -screen 0 1600x900x24\"  /home/emoc/processing-3.4/processing-java --sketch=\""
             . $chemin . "\" --run \"" . "gauche.png" .  "\" \"" . $rep . "/\" \"0\"";

    echo $cmd . PHP_EOL;
    if ($OK) {
        echo exec($cmd) . PHP_EOL;
        usleep($usleep);
    }
    
    $cmd = "xvfb-run -s \"-ac -screen 0 1600x900x24\"  /home/emoc/processing-3.4/processing-java --sketch=\""
             . $chemin . "\" --run \"" . "droite.png" .  "\" \"" . $rep . "/\" \"0\"";

    echo $cmd . PHP_EOL;
    if ($OK) {
        echo exec($cmd) . PHP_EOL;
        usleep($usleep);
    }


    // *************** Etape 2 - Conversions, montage des pages ****************

    $cmd = "convert -page +0+0 gauche.png -page +878+0 droite.png -mosaic page_" . $ex . ".png";
    echo $cmd . PHP_EOL;
    if ($OK)
        echo exec($cmd) . PHP_EOL;
        
    // *************** Etape 3 - Effacement des fichiers temporaires ***********

    usleep($usleep);

    $cmd = "rm gauche.png droite.png";
    echo $cmd . PHP_EOL;

    if ($OK)
        echo exec($cmd) . PHP_EOL;
}



// ****************** Etape 4 - Création du fichier pdf ********************
    
$cmd = "convert ";

for ($ex = 0; $ex < $exemplaires; $ex++) {    
    $cmd .= "page_" . $ex . ".png ";
    $cmd .= "verso_double.png ";
}

$cmd .= "-units PixelsPerInch -density " . $densite . " " . $titre_complet_print;

echo $cmd . PHP_EOL;
if ($OK)
    echo exec($cmd) . PHP_EOL;



// *************** Etape 5 - Effacer les fichiers temporaires ****************

usleep($usleep);

$cmd = "rm ";

for ($ex = 0; $ex < $exemplaires; $ex++) {    
    $cmd .= "page_" . $ex . ".png ";
}


echo $cmd . PHP_EOL;
if ($OK)
    echo exec($cmd) . PHP_EOL;
?>
