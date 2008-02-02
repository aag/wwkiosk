package views.components
{
	import flash.display.Bitmap;
	import flash.events.Event;
	
	import mx.controls.Image;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	
	use namespace mx_internal;
	
	[Style(name="bitmapSmoothing", type="Boolean", inherit="no")]
	
	public class SmoothImage extends Image {
		public function SmoothImage() {
			super();
			addEventListener(mx.events.FlexEvent.CREATION_COMPLETE, smoothImage);
			addEventListener(mx.events.FlexEvent.UPDATE_COMPLETE, smoothImage);
		}
	
		private function smoothImage(event:Event):void {
			var bitmap:Bitmap = ((event.target as Image).content as Bitmap);
			if (bitmap != null) {
				bitmap.smoothing = true;
			}
		}
	}
}