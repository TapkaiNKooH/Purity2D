#ifndef ENGINE_H
#define ENGINE_H

#include <memory>
#include <SFML/Graphics.hpp>
#include "scene.h"
#include "renderer.h"

namespace Purity
{

    class Engine
    {
    public:
        void initialize();
        void run();
        void cleanup();

    private:
        std::unique_ptr<sf::RenderWindow> mWindow;
        std::unique_ptr<Renderer> mRenderer;
        std::unique_ptr<Scene> mMap;

        void initializeWindow();
        void initializeRenderer();
    };

}

#endif // ENGINE_H