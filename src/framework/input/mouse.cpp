#include "mouse.h"

#ifdef __gnu_linux__
#include <X11/Xlib.h>
#elif defined _WIN32
#include <windows.h>
#endif

#include <SDL_events.h>

Purity::Vector2i Purity::Mouse::getPosition()
{
#ifdef __gnu_linux__
    // Open a connection with the X server
    Display* display = XOpenDisplay(NULL);

    // we don't care about these but they are required
    ::Window root, child;
    int x, y;
    unsigned int buttons;

    int gx = 0;
    int gy = 0;
    XQueryPointer(display, DefaultRootWindow(display), &root, &child, &gx, &gy, &x, &y, &buttons);

    // Close the connection with the X server
    XCloseDisplay(display);

    return Vector2i(gx, gy);
#elif defined _WIN32
    POINT point;
    GetCursorPos(&point);
    return Vector2i(point.x, point.y);
#elif defined __APPLE__
#error Not implemented on OS X
#endif
}


Purity::Vector2i Purity::Mouse::getPosition(const Purity::Window& relativeTo)
{
    int x, y;

    SDL_PumpEvents();
    SDL_GetMouseState(&x, &y);

    return Vector2i(x, y);
}

bool Purity::Mouse::isButtonPressed(Button button)
{
    SDL_PumpEvents();

    return SDL_GetMouseState(NULL, NULL) & SDL_BUTTON(button);
}