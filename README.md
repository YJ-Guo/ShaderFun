# ShaderFun
Implemented various artistic shaders with GLSL based on OpenGL pipeline.
## Pre-Process Shaders
### The Blinn-Phong Reflection Shader
![](ShaderResults/BlinnPhong.png)
### The Matcap Reflection Shader
The "Matcap" method uses designed material spheres to give 3D models the appearance of a complex material with dynamic lighting without having to perform expensive lighting calculations.
![](ShaderResults/matcap.png)
### The Iridescent Shader
In this shader a cosine color palette is chosen with the Lambertian dot product as the t value to exhibit a iridescent effect.
![](ShaderResults/iridescentShader.png)
## Post-Porcess Shaders
### The Greyscale and Vignette Shader
![](ShaderResults/greyscaleshader.png)
### The Gaussian Blur Shader
A Gaussian blur effectively performs a weighted average of NxN pixels and stores the result in the pixel at the center of that NxN box.
![](ShaderResults/gaussianblur.png)
### The Sobel Filter Shader
A Sobel filter effectively detects and enhances the edges of shapes in the 3D scene. It computes the approximate gradient of the color at each pixel, and where the color abruptly changes it returns a high value, otherwise it returns roughly black, or a slope of zero.
![](ShaderResults/sobelfilter.png)
### The Fake Bloom Shader
Conducting a threshold test on the average of surrounding pixel color to fake the blooming effect with only one step. 
![](ShaderResults/bloomshader.png)
