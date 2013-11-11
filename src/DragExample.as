package
{
	import alternativa.engine3d.core.events.MouseEvent3D;
	import alternativa.engine3d.core.RayIntersectionData;
	import alternativa.engine3d.objects.WireFrame;
	import alternativa.engine3d.primitives.Cylinder;
	import alternativa.engine3d.primitives.Plane;
	import alternativa.utils.Properties;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import alternativa.engine3d.primitives.Box;
	import alternativa.engine3d.core.Resource;
	import alternativa.engine3d.controllers.SimpleObjectController;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.View;
	import alternativa.engine3d.materials.FillMaterial;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author David E Jones
	 */
	public class DragExample extends Sprite
	{
		private var scene:Object3D = new Object3D();
		private var camera:Camera3D;
		private var controller:SimpleObjectController;
		private var stage3D:Stage3D;
		private var box:Object3D; // Box;
		private var boxSelected:Boolean = false;
		private var startPoint:Vector3D;
		private var plane:Plane;
		private var wire:WireFrame;
		private var wireContainer:Object3D;
		
		public function DragExample():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			camera = new Camera3D(1, 100000);
			camera.rotationX = -120 * Math.PI / 180; //120
			camera.x = 0;
			camera.y = -200;
			camera.z = 400; // -800;
			camera.view = new View(stage.stageWidth, stage.stageHeight, false, 0, 0, 4);
			camera.view.backgroundColor = 0x000000;
			camera.debug = true;
			addChild(camera.view);
			addChild(camera.diagram);
			
			   controller = new SimpleObjectController(stage, camera, 200);
			   controller.unbindAll();
			   controller.unbindKey(73);
			   controller.unbindKey(75);
			   controller.bindKey(73, SimpleObjectController.ACTION_PITCH_UP);
			 controller.bindKey(75, SimpleObjectController.ACTION_PITCH_DOWN);/**/
			
			/*	controller.lookAt(new Vector3D(0,0,0));*/
			scene.addChild(camera);
			
			stage3D = stage.stage3Ds[0];
			stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreate);
			stage3D.requestContext3D();
		}
		
		private function onContextCreate(e:Event):void
		{
			stage3D.removeEventListener(Event.CONTEXT3D_CREATE, onContextCreate);
			
			plane = new Plane(150, 150, 1, 1);
			plane.setMaterialToAllSurfaces(new FillMaterial(0x00FF00));
			//	plane.rotationX =-45 * Math.PI / 180;
			//plane.y = -50;
			scene.addChild(plane);
			uploadResources(plane.getResources(true));
			
			box = new Box(10, 40, 60, 1, 1, 1, false, new FillMaterial(0xCCCCCC));
			scene.addChild(box);
			uploadResources(box.getResources(true));
			//box = new Box(100, 100, 100, 1, 1, 1, false, null);
			//box = new Cylinder(15, 15, 150, 16, 1, 1, 1, 1, false, new FillMaterial(0xFF0000));
			box = new Puck(new Player("GUEST",new FillMaterial(0xFF0000)), InlineShuffle.PuckDiameter * 0.5, InlineShuffle.PuckHeight, 8, 6, 100);
			var material:FillMaterial = new FillMaterial(0xFF0000);
			//box.setMaterialToAllSurfaces(material);
			//box.z =-150;
			scene.addChild(box);
			box.y = 50;
			box.z = Puck(box).height*0.5;
			uploadResources(box.getResources(true));
			
			box.addEventListener(MouseEvent3D.MOUSE_DOWN, onMouseDown);
			
			addWireXY(1500, 1500);
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(Event.RESIZE, onResize);
			onResize();
		}
		
		private function addWireXY(sizeX:Number, sizeY:Number,axisLength:Number=1000):void
		{
			
			var i:int;
			
			var lines:Vector.<Vector3D> = new Vector.<Vector3D>();
			
			var size:Number = 10;
			
			var length:int = sizeX / size;
			
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
			
			wireContainer = new Object3D();
		
			scene.addChild(wireContainer);
			
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
		
		private function onMouseDown(e:MouseEvent3D):void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			var object:Object3D = e.target as Object3D;
			var origin:Vector3D = new Vector3D();
			var direction:Vector3D = new Vector3D();
			
			// This calculate ray from camera to mouse cursor.
			camera.calculateRay(origin, direction, stage.mouseX, stage.mouseY);
			
			// You can test where ray hits.
			
			var data:RayIntersectionData = object.parent.intersectRay(origin, direction);
			
			
			if (data != null)
			{
				startPoint = data.point;
				trace("click in");
			}
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
			if (startPoint != null)
			{
				var origin:Vector3D = new Vector3D;
				var directionA:Vector3D = new Vector3D;
				var directionB:Vector3D = new Vector3D;
				var direction:Vector3D = new Vector3D;
				
				camera.calculateRay(origin, directionA, camera.view.width / 2, camera.view.height / 2);
				camera.calculateRay(origin, directionB, mouseX, mouseY);
				
				var pos:Vector3D = intersectionPoint(origin, directionB, new Vector3D(0, startPoint.y, Puck(box).height), new Vector3D(0, 0, 1));
				box.x = pos.x-startPoint.x;
				box.y = pos.y-startPoint.y;
			//	box.z = pos.z - startPoint.z;
				/*box.x = pos.x - startPoint.x;
				box.y = pos.z - startPoint.z;*/
					//box.z = pos.z - startPoint.z;
			}
		}
		
		public static function intersectionPoint(lineStart:Vector3D, lineDirection:Vector3D, planePosition:Vector3D, planeNormal:Vector3D):Vector3D
		{
			
			var result:Vector3D = new Vector3D();
			var w:Vector3D = lineStart.subtract(planePosition);
			var d:Number = planeNormal.dotProduct(lineDirection);
			var n:Number = -planeNormal.dotProduct(w);
			
			if (Math.abs(d) < 0.0000001)
				return result;
			
			var sI:Number = n / d;
			
			result.x = lineStart.x + (lineDirection.x * sI);
			result.y = lineStart.y + (lineDirection.y * sI);
			result.z = lineStart.z + (lineDirection.z * sI);
			
			return result;
		}
		
		private function onMouse9Move(e:MouseEvent3D):void
		{
			if (boxSelected)
			{
				var object:Object3D = e.target as Object3D;
					//var target:Vector3D = object.localToGlobal(new Vector3D(e.localX, e.localY, e.localZ));
					//var target:Vector3D = object.globalToLocal(new Vector3D(e.localX, e.localY, e.localZ));
					//object.x = e.localX;
					//object.y = e.localY;
					//object.z = object.z;
					//object.x = target.x;
					//object.y = target.y;
					//object.z = target.z;
					//trace(box.x);
					//trace(e.localX);
					//trace(target.x);
			}
		}
		
		private function onClick(e:MouseEvent3D):void
		{
			var box:Box = new Box(50, 50, 50, 1, 1, 1, false, new FillMaterial(0xFF0000));
			box.x = e.localX;
			box.y = e.localY;
			box.z = e.localZ + 25;
			scene.addChild(box);
			
			uploadResources(box.getResources());
		}
		
		private function uploadResources(resources:Vector.<Resource>):void
		{
			for each (var resource:Resource in resources)
			{
				if(!resource.isUploaded)
				resource.upload(stage3D.context3D);
			}
		}
		
		private function onEnterFrame(e:Event):void
		{
			if (boxSelected)
			{
				
			}
			
			//plane.rotationX += 5 * Math.PI / 180;
			//plane.z += 2;
			//controller.update();
			camera.render(stage3D);
			//trace(camera.rotationX * 180 / Math.PI, camera.rotationY * 180 / Math.PI, camera.rotationZ * 180 / Math.PI);
			//trace("x:",camera.x,"y:",camera.y,"z:",camera.z);
		}
		
		private function onResize(e:Event = null):void
		{
			camera.view.width = stage.stageWidth;
			camera.view.height = stage.stageHeight;
		}
	
	}

}