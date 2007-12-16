package info.emantis.view.component
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import mx.controls.Image;
	import mx.core.mx_internal;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	
	use namespace mx_internal;
	
	[Style(name="bitmapSmoothing", type="Boolean", inherit="no")]
	
	public class SmoothImage extends Image {
		
		private static var classConstructed:Boolean = classConstruct();
		
		private static function classConstruct():Boolean {
	  		// If there is no CSS definition for our style,
	  		// then create one and set the default value.
	  
	  		if (!StyleManager.getStyleDeclaration("SmoothImage"))  {
	   			var newStyleDeclaration:CSSStyleDeclaration = new CSSStyleDeclaration();
	   			newStyleDeclaration.defaultFactory = function():void {
					this.bitmapSmoothing = true;
   				}
	   			StyleManager.setStyleDeclaration("SmoothImage", newStyleDeclaration, true);
	  		}
	  		
	  		return true;
		}

		private var bSmoothingChanged:Boolean;

		public function SmoothImage():void {
  			bSmoothingChanged = true;
			super();
		}

		override public function styleChanged(styleProp:String):void {
  			super.styleChanged(styleProp);
			// Check to see if style changed.
  			if (styleProp == "bitmapSmoothing") {
		   		bSmoothingChanged = true;
		   		invalidateDisplayList();
  			}
		}

		override mx_internal function contentLoaderInfo_completeEventHandler(event:Event):void {
  			bSmoothingChanged = true;
  			super.contentLoaderInfo_completeEventHandler(event);
		}

		override public function load(url:Object = null):void {
  			super.load(url);
  
  			if (contentHolder) {
   				if (contentHolder is Bitmap)
    				bSmoothingChanged = true;
  			}
		}

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
  			super.updateDisplayList(unscaledWidth, unscaledHeight);

  			// Check to see if style changed.
  			if (bSmoothingChanged == true && contentHolder) {
   				var bitmapSmoothing:Boolean = getStyle("bitmapSmoothing");
   				if (contentHolder is Bitmap) {
    				Bitmap(contentHolder).smoothing = bitmapSmoothing;
   				} else if (contentHolder is Loader) {
    				try {
     					if (Loader(contentHolder).content is Bitmap) {
      						Bitmap(Loader(contentHolder).content).smoothing = bitmapSmoothing;
     					}
    				} catch(error:Error) {
    				
    				}
   				}
   				// Updated.
   				bSmoothingChanged = false;
		
			}
		}
	}
}