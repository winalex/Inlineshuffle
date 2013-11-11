package alternativa.engine3d.core 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	/**
	 * ...
	 * @author winxalex
	 */

  

    public class Sound3D extends EventDispatcher
    {
        public var loop:Boolean = false;
		
        private var _sound:Sound;
        private var _channel:SoundChannel;
        private var _time:Number = 0;
        private var _volume:Number = 1;
        private var _paused:Boolean = true;
		private var _enabled:Boolean = false;
		
		
		public var name:String;
        public var radius:int;
        public var x:int=0;
        public var y:int=0;
        public var z:int=0;

       
		 public function Sound3D(sound:Sound, name:String = "", radius:int = 500,enabled:Boolean=true)
        {
           
            this.name = name;
            this.radius = radius;
                    
            
            if (sound != null)
            {
                this.setup(sound);
            }
			
			
            return;
        }// end function

        public function setup(param1:Sound) : void
        {
            this.reset();
            this._sound = param1;
            this._time = 0;
            this._paused = true;
            return;
        }// end function

        public function play(param1:Number = -1, param2:int = 0) : void
        {
            if (this._paused)
            {
                this._channel = this._sound.play(param1 != -1 ? (param1) : (this._time), param2);
                this._channel.addEventListener(Event.SOUND_COMPLETE, this.onSoundEnd);
                this.volume = this._volume;
                this._paused = false;
            }
            else
            {
                this.stop();
                this.play();
            }
            return;
        }// end function

        public function stop() : void
        {
            this._time = 0;
			if(this._channel)
            this._channel.stop();
            this._paused = true;
            return;
        }// end function

        public function pause() : void
        {
            if (!this._paused)
            {
                this._time = this._channel.position;
                this._channel.stop();
                this._paused = true;
            }
            return;
        }// end function

        public function reset() : void
        {
            if (!this._paused)
            {
                this.stop();
            }
            this._sound = null;
            this._channel = null;
            this._time = 0;
            this._volume = 1;
            this._paused = true;
            return;
        }// end function

        private function onSoundEnd(event:Event) : void
        {
            dispatchEvent(new Event("complete"));
            this.stop();
            this._channel.removeEventListener(Event.SOUND_COMPLETE, this.onSoundEnd);
            if (this.loop)
            {
                this.play();
            }
            return;
        }// end function

        public function set volume(param1:Number) : void
        {
            var _loc_2:SoundTransform = null;
            this._volume = param1;
            if (this._channel != null)
            {
                _loc_2 = this._channel.soundTransform;
                _loc_2.volume = this._volume;
                this._channel.soundTransform = _loc_2;
            }
            return;
        }// end function

        public function get volume() : Number
        {
            return this._volume;
        }// end function

        public function get channel() : SoundChannel
        {
            return this._channel;
        }// end function

        public function get sound() : Sound
        {
            return this._sound;
        }// end function

        public function get paused() : Boolean
        {
            return this._paused;
        }// end function

        public function get progress() : int
        {
            if (this._channel != null)
            {
                return this._channel.position / this._sound.length * 100;
            }
            return 0;
        }// end function
		
		public function get enabled():Boolean 
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void 
		{
			_enabled = value;
		}

        

    }
}
