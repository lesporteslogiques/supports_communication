class LigneImage {

  float hauteur;
  float largeur;
  float startx;
  float starty;
  PImage img;
  String imgname;

  int tranches_orig = 32;
  int tranches_dest = tranches_orig;
  float largeur_orig;
  float variation;

  float[] v1 = {1};
  float[] v2;

  LigneImage(float _h, float _l, float _x, float _y, String _imgname, int _t, float _v) {
    hauteur = _h;
    largeur = _l;
    startx  = _x;
    starty  = _y;
    img     = loadImage(_imgname);
    imgname = _imgname;
    tranches_orig = _t;
    largeur_orig = img.width;
    variation = _v;
  }

  void afficher() {
    //int starty = 0;

    //for (int iter = 0; iter < 16; iter ++) {
      tranches_dest = tranches_orig;
      // Calculer les valeurs pour chaque tranche
      while (tranches_dest >= 2) {
        //println(tranches_dest);
        v2 = doubler(v1, variation);
        //println(v2);
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
        int sh = int( img.height );
        int dx = int( startx ) + int( pixw );
        int dy = int( starty );
        int dw = int( largeur * v2[i] );
        int dh = int( hauteur );
        copy(img, sx, sy, sw, sh, dx, dy, dw, dh);
        pixw += dw;
        //println("bloucing "+imgname+" / "+sx+" "+sy+" "+sw+" "+sh+" / "+dx+" "+dy+" "+dw+" "+dh+" / "+pixw);
      }
/*
      starty += 78;
      v1 = new float[1];
      v1[0] = 1;
      v2 = new float[2];
*/
  //}
  }
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
}
