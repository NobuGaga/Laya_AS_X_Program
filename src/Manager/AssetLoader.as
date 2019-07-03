package Manager {
    import laya.utils.Handler;

	public class AssetLoader {
        public function load():void {
            Laya.loader.load("res/atlas/loading.atlas", Handler.create(this, onLoadCompleted));
        }

        private function onLoadCompleted():void {

        }
	}
}