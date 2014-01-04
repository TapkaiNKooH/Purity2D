#include "entitystate.h"

Purity::EntityState::EntityState(const unsigned int id)
    : entityId(id)
{
}

void Purity::EntityState::update(const b2Body *body)
{
    position = body->GetPosition();
    angle = body->GetAngle();
}
