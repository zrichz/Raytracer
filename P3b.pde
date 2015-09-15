/*
  Monet Tomioka CS 3451 Project 3b
  3/13/2015
*/

String gCurrentFile = new String("i1.cli"); // A global variable for holding current active file name.

float fov;
Color bg;
ArrayList<Light> lightlist;
ArrayList<Sphere> spherelist;
Surface s;
ArrayList<Triangle> trianglelist;
PVector first;
PVector second;
float recursionDepth;
float epsilon;

void keyPressed() {
  switch(key) {
    case '1':  gCurrentFile = new String("i1.cli"); interpreter(); break;
    case '2':  gCurrentFile = new String("i2.cli"); interpreter(); break;
    case '3':  gCurrentFile = new String("i3.cli"); interpreter(); break;
    case '4':  gCurrentFile = new String("i4.cli"); interpreter(); break;
    case '5':  gCurrentFile = new String("i5.cli"); interpreter(); break;
    case '6':  gCurrentFile = new String("i6.cli"); interpreter(); break;
    case '7':  gCurrentFile = new String("i7.cli"); interpreter(); break;
    case '8':  gCurrentFile = new String("i8.cli"); interpreter(); break;
    case '9':  gCurrentFile = new String("i9.cli"); interpreter(); break;
    case '0':  gCurrentFile = new String("i0.cli"); interpreter(); break;
  }
}

float get_float(String str) { return float(str); }

void interpreter() {
  reset_scene();
  spherelist = new ArrayList<Sphere>();
  lightlist = new ArrayList<Light>();
  trianglelist = new ArrayList<Triangle>();
  recursionDepth = 0;
  epsilon = 0.0001;
  println("Parsing '" + gCurrentFile + "'");
  String str[] = loadStrings(gCurrentFile);
  if (str == null) println("Error! Failed to read the file.");
  for (int i=0; i<str.length; i++) {
    
    String[] token = splitTokens(str[i], " "); // Get a line and parse tokens.
    if (token.length == 0) continue; // Skip blank line.
    
    if (token[0].equals("fov")) {
      fov = get_float(token[1]);
    }
    else if (token[0].equals("background")) {
      bg = new Color();
      bg.r =get_float(token[1]);
      bg.g =get_float(token[2]);
      bg.b =get_float(token[3]);
    }
    else if (token[0].equals("light")) {
      Light l = new Light();
      l.x =get_float(token[1]);
      l.y =get_float(token[2]);
      l.z =get_float(token[3]);
      l.r =get_float(token[4]);
      l.g =get_float(token[5]);
      l.b =get_float(token[6]);
      lightlist.add(l);
    }
    else if (token[0].equals("surface")) {
      s = new Surface();
      s.Cdr =get_float(token[1]);
      s.Cdg =get_float(token[2]);
      s.Cdb =get_float(token[3]);
      s.Car =get_float(token[4]);
      s.Cag =get_float(token[5]);
      s.Cab =get_float(token[6]);
      s.Csr =get_float(token[7]);
      s.Csg =get_float(token[8]);
      s.Csb =get_float(token[9]);
      s.P =get_float(token[10]);
      s.K =get_float(token[11]);
    }    
    else if (token[0].equals("sphere")) {
      Sphere sp = new Sphere(get_float(token[1]), get_float(token[2]), get_float(token[3]), get_float(token[4]));
      sp.type = 'h';
      sp.sur = s;
      spherelist.add(sp);
    }
    else if (token[0].equals("begin")) {
      first = null;
      second = null;
    }
    else if (token[0].equals("vertex")) {
      if(first == null && second == null) first = new PVector(get_float(token[1]), get_float(token[2]), get_float(token[3]));
      else if (first != null && second == null) second = new PVector(get_float(token[1]), get_float(token[2]), get_float(token[3]));
      else{
        Triangle t = new Triangle(first, second, new PVector( get_float(token[1]), get_float(token[2]), get_float(token[3]) ));
        t.sur = s;
        trianglelist.add(t);
      }
    }
    else if (token[0].equals("end")) {
      first = null;
      second = null;
    }
    else if (token[0].equals("color")) {
      PVector c = new PVector(get_float(token[1]), get_float(token[2]), get_float(token[3]));
    }
    else if (token[0].equals("write")) {
      draw_scene();
      println("Saving image to '" + token[1]+"'");
      save(token[1]);
    }
  }  
}

void setup() {
  reset_scene();
  size(300, 300);
  noStroke();
  colorMode(RGB, 1.0);
  background(0, 0, 0);
  interpreter();
}

void reset_scene() {
  //reset global scene variables
  bg = null;
}


//=============================================================================================================
//=============================================================================================================

