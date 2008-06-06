package util
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import model.KioskModelLocator;
	import model.vo.PeopleVO;
	import model.vo.SiteVO;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	public class XMLSettingsUtil
	{
		// Hardcoded name of the config dir.  This must be a subdirectory
		// of the user's documents dir.
		private static const configDirName:String = "WWKiosk";
		
		// Hardcoded name of the config file.
		private static const configFileName:String = "sites.xml";
		
		private static function get mainConfigDirPath():String {
			return File.documentsDirectory.resolvePath(configDirName).nativePath + File.separator;
		}
		
		private static function getNativeSiteSourceDirPath(sourceDir:String):String {
			return mainConfigDirPath + sourceDir + File.separator;
		}
		
		public static function loadSitesData():void {
			var configDir:File = new File(mainConfigDirPath);
			if (!configDir.exists){
				configDir.createDirectory();
			}
			
			var configFile:File = new File(mainConfigDirPath + configFileName);
			if (configFile.exists){
				var fs:FileStream = new FileStream();
				fs.open(configFile, FileMode.READ);
				var sitesXML:XML = XML(fs.readUTFBytes(fs.bytesAvailable));
				fs.close();
				KioskModelLocator.getInstance().sites = new ArrayCollection();
				for each(var site:XML in sitesXML.site) {
					var vo:SiteVO = new SiteVO();
					vo.locationName = site.locationName;
					vo.xPosition = site.xPosition;
					vo.yPosition = site.yPosition;
					vo.sourceDir = site.sourceDir;
					vo.profileImagePath = getNativeSiteSourceDirPath(site.sourceDir) + site.profileImage;
					var videoFileName:String = site.videoFile;
					if (videoFileName != "") {
						vo.videoPath = getNativeSiteSourceDirPath(site.sourceDir) + videoFileName;
					}
					var p:PeopleVO = new PeopleVO();
					p.names = site.people.names;
					p.story = site.people.story;
					vo.people = p;
					KioskModelLocator.getInstance().sites.addItem(vo);
				}
				loadSiteDirs();
			} else {
				KioskModelLocator.getInstance().sites = new ArrayCollection();
				writeSiteDataToFile();
				mx.controls.Alert.show("Config file not found.  Creating new one at " + configFile.nativePath);
			}
		}
		
		public static function loadSiteDirs():void{
			for each (var site:SiteVO in KioskModelLocator.getInstance().sites){
				var sourceDir:File = new File(mainConfigDirPath + site.sourceDir);
				var allFiles:Array = sourceDir.getDirectoryListing();
				site.galleryImagePaths = new ArrayCollection();
				for each (var file:File in allFiles){
					var imagesRegExp:RegExp = new RegExp("\.(jpg|gif|jpeg|png|swf)$", "i");
					if (file.name.match(imagesRegExp) && (file.nativePath != site.profileImagePath)){
						site.galleryImagePaths.addItem(file.nativePath);
					}
				}
			}
		}
		
		public static function writeSiteDataToFile():void {
			var configFile:File = new File(mainConfigDirPath + configFileName);
			
			var fs:FileStream = new FileStream();
			fs.open(configFile, FileMode.WRITE);
			fs.writeUTFBytes('<?xml version="1.0" encoding="UTF-8"?>\n');
			fs.writeUTFBytes(serializeModelToXML());
			fs.close();
		}
		
		private static function serializeModelToXML():String {
			var sitesXML:String = "<sites></sites>";
			var modelXML:XML = new XML(sitesXML);
				
			for each (var site:SiteVO in KioskModelLocator.getInstance().sites){
				var videoFileName:String = "";
				
				if ((site.videoPath != null) && (site.videoPath != "")){
					var videoFile:File = new File(site.videoPath);
					if ((videoFile != null) && videoFile.exists){
						videoFileName = videoFile.name;
					}
				}
				
				var profileImageFile:File = new File(site.profileImagePath);
				var profileImageName:String = profileImageFile.name;
				
				var siteXML:XML = 
					<site>
						<locationName>{site.locationName}</locationName>
						<xPosition>{site.xPosition}</xPosition>
						<yPosition>{site.yPosition}</yPosition>
						<sourceDir>{site.sourceDir}</sourceDir>
						<profileImage>{profileImageName}</profileImage>
						<videoFile>{videoFileName}</videoFile>
						<people>
							<names>{site.people.names}</names>
							<story>
								{site.people.story}
							</story>
						</people>
					</site>;
				modelXML.appendChild(siteXML);
			}
			
			return modelXML.toXMLString();
		}
	}
}