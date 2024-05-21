' =============================================================================
' Tiled TMX/TSX loader & renderer
' by AXG74
' v1.00
' =============================================================================
Type TTileLayer
	Field id:Int
	Field width:Int
	Field height:Int
	Field name:String
	Field data:Int[]
EndType

Type TTiled
	' map-position in pixel
	Global posX:Int
	Global posY:Int
	
	' map-size in tiles
	Global mapWidth:Int
	Global mapHeight:Int
	
	' tilesheet image
	Global imgTileSheet:TImage

	' tile-size in pixel
	Global tileWidth:Int
	Global tileHeight:Int
		
	' number of tiles in the tilesheet
	Global tileCount:Int
	
	' position (x, y) of each tile
	Global tilePosTab:Int[]
	
	' size of the tilesheet in pixel
	Global tileSheetWidth:Int
	Global tileSheetHeight:Int
	
	' tile-layer data
	Global tileLayerList:TList
		
	' filenames
	Global tileSheetFilename:String
	Global tsxFilename:String
	
	' render a tile-layer to the screen
	' !!! this is a simple implementation for rendering tiles
	' !!! you should implement your own one.
	Function RenderTileLayer(data:Int[])
		Local mapX:Int = posX / tileWidth
		Local mapY:Int = posY / tileHeight
		
		Local scrollX:Int = posX Mod tileWidth
		Local scrollY:Int = posY Mod tileHeight
		
		For Local y:Int = 0 To mapHeight - 1
			For Local x:Int = 0 To mapWidth - 1
				Local tileId:Int = data[(x + mapX) + ((y + mapY) * mapWidth)]
				
				If tileId > 0 Then
					Local tileSourceX:Int = tilePosTab[(tileId - 1) * 2 + 0]
					Local tileSourceY:Int = tilePosTab[(tileId - 1) * 2 + 1]
					
					TScreen.DrawSubImage(imgTileSheet, ..
										 (x * tileWidth) - scrollX, y * tileHeight, ..
										 tileSourceX, tileSourceY,
										 tileWidth, tileHeight)	
				EndIf				
			Next
		Next
	EndFunction
	
	' load and extract Tiled TMX, TSX & tilesheet image file
	Function Load(filename:String)
		' load and parse TMX/TSX files
		ParseTMX(filename)
		ParseTSX(ExtractDir(filename) + "/" + tsxFilename)
		
		' calculate tile positions
		CalcTilePosTab(tileWidth, tileHeight, tileCount)
		
		' load tilesheet image
		imgTileSheet = LoadImage(ExtractDir(filename) + "/" + tileSheetFilename)
	EndFunction
	
	' returns a tile-layer by it´s tile-layer ID, or null if nothing was found
	Function GetTileLayerById:TTileLayer(layerId:Int)
		For Local tl:TTileLayer = EachIn tileLayerList
			If tl.id = layerId
				Return tl
			EndIf
		Next
		
		Return Null
	EndFunction
	
	' returns a tile-layer by it´s tile-layer name, or null if nothing was found
	Function GetTileLayerByName:TTileLayer(layerName:String)
		For Local tl:TTileLayer = EachIn tileLayerList
			If tl.name.ToLower() = layerName.ToLower()
				Return tl
			EndIf
		Next
				
		Return Null
	EndFunction
	
	' parse a Tiled-TMX file and extract all relevant data like
	' # map-size (width, height) in tiles
	' # all tile-layer data
	' # TSX filename (filename for the tileset image)
	Function ParseTMX(filename:String)
		Local csvData:String[]
		Local tileData:Int[]
	
		tsxFilename = ""
		tileLayerList = New TList
		
		Local xmlDoc:TxmlDoc = TxmlDoc.parseFile(filename)
		Local rootNode:TxmlNode = xmlDoc.GetRootElement()

		' get map size in tiles
		mapWidth = rootNode.GetAttribute("width").ToInt()
		mapHeight = rootNode.GetAttribute("height").ToInt()
				
		' get tile-layer data
		For Local childNode:TxmlNode = EachIn rootNode.GetChildren()
			Local nodeName:String = childNode.GetName()
			Local layerName:String = childNode.GetAttribute("name")
			Local layerId:Int = childNode.GetAttribute("id").ToInt()
			Local layerCsvData:String = childNode.GetContent()
			
			csvData = layerCsvData.Split(",")

			Select nodeName	
				' load the TSX-file that defines a tileset
				Case "tileset"
					tsxFilename = childNode.GetAttribute("source")
					
				' add tile-layer data
				Case "layer"
					' process csv tile-data
					tileData = New Int[csvData.length]
					
					For Local i:Int = 0 To csvData.length - 1
						tileData[i] = csvData[i].ToInt()
					Next
					
					' create a new tile-layer
					Local tl:TTileLayer = New TTileLayer
					tl.id = layerId
					tl.width = mapWidth
					tl.height = mapHeight
					tl.name = layerName
					tl.data = tileData[..]
					tileLayerList.AddLast(tl)
			EndSelect
		Next
		
		xmlDoc.Free()
	EndFunction
	
	' parse a Tiled-TSX file and extract all relevant data like
	' # tile-size (width, height) in pixel
	' # tilesheet image size in pixel
	' # total tile count in the tilesheet
	Function ParseTSX(filename:String)
		Local xmlDoc:TxmlDoc = TxmlDoc.parseFile(filename)
		Local rootNode:TxmlNode = xmlDoc.getRootElement()
		
		' get tile size in pixel
		tileWidth = rootNode.GetAttribute("tilewidth").ToInt()
		tileHeight = rootNode.GetAttribute("tileheight").ToInt()
		tileCount = rootNode.GetAttribute("tilecount").ToInt()
		
		For Local childNode:TxmlNode = EachIn rootNode.GetChildren()
			Local nodeName:String = childNode.GetName()
			
			If nodeName = "image" Then
				' get filename of the tilesheet (relative path)
				tileSheetFilename = childNode.GetAttribute("source")
				
				' get size of the tilesheet in pixel
				tileSheetWidth = childNode.GetAttribute("width").ToInt()
				tileSheetHeight = childNode.GetAttribute("height").ToInt()
			EndIf
		Next
	
		xmlDoc.Free()
	EndFunction
	
	' precalculates the x/y position for each tile of the tilesheet
	Function CalcTilePosTab(tileW:Int, tileH:Int, tileC:Int)
		tilePosTab = New Int[tileC * 2]
		Local c:Int = 0
		
		For Local y:Int = 0 To tileSheetHeight / tileHeight - 1
			For Local x:Int = 0 To tileSheetWidth / tileWidth - 1
				tilePosTab[c + 0] = x * tileWidth
				tilePosTab[c + 1] = y * tileHeight
				c:+2
			Next
		Next
	EndFunction
	
	' returns the tilemap size
	Function GetTilemapSize:Int()
		Return mapWidth * mapHeight
	EndFunction
EndType