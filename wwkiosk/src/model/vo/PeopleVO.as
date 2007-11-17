package model.vo
{
	import com.adobe.cairngorm.vo.IValueObject;

	[Bindable]
	public class PeopleVO implements IValueObject
	{
		public var names:String;
		public var story:String;
	}
}