#include "networksystem.h"
#include "luamanager.h"
#include <iostream>

Purity::NetworkSystem::NetworkSystem(std::queue<NetworkAction> * serverActionQueue) 
: mServer(false), mServerActionQueue(serverActionQueue)
{
    mSocket.setBlocking(false);
    mListener.setBlocking(false);
    luabind::globals(LuaManager::getManager()->getState())["GPurityNetwork"] = this;
}

void Purity::NetworkSystem::update(Scene* scene)
{
    if (isServer())
    {
        listenForNewConnections();
        receiveActionsFromClients();
        sendDataToClients();
    }
    else
    {
        sendActionsToServer();
        receiveDataFromServer();
    }
}

void Purity::NetworkSystem::setPort(unsigned short port)
{
    mPort = port;
    mSocket.bind(mPort);
    mListener.listen(mPort);
}

void Purity::NetworkSystem::sendAction(std::string objectName, std::string actionName)
{
    NetworkAction action;
    action.objectName = objectName;
    action.actionName = actionName;

    mClientActionQueue.push(action);
}

void Purity::NetworkSystem::sendActionsToServer()
{
    while (mClientActionQueue.empty() == false)
    {
        sf::Packet packet;

        packet << mClientActionQueue.front();

        mClientActionQueue.pop();

        mSocket.send(packet, mServerAddress, mPort);
    }
}

void Purity::NetworkSystem::setServer(bool isServer)
{
    this->mServer = isServer;
}

bool Purity::NetworkSystem::isServer() const
{
    return mServer;
}

void Purity::NetworkSystem::receiveAction(sf::IpAddress& client)
{
    sf::Packet packet;
    NetworkAction action;

    mSocket.receive(packet, client, mPort);
    
    if (packet >> action)
    {
        mServerActionQueue->push(action);
        std::cout << "Object " << action.objectName << " is performing " << action.actionName << std::endl;
    }
}

void Purity::NetworkSystem::connectToServer(std::string serverAddressStr)
{
    sf::TcpSocket socket;
    sf::IpAddress serverAddress(serverAddressStr);
    this->mServerAddress = serverAddress;
    sf::Socket::Status status = socket.connect(mServerAddress, mPort);
    if (status != sf::Socket::Done)
    {
        std::cerr << "Connection to " << mServerAddress << " failed!" << std::endl;
    }
    else if (status == sf::Socket::Done)
    {
        std::cout << "Connected to " << mServerAddress << std::endl;
    }
    socket.disconnect();
}

std::string Purity::NetworkSystem::getLocalAddress()
{
    return sf::IpAddress::getLocalAddress().toString();
}

std::string Purity::NetworkSystem::getPublicAddress()
{
    return sf::IpAddress::getPublicAddress().toString();
}

void Purity::NetworkSystem::listenForNewConnections()
{
    sf::TcpSocket client;

    if (mListener.accept(client) == sf::Socket::Done)
    {
        std::cout << "New connection received from: " << client.getRemoteAddress() << std::endl;
        addClient(client.getRemoteAddress());
    }
}

void Purity::NetworkSystem::addClient(const sf::IpAddress& clientAddress)
{
    mClientAddressList.push_back(clientAddress);
}

void Purity::NetworkSystem::sendDataToClients()
{

}

void Purity::NetworkSystem::receiveDataFromServer()
{
}

void Purity::NetworkSystem::receiveActionsFromClients()
{
    for (auto it = mClientAddressList.begin(); it != mClientAddressList.end(); ++it)
    {
        receiveAction(*it);
    }
}

luabind::scope Purity::NetworkSystem::luaBindings()
{
    return luabind::class_<NetworkSystem>("NetworkSystem")
        .def("getLocalAddress", &NetworkSystem::getLocalAddress)
        .def("getPublicAddress", &NetworkSystem::getPublicAddress)
        .def("setPort", &NetworkSystem::setPort)
        .def("sendAction", &NetworkSystem::sendAction)
        .def("receiveAction", &NetworkSystem::receiveAction)
        .def("connectToServer", &NetworkSystem::connectToServer)
        .def("setServer", &NetworkSystem::setServer)
        ;
}