package  
{
	import alternativa.engine3d.controllers.SimpleObjectController;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.View;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author winxalex
	 */
	public class BasicView extends View 
	{
			
		
		private var __camera:Camera3D;
		
		
		private var __scene:BasicScene;
		
		
		private var __isRendering:Boolean = false;
	
		private var __startRendering:Boolean = false;
		private var __singleRendering:Boolean = false;
		
			
	
		
	
		
		public function get scene():BasicScene 
		{
			return __scene;
		}
		
			
		public function set scene(value:BasicScene):void 
		{
			__scene = value;
			__scene.camera.view = this;
			
		}
		
	
		
		public function BasicView(width:int,height:int,renderToBitmap:Boolean=false,backgroundColor:uint=0,backgroundAlpha:Number=0,antiAlias:uint=4):void
		{
					
					
					super(width, height, renderToBitmap, backgroundColor, backgroundAlpha, antiAlias);
					
					
					
							
					this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
					
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			
			
			
			
	/*		// Initial position
					// Установка положения камеры
					__camera.rotationX = -120*Math.PI/180;
					__camera.y = -800;
					__camera.z = 400;*/
					
					if (__startRendering) {
						__startRendering = false;
						startRendering();
					}else if (__singleRendering) {
						__singleRendering = false;
						singleRendering();
					}
		
				
		}



		public function stopRendering():void {
			__isRendering = false;
			
			stage.removeEventListener(Event.ENTER_FRAME, onRenderTick);
			
			
		}


		public function startRendering():void {
			
			if (!stage) { __startRendering = true; return; }
			
				if(!__isRendering){
					// Listeners
					// Подписка на события
					this.addEventListener(Event.ENTER_FRAME, onRenderTick, false, 0, true);
				}
				
				__isRendering = true;
		}


		public function singleRendering():void {
				
					if (!stage) { __singleRendering = true; return; }
					
					
					
					// Width and height of view
					// Установка ширины и высоты вьюпорта
				//	this.width = stage.stageWidth;
				//	this.height = stage.stageHeight;
					
					
						
					// Render
					// Отрисовка
					__scene.render();
					
					
					
		}
	


	
		

		protected function onRenderTick(event:Event=null):void
        {
           
			
			singleRendering();
			
           
        }
	}
	

}