package laya.d3.physics.shape {
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	
	/**
	 * <code>CapsuleColliderShape</code> 类用于创建胶囊形状碰撞器。
	 */
	public class CapsuleColliderShape extends ColliderShape {
		/** @private */
		private static const _tempVector30:Vector3 = new Vector3();
		
		/**@private */
		private var _radius:Number;
		/**@private */
		private var _length:Number;
		/**@private */
		private var _orientation:int;
		
		/**
		 * 获取半径。
		 */
		public function get radius():Number {
			return _radius;
		}
		
		/**
		 * 获取长度。
		 */
		public function get length():Number {
			return _length;
		}
		
		/**
		 * 获取方向。
		 */
		public function get orientation():int {
			return _orientation;
		}
		
		/**
		 * 创建一个新的 <code>CapsuleColliderShape</code> 实例。
		 * @param 半径。
		 * @param 高(包含半径)。
		 * @param orientation 胶囊体方向。
		 */
		public function CapsuleColliderShape(radius:Number = 0.5, length:Number = 1.25, orientation:int = ColliderShape.SHAPEORIENTATION_UPY) {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			_radius = radius;
			_length = length;
			_orientation = orientation;
			_type = ColliderShape.SHAPETYPES_CAPSULE;
			
			switch (orientation) {
			case ColliderShape.SHAPEORIENTATION_UPX: 
				_nativeShape = new Laya3D._physics3D.btCapsuleShapeX(radius, length - radius * 2);
				break;
			case ColliderShape.SHAPEORIENTATION_UPY: 
				_nativeShape = new Laya3D._physics3D.btCapsuleShape(radius, length - radius * 2);
				break;
			case ColliderShape.SHAPEORIENTATION_UPZ: 
				_nativeShape = new Laya3D._physics3D.btCapsuleShapeZ(radius, length - radius * 2);
				break;
			default: 
				throw "CapsuleColliderShape:unknown orientation.";
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _setScale(value:Vector3):void {
			var fixScale:Vector3 = _tempVector30;
			switch (orientation) {
			case ColliderShape.SHAPEORIENTATION_UPX: 
				fixScale.x = value.x;
				fixScale.y = fixScale.z = Math.max(value.y, value.z);
				break;
			case ColliderShape.SHAPEORIENTATION_UPY: 
				fixScale.y = value.y;
				fixScale.x = fixScale.z = Math.max(value.x, value.z);
				break;
			case ColliderShape.SHAPEORIENTATION_UPZ: 
				fixScale.z = value.z;
				fixScale.x = fixScale.y = Math.max(value.x, value.y);
				break;
			default: 
				throw "CapsuleColliderShape:unknown orientation.";
			}
			super._setScale(fixScale);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function clone():* {
			var dest:CapsuleColliderShape = new CapsuleColliderShape(_radius, _length, _orientation);
			cloneTo(dest);
			return dest;
		}
	
	}

}