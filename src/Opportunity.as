package  
{
	
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author AlexWinx
	 */
	public class Opportunity
	{
		public var value:int=0;
		public var side:int = ScoreField.MIDDLE;
		public var targetPuck:Puck;
		
		
		
    	public var pushRayEnd:Vector3D;
		public var bounceBackRayStart:Vector3D;
		public var bounceBackRayEnd:Vector3D;
		public var score:Number;
	
		private var _pushDistance:Number;
		private var _targetX:Number;
		private var _pushInterPoint:Vector3D;
	
		
		
		
		public function Opportunity() :void
		{
			
		}
		
		
		public function get pushDistance():Number 
		{
			
			
			//FIND INTERSECTION POINT   
			
			//check -minus 10 intersection => this have priority (pushing to -10)
			_pushInterPoint = WorkingMemory.lineIntersectLine(WorkingMemory._minus10ScoreSegmentA, WorkingMemory._minus10ScoreSegmentB, targetPuck.position, pushRayEnd);
			
			if(!_pushInterPoint)
			//left or right pushing
			if(pushRayEnd.x>targetPuck.position.x)
				_pushInterPoint = WorkingMemory.lineIntersectLine(WorkingMemory._centerSegmentA, WorkingMemory._rightOutterSegmentB, targetPuck.position, pushRayEnd);
			else
			   _pushInterPoint = WorkingMemory.lineIntersectLine(WorkingMemory._centerSegmentA, WorkingMemory._leftOutterSegmentB, targetPuck.position, pushRayEnd);
			   
			 if (!_pushInterPoint) {
				 throw new Error(" Ray supplied to opportunity not intersecting \// or -10 imaginary line");
			 }
			 
			 //return Vector3D.sub(targetPuck.position,_pushInterPoint).modulo;
			 return targetPuck.position.subtract(_pushInterPoint).length;
		}
		
		
		public function get bounceBackDistance():Number 
		{
			
			
		/*	//FIND INTERSECTION POINT   
			
			//check -minus 10 intersection => this have priority (pushing to -10)
			_bounceBackInterPoint = WorkingMemory.lineIntersectLine(WorkingMemory._minus10ScoreSegmentA, WorkingMemory._minus10ScoreSegmentB, bounceBackRayStart, bounceBackRayEnd);
			
			if(!_bounceBackInterPoint)
			//left or right pushing
			if(bounceBackRayEnd.x>bounceBackRayStart.x)
				_bounceBackInterPoint = WorkingMemory.lineIntersectLine(WorkingMemory._centerSegmentA, WorkingMemory._rightOutterSegmentB,bounceBackRayStart,bounceBackRayEnd);
			else
			   _bounceBackInterPoint = WorkingMemory.lineIntersectLine(WorkingMemory._centerSegmentA, WorkingMemory._leftOutterSegmentB, bounceBackRayStart, bounceBackRayEnd);
			   
			 if (!_bounceBackInterPoint) {
				 throw new Error(" Ray supplied to opportunity not intersecting \// or -10 imaginary line");
			 }*/
			
			
			
			//return Vector3D.sub(bounceBackRayStart,bounceBackRayEnd).modulo;
			return bounceBackRayStart.subtract(bounceBackRayEnd).length;
		}
		
		public function get lunchX():Number 
		{
			return bounceBackRayStart.x;// bounceBackRayEnd.x;
		}
		
	
		
		public function get pushInterPoint():Vector3D 
		{
			return _pushInterPoint;
		}
		
		
		
		public function toString():String {
			return "Value:" + this.value + " Side:" + this.side + " Puck:" + this.targetPuck + " pushEndRay:" + this.pushRayEnd;
		}
		
	}

}