// Helper classes to store data globally

class Obj{
  float x;
  float y;
  float z;
  char type;
  Surface sur;
}

public class Color{
  float r;
  float g;
  float b;
}

public class Light{
  float x;
  float y;
  float z;
  float r;
  float g;
  float b;
}

public class Surface{
  float Cdr;
  float Cdg;
  float Cdb;
  float Car;
  float Cag;
  float Cab;
  float Csr;
  float Csg;
  float Csb;
  float P;
  float K;
}

public class Triangle extends Obj{
  PVector vec1;
  PVector vec2;
  PVector vec3;
  Triangle(PVector a, PVector b, PVector c){
    vec1 = a;
    vec2 = b;
    vec3 = c;
  }
}

public class Hit{
  PVector hitCoord;
  Obj hitObj;
  Surface sur;
  PVector snormal;
  float t;
}

public class Sphere extends Obj{
  float r;
  Sphere(float r, float x, float y, float z){
    this.x = x;
    this.y = y;
    this.z = z;
    this.r = r;
  }
}
