package views.components
{
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import mx.controls.Alert;
	import mx.core.UIComponent;

	public class H264Video extends UIComponent
	{
		private var _video:Video;      
		private var _nc:NetConnection;      
		private var _ns:NetStream;      
		private var _client:Object;      
		private var _filePath:String; 
		
		public function H264Video()	{
		     super();      
		     init();
		} 
		
		public function init():void {      
		     _video = new Video();           
		     _nc = new NetConnection();      
		     _nc.connect(null);           
		     _ns = new NetStream(_nc);   
		     _client = new Object();      
			 _ns.client = _client;
			 _ns.addEventListener(NetStatusEvent.NET_STATUS, onStatus);  
			 _video.attachNetStream(_ns);
		     this.addChild(_video);
		     if(_filePath) {      
		         _ns.play(_filePath);      
		     }    
		} 
		
		private function onStatus(p_evt:NetStatusEvent):void  {
	        if(p_evt.info.code == "NetStream.FileStructureInvalid") {
	             Alert.show("The MP4's file structure is invalid.", "Status");
	        } else if(p_evt.info.code == "NetStream.NoSupportedTrackFound") {
	             Alert.show("The MP4 doesn't contain any supported tracks", "Status");
	        } else if(p_evt.info.level == "error") {
	             Alert.show("There was some sort of error with the NetStream", "Error");
	        } else {
	        	Alert.show("Unknown error playing video.");
	        }
	    }
	  
	    [Bindable]
		public function get filePath():String {      
		     return _filePath;      
		}      
		            
		public function set filePath(p_path:String):void {      
			trace("set file path");
		     _filePath = p_path;      
		     _ns.play(_filePath);      
		} 
		
		public function play():void {
			_ns.play(_filePath); 
		}
	}
}