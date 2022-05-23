import SpriteKit
import GameplayKit

// swiftlint:disable:next type_body_length
public final class MSKTiledMapParser: NSObject, XMLParserDelegate {

    private var characters = ""
    private var encodingType: EncodingType = .csv

    private var tileGroups = [SKTileGroup]()
    private var layers = [SKTileMapNode]()

    private var tileSize = CGSize()
    private var mapSize = CGSize()

    private var textureCache = [String: SKTexture]()

    private var currentRawTile: RawTile?
    private var rawTiles = [RawTile]()

    private var currentRawTileSet: RawTileSet?
    private var rawTileSets = [RawTileSet]()

    private var currentRawLayer: RawLayer?

    public func loadTilemap(filename: String) -> (layers: [SKTileMapNode], tileGroups: [SKTileGroup]) {
        guard let path = Bundle.main.url(forResource: filename, withExtension: ".tmx") else {
            log(logLevel: .error, message: "Failed to locate tilemap \(filename) in bundle")
            return (layers, tileGroups)
        }
        guard let parser = XMLParser(contentsOf: path) else {
            log(logLevel: .error, message: "Failed to load xml tilemap \(filename)")
            return (layers, tileGroups)
        }

        parser.delegate = self
        parser.parse()

        cleanUp()
        return (layers, tileGroups)
    }

    // swiftlint:disable:next cyclomatic_complexity function_body_length
    public func parser(_ parser: XMLParser,
                       didStartElement elementName: String,
                       namespaceURI: String?,
                       qualifiedName qName: String?,
                       attributes attributeDict: [String: String]) {
        if elementName == ElementName.map.rawValue {
            guard let mapWidth = getDoubleValueFromAttributes(attributeDict, attributeName: .width),
                  let mapHeight = getDoubleValueFromAttributes(attributeDict, attributeName: .height) else {
                      log(logLevel: .error, message: "Map found without a size definition: LINE[\(parser.lineNumber)]")
                      parser.abortParsing()
                      return
                  }
            guard let tileWidth = getDoubleValueFromAttributes(attributeDict, attributeName: .tilewidth),
                  let tileHeight = getDoubleValueFromAttributes(attributeDict, attributeName: .tileheight) else {
                      log(logLevel: .error, message: "Map found without a tilesize definition: LINE[\(parser.lineNumber)]")
                      parser.abortParsing()
                      return
                  }
            mapSize = .init(width: mapWidth, height: mapHeight)
            tileSize = .init(width: tileWidth, height: tileHeight)
        } else if elementName == ElementName.tileset.rawValue {
            guard let tileWidth = getDoubleValueFromAttributes(attributeDict, attributeName: .tilewidth),
                  let tileHeight = getDoubleValueFromAttributes(attributeDict, attributeName: .tileheight) else {
                      log(logLevel: .error, message: "Tileset found without tilesize definitions: LINE[\(parser.lineNumber)]")
                      parser.abortParsing()
                      return
                  }
            if tileSize.width != tileWidth || tileSize.height != tileHeight {
                log(logLevel: .error, message: "Tileset found with a different tilesize (\(tileWidth),\(tileHeight) than defined on the map (\(tileSize)): LINE[\(parser.lineNumber)]")
                parser.abortParsing()
                return
            }
            guard let firstGid = getIntValueFromAttributes(attributeDict, attributeName: .firstgid),
                  let tileCount = getIntValueFromAttributes(attributeDict, attributeName: .tilecount),
                  let columns = getIntValueFromAttributes(attributeDict, attributeName: .columns) else {
                      log(logLevel: .error, message: "Invalid tileset found. Check existence of firstgid, tilecount and columns: LINE[\(parser.lineNumber)]")
                      parser.abortParsing()
                      return
                  }
            currentRawTileSet = RawTileSet(firstGid: firstGid, tileCount: tileCount, image: "", columns: columns)
        } else if elementName == ElementName.image.rawValue {
            guard let currentRawTileSet = currentRawTileSet else {
                log(logLevel: .error, message: "Images are only supported for tilesets at the moment: LINE[\(parser.lineNumber)]")
                return
            }
            guard let source = getStringValueFromAttributes(attributeDict, attributeName: .source) else {
                log(logLevel: .error, message: "Tileset image found without a valid source: LINE[\(parser.lineNumber)]")
                parser.abortParsing()
                return
            }

            let rawTileSet = RawTileSet(firstGid: currentRawTileSet.firstGid, tileCount: currentRawTileSet.tileCount, image: source, columns: currentRawTileSet.columns)
            rawTileSets.append(rawTileSet)
        } else if elementName == ElementName.tile.rawValue {
            guard let currentRawTileSet = currentRawTileSet else {
                log(logLevel: .error, message: "Tile found not embedded in a tileset: LINE[\(parser.lineNumber)]")
                return
            }

            if let tileId = getIntValueFromAttributes(attributeDict, attributeName: .id) {
                currentRawTile = .init(id: tileId+currentRawTileSet.firstGid, properties: nil)
            } else {
                log(logLevel: .error, message: "Tile found without an id: LINE[\(parser.lineNumber)]")
                parser.abortParsing()
                return
            }
        } else if elementName == ElementName.property.rawValue {
            guard let currentRawTile = currentRawTile else {
                log(logLevel: .warning, message: "Properties are only supported on tiles")
                return
            }
            guard
                let name = getStringValueFromAttributes(attributeDict, attributeName: .name),
                let value = getStringValueFromAttributes(attributeDict, attributeName: .value)
            else {
                log(logLevel: .error, message: "Invalid property found: LINE[\(parser.lineNumber)]")
                return
            }
            var propertyValue: Any = value
            if let type = getStringValueFromAttributes(attributeDict, attributeName: .type) {
                if let propertyType = PropertyType.init(rawValue: type) {
                    if propertyType == .bool {
                        if let boolValue = Bool(value) {
                            propertyValue = boolValue
                        } else {
                            log(logLevel: .error, message: "Invalid property boolean found: LINE[\(parser.lineNumber)]")
                            return
                        }
                    }
                } else {
                    log(logLevel: .error, message: "Unsupported property type found: LINE[\(parser.lineNumber)]")
                    return
                }
            }
            var newProperties = [String: Any]()
            if var existingProperties = currentRawTile.properties {
                existingProperties[name] = propertyValue
                newProperties = existingProperties
            } else {
                newProperties[name] = propertyValue
            }
            self.currentRawTile = RawTile(id: currentRawTile.id, properties: newProperties)
        } else if elementName == ElementName.layer.rawValue {
            guard let layerWidth = getDoubleValueFromAttributes(attributeDict, attributeName: .width),
                  let layerHeight = getDoubleValueFromAttributes(attributeDict, attributeName: .height) else {
                      log(logLevel: .error, message: "Layer found without a size definition: LINE[\(parser.lineNumber)]")
                      parser.abortParsing()
                      return
                  }
            if mapSize.width != layerWidth || mapSize.height != layerHeight {
                log(logLevel: .error, message: "Layer found with a different size (\(layerWidth),\(layerHeight) than defined on the map (\(mapSize)): LINE[\(parser.lineNumber)]")
                parser.abortParsing()
                return
            }
            guard
                // swiftlint:disable:next identifier_name
                let id = getIntValueFromAttributes(attributeDict, attributeName: .id),
                let name = getStringValueFromAttributes(attributeDict, attributeName: .name)
            else {
                log(logLevel: .error, message: "Invalid layer (no name or id) found: LINE[\(parser.lineNumber)]")
                parser.abortParsing()
                return
            }
            currentRawLayer = .init(id: id, name: name)
        } else if elementName == ElementName.data.rawValue {
            if let encoding = getStringValueFromAttributes(attributeDict, attributeName: .encoding) {
                if let encodingType = EncodingType.init(rawValue: encoding) {
                    self.encodingType = encodingType
                } else {
                    log(logLevel: .error, message: "Unsupported encoding found (only csv is supported): LINE[\(parser.lineNumber)]")
                    parser.abortParsing()
                }
            } else {
                log(logLevel: .warning, message: "No encoding found, defaulting to csv")
                self.encodingType = .csv
            }
        }
    }

