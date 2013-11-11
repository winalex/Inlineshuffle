/**
 * ...
 * @author Default
 * @version 0.1
 */

package
{
	import alternativa.Alternativa3D;
	import alternativa.engine3d.controllers.SimpleObjectController;
	import alternativa.engine3d.core.Sound3D;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.materials.MovieMaterial;
	import alternativa.engine3d.primitives.Plane;
	
	import com.demonsters.debugger.MonsterDebugger;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.geom.Vector3D;
	import flash.media.SoundTransform;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Resource;
	import alternativa.engine3d.core.View;
	
	import alternativa.engine3d.alternativa3d;
	use namespace alternativa3d;
	
	import flash.events.Event;
	
	import caurina.transitions.Tweener;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class InlineShuffle
	{
		
		public static var PuckSpeed:Number = 50; // 30;
		public static var PuckDiameter:Number = 25; // 30;
		public static var PuckHeight:uint = 15;
		public static var Pucks:Vector.<Puck> = new Vector.<Puck>;
		public static var BoardFriction:Number = 0.35;
		
		
		public static const BOARD_LENGTH:uint = 800;
		public static const BOARD_WIDTH:uint = 600;
		
		public static var Gravity:Number = 2;
		public static var Acceleration:Number;
		public static var distanceFactor:Number = 2; //shooter drag / speed ratio
		
		public static const TIME_OUT:uint = 20;
		public static const SWIPE_OFFSET_Z:uint = 10;
		static public const MAX_DRAG_Y:uint = 100;
		
		public static var CurrentPlayer:Player;
		public static var Players:Vector.<Player> = new Vector.<Player>(2, true);
		
		public static var CurrentRound:uint = 1;
		public static var Rounds:uint = 5;
		
		public static var shooter:Shooter;
		public static var shootTimer:Timer;
		
		public static var PowerGrid:Plane;
		
		public static var stage:Stage;
		static private var camera:Camera3D;
		/*	public static var dynamicCamera:Camera3D;
		 public static var staticCamera:Camera3D;*/
		
		public static var scene:Object3D;
		public static var root:DisplayObject;
		public static var view:BasicView;
		
		/*	public static var view:BasicView;
		 public static var view:BasicView;*/
		
		public static var ScoreFields:Array = new Array;
		public static var ScoreFieldLineTickness:uint = 12;
		public static var scoreBoard:ScoreBoard;
		
		public static var buzzSound3D:Sound3D;
		public static var beepSound3D:Sound3D;
		public static var puckCrackSound3D:Sound3D;
		public static var puckWallHitSound3D:Sound3D;
		
		public static var hasAI:Boolean;
		public static var Rules:Array = new Array();
		
		private static var _messageTextField:TextField;
		private static var _messageWnd:MessageMovieClip;
		
		
		public static var _messageTimer:Timer;
		
		public static function init(view:BasicView/*, dynamicSceneView:BasicView*/):void
		{
			/*InlineShuffle.view = staticSceneView;
			 InlineShuffle.view = dynamicSceneView;*/
			InlineShuffle.view = view;
			InlineShuffle.root = view.root;
			
			/*InlineShuffle.dynamicCamera = dynamicSceneView.scene.camera;
			InlineShuffle.staticCamera = staticSceneView.scene.camera;*/
			InlineShuffle.camera = view.scene.camera;
			//dynamicCamera.lookAt(0, 0, 0);
			//staticCamera.lookAt(0, 0, 0);
			
			InlineShuffle.stage = view.stage;
			InlineShuffle.scene = view.scene;
			
			InlineShuffle.Acceleration = InlineShuffle.Gravity * InlineShuffle.BoardFriction;
			
			InlineShuffle.CreateGame();
		
		}
		
		public static function showMsgWindow(msg:String, duration:uint = 0):void
		{
			InlineShuffle._messageWnd.visible = true;
			InlineShuffle._messageTextField.text = msg;
			
			if (duration > 0)
			{
				if (!_messageTimer)
				{
					_messageTimer = new Timer(duration * 1000, 1);
					_messageTimer.addEventListener(TimerEvent.TIMER_COMPLETE, InlineShuffle.hideMsgWindow);
				}
				
				_messageTimer.start();
				
			}
		
		}
		
		public static function hideMsgWindow(e:TimerEvent):void
		{
			_messageTimer.reset();
			InlineShuffle._messageWnd.visible = false;
		
		}
		
		private static function CreateMsgWindow(w:uint, h:uint, x:Number, y:Number, center:Boolean = true):void
		{
			
			_messageWnd = new MessageMovieClip();
			_messageTextField = TextField(_messageWnd.getChildByName("messageTextField"));
			
			InlineShuffle.stage.addChild(_messageWnd)
			
			if (center)
			{
				_messageWnd.x = (InlineShuffle.stage.stageWidth - _messageWnd.width) / 2
				_messageWnd.y = (InlineShuffle.stage.stageHeight - _messageWnd.height) / 2;
			}
			else
			{
				_messageWnd.x = x;
				_messageWnd.y = y;
			}
		
		}
		
		////////////////////////////////////////////////////////
		//					CreateRules()
		///////////////////////////////////////////////////////
		private static function CreateRules():void
		{
		
			//
			//if AI shoot first shoot 8 (L|R)
			//if ifOpponenthasScore
		
			//RULE-1
			//if competitorPucksOn10>0 && ourPucksOn10>0
			//InlineShuffle.Rules.push(new Rule(WorkingMemory.hasPuckOn10, AI.shoot,4);
		
			//RULE-2
			//InlineShuffle.Rules.push(new Rule(WorkingMemory.hasPuckOn10=0, AI.,4);
		}
		
		/*protected function loadBitmap():void
		   {
		   material = new BitmapFileMaterial();
		   material.addEventListener(FileLoadEvent.LOAD_COMPLETE, handleFileLoaded);
		   material.texture = "rockOnFlashScreenshot.png"
		   }
		
		   protected function handleFileLoaded(e:FileLoadEvent):void
		   {
		   var plane:Plane = new Plane( material, 500, 500, 8, 8 );
		   scene.addChild(plane);
		
		   addEventListener(Event.ENTER_FRAME, loop);
		 }*/
		
		/*
		
		 }*/
		
		////////////////////////////////////////////////////////
		//					CreateGame()
		///////////////////////////////////////////////////////
		public static function CreateGame():void
		{
			
			//create msg window
			InlineShuffle.CreateMsgWindow(320, 40, 240, 280);
			
			//enviroment background
			//InlineShuffle.CreateEnvironmentBack();
			
			//create Score Fields 
			InlineShuffle.CreateScoreFields();
			
			//creat score board
			InlineShuffle.scoreBoard = MainScene(InlineShuffle.view.scene).scoreBoard;
			//InlineShuffle.scoreBoard = InlineShuffle.CreateScoreBoard();
			//InlineShuffle.view.scene.addChild(scoreBoard);
			
			//create and position global scene sounds 
			InlineShuffle.CreateSounds();
			
			//Timer
			InlineShuffle.shootTimer = new Timer(1000, 20);
			//update Score board every second
			InlineShuffle.shootTimer.addEventListener(TimerEvent.TIMER, InlineShuffle.countShootTime);
			//if player wasn't shoot for 20 sec
			InlineShuffle.shootTimer.addEventListener(TimerEvent.TIMER_COMPLETE, InlineShuffle.shootTimeComplete);
			
			//create shooter and load with puck BarScene.mtrList.getMaterialByName('shooter')
			InlineShuffle.shooter = InlineShuffle.CreateShooter(BasicScene(InlineShuffle.view.scene).assetsDictionary["ShooterTexture"], new Vector3D(0, 0, 49));
			InlineShuffle.view.scene.addChild(InlineShuffle.shooter);
			InlineShuffle.shooter.visible = false;
			
			//create shoot power grid
			//InlineShuffle.scene.addChild(InlineShuffle.CreatePowerGrid(600, 200));
			
			//
			//Tweener.addTween(InlineShuffle.camera, {rotationX:rot,z:zTo, time:time, delay:delay,transition:"easeOutQuint", onComplete:InlineShuffle.checkGameStatus});//
			
			//Tweener.addTween(InlineShuffle.camera, {rotationY: 1400, time: 300, transition: "easyNone"});
			
			switch (Game.type)
			{
				case Game.HotSeat: 
					InlineShuffle.CreatePlayers(new Player("GUEST", BasicScene(InlineShuffle.view.scene).assetsDictionary["PuckBTexture"]), new Player("HOME", BasicScene(InlineShuffle.view.scene).assetsDictionary["PuckRTexture"]));
					InlineShuffle.showMsgWindow("Press 'Spacebar' for start");
					InlineShuffle.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
					
					break;
				
				case Game.MULTI: 
					InlineShuffle.showMsgWindow("Joining Game.");
					var nick:String = InlineShuffle.root.loaderInfo.parameters.player;
					//debug only
					/*if (Game.debug)
					   {
					   if (!nick || nick == "")
					   nick= "nick" + Math.round(Math.random() * 1000);
					 }*/
					
					nick = "nick" + Math.round(Math.random() * 1000);
					
					if (!nick || nick == "")
						InlineShuffle.showMsgWindow("Not a member of www.i.com");
					//else
					//Multiplayer.init(new Player(nick, null, InlineShuffle.root.loaderInfo.parameters.playerid), InlineShuffle.startGame,);
					
					break;
				
				case Game.Single: 
					//InlineShuffle.CreatePlayers(new Player("GUEST", new MovieAssetMaterial("puckPlayer1Texture", false, true)), new AI(new MovieAssetMaterial("puckPlayer2Texture", false, true)));
					InlineShuffle.CreatePlayers(new Player("GUEST", BasicScene(InlineShuffle.view.scene).assetsDictionary["PuckBTexture"]), new AI(BasicScene(InlineShuffle.view.scene).assetsDictionary["PuckRTexture"]));
					//InlineShuffle.CreateRules();
					//AI.init();
					InlineShuffle.showMsgWindow("Press 'Spacebar' for start");
					InlineShuffle.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
					break;
			
			}
		
		}
		
		////////////////////////////////////////////////////////
		//					keyHandler()
		///////////////////////////////////////////////////////
		private static function keyHandler(e:KeyboardEvent):void
		{
			
			if (e.keyCode == Keyboard.SPACE && !Game.isStarted)
			{
				InlineShuffle.startGame();
			}
		}
		
		//TODO CreateEnvironmentBack is commented
		/*private static function CreateEnvironmentBack()
		   {
		   var envi:enviMap = new enviMap()
		   envi.name = "environment";
		   DisplayObjectContainer(view.root).addChildAt(envi, 0);
		   envi.x = 528;
		   envi.y = 257;
		 }*/
		
		////////////////////////////////////////////////////////
		//					CreatePlayers()
		///////////////////////////////////////////////////////
		public static function CreatePlayers(player1:Player, player2:Player, playingFirst:Player = null):void
		{
			
			InlineShuffle.Players[0] = player1;
			InlineShuffle.scoreBoard.player1 = player1.name;
			
			InlineShuffle.Players[1] = player2;
			InlineShuffle.scoreBoard.player2 = player2.name;
			
			if (!playingFirst){
				InlineShuffle.CurrentPlayer = player1;
				
			}
			else{
				InlineShuffle.CurrentPlayer = playingFirst;
			}
		}
		
		////////////////////////////////////////////////////////
		//					StartGame
		///////////////////////////////////////////////////////
		public static function startGame():void
		{
			Game.isStarted = true;
			
			InlineShuffle.showMsgWindow("Game started.", 1);
			
			/*Tweener.removeTweens(InlineShuffle.dynamicCamera);
			Tweener.removeTweens(InlineShuffle.staticCamera);*/
			Tweener.removeTweens(InlineShuffle.camera);
			
			//DisplayObjectContainer(InlineShuffle.view.root).addChild(InlineShuffle.view.dynamicSceneView);
			
			InlineShuffle.shooter.visible = true;
			
			//InlineShuffle.staticCameraController.lookAtXYZ(0, 0, 0);
			
			//INIT CAMERA
			//   Z  Y
			//   | /
			//	 |/
			//   |-------X
				 
				 
			InlineShuffle.camera.rotationX = -120 * Math.PI / 180; //120
			InlineShuffle.camera.y = -150;//
			InlineShuffle.camera.z = 400;// 600;//
			InlineShuffle.camera.x = 0;
		//	InlineShuffle.camera.lookAt(0, 0, 0);
			
		//	view.scene.simpleObjectController.setObjectPosXYZ(0, 400, 100);
		//	view.scene.simpleObjectController.lookAtXYZ(3, 200, -400);
			
			//camera.focalLength
			/*InlineShuffle.staticCamera.rotationX = 120 * Math.PI / 180; //120
			InlineShuffle.staticCamera.y = 400;
			InlineShuffle.staticCamera.z = 0;
			InlineShuffle.staticCamera.x = 0;*/
			
			/*InlineShuffle.dynamicCamera.rotationX = 120 * Math.PI / 180; //120
			InlineShuffle.dynamicCamera.y = 400;
			InlineShuffle.dynamicCamera.z = 0;
			InlineShuffle.dynamicCamera.x = 0;*/
			
			//InlineShuffle.view.scene.simpleObjectController.lookAt(InlineShuffle.b
			//InlineShuffle.staticCamera.lookAt(0, 0, 0);
			
			//camera.lookAt(0, 0, 0);
			
			//camera.z = -172; //193 ;
			//camera.y = 290; //184(natural)//
			//camera.x = 0;
			
			//camera.rotationX = -15; //O(naturall)
			//camera.rotationY = 0;
			//camera.rotationZ = 0;
			
			//camera.zoom = 5; // 6;
			//camera.focalLength = 60; // 35;
			
			//stop static scene renderingtrue,true
			//InlineShuffle.view.stopRendering();
			
			//create puck for current player  
			var puck:Puck = InlineShuffle.CreatePuck(CurrentPlayer, new Vector3D(0,50 , InlineShuffle.PuckHeight * 0.5));
			InlineShuffle.view.scene.addToScene(puck);// addChild(puck);
			
			InlineShuffle.shooter.load(puck);
			
			if(CurrentPlayer==InlineShuffle.Players[0])
				InlineShuffle.scoreBoard.player1AvailablePucks--;
			else
				InlineShuffle.scoreBoard.player2AvailablePucks--;
			
			//InlineShuffle.view.startRendering();
			//InlineShuffle.view.singleRendering();
			InlineShuffle.view.startRendering();
		
		}
		
		//////////////////////////////////////////////////////////////////
		//					CreatePuck(player:Player,pos:Vector3D):Puck
		//@player:Player
		//@pos:Vector3D
		/////////////////////////////////////////////////////////////////
		public static function CreatePuck(player:Player, pos:Vector3D):Puck
		{
			var puck:Puck = new Puck(player, InlineShuffle.PuckDiameter * 0.5, InlineShuffle.PuckHeight, 8, 6, 100, InlineShuffle.view.scene.sound3DController.getChildByName("PuckSlideSound"));
			
			//puck.material.interactive=true;
			
			//position puck on the first line
			puck.x = pos.x;
			puck.y =  pos.y; //
			puck.z =  pos.z;
			puck.name = "puck_" + InlineShuffle.Pucks.length;
			puck.inx = InlineShuffle.Pucks.length;
			//puck.visible = false;
			InlineShuffle.Pucks.push(puck);
			
			MonsterDebugger.trace(InlineShuffle.CreatePuck, "InlineShuffle --> number of pucks = " + InlineShuffle.Pucks.length,"","InlineShuffle.CreatePuck");
			
			return puck;
		}
		
		/////////////////////////////////////////////////////////////
		//						CreateSounds()
		////////////////////////////////////////////////////////////
		public static function CreateSounds():void
		{
			InlineShuffle.buzzSound3D = InlineShuffle.view.scene.sound3DController.getChildByName("BuzzSound");
			InlineShuffle.beepSound3D = InlineShuffle.view.scene.sound3DController.getChildByName("BeepSound");
			
			//position inside the scoreboard
			InlineShuffle.beepSound3D.x = buzzSound3D.x = InlineShuffle.scoreBoard.x;
			InlineShuffle.beepSound3D.y = buzzSound3D.y = InlineShuffle.scoreBoard.y;
			InlineShuffle.beepSound3D.z = buzzSound3D.z = InlineShuffle.scoreBoard.z;
			
			InlineShuffle.puckWallHitSound3D = InlineShuffle.view.scene.sound3DController.getChildByName("WallHitSound");
			InlineShuffle.puckCrackSound3D = InlineShuffle.view.scene.sound3DController.getChildByName("PuckCrackSound");
		
		}
		
		/////////////////////////////////////////////////////////////
		//						CreateScoreBoard()
		////////////////////////////////////////////////////////////
		/*	public static function CreateScoreBoard():ScoreBoard
		   {
		   //InlineShuffle.scoreBoard = new ScoreBoard(InlineShuffle.Players[0].name, InlineShuffle.Players[1].name);
		   InlineShuffle.scoreBoard = new ScoreBoard();
		   InlineShuffle.scoreBoard.x = 0;
		   InlineShuffle.scoreBoard.y = 400 - InlineShuffle.scoreBoard.height / 2; // InlineShuffle.scoreBoard.height / 2;
		   InlineShuffle.scoreBoard.z = 200; // - 25;//50;//
		
		   //reset values
		
		   InlineShuffle.scoreBoard.player1Score = 0; // 0;
		   InlineShuffle.scoreBoard.player2Score = 0; //0;
		   InlineShuffle.scoreBoard.roundNumber = InlineShuffle.CurrentRound;
		   InlineShuffle.scoreBoard.shootCounter = 0;
		
		   return InlineShuffle.scoreBoard;
		 }*/
		
		/////////////////////////////////////////////////////////////
		//						CreatePowerGrid()
		////////////////////////////////////////////////////////////
		/*	public static function CreatePowerGrid(width:uint, height:uint):Plane
		   {
		   var powerGridMovie:MovieClip = new MovieClip();
		   var powerGridMovieMaterial:MovieMaterial;
		   var powerGrid:Plane;
		
		   //creat power grid plane hidden alpha=0
		   //powerGrid = new Plane(new ColorMaterial(0x00FF00, 0, true), width, height, 1, 1);
		   powerGrid = new Plane(new FillMaterial(0x00FF00, 0, true), width, height, 1, 1);
		   //powerGrid = new Plane(new WireframeMaterial(0x00FF00, 1,2),width,height,1,1);
		   powerGrid.x = 0;
		   powerGrid.y = 0;
		   powerGrid.z = 0;
		   powerGrid.rotationX = -90;
		   powerGrid.y = 0;
		
		   InlineShuffle.PowerGrid = powerGrid;
		
		   return powerGrid;
		 }*/
		
		/////////////////////////////////////////////////////////////
		//						CreateShooter()
		////////////////////////////////////////////////////////////
		public static function CreateShooter(material:Material, pos:Vector3D):Shooter
		{
			var shooter:Shooter = new Shooter(material, 10 + InlineShuffle.PuckDiameter / 2, 10 + InlineShuffle.PuckHeight, 8, 6, -1, InlineShuffle.view.scene.sound3DController.getChildByName("ShooterSound"));
			//shooter.material.interactive=true;
			
			//position shooter on the first line
			shooter.x = pos.x;
			shooter.y = 10 + InlineShuffle.PuckHeight; //2*shooter.radius
			shooter.z = -100;// pos.z;
			shooter.name = "shooter";
			
			return shooter;
		}
		
		/////////////////////////////////////////////////////////////
		//						CreateScoreFields()
		////////////////////////////////////////////////////////////
		public static function CreateScoreFields():void
		{
			
			/*	InlineShuffle.ScoreFields.push(new ScoreField([new Vector3D( -230, z: 725}, new Vector3D( 230, z: 725}, new Vector3D( 186, z: 657}, new Vector3D( -186, z: 657}], -10, ScoreField.MIDDLE));
			   InlineShuffle.ScoreFields.push(new ScoreField([new Vector3D( -231, z: 657}, new Vector3D( 0, z: 657}, new Vector3D( 0, z: 546}, new Vector3D( -155, z: 546}], 7, ScoreField.LEFT)); //left 7
			   InlineShuffle.ScoreFields.push(new ScoreField([new Vector3D( -155, z: 546}, new Vector3D( -77, z: 432}, new Vector3D( 0, z: 432}, new Vector3D( 0, z: 546}], 8, ScoreField.LEFT)); //left 8
			   InlineShuffle.ScoreFields.push(new ScoreField([new Vector3D( -77, z: 432}, new Vector3D( 77, z: 432}, new Vector3D( 0, z: 324}], 10, ScoreField.MIDDLE));
			   InlineShuffle.ScoreFields.push(new ScoreField([new Vector3D( 155, z: 546}, new Vector3D( 77, z: 432}, new Vector3D( 0, z: 432}, new Vector3D( 0, z: 546}], 8, ScoreField.RIGHT)); //right 8
			   InlineShuffle.ScoreFields.push(new ScoreField([new Vector3D( 231, z: 657}, new Vector3D( 0, z: 657}, new Vector3D( 0, z: 546}, new Vector3D( 155, z: 546}], 7, ScoreField.RIGHT)); //right 7
			 */
			
/*			InlineShuffle.ScoreFields.push(new ScoreField([new Vector3D(-230, 0, 725), new Vector3D(230, 0, 725), new Vector3D(186, 0, 657), new Vector3D(-186, 0, 657)], -10, ScoreField.MIDDLE));
			InlineShuffle.ScoreFields.push(new ScoreField([new Vector3D(-231, 0, 657), new Vector3D(0, 0, 657), new Vector3D(0, 0, 546), new Vector3D(-155, 0, 546)], 7, ScoreField.LEFT)); //left 7
			InlineShuffle.ScoreFields.push(new ScoreField([new Vector3D(-155, 0, 546), new Vector3D(-77, 0, 432), new Vector3D(0, 0, 432), new Vector3D(0, 0, 546)], 8, ScoreField.LEFT)); //left 8
			InlineShuffle.ScoreFields.push(new ScoreField([new Vector3D(-77, 0, 432), new Vector3D(77, 0, 432), new Vector3D(0, 0, 324)], 10, ScoreField.MIDDLE));
			InlineShuffle.ScoreFields.push(new ScoreField([new Vector3D(155, 0, 546), new Vector3D(77, 0, 432), new Vector3D(0, 0, 432), new Vector3D(0, 0, 546)], 8, ScoreField.RIGHT)); //right 8
			InlineShuffle.ScoreFields.push(new ScoreField([new Vector3D(231, 0, 657), new Vector3D(0, 0, 657), new Vector3D(0, 0, 546), new Vector3D(155, 0, 546)], 7, ScoreField.RIGHT)); //right 7
	*/	
			
			InlineShuffle.ScoreFields.push(new ScoreField(Vector.<Vector3D>([new Vector3D(-230, 725+50), new Vector3D(230, 725+50 ), new Vector3D(186,  657+50), new Vector3D(-186,  657+50)]), -10, ScoreField.MIDDLE));
			InlineShuffle.ScoreFields.push(new ScoreField(Vector.<Vector3D>([new Vector3D(-231,  657+50), new Vector3D(0,  657+50), new Vector3D(0,  546+50), new Vector3D(-155,  546+50)]), 7, ScoreField.LEFT)); //left 7
			InlineShuffle.ScoreFields.push(new ScoreField(Vector.<Vector3D>([new Vector3D(-155,  546+50), new Vector3D(-77,  432+50), new Vector3D(0,  432+50), new Vector3D(0,  546+50)]), 8, ScoreField.LEFT)); //left 8
			InlineShuffle.ScoreFields.push(new ScoreField(Vector.<Vector3D>([new Vector3D(-77, 432+50), new Vector3D(77,  432+50), new Vector3D(0,  324+50)]), 10, ScoreField.MIDDLE));
			InlineShuffle.ScoreFields.push(new ScoreField(Vector.<Vector3D>([new Vector3D(155,  546+50), new Vector3D(77,  432+50), new Vector3D(0,  432+50), new Vector3D(0,  546+50)]), 8, ScoreField.RIGHT)); //right 8
			InlineShuffle.ScoreFields.push(new ScoreField(Vector.<Vector3D>([new Vector3D(231,  657+50), new Vector3D(0,  657+50), new Vector3D(0,  546+50), new Vector3D(155,  546+50)]), 7, ScoreField.RIGHT)); //right 7

	
	
		}
		
		/////////////////////////////////////////////////////////////
		//						CHECKSCORE
		////////////////////////////////////////////////////////////
		public static function checkScore():void
		{
			
			//reset scoreBoard
			if (InlineShuffle.scoreBoard)
			{
				InlineShuffle.scoreBoard.player1Score = InlineShuffle.Players[0].score;
				InlineShuffle.scoreBoard.player2Score = InlineShuffle.Players[1].score;
			}
			
			WorkingMemory.reset();
			
			//evaluate changed situation
			for each (var puck:Puck in InlineShuffle.Pucks)
			{
				
				MonsterDebugger.trace(InlineShuffle.checkScore, "INLINESHUFLE -> PUCK " + puck.toString());
				
				for each (var scoreField:ScoreField in InlineShuffle.ScoreFields)
					
				{
					if (scoreField.isInScoreField(puck))
					{ //is in field
						if (!scoreField.isIntersectOutline(puck, InlineShuffle.ScoreFieldLineTickness)) //and not on line
						{
							
							//
							if (puck.belongTo == InlineShuffle.Players[0])
							{
								if (InlineShuffle.scoreBoard)
									InlineShuffle.scoreBoard.player1Score += scoreField.score;
								
								//TODO connect Fuzzy logic
								//Save current situation of pucks
								WorkingMemory.player1Score(puck, scoreField);
								
							}
							else
							{
								if (InlineShuffle.scoreBoard)
									InlineShuffle.scoreBoard.player2Score += scoreField.score;
								
							}
							
							MonsterDebugger.trace(InlineShuffle.checkScore, "INLINESHUFLE -> SCORING: " + scoreField.score);
							
						}
						else
						{
							MonsterDebugger.trace(InlineShuffle.checkScore, "INLINESHUFLE -> LINE INTERSECTION");
						}
						
						break;
					}
					
						//puck was in some field so step out of checkin
					
				}
				
			}
		
		}
		
		/////////////////////////////////////////////////////////////////
		// 						countShootTime
		////////////////////////////////////////////////////////////////
		private static function countShootTime(event:TimerEvent):void
		{
			
			InlineShuffle.scoreBoard.shootCounter = InlineShuffle.TIME_OUT - event.target.currentCount;
			//trace("INLINESHUFFLE -> second " + event.target.currentCount);
			//MonsterDebugger.trace(this,"INLINESHUFFLE -> second " + event.target.currentCount);
			if (event.target.currentCount > 15) //last 5s
			{
				//beep sound
				InlineShuffle.beepSound3D.play();
				
				if (event.target.currentCount == InlineShuffle.TIME_OUT)
					InlineShuffle.buzzSound3D.play();
					//buzz sound
			}
		
		}
		
		/////////////////////////////////////////////////////////////////
		// 						shootTimeComplete
		////////////////////////////////////////////////////////////////
		private static function shootTimeComplete(event:TimerEvent):void
		{
			MonsterDebugger.trace(InlineShuffle.shootTimeComplete, "INLINESHUFFLE -> timer complete at " + event.target.currentCount);
			
			InlineShuffle.showMsgWindow("Time out!!!", 1);
			
			//send to remote player
			//if(Game.type==Game.Mutli && !InlineShuffle.CurrentPlayer.isRemote)
			//Multiplayer.client.sendObject( { type:GameStatus.SHOOTTIMECOMPLETE} );		
			
			
			//TODO uncommnent both lines
			InlineShuffle.shooter.unload();
			checkGameStatus();
		}
		
		/////////////////////////////////////////////////////////////////
		// 						CHECKGAMESTATUS
		////////////////////////////////////////////////////////////////
		/*
		 * function checkGameStatus()
		 */
		public static function checkGameStatus():void
		{
			var puck:Puck;
			
			//InlineShuffle.view.dynamicSceneView.startRendering();
			//if (Tweener.isTweening(InlineShuffle.dynamicCamera) || Tweener.isTweening(InlineShuffle.staticCamera))
			if(Tweener.isTweening(InlineShuffle.camera))
			{
				
				Tweener.removeAllTweens();
				MonsterDebugger.trace(InlineShuffle.checkGameStatus, "INLINESHUFLE:--> camera Zoom and Back tween removed");
			}
			
			//InlineShuffle.view.stopRendering(true, true);
			
			if (InlineShuffle.shooter.shoots == 8) //4 per player
			{
				InlineShuffle.shooter.unload();
				
				//update playersScore
				InlineShuffle.Players[0].score = InlineShuffle.scoreBoard.player1Score;
				InlineShuffle.Players[1].score = InlineShuffle.scoreBoard.player2Score;
				
				//TIE score
				if (InlineShuffle.Players[0].score == InlineShuffle.Players[1].score)
				{
					MonsterDebugger.trace(InlineShuffle.checkGameStatus, "INLINESHUFLE:--> TIE");
					InlineShuffle.showMsgWindow(" Game finished as TIE. Golden Round. ");
					if (InlineShuffle.CurrentRound == InlineShuffle.Rounds)
						InlineShuffle.Rounds++; //creat new round until someone win
				}
				
				if (InlineShuffle.CurrentRound == InlineShuffle.Rounds)
				{
					//game end; //move the camera to the score board
					
					InlineShuffle.shooter.unload();
					
					if (InlineShuffle.Players[0].score > InlineShuffle.Players[1].score)
						InlineShuffle.Players[0].hasWon = true;
					else
						InlineShuffle.Players[1].hasWon = true;
					
					if (Game.type == Game.MULTI)
					{
						if (!CurrentPlayer.isRemote) //current player reports the match if it is clientPlayer
						{
							Multiplayer.reportMatch();
							
						}
						
						return;
					}
					else
					{
						MonsterDebugger.trace(InlineShuffle.checkGameStatus, "INLINESHUFLE:--> Game over");
						InlineShuffle.showMsgWindow("Game over!");
					}
					
					return;
				}
				else
				{
					
					//next round	
					InlineShuffle.CurrentRound++;
					InlineShuffle.scoreBoard.roundNumber = InlineShuffle.CurrentRound;
					
					MonsterDebugger.trace(InlineShuffle.checkGameStatus, "INLINESHUFLE:--> New round " + InlineShuffle.CurrentRound + "initialization");
					
					InlineShuffle.showMsgWindow("Round " + InlineShuffle.CurrentRound + " has started", 1);
					
					//update playersScore
					InlineShuffle.Players[0].score = InlineShuffle.scoreBoard.player1Score;
					InlineShuffle.Players[1].score = InlineShuffle.scoreBoard.player2Score;
					
					
					//TODO optimize this with object Pool way of working
					//remove pucks
					for (var i:int = 0; i < InlineShuffle.Pucks.length; i++)
					{
						//InlineShuffle.view.scene.removeChild(InlineShuffle.Pucks[i].puckSlideSound3D);
						InlineShuffle.view.scene.removeChild(InlineShuffle.Pucks[i]);
						
						delete InlineShuffle.Pucks[i];
						
					}
					
					InlineShuffle.Pucks.length = 0;
					InlineShuffle.shooter.shoots = 0;
					
				}
				
			}
			else
			{
				switchCurrentPlayer();
			}
			
			//create new Puck
			puck = InlineShuffle.CreatePuck(CurrentPlayer, new Vector3D(0,  50,InlineShuffle.PuckHeight * 0.5));
			InlineShuffle.view.scene.addToScene(puck);
			
			//load new Puck
			InlineShuffle.shooter.load(puck);
			
			if(CurrentPlayer==InlineShuffle.Players[0])
				InlineShuffle.scoreBoard.player1AvailablePucks--;
			else
				InlineShuffle.scoreBoard.player2AvailablePucks--;
		
			//TODO more syncronization need here (need to wait other party to load pack too)
		
		}
		
		private static function switchCurrentPlayer():void
		{
			//switch player
			if (InlineShuffle.CurrentPlayer == InlineShuffle.Players[0])
			{
				InlineShuffle.CurrentPlayer = InlineShuffle.Players[1];
				MonsterDebugger.trace(InlineShuffle.switchCurrentPlayer, InlineShuffle.CurrentPlayer, "INLINESHUFFLE ->Turn switch from " + InlineShuffle.Players[0].name + " changed to " + InlineShuffle.CurrentPlayer.name);
				
			}
			else
			{
				InlineShuffle.CurrentPlayer = InlineShuffle.Players[0];
				MonsterDebugger.trace(InlineShuffle.switchCurrentPlayer, InlineShuffle.CurrentPlayer, "INLINESHUFFLE ->Turn switch from " + InlineShuffle.Players[1].name + " changed to " + InlineShuffle.CurrentPlayer.name);
			}
		}
		
		/*
		 *VERSION 1
		 *
		 * public static function cameraZoom(rot:int,zTo:Number,time:Number,delay:Number)
		   {
		
		   Tweener.addTween(InlineShuffle.camera, {rotationX:rot,z:zTo, time:time, delay:delay,transition:"easeOutQuint",onComplete:InlineShuffle.cameraBack, onCompleteParams:[0,-152,2,3] });//
		   }
		
		   public static function cameraBack(rot:int,zTo:Number,time:Number,delay:Number)
		   {
		   MonsterDebugger.trace(this,"INLINESHUFLE-> cameraBack ");
		   Tweener.addTween(InlineShuffle.camera, {rotationX:rot,z:zTo, time:time, delay:delay,transition:"easeOutQuint", onComplete:InlineShuffle.checkGameStatus});//
		
		 }*/
		public static function cameraZoom(rot:int, zTo:Number, time:Number, delay:Number):void
		{
			
			/*	if (Game.debug)
			   {
			   //Tweener.addTween(InlineShuffle.camera, {rotationX:-90,z:650, time:time, delay:delay,transition:"easeOutQuint",onComplete:InlineShuffle.cameraBack, onCompleteParams:[-15,-152,2,1] });//[0,-152,2,3]
			   Tweener.addTween(InlineShuffle.camera, {rotationX:-90,z:650, time:time, delay:delay,transition:"easeOutQuint"});//[0,-152,2,3]
			   }
			 else//rotationX: -15,
			{
				//Tweener.addTween(InlineShuffle.view.scene.camera, {zoom: 20, time: time, delay: delay, transition: "easeOutQuint"});
				//Tweener.addTween(InlineShuffle.view.scene.camera, {zoom: 20, time: time, delay: delay, transition: "easeOutQuint"}); // , onComplete:InlineShuffle.cameraBack, onCompleteParams:[ -15, -152, 2, 1] } );//[0,-152,2,3] 
			}*/
			
			//y: 300,
			//Tweener.addTween(InlineShuffle.camera, {fov:0.5, time: time, delay: delay, transition: "easeOutQuint"});
			
		}
		
		public static function cameraBack(rot:int, zTo:Number, time:Number, delay:Number):void
		{
			MonsterDebugger.trace(InlineShuffle.cameraBack, "INLINESHUFLE-> cameraBack ");
			
			/*if (Game.debug)//
			   {
			   Tweener.addTween(InlineShuffle.camera, {rotationX:-15,z:-193, time:time, delay:delay,transition:"easeOutQuint", onComplete:InlineShuffle.checkGameStatus });//[0,-152,2,3]
			
			   }
			 else*/
			{
			//	Tweener.addTween(InlineShuffle.view.scene.camera, {zoom: 5, time: time, delay: delay, transition: "easeOutQuint", onUpdate: InlineShuffle.render, onComplete: InlineShuffle.checkGameStatus});
				//Tweener.addTween(InlineShuffle.view.scene.camera, {zoom: 5, time: time, delay: delay, transition: "easeOutQuint", onUpdate: InlineShuffle.render, onComplete: InlineShuffle.checkGameStatus}); //
			
				
				//TODO add camera implementation
				 InlineShuffle.checkGameStatus();
			}
		}
		
		////////////////////////////////////////////////////////
		//					render()
		///////////////////////////////////////////////////////
		public static function render():void
		{
			//InlineShuffle.view.singleRendering();
			//InlineShuffle.view.singleRendering();
		}
		
		////////////////////////////////////////////////////////
		//					startCheckHitLoop()
		///////////////////////////////////////////////////////
		public static function startCheckHitLoop():void
		{
			//InlineShuffle.view.startRendering();
			//InlineShuffle.view.stopRendering();
			
			//if(Tweener.isTweening(InlineShuffle.camera))
			//	Tweener.removeAllTweens();
			
			MonsterDebugger.trace(InlineShuffle.startCheckHitLoop, null, "InlineShuffle: startCheckHitLoop");
			InlineShuffle.stage.addEventListener(Event.ENTER_FRAME, InlineShuffle.mainLoop);
			
			//rot:int,zTo:Number,time:Number,delay:Number
			//TODO camera follow the puck
			InlineShuffle.cameraZoom(-75, InlineShuffle.BOARD_LENGTH - 400, 5, 0);
		}
		
		////////////////////////////////////////////////////////
		//					stoptCheckHitLoop()
		///////////////////////////////////////////////////////
		public static function stopCheckHitLoop():void
		{
			
			MonsterDebugger.trace(InlineShuffle.startCheckHitLoop, "InlineShuffle: stopCheckHitLoop");
			InlineShuffle.stage.removeEventListener(Event.ENTER_FRAME, InlineShuffle.mainLoop);
			// InlineShuffle.view.dynamicSceneView.stopRendering(true, true);
			InlineShuffle.cameraBack(-15, -152, 2, 1);
		}
		
		////////////////////////////////////////////////////////
		//					mainLoop()
		///////////////////////////////////////////////////////
		public static function mainLoop(e:Event):void //Update speed
		{
			
			var equlibrium:Boolean = true;
			var i:int = 0;
			var j:int = 0;
			var currentPuck:Puck;
			
			for (i = 0; i < InlineShuffle.Pucks.length; i++)
			{
				//move all pucks
				InlineShuffle.Pucks[i].movePuck();
			}
			
			//Correction of moving cos of hit
			for (i = 0; i < InlineShuffle.Pucks.length; i++)
			{
				currentPuck = InlineShuffle.Pucks[i];
				
				//reset flag
				currentPuck.hasCollided = false;
				
				Puck.checkPuckHit(i);
				Puck.checkWallsHit(i);
				
				if (currentPuck.hasCollided || currentPuck.speed.x != 0 || currentPuck.speed.y != 0) //|| currentPuck.speed.z != 0
				{
					
					equlibrium = false;
						//InlineShuffle.Pucks[i].start();
				}
				else
				{
					currentPuck.stopPuck();
					
				}
				
			}
			
			//render
			//MonsterDebugger.trace(this,"InlineShuffle --> camera current render " + camera.zoom);
			//InlineShuffle.view.singleRendering();
			//MonsterDebugger.trace(this,"InlineShuffle --> camera dynamic render "+camera.zoom);
			//InlineShuffle.view.singleRendering();
			//MonsterDebugger.trace(this,"InlineShuffle --> camera static render "+camera.zoom);
			
			if (equlibrium)
			{
				MonsterDebugger.trace(InlineShuffle.mainLoop, "InlineShuffle --> Pucks postions in equlibrium \n" + InlineShuffle.Pucks.join());
				MonsterDebugger.trace(InlineShuffle.mainLoop, "InlineShuffle --> all pucks has stoped");
				MonsterDebugger.trace(InlineShuffle.camera, "InlineShuffle --> " + InlineShuffle.camera.toString());
				
				InlineShuffle.stopCheckHitLoop();
				InlineShuffle.checkScore();
				
				trace("EQULIBRIUM");
					//end or next round or/and change player
					//InlineShuffle.checkGameStatus();
				
			}
		
		}
	
	}

}
