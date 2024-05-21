' demo for tiled tilemaps with BlitzMAX NG
' use left/right cursor key to scroll horizontal
' ESC to quit
' tested on Windows 11
' by AXG74
' ----------------------------------------------

SuperStrict

Import text.xml

Include "TScreen.bmx"
Include "TTiled.bmx"

Global tileLayerData:Int[]
Global scrollSpeedX:Int = 4

TScreen.Init(320, 256)
TTiled.Load("assets/tiled/level1.tmx")

' create a copy of the tilemap layer data
tileLayerData = New Int[TTiled.GetTilemapSize()]
Local tileLayer:TTileLayer = TTiled.GetTileLayerById(1)
tileLayerData = tileLayer.data[..]

Repeat
	TScreen.Clear(0, 0, 0)
	TScreen.ScaleToScreen()
	TTiled.RenderTileLayer(tileLayerData)
	TScreen.ScaleReset()
	
	' scroll the tilemap
	If KeyDown(KEY_LEFT) Then
		If TTiled.posX > 0 Then 
			TTiled.posX:-scrollSpeedX
		EndIf
	EndIf
	
	If KeyDown(KEY_RIGHT) Then
		If TTiled.posX < (TTiled.mapWidth * TTiled.tileWidth) - (20 * TTiled.tileWidth) Then
			TTiled.posX:+scrollSpeedX
		EndIf
	EndIf
	
	TScreen.DrawDebug("scrollPos-X: " + TTiled.posX, 4, 4)
	Flip
Until KeyDown(KEY_ESCAPE)
End
