/*
  Déformer une image par tranche
 Quimper, Dour Ru, 20210823 / pierre@lesporteslogiques.net
 Processing 3.5.4 @ kirin / Debian Stretch 9.5
 */

PImage image_orig;
int tranches_orig = 32; // toujours un multiple de 2
int tranches_dest = tranches_orig;
float largeur_dest = 1200;
float largeur_orig;
float rapport;
int frame = 0;

float[] v1 = {1};
float[] v2;

void setup() {
  size(640, 100);
  background(255);
  image_orig = loadImage("texte.png");
  largeur_orig = image_orig.width;
  rapport = largeur_dest / largeur_orig;
  frameRate(1);
}

void draw() {
  
  int starty = 0;

  for (int iter = 0; iter < 16; iter ++) {
    tranches_dest = tranches_orig;
    // Calculer les valeurs pour chaque tranche
    while (tranches_dest >= 2) {
      println(tranches_dest);
      v2 = doubler(v1, 100);
      println(v2);
      if (tranches_dest > 2) {
        v1 = new float[v1.length * 2];
        arrayCopy(v2, v1);
        v2 = new float[v2.length * 2];
      }
      tranches_dest /= 2;
    }

    // Afficher avec ces valeurs
    float pixw = 0;

    for (int i = 0; i < v2.length; i++) {
      int sx = int( i * (largeur_orig / tranches_orig) );
      int sy = 0;
      int sw = int( largeur_orig / tranches_orig );
      int sh = image_orig.height;
      int dx = int( pixw );
      int dy = 0 + starty;
      int dw = int( image_orig.width * v2[i] );
      int dh = image_orig.height;
      copy(image_orig, sx, sy, sw, sh, dx, dy, dw, dh);
      pixw += dw;
      println("bloucing "+sx+" "+sy+" "+sw+" "+sh+" / "+dx+" "+dy+" "+dw+" "+dh+" / "+pixw);
    }

    starty += 50;
    v1 = new float[1];
    v1[0] = 1;
    v2 = new float[2];
  }
  //copy(image_orig, 0, 0, 100, 200, 0, 200, 100, 200);
  saveFrame("anim_ai_##.png");

  frame++;
  if (frame >= 16) noLoop();
}

/**
 * Prendre un tableau de valeurs et retourner un tableau du double des valeurs
 * 
 * @param valeurs    tableau des valeurs à traiter
 * @param variation  une valeur entre 0 et 100%
 */
public float[] doubler(float[] valeurs, float variation) {
  int taille = valeurs.length * 2;
  int index = 0;
  float[] valeurs_new = new float[taille];
  for (float v : valeurs) {
    float var = 0.5 + (0.5 * (random(variation) / 100 - 0.5));
    valeurs_new[index] = v * var;
    valeurs_new[index+1] = v * (1 - var);
    index += 2;
  }
  return valeurs_new;
}
