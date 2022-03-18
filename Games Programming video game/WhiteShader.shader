shader_type canvas_item;

uniform bool active = true;

void fragment()
{
vec4 previousColour = texture(TEXTURE, UV);
vec4 whiteColour = vec4(1.0,1.0,1.0,previousColour.a);
vec4 newColour = previousColour;
if (active == true)
{
	newColour = whiteColour;
}
COLOR = newColour;	
} 