extends TextureRect

func ready():
	
	$TextureProgress.value = 100.00

func setpercentvalueint(value):
	$TextureProgress.value = value
