package {
	import laya.display.Scene;
	import laya.net.AtlasInfoManager;
	import laya.net.ResourceVersion;
	import laya.net.URL;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import laya.utils.Utils;
	
	public class Main {
		public function Main() {
			console.log("Main");
			//微信小游戏自适应
			// Laya.MiniAdpter.init();
			//根据IDE设置初始化引擎		
			if (window.Laya3D)
				window.Laya3D.init(GameConfig.width, GameConfig.height);
			else
				Laya.init(GameConfig.width, GameConfig.height, Laya.WebGL);
			
			Laya.Physics && Laya.Physics.enable();
			Laya.DebugPanel && Laya.DebugPanel.enable();
			
			Laya.stage.bgColor = "#5a7b9a";
			//按照宽度或者高度自适应
			Laya.stage.scaleMode = GameConfig.scaleMode;
			//屏幕适配，横屏还是竖屏，默认不改变
			Laya.stage.screenMode = GameConfig.screenMode;
			//垂直对齐方式，垂直居中
			Laya.stage.alignV = GameConfig.alignV;
			//水平对齐方式，水平居中
			Laya.stage.alignH = GameConfig.alignH;
			//禁用多点触控
			Laya.MouseManager.multiTouchEnabled = false;

			//兼容微信不支持加载scene后缀场景
			URL.exportSceneToJson = GameConfig.exportSceneToJson;
			
			//打开调试面板（IDE设置调试模式，或者url地址增加debug=true参数，均可打开调试面板）
			if (GameConfig.debug || Utils.getQueryString("debug") == "true")
				Laya.enableDebugPanel();
			if (GameConfig.physicsDebug && Laya.PhysicsDebugDraw)
				Laya.PhysicsDebugDraw.enable();
			if (GameConfig.stat)
				Stat.show();
			
			Laya.alertGlobalError = true;
			
			//激活资源版本控制，版本文件由发布功能生成
			ResourceVersion.enable("version.json", Handler.create(this, this.onVersionLoaded), ResourceVersion.FILENAME_VERSION);
		}
		
		private function onVersionLoaded():void {
			console.log("onVersionLoaded");
			//激活大小图映射，加载小图的时候，如果发现小图在大图合集里面，则优先加载大图合集，而不是小图
			AtlasInfoManager.enable("fileconfig.json", Handler.create(this, this.onConfigLoaded));
		}
		
		private function onConfigLoaded():void {
			console.log("onConfigLoaded");
			//加载场景
			GameConfig.startScene && Scene.open(GameConfig.startScene);
			// let gameMain= new ui.view.gameMainUI();
			// Laya.stage.addChild(gameMain);//添加到舞台，removeChild()
		}
	}
}