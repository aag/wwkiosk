package views.components
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	
	import mx.controls.Image;
	import mx.core.mx_internal;
	
	use namespace mx_internal;
	
	public class SmoothImage extends Image {
		public function SmoothImage() {
			super();
		}
		
		override mx_internal function contentLoaderInfo_completeEventHandler(event:Event):void {
            var smoothLoader:Loader = event.target.loader as Loader;
            var smoothImage:Bitmap = smoothLoader.content as Bitmap;
            smoothImage.smoothing = true;
 
            super.contentLoaderInfo_completeEventHandler(event);
        }
	}
}