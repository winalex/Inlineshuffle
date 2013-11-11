/**
* ...
* @author Default
* @version 0.1
*/

package  {
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.primitives.Plane;
	import flash.geom.Vector3D;
	
	public class Wall extends Plane{
		
		
		public var hasCollidedWith:int=-1;
		public var hasStopped:Boolean = true;
		public var mass:Number = 1000000; //Number.MAX_VALUE Number.POSITIVE_INFINITY;
		public var speed:Vector3D;
		public var accel:Vector3D;
		
		protected var _id:int = Number.NaN;
		
		public function Wall(w:Number,h:Number,segW:uint=1,segH:uint=1,material:Material=null):void 
		{
			super(w, h, segW, segH, false, false, null, material);
			
			this.speed = new Vector3D();//0,0,0
			this.accel = new Vector3D();//0,0,0
		}
		
		public function get id():int 
		{
			return this.parent.getChildIndex(this);
		}
		
		
		
	}
	
}
