#include "entity.h"

#include <Tmx.h>
#include <LuaBridge.h>

unsigned int Purity::Entity::sNumOfEntities = 0;

Purity::Entity::Entity()
    : mId(++sNumOfEntities)
{
    mState.entityId = mId;
}

Purity::Entity::Entity(const Tmx::Object* object, b2World* world, Purity::Texture* texture)
    : Entity()
{
    mTexture = texture;
    float x = object->GetX() / PIXELS_PER_METER;
    float y = object->GetY() / PIXELS_PER_METER;
    float width = (float)object->GetWidth();
    float height = (float)object->GetHeight();

    mName = object->GetName();

    createBody(world);
    setPosition(x, y);
    setBodyPosition(x, y);
    setSize(width, height);

    if (mTexture != nullptr)
    {
        mSpriteSheet = std::unique_ptr<SpriteSheet>(
            new SpriteSheet(mTexture, object->GetProperties().GetIntProperty("AnimationFrameWidth"),
                            object->GetProperties().GetIntProperty("AnimationFrameWidth")));

        mAnimationFrame = object->GetProperties().GetIntProperty("StartingAnimationFrame");
        mFrameOffsetX = object->GetProperties().GetIntProperty("AnimationFrameOffsetX");
        mFrameOffsetY = object->GetProperties().GetIntProperty("AnimationFrameOffsetY");
    }
}

Purity::Entity::Entity(const Purity::Entity& e)
{
    auto world = e.mHitboxBody->GetWorld();

    mId = ++sNumOfEntities;
    mName = e.getName();

    mHitboxBodyDef = e.mHitboxBodyDef;
    createBody(world);
    setPosition(e.getX(), e.getY());
    setBodyPosition(e.getX(), e.getY());
    setSize(e.mWidthPixels, e.mHeightPixels);
}

Purity::Entity::~Entity()
{
    if (mHitboxBody)
    {
        mHitboxBody->GetWorld()->DestroyBody(mHitboxBody);
    }
}

void Purity::Entity::setBodyPosition(float x, float y)
{
    b2Vec2 pos;
    pos.Set(x, y);

    mHitboxBody->SetTransform(pos, mHitboxBody->GetAngle());
}

float Purity::Entity::getX() const
{
    return getPosition().x;
}

float Purity::Entity::getY() const
{
    return getPosition().y;
}

unsigned int Purity::Entity::getId() const
{
    return mId;
}

std::string Purity::Entity::getName() const
{
    return mName;
}

void Purity::Entity::setSize(float width, float height)
{
    mWidthPixels = width;
    mHeightPixels = height;

    b2PolygonShape hitboxBox;
    b2FixtureDef hitboxFixtureDef;

    hitboxBox.SetAsBox(mWidthPixels / PIXELS_PER_METER / 2, mHeightPixels / PIXELS_PER_METER / 2);

    hitboxFixtureDef.shape = &hitboxBox;

    hitboxFixtureDef.density = 0.0f;

    mHitboxBody->CreateFixture(&hitboxFixtureDef);

    mHitboxBody->SetUserData(this);

    initializeHitboxShape();
}

Purity::EntityState Purity::Entity::getState() const
{
    return mState;
}

void Purity::Entity::setAnimationFrame(int frame)
{
    mAnimationFrame = frame;
}

void Purity::Entity::update()
{
    float x = (mHitboxBody->GetPosition().x * PIXELS_PER_METER) - (mWidthPixels / 2);
    float y = (mHitboxBody->GetPosition().y * PIXELS_PER_METER) - (mHeightPixels / 2);

    setPosition(x, y);

    mHitboxRect.position.x = x;
    mHitboxRect.position.y = y;

    updateState();
}

void Purity::Entity::updateState()
{
    mState.position = mHitboxBody->GetPosition();
    mState.angle = mHitboxBody->GetAngle();
}

void Purity::Entity::createBody(b2World* world)
{
    mHitboxBody = world->CreateBody(&mHitboxBodyDef);
}

void Purity::Entity::initializeHitboxShape()
{
    mHitboxRect.position.x = getPosition().x;
    mHitboxRect.position.y = getPosition().y;
    mHitboxRect.width = mWidthPixels;
    mHitboxRect.height = mHeightPixels;
}

void Purity::Entity::draw(Purity::RenderTarget& target) const
{
    if (mSpriteSheet)
    {
        target.draw(mSpriteSheet.get(), mAnimationFrame,
                    Vector2f(getPosition().x + mFrameOffsetX, getPosition().y + mFrameOffsetY));
    }
    else
    {
        target.draw(mHitboxRect);
    }
}

void Purity::Entity::luaBindings(lua_State* state)
{
    /*
        luabridge::getGlobalNamespace(state)
            .beginNamespace("Purity")
                .beginClass<Entity>("Entity")
                    .addFunction("getName", &Entity::getName)
                .endClass()
            .endNamespace();*/
}
