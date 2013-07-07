#include "gamemap.h"
#include "spritesheet.h"
#include <TmxParser/Tmx.h>


Purity::GameMap::GameMap(const boost::filesystem::path& path)
{

}

sf::Sprite Purity::GameMap::getTile(int x, int y, int layerNum) const
{
        Tmx::MapTile tile;
        const Tmx::Tileset* tileset;
        SpriteSheet* spriteSheet;
        sf::Sprite tileSprite;
        int tilePositionX;
        int tilePositionY;
        std::string imagePath;

        tile = mTmxMap->GetLayer(layerNum)->GetTile(x, y);
        
        if (tile.id == 0)
        {
                return tileSprite;
        }

        tileset = mTmxMap->GetTileset(tile.tilesetId);

        imagePath = tileset->GetImage()->GetSource();

        spriteSheet = mTilesetMap.at(imagePath).get();

        tileSprite = spriteSheet->getTile(tile.id);

        tilePositionX = x * spriteSheet->getTileWidth();
        tilePositionY = y * spriteSheet->getTileHeight();

        tileSprite.setPosition(tilePositionX, tilePositionY);

        return tileSprite;

}

void Purity::GameMap::draw(sf::RenderTarget& target, sf::RenderStates states) const
{
    drawTiles(target, states);
}

void Purity::GameMap::drawTiles(sf::RenderTarget& target, sf::RenderStates states) const
{
    sf::Sprite tile;
    int layerCount = mTmxMap->GetNumLayers();
    int mapHeight = mTmxMap->GetHeight();
    int mapWidth = mTmxMap->GetWidth();

    for (int layerNum = 0; layerNum < layerCount; layerNum++)
    {
        for (int y = 0; y < mapHeight; y++)
        {
            for (int x = 0; x < mapWidth; x++)
            {
                tile = getTile(x, y, layerNum);
                target.draw(tile);
            }
        }
    }
}