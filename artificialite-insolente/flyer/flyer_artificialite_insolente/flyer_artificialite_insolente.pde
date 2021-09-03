/*
  Mise en page du flyer pour Artificialite Insolente
 Quimper, Dour Ru, 20210824 / pierre@lesporteslogiques.net
 Processing 3.5.4 @ kirin / Debian Stretch 9.5
 */

String emplacement = ""; // à conserver tel quel, utilisé pour la publication
boolean TESTMODE = true; // à conserver tel quel, utilisé pour la publication

String fichier =  "fly_ai.png";  

// Chaque ligne peut être constituée d'une typo/image différente
// Certaines lignes sont doubles
int[] ligne = { 0, 0, 0, 0, 
                0, 0, 0, 0, 
                0, 0, 0, 0, 
                0, 0, 0, 0};

LigneImage[] lili;
int hmod = 1;       // Permet de doubler la hauteur des lignes doubles
int morceaux = 32;  // nombre de morceaux dans lequel est découpée chaque ligne

void setup() {
  size(877, 1240);
  init();
  lili = new LigneImage[ligne.length]; 

}

void draw() {
  background(255);
  traits_de_coupe();

  // Placer la première ligne d'info "Artificialité insolente"
  int l1 = int(random(0, 4));
  // Placer la 2e ligne              "Quimper 6-10 sept. 2021"
  int l2 = int(random(5, 12));
  // Placer la 3e ligne              ">>> les portes logiques"
  int l3 = int(random(13, 15));

  // Définir ces lignes particulières dans le tableau
  ligne[l1]   =  1;
  ligne[l1+1] = -1; // Rien sur cette ligne, la précédente est double
  ligne[l2]   =  2;
  ligne[l2+1] = -1;
  ligne[l3]   =  3;
  ligne[l3+1] = -1;

  for (int i=0; i < ligne.length; i++) {
    if (ligne[i] == 0) {
      ligne[i] = int(random(4, 6));
    }
  }

  //println(ligne);
  
  float deformation = random(60,100);
  println("deformation : " + deformation);
  
  float hligne = 944.0 / ligne.length;
  println("hligne : " + hligne);
  for (int i=0; i < ligne.length; i++) {
    //println("Afficher la ligne " + i + " / y : " + hligne * i);
    if (ligne[i] < 4) {
      morceaux = 8;
      hmod = 2;
    } else {
      morceaux = 32;
      hmod = 1;
    }
    if (ligne[i] != -1) {
      lili[i] = new LigneImage(64 * hmod, 734, 82, 142+(hligne * i), "texte"+ligne[i]+".png", morceaux, deformation );
      lili[i].afficher();
    }
    
  }

  if (!TESTMODE) {
    saveFrame(emplacement + fichier); 
    exit();
  }
  
  noLoop();
  saveFrame("test_" + millis() + ".png");
}

public void afficher_ligne(int l, PImage img) {
}

public void traits_de_coupe() {
  strokeWeight(1);
  stroke(0);
  // Verticales
  line(87, 0, 87, 148);
  line(790, 0, 790, 148);
  line(87, 1092, 87, 1240);
  line(790, 1092, 790, 1240);
  // Horizontales
  line(0, 148, 87, 148);
  line(790, 148, 877, 148);
  line(0, 1092, 87, 1092);
  line(790, 1092, 877, 1092);
}

public void empreinte() {
  fill(200);
  noStroke();
  rect(58, 118, 768, 1004);
}

// Fonction utilisée pour la publication à conserver telle quelle

void init() {
  if (args != null) {
    println(args.length); 
    for (int i = 0; i < args.length; i++) {
      println(args[i]);
    }
    fichier = args[0]; 
    emplacement = args[1]; 
    if (args[2].equals("0")) TESTMODE = false; 
    else TESTMODE = true; 
    println("fichier : " + fichier); 
    println("emplacement : " + emplacement); 
    println("testmode : " + TESTMODE); 
    println(fichier + " en cours");
  } else {
    println("args == null");
  }
}
