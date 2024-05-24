Type TScreen
	Global width:Int
	Global height:Int
	Global scaleVal:Int
	Global offsetX:Int
	Global offsetY:Int
	
	' init graphics with a given resolution in fullscreen mode
	Function Init(pWidth:Int, pHeight:Int)
		width = pWidth
		height = pHeight
		
		' calculate integer screen scale
		scaleVal = DesktopHeight() / height
		
		' calculate offsets for centering
		offsetX = (DesktopWidth() - (width * scaleVal)) / 2
		offsetY = (DesktopHeight() - (height * scaleVal)) / 2
		
		Graphics DesktopWidth(), DesktopHeight(), DesktopDepth(), DesktopHertz()
		AutoImageFlags MASKEDIMAGE
		HideMouse()
	EndFunction
	
	' helper for set the scaling
	Function ScaleToScreen()
		SetScale (scaleVal, scaleVal)
	EndFunction
	
	Function ScaleReset()
		SetScale (1, 1)
	EndFunction
	
	' helper: clear the screen with some color
	Function Clear(red:Int, green:Int, blue:Int)
		SetViewport(offsetX, offsetY, width * scaleVal, height * scaleVal)
		Cls
		SetColor(red, green, blue)
		DrawRect(offsetX, offsetY, width * scaleVal, height * scaleVal)
		SetColor(255, 255, 255)
	EndFunction
	
	' draw a sub-image-rect with correct offset and scaling to the screen
	Function DrawSubImage(img:TImage, x:Int, y:Int, sourceX:Int, sourceY:Int, width:Int, height:Int)
		DrawSubImageRect(img, ..
					 Int(offsetX + Floor(x * scaleVal)), Int(offsetY + Floor(y * scaleVal)), ..
					 width, height, ..
					 sourceX, sourceY, ..
					 width, height)
	EndFunction
	
	' helper: draw a debug message to the screen
	Function DrawDebug(txt:String, x:Int, y:Int)
		SetColor 0, 255, 0
		DrawText(txt, x + offsetX, y + offsetY)
		SetColor 255, 255, 255
	EndFunction
EndType