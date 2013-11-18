#ifndef MOVABLE_OBJECT_H
#define MOVABLE_OBJECT_H

#include "object.h"

namespace luabind
{
    struct scope;
}

namespace Purity
{
    class MovableEntity : public Entity
    {
    public:
        MovableEntity(const Tmx::Object* object, b2World* world);

        void applyLinearImpulse(float x, float y);
        void setLinearVelocity(float x, float y);
        float getLinearVelocityX() const;
        float getLinearVelocityY() const;

        static luabind::scope luaBindings();
    };
}

#endif // MOVABLE_OBJECT_H