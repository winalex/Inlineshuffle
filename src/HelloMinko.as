package
{
    import aerys.minko.render.Viewport;
    import aerys.minko.scene.node.camera.ArcBallCamera;
    import aerys.minko.scene.node.group.Group;
    import aerys.minko.scene.node.group.LoaderGroup;
	import aerys.minko.scene.node.group.TransformGroup;
    import aerys.minko.scene.node.mesh.primitive.CubeMesh;
	import aerys.minko.scene.node.texture.ColorTexture;
	import aerys.minko.type.math.ConstVector4;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import utils.Monitor;
     
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Point;
     
    public class HelloMinko extends Sprite
    {
      
         
        private var _viewport   : Viewport          = new Viewport();
        private var _camera     : ArcBallCamera     = new ArcBallCamera();
        private var _cube       : Group             = new Group();
        private var _scene      : Group             = new Group(_camera);
        private var _cursor     : Point             = new Point();
		private var _electron  :TransformGroup  	= new TransformGroup();
         
        public function HelloMinko()
        {
            if (stage)
                initialize();
            else
                addEventListener(Event.ADDED_TO_STAGE, initialize);
        }
         
        private function initialize(event : Event=null) : void
        {
            removeEventListener(Event.ADDED_TO_STAGE, initialize);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
             
			_viewport.width = stage.stageWidth;
			_viewport.height = stage.stageHeight;
            stage.addChild(_viewport);
             
            _camera.distance = 3.;
             
			  stage.addChild(Monitor.monitor.watch(_viewport, ["numTriangles"]));
            
			  var cubeMesh:CubeMesh = CubeMesh.cubeMesh;
			 
			
			
			 _electron.addChild(new ColorTexture(0xff00ff00))
                 .addChild(CubeMesh.cubeMesh);
			
			_scene.addChild(_electron);
			
			
             
            addEventListener(Event.ENTER_FRAME, enterFrameHandler);
             
            stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
            stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
        }
         
        private function enterFrameHandler(event : Event) : void
        {
			
			 _electron.transform.appendRotation( -.01, ConstVector4.Z_AXIS);
            _viewport.render(_scene);
        }
         
        private function mouseWheelHandler(event : MouseEvent) : void
        {
            _camera.distance -= event.delta;
        }
         
        private function mouseMoveHandler(event : MouseEvent) : void
        {
            if (event.buttonDown)
            {
                _camera.rotation.y -= (event.stageX - _cursor.x) * .01;
                _camera.rotation.x -= (event.stageY - _cursor.y) * .01;
            }
             
            _cursor.x = event.stageX;
            _cursor.y = event.stageY;
        }
    }
}