void draw_scene() {
  loadPixels(); //load the pixel buffer
  color col = color(0,0,0); //default black pixel
  for(int y = 0; y < height; y++) {
    for(int x = 0; x < width; x++) {
      //cast the eye ray
      recursionDepth = 0;
      float k = tan(radians(fov)/2);
      float xmapped = ((x-(width/2))*((2*k)/width));
      float ymapped = -((y-(height/2))*((2*k)/height));
      PVector shootres = shading(xmapped,ymapped,-1, 0,0,0);  //see if it intersects; returns the object & intersection point
      col = color(shootres.x, shootres.y, shootres.z);
      pixels[y*width + x] = col;
    }
  }
  updatePixels(); //fill the screne with your updated pixel buffer
}


//=============================================================================================================
//=============================================================================================================


/*
  For each object, see if the incoming ray intersects it
  (x,y,z) = direction
  (d,e,f) = origin of ray
*/
Hit shootRay(float dx, float dy, float dz, float d, float e, float f){
  Hit answer = new Hit();
  PVector closestsph = null;  //sphere loop starts here
  Sphere sph = null;
  for(int i = 0; i < spherelist.size(); i++){  //for each sphere in spherelist
    Sphere stuff = spherelist.get(i);
    float a = (dx*dx) + (dy*dy) + (dz*dz);
    float b = (2*dx*(d-stuff.x)) + (2*dy*(e-stuff.y)) + (2*dz*(f-stuff.z));
    float c = (stuff.x*stuff.x) + (stuff.y*stuff.y) + (stuff.z*stuff.z) + (d*d) + (e*e) + (f*f) - (2*((stuff.x*d)+(stuff.y*e)+(stuff.z*f))) - (stuff.r*stuff.r);
    float quadres = quad(a,b,c);  //returns t value; how far the object/intersection is
    if (quadres > 0) {
      if(closestsph == null){
        closestsph = new PVector();
        closestsph.x = dx * quadres + d;
        closestsph.y = dy * quadres + e;
        closestsph.z = dz * quadres + f;
        answer.t = quadres;
        sph = stuff;
      }
      else if ((dz*quadres+f) > closestsph.z) {
        closestsph.x = dx * quadres + d;
        closestsph.y = dy * quadres + e;
        closestsph.z = dz * quadres + f;
        answer.t = quadres;
        sph = stuff;
      }
    }
  } //ends loop for each sphere
  
  PVector closesttr = null;  //triangle loop starts here
  Triangle tr = null;
  for(int i = 0; i < trianglelist.size(); i++){  //for each triangle in trianglelist
    Triangle tri = trianglelist.get(i);
    //get surface normal of plane
    PVector e1 = PVector.sub(tri.vec2, tri.vec1);
    PVector e2 = PVector.sub(tri.vec3, tri.vec1);
    PVector s = new PVector(d,e,f);
    PVector n = e1.cross(e2);
    n.normalize();
    //ray in plane intersection
    PVector qs = PVector.sub(s, tri.vec2);  //S-Q; Q is a point on plane (used vector 2 from triangle)
    PVector qsneg = PVector.mult(qs, -1);
    PVector dir = new PVector(dx, dy, dz);  //dx = x1 - x0;
    float res = PVector.dot(qsneg, n)/PVector.dot(dir, n);  //t value
    float xres = dx * res + d;
    float yres = dy * res + e;
    float zres = dz * res + f;
    if(res >= 0){
      PVector mappedpix = new PVector(xres, yres, zres);
      //if the intersection point is inside triangle
      if (sameSide(mappedpix, tri.vec1, tri.vec2, tri.vec3) && sameSide(mappedpix, tri.vec2, tri.vec1, tri.vec3) && sameSide(mappedpix, tri.vec3, tri.vec1, tri.vec2)){
        if(closesttr == null){
          closesttr = new PVector();
          closesttr.x = xres;
          closesttr.y = yres;
          closesttr.z = zres;
          tr = tri;
          answer.t = res;
        }
        else if(zres > closesttr.z){
          closesttr.x = xres;
          closesttr.y = yres;
          closesttr.z = zres;
          tr = tri;
          answer.t = res;
        }
      }
    }
  } //ends loop through all triangles
  
  //check between closest sphere and closest triangle
  if(closestsph != null){
    if(closesttr != null){
      if(closestsph.z > closesttr.z){
        PVector spherecenter = new PVector(sph.x, sph.y, sph.z);
        PVector norm = PVector.sub(closestsph, spherecenter);
        norm.normalize();
        answer.snormal = norm;
        answer.hitObj = sph;  //object
        answer.hitCoord = closestsph;  //intersection point
      }
      else{
        PVector e1 = PVector.sub(tr.vec2, tr.vec1);
        PVector e2 = PVector.sub(tr.vec3, tr.vec1);
        PVector vnormal = e2.cross(e1);
        vnormal.normalize();
        answer.snormal = vnormal;
        answer.hitObj = tr;
        answer.hitCoord = closesttr;
      }
    }
    else{
      PVector spherecenter = new PVector(sph.x, sph.y, sph.z);
      PVector norm = PVector.sub(closestsph, spherecenter);
      norm.normalize();
      answer.snormal = norm;
      answer.hitObj = sph;  //object
      answer.hitCoord = closestsph;  //intersection point
    }
  }
  else if(closesttr != null){
    PVector e1 = PVector.sub(tr.vec2, tr.vec1);
    PVector e2 = PVector.sub(tr.vec3, tr.vec1);
    PVector vnormal = e2.cross(e1);
    vnormal.normalize();
    answer.snormal = vnormal;
    answer.hitObj = tr;
    answer.hitCoord = closesttr;
  }
  return answer;
}


