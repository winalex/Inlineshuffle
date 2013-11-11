package
{
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Resource;
	import alternativa.engine3d.core.Sound3D;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.MovieMaterial;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.primitives.Box;
	import alternativa.engine3d.primitives.Plane;
	import alternativa.engine3d.resources.BitmapTextureResource;
	import alternativa.engine3d.resources.Geometry;
	import flash.display.Stage3D;
	
	/**
	 * ...
	 * @author winxalex
	 */
	public class MainScene extends BasicScene
	{
		
		private var _scoreBoard:ScoreBoard;
		private var _frontWallPlane:Wall;
		
		public function MainScene(stage3D:Stage3D, camera:Camera3D, config:XML = null):void
		{
			super(stage3D, camera, config);
		
		}
		
		
	
		
		override public function loadScene(readyCallback:Function):void
		{
			super.loadScene(readyCallback);
			
			// Primitive box
			// Создание примитива
			/*var box:Box = new Box(500, 500, 500, 1, 1, 1);
			   var material:FillMaterial = new FillMaterial(0xFF7700);
			   box.setMaterialToAllSurfaces(material);
			 this.addChild(box);*/
			
			var texture:BitmapTextureResource;
			
			texture = new BitmapTextureResource(new BoardTexture(), true);
			assetsDictionary["BoardTexture"] = new TextureMaterial(texture);
			texture.upload(stage3D.context3D); //add to context3D
			
			texture = new BitmapTextureResource(new PuckBTexture(), true);
			assetsDictionary["PuckBTexture"] = new TextureMaterial(texture);
			texture.upload(stage3D.context3D); //add to context3D
			
			texture = new BitmapTextureResource(new PuckRTexture(), true);
			assetsDictionary["PuckRTexture"] = new TextureMaterial(texture);
			texture.upload(stage3D.context3D); //add to context3D
			
			texture = new BitmapTextureResource(new PuckRTexture(), true);
			assetsDictionary["ShooterTexture"] = new TextureMaterial(texture);
			texture.upload(stage3D.context3D); //add to context3D
			
			_scoreBoard = new ScoreBoard(new MovieMaterial(new ScoreBoardMovieClipAsset(), false));
			_scoreBoard.x = 0;
			_scoreBoard.y = 600;
			_scoreBoard.z = 200;
			_scoreBoard.rotationX = 90 * Math.PI / 180;
			_scoreBoard.update();
			
			addChild(_scoreBoard);
			
			var gameBoardPlane:Plane = new Plane(InlineShuffle.BOARD_WIDTH, InlineShuffle.BOARD_LENGTH, 1, 1, false, false, null, new TextureMaterial(new BitmapTextureResource(new BoardTexture(), true))); ////,gameBoardPlaneMaterial,600,800,20,20);
			gameBoardPlane.x = 0;
			gameBoardPlane.y = 400;
			gameBoardPlane.z = 0; // +50;
			//gameBoardPlane.rotationX = -90 * Math.PI / 180;
			//TODO check if this 50 is implemented in
			//half height and -50 cos of powerboard
			//scene.addChild(gameBoardPlane);
			this.addChild(gameBoardPlane);
			
			
			//_frontWallPlane = new Plane(600, InlineShuffle.BOARD_WIDTH, 1, 1, false, false, null, new TextureMaterial(new BitmapTextureResource(new WoodTexture(), true)));
			_frontWallPlane = new Wall(600, InlineShuffle.BOARD_WIDTH, 1, 1, new TextureMaterial(new BitmapTextureResource(new WoodTexture(), true)));
			_frontWallPlane.x = 0;
			_frontWallPlane.y = 800;
			_frontWallPlane.z = 200; // + 50;
			_frontWallPlane.rotationX = 90 * Math.PI / 180;
			this.addChild(_frontWallPlane);
			
			for each (var resource:Resource in this.getResources(true))
			{
				resource.upload(stage3D.context3D);
			}
			
			addSounds();
			
			readyCallback.apply();
		
		}
		
		private function addSounds():void
		{
			this.sound3DController.addChild(new Sound3D(new PuckSlideSound(), "PuckSlideSound", 800));
			this.sound3DController.addChild(new Sound3D(new PuckCrackSound(), "PuckCrackSound", 800));
			this.sound3DController.addChild(new Sound3D(new BuzzSound(), "BuzzSound", 800));
			this.sound3DController.addChild(new Sound3D(new BeepSound(), "BeepSound", 800));
			this.sound3DController.addChild(new Sound3D(new WallHitSound(), "WallHitSound", 800));
			this.sound3DController.addChild(new Sound3D(new ShooterSound(), "ShooterSound", 200));
		
			//TODO  add spectators sounds claping,miss disapointments....
		
		}
		
		public function get scoreBoard():ScoreBoard
		{
			return _scoreBoard;
		}
		
		public function get frontWallPlane():Wall 
		{
			return _frontWallPlane;
		}
	
	}

}