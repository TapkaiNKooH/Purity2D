#ifndef NETWORK_MANAGER_H
#define NETWORK_MANAGER_H

#include <SFML/Network.hpp>
#include <luabind/luabind.hpp>
#include <string>

namespace Purity
{
    class NetworkManager
    {
    public:
        NetworkManager();

        std::string getLocalAddress();
        std::string getPublicAddress();

        void update();

        void setPort(unsigned short port);

        void sendAction(std::string recipient, std::string objectName, std::string action);
        void receiveAction(std::string sender);

        void connectToServer(std::string serverAddress);

        void setServer(bool isServer);

        static luabind::scope luaBindings();

    private:
        sf::UdpSocket mSocket;
        sf::TcpListener mListener;

        unsigned short mPort;
        bool isServer;

        void listenForConnections();
    };
}

#endif // NETWORK_MANAGER_H