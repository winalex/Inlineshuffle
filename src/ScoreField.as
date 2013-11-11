/**
* ...
* @author Default
* @version 0.1
*/

package  {
	import flash.geom.Vector3D;
	
	

	public class ScoreField {
		
		public var outline:Vector.<Vector3D>;
		public var score:int;
		public var side:int; //-1-left 0-middle 1-right
		public static var LEFT:int = -1;
		public static var MIDDLE:int = 0;
		public static var RIGHT:int = 1;
		
		
		//outline [{stPoint:new Point(x,y),enPoint:new Point(x,y)}]
		public function ScoreField(outline:Vector.<Vector3D>,score:int,side:int) 
		{
			this.outline = outline;
			this.score = score;
			this.side = side;
		}
		
		
/*		//===================================================================
isLeft( Point P0, Point P1, Point P2 )
{
    return ( (P1.x - P0.x) * (P2.y - P0.y)
            - (P2.x - P0.x) * (P1.y - P0.y) );
}
// wn_PnPoly(): winding number test for a point in a polygon
//      Input:   P = a point,
//               V[] = vertex points of a polygon V[n+1] with V[n]=V[0]
//      Return:  wn = the winding number (=0 only if P is outside V[])
int
wn_PnPoly( Point P, Point* V, int n )
{
    int    wn = 0;    // the winding number counter

    // loop through all edges of the polygon
    for (int i=0; i<n; i++) {   // edge from V[i] to V[i+1]
        if (V[i].y <= P.y) {         // start y <= P.y
            if (V[i+1].y > P.y)      // an upward crossing
                if (isLeft( V[i], V[i+1], P) > 0)  // P left of edge
                    ++wn;            // have a valid up intersect
        }
        else {                       // start y > P.y (no test needed)
            if (V[i+1].y <= P.y)     // a downward crossing
                if (isLeft( V[i], V[i+1], P) < 0)  // P right of edge
                    --wn;            // have a valid down intersect
        }
    }
    return wn;
}
//===================================================================
*/
//( Point P0, Point P1, Point P2 )
		/*private function isLeft(P0:Object, P1:Object, P2:Object ):Number
		{
			return ( (P1.x - P0.x) * (P2.z - P0.z) - (P2.x - P0.x) * (P1.z - P0.z) );
		}*/
		
		
		private function isLeft(P0:Vector3D, P1:Vector3D, P2:Vector3D ):Number
		{
			return ( (P1.x - P0.x) * (P2.y - P0.y) - (P2.x - P0.x) * (P1.y - P0.y) );
		}

		public function isInScoreField(puck:Puck):Boolean
		{
			var wn:int = 0;// the winding number counter
			var edgeStartPoint:Vector3D;
			var edgeEndPoint:Vector3D;
			var puckCenterPoint:Vector3D = puck.position; //{ x:puck.x, z:puck.z };
			for (var i:int = 0; i < outline.length; i++)
			{
				edgeStartPoint = outline[i];
				edgeEndPoint = outline[(i + 1) % outline.length];
				
				if (edgeStartPoint.y <= puckCenterPoint.y)// start y <= P.y
				{
					if (edgeEndPoint.y > puckCenterPoint.y)// an upward crossing
						if (isLeft(edgeStartPoint, edgeEndPoint, puckCenterPoint)>0)// Puck is left of edge
						++wn;// have a valid up intersect
				}
				else // start y > P.y (no test needed)
				{
					if (edgeEndPoint.y <= puckCenterPoint.y)// a downward crossing
					 if (isLeft (edgeStartPoint, edgeEndPoint, puckCenterPoint) < 0)// P right of edge
					 --wn; // have a valid down intersect
				}
						
			}
			
			//trace("SCOREFIELD --> winding number is " + wn);
			  
			//FlashViewer.trace("SCOREFIELD --> winding number is " + wn);
			
			return Boolean(wn);
			//return Boolean(calculateWindingNumber(puck.x, puck.z));
			
			
			
		}
		
	
		
		public function isIntersectOutline(puck:Puck, lineThickness:Number = 0):Boolean {
			//loop thru all edges of outline
			for (var i:int = 0; i < outline.length; i++)
			{
				if (puck.isIntersectLineSegment(outline[(i + 1) % outline.length], outline[i], lineThickness)) {
					return true;
				}
			}
			
			return false;
		}
		
		
/*		public function isIntersectOutline(puck:Puck,lineThickness:Number=0):Boolean
		{
			var discriminant:Number;
			var dx, dz, dr, determinant:Number;
			var x1, z1, x2, z2:Number;
			


			//loop thru all edges of outline
			for (var i = 0; i < outline.length; i++)
			{
				//translate line coords as much as needed circle to get to (0,0) coords
					x2 = outline[(i + 1)%outline.length].x-puck.x;
					x1 = outline[i].x-puck.x;
					
					z2 = outline[(i + 1)%outline.length].z-puck.z;
					z1 = outline[i].z-puck.z;
					
					
					dx=x2-x1
					dz=z2-z1
					
					
					//dr
					dr = Math.sqrt(Math.pow(dx, 2) + Math.pow(dz, 2));
					
					//|x1 x2|
					//|z1 z2|
					
					determinant = x1 * z2 - x2 * z1;
					
					//discriminant=r(2)*dr(2)-D(2)
					discriminant = Math.pow(puck.radius+lineThickness/2, 2) * Math.pow(dr, 2) - Math.pow(determinant,2);
					
					//discriminant =0 -> tangenta
					//discriminant >0 -> intersection
					//discriminant <0 -> no intersection
					if (discriminant >=0)
					return true;
					
			}
			return false;
		}*/
		
	}
	
}