boolean sameSide(PVector p1, PVector p2, PVector a, PVector b){
  PVector cp1 = (PVector.sub(b,a)).cross(PVector.sub(p1,a));
  PVector cp2 = (PVector.sub(b,a)).cross(PVector.sub(p2,a));
  if(PVector.dot(cp1,cp2) >= 0) return true;
  else return false;
}


//=============================================================================================================
//=============================================================================================================

PVector shading(float x, float y, float z, float d, float e, float f){
  Hit answer = shootRay(x,y,z, d,e,f);
  if(answer.hitObj == null){
    if (bg != null)  return new PVector(bg.r, bg.g, bg.b);
    else return new PVector(0,0,0);
  }
  PVector hitpoint = answer.hitCoord;  //answer.hitCoord = intersection point
  PVector result = new PVector(answer.hitObj.sur.Car, answer.hitObj.sur.Cag, answer.hitObj.sur.Cab);  //setting result as ambient
  PVector eye = PVector.mult(hitpoint, -1);
  PVector stuff = PVector.mult(answer.snormal, epsilon);  //normal * epsilon
  eye.normalize();
  for (int i = 0; i < lightlist.size(); i++){
    //diffuse: for each light source, calculate normal2: light - intersection point
    PVector light = new PVector(lightlist.get(i).x, lightlist.get(i).y, lightlist.get(i).z);
    PVector lightsource = PVector.sub(light, hitpoint);
    float lightdist = lightsource.mag();
    lightsource.normalize();
    float dotprod = PVector.dot(lightsource, answer.snormal);
    float maxi = max(dotprod, 0);
    
    //phong, using reflection
    PVector twoNLN = PVector.mult(answer.snormal, dotprod*2);
    PVector refl = PVector.sub(twoNLN, lightsource);
    float relfdot = (float)Math.pow(max(0.0, PVector.dot(eye, refl)), answer.hitObj.sur.P);
    
    //shadows
    Hit shadowanswer = shootRay(lightsource.x, lightsource.y, lightsource.z, hitpoint.x + stuff.x, hitpoint.y + stuff.y, hitpoint.z + stuff.z);
    if(!(shadowanswer.hitObj != null && shadowanswer.t > epsilon && shadowanswer.t < lightdist)){
      result.x += ((lightlist.get(i).r * maxi * answer.hitObj.sur.Cdr) + (lightlist.get(i).r * relfdot * answer.hitObj.sur.Csr));
      result.y += ((lightlist.get(i).g * maxi * answer.hitObj.sur.Cdg) + (lightlist.get(i).g * relfdot * answer.hitObj.sur.Csg));
      result.z += ((lightlist.get(i).b * maxi * answer.hitObj.sur.Cdb) + (lightlist.get(i).b * relfdot * answer.hitObj.sur.Csb));
    }
  }
  
  //recursion
  if(answer.hitObj.sur.K > 0 && recursionDepth < 8){
    recursionDepth++;
    //finding reflection ray
    PVector ray = new PVector(x,y,z);
    PVector nray = PVector.mult(ray, -1);
    nray.normalize();
    float twoNL = PVector.dot(answer.snormal, nray)*2;
    PVector twoNLN = PVector.mult(answer.snormal, twoNL);
    PVector refl = PVector.sub(twoNLN, nray);
    //added hitpoint + epsilon*normal
    PVector reflection = shading(refl.x, refl.y, refl.z, hitpoint.x+stuff.x, hitpoint.y+stuff.y, hitpoint.z+stuff.z);
    result.x += (answer.hitObj.sur.K * reflection.x);
    result.y += (answer.hitObj.sur.K * reflection.y);
    result.z += (answer.hitObj.sur.K * reflection.z);
  }
  return result;
}


/*
  Computes quadratic equation with float a, b, c
  returns an array:
    res[0] = -b + ...
    res[1] = -b - ...
    res[2] = -1 if imaginary components added/subtracted;
              some positive number if there's only 1 solution
*/
float quad(float a, float b, float c){
  float res = 0;
  float d = (b*b) - (4.0*a*c);
  if (d < 0) res = -1;
  else if (d == 0) res = -b / (2.0*a);
  else if (d >0) res = min((float)((-b-Math.sqrt(d))/(2.0*a)), (float)((-b+Math.sqrt(d))/(2.0*a)));
  return res;
}

void draw() {
  //nothing iterative in this project
}
