namespace Bomberman.System
{
    public class EventManager : Node
    {
        [Signal]
        public delegate void BombExplosion(PlayerIndex playerType);

        [Signal]
        public delegate void PlayerDie(PlayerIndex playerType);

        [Signal]
        public delegate void ItemPickup(PlayerIndex playerType, ItemType itemType);

        [Signal]
        public delegate void SuddenDeathStart();

        [Signal]
        public delegate void SuddenDeathDestroyBricks();
    }
}