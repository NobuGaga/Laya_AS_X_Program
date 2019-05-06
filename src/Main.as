package {
	import laya.display.Scene;
	import laya.net.AtlasInfoManager;
	import laya.net.ResourceVersion;
	import laya.net.URL;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import tool.Debug;

	public class Main {
		public function Main() {
			//微信小游戏自适应
			// Laya.MiniAdpter.init();
			//根据IDE设置初始化引擎		
			setGameConfig();
			Debug.logFunction(arguments.callee);
	
			Laya.Physics && Laya.Physics.enable();
			Laya.alertGlobalError = true;
			
			//激活资源版本控制，版本文件由发布功能生成
			ResourceVersion.enable("version.json", Handler.create(this, this.onVersionLoaded), ResourceVersion.FILENAME_VERSION);
		}
		
		private function setGameConfig():void {
			if (window.Laya3D)
				window.Laya3D.init(GameConfig.width, GameConfig.height);
			else
				Laya.init(GameConfig.width, GameConfig.height, Laya.WebGL);
			
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
			
			if (GameConfig.stat)
				Stat.show();

			//自定义 Debug 类使用 GameConfig 设置
			Debug.init();
		}

		private function onVersionLoaded():void {
			//回调 Handler 无法获取函数引用，闭包没有传入函数指针本身？
			// Debug.logFunction(arguments.callee);
			Debug.log("onVersionLoaded");
			//激活大小图映射，加载小图的时候，如果发现小图在大图合集里面，则优先加载大图合集，而不是小图
			AtlasInfoManager.enable("fileconfig.json", Handler.create(this, this.onConfigLoaded));
		}
		
		private function onConfigLoaded():void {
			//回调 Handler 无法获取函数引用，闭包没有传入函数指针本身？
			// Debug.logFunction(arguments.callee);
			Debug.log("onConfigLoaded");
			//加载场景
			GameConfig.startScene && Scene.open(GameConfig.startScene);
			// let gameMain= new ui.view.gameMainUI();
			// Laya.stage.addChild(gameMain);//添加到舞台，removeChild()
		}
	}
}