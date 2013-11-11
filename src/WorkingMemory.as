/**
 * ...
 * @author Default
 * @version 0.1
 */

package
{
	
	import com.demonsters.debugger.MonsterDebugger;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	
	public class WorkingMemory
	{
		
		//player2 has
		public static var player2HasPuckOnMinus10:uint = 0;
		public static var player2HasPuckOn10:uint = 0;
		public static var player2HasPuckOnLeft8:uint = 0;
		public static var player2HasPuckOnRight8:uint = 0;
		public static var player2HasPuckOnLeft7:uint = 0;
		public static var player2HasPuckOnRight7:uint = 0;
		
		//player1 has
		public static var player1HasPuckOnMinus10:uint = 0;
		public static var player1HasPuckOn10:uint = 0;
		public static var player1HasPuckOnLeft8:uint = 0;
		public static var player1HasPuckOnRight8:uint = 0;
		public static var player1HasPuckOnLeft7:uint = 0;
		public static var player1HasPuckOnRight7:uint = 0;
		
		public static var _leftOutterSegmentB:Vector3D = new Vector3D(-230, 0, 657); //				 left(B) right(B)        
		public static var _rightOutterSegmentB:Vector3D = new Vector3D(230, 0, 657); //                   \   /      
		public static var _centerSegmentA:Vector3D = new Vector3D(0, 0, 324); // 						 		 \/
																										   //top Vector3D of the triangle->   A
		
		public static var _minus10ScoreSegmentA:Vector3D = new Vector3D(-166, 0, 691); //    \   A-------- save(-10)zone --------B   /
		public static var _minus10ScoreSegmentB:Vector3D = new Vector3D(166, 0, 691); //imagery line passing thru middle of -10 
		
		public static var _leftSmallSegmentA:Vector3D = new Vector3D(-186, 0, 657); //     \						-10						      /
		public static var _leftSmallSegmentB:Vector3D = new Vector3D(-230, 0, 657); //      \____________________________/			
																																				// left(B  A\	    |	    /A	 right(B)
																																				//				 \	7  |  7 /		
		public static var _rightSmallSegmentA:Vector3D = new Vector3D(186, 0, 657); //		 
		public static var _rightSmallSegmentB:Vector3D = new Vector3D(230, 0, 657); //	
		
			
			
			//
			public static var _thirdHorizontalA:Vector3D = new Vector3D(230, 0, 657); ////     \						-10				     	      /
			public static var _thirdHorizontalB:Vector3D = new Vector3D(230, 0, 657); //		 \___________________________/	
			//
			public static var _secondHorizontalA:Vector3D = new Vector3D(-155, 0, 546); // 					  \ 7  |  7 /	
			public static var _secondHorizontalB:Vector3D = new Vector3D(155, 0, 546); //					   \__|__/
			//
			public static var _firstHorizontalA:Vector3D = new Vector3D(-77, 0, 432); //								\10/
			public static var _firstHorizontalB:Vector3D = new Vector3D(77, 0, 432); //  								  \/
			//																															
			public static var _middleA:Vector3D = new Vector3D(0, 0, 436); //								|
			public static var _middleB:Vector3D = new Vector3D(0, 0, 657);//	
			
			public static var _dummyPuck:Puck = new Puck(new Player());
			public static var _opportunity:Opportunity = new Opportunity();
			public static var _oppCoef:OpportunityCoef = new OpportunityCoef();
		
		
		
		private static var _player1Scores:Dictionary = new Dictionary(true);
		//public static var _virtualPuck:Puck = new Puck(InlineShuffle.Players[1], 15, 100, 8, 6);
		//public static var _mulPuckDistances:Vector.<Number> = Vector.<Number>([InlineShuffle.PuckDiameter, 2 * InlineShuffle.PuckDiameter, 3 * InlineShuffle.PuckDiameter, 4 * InlineShuffle.PuckDiameter, 5 * InlineShuffle.PuckDiameter, 6 * InlineShuffle.PuckDiameter]);
		public static var 	segments:Vector.<Vector3D> = initSegments();
	
		
	
	
		//public static var _mulPuckDistances:Vector.<Number> = Vector.<Number>([30,60,90,120,150]);
		
		
		
		private static function initSegments():Vector.<Vector3D> {
			var seg:Vector.<Vector3D>= new Vector.<Vector3D>(12, true);
			seg[0] = _middleA;
			seg[1] = _middleB;
			seg[2] = _thirdHorizontalA;
			seg[3] = _thirdHorizontalB;
			seg[4] = _secondHorizontalA;
			seg[5] = _secondHorizontalB;
			seg[6] = _firstHorizontalA;
			seg[7] = _firstHorizontalB;
			seg[8] = _centerSegmentA;
			seg[9] = _rightOutterSegmentB;
			seg[10] = _centerSegmentA;
			seg[11] =_leftOutterSegmentB;
			
			return seg;
		}
		
		
		public static function player1Score(puck:Puck, scoreField:ScoreField):void
		{
			var side:String = "";
			var varName:String;
			
			if (scoreField.score > 0) //if puck is in -10 not need to check
				_player1Scores[puck] = scoreField;
			
			switch (scoreField.side)
			{
				case-1: 
					side = "Left";
				case 1: 
					side = "Right";
			}
			
			if (scoreField.score < 0)
				side += "Minus";
			
			varName = "player1HasPuckOn" + side + Math.abs(scoreField.score);
			// trace(varName);
			
			

			
			WorkingMemory[varName] = WorkingMemory[varName] + 1;
		}
		
		public static function reset():void
		{
			_player1Scores = new Dictionary(true);
			
			player1HasPuckOnMinus10 = 0;
			player1HasPuckOn10 = 0;
			player1HasPuckOnLeft8 = 0;
			player1HasPuckOnRight8 = 0;
			player1HasPuckOnLeft7 = 0;
			player1HasPuckOnRight7 = 0;
		}
		
		
		/**
		 * collects lengths of scoring imaginary rects(width=PuckDiameter) in direction of the backBounceRay 
		 * @param	puckPosition
		 * @param	backRay
		 * @param	drawingContainer
		 * @return
		 */
		public static function evaluateOpportunityCoef(backRayStart:Vector3D,backRayEnd:Vector3D,drawingContainer:Sprite=null):OpportunityCoef {
			
			//length of area bounded with rect where puck can be and score
			var scoringRectLength:Number;
			var interPointGraphic:DisplayObject;
			
			var diff:Number;
			var topInterPoint:Vector3D;
			var bottomInterPoint:Vector3D;
			
			var topIntersectionPoints:Vector.<Vector3D>=new Vector.<Vector3D>();
			var bottomIntersectPoints:Vector.<Vector3D> = new Vector.<Vector3D>;
			
			var scoreOpportunityCoef:Number = 1;//min=1
			var maxRectLength:Number = 1;
			var maxRectStartPoint:Vector3D;
			
			var i:int = 0;
			var intersLen:int;
			
            // topRay and bottomRay are outline of bouncing direction with width=2*R (R=puck radius)
			//TODO this could go static
			var topRayA:Vector3D = new Vector3D();
			var topRayB:Vector3D = new Vector3D();
			var bottomRayA:Vector3D = new Vector3D();
			var bottomRayB:Vector3D = new Vector3D();
			
			var topCut:Number;
			var bottomCut:Number;
			var puckDiameter:Number = InlineShuffle.PuckDiameter;
			var lineTickness:Number = InlineShuffle.ScoreFieldLineTickness;
			var bLeft:Boolean;
			var graphics:Graphics;
			var dDiv:Number;
			var backRayUnit:Vector3D;
			var startTopRay:Vector3D;
			var startBottomRay:Vector3D;
			var isTop:Boolean;
			var plannedBounceDistance:Number = 0;
			var score:Number=0;
			
			
			//m=-1/m;  is slope of normal to line with slope m=(backRay.z-puckPosition.z)/(backRay.x-puckPosition.x);
			
			var m:Number = -(backRayEnd.x - backRayStart.x) / (backRayEnd.z - backRayStart.z);
			
			
		
		        dDiv = puckDiameter / (2 * Math.sqrt(1 + m * m));
				
				
			if(drawingContainer)
			//if(drawingContainer.graphics)
			  graphics = drawingContainer.graphics;
			
				//create top and bottom ray parallel to back bounce ray at distance or Puck Radius
						topRayA.x = backRayStart.x+dDiv;
						topRayA.z = backRayStart.z+m*(topRayA.x-backRayStart.x);
						topRayB.x = backRayEnd.x+dDiv;
						topRayB.z = backRayEnd.z+m*(topRayB.x-backRayEnd.x);
		
						
						bottomRayA.x = backRayStart.x-dDiv;
						bottomRayA.z = backRayStart.z +m*(bottomRayA.x-backRayStart.x);
						bottomRayB.x = backRayEnd.x-dDiv;
						bottomRayB.z = backRayEnd.z + m * (bottomRayB.x - backRayEnd.x);
						
						startTopRay = new Vector3D(topRayA.x,topRayA.y,topRayA.z);
					    startBottomRay = new Vector3D(bottomRayA.x,bottomRayA.y,bottomRayA.z);
					
					
					 //Draw 
					 if (graphics) {
						 
						graphics.lineStyle(1, 0x00ff00);
						graphics.moveTo(topRayA.x, -topRayA.z);
						graphics.lineTo(topRayB.x, -topRayB.z);
					
						
						graphics.moveTo(bottomRayA.x, -bottomRayA.z);
						graphics.lineTo(bottomRayB.x,- bottomRayB.z);
					 }	
						
			
			
			
										//check intersection of bouncing outline rays with score lines
										for (i = 0; i < WorkingMemory.segments.length; i+=2)
										{
											topInterPoint =WorkingMemory.lineIntersectLine(topRayA, topRayB, segments[i], segments[i + 1]);
											if (topInterPoint)
											{
												topIntersectionPoints.push(topInterPoint);
												
												if (drawingContainer) {
													//drawing
													interPointGraphic =drawingContainer.addChild(new IntersectPoint());
													interPointGraphic.x = topInterPoint.x;
													interPointGraphic.y = -topInterPoint.z;
												}
												
											}
											
											bottomInterPoint = WorkingMemory.lineIntersectLine(bottomRayA, bottomRayB, segments[i], segments[i + 1]);
											if (bottomInterPoint)
											{
												bottomIntersectPoints.push(bottomInterPoint);
												
												if (drawingContainer) {
													//drawing
													interPointGraphic = drawingContainer.addChild(new IntersectPoint());
													interPointGraphic.x = bottomInterPoint.x;
													interPointGraphic.y = -bottomInterPoint.z;
												}
												
											}
											
											
										}
										
										
										bLeft=backRayStart.x>backRayEnd.x? true: false;
										
										if(!bLeft){
											//sort in acdenting for right bounce
										   bottomIntersectPoints=bottomIntersectPoints.sort(WorkingMemory.sortIntersectionsByXAsc);
										   topIntersectionPoints=topIntersectionPoints.sort(WorkingMemory.sortIntersectionsByXAsc);
										}else{
											//sort in desc for left bounce
											bottomIntersectPoints=bottomIntersectPoints.sort(WorkingMemory.sortIntersectionsByXDesc);
											topIntersectionPoints=topIntersectionPoints.sort(WorkingMemory.sortIntersectionsByXDesc);
										}
										
										
										
											var tempPoint:Vector3D;
											
											if (bottomIntersectPoints.length == 0 || topIntersectionPoints.length==0) {
												trace(" bottomIntersectPoints or topIntersectionPoints are 0 length");
												return null;
											}
			
										//duplication of last-1 point when diffrent number of intersectionPoints
										if (bottomIntersectPoints.length < topIntersectionPoints.length) {
										
										
												if (bottomIntersectPoints.length == 1)
												{
														bottomIntersectPoints[1] = bottomIntersectPoints[0];
												}
												else
												{	
													   tempPoint = bottomIntersectPoints[bottomIntersectPoints.length -1];
														bottomIntersectPoints[bottomIntersectPoints.length - 1] = bottomIntersectPoints[bottomIntersectPoints.length -2];
														bottomIntersectPoints[bottomIntersectPoints.length] = tempPoint;
												}
												
											
										
										}else if(bottomIntersectPoints.length>topIntersectionPoints.length) {
											
											
											if (topIntersectionPoints.length == 1) {
											
												topIntersectionPoints[1] = topIntersectionPoints[0];
											}else {
												tempPoint = topIntersectionPoints[topIntersectionPoints.length - 1];
												topIntersectionPoints[topIntersectionPoints.length - 1] = topIntersectionPoints[topIntersectionPoints.length - 2];
												topIntersectionPoints[topIntersectionPoints.length] = tempPoint;
											}
											
											
										
										}
								
										
										intersLen = bottomIntersectPoints.length;
										
										for(i=0;i<intersLen;i++)
										{
											
												   topInterPoint=topIntersectionPoints[i]
													bottomInterPoint=bottomIntersectPoints[i];
											
												if (graphics) {
																							
													//drawings
													graphics.lineStyle(10/(i+1),Math.random() * 0xFFFFFF);
													graphics.moveTo(topRayA.x, -topRayA.z);
													graphics.lineTo(topInterPoint.x, -topInterPoint.z);
													
													graphics.moveTo(bottomRayA.x, -bottomRayA.z);
													graphics.lineTo(bottomInterPoint.x,- bottomInterPoint.z);
												}	
																
													//check which cut is bigger( smaller cut  -2*R is actually scoring option)
													topCut = topRayA.x - topInterPoint.x;
													bottomCut = bottomRayA.x - bottomInterPoint.x;
													
													//imaginary polygon(rect) is formed between top and bottom ray  started from bounce back puck and intersection points with segments
													
													//smaller cut is taking in consideration
													if (topCut > bottomCut)
													{
														//scoringRectLength = Vector3D.sub(bottomInterPoint, bottomRayA).modulo;
														
														scoringRectLength = bottomInterPoint.subtract(bottomRayA).length;
													  
														//for Vector3D
														//distance = bottomInterPoint.subtract(bottomRayA).length;
														
													}
													else
													{
														
														//scoringRectLength = Vector3D.sub(topInterPoint, topRayA).modulo;
														scoringRectLength = topInterPoint.subtract( topRayA).length;
															//for Vector3D
														   //distance = topInterPoint.subtract(topRayA).length;
													}
													
													//trace("Rect points:start(x,y) ",topRayA,bottomRayA," end(x,y) "+topInterPoint,bottomInterPoint);
													//trace("distance available for bounce in rect is:"+distance);
													
													//scoring save length - save offset distance
													diff = scoringRectLength - puckDiameter - 2 * lineTickness;
													
													
													
													if (diff > 0) {
														
														//found rect with max area
														if (scoringRectLength > maxRectLength)
														{
															maxRectLength = scoringRectLength;
															
													     	if (topCut > bottomCut)
															{
															       maxRectStartPoint = bottomRayA;
																     isTop = false;
															}
															else
															{
																  maxRectStartPoint = topRayA;
																  isTop = true;
															}
															
														}
														
														scoreOpportunityCoef += diff
													}
												
												
											
												
											//avoiding cross lines spot problem(when scoring field line cross is inside imageginary scoring rect)
											//
											if (  ((bLeft && bottomInterPoint.x == _middleA.x &&  topInterPoint.x > 0  &&  bottomInterPoint.x!=bottomIntersectPoints[i+1].x)  || (!bLeft && topInterPoint.x == _middleA.x && bottomInterPoint.x < 0) && topInterPoint.x!=topIntersectionPoints[i+1].x )){
										
												i++;
												if(i<intersLen){
												topRayA=topIntersectionPoints[i]
												bottomRayA=bottomIntersectPoints[i];
												}
												
											}else{
												topRayA=topInterPoint;
												bottomRayA = bottomInterPoint;
											}
										}//for
										
										//_oppCoef.assumedPosition= null;
										
										//calculate assumed shooting puck bounce position
										if (scoreOpportunityCoef > 1) {
											
												//unit in direction of back bounce	
												//backRayUnit = Vector3D.unit(Vector3D.sub(backRayEnd, backRayStart));
												
												backRayUnit = backRayEnd.subtract(backRayStart);
												backRayUnit.normalize();
												
												//calc distance from start top/bottom ray point to first rect(rect with max length) point + half rect width
												if(isTop)
												    //plannedBounceDistance=Vector3D.sub(maxRectStartPoint, startTopRay).modulo + maxRectLength * 0.5;
													plannedBounceDistance=maxRectStartPoint.subtract(startTopRay).length + maxRectLength * 0.5;
												else
												   // plannedBounceDistance=Vector3D.sub(maxRectStartPoint, startBottomRay).modulo + maxRectLength * 0.5;
												   plannedBounceDistance=maxRectStartPoint.subtract(startBottomRay).length + maxRectLength * 0.5;
												
													//extend unit to 
													//backRayUnit=Vector3D.mul( plannedBounceDistance, backRayUnit);
													//backRayUnit = Vector3D.add(backRayStart, backRayUnit);
													backRayUnit.scaleBy(plannedBounceDistance);
													backRayUnit = backRayStart.add( backRayUnit);
													
													_dummyPuck.position = backRayUnit;
												
												//trace("Back Ray UNIT:",backRayUnit);
													
													score = opportunityScoreField(_dummyPuck);
													
													if (score)
													scoreOpportunityCoef = scoreOpportunityCoef * score;
													
													 //direction of bounce back
													 if (graphics) {
														 
														graphics.lineStyle(5, 0x00ff00);
														graphics.moveTo(backRayStart.x, -backRayStart.z);
														graphics.lineTo(backRayUnit.x, -backRayUnit.z);
														
														trace("WorkingMemory>evaluateOpporutintyCoef Score:", score,"maxRectLen:" ,maxRectLength);
													
													 }	
													 
												
													 _oppCoef.assumedPosition =backRayUnit;
												
										}
									
										_oppCoef.score = score;
										_oppCoef.value = scoreOpportunityCoef;
										
											return _oppCoef;
		}
		
		public static function evaluateOpportunities():void
		{
			var bestPuck:Puck;
			var opportunityValue:int;
			
			for (var currentPuck:* in _player1Scores)
			{
				MonsterDebugger.trace(WorkingMemory.evaluateOpportunities,"PACK" + currentPuck + " evaluateOpportunities");
				
				opportunityValue = evaluatePackAsHitOpportunity(currentPuck);
				MonsterDebugger.trace(WorkingMemory,"PACK" + currentPuck.toString() + " Opportunity:" + opportunityValue);
			}
			
			
			
		}
		
		private static function evaluatePackAsHitOpportunity(puck:Puck):int
		{
			var opportunity:int = 0;
			var scoreField:ScoreField;
			
			for each (var currentPuck:Puck in InlineShuffle.Pucks)
			{
				
				/*if (currentPuck != puck)//not the same puck
				   {
				   trace(puck.x-InlineShuffle.PuckDiameter,"<",currentPuck.x,"<",puck.x+InlineShuffle.PuckDiameter);
				   //trace((puck.x + d)+">"+currentPuck.x+">"+(puck.x - d));
				   if (currentPuck.isInRangeOf(puck)) {
				   opportunity = 4;
				
				   //check  if puck after bounce can score (one puck dimension after puck being hit as save score area)
				   _virtualPuck.x = puck.x;
				   _virtualPuck.z = puck.z - InlineShuffle.PuckDiameter;
				
				   opportunity += opportunityScoreField(_virtualPuck);
				
				   //Input variables (distance to puck, r, puck to -10)
				
				
				   }else {
				
				 }*/
				
				if (currentPuck != puck) //not the same puck 
				{
					
					scoreField = _player1Scores[scoreField]; //
					
					checkBounce(puck, scoreField);
					
				}
			}
			
			return opportunity;
		}
		
		public static function checkBounce(puck:Puck, scoreField:ScoreField):void
		{
			
			switch (scoreField.side)
			{
				case 1:
					
					break;
				case-1:
			
				//outline Number3Ds
				//scoreField.outline[0],scoreField.outline[3]
			
				//draw line from puck
				//90 / 7=3
				//for (var angle:int = 0;angle<90
				//y=kx; x=const =600;
			
				//break;
			
			}
		}
		
		//side
		
		//front clear => opportunity weight=1(check the rest only if this is ok)
		//front clear  with score (bounce one puck size) => opportunity weight=1
		//front clear  with score (bounce two puck size) => opportunity weight=2
		
		//when puck target is far need greater power to hit it less
		//when puck target is near and it should go far greater power needed
		
		//---------------------------------------------------------------
		//Checks for intersection of Segment if as_seg is true.
		//Checks for intersection of Line if as_seg is false.
		//Return intersection of Segment AB and Segment EF as a Vector3D
		//Return null if there is no intersection
		//---------------------------------------------------------------
			public static function lineIntersectLine(A:Vector3D, B:Vector3D, E:Vector3D, F:Vector3D, as_seg:Boolean = true):Vector3D
		   {
		   var dABz:Number;
		   var denom:Number;
		   //intersection Vector3D
		   var ip:Vector3D;
		   var a1:Number;
		   var a2:Number;
		   var b1:Number;
		   var b2:Number;
		   var c1:Number;
		   var c2:Number;
		
		   var dipBx:Number;
		   var dipBz:Number;
		   var dAz:Number;
		   var dABx:Number;
		
		   var dAx:Number;
		   var dEx:Number;
		   var dEz:Number;
		
		   var dEFx:Number = E.x - F.x;
		   var dEFz:Number = E.z - F.z;
		
		   dABx = A.x - B.x;
		   dABz = A.z - B.z;
		
		
		   a1 = B.z - A.z;
		   //a1 = -dABz;
		
		   //b1 = A.x - B.x;
		   b1 = dABx;
		
		   c1 = B.x * A.z - A.x * B.z;
		   a2 = F.z - E.z;
		   //a2 = -dEFz;
		
		   //b2 = E.x - F.x;
		   b2 = dEFx;
		   c2 = F.x * E.z - E.x * F.z;
		
		   denom = a1 * b2 - a2 * b1;
		
		   if (denom == 0)
		   {
		   return null;
		   }
		
		   ip = new Vector3D();
		   ip.x = (b1 * c2 - b2 * c1) / denom;
		   ip.z = (a2 * c1 - a1 * c2) / denom;
		
		   //---------------------------------------------------
		   //Do checks to see if intersection to endNumber3Ds
		   //distance is longer than actual Segments.
		   //Return null if it is with any.
		   //---------------------------------------------------
		
		   if (as_seg)
		   {
		
		   dipBx = ip.x - B.x;
		   dipBz = ip.z - B.z;
		
		
		   var mul_dABx2dABz2:Number;
		   mul_dABx2dABz2 = dABx * dABx + dABz * dABz;
		   //if (Math.pow(ip.x - B.x, 2) + Math.pow(ip.z - B.z, 2) > Math.pow(A.x - B.x, 2) + Math.pow(A.z - B.z, 2))
		   if (dipBx*dipBx + dipBz*dipBz > mul_dABx2dABz2)
		   {
		   return null;
		   }
		
		   var dipAx:Number = ip.x - A.x;
		   var dipAz:Number = ip.z - A.z;
		
		   //if (Math.pow(ip.x - A.x, 2) + Math.pow(ip.z - A.z, 2) > Math.pow(A.x - B.x, 2) + Math.pow(A.z - B.z, 2))
		   if (dipAx*dipAx + dipAz*dipAz > mul_dABx2dABz2)
		   {
		   return null;
		   }
		
		   var dipFx:Number = ip.x - F.x;
		   var dipFz:Number = ip.z - F.z;
		
		   var mul_dEFx2dEFz2:Number=dEFx*dEFx+dEFz*dEFz;
		
		   //if (Math.pow(ip.x - F.x, 2) + Math.pow(ip.z - F.z, 2) > Math.pow(E.x - F.x, 2) + Math.pow(E.z - F.z, 2))
		   if (dipFx*dipFx + dipFz*dipFz > mul_dEFx2dEFz2)
		   {
		   return null;
		   }
		
		   var dipEx:Number = ip.x - E.x;
		   var dipEz:Number = ip.z - E.z;
		
		   //if (Math.pow(ip.x - E.x, 2) + Math.pow(ip.z - E.z, 2) > Math.pow(E.x - F.x, 2) + Math.pow(E.z - F.z, 2))
		   if (dipEx*dipEx + dipEz*dipEz > mul_dEFx2dEFz2)
		   {
		   return null;
		   }
		   }
		   return ip;
		   }
		 
		
		//---------------------------------------------------------------
//Checks for intersection of Segment if as_seg is true.
//Checks for intersection of Line if as_seg is false.
//Return intersection of Segment AB and Segment EF as a Vector3D
//Return null if there is no intersection
//---------------------------------------------------------------
		/*public static function lineIntersectLine(A:Vector3D,B:Vector3D,E:Vector3D,F:Vector3D,as_seg:Boolean=true):Vector3D {
		   var ip:Vector3D;
		   var a1:Number;
		   var a2:Number;
		   var b1:Number;
		   var b2:Number;
		   var c1:Number;
		   var c2:Number;
		
		   a1= B.z-A.z;
		   b1= A.x-B.x;
		   c1= B.x*A.z - A.x*B.z;
		   a2= F.z-E.z;
		   b2= E.x-F.x;
		   c2= F.x*E.z - E.x*F.z;
		
		   var denom:Number=a1*b2 - a2*b1;
		   if (denom == 0) {
		   return null;
		   }
		   ip=new Vector3D();
		   ip.x=(b1*c2 - b2*c1)/denom;
		   ip.z=(a2*c1 - a1*c2)/denom;
		
		   //---------------------------------------------------
		   //Do checks to see if intersection to endNumber3Ds
		   //distance is longer than actual Segments.
		   //Return null if it is with any.
		   //---------------------------------------------------
		   if(as_seg){
		   if(Math.pow(ip.x - B.x, 2) + Math.pow(ip.z - B.z, 2) > Math.pow(A.x - B.x, 2) + Math.pow(A.z - B.z, 2))
		   {
		   return null;
		   }
		   if(Math.pow(ip.x - A.x, 2) + Math.pow(ip.z - A.z, 2) > Math.pow(A.x - B.x, 2) + Math.pow(A.z - B.z, 2))
		   {
		   return null;
		   }
		
		   if(Math.pow(ip.x - F.x, 2) + Math.pow(ip.z - F.z, 2) > Math.pow(E.x - F.x, 2) + Math.pow(E.z - F.z, 2))
		   {
		   return null;
		   }
		   if(Math.pow(ip.x - E.x, 2) + Math.pow(ip.z - E.z, 2) > Math.pow(E.x - F.x, 2) + Math.pow(E.z - F.z, 2))
		   {
		   return null;
		   }
		   }
		   return ip;
		 }*/
		
	/*	public static function lineIntersectLine(p1:Vector3D, p2:Vector3D, p3:Vector3D, p4:Vector3D):Vector3D
		{
			var x1:Number = p1.x, x2:Number = p2.x, x3:Number = p3.x, x4:Number = p4.x;
			var y1:Number = p1.z, y2:Number = p2.z, y3:Number = p3.z, y4:Number = p4.z;
			var z1:Number = (x1 - x2), z2:Number = (x3 - x4), z3:Number = (y1 - y2), z4:Number = (y3 - y4);
			var d:Number = z1 * z4 - z3 * z2;
			
// If d is zero, there is no intersection
			if (d == 0)
				return null;
			
// Get the x and y
			var pre:Number = (x1 * y2 - y1 * x2), post:Number = (x3 * y4 - y3 * x4);
			var x:Number = (pre * z2 - z1 * post) / d;
			var z:Number = (pre * z4 - z3 * post) / d;
			
// Check if the x and z coordinates are within both lines
			if (x < Math.min(x1, x2) || x > Math.max(x1, x2) || x < Math.min(x3, x4) || x > Math.max(x3, x4))
				return null;
			if (z < Math.min(y1, y2) || z > Math.max(y1, y2) || z < Math.min(y3, y4) || z > Math.max(y3, y4))
				return null;
			
// Return the Vector3D of intersection
			return new Vector3D(x, 0, z);
		}*/
		
		private static function getSideOpportunity(puck:Puck):Opportunity
		{
			var r:Number = 0;
			var x:Number;
			var z:Number;
			var bounceRadius:Number;
			
			var scoreOpportunity:int = 0;
			var maxScoreOpportunity:Number = 7; //7+7
			
			//for (var offset:int = -28; offset < 29; offset += 4) {
			for (var offset:int = 0; offset < 6; offset += 4)
			{
				if (offset == 0)
					continue;
				
				scoreOpportunity = 0;
				
				/*for (var dr:int = 1; dr < 4; dr++)
				   {
				
				   r = dr * puck.radius;
				   _virtualPuck.x = puck.x + offset;
				   _virtualPuck.z = Math.SQRT2(Math.pow(r) - Math.pow(_virtualPuck.x));
				
				   scoreOpportunity += opportunityScoreField(_virtualPuck)
				
				   }
				
				   if (scoreOpportunity > maxScoreOpportunity)
				 maxScoreOpportunity=*/
				
			}
			
			if (scoreOpportunity)
			{
				
				return null; //new Opportunity();
			}
			else
			{
				return null;
			}
		
		}
		
		private static function isSideClearShoot(puck:Puck):Boolean
		{
			return false;
		}
		
		//return pack and weight
		private static function isFrontClearShoot(puck:Puck):Boolean
		{
			var d:Number = 2 * puck.radius;
			for each (var currentPuck:Puck in InlineShuffle.Pucks)
			{
				
				if (currentPuck != puck) //not the same puck 
				{
					trace(puck.x - d, "<", currentPuck.x, "<", puck.x + d);
					//trace((puck.x + d)+">"+currentPuck.x+">"+(puck.x - d));
					if (currentPuck.isFrontOf(puck, InlineShuffle.PuckDiameter)) //if puck is inside shoot line
						return false;
				}
				
			}
			
			//&& currentPuck.belongTo!=puck.belongTo)//puck is from opposite player
			
			return true;
		}
		
		/**
		 * returns scoreField score of the puck(if puck would have that position then would have score)
		 * @param	puck
		 * @return
		 */
		public static function opportunityScoreField(puck:Puck):int
		{
			for each (var scoreField:ScoreField in InlineShuffle.ScoreFields)
			{
				//is in field && //and not on line
				if (scoreField.isInScoreField(puck) && !scoreField.isIntersectOutline(puck, InlineShuffle.ScoreFieldLineTickness))
				{
					return scoreField.score;
				}
			}
			
			return 0;
		}
		
		
		    public static function sortIntersectionsByXAsc(A:Vector3D, B:Vector3D):Number
			{ 
				if (A.x < B.x) { return -1; } else if (A.x > B.x) { return 1; } else { return 0; } 
			}
			
			public static function sortIntersectionsByXDesc(A:Vector3D, B:Vector3D):Number
			{ 
				if (A.x > B.x) { return -1; } else if (A.x < B.x) { return 1; } else { return 0; } 
			}
		
		public static function dump():void
		{
			var s:String;
			s = "player1HasPuckOnMinus10=" + player1HasPuckOnMinus10 + "\n" + "player1HasPuckOn10=" + player1HasPuckOn10 + "\n" + "player1HasPuckOnLeft8=" + player1HasPuckOnLeft8 + "\n" + "player1HasPuckOnRight8=" + player1HasPuckOnRight8 + "\n" + "player1HasPuckOnLeft7=" + player1HasPuckOnLeft7 + "\n" + "player1HasPuckOnRight7=" + player1HasPuckOnRight7;
			
			trace(s);
		}
	}

}
