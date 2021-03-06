package laya.d3.math.Native {
	import laya.d3.core.IClone;
	import laya.d3.math.MathUtils3D;
	import laya.d3.math.Matrix3x3;
	import laya.d3.math.Matrix4x4;
	
	/**
	 * <code>Quaternion</code> 类用于创建四元数。
	 */
	public class ConchQuaternion implements IClone {
		/*[FILEINDEX:10000]*/
		/**@private */
		public static var TEMPVector30:ConchVector3 = new ConchVector3();
		/**@private */
		public static var TEMPVector31:ConchVector3 = new ConchVector3();
		/**@private */
		public static var TEMPVector32:ConchVector3 = new ConchVector3();
		/**@private */
		public static var TEMPVector33:ConchVector3 = new ConchVector3();
		/**@private */
		public static var TEMPMatrix0:Matrix4x4 = new Matrix4x4();
		/**@private */
		public static var TEMPMatrix1:Matrix4x4 = new Matrix4x4();
		/**@private */
		public static var _tempMatrix3x3:Matrix3x3 = new Matrix3x3();
		
		/**默认矩阵,禁止修改*/
		public static const DEFAULT:ConchQuaternion =/*[STATIC SAFE]*/ new ConchQuaternion();
		/**无效矩阵,禁止修改*/
		public static const NAN:ConchQuaternion = new ConchQuaternion(NaN, NaN, NaN, NaN);
		
		/**
		 * @private
		 */
		public static function _dotArray(l:Float32Array, r:Float32Array):Number {			
			return l[0] * r[0] + l[1] * r[1] + l[2] * r[2] + l[3] * r[3];
		}
		
		/**
		 * @private
		 */
		public static function _normalizeArray(f:Float32Array, o:Float32Array):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var x:Number = f[0], y:Number = f[1], z:Number = f[2], w:Number = f[3];
			var len:Number = x * x + y * y + z * z + w * w;
			if (len > 0) {
				len = 1 / Math.sqrt(len);
				o[0] = x * len;
				o[1] = y * len;
				o[2] = z * len;
				o[3] = w * len;
			}
		}
		
		/**
		 * @private
		 */
		public static function _lerpArray(l:Float32Array, r:Float32Array, amount:Number, o:Float32Array):void {
			var inverse:Number = 1.0 - amount;
			if (_dotArray(l, r) >= 0) {
				o[0] = (inverse * l[0]) + (amount * r[0]);
				o[1] = (inverse * l[1]) + (amount * r[1]);
				o[2] = (inverse * l[2]) + (amount * r[2]);
				o[3] = (inverse * l[3]) + (amount * r[3]);
			} else {
				o[0] = (inverse * l[0]) - (amount * r[0]);
				o[1] = (inverse * l[1]) - (amount * r[1]);
				o[2] = (inverse * l[2]) - (amount * r[2]);
				o[3] = (inverse * l[3]) - (amount * r[3]);
			}
			_normalizeArray(o, o);
		}
		
		/**
		 *  从欧拉角生成四元数（顺序为Yaw、Pitch、Roll）
		 * @param	yaw yaw值
		 * @param	pitch pitch值
		 * @param	roll roll值
		 * @param	out 输出四元数
		 */
		public static function createFromYawPitchRoll(yaw:Number, pitch:Number, roll:Number, out:ConchQuaternion):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var halfRoll:Number = roll * 0.5;
			var halfPitch:Number = pitch * 0.5;
			var halfYaw:Number = yaw * 0.5;
			
			var sinRoll:Number = Math.sin(halfRoll);
			var cosRoll:Number = Math.cos(halfRoll);
			var sinPitch:Number = Math.sin(halfPitch);
			var cosPitch:Number = Math.cos(halfPitch);
			var sinYaw:Number = Math.sin(halfYaw);
			var cosYaw:Number = Math.cos(halfYaw);
			
			var oe:Float32Array = out.elements;
			oe[0] = (cosYaw * sinPitch * cosRoll) + (sinYaw * cosPitch * sinRoll);
			oe[1] = (sinYaw * cosPitch * cosRoll) - (cosYaw * sinPitch * sinRoll);
			oe[2] = (cosYaw * cosPitch * sinRoll) - (sinYaw * sinPitch * cosRoll);
			oe[3] = (cosYaw * cosPitch * cosRoll) + (sinYaw * sinPitch * sinRoll);
		}
		
		/**
		 * 计算两个四元数相乘
		 * @param	left left四元数
		 * @param	right  right四元数
		 * @param	out 输出四元数
		 */
		public static function multiply(left:ConchQuaternion, right:ConchQuaternion, out:ConchQuaternion):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var le:Float32Array = left.elements;
			var re:Float32Array = right.elements;
			var oe:Float32Array = out.elements;
			
			var lx:Number = le[0];
			var ly:Number = le[1];
			var lz:Number = le[2];
			var lw:Number = le[3];
			var rx:Number = re[0];
			var ry:Number = re[1];
			var rz:Number = re[2];
			var rw:Number = re[3];
			var a:Number = (ly * rz - lz * ry);
			var b:Number = (lz * rx - lx * rz);
			var c:Number = (lx * ry - ly * rx);
			var d:Number = (lx * rx + ly * ry + lz * rz);
			oe[0] = (lx * rw + rx * lw) + a;
			oe[1] = (ly * rw + ry * lw) + b;
			oe[2] = (lz * rw + rz * lw) + c;
			oe[3] = lw * rw - d;
		}
		
		private static function arcTanAngle(x:Number, y:Number):Number {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			if (x == 0) {
				if (y == 1)
					return Math.PI / 2;
				return -Math.PI / 2;
			}
			if (x > 0)
				return Math.atan(y / x);
			if (x < 0) {
				if (y > 0)
					return Math.atan(y / x) + Math.PI;
				return Math.atan(y / x) - Math.PI;
			}
			return 0;
		}
		
		private static function angleTo(from:ConchVector3, location:ConchVector3, angle:ConchVector3):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			ConchVector3.subtract(location, from, TEMPVector30);
			ConchVector3.normalize(TEMPVector30, TEMPVector30);
			
			angle.elements[0] = Math.asin(TEMPVector30.y);
			angle.elements[1] = arcTanAngle(-TEMPVector30.z, -TEMPVector30.x);
		}
		
		/**
		 * 从指定的轴和角度计算四元数
		 * @param	axis  轴
		 * @param	rad  角度
		 * @param	out  输出四元数
		 */
		public static function createFromAxisAngle(axis:ConchVector3, rad:Number, out:ConchQuaternion):void {
			var e:Float32Array = out.elements;
			var f:Float32Array = axis.elements;
			
			rad = rad * 0.5;
			var s:Number = Math.sin(rad);
			e[0] = s * f[0];
			e[1] = s * f[1];
			e[2] = s * f[2];
			e[3] = Math.cos(rad);
		}
		
		/**
		 * 根据3x3矩阵计算四元数
		 * @param	sou 源矩阵
		 * @param	out 输出四元数
		 */
		public static function createFromMatrix3x3(sou:Matrix3x3, out:ConchQuaternion):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var e:Float32Array = out.elements;
			var f:Float32Array = sou.elements;
			
			var fTrace:Number = f[0] + f[4] + f[8];
			var fRoot:Number;
			if (fTrace > 0.0) {
				// |w| > 1/2, may as well choose w > 1/2
				fRoot = Math.sqrt(fTrace + 1.0);  // 2w
				e[3] = 0.5 * fRoot;
				fRoot = 0.5 / fRoot;  // 1/(4w)
				e[0] = (f[5] - f[7]) * fRoot;
				e[1] = (f[6] - f[2]) * fRoot;
				e[2] = (f[1] - f[3]) * fRoot;
			} else {
				// |w| <= 1/2
				var i:Number = 0;
				if (f[4] > f[0])
					i = 1;
				if (f[8] > f[i * 3 + i])
					i = 2;
				var j:Number = (i + 1) % 3;
				var k:Number = (i + 2) % 3;
				
				fRoot = Math.sqrt(f[i * 3 + i] - f[j * 3 + j] - f[k * 3 + k] + 1.0);
				e[i] = 0.5 * fRoot;
				fRoot = 0.5 / fRoot;
				e[3] = (f[j * 3 + k] - f[k * 3 + j]) * fRoot;
				e[j] = (f[j * 3 + i] + f[i * 3 + j]) * fRoot;
				e[k] = (f[k * 3 + i] + f[i * 3 + k]) * fRoot;
			}
			
			return;
		
		}
		
		/**
		 *  从旋转矩阵计算四元数
		 * @param	mat 旋转矩阵
		 * @param	out  输出四元数
		 */
		public static function createFromMatrix4x4(mat:Matrix4x4, out:ConchQuaternion):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var me:Float32Array = mat.elements;
			var oe:Float32Array = out.elements;
			
			var sqrt:Number;
			var half:Number;
			var scale:Number = me[0] + me[5] + me[10];
			
			if (scale > 0.0) {
				sqrt = Math.sqrt(scale + 1.0);
				oe[3] = sqrt * 0.5;
				sqrt = 0.5 / sqrt;
				
				oe[0] = (me[6] - me[9]) * sqrt;
				oe[1] = (me[8] - me[2]) * sqrt;
				oe[2] = (me[1] - me[4]) * sqrt;
			} else if ((me[0] >= me[5]) && (me[0] >= me[10])) {
				sqrt = Math.sqrt(1.0 + me[0] - me[5] - me[10]);
				half = 0.5 / sqrt;
				
				oe[0] = 0.5 * sqrt;
				oe[1] = (me[1] + me[4]) * half;
				oe[2] = (me[2] + me[8]) * half;
				oe[3] = (me[6] - me[9]) * half;
			} else if (me[5] > me[10]) {
				sqrt = Math.sqrt(1.0 + me[5] - me[0] - me[10]);
				half = 0.5 / sqrt;
				
				oe[0] = (me[4] + me[1]) * half;
				oe[1] = 0.5 * sqrt;
				oe[2] = (me[9] + me[6]) * half;
				oe[3] = (me[8] - me[2]) * half;
			} else {
				sqrt = Math.sqrt(1.0 + me[10] - me[0] - me[5]);
				half = 0.5 / sqrt;
				
				oe[0] = (me[8] + me[2]) * half;
				oe[1] = (me[9] + me[6]) * half;
				oe[2] = 0.5 * sqrt;
				oe[3] = (me[1] - me[4]) * half;
			}
		
		}
		
		/**
		 * 球面插值
		 * @param	left left四元数
		 * @param	right  right四元数
		 * @param	a 插值比例
		 * @param	out 输出四元数
		 * @return   输出Float32Array
		 */
		public static function slerp(left:ConchQuaternion, right:ConchQuaternion, t:Number, out:ConchQuaternion):Float32Array {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var a:Float32Array = left.elements;
			var b:Float32Array = right.elements;
			var oe:Float32Array = out.elements;
			var ax:Number = a[0], ay:Number = a[1], az:Number = a[2], aw:Number = a[3], bx:Number = b[0], by:Number = b[1], bz:Number = b[2], bw:Number = b[3];
			
			var omega:Number, cosom:Number, sinom:Number, scale0:Number, scale1:Number;
			
			// calc cosine 
			cosom = ax * bx + ay * by + az * bz + aw * bw;
			// adjust signs (if necessary) 
			if (cosom < 0.0) {
				cosom = -cosom;
				bx = -bx;
				by = -by;
				bz = -bz;
				bw = -bw;
			}
			// calculate coefficients 
			if ((1.0 - cosom) > 0.000001) {
				// standard case (slerp) 
				omega = Math.acos(cosom);
				sinom = Math.sin(omega);
				scale0 = Math.sin((1.0 - t) * omega) / sinom;
				scale1 = Math.sin(t * omega) / sinom;
			} else {
				// "from" and "to" quaternions are very close  
				//  ... so we can do a linear interpolation 
				scale0 = 1.0 - t;
				scale1 = t;
			}
			// calculate final values 
			oe[0] = scale0 * ax + scale1 * bx;
			oe[1] = scale0 * ay + scale1 * by;
			oe[2] = scale0 * az + scale1 * bz;
			oe[3] = scale0 * aw + scale1 * bw;
			
			return oe;
		}
		
		/**
		 * 计算两个四元数的线性插值
		 * @param	left left四元数
		 * @param	right right四元数b
		 * @param	t 插值比例
		 * @param	out 输出四元数
		 */
		public static function lerp(left:ConchQuaternion, right:ConchQuaternion, amount:Number, out:ConchQuaternion):void {
			_lerpArray(left.elements, right.elements, amount, out.elements);
		}
		
		/**
		 * 计算两个四元数的和
		 * @param	left  left四元数
		 * @param	right right 四元数
		 * @param	out 输出四元数
		 */
		public static function add(left:*, right:ConchQuaternion, out:ConchQuaternion):void {
			var e:Float32Array = out.elements;
			var f:Float32Array = left.elements;
			var g:Float32Array = right.elements;
			
			e[0] = f[0] + g[0];
			e[1] = f[1] + g[1];
			e[2] = f[2] + g[2];
			e[3] = f[3] + g[3];
		}
		
		/**
		 * 计算两个四元数的点积
		 * @param	left left四元数
		 * @param	right right四元数
		 * @return  点积
		 */
		public static function dot(left:*, right:ConchQuaternion):Number {
			return _dotArray(left.elements,right.elements);
		}
		
		/**四元数元素数组*/
		public var elements:Float32Array;
		
		/**
		 * 获取四元数的x值
		 */
		public function get x():Number {
			return this.elements[0];
		}
		
		/**
		 * 设置四元数的x值
		 */
		public function set x(value:Number):void {
			this.elements[0] = value;
		}
		
		
		/**
		 * 获取四元数的y值
		 */
		public function get y():Number {
			return this.elements[1];
		}
		
		/**
		 * 设置四元数的y值
		 */
		public function set y(value:Number):void {
			this.elements[1] = value;
		}
		
		
		/**
		 * 获取四元数的z值
		 */
		public function get z():Number {
			return this.elements[2];
		}
		
		/**
		 * 设置四元数的z值
		 */
		public function set z(value:Number):void {
			this.elements[2] = value;
		}
		
		
		/**
		 * 获取四元数的w值
		 */
		public function get w():Number {
			return this.elements[3];
		}
		
		/**
		 * 设置四元数的w值
		 */
		public function set w(value:Number):void {
			this.elements[3] = value;
		}
		
		
		/**
		 * 创建一个 <code>Quaternion</code> 实例。
		 * @param	x 四元数的x值
		 * @param	y 四元数的y值
		 * @param	z 四元数的z值
		 * @param	w 四元数的w值
		 */
		public function ConchQuaternion(x:Number = 0, y:Number = 0, z:Number = 0, w:Number = 1, nativeElements:Float32Array = null/*[NATIVE]*/) {
			var v:Float32Array;
			if (nativeElements) {///*[NATIVE]*/
				v = nativeElements;
			} else {
				v = new Float32Array(4);
			}
			
			v[0] = x;
			v[1] = y;
			v[2] = z;
			v[3] = w;
			elements = v;	
		}
		
		/**
		 * 根据缩放值缩放四元数
		 * @param	scale 缩放值
		 * @param	out 输出四元数
		 */
		public function scaling(scaling:Number, out:ConchQuaternion):void {
			var e:Float32Array = out.elements;
			var f:Float32Array = this.elements;
			
			e[0] = f[0] * scaling;
			e[1] = f[1] * scaling;
			e[2] = f[2] * scaling;
			e[3] = f[3] * scaling;
		}
		
		/**
		 * 归一化四元数
		 * @param	out 输出四元数
		 */
		public function normalize(out:ConchQuaternion):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			_normalizeArray(elements, out.elements);
		}
		
		/**
		 * 计算四元数的长度
		 * @return  长度
		 */
		public function length():Number {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var f:Float32Array = this.elements;
			
			var x:Number = f[0], y:Number = f[1], z:Number = f[2], w:Number = f[3];
			return Math.sqrt(x * x + y * y + z * z + w * w);
		}
		
		/**
		 * 根据绕X轴的角度旋转四元数
		 * @param	rad 角度
		 * @param	out 输出四元数
		 */
		public function rotateX(rad:Number, out:ConchQuaternion):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var e:Float32Array = out.elements;
			var f:Float32Array = this.elements;
			
			rad *= 0.5;
			
			var ax:Number = f[0], ay:Number = f[1], az:Number = f[2], aw:Number = f[3];
			var bx:Number = Math.sin(rad), bw:Number = Math.cos(rad);
			
			e[0] = ax * bw + aw * bx;
			e[1] = ay * bw + az * bx;
			e[2] = az * bw - ay * bx;
			e[3] = aw * bw - ax * bx;
		}
		
		/**
		 * 根据绕Y轴的制定角度旋转四元数
		 * @param	rad 角度
		 * @param	out 输出四元数
		 */
		public function rotateY(rad:Number, out:ConchQuaternion):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var e:Float32Array = out.elements;
			var f:Float32Array = this.elements;
			
			rad *= 0.5;
			
			var ax:Number = f[0], ay:Number = f[1], az:Number = f[2], aw:Number = f[3], by:Number = Math.sin(rad), bw:Number = Math.cos(rad);
			
			e[0] = ax * bw - az * by;
			e[1] = ay * bw + aw * by;
			e[2] = az * bw + ax * by;
			e[3] = aw * bw - ay * by;
		}
		
		/**
		 * 根据绕Z轴的制定角度旋转四元数
		 * @param	rad 角度
		 * @param	out 输出四元数
		 */
		public function rotateZ(rad:Number, out:ConchQuaternion):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var e:Float32Array = out.elements;
			var f:Float32Array = this.elements;
			
			rad *= 0.5;
			
			var ax:Number = f[0], ay:Number = f[1], az:Number = f[2], aw:Number = f[3], bz:Number = Math.sin(rad), bw:Number = Math.cos(rad);
			
			e[0] = ax * bw + ay * bz;
			e[1] = ay * bw - ax * bz;
			e[2] = az * bw + aw * bz;
			e[3] = aw * bw - az * bz;
		}
		
		/**
		 * 分解四元数到欧拉角（顺序为Yaw、Pitch、Roll），参考自http://xboxforums.create.msdn.com/forums/p/4574/23988.aspx#23988,问题绕X轴翻转超过±90度时有，会产生瞬间反转
		 * @param	quaternion 源四元数
		 * @param	out 欧拉角值
		 */
		public function getYawPitchRoll(out:ConchVector3):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			ConchVector3.transformQuat(ConchVector3.ForwardRH, this, TEMPVector31/*forwarldRH*/);
			
			ConchVector3.transformQuat(ConchVector3.Up, this, TEMPVector32/*up*/);
			var upe:Float32Array = TEMPVector32.elements;
			
			angleTo(ConchVector3.ZERO, TEMPVector31, TEMPVector33/*angle*/);
			var anglee:Float32Array = TEMPVector33.elements;
			
			if (anglee[0] == Math.PI / 2) {
				anglee[1] = arcTanAngle(upe[2], upe[0]);
				anglee[2] = 0;
			} else if (anglee[0] == -Math.PI / 2) {
				anglee[1] = arcTanAngle(-upe[2], -upe[0]);
				anglee[2] = 0;
			} else {
				Matrix4x4.createRotationY(-anglee[1], TEMPMatrix0);
				Matrix4x4.createRotationX(-anglee[0], TEMPMatrix1);
				
				ConchVector3.transformCoordinate(TEMPVector32, TEMPMatrix0, TEMPVector32);
				ConchVector3.transformCoordinate(TEMPVector32, TEMPMatrix1, TEMPVector32);
				anglee[2] = arcTanAngle(upe[1], -upe[0]);
			}
			
			// Special cases.
			if (anglee[1] <= -Math.PI)
				anglee[1] = Math.PI;
			if (anglee[2] <= -Math.PI)
				anglee[2] = Math.PI;
			
			if (anglee[1] >= Math.PI && anglee[2] >= Math.PI) {
				anglee[1] = 0;
				anglee[2] = 0;
				anglee[0] = Math.PI - anglee[0];
			}
			
			var oe:Float32Array = out.elements;
			oe[0] = anglee[1];
			oe[1] = anglee[0];
			oe[2] = anglee[2];
		}
		
		/**
		 * 求四元数的逆
		 * @param	out  输出四元数
		 */
		public function invert(out:ConchQuaternion):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var e:Float32Array = out.elements;
			var f:Float32Array = this.elements;
			
			var a0:Number = f[0], a1:Number = f[1], a2:Number = f[2], a3:Number = f[3];
			var dot:Number = a0 * a0 + a1 * a1 + a2 * a2 + a3 * a3;
			var invDot:Number = dot ? 1.0 / dot : 0;
			
			// TODO: Would be faster to return [0,0,0,0] immediately if dot == 0
			e[0] = -a0 * invDot;
			e[1] = -a1 * invDot;
			e[2] = -a2 * invDot;
			e[3] = a3 * invDot;
		}
		
		/**
		 *设置四元数为单位算数
		 * @param out  输出四元数
		 */
		public function identity():void {
			var e:Float32Array = this.elements;
			e[0] = 0;
			e[1] = 0;
			e[2] = 0;
			e[3] = 1;
		}
		
		/**
		 * 从Array数组拷贝值。
		 * @param  array 数组。
		 * @param  offset 数组偏移。
		 */
		public function fromArray(array:Array, offset:int = 0):void {
			elements[0] = array[offset + 0];
			elements[1] = array[offset + 1];
			elements[2] = array[offset + 2];
			elements[3] = array[offset + 3];
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:*):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var i:int, s:Float32Array, d:Float32Array;
			s = this.elements;
			d = destObject.elements;
			if (s === d) {
				return;
			}
			for (i = 0; i < 4; ++i) {
				d[i] = s[i];
			}
		}
		
		/**
		 * 克隆。
		 * @return	 克隆副本。
		 */
		public function clone():* {
			var dest:ConchQuaternion = __JS__("new this.constructor()");
			cloneTo(dest);
			return dest;
		}
		
		public function equals(b:ConchQuaternion):Boolean {
			
			var ae:Float32Array = this.elements;
			var be:Float32Array = b.elements;
			
			return MathUtils3D.nearEqual(ae[0], be[0]) && MathUtils3D.nearEqual(ae[1], be[1]) && MathUtils3D.nearEqual(ae[2], be[2]) && MathUtils3D.nearEqual(ae[3], be[3]);
		}
		
		/**
		 * 计算旋转观察四元数
		 * @param	forward 方向
		 * @param	up     上向量
		 * @param	out    输出四元数
		 */
		public static function rotationLookAt(forward:ConchVector3, up:ConchVector3, out:ConchQuaternion):void {
			lookAt(ConchVector3.ZERO, forward, up, out);
		}
		
		/**
		 * 计算观察四元数
		 * @param	eye    观察者位置
		 * @param	target 目标位置
		 * @param	up     上向量
		 * @param	out    输出四元数
		 */
		public static function lookAt(eye:*, target:*, up:*, out:ConchQuaternion):void {
			Matrix3x3.lookAt(eye, target, up, _tempMatrix3x3);
			rotationMatrix(_tempMatrix3x3, out);
		}
		
		/**
		 * 计算长度的平方。
		 * @return 长度的平方。
		 */
		public function lengthSquared():Number {
			var x:Number = elements[0];
			var y:Number = elements[1];
			var z:Number = elements[2];
			var w:Number = elements[3];
			return (x * x) + (y * y) + (z * z) + (w * w);
		}
		
		/**
		 * 计算四元数的逆四元数。
		 * @param	value 四元数。
		 * @param	out 逆四元数。
		 */
		public static function invert(value:ConchQuaternion, out:ConchQuaternion):void {
			var vE:Float32Array = value.elements;
			var oE:Float32Array = out.elements;
			var lengthSq:Number = value.lengthSquared();
			if (!MathUtils3D.isZero(lengthSq)) {
				lengthSq = 1.0 / lengthSq;
				
				oE[0] = -vE[0] * lengthSq;
				oE[1] = -vE[1] * lengthSq;
				oE[2] = -vE[2] * lengthSq;
				oE[3] = vE[3] * lengthSq;
			}
		}
		
		/**
		 * 通过一个3x3矩阵创建一个四元数
		 * @param	matrix3x3  3x3矩阵
		 * @param	out        四元数
		 */
		public static function rotationMatrix(matrix3x3:Matrix3x3, out:ConchQuaternion):void {
			var me:Float32Array = matrix3x3.elements;
			var m11:Number = me[0];
			var m12:Number = me[1];
			var m13:Number = me[2];
			var m21:Number = me[3];
			var m22:Number = me[4];
			var m23:Number = me[5];
			var m31:Number = me[6];
			var m32:Number = me[7];
			var m33:Number = me[8];
			
			var oe:Float32Array = out.elements;
			
			var sqrt:Number, half:Number;
			var scale:Number = m11 + m22 + m33;
			
			if (scale > 0) {
				
				sqrt = Math.sqrt(scale + 1);
				oe[3] = sqrt * 0.5;
				sqrt = 0.5 / sqrt;
				
				oe[0] = (m23 - m32) * sqrt;
				oe[1] = (m31 - m13) * sqrt;
				oe[2] = (m12 - m21) * sqrt;
				
			} else if ((m11 >= m22) && (m11 >= m33)) {
				
				sqrt = Math.sqrt(1 + m11 - m22 - m33);
				half = 0.5 / sqrt;
				
				oe[0] = 0.5 * sqrt;
				oe[1] = (m12 + m21) * half;
				oe[2] = (m13 + m31) * half;
				oe[3] = (m23 - m32) * half;
			} else if (m22 > m33) {
				
				sqrt = Math.sqrt(1 + m22 - m11 - m33);
				half = 0.5 / sqrt;
				
				oe[0] = (m21 + m12) * half;
				oe[1] = 0.5 * sqrt;
				oe[2] = (m32 + m23) * half;
				oe[3] = (m31 - m13) * half;
			} else {
				
				sqrt = Math.sqrt(1 + m33 - m11 - m22);
				half = 0.5 / sqrt;
				
				oe[0] = (m31 + m13) * half;
				oe[1] = (m32 + m23) * half;
				oe[2] = 0.5 * sqrt;
				oe[3] = (m12 - m21) * half;
			}
		}
	}
}
