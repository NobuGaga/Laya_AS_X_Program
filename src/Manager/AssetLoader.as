package Manager {
	public class AssetLoader {
        public static function load():void {
            Laya.loader.load("res/atlas/loading.atlas", Laya.Handler.create(this, function (e) {
                // var loading = new ui.view.gameLoadingUI();
                // Laya.stage.addChild(loading);
                // var sp_mask = loading.sp_mask;
                // sp_mask.optimizeScrollRect = true;
                // resManager.loaded((e) => {
                //     var mainBoard = MainBoard.getInstance();
                //     var user = UserUtils.getInstance();
                //     user.getWxUser({
                //         sucFn: () => {
                //             console.log('登陆成功v1.0.0');
                //             Laya.stage.addChild(LayoutUtils.getInstance().map.get("gameStartUI"));
                //             Laya.stage.removeChild(loading);
                //             mainBoard.initMainBoard();
                //             GameEvent.getInstance().bindListenEvent();
                //             GameEvent.getInstance().remarkGameTime();  
                //         }, errFn: () => {
                //             alert('登陆失败');
                //         }
                //     });

                // }, (e) => {
                //     var process = parseInt(e * 100);
                //     loading.progress_text.text = process + '%';
                //     sp_mask.scrollRect = new Laya.Rectangle(0, 0, 5.2 * process, 24);
                // });
            });
        }
	}
}