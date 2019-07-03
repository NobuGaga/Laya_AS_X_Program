package tool {
	import laya.utils.Utils;

	public class Debug {
		/** @prop {name:_state, tips:"调试开关", type:Boolean, default:false}*/
		private static var _state:Boolean = false;
		public static function state():Boolean {
			return _state;
		}

		public static function init():void {
			_state = GameConfig.debug || Utils.getQueryString("debug") == "true";
			if (GameConfig.physicsDebug && Laya["PhysicsDebugDraw"])
				Laya["PhysicsDebugDraw"].enable();
			if (!_state)
				return;
			//打开调试面板（IDE设置调试模式，或者url地址增加debug=true参数，均可打开调试面板）
			// Laya.enableDebugPanel();
		}

		public static function log(text:String):void {
			if (_state)
				console.log(text);
		}

		public static function logFunction(func:Function):void {
			if (!_state)
				return;
			// func == func.arguments.callee is true
			console.log("function name : " + func.name);
			const length:int = func.arguments.length;
			console.log("function arguments length : " + length);
			if (length == 0)
				return;
			for (var index:int = 0; index < length; index++)
				console.log("function arguments[" + index + "] : " + arguments[index]);
		}
	}
}