package alternativa.engine3d.materials {

import alternativa.engine3d.core.Camera3D;
import alternativa.engine3d.core.Light3D;
import alternativa.engine3d.materials.TextureMaterial;
import alternativa.engine3d.objects.Surface;
import alternativa.engine3d.resources.BitmapTextureResource;
import alternativa.engine3d.resources.Geometry;
import alternativa.engine3d.resources.TextureResource;
import flash.display.BitmapData;
import flash.display.MovieClip;
import flash.events.Event;

import alternativa.engine3d.alternativa3d;
use namespace alternativa3d;
 
/**
 * Material enable use MovieClip as a texture
 * Материал, позволяющий использовать MovieClip
 * в качестве текстуры.
 */
public class MovieMaterial extends TextureMaterial {
	private var _diffuseMapDirty:Boolean=false;
	
	protected var _mc:MovieClip;
	protected var bd:BitmapData;
	
	protected var _autoUpdate:Boolean;
	
	public var smooth:Boolean = true;
 
	public function MovieMaterial (clip:MovieClip,autoUpdate:Boolean=true,smoothing:Boolean=true) {
		_mc = clip;
		
		
		this.smooth = smoothing;
		_diffuseMapDirty = true;
		super(getDiffuse());
		
		
		this.autoUpdate = autoUpdate;
 
	
	}
	
	
	private function getDiffuse():TextureResource {
			bd = new BitmapData (_mc.width, _mc.height, true);
			return new BitmapTextureResource(bd,true);
		}
 
	public function updateTexture (e:Event = null):void {
		bd.fillRect (bd.rect, 0);
		bd.draw (_mc, null, null, null, null, this.smooth);
		_diffuseMapDirty = true;
	}
	
	public function get autoUpdate():Boolean 
	{
		return _autoUpdate;
	}
	
	public function set autoUpdate(value:Boolean):void 
	{
		_autoUpdate = value;
		
		if (_autoUpdate && !_mc.hasEventListener(Event.ENTER_FRAME)) {
			_mc.addEventListener (Event.ENTER_FRAME, updateTexture);
		}else if(_mc.hasEventListener(Event.ENTER_FRAME)) {
			_mc.removeEventListener(Event.ENTER_FRAME, updateTexture);
		}
	}
	
	public function get mc():MovieClip 
	{
		return _mc;
	}
	
	
	override alternativa3d function collectDraws(camera:Camera3D, surface:Surface, geometry:Geometry, lights:Vector.<Light3D>, lightsLength:int,useShadow:Boolean, objectRenderPriority:int = -1):void 
		{
			if (diffuseMap && _diffuseMapDirty) { 
				diffuseMap.upload(camera.context3D);
				_diffuseMapDirty = false;
				}
			super.collectDraws(camera, surface, geometry, lights, lightsLength,useShadow, objectRenderPriority);
		}
}
}