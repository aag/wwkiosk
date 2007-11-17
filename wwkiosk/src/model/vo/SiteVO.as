package model.vo
{
	import com.adobe.cairngorm.vo.IValueObject;
	
	[Bindable]
	public class SiteVO implements IValueObject
	{
		public var locationName:String;
		public var latitude:Number;
		public var longtitude:Number;
		public var people:PeopleVO;	
	}
}