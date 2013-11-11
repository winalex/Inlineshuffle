package  {

	import alternativa.engine3d.controllers.SimpleObjectController;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Resource;
	import alternativa.engine3d.core.View;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.primitives.Box;

	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	/**
	 * Alternativa3D "Hello world!" application. 
	 * Создание простейшего трёхмерного приложения.
	 */
	public class HelloAlternativa3D extends Sprite {
		
		private var rootContainer:Object3D ;//= new Object3D();
		
		private var camera:Camera3D;
		private var stage3D:Stage3D;
		
		private var box:Box;
		
		public function HelloAlternativa3D() {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			// Camera and view
			// Создание камеры и вьюпорта
			camera = new Camera3D(0.1, 10000);
			//camera.view = new View(stage.stageWidth, stage.stageHeight, false, 0, 0, 4);
			camera.view = new BasicView(stage.stageWidth, stage.stageHeight);
			
			//var mainScene:MainScene
			addChild(camera.view);
			addChild(camera.diagram);
			
			// Initial position
			// Установка положения камеры
			camera.rotationX =120*Math.PI/180;
			camera.y =400;
			camera.z = 300;
			/*rootContainer.addChild(camera);
			
			
			// Primitive box
			// Создание примитива
			box = new Box(500, 500, 500, 1, 1, 1);
			var material:FillMaterial = new FillMaterial(0xFF7700);
			box.setMaterialToAllSurfaces(material);
			rootContainer.addChild(box);*/
			
			stage3D = stage.stage3Ds[1];
			stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreate);
			stage3D.requestContext3D();
		}
		
		private function onContextCreate(e:Event):void {
			
			rootContainer = new BoardScene(stage3D, camera);
			
			
			/*for each (var resource:Resource in rootContainer.getResources(true)) {
				resource.upload(stage3D.context3D);
			}*/
			
			BoardScene(rootContainer).loadScene(onLoadScene);
			
			
			
		}
		
		private function onLoadScene():void 
		{
			// Listeners
			// Подписка на события
		//	stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			//BoardScene(rootContainer).render();
			BasicView(camera.view).scene = BasicScene(rootContainer);
			BasicView(camera.view).scene.simpleObjectController = new SimpleObjectController(stage, camera, 100);
			BasicView(camera.view).startRendering();
		}
		
		
		
		
		
		private function onEnterFrame(e:Event):void {
			// Width and height of view
			// Установка ширины и высоты вьюпорта
			//camera.view.width = stage.stageWidth;
			//camera.view.height = stage.stageHeight;
			
			// Rotation
			// Вращение примитива
			//box.rotationZ -= 0.01;
			
			// Render
			// Отрисовка
			//camera.render(stage3D);
			trace(camera.x, camera.y, camera.z, camera.rotationX, camera.rotationY);
			
		}
		
	}
}
