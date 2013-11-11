package  
{
	import alternativa.engine3d.controllers.SimpleObjectController;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Resource;
	import alternativa.engine3d.core.View;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.primitives.Box;
	import com.demonsters.debugger.MonsterDebugger;
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	
	
	/**
	 * ...
	 * @author winxalex
	 */
	public class Main extends Sprite 
	{
		
		private var __scenesToBeLoaded:int = 1;
		private var dynamicBoardSceneView:BoardView;
		private var mainBackgroundSceneView:MainView;
	
	
		
		
		public function Main():void {
			
			stage.align = StageAlign.TOP_LEFT;
		    stage.scaleMode = StageScaleMode.NO_SCALE;
			
			trace(Capabilities.version);
			
			//game type
			Game.debug = CONFIG::DEBUG;
			
			
			
			//TODO loadder
			this.root.loaderInfo.addEventListener(Event.COMPLETE, onSWFLoaded);
			
		
			
			
			
			
		}
		
		
		
		
		
		
		private function onSWFLoaded(e:Event):void
		{
			
		
			
			// FLASH VARS
			
				
			//INIT DEBUG
			
			if (Game.debug)
				{	
					// Start the MonsterDebugger
					MonsterDebugger.initialize(this);
					MonsterDebugger.enabled = true;
					
				}
				
				switch(CONFIG::SERVER_TYPE)
				{
					default:
						Game.zone = "CowboyBar";
						//Game.type = Game.Mutli;//Game.Single;////// // uint(this.root.loaderInfo.parameters.gametype);//Game.Single;// 0;// 
						Game.type = Game.Single;
						Game.id = 6;// uint(this.root.loaderInfo.parameters.gameid);
						Game.name = "Game1";// this.root.loaderInfo.parameters.game;
					break;
					
					
					case ServerType.Cirrus:
						Game.zone = "CowboyBar";
						Game.type = Game.MULTI;//Game.Single;////// // uint(this.root.loaderInfo.parameters.gametype);//Game.Single;// 0;// 
						//Game.type = Game.Single;
						Game.id = 6;// uint(this.root.loaderInfo.parameters.gameid);
						Game.name = "Game1";// this.root.loaderInfo.parameters.game;
					break;
				}
			
				
		/*	}
			else
			{
				Game.zone = "CowboyBar";
				Game.type = uint(this.root.loaderInfo.parameters.gametype);//Game.Single;// 0;// 
				Game.id = uint(this.root.loaderInfo.parameters.gameid);
				Game.name = this.root.loaderInfo.parameters.game;
				TraceWindow.visible = false;// // ;
				
			}*/
			
			
			/*var variables:URLVariables = new URLVariables();
			 variables.ladderid = 6;
			variables.lplayerid = 7;
			variables.wplayerid = 8;
			Multiplayer.sendMatchResults(variables);*/	  
					  
			
			
			
			
			//TraceWindow.display("Game name: " + Game.name + " Game id:" + Game.id);
			MonsterDebugger.trace(this.init, "Game name: " + Game.name + " Game id:" + Game.id, "team member", "labela");
			
			//add logo
			this.stage.addChild(new WinxLogo()).addEventListener(MouseEvent.CLICK, logoClick);
			
			
			init();

			
			//;
			//debug only
			//Game.isStarted = true;
			//Multiplayer.reportMatch();
			
			
			
		}
		
		
		public function init():void
		{
		
					var stage3D:Stage3D
				
					//get stage3D
					stage3D = stage.stage3Ds[0];
					stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreate);
					stage3D.requestContext3D();
					
					/*
					stage3D = stage.stage3Ds[1];
					stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreate1);
					stage3D.requestContext3D();*/
					
			
		}
		
		
		
		
		
		/*private function onContextCreate1(e:Event):void 
		{
			var stage3D:Stage3D=e.currentTarget as Stage3D
			trace(stage3D.context3D.driverInfo);
			
			
			
			//create view for dynamic elements(pucks) and add to init
			   dynamicBoardSceneView = new BoardView(300, 300);// stage.stageWidth, stage.stageHeight);
			   dynamicBoardSceneView.scene = new BoardScene(stage3D, new Camera3D(0.1, 10000));
			  
				stage.addChild(dynamicBoardSceneView);
			   dynamicBoardSceneView.scene.loadScene(onLoadScene);
		}*/
		
		
		
		private function onContextCreate(e:Event):void {
			
			var stage3D:Stage3D=e.currentTarget as Stage3D
			trace(stage3D.context3D.driverInfo);
			
			//set views
			
			//set main view and scene
			   mainBackgroundSceneView = new MainView(stage.stageWidth, stage.stageHeight);
			   mainBackgroundSceneView.scene = new MainScene(stage3D, new Camera3D(0.1, 10000));
			   mainBackgroundSceneView.scene.addWireXY(1000, 1000);
			 //  mainBackgroundSceneView.x = 0;
			//   mainBackgroundSceneView.y = 0;
			//   mainBackgroundSceneView.scene.simpleObjectController= new SimpleObjectController(stage, mainBackgroundSceneView.scene.camera, 200);
			
			   stage.addChild(mainBackgroundSceneView);
			
			
			   mainBackgroundSceneView.scene.loadScene(onLoadScene);
			   
			   
			   
			   
			   
			/*//create view for dynamic elements(pucks) and add to init
			   dynamicBoardSceneView = new BoardView(stage.stageWidth, stage.stageHeight);
			  // dynamicBoardSceneView.scene = new BoardScene(stage3D, new Camera3D(0.1, 10000));
			  dynamicBoardSceneView.scene = new BoardScene(stage3D, mainBackgroundSceneView.scene.camera);
			//	stage.addChild(dynamicBoardSceneView);
			   dynamicBoardSceneView.scene.loadScene(onLoadScene);*/
			     
			
			
			stage.addEventListener(Event.RESIZE, onResize);
			
		}
		
		private function onLoadScene():void 
		{
			__scenesToBeLoaded--;
			if (!__scenesToBeLoaded)  InlineShuffle.init(mainBackgroundSceneView/*, dynamicBoardSceneView*/);
		}
		
		private function onResize(e:Event):void 
		{
			this.mainBackgroundSceneView.width = stage.stageWidth;
			this.mainBackgroundSceneView.height = stage.stageHeight;
			
			this.dynamicBoardSceneView.width = stage.stageWidth;
			this.dynamicBoardSceneView.height = stage.stageHeight;
		}
		
			
			
		private function logoClick(e:MouseEvent):void
		{
			var req:URLRequest = new URLRequest("http://www.winx.ws");
			
			navigateToURL(req, "_self"); 
		}
		
	
		
	}

}