#version 150

uniform ivec2 u_Dimensions;
uniform int u_Time;

in vec2 fs_UV;

out vec3 color;

uniform sampler2D u_RenderedTexture;


#define DISPLACE .125

vec2 random2( vec2 p ) {
    return fract(sin(vec2(dot(p, vec2(127.1, 311.7)),
                 dot(p, vec2(269.5,183.3))))* 43758.5453);
}

float WorleyNoise(vec2 uv) {
    uv *= 10; // Change the space to 10 * 10
    vec2 uvInt = floor(uv);
    vec2 uvFract = fract(uv);
    float minDist = 1.0; // Minimum distance initialized to max.
    for(int y = -1; y <= 1; ++y) {
        for(int x = -1; x <= 1; ++x) {
            vec2 neighbor = vec2(float(x), float(y)); // Direction in which neighbor cell lies
            vec2 point = random2(uvInt + neighbor); // Get the Voronoi centerpoint for the neighboring cell
            vec2 diff = neighbor + point - uvFract; // Distance between fragment coord and neighbor’s Voronoi point
            float dist = length(diff);
            minDist = min(minDist, dist);
        }
    }
    return minDist;
}

//Calculate the squared length of a vector
float length2(vec2 p){
    return dot(p,p);
}


float fworley(vec2 p) {
    //Stack noise layers
        return sqrt(sqrt(sqrt(
                WorleyNoise(p * 0.8 + 0.0005 * u_Time) *
                sqrt(WorleyNoise(p * 0.98 + 0.12 + -0.001 * u_Time)) *
                sqrt(sqrt(WorleyNoise(p * -0.99976 + 0.0003 * u_Time))))));
}


mat2 rotate(float theta) {
    return mat2(cos(theta), -sin(theta), sin(theta), cos(theta));
}

void main()
{
    // make a copy of fs_UV
    vec2 uv = fs_UV.xy;
    // Calculate the t for corrdinates change
    float t = fworley(vec2((uv.x / 12.0), (uv.y / 18.0)));

    uv.y += cos(0.99754 * t - 0.2674) - 0.87645;
    uv.x -= 0.5 * (cos(0.99754 * t - 0.2674) - 0.87645);

    vec4 fragcolor = texture(u_RenderedTexture, uv);

    // Add an other layer of noise
    float n = WorleyNoise(uv * 1000);
    vec2 uvN = fs_UV * cos(n * u_Time);
    vec4 noiseColor = texture(u_RenderedTexture, uvN);
    noiseColor *= n;

    // Add a fan to the right top corner
    color = vec3(fragcolor);
//    color = vec3(fragcolor + noiseColor);
//    vec2 nor = normalize(vec2(uvN + uv - 2 * fs_UV));
//    mat2 rotation = rotate(u_Time * 0.01);
//    vec2 view = normalize(rotation * vec2((0.2,0.8) - fs_UV));
//    float p = dot(nor, view) + fworley(view);

//    vec3 a = vec3(0.500, 0.500, 0.500);
//    vec3 b = vec3(0.500, 0.500, 0.500);
//    vec3 c = vec3(1.007, 1.007, 1.007);
//    vec3 d = vec3(0.497, 0.497, 0.497);
//    const float PI = 3.1415926;

//    color += (a + b * cos(2.f * PI * (c * p + d))) / 3.5;

}
