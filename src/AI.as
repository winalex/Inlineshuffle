/**
* ...
* @author Default
* @version 0.1
*/

package  {
	
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.Material;
	import caurina.transitions.Tweener;
	import flash.geom.Vector3D;
	

	

	//simple AI with predefined values
	public class AI extends Player {
		
		
		
		public static var EASY:uint = 3;
		public static var MEDIUM:uint = 2;
		public static var HARD:uint = 1;
		public var level:uint = 1; // probablity
		public var numLevels:uint = 3;
		public var shooterPositionForScore7L:Array;
		public var shooterPositionForScore7R:Array;
		public var shooterPositionForScore8L:Array;
		public var shooterPositionForScore8R:Array;
		public var shooterPositionForScore10:Array;
		//public var score
		
		public function AI(puckMaterial:Material=null,level:uint=3):void
		{
			if (!puckMaterial)
			puckMaterial = new FillMaterial(0xFF00FF);
			
			super("BOT", puckMaterial);
			
			this.level = level;
			
			//init preDefinied values
			
			
			this.shooterPositionForScore7L = new Array();
			this.shooterPositionForScore7L[shooterPositionForScore7L.length] = new Vector3D ( -32, 0, -22.48);
			this.shooterPositionForScore7L[shooterPositionForScore7L.length] = new Vector3D ( -101.70, 0, -22.48);
			
			this.shooterPositionForScore7R = new Array();
			this.shooterPositionForScore7R[shooterPositionForScore7R.length] = new Vector3D ( 32, 0, -22.48);
			this.shooterPositionForScore7R[shooterPositionForScore7R.length] = new Vector3D ( 101.70, 0, -22.48);
			
			this.shooterPositionForScore8L = new Array();
			this.shooterPositionForScore8L[shooterPositionForScore8L.length] = new Vector3D( -91, 0, -7.16) ;
			
			this.shooterPositionForScore8R = new Array();
			this.shooterPositionForScore8R[shooterPositionForScore8R.length] = new Vector3D( -91, 0, -7.16) ;
			
			this.shooterPositionForScore10 = new Array();
			this.shooterPositionForScore10[shooterPositionForScore10.length] = new Vector3D( 2, 0, 9.573538041104285) ;
			
			
			
		
			
			
			
		/*	this.targets[targets.length] = new Vector3D(-91,0,-7.16);//0
			this.targets[targets.length] = new Vector3D( -29, 0, -10.53);//1
			this.targets[targets.length] = new Vector3D ( 29.69, 0, -21.46);//2
			this.targets[targets.length] = new Vector3D(91, 0, -7.16);//3
			this.targets[targets.length] = new Vector3D( 5, 0, 10);//4
			this.targets[targets.length] = new Vector3D( -89, 0, -6.31);//5
			this.targets[targets.length] = new Vector3D( -36, 0, -8);//6
			this.targets[targets.length] = new Vector3D( 29, 0, -10.53);//7
			this.targets[targets.length] = new Vector3D (101.70, 0, -22.48);//8
			this.targets[targets.length] = new Vector3D( -5, 0, 10);//9
			this.targets[targets.length] = new Vector3D( 36, 0, -8);//10
			this.targets[targets.length] = new Vector3D( 0, 0, 10);//11
			this.targets[targets.length] = new Vector3D ( -29.69, 0, -21.46);//12
			this.targets[targets.length] = new Vector3D ( -101.70, 0, -22.48);//13
			this.targets[targets.length] = new Vector3D ( -32, 0, -22.48);//14
			this.targets[targets.length] = new Vector3D ( 32, 0, -22.48);//15
			*/
			
			
		}
		
		private function autoTarget(pos:Vector3D, t:Number):void
		{
			//	Tweener.addTween(InlineShuffle.camera, {rotationX:-15,zoom:30, time:time, delay:delay,transition:"easeOutQuint",onComplete:InlineShuffle.cameraBack, onCompleteParams:[0,-152,2,3] });//
			
			Tweener.addTween(InlineShuffle.shooter, { x:pos.x, z:pos.z,time:t,transition:"easeOutQuint",onComplete:InlineShuffle.shooter.shoot } );
		}
		
		public function think():void
		{
			
			
			if (InlineShuffle.shooter.shoots == 7)//&& hasNoOpportunity && WorkingMemory.player1HasPuckOn10
			{
				shoot(10);
				//TraceWindow.display(""+randomValue);
			}else
				shoot(8,random(0,1)? "L":"R");
			
			//InlineShuffle.processRules();//returns function (consequant)
			//var shooterPos:Vector3D =	eval function //returns generated postion 
			//autoTarget(shooterPos, 3);
			
			/*var randomValue = this.random(0, this.targets.length - 1);
			TraceWindow.display("AI --> randomValue: "+randomValue);
			
			//random target
			var target:Vector3D=this.targets[randomValue];
			
			
			target.z = target.z * this.level / this.numLevels;
			
			autoTarget(target, 3);*/
			
			
					
		}
		
		public function shoot(scoreFieldNumber:Number,side:String=""):void {
			
			var targets:Array = this["shooterPositionForScore" + scoreFieldNumber + side];
			var randomValue:Number = this.random(0, targets.length - 1);
			
			//TODO AI need hard redoing random targets
			//random target
			var target:Vector3D=targets[randomValue];
			
			
			target.z = target.z + this.level * random(1,5) ;
			target.x = target.x + this.level * random(1, 5);
			
			autoTarget(target, 3);
		}
		
		
		private function random(min:Number, max:Number):Number 
		{
				var randomNum:Number = Math.floor(Math.random() * (max - min + 1)) + min;
				return randomNum;
		}
		
		
		/*private function findEnemyPuck():Puck
		{
			var enemyPuck:Puck = null;
			var maxScore:Number = 0;
			for (var puck:Puck in InlineShuffle.Pucks)
			{
				if (puck.belongTo != this)//not belong to this puck
				{
					if(puck maxScore
				}
			}
		}*/
		
		
		/*
		 * calculate position for shooting
		 */
		public function shootScore(score:int,side:int):void
		{
			//find best score and with clear shoot
			
		}
		
		
		
		/*
		 * calculate position for shooting which will push Enemy puck
		 */
		private function pushOut(side:int, power:Number):Vector3D
		{
			//find enemy puck with score and with clear shoot
			//if greater score greater power
			
			return null;
		}
		
		
		
		
	}
	
}