    // swiftlint:disable:next cyclomatic_complexity
    public func parser(_ parser: XMLParser,
                       didEndElement elementName: String,
                       namespaceURI: String?,
                       qualifiedName qName: String?) {
        if elementName == ElementName.tile.rawValue {
            currentRawTile = nil
        } else if elementName == ElementName.tileset.rawValue {
            currentRawTileSet = nil
        } else if elementName == ElementName.properties.rawValue {
            if let currentRawTile = currentRawTile {
                rawTiles.append(currentRawTile)
            }
        } else if elementName == ElementName.layer.rawValue {
            currentRawLayer = nil
        } else if elementName == ElementName.data.rawValue {
            guard let currentRawLayer = currentRawLayer else {
                log(logLevel: .warning, message: "Data is only supported on layers")
                return
            }
            if encodingType == .csv { // not functional, but good to have in place for future support
                characters = characters.replacingOccurrences(of: "\n", with: "")
                characters = characters.trimmingCharacters(in: .whitespacesAndNewlines)
                characters = characters.replacingOccurrences(of: " ", with: "")
                let layerData = characters.components(separatedBy: ",").compactMap { Int($0) }

                createTileGroupsFor(layerData: layerData)

                let tileSet = SKTileSet(tileGroups: tileGroups, tileSetType: .grid)
                let layer = SKTileMapNode(tileSet: tileSet, columns: Int(mapSize.width), rows: Int(mapSize.height), tileSize: tileSize)

                var idx = 0
                for tileId in layerData {
                    if !hasValidTileData(tileId: tileId) {
                        continue
                    }
                    var column = 0
                    if idx > 0 {
                        column = idx%Int(mapSize.width)
                    }
                    let row = Int(floor(CGFloat(idx)/mapSize.height))

                    let tileGroup = getTileGroup(tileId: tileId)
                    layer.setTileGroup(tileGroup, forColumn: column, row: Int(mapSize.height-1)-row)
                    idx+=1
                }
                layer.name = currentRawLayer.name
                layers.append(layer)
            }
        }
        characters = ""
    }

    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        characters += string
    }

    private func cleanUp() {
        textureCache.removeAll()
    }

    private func createTileGroupsFor(layerData: [Int]) {
        for tileId in layerData {
            if !hasValidTileData(tileId: tileId) || hasTileGroupForTile(tileId: tileId) {
                continue
            }
            tileGroups.append(getTileGroup(tileId: tileId))
        }
    }

    private func hasValidTileData(tileId: Int) -> Bool {
        return tileId > 0
    }

    private func hasTileGroupForTile(tileId: Int) -> Bool {
        return tileGroups.first { $0.name == ("\(tileId)") } != nil
    }

    private func getRawTileSetFor(tileId: Int) -> RawTileSet {
        for rawTileSet in rawTileSets {
            if tileId >= rawTileSet.firstGid && tileId < rawTileSet.firstGid+rawTileSet.tileCount {
                return rawTileSet
            }
        }
        fatalError("getRawTileSetFor not found for tileId \(tileId)")
    }

    private func getTileGroup(tileId: Int) -> SKTileGroup {
        let tileGroup = tileGroups.first { $0.name == ("\(tileId)") }
        if let tileGroup = tileGroup {
            return tileGroup
        }

        // find correct one
        let rawTileSet = getRawTileSetFor(tileId: tileId)

        let tileIdInSheet = tileId-rawTileSet.firstGid
        var column = 0
        if tileIdInSheet > 0 {
            column = tileIdInSheet%rawTileSet.columns
        }
        let row = Int(floor(CGFloat(tileIdInSheet)/CGFloat(rawTileSet.columns)))

        let sourceTexture = getTexture(name: rawTileSet.image)
        let tileTexture = SKTexture(rect: CGRect(x: tileSize.width*CGFloat(column)/sourceTexture.size().width, y: 1-(tileSize.height*CGFloat(row+1)/sourceTexture.size().height), width: tileSize.width/sourceTexture.size().width, height: tileSize.height/sourceTexture.size().height), in: sourceTexture)

        let tileDefinition = SKTileDefinition(texture: tileTexture)
        if let rawTile = rawTiles.first(where: { $0.id == tileId }), let properties = rawTile.properties {
            tileDefinition.userData = .init()
            properties.forEach { (key: String, value: Any) in
                tileDefinition.userData?.setValue(value, forKey: key)
            }
        }
        let newTileGroup = SKTileGroup(tileDefinition: tileDefinition)
        newTileGroup.name = "\(tileId)"
        return newTileGroup
    }

    private func getTexture(name: String) -> SKTexture {
        if let cachedTexture = textureCache[name] {
            return cachedTexture
        }
        let texture = SKTexture(imageNamed: name)
        textureCache[name] = texture
        return texture
    }

    private func getIntValueFromAttributes(_ attributes: [String: String], attributeName: AttributeName) -> Int? {
        guard let value = attributes[attributeName.rawValue], let integerValue = Int(value) else {
            return nil
        }
        return integerValue
    }

    private func getDoubleValueFromAttributes(_ attributes: [String: String], attributeName: AttributeName) -> Double? {
        guard let value = attributes[attributeName.rawValue], let doubleValue = Double(value) else {
            return nil
        }
        return doubleValue
    }

    private func getStringValueFromAttributes(_ attributes: [String: String], attributeName: AttributeName) -> String? {
        return attributes[attributeName.rawValue]
    }
}

private enum EncodingType: String {
    case csv
}

private enum ElementName: String {
    case map
    case tileset
    case image
    case property
    case properties
    case tile
    case layer
    case data
}

private enum AttributeName: String {
    case width
    case height
    case tilewidth
    case tileheight
    case firstgid
    case tilecount
    case columns
    case source
    // swiftlint:disable:next identifier_name
    case id
    case name
    case value
    case encoding
    case type
}

private struct RawTileSet {
    let firstGid: Int
    let tileCount: Int
    let image: String
    let columns: Int
}

private struct RawTile {
    // swiftlint:disable:next identifier_name
    let id: Int
    let properties: [String: Any]?
}

private enum PropertyType: String {
    case string
    case bool
}

private struct RawLayer {
    // swiftlint:disable:next identifier_name
    let id: Int
    let name: String
}
