package alternativa.engine3d.controllers 
{
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Sound3D;
	import flash.media.SoundTransform;
	/**
	 * ...
	 * @author winxalex
	 */
	public class Sound3DController extends Object
    {
        public var camera:Camera3D;
        public var near:int;
        public var volume:Number;
        public var mute:Boolean;
        private var sounds:Vector.<Sound3D>;

        public function Sound3DController(camera:Camera3D=null):void
        {
            this.camera = camera;
            this.reset();
            return;
        }// end function

        public function addChild(sound:Sound3D) : void
        {
            this.sounds.push(sound);
            return;
        }// end function

        public function getChildAt(param1:int) : Sound3D
        {
            return this.sounds[param1];
        }// end function

        public function getChildByName(name:String) : Sound3D
        {
            var _loc_2:Sound3D = null;
            for each (_loc_2 in this.sounds)
            {
                
                if (_loc_2.name == name)
                {
                    return _loc_2;
                }
            }
            return null;
        }// end function

        public function removeChild(param1:Sound3D) : void
        {
            var _loc_2:* = this.sounds.indexOf(param1);
            if (_loc_2 != -1)
            {
                this.sounds.splice(_loc_2, 1);
            }
            return;
        }// end function

        public function removeChildByName(name:String) : void
        {
            var _loc_2:Sound3D = null;
            var _loc_3:int = 0;
            var _loc_4:* = this.sounds.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_4)
            {
                
                _loc_2 = this.sounds[_loc_3];
                if (_loc_2.name == name)
                {
                    this.sounds.splice(_loc_3, 1);
                }
                _loc_3++;
            }
            return;
        }// end function

        public function reset() : void
        {
            this.sounds = new Vector.<Sound3D>;
            this.near = 10;
            this.volume = 1;
            this.mute = false;
            return;
        }// end function

        public function update() : void
        {
            var _loc_1:Sound3D = null;
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var _loc_8:int = 0;
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_11:Number = NaN;
            if (this.mute || this.volume == 0)
            {
                return;
            }
            var _loc_4:* = this.sounds.length;
            var _loc_5:* = new SoundTransform();
            _loc_2 = 0;
            while (_loc_2 < _loc_4)
            {
                
                _loc_1 = this.sounds[_loc_2];
				
				if (!_loc_1.enabled) continue;
				
                _loc_6 = this.camera.x - _loc_1.x;
                _loc_7 = this.camera.y - _loc_1.y;
                _loc_8 = this.camera.z - _loc_1.z;
                _loc_3 = Math.sqrt(_loc_6 * _loc_6 + _loc_7 * _loc_7 + _loc_8 * _loc_8);
                if (_loc_1.paused)
                {
                    _loc_1.play();
                }
                if (_loc_3 < this.near)
                {
                    _loc_5.volume = this.volume;
                    _loc_5.pan = 0;
                }
                else if (_loc_3 <= _loc_1.radius)
                {
                    _loc_9 = _loc_6 * this.camera.matrix.rawData[0] + _loc_7 * this.camera.matrix.rawData[4] + _loc_8 * this.camera.matrix.rawData[8];
                   
					//TODO optimize this
					_loc_10 = Math.acos(_loc_9 / _loc_3) - Math.PI / 2;
                    _loc_11 = -_loc_10 / 100 * (100 / (Math.PI / 2));
					
                    if (_loc_11 < -1)
                    {
                        _loc_11 = -1;
                    }
                    else if (_loc_11 > 1)
                    {
                        _loc_11 = 1;
                    }
                    _loc_5.volume = this.volume / _loc_1.radius * (_loc_1.radius - _loc_3);
                    _loc_5.pan = _loc_11;
                }
                else
                {
                    _loc_5.volume = 0;
                    _loc_1.pause();
                }
                _loc_1.channel.soundTransform = _loc_5;
                _loc_2++;
            }
            return;
        }// end function

    }
	
	
	

}


 

  

   

