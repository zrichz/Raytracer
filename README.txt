Ray Tracer in Processing
Author: Monet Tomioka
Date: 2/1/2016

This is a ray tracer written in the Processing language, a Java-based open source language with IDE that excels in producing graphics. Download the Processing language & IDE at their website (https://www.processing.org).

This ray tracer reads .cli files in /data folder. "cli" stands for "command language interpreter". Below is the grammar for the .cli files made by professor Greg Turk of Georgia Institute of Technology. Sample .cli files and their outputs (.png images) are provided.

fov angle: Specifies the field of view (in degrees) for a perspective projection. The viewer's eye position  is assumed to be at the origin and to be looking down the negative z-axis (giving us a right-handed coordinate system). The y-axis points up.

background r g b: Background color. If a ray misses all the objects in the scene, the pixel should be given this color.

light x y z r g b: Point light source at position (x,y,z) with color (r,g,b). allow up to 10 light sources. Any objects in scene should cast shadows from these light sources.

surface Cdr Cdg Cdb Car Cag Cab Csr Csg Csb P Krefl:
describes reflectance properties of a surface. This reflectance is given to objects that follow the command in the scene description, such as spheres and triangles.  The first three values are diffuse coefficients (r, g, b), followed by ambient and specular coefficients. Next is specular power P (Phong exponent). final value is the reflection coefficient (0 = no reflection, 1 = perfect mirror). Usually, 0 <= Cd,Ca,Cs,Krefl <= 1.  When Krefl is larger than one, this indicates that you will need to create reflection rays for this surface.

sphere radius x y z: A sphere with center (x, y, z).

begin: Begins the definition of a polygon. followed by "vertex" commands. the polygon definition is terminated by an "end".

vertex x y z: One vertex of a polygon. all polygons will be triangles. assume exactly three "vertex" commands between a "begin" and "end".

end: Ends the definition of a polygon.

write [filename].png: Raytraces scene and saves image to a PNG
