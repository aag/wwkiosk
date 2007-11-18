package model.vo
{
	import com.adobe.cairngorm.vo.IValueObject;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class SiteVO implements IValueObject
	{
		public var locationName:String;
		public var latitude:Number;
		public var longtitude:Number;
		public var sourceDir:String;
		public var people:PeopleVO;
		public var profileImagePath:String;
		public var galleryImagePaths:ArrayCollection;
		public var videoPath:String;
	}
}