package util
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import model.KioskModelLocator;
	import model.vo.PeopleVO;
	import model.vo.SiteVO;
	
	import mx.collections.ArrayCollection;
	
	public class XMLLoaderUtil
	{
		public static function loadSitesData():void {
			if (File.documentsDirectory.resolvePath("WWKiosk/sites.xml").exists){
				var file:File = File.documentsDirectory.resolvePath("WWKiosk/sites.xml");
				var fs:FileStream = new FileStream();
				fs.open(file, FileMode.READ);
				var sitesXML:XML = XML(fs.readUTFBytes(fs.bytesAvailable));
				fs.close();
				KioskModelLocator.getInstance().sites = new ArrayCollection();
				for each(var site:XML in sitesXML.site) {
					var vo:SiteVO = new SiteVO();
					vo.locationName = site.locationName;
					vo.latitude = site.latitude;
					vo.longtitude = site.longitude;
					vo.sourceDir = site.sourceDir;
					vo.profileImagePath = File.documentsDirectory.resolvePath("WWKiosk").nativePath + "/" + site.sourceDir + "/" + site.profileImage;
					var p:PeopleVO = new PeopleVO();
					p.names = site.people.names;
					p.story = site.people.story;
					vo.people = p;
					KioskModelLocator.getInstance().sites.addItem(vo);
				}
				loadSiteDirs();
			} 
		}
		
		public static function loadSiteDirs():void{
			for each (var site:SiteVO in KioskModelLocator.getInstance().sites){
				var allFiles:Array = File.documentsDirectory.resolvePath("WWKiosk/" + site.sourceDir ).getDirectoryListing();
				site.galleryImagePaths = new ArrayCollection();
				for each (var file:File in allFiles){
					var imagesRegExp:RegExp = new RegExp("\.(jpg|gif|jpeg|png|swf)$", "i");
					if (file.name.match(imagesRegExp) && (file.nativePath != site.profileImagePath)){
						site.galleryImagePaths.addItem(file.nativePath);
					}
				}
			}
		}
	}
}