/**
* ...
* @author Default
* @version 0.1
*/

package  {
	import alternativa.engine3d.materials.Material;
	
	


	public class Player extends Object{
		public var name:String;
		public var score:int = 0;
		public var id:uint;
		public var isRemote:Boolean;
		public var puckMaterial:Material;
		public var hasWon:Boolean = false;
		
		public function Player(name:String="PLAYER",puckMaterial:Material=null,id:int=-1,bRemote:Boolean=false) {//=new ColorMaterial(0x00FF00)
			
			if(name)
			this.name = name;
			
			this.isRemote = bRemote;
			this.puckMaterial = puckMaterial;
			this.id = id;
		}
		
	}
	
}
