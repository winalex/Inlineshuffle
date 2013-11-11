package  
{
	import alternativa.engine3d.alternativa3d;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Resource;
	import alternativa.engine3d.core.Sound3D;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.MovieMaterial;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.primitives.Box;
	import alternativa.engine3d.resources.BitmapTextureResource;
	import alternativa.engine3d.resources.Geometry;
	import flash.display.Bitmap;
	import flash.display.Stage3D;
	
	use namespace alternativa3d;
	/**
	 * ...
	 * @author winxalex
	 */
	public class BoardScene extends BasicScene
	{
		private var _scoreBoard:ScoreBoard;
		
		public function BoardScene(stage3D:Stage3D,camera:Camera3D, config:XML=null) :void
		{
			super(stage3D,camera,config);
		}
		
		override public function loadScene(readyCallback:Function):void 
		{
			super.loadScene(readyCallback);
			
			var texture:BitmapTextureResource;	
			
				texture=new BitmapTextureResource(new BoardTexture(),true);
				assetsDictionary["BoardTexture"] = new TextureMaterial(texture);
				texture.upload(stage3D.context3D); //add to context3D
				
				texture = new BitmapTextureResource(new PuckBTexture(),true);
				assetsDictionary["PuckBTexture" ] = new TextureMaterial(texture);
				texture.upload(stage3D.context3D); //add to context3D
				
				texture = new BitmapTextureResource(new PuckRTexture(),true);
				assetsDictionary["PuckRTexture" ] = new TextureMaterial(texture);
				texture.upload(stage3D.context3D); //add to context3D
				
				
				_scoreBoard = new ScoreBoard(new MovieMaterial(new ScoreBoardMovieClipAsset(),false));
				_scoreBoard.x = 0;
				_scoreBoard.y = 200;
				_scoreBoard.z = -200;
				_scoreBoard.update();
				
				
				addChild(_scoreBoard);
				
				
				/*var box:Box = new Box(100, 100, 100, 1, 1, 1);
				var material:FillMaterial = new FillMaterial(0xFF7700);
				box.setMaterialToAllSurfaces(material);
				addChild(box);*/
				
				
				
				
				for each (var resource:Resource in this.getResources(true)) {
				resource.upload(stage3D.context3D);
			}
								
				addSounds();
				
				
				//notify that SCENE is READY
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
		
	}

}