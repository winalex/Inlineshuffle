/**
 * ...
 * @author Default
 * @version 0.1
 */

package
{
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.events.MouseEvent3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.RayIntersectionData;
	import alternativa.engine3d.core.Sound3D;
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.objects.WireFrame;
	import alternativa.engine3d.primitives.Cylinder;
	import com.demonsters.debugger.MonsterDebugger;
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.geom.Vector3D;
	import flash.media.SoundTransform;
	import flash.ui.Mouse;
	import flash.utils.getTimer;
	
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	import flash.geom.Point;
	
	public class Shooter extends Cylinder
	{
		
		private var _puckLoaded:Puck = null;
		private var _enable:Boolean;
		public var shoots:uint = 0;
		
		public var shooterSound3D:Sound3D;
		private var isDragging:Boolean = false;
		private var startPoint:Vector3D = new Vector3D();
		private var origin:Vector3D = new Vector3D();
		private var directionA:Vector3D = new Vector3D();
		private var directionB:Vector3D = new Vector3D();
		public var radius:Number;
		
		private var _currentTime:uint;
		private var _prevTime:uint;
		private var _currentPoint:Vector3D;
		private var _prevPoint:Vector3D;
		
		public function Shooter(material:Material = null, radius:Number = 100, height:Number = 100, segmentsW:int = 8, segmentsH:int = 6, topRadius:Number = -1, sound:Sound3D = null, initObject:Object = null)
		{
			//DisplayObject3D(name:String = null, geometry:GeometryObject3D = null, initObject:Object = null)
			super(radius, radius, height, segmentsW, segmentsH, true, true, true, true, material);
			
			//this.addChild(BarScene.shooterButtonPart.extra.pivot);
			//BarScene.Hat01D3OD.extra.pivot.scale = 5;
			
			this.shooterSound3D = sound;
			//this.shooterSound3D.maxSoundDistance = 800;
			this.radius = radius;
			
			//_currentPoint = new Vector3D();
			_prevPoint = new Vector3D();
		
			//add sound 3D 
			//if(InlineShuffle.view.dynamicSceneView.scene)
			//InlineShuffle.view.dynamicSceneView.scene.addChild(this.shooterSound3D);
			//InlineShuffle.view.sound3DController.addChild(this.shooterSound3D);
		}
		
		private function startDrag(e:MouseEvent3D):void
		{
			
			var stage:Stage = InlineShuffle.stage;
			var camera:Camera3D = InlineShuffle.view.scene.camera;
			var object:Object3D = e.target as Object3D;
			//var origin:Vector3D = new Vector3D();
			//var directionA:Vector3D = new Vector3D();
			//origin.x = origin.y = origin.z = 0;
			//directionA.x = directionA.y = directionA.y = 0;
			
			// This calculate ray from camera to mouse cursor.
			camera.calculateRay(origin, directionA, stage.mouseX, stage.mouseY);
			
			// You can test where ray hits.
			var data:RayIntersectionData = object.parent.intersectRay(origin, directionA);
			
			if (data != null)
			{
				Mouse.hide();
				
				//stage.addEventListener(Event.ENTER_FRAME, dragShooter);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, dragShooter);
				stage.addEventListener(MouseEvent.MOUSE_UP, stopDrag);
				
				startPoint = data.point;
				
				this.isDragging = true;
				
				//get current point and time
				_currentPoint = startPoint.clone();
				//_currentPoint.x = startPoint.x;
				//_currentPoint.y = startPoint.y;
				//_prevPoint = _currentPoint;
				
				_currentPoint.y = stage.mouseY;
				_prevPoint.y = _currentPoint.y; /**/
				
				_currentTime = getTimer();
				_prevTime = _currentTime;
				
				Mouse.hide();
				
				//trace("startPoint:", startPoint);
				
				MonsterDebugger.trace(InlineShuffle.view, "START DRAGING at point:" + startPoint.toString(), "", "Shooter->startDrag");
					//trace(startPoint.x, startPoint.y,startPoint.y);
				
			}
			else
				trace("click out");
		
		}
		
		private function stopDrag(e:MouseEvent):void
		{
			if (this.isDragging)
			{
				
				var view:BasicView = InlineShuffle.view;
				var camera:Camera3D = view.scene.camera;
				var stage:Stage = InlineShuffle.stage;
				
				
				this.isDragging = false;
				
				/*if (stage.mouseY < 548) {
				
				   //camera.calculateRay(origin, directionA, view.width * 0.5,view.height * 0.5);
				   camera.calculateRay(origin, directionB, stage.mouseX, stage.mouseY);
				
				   directionA.x = 0;
				   directionA.y = startPoint.y;
				   directionA.z = _puckLoaded.height;
				
				   var pos:Vector3D = Shooter.intersectionPoint(origin, directionB, directionA, Vector3D.Z_AXIS);
				
				   //set puck Y restriciton to board
				   //set puck Y  restricition from PUCK.radius to InlineShuffle.MAX_DRAG_Y-PUCK.radius
				   _puckLoaded.y = pos.y - startPoint.y;
				   _puckLoaded.x = pos.x - startPoint.x;
				   //_puckLoaded.z = pos.z - startPoint.z;
				   var diff:Number = InlineShuffle.BOARD_WIDTH * 0.5 - _puckLoaded.radius;
				
				   if (_puckLoaded.x > diff)
				   _puckLoaded.x = diff;
				   else if (_puckLoaded.x < -diff)
				   _puckLoaded.x = -diff;
				
				   diff = InlineShuffle.MAX_DRAG_Y - _puckLoaded.radius;
				
				   if (_puckLoaded.y > diff)
				   _puckLoaded.y = diff;
				   else if (_puckLoaded.y < _puckLoaded.radius)
				   _puckLoaded.y = _puckLoaded.radius;
				 }*/
				
				_currentPoint.y = stage.mouseY;
				
				trace(_prevPoint.y, _currentPoint.y, "offsetY:", (_prevPoint.y - _currentPoint.y), (getTimer() - _prevTime));
				
				MonsterDebugger.trace(this, "STOP DRAG at point:" + _currentPoint.toString(), "Shooter->stopDrag");
				
				var offsetX:Number = Math.abs(_currentPoint.x - _prevPoint.x);
				
				MonsterDebugger.trace(this, "_prevPoint.x=" + _prevPoint.x, "", "SHOOTER>shoot");
				MonsterDebugger.trace(this, "_currentPoint.x=" + _currentPoint.x, "", "SHOOTER>shoot ");
				MonsterDebugger.trace(this, "offsetX=" + offsetX, "", "SHOOTER>shoot ");
				
				//offsetZ (first point should be lower then second in direction of positive Z)
				var offsetZ:Number = _prevPoint.y - _currentPoint.y; //_prevPoint.z-_currentPoint.z;
				
				MonsterDebugger.trace(this, "_prevPoint.y=" + _prevPoint.y, "", "SHOOTER>shoot");
				MonsterDebugger.trace(this, "_currentPoint.y=" + _currentPoint.y, "", "SHOOTER>shoot ");
				MonsterDebugger.trace(this, "offsetZ=" + offsetZ, "", "SHOOTER>shoot ");
				
				shoot();
				
				//offsetZ>0  and offsetZ>offsetX(swipe to be towards Z) and offsetZ>Inlineshuffle
				/*if (_prevPoint.y > _currentPoint.y)
				{ // if direction is towards the -Z Axes
					if (offsetZ > offsetX && offsetZ > InlineShuffle.SWIPE_OFFSET_Z)
					{
						this.enable = false
						shoot();
						return;
					}
				}
				
				
				Mouse.show();
					this.enable = true;*/
				
				
			}
		
		}
		
		private function dragShooter(e:Event):void
		{
			if (this.isDragging)
			{
				//var origin:Vector3D = new Vector3D;
				//	var directionA:Vector3D = new Vector3D;
				//	var directionB:Vector3D = new Vector3D;
				//	var direction:Vector3D = new Vector3D;
				var view:BasicView = InlineShuffle.view;
				var camera:Camera3D = view.scene.camera;
				var stage:Stage = InlineShuffle.stage;
				
				//if (stage.mouseY < 548) return;
				
				camera.calculateRay(origin, directionA, view.width * 0.5, view.height * 0.5);
				camera.calculateRay(origin, directionB, stage.mouseX, stage.mouseY);
				
				//directionA is reused
				directionA.x = 0;
				directionA.y = startPoint.y;
				directionA.z = _puckLoaded.height;
				
				var pos:Vector3D = Shooter.intersectionPoint(origin, directionB, directionA, Vector3D.Z_AXIS);
				
				//set puck Y restriciton to board
				//set puck Y  restricition from PUCK.radius to InlineShuffle.MAX_DRAG_Y-PUCK.radius
				_puckLoaded.y = pos.y - startPoint.y;
				
				//_puckLoaded.z = pos.z - startPoint.z;
				
				//trace("offsetX3D:", pos.x - _prevPoint.x);
				
				var diff:Number;
				
				diff = InlineShuffle.MAX_DRAG_Y - _puckLoaded.radius;
				
				//TODO Expert mode should add some degree of offsetX drag instead cancel all
				
				//Switch of cancel X drag when Y value is outside boundaries
				var bCancelDragX:Boolean = false;
				trace(_puckLoaded.y, diff);
				if (_puckLoaded.y > diff)
				{
					_puckLoaded.y = diff;
					bCancelDragX = true;
				}
				else if (_puckLoaded.y < _puckLoaded.radius)
					_puckLoaded.y = _puckLoaded.radius;
				
				if (!bCancelDragX)
				{
					
					_puckLoaded.x = pos.x - startPoint.x;
					
					diff = InlineShuffle.BOARD_WIDTH * 0.5 - _puckLoaded.radius;
					
					if (_puckLoaded.x > diff)
						_puckLoaded.x = diff;
					else if (_puckLoaded.x < -diff)
						_puckLoaded.x = -diff;
					
				}
				
				_prevPoint.x = _currentPoint.x;
				_prevPoint.y = _currentPoint.y;
				
				//_currentPoint = _puckLoaded.position;
				_prevPoint.x = _currentPoint.x;
				_prevPoint.y = _currentPoint.y;
				_currentPoint.y = stage.mouseY;
				_currentPoint.x = pos.x;
				_prevTime = _currentTime;
				_currentTime = getTimer();
				
					//trace("y:", _currentPoint.y);
					//trace("pos:", pos);
				
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
		
		/**
		 *
		 * @param	puck
		 */
		public function load(puck:Puck):void
		{
			//TODO animate puck showing (drop form the hight)
			//TODO animate AI player shooting with going to postiong and taking back to get speed dragging in front
			
			//reset position
			//this.x = 0;
			//this.y = 0;
			
			//load shooter
			this._puckLoaded = puck;
			//this._puckLoaded.visible = false;
		
			
			if (InlineShuffle.CurrentPlayer is AI)
			{
				this.enable = false; //disable interaction
				AI(InlineShuffle.CurrentPlayer).think();
			}
			else
			{
				if (InlineShuffle.CurrentPlayer.isRemote)
				{
					this.enable = false; //disable interaction
				}
				else
				{
					this.enable = true;
				}
			}
			
			//start shooting Timer
			InlineShuffle.scoreBoard.shootCounter = InlineShuffle.TIME_OUT;
			InlineShuffle.shootTimer.start();
		
		}
		
		public function unload():void
		{
			//count as shooted
			InlineShuffle.shooter.shoots++;
			
			//reset timer
			InlineShuffle.shootTimer.reset();
			//reset timere display
			InlineShuffle.scoreBoard.shootCounter = 0;
			
			this.enable = false;
			
			//var puck;
			if (this._puckLoaded)
			{
				
				//InlineShuffle.view.dynamicSceneView.scene.removeChild(this._puckLoaded.puckSlideSound3D);
				InlineShuffle.view.scene.removeChild(this._puckLoaded);
				
				delete InlineShuffle.Pucks[this.shoots - 1];
				InlineShuffle.Pucks.length--;
				this._puckLoaded = null;
				
			}
		}
		
		public function set enable(bEnable:Boolean):void
		{
			this._enable = bEnable;
			
			var stage:Stage = InlineShuffle.stage;
			
			if (_enable)
			{
				
				this._puckLoaded.addEventListener(MouseEvent3D.MOUSE_DOWN, startDrag);
				MonsterDebugger.trace(this, "SHOOTER -> enabled");
				
			}
			else
			{
				
				MonsterDebugger.trace(this, "SHOOTER -> disabled");
				stage.removeEventListener(MouseEvent.MOUSE_UP, stopDrag);
				
				//	stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragShooter);
				stage.removeEventListener(Event.ENTER_FRAME, dragShooter);
				
				Mouse.show();
			}
		}
		
		public function get enable():Boolean
		{
			return _enable;
		}
		
		public function shoot():void
		{
			//send to remote player (if it's multi game and player is not remote=> remote only receives)
			if (Game.type == Game.MULTI && !InlineShuffle.CurrentPlayer.isRemote)
			{
				
				//TraceWindow.display("Remote:" + InlineShuffle.CurrentPlayer.isRemote + " name:" + Multiplayer.clientPlayer.name);
				MonsterDebugger.trace(this, "Remote:" + InlineShuffle.CurrentPlayer.isRemote + " name:" + Multiplayer.clientPlayer.name);
				
				Multiplayer.sendObject({type: GameStatus.SHOOT});
			}
			
			//increse number of shoots
			this.shoots++;
			
			//reset timer
			InlineShuffle.shootTimer.reset();
			
			//reset timere display
			InlineShuffle.scoreBoard.shootCounter = 0;
			
			if (this._puckLoaded == null)
			{
				MonsterDebugger.trace(this, "Error: Puck not loaded??? player playing " + InlineShuffle.CurrentPlayer.name + " this client player" + Multiplayer.clientPlayer.name, "", "ERROR", 0xFF00FF);
				
				return;
			}
			
			var time:Number = (getTimer() - _prevTime) * 0.005;
			
			MonsterDebugger.trace(this, "SWIPE time=" + time, "", "SHOOTER>shoot");
			
			//convert swipe into speed
			this._puckLoaded.speed.y = 35//;
			this._puckLoaded.accel.y = -InlineShuffle.Acceleration;
			
			/*if (Game.mode == Game.EXPERT_MODE)
			{
				this._puckLoaded.speed.x = offsetX / time;
				this._puckLoaded.accel.x = -InlineShuffle.Acceleration;
			}*/
			
			MonsterDebugger.trace(this._puckLoaded, "PUCK speed=" + _puckLoaded.speed, "SHOOTER>shoot");
			MonsterDebugger.trace(this._puckLoaded, "PUCK accell=" + _puckLoaded.accel, "SHOOTER>shoot");
			
			//set position of Shooter sound
			this.shooterSound3D.x = _puckLoaded.x;
			this.shooterSound3D.y = _puckLoaded.y;
			this.shooterSound3D.z = _puckLoaded.z;
			//this._puckLoaded.x = this.shooterSound3D.x = this.x;
			//this._puckLoaded.y =this.shooterSound3D.y= this.y;
			//this._puckLoaded.z = this.shooterSound3D.z = this.z;
			
			//muted crossbow sound
			this.shooterSound3D.play(); // 0, 0, new SoundTransform(1, 0));
			
			//this._puckLoaded.visible = true;
			
			//start moving puck
			this._puckLoaded.startPuck();
			
			this._puckLoaded = null; //free shooter
			
			//start main loop (moving checking)
			InlineShuffle.startCheckHitLoop();
		
		}
	
	}

}
