package utils
{
    import mx.core.UIComponent;

	import mx.controls.Alert;

    import view.EditingSurface;
    import view.interfaces.IFlexSurfaceComponent;
    import view.interfaces.ISurfaceComponent;
    import view.primeFaces.supportClasses.Container;
    import view.primeFaces.surfaceComponents.components.MainApplication;

    public class MainApplicationCodeUtils
	{


		public static function appendXMLMainTag(surface:EditingSurface):XML
		{
			var element:ISurfaceComponent = surface.numElements > 0 ? surface.getElementAt(0) as ISurfaceComponent : null;
			var isPrimeFacesMainApp:MainApplication = element as MainApplication;

            if (!isPrimeFacesMainApp && element === null)
			{
				var container:XML = new XML("<RootDiv />");
                container.@width = "700";
				container.@height = "450";

				return container;
			}

			return null;
		}

		/**
		 * return domino main xml tag
		 */
		public static function appendDominoXMLMainTag(surface:EditingSurface):XML
		{
			var element:ISurfaceComponent = surface.numElements > 0 ? surface.getElementAt(0) as ISurfaceComponent : null;
			var isDominoMainApp:MainApplication = element as MainApplication;

		
            if (element === null && !isDominoMainApp)
			{
				
				var container:XML = new XML("<MainApplication id='mainApplicationWindow' x='0' y='0' width='700' height='450'  />");

				return container;
			}

			return null;
		}

		public static function getMainContainerTag(xml:XML):XML
		{
            var body:XMLList = xml.children();
            for each (var item:XML in body)
            {
                var itemName:String = item.name();
                if (itemName.lastIndexOf("body") > -1||itemName.lastIndexOf("Body") > -1)
                {
                    return item.children()[0];
                }
            }

			return null;
		}


		public static function getDominMainContainerTag(xml:XML):XML
		{
            var body:XMLList = xml.children();
			var mainItem:XML=null;
			for each (var item:XML in body)
            {
                var itemName:String = item.name();
				
                if (itemName=="http://www.lotus.com/dxl::richtext")
                {
					mainItem=item
                   
                }
            }
			if(mainItem==null){
				for each (var item:XML in body)
				{
					var itemName:String = item.name();
					
					if (itemName=="http://www.lotus.com/dxl::item" && item.@name=="$Body")
					{
						mainItem=item
					
					}
				}
			}

			return mainItem;
		}

		public static function getDominMainContainerTagByRichtext(xml:XML):XML
		{
            var body:XMLList = xml.children();
			var mainItem:XML=null;
			for each (var item:XML in body)
            {
                var itemName:String = item.name();
				
                if (itemName=="http://www.lotus.com/dxl::richtext")
                {
					mainItem=item
                   
                }
            }
		

			return mainItem;
		}


		public static function getDominTitleTag(xml:XML):XML
		{
            var body:XMLList = xml.children();
            for each (var item:XML in body)
            {
                var itemName:String = item.name();
				
                if (itemName=="http://www.lotus.com/dxl::item" && item.@name=="$TITLE")
                {
				
                    return item;
                }
            }

			return null;
		}


		public static function fixDominField(xml:XML):XML
		{
			var mainFieldsContainer:XML=getDominMainFieldListContainerTag(xml);
			var total_xml:XML=xml;
            handleFleldOneNode(xml,mainFieldsContainer,total_xml);
			return xml;
		}


		private static function handleFleldOneNode(xml:XML,mainFieldsContainer:XML,total_xml:XML):void {
                var children:XMLList = xml.children();
                if ( children.length() == 0 ) {
					
                    //Handle Leaf node -> Create ui object, or whatever 
                } else {
                    //Non terminal node, check children
                    for each (var child:XML in children ) {
						
						var childName:String=child.name();
                        if(childName=="field" || childName== "_moonshineSelected_field"){
                             
                            xml=handleDominoFleldNode(child,mainFieldsContainer,total_xml)
                        }
                        handleFleldOneNode(child,mainFieldsContainer,total_xml);
                    }
                }

			
            }


			private static function handleDominoFleldNode(node:XML,mainFieldsContainer:XML,total_xml:XML):XML{

						
						var field_name:String = node.attribute("name").toString();
						 //Alert.show("field name 212:"+field_name);
						  if(mainFieldsContainer){
                               mainFieldsContainer.appendChild(new XML("<text>"+field_name+"</text>"))
                          }
                         //2.
						//   var itemXML:XML = new XML("<item />");
                        //    itemXML.@name=field_name;
                        //    itemXML.@summary="false";
                        //    itemXML.@sign="true";
						//    if(node.@type=="text"){
                        //        var tyepTextXML:XML = new XML("<text>"+field_name+"</text>");
                        //        itemXML.appendChild(tyepTextXML);
						// 	}else if(node.@type=="number"){
						// 		var tyepNumberXML:XML = new XML("<number>"+0+"</number>");
						// 		itemXML.appendChild(tyepNumberXML);
						// 	}else if(node.@type=="datetime"){
						// 		var rawXML:XML = new XML("<rawitemdata type='400'>AAAAAAAAAAA=</rawitemdata>");
						// 		itemXML.appendChild(rawXML);
						// 	}

						// 	 total_xml.appendChild(itemXML);
					

					return total_xml
			
			}


	





		public static function getDominMainFieldListContainerTag(xml:XML):XML
		{
            var body:XMLList = xml.children();
            for each (var item:XML in body)
            {
                var itemName:String = item.name();
                if (itemName=="http://www.lotus.com/dxl::item" && item.@name=="$Fields")
                {
				
                    return item.children()[0];
                }
            }

			return null;
		}
		
		public static function getParentContent(surface:EditingSurface, title:String, component:UIComponent):XML
		{
            var element:ISurfaceComponent = surface.getElementAt(0) as ISurfaceComponent;
            var isPrimeFacesMainApp:MainApplication = element as MainApplication;

			if (!isPrimeFacesMainApp && element is IFlexSurfaceComponent)
			{
				return getFlexMainContainer(title, element.width, element.height);
			}
			
			return getPrimeFacesMainContainer(title, component,
                    element as view.primeFaces.supportClasses.Container);
		}
		/**
		 * Overloaded this function, so that the domino project can call it
		 */

		public static function getDominoParentContent(title:String,windowsTitle:String):XML
		{	   
			return getDominoMainContainer(title,windowsTitle);	
		}
		
		private static function getFlexMainContainer(title:String, width:Number, height:Number):XML
		{
			var xml:XML = new XML("<WindowedApplication></WindowedApplication>");
            var sparkNamespace:Namespace = new Namespace("s", "library://ns.adobe.com/flex/spark");
            xml.addNamespace(sparkNamespace);
            xml.setNamespace(sparkNamespace);
			
            var fxNamespace:Namespace = new Namespace("fx", "http://ns.adobe.com/mxml/2009");
            xml.addNamespace(fxNamespace);
			xml.@title = title;
			xml.@width = width;
			xml.@height = height;
			
			return xml;
		}
		
		private static function getPrimeFacesMainContainer(title:String, element:UIComponent,
														   container:view.primeFaces.supportClasses.Container):XML
		{
			var xml:XML = new XML("<html/>");

            var htmlNamespace:Namespace = new Namespace("", "http://www.w3.org/1999/xhtml");
            xml.addNamespace(htmlNamespace);
            xml.setNamespace(htmlNamespace);

			var hNamespace:Namespace = new Namespace("h", "http://xmlns.jcp.org/jsf/html");
			xml.addNamespace(hNamespace);
			
			var uiNamespace:Namespace = new Namespace("ui", "http://xmlns.jcp.org/jsf/facelets");
			xml.addNamespace(uiNamespace);

			var fNamespace:Namespace = new Namespace("f", "http://xmlns.jcp.org/jsf/core");
			xml.addNamespace(fNamespace);

			var pNamespace:Namespace = new Namespace("p", "http://primefaces.org/ui");
			xml.addNamespace(pNamespace);

			var headXml:XML = new XML("<head/>");
			headXml.addNamespace(hNamespace);
			headXml.setNamespace(hNamespace);

            var relativeFilePath:String = MoonshineBridgeUtils.getRelativeFilePath();

			var cssStyleSheetXml:XML = new XML("<link></link>");
            cssStyleSheetXml.@rel = "stylesheet";
			cssStyleSheetXml.@type = "text/css";
			if (relativeFilePath == "..")
			{
                cssStyleSheetXml.@href = "resources/moonshine-layout-styles.css";
			}
			else
			{
                cssStyleSheetXml.@href = relativeFilePath.substring(relativeFilePath.indexOf("/") + 1) + "/resources/moonshine-layout-styles.css";
            }

            headXml.appendChild(cssStyleSheetXml);

            cssStyleSheetXml = new XML("<link></link>");
            cssStyleSheetXml.@rel = "stylesheet";
            cssStyleSheetXml.@type = "text/css";
            cssStyleSheetXml.@href = relativeFilePath + "/assets/moonshine-layout-styles.css";

			headXml.appendChild(cssStyleSheetXml);

			if (!title)
			{
				title = "";
			}		
			
			var titleXML:XML = new XML("<title>" + title + "</title>");
			headXml.appendChild(titleXML);
			
			var bodyXML:XML = new XML("<body/>");
			bodyXML.addNamespace(hNamespace);
			bodyXML.setNamespace(hNamespace);

			var mainDiv:XML = new XML("<"+ MxmlCodeUtils.getMXMLTagNameWithSelection(container as ISurfaceComponent, "div") +"/>");

            mainDiv["@class"] = XMLCodeUtils.getChildrenPositionForXML(container);
            XMLCodeUtils.addSizeHtmlStyleToXML(mainDiv, element);
			
			bodyXML.appendChild(mainDiv);
			
			xml.appendChild(headXml);
			xml.appendChild(bodyXML);

			return xml;
		}


		private static function getDominoMainContainer(title:String,windowsTitle:String):XML
		{
				var dat:Date = new Date();
				var xml_str:String = "<?xml version=\"1.0\" encoding=\"utf-8\"?>";
				xml_str=xml_str+"<note class='form' xmlns='http://www.lotus.com/dxl' version='9.0' maintenanceversion='1.4' replicaid='4825808B00336E81'>";
				xml_str=xml_str+"<!DOCTYPE note>";
				// xml_str=xml_str+"<noteinfo noteid='2116' unid='27C118EDE31483CB86256C6900644875' sequence='8'>";
				// xml_str=xml_str+"<created><datetime>"+dat+"</datetime></created> ";
				// xml_str=xml_str+"<modified><datetime>"+dat+"</datetime></modified> ";
				// xml_str=xml_str+"<revised dst=\"true\"><datetime>"+dat+"</datetime></revised>";
				// xml_str=xml_str+"<lastaccessed><datetime>"+dat+"</datetime></lastaccessed>";
				// xml_str=xml_str+"<lastaccessed><datetime>"+dat+"</datetime></lastaccessed>";
				// xml_str=xml_str+"<addedtofile><datetime>"+dat+"</datetime></addedtofile>";
				// xml_str=xml_str+"</noteinfo>"
				if(windowsTitle!=null  && windowsTitle!=""){
					xml_str=xml_str+"<item name='$WindowTitle' sign='true'><formula>"+windowsTitle+"</formula></item>"
				}
				xml_str=xml_str+"<item name='$Info' sign='true'><rawitemdata type='1'>hhgBAIAAAAAAgAAAAQABAP///wAQAAAA</rawitemdata></item>"
				xml_str=xml_str+"<item name='$Flags'><text/></item>"
				xml_str=xml_str+"<item name='$TITLE'><text>"+title+"</text></item>"
				xml_str=xml_str+"<item name='$Fields'><textlist></textlist></item>"
				xml_str=xml_str+"<item name='$Body' sign='true'></item>"
				
				xml_str=xml_str+"</note>";
			



				var xml:XML = new XML(xml_str);
				
			
			

			return xml;
		}
	}
}