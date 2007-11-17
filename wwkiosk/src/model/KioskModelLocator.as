package model
{
	import com.adobe.cairngorm.CairngormError;
	import com.adobe.cairngorm.CairngormMessageCodes;
	import com.adobe.cairngorm.model.IModelLocator;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	public class KioskModelLocator implements IModelLocator
	{
		private static var isConstructing:Boolean = false;
		private static var instance:KioskModelLocator;
		
		public var sites:ArrayCollection;
		
		public function KioskModelLocator():void {
			if(!isConstructing) {
				throw new CairngormError(CairngormMessageCodes.SINGLETON_EXCEPTION, "KioskModelLocator");
			}
		}
		
		public static function getInstance():KioskModelLocator {
			if(instance == null) {
				isConstructing = true;
				instance = new KioskModelLocator();
			}
			return instance;
		}
		
	}
}