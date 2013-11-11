/**
 * ...
 * @author Default
 * @version 0.1
 */

package
{
	
	
	
	import alternativa.engine3d.core.Sound3D;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.primitives.Cylinder;
	import alternativa.engine3d.primitives.Plane;
	import com.demonsters.debugger.MonsterDebugger;
	import flash.display.Graphics;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.media.ID3Info;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.events.Event;
	
	
	
	public class Puck extends Cylinder
	{
		
	
		
		public var radius:Number;
		//public var height:Number;
		public var speed:Vector3D;
		public var accel:Vector3D;
		public var hasCollided:Boolean = false;
		public var hasCollidedWith:int = -1;
		public var isMoving:Boolean = false;
		public var mass:Number = 1;
		public var belongTo:Player;
		public var puckSlideSound3D:Sound3D;
		public var inx:Number = -1;
		public var prevPosition:Vector3D;
		
		protected var _id:uint=Number.NaN;
		
		public function get position():Vector3D {
			return this.matrix.position;
		}
		
		
		public function set position(p:Vector3D):void {
			this.matrix.position=p;
		}
		
		public function get id():uint 
		{
			return this.parent.getChildIndex(this);
		}
		
		
		public function Puck(player:Player, radius:Number = 100, height:Number = 100, segmentsW:int = 32, segmentsH:int = 30, topRadius:Number = -1,sound:Sound3D=null, initObject:Object = null)
		{
			
				
			super(radius, radius, height, segmentsW, segmentsH, true, false, true, false, player.puckMaterial);
			
			//super(player.puckMaterial, radius, height, segmentsW, segmentsH, topRadius, initObject);
			
			
			this.belongTo = player;
			//this.hasCollidedWith = this.id;
			this.radius = radius;
			//this.height = height;
			this.speed = new Vector3D(); //0,0,0
			this.accel = new Vector3D(); //0,0,0
			this.prevPosition = new Vector3D();
			this.puckSlideSound3D = sound;
			
			
			/*if (InlineShuffle.view)
				if (InlineShuffle.view.dynamicSceneView.scene)
					InlineShuffle.view.dynamicSceneView.scene.addChild(this.puckSlideSound3D);*/
			
					
			//material.interactive = true;
		
		}
		
		public function movePuck():void
		{
			this.prevPosition = this.position;
			
			movePuckAlong("x");
			//movePuckAlong("z");
			movePuckAlong("y");
			
			//set sound factor depending of puck speed
			//this.puckSlideSound3D.factor = Math.sqrt(Math.pow(this.speed.x, 2) + Math.pow(this.speed.z, 2)) / 35
		
		}
		
		//////////////////////////////////////////////////////////////////
		//					startPuck
		/////////////////////////////////////////////////////////////////	
		public function startPuck():void
		{
			//if (this.puckSlideSound3D.soundChannel)
			if (this.puckSlideSound3D)
				this.puckSlideSound3D.stop();
				
			//slide sound
			this.puckSlideSound3D.x = this.x;
			this.puckSlideSound3D.y = this.y;
			this.puckSlideSound3D.z = this.z;
			
			//power grid width is 600 so the pan is 1/y
			this.puckSlideSound3D.play(); // this.x / 600));
			
			//current speed with max speed possible
			//this.puckSlideSound3D.factor = Math.sqrt(Math.pow(this.speed.x, 2) + Math.pow(this.speed.z, 2)) / 35;
			
			this.isMoving = true;
		}
		
		//////////////////////////////////////////////////////////////////
		//					stopPuck(player:Player,pos:Vector3D):Puck
		/////////////////////////////////////////////////////////////////
		public function stopPuck():void
		{
			
			this.isMoving = false;
			this.puckSlideSound3D.stop();
		
			//this.speed.x = 0;
			//this.speed.y = 0;
			//this.speed.z = 0;
		}
		
		//F=m*a=m*u*g
		//vx=v0x-a*t  (- cos accel is trying to stop thing moving or accel is actually deccel)
		//vx should be got 0
		//0=v0x*u*g*t
		//v0x=-u*g*t
		//t=v0x/u*g
		
		//at start v=v0x=some speed
		private function movePuckAlong(axis:String):void
		{
			
			if (Math.abs(this.speed[axis]) >= Math.abs(this.accel[axis]))
			{
				
				//speed down
				//vx=v0x-a*t =v0x-ua;
				
				//or every t=frame
				//vx=vx-a
				this.speed[axis] += this.accel[axis];
				
				//move puck	
				this[axis] += this.speed[axis];
				
				this.puckSlideSound3D[axis] = this[axis];
				
			}
			else
				this.speed[axis] = 0;
		
		}
		
		public function isBehindOf(puck:Puck, offset:Number):Boolean
		{
			return this.y > puck.y - offset;
		}
		
		public function isFrontOf(puck:Puck, offset:Number):Boolean
		{
			return this.y > puck.y + offset;
		}
		
		public function isInRangeOf(puck:Puck, lOffset:Number, rOffset:Number):Boolean
		{
			//front and behind (test for clear front shoot and bouncing to -10)
			return this.x > puck.x - lOffset && this.x < puck.x + rOffset;
		}
		
		/**
		 * returns distance to AB segment or to A or to B depending of what is nearest
		 * @param	A
		 * @param	B
		 * @return
		 */
		public function distanceToSegment2(A:Vector3D, B:Vector3D):Number
		{
			var difBA:Vector3D = B.subtract(A);// Vector3D.sub(B, A);
			var lineModulo:Number = difBA.x * difBA.x + difBA.y * difBA.y + difBA.z * difBA.z; //difBA.modulo;
			var U:Number = ((this.position.x - A.x) * difBA.x + (this.position.y - A.y) * difBA.y + (this.position.z - A.z) * difBA.z) / (lineModulo); //*lineModulo);
			var intersectionPoint:Vector3D;
			
			//if U>0 nearest is B
			//if U=1 near is B
			//if U=0 near is A
			//if U<0 nearest is A
			
			if (U > 1)
				U = 1;
			else if (U < 0)
				U = 0;
			
			//here you can return intersection point if you like
			intersectionPoint = new Vector3D(A.x + U * difBA.x, A.y + U * difBA.y, A.z + U * difBA.z);
			
			//return Vector3D.sub(intersectionPoint, this.position).modulo;
			return intersectionPoint.subtract(this.position).length;//
		}
		
		//Compute the distance from AB to this.position
		//if isSegment is true, AB is a segment, not a line.
		/*double linePointDist(point A, point B, point this.position, bool isSegment){
		   double dist = ((B-A)^(this.position-A)) / sqrt((B-A)*(B-A));
		   if(isSegment){
		   int dot1 = (this.position-B)*(B-A);
		   if(dot1 > 0)return sqrt((B-this.position)*(B-this.position));
		   int dot2 = (this.position-A)*(A-B);
		   if(dot2 > 0)return sqrt((A-this.position)*(A-this.position));
		   }
		   return abs(dist);
		 }*/
		
		/**
		 * returns distance to AB segment or to A or to B depending of what is nearest
		 * @param	A
		 * @param	B
		 * @param	isSegment
		 * @return
		 */
		public function distanceToSegment(A:Vector3D, B:Vector3D, isSegment:Boolean = true):Number
		{
			var difBA:Vector3D;
			var dotNearA:int;
			var dotNearB:int;
			var dist:Number;
			
			if (isSegment)
			{
				//dotNearB = Vector3D.dot(Vector3D.sub(this.position, B), Vector3D.sub(B, A));
				dotNearB = this.position.subtract(B).dotProduct(B.subtract(A));
				
				//check if nearest point is beyound B
				if (dotNearB > 0)
				{ // nearest is B
					//return Vector3D.sub(B, this.position).modulo;
					return B.subtract(this.position).length;
				}
				
				//check if nearest point is beyound A (if 0 or >0 nearest is A
				//dotNearA = Vector3D.dot(Vector3D.sub(this.position, A), Vector3D.sub(A, B));
				dotNearA = this.position.subtract(A).dotProduct(A.subtract(B));
				
				if (dotNearA > 0)
				{ //nearest is A
					
					//return Vector3D.sub(A, this.position).modulo;
					return A.subtract(this.position).length;
				}
				
					//If both dot products are negative, then the nearest point to this.position is somewhere along the segment.
					//=> segment = line logic
				
			}
			
			difBA = B.subtract(A);// Vector3D.sub(B, A); //vector B-A
			
			
			dist = difBA.crossProduct(this.position.subtract(A)).length/difBA.length;//Vector3D.cross(difBA, Vector3D.sub(this.position, A)).modulo / difBA.modulo;
			
			return dist < 0 ? -dist : dist;
		}
		
		//TODO optmize to quadrat distance if possible
		//this is actully distance to line
		public function distanceToLine(A:Vector3D, B:Vector3D):Number
		{
			//Math.abs((x2-x1)(y1-y0)-(x1-x0)(y2-y1))/Math.sqrt(x2-x1)(x2-x1)+(y2-y1)(y2-y1)
			return Math.abs((B.x - A.x) * (A.y - this.y) - (A.x - this.x) * (B.y - A.y)) / Math.sqrt((B.x - A.x) * (B.x - A.x) + (B.y - A.y) * (B.y - A.y));
		
		}
		
		public function isIntersectLineSegment(A:Vector3D, B:Vector3D, lineThickness:Number):Boolean
		{
			
			var discriminant:Number;
			var dx:Number;
			var dy:Number;
			var dr:Number;
			var determinant:Number;
			var x1:Number;
			var y1:Number;
			var x2:Number;
			var y2:Number;
			
			lineThickness = lineThickness * 0.5 + this.radius; //half of line
			
			//translate line coords as much as needed circle to get to (0,0) coords
			//translate line coords as much as needed circle to get to (0,0) coords
			x2 = B.x - this.x;
			x1 = A.x - this.x;
			
			y2 = B.y - this.y;
			y1 = A.y - this.y;
			
			dx = x2 - x1
			dy = y2 - y1
			
			//dr
			//dr = Math.sqrt(Math.pow(dx, 2) + Math.pow(dz, 2));
			dr = Math.sqrt(dx * dx + dy * dy);
			
			//|x1 x2|
			//|y1 y2|
			
			determinant = x1 * y2 - x2 * y1;
			
			//discriminant=r(2)*dr(2)-D(2)
			//discriminant= Math.pow(this.radius+lineThickness, 2) * Math.pow(dr, 2) - Math.pow(determinant,2);
			discriminant = lineThickness * lineThickness * dr * dr - (determinant * determinant);
			
			//discriminant =0 -> tangenta
			//discriminant >0 -> intersection
			//discriminant <0 -> no intersection
			if (discriminant >= 0)
				return true;
			
			return false;
		
		}
		
		/**
		 * from puck with inx to end pucks list
		 * @param	inx
		 */
		public static function checkPuckHit(inx:int):void
		{
			
			var currentPuck:Puck=InlineShuffle.Pucks[inx];
			
			for (var j:int = inx + 1; j < InlineShuffle.Pucks.length; j++)
			{
				
				Puck.correctionBack(currentPuck, InlineShuffle.Pucks[j]);
			}
			
			if (currentPuck.hasCollided)
			{
				//puckCrack sound
				if (InlineShuffle.puckCrackSound3D)
				{
					
					InlineShuffle.puckCrackSound3D.x = currentPuck.x;
					InlineShuffle.puckCrackSound3D.y = currentPuck.y;
					//InlineShuffle.puckCrackSound3D.z = currentPuck.z;
					
					InlineShuffle.puckCrackSound3D.play();
				}
				
			}
		
		}
		
		public static function checkWallsHit(inx:int):void
		{
			
			var currentPuck:Puck = InlineShuffle.Pucks[inx];
			var wall:Wall = MainScene(InlineShuffle.scene).frontWallPlane;
			
			//check Wall hit
			if (currentPuck.y + currentPuck.radius > wall.y)
			{
				//currentPuck.stopPuck();
				
				//wood puck Crack sound
				InlineShuffle.puckWallHitSound3D.play();
				InlineShuffle.puckWallHitSound3D.x = currentPuck.x;
				InlineShuffle.puckWallHitSound3D.y = currentPuck.y;
			//	InlineShuffle.puckWallHitSound3D.z = currentPuck.z;
				
				MonsterDebugger.trace(Puck.checkWallsHit,"PUCK -> puck before hit y:" + currentPuck.y);
				//get out of the wall
				//currentPuck.z = wall.z - currentPuck.radius;
				currentPuck.y = wall.y - currentPuck.radius;
				MonsterDebugger.trace(Puck.checkWallsHit,"PUCK -> puck after hit y:" + currentPuck.y);
				
				currentPuck.hasCollidedWith = wall.id;
				currentPuck.hasCollided = true;
				
				//change only the direction of the normal with wall component of thespeed
				currentPuck.speed.y = -currentPuck.speed.y
				currentPuck.accel.y = -currentPuck.accel.y;
				/*currentPuck.speed.z = -currentPuck.speed.z
				currentPuck.accel.z = -currentPuck.accel.z;
				*/
				
				
				currentPuck.startPuck();
			}
		}
		
		private static function bounce(body1:Puck, body2:Puck,graphics:Graphics=null):void
		{
			var v_v2tPrime:Vector3D;
			var v_v2nPrime:Vector3D;
			var v_v1tPrime:Vector3D;
			var v1tPrime:Number;
			var v2nPrime:Number;
			var v1nPrime:Number;
			var v2tPrime:Number;
			var v_v1nPrime:Vector3D;
			var v2t:Number;
			var v2n:Number;
			var v1t:Number;
			var v1n:Number;
			
			
			var pos1:Vector3D = body1.position;// new Vector3D(body1.x, 0, -body1.y);
			var pos2:Vector3D = body2.position;// new Vector3D(body2.x, 0, -body2.y);
			var speed1:Vector3D = body1.speed;// new Vector3D(0, 0, 10); //if you attack from top -10 for testing
			var speed2:Vector3D = body2.speed;// new Vector3D();
			/*var mass1:Number = 100;
			var mass2:Number = 100;*/
			var accelConst:Number = InlineShuffle.Acceleration;
			var accel1:Vector3D = body1.accel;
			var accel2:Vector3D = body2.accel;
			var acc_v1nPrime:Vector3D;
			var acc_v1tPrime:Vector3D;
			
			accel1.x = accel1.y = 0;
			accel2.x = accel2.y = 0;
			
			var isLeftNormal:Boolean = false;//left or right normal
			
			// Compute unit normal and unit tangent vectors
			var v_n:Vector3D = pos2.subtract(pos1);// Vector3D.sub(pos2, pos1); //v_n = normal vec. - a vector normal to the collision surface 
			//actully vector into direction from one bodycenter to other
			var v_un:Vector3D = v_n.clone();//Vector3D.unit(v_n); // unit normal vector
			v_un.normalize();
			
			var v_ut:Vector3D;
			
			/*Vector2D v_n = b2.pos() - b1.pos();
			   Vector2D v_un = v_n.unitVector();
			 Vector2D v_ut(-v_un.y(), v_un.x());*/
			 
			 
			 MonsterDebugger.trace(Puck.bounce,"BEFORE BOUNCE DATA->speed1:" + body1.speed+" accel1:"+body1.accel + " , speed2:" + body2.speed+" accel2:"+body2.accel);
	
			
			if (pos1.x > pos2.x)
			{
				//trace("RIGHT");
				v_ut = new Vector3D(v_un.y, 0, -v_un.x); //unit tanget vector(right)
			}
			else
			{
				v_ut = new Vector3D(-v_un.y, 0, v_un.x); //	unit tangent vector(left)
				//trace("LEFT");
				isLeftNormal = true;
			}
			
			
			
			// Compute scalar projections of velocities onto v_un and v_ut
			//actually decompose speed on tangent and normal component
			v1n = v_un.dotProduct(speed1);// Vector3D.dot(v_un, speed1);
			v1t = v_ut.dotProduct(speed1);// Vector3D.dot(v_ut, speed1);
			v2n = v_un.dotProduct(speed2);// Vector3D.dot(v_un, speed2);
			v2t = v_ut.dotProduct(speed2);// Vector3D.dot(v_ut, speed2);
			
			/*
			   double v1n = v_un * b1.v(); // Dot product
			   double v1t = v_ut * b1.v();
			   double v2n = v_un * b2.v();
			 double v2t = v_ut * b2.v();*/
			
			// Compute new tangential velocities
			v1tPrime = v1t;
			v2tPrime = v2t;
			// Note: in reality, the tangential velocities do not change after the collision
			/*double v1tPrime = v1t; // Note: in reality, the tangential velocities do not change after the collision
			 double v2tPrime = v2t;*/
			 
			// Compute new normal velocities using one-dimensional elastic collision equations in the normal direction
			// Division by zero avoided. See early return above.
			/*var v1nPrime:Number=(v1n * (mass1 - mass2) + 2. * mass2 * v2n) / (mass1 + mass2);
			 var v2nPrime:Number=(v2n * (mass2 - mass1) + 2. * mass1 * v1n) / (mass1 + mass2);*/
			 
			 //mass1=mass2
			v1nPrime = v2n;
			v2nPrime = v1n;
			
		
			
			// Compute new normal velocities using one-dimensional elastic collision equations in the normal direction
			// Division by zero avoided. See early return above.
			/*	double v1nPrime = (v1n * (b1.m() - b2.m()) + 2. * b2.m() * v2n) / (b1.m() + b2.m());
			 double v2nPrime = (v2n * (b2.m() - b1.m()) + 2. * b1.m() * v1n) / (b1.m() + b2.m());*/
			
			// Compute new normal and tangential velocity vectors
			v_v1nPrime = v_un.clone();
			 v_v1nPrime.scaleBy(v1nPrime);//v_v1nPrime = Vector3D.mul(v1nPrime, v_un)
			 
			 v_v1tPrime = v_ut.clone();
			v_v1tPrime.scaleBy(v1tPrime);//v_v1tPrime = Vector3D.mul(v1tPrime, v_ut)
			
			v_v2nPrime = v_un.clone();
			v_v2nPrime.scaleBy(v2nPrime);//v_v2nPrime =Vector3D.mul(v2nPrime, v_un)
			
			v_v2tPrime=v_ut.clone();
			 v_v2tPrime.scaleBy(v2tPrime);//v_v2tPrime =Vector3D.mul(v2tPrime, v_ut)
			/*
			   Vector2D v_v1nPrime = v1nPrime * v_un; // Multiplication by a scalar
			   Vector2D v_v1tPrime = v1tPrime * v_ut;
			   Vector2D v_v2nPrime = v2nPrime * v_un;
			 Vector2D v_v2tPrime = v2tPrime * v_ut;*/
			
			//back from tangent/normal system to x/z system
			// Set new velocities in x and z coordinates
			speed1.x = v_v1nPrime.x + v_v1tPrime.x;
			speed1.y = v_v1nPrime.y + v_v1tPrime.y;
			
			accel1.x=-speed1.x;
			accel1.y = -speed1.y;
			
			 //accel1=Vector3D.mul(accelConst,Vector3D.unit(accel1));	
			accel1.normalize();
			accel1.scaleBy(accelConst); 	
			
			speed2.x=v_v2nPrime.x+ v_v2tPrime.x;
		    speed2.y=v_v2nPrime.y+ v_v2tPrime.y;
			
		
			accel2.x=-speed2.x;
	       accel2.y=-speed2.y;
		   
		   //accel2=Vector3D.mul(accelConst,Vector3D.unit(accel2));
	       accel2.normalize();
		   accel2.scaleBy(accelConst);
			
		
			
			// Set new velocities in x and y coordinates
			/*
			   b1.setVX(v_v1nPrime.x() + v_v1tPrime.x());
			   b1.setVY(v_v1nPrime.y() + v_v1tPrime.y());
			   b2.setVX(v_v2nPrime.x() + v_v2tPrime.x());
			 b2.setVY(v_v2nPrime.y() + v_v2tPrime.y());*/
			 
			 
			body1.speed = speed1;
			body2.speed = speed2;
			 
			
			body1.accel = accel1;
			body2.accel = accel2;
			
			
				MonsterDebugger.trace(Puck.bounce,body1,"AFTER BOUNCE DATA->speed1:" + body1.speed+" accel1:"+body1.accel + " , speed2:" + body2.speed+" accel2:"+body2.accel);
			
			if(graphics){
			//draw a vector normal to the collision surface
			graphics.lineStyle(1, 0x0000FF);
			graphics.moveTo(pos1.x, -pos1.y);
			graphics.lineTo(pos1.x + v_n.x, -pos1.y - v_n.y);
			
			/*draw accelerations*/
			graphics.lineStyle(1, 0xCCCCCC);
			graphics.moveTo(pos1.x, -pos1.y);
			graphics.lineTo(pos1.x + accel1.x, -pos1.y - accel1.y);
			
			graphics.lineStyle(1, 0x666666);
			graphics.moveTo(pos1.x, -pos1.y);
			graphics.lineTo(pos1.x + accel2.x, -pos1.y - accel2.y);
			
		
			
			/* draw speeds */
			graphics.lineStyle(1, 0xFF00FF);
			graphics.moveTo(pos2.x, -pos2.y);
			graphics.lineTo(pos2.x + speed2.x, -pos2.y - speed2.y);
			
			graphics.lineStyle(1, 0xFF00FF);
			graphics.moveTo(pos1.x, -pos1.y);
			graphics.lineTo(pos1.x + speed1.x, -pos1.y - speed1.y); 
			
			//draw unit vectors
			graphics.lineStyle(1, 0x00FF00);
			graphics.moveTo(pos1.x, -pos1.y);
			graphics.lineTo(pos1.x + v_un.x, -pos1.y - v_un.y);
			
			graphics.lineStyle(1, 0xFF0000);
			graphics.moveTo(pos1.x, -pos1.y);
			graphics.lineTo(pos1.x + v_ut.x, -pos1.y - v_ut.y);
		
			}
		
		}
		
	
	
		
		public static function correctionBack(body1:Puck, body2:Puck):void
		{
			var ratio:Number;
			//frst move all then make correction
			
			//movement Vector 
			var movBody1Vec:Vector3D;
			var movBody2Vec:Vector3D;
			var movVec:Vector3D;
			var movUnitVec:Vector3D;
			
			//vector between center points of bodies 
			var cenVec:Vector3D;
			
			//projection of cenVec on movement vector
			var cenProjVec:Vector3D;
			
			var p2Vec:Vector3D; //dot P2
			var p3Vec:Vector3D; //dot P3
			
			var cenNormVec:Vector3D;
			var newSpeedVec:Vector3D;
			
			//(before and after movement body1)
			movBody1Vec = new Vector3D();
			movBody1Vec = body1.position.subtract(body1.prevPosition);//Vector3D.sub(body1.position, body1.prevPosition);
			
			//(before and after movement body2)
			movBody2Vec = new Vector3D();
			movBody2Vec = body2.position.subtract(body2.prevPosition);//Vector3D.sub(body2.position, body2.prevPosition);
			
			//reduce movement vector from ball2 from movement vector of ball1
			movVec = new Vector3D();
			movVec = movBody1Vec.subtract(movBody2Vec);//Vector3D.sub(movBody1Vec, movBody2Vec);
			
			//between bodies (pos)centers
			cenVec = new Vector3D();
			cenVec = body2.prevPosition.subtract(body1.prevPosition);//Vector3D.sub(body2.prevPosition, body1.prevPosition);
			
			movUnitVec = movVec.clone();//Vector3D.unit(movVec);
			movUnitVec.normalize();
			
			
			//cenProjVec = Vector3D.vproj(cenVec, movVec);
			cenProjVec = movUnitVec.clone();
			cenProjVec.scaleBy(cenVec.dotProduct(movUnitVec));
			
						
			
			//vector in direction to center of body2 normal to movment vector
			cenNormVec = new Vector3D();
			p2Vec = body1.prevPosition.add(cenProjVec);// Vector3D.add(body1.prevPosition, cenProjVec);
			cenNormVec = body2.prevPosition.subtract(p2Vec);   //Vector3D.sub(body2.prevPosition, p2Vec);
			
			var diff:Number= InlineShuffle.PuckDiameter - cenNormVec.length;
			
			if (diff > 0)
			{
				
				//amount to move back moving ball
				var moveBack:Number = Math.sqrt(Math.pow(InlineShuffle.PuckDiameter, 2) - Math.pow(cenNormVec.length, 2));
				//newSpeedVec = new Vector3D();
				//Vector3D.sub(p2Vec, Vector3D.mul(moveBack, movUnitVec));
				p3Vec = movUnitVec.clone();
				p3Vec.scaleBy(moveBack);
				p3Vec = p2Vec.subtract(p3Vec);
				newSpeedVec = p3Vec.subtract(body1.prevPosition);//Vector3D.sub(p3Vec, body1.prevPosition);
				
				
				
				//check if p3 is on the movement vector
				if (newSpeedVec.length <= movVec.length &&  newSpeedVec.dotProduct(movVec) >= 0)//Vector3D.dot(newSpeedVec, movVec)
				{
					//collision
					ratio = newSpeedVec.length / movVec.length;
					
					//apply back corection
					body1.x = body1.prevPosition.x + ratio * movBody1Vec.x;
					//body1.y  =body1.prevPosition.y+ratio*movBody1Vec.y;
					body1.y = body1.prevPosition.y + ratio * movBody1Vec.y;
					
					//apply back corection
					body2.x = body2.prevPosition.x + ratio * movBody2Vec.x;
					//body1.y  =body1.prevPosition.y+ratio*movBody1Vec.y;
					body2.y = body2.prevPosition.y + ratio * movBody2Vec.y;
					
					//TODO check where ID's are set
					body1.hasCollidedWith = body2.id;
					body2.hasCollidedWith = body1.id;
					body1.hasCollided = true;
					body2.hasCollided = true;
					
					if (body1.isMoving)
						body1.startPuck();
					
					if (body2.isMoving)
						body2.startPuck();
					
					MonsterDebugger.trace(Puck.correctionBack,"Puck-> Positions Before bounce:" + body1 + "," + body2);
					
					
					//calculate bounce
					Puck.bounce(body1, body2);
						//MonsterDebugger.trace(this,"collision correction");
					
				}
				else
				{
					//no collision
					//MonsterDebugger.trace(this,"PUCK: no collision p3 is on the movement vector");
				}
				
			}
		
		}
		
		
	
		
		
		
		
		
		
		
		
		
	
	}

}
