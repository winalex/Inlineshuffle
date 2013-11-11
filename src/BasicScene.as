/**
* ...
* @author winxalex
* @version 0.1
*/

package  {
	import alternativa.engine3d.controllers.SimpleObjectController;
	import alternativa.engine3d.controllers.Sound3DController;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Resource;
	import alternativa.engine3d.lights.AmbientLight;
	import alternativa.engine3d.lights.DirectionalLight;
	import alternativa.engine3d.objects.WireFrame;
	import alternativa.engine3d.resources.BitmapTextureResource;
	import flash.display.Stage3D;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;

	


	public class BasicScene extends Object3D {
		
		
		private var _readyCallback:Function;
		private var __stage3D:Stage3D;
		
		private var ambiLight:AmbientLight;
		private var dirLight:DirectionalLight;
		
		public var assetsDictionary:Dictionary;
		
		private var __sound3DController:Sound3DController;
		private var __camera:Camera3D;
		private var __simpleObjectController:SimpleObjectController;
		
		
		public function get sound3DController():Sound3DController 
		{
			return __sound3DController;
		}
		
		
		public function get camera():Camera3D 
		{
			return __camera;
		}
		
		public function get stage3D():Stage3D 
		{
			return __stage3D;
		}
		
		public function get simpleObjectController():SimpleObjectController 
		{
			return __simpleObjectController;
		}
		
		public function set simpleObjectController(value:SimpleObjectController):void 
		{
			__simpleObjectController = value;
		}
		
		/*public function set camera(value:Camera3D):void 
		{
			if(__camera)
			__scene.removeChild(__camera);
			
			__camera = value;
			__camera.view = this;
			__scene.addChild(__camera);
			__scene.sound3DController.camera = camera;
			
			
		}*/
		
		
		//TODO load config,load collada, materials 
		public function BasicScene(stage3D:Stage3D,camera:Camera3D, config:XML = null):void {
			
			__camera = camera;
			
			
			
			this.addChild(camera);
			
			__stage3D = stage3D;
			
			//Assets
			assetsDictionary = new Dictionary(true);
			
			//Sound3D
			__sound3DController = new Sound3DController(camera);
			
			
			
		}
		
			
		public function loadScene(readyCallback:Function):void
		{
			
			_readyCallback = readyCallback;
			
			
					//Setup light
					addLights();
					
		
					
				
			
		}
		
		
		
		public function addToScene(child:Object3D):Object3D 
		{
			uploadResources(child.getResources());
			
			return super.addChild(child);
		}
		
		
		public function uploadResources(resources:Vector.<Resource>):void {
			for each (var resource:Resource in resources) {
				if(!resource.isUploaded)
				resource.upload(stage3D.context3D);
			}
		}
		
		
		public function addWireXY(sizeX:Number, sizeY:Number,axisLength:Number=1000):void
		{
			
			var i:int;
			
			var wire:Object3D;
			
			var lines:Vector.<Vector3D> = new Vector.<Vector3D>();
			
			var size:Number = 10;
			
			var length:int = sizeX / size;
			
			var wireContainer:Object3D = new Object3D();
			
			for (i = 0; i <= length; i++)
			{
				
				lines.push(new Vector3D(i * size, 0, 0));
				
				lines.push(new Vector3D(i * size, sizeY, 0));
				
			}
			
			length = sizeY / size;
			
			for (i = 0; i <= length; i++)
			{
				
				lines.push(new Vector3D(0, i * size, 0));
				
				lines.push(new Vector3D(sizeX, i * size, 0));
				
			}
			
			
		
			this.addChild(wireContainer);
			
			wire = WireFrame.createLinesList(lines, 0x4b4b4b, 0.8, 0.5);
						
			wireContainer.addChild(wire);
			
			wire.x = -sizeX / 2;
			
			wire.y = -sizeY / 2;
			
			uploadResources(wire.getResources());
			
			
			lines = Vector.<Vector3D>([new Vector3D(), new Vector3D(axisLength, 0, 0)]);
			
			wire = WireFrame.createLinesList(lines, 0xFF0000, 1, 1);
			wireContainer.addChild(wire);
			uploadResources(wire.getResources());
			
			lines[1].x = 0;
			lines[1].y = axisLength;
			wire = WireFrame.createLinesList(lines, 0x00FF00, 1, 1);
			wireContainer.addChild(wire);
			uploadResources(wire.getResources());
			
			lines[1].y = 0;
			lines[1].z = axisLength;
			wire = WireFrame.createLinesList(lines, 0x0000FF, 1, 1);
			wireContainer.addChild(wire);
			uploadResources(wire.getResources());
			
		
		
		}
		
		
		public function addLights():void 
		{ 
			//ligths
			
			ambiLight = new AmbientLight(0xc0d0f0);
			this.addChild(ambiLight); 
			
			dirLight = new DirectionalLight(0xFFFFFF); 
			dirLight.intensity = 1.5; 
			dirLight.y = -500; 
			dirLight.z = 500; 
			dirLight.lookAt(0, 0, 0); 
			this.addChild(dirLight); /**/
		}
		
		public function render():void 
		{
			if(__simpleObjectController) __simpleObjectController.update();
			//__sound3DController.update();
			__camera.render(__stage3D);
			
			//trace(__camera.x,__camera.y,__camera.z,__camera.rotationX);
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
	
}
