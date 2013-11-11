/**
* ...
* @author Default
* @version 0.1
*/

package  {
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.materials.MovieMaterial;
	import alternativa.engine3d.primitives.Plane;
	import flash.display.MovieClip;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import flash.events.TimerEvent;
	

	public class ScoreBoard extends Plane
	{
		
		private var _player1TextField:TextField;
		private var _player2TextField:TextField;
		private var _shootCounterTextField:TextField;
		private var _roundTextField:TextField;
		private var _player1ScoreTextField:TextField;
		private var _player2ScoreTextField:TextField;
		private var _roundTTextField:TextField;
		private var _captionTextField:TextField;
		
		private var _ledFont:Font = new LedFont();
		private var _impactBoldItalicFont:Font = new ImpactBoldItalicFont();
		private var _impactBoldFont:Font = new ImpactBoldFont();
		
		private var _playerTextFormat:TextFormat = new TextFormat();
		private var _counterTextFormat:TextFormat = new TextFormat();
		private var _scoreTextFormat:TextFormat = new TextFormat();
		private var _roundTextFormat:TextFormat = new TextFormat();
		private var _roundTTextFormat:TextFormat = new TextFormat();
		private var _captionTextFormat:TextFormat = new TextFormat();
		
		public var width:uint;
		public var height:uint;
		
		private var _player1AvailablePucks:int=4;
		private var _player2AvailablePucks:int=4;
		
		
		private var _topMaterial:MovieMaterial;
		private var _materialMovieClip:MovieClip;
		
		public function ScoreBoard(material:MovieMaterial,teamName1:String = "Guest", teamName2:String ="Home"):void
		{
			
			_materialMovieClip = material.mc;
		
			_topMaterial = material;
			
			//  F O R M A T S //
			
			_scoreTextFormat.font = _ledFont.fontName;
			_scoreTextFormat.bold = true;
			_scoreTextFormat.color = 0xFF6600;
			_scoreTextFormat.size = 40;
			
			_playerTextFormat.font = _impactBoldItalicFont.fontName;
			_playerTextFormat.bold = true;
			_playerTextFormat.italic = true;
			_playerTextFormat.color = 0xFFFFFF;
			_playerTextFormat.size = 20;
			_playerTextFormat.letterSpacing = 2;
			
			_roundTextFormat.font = _ledFont.fontName;
			_roundTextFormat.bold = true;
			_roundTextFormat.color = 0xFF0000;
			_roundTextFormat.size = 23;
			
			_captionTextFormat.font =_impactBoldFont.fontName;
			_captionTextFormat.bold = true;
			_captionTextFormat.color = 0xFF0000;
			_captionTextFormat.size = 20;
			_captionTextFormat.letterSpacing = 6;
			
			_roundTTextFormat.font = _impactBoldFont.fontName;
			_roundTTextFormat.bold = true;
			_roundTTextFormat.color = 0xFFFFFF;
			_roundTTextFormat.size = 16;
			_roundTTextFormat.letterSpacing = 1;
			
			
			_counterTextFormat.font = _ledFont.fontName;
			_counterTextFormat.bold = true;
			_counterTextFormat.color = 0xFF0000;
			_counterTextFormat.size = 45;
		
			
			// TEXTFIELD //
			
				_player1TextField = TextField(_materialMovieClip.getChildByName("player1TextField"));
				_player1TextField.defaultTextFormat=_playerTextFormat;
				_player1TextField.antiAliasType =AntiAliasType.ADVANCED;
				_player1TextField.embedFonts = true;
				_player1TextField.cacheAsBitmap = true;
				_player1TextField.text = teamName1;
			
				_player2TextField = TextField(_materialMovieClip.getChildByName("player2TextField"));
				_player2TextField.defaultTextFormat=_playerTextFormat;
				_player2TextField.antiAliasType =AntiAliasType.ADVANCED;
				_player2TextField.embedFonts = true;
				_player2TextField.cacheAsBitmap = true;
				_player2TextField.text = teamName2;
				
				
					_shootCounterTextField = TextField(_materialMovieClip.getChildByName("shootCounterTextField"));
					_shootCounterTextField.defaultTextFormat=_counterTextFormat;
					_shootCounterTextField.antiAliasType =AntiAliasType.ADVANCED;
					_shootCounterTextField.embedFonts = true;
					//_shootCounterTextField.cacheAsBitmap = true;
					
					
					
					_roundTextField = TextField(_materialMovieClip.getChildByName("roundTextField"));
					_roundTextField.defaultTextFormat=_roundTextFormat;
					_roundTextField.antiAliasType =AntiAliasType.ADVANCED;
					_roundTextField.embedFonts = true;
					_roundTextField.text = "1";
					//_roundTextField.cacheAsBitmap = true;
					
					
					_roundTTextField = TextField(_materialMovieClip.getChildByName("roundTTextField"));
					_roundTTextField.defaultTextFormat=_roundTTextFormat;
					_roundTTextField.antiAliasType =AntiAliasType.ADVANCED;
					_roundTTextField.embedFonts = true;
					_roundTTextField.cacheAsBitmap = true;
					
					
					_captionTextField = TextField(_materialMovieClip.getChildByName("captionTextField"));
					_captionTextField.defaultTextFormat=_captionTextFormat;
					_captionTextField.antiAliasType =AntiAliasType.ADVANCED;
					_captionTextField.embedFonts = true;
					_captionTextField.cacheAsBitmap = true;
					
					
					_player1ScoreTextField = TextField(_materialMovieClip.getChildByName("player1ScoreTextField"));
					_player1ScoreTextField.defaultTextFormat=_scoreTextFormat;
					_player1ScoreTextField.antiAliasType =AntiAliasType.ADVANCED;
					_player1ScoreTextField.embedFonts = true;
					//_player1ScoreTextField.cacheAsBitmap = true;
					_player1ScoreTextField.text = "0";
					
					
					_player2ScoreTextField = TextField(_materialMovieClip.getChildByName("player2ScoreTextField"));
					_player2ScoreTextField.defaultTextFormat=_scoreTextFormat;
					_player2ScoreTextField.antiAliasType =AntiAliasType.ADVANCED;
					_player2ScoreTextField.embedFonts = true;
					_player2ScoreTextField.text = "0";
					//_player2ScoreTextField.cacheAsBitmap = true;
					
		
					this.width = _materialMovieClip.width;
					this.height = _materialMovieClip.height;
					
					
					
			super (width,height,1,1,false,false,null,_topMaterial);
			
			//super (new MovieAssetMaterial("scoreBoardMovieClipAsset"),1000,400,10,10);
		}
		
		public function update():void 
		{
			MovieMaterial(this._topMaterial).updateTexture();
		}
		
			
		public  function set shootCounter(sec:Number):void
		{
			_shootCounterTextField.text = sec.toString();
			this._topMaterial.updateTexture();
		}
		
		public  function get shootCounter():Number
		{
			return Number(_shootCounterTextField.text);
		}
		
		public function set roundNumber(round:Number):void
		{
			_roundTextField.text = round.toString();
			
			//TODO check why this not working
			//with every round reset pucksAvailable display
			for (var i:int = 1; i < 5; i++) {
				MovieClip( _materialMovieClip["p1_" + i]).gotoAndStop(1);
				
				MovieClip( _materialMovieClip["p2_" + i]).gotoAndStop(1);
			}
			
			_player1AvailablePucks = 4;
			_player2AvailablePucks = 4;
			
			
			//_topMaterial.updateTexture();
		}
		
		public  function get roundNumber():Number
		{
			return Number(_roundTextField.text);
		}
		
		public function set  player1(name:String):void
		{
			_player1TextField.text=name;
			_topMaterial.updateTexture();
		}
		
		public  function get player1():String
		{
			return _player1TextField.text;
		}
		
		
		public  function set player2(name:String):void
		{
			_player2TextField.text = name;
			_topMaterial.updateTexture();
		}
		
		public  function get player2():String
		{
			return _player2TextField.text;
		}
		
		
		public  function set player1AvailablePucks(num:uint):void
		{
			_materialMovieClip["p1_" + _player1AvailablePucks].gotoAndStop(2);
			_player1AvailablePucks = num;
		   
		}
		
		public  function get player1AvailablePucks():uint
		{
			return _player1AvailablePucks;
		}
		
		
		
		public  function set player2AvailablePucks(num:uint):void
		{
			_materialMovieClip["p2_" + _player2AvailablePucks].gotoAndStop(2);
			_player2AvailablePucks = num;
		   
		}
		
		public  function get player2AvailablePucks():uint
		{
			return _player2AvailablePucks;
		}
		
		
		public  function set player1Score(score:Number):void
		{
			_player1ScoreTextField.text = score.toString();
			_topMaterial.updateTexture();
		}
		
		public  function get player1Score():Number
		{
			return Number(_player1ScoreTextField.text);
		}
		
		public  function set player2Score(score:Number):void
		{
			_player2ScoreTextField.text = score.toString();
			_topMaterial.updateTexture();
		}
		
		public function get player2Score():Number
		{
			return Number(_player2ScoreTextField.text);
		}
		
		public function get topMaterial():MovieMaterial 
		{
			return _topMaterial;
		}
		
		public function set topMaterial(value:MovieMaterial):void 
		{
			_topMaterial = value;
			this.getSurface(0).material = value;
		}
	}
	
}
