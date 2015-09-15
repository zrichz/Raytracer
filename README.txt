Ray Tracer in Processing
Author: Monet Tomioka
Date: 3/13/2015

This ray tracer reads .cli files in /data folder. "cli" stands for "command language interpreter". Below is the grammar for the .cli files made by professor Greg Turk of Georgia Institute of Technology. Sample .cli files and their outputs (.png images) are provided.

fov angle: Specifies the field of view (in degrees) for a perspective projection. The viewer's eye position  is assumed to be at the origin and to be looking down the negative z-axis (giving us a right-handed coordinate system). The y-axis points up.

background r g b: Background color. If a ray misses all the objects in the scene, the pixel should be given this color.

light x y z r g b: Point light source at position (x,y,z) and its color (r, g, b). Your code should allow up to 10 light sources. Any objects in your scene should cast shadows from these light sources, of course.

surface Cdr Cdg Cdb Car Cag Cab Csr Csg Csb P Krefl: This command describes the reflectance properties of a surface, and this reflectance should be given to the objects that follow the command in the scene description, such as spheres and triangles.  The first three values are the diffuse coefficients (red, green, blue), followed by ambient and specular coefficients. Next comes the specular power P (the Phong exponent), which says how shiny the highlight of the surface should be. The final value is the reflection coefficient (0 = no reflection, 1 = perfect mirror). Usually, 0 <= Cd,Ca,Cs,Krefl <= 1.  When Krefl is larger than one, this indicates that you will need to create reflection rays for this surface.

sphere radius x y z: A sphere with its center at (x, y, z).

begin: Begins the definition of a polygon. Should be followed by "vertex" commands, and the polygon definition is terminated by an "end".

vertex x y z: One vertex of a polygon. For this project, all of the provided polygons will be triangles. This means you can assume that there will be exactly three "vertex" commands between a "begin" and "end".

end: Ends the definition of a polygon.

write [filename].png: Ray-traces the scene and saves the image to a PNG image file