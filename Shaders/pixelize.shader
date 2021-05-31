shader_type canvas_item;

uniform float size_x; //Display Dimensions
uniform float size_y; //size_y = NumPixels / Window.size.y
uniform float SCREEN_RESOLUTION = 8; //Number of pixels in an x by x area.
uniform float colour_rate = 32; //Reduce colours to 32bit.

void fragment()
{
	//Pixelization
	vec2 uv = SCREEN_UV;
	uv -= mod(uv, vec2(SCREEN_RESOLUTION/size_x, SCREEN_RESOLUTION/size_y));
	COLOR.rgb = textureLod(SCREEN_TEXTURE, uv, 0.0).rgb;
	//Colour Reduce
	COLOR.r = floor(COLOR.r*colour_rate)/colour_rate;
	COLOR.g = floor(COLOR.g*colour_rate)/colour_rate;
	COLOR.b = floor(COLOR.b*colour_rate)/colour_rate;
}