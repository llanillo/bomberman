using Bomberman.Player;

namespace Bomberman.System
{
    public class EventManager
    {
        [Signal]
        public delegate void BombExplosion(PlayerType playerType);

        [Signal]
        public delegate void PlayerDie(PlayerType playerType);

        [Signal]
        public delegate void ItemPickup(PlayerType playerType, ItemType itemType);

        [Signal]
        public delegate void SuddenDeathStart();

        [Signal]
        public delegate void SuddenDeathDestroyBricks();
    }
}