package utils
{
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	
	import view.EditingSurface;
	import view.interfaces.ISurfaceComponent;
	import view.flex.surfaceComponents.components.Button;
	import view.flex.surfaceComponents.components.Calendar;
	import view.flex.surfaceComponents.components.CheckBox;
	import view.flex.surfaceComponents.components.Container;
	import view.flex.surfaceComponents.components.DropDownList;
	import view.flex.surfaceComponents.components.Hyperlink;
	import view.flex.surfaceComponents.components.Image;
	import view.flex.surfaceComponents.components.Input;
	import view.flex.surfaceComponents.components.List;
    import view.flex.surfaceComponents.components.MainApplication;
    import view.flex.surfaceComponents.components.RadioButton;
	import view.flex.surfaceComponents.components.Table;
	import view.flex.surfaceComponents.components.Tabs;
	import view.flex.surfaceComponents.components.Text;
	import view.flex.surfaceComponents.components.Tree;
	import view.flex.surfaceComponents.components.Window;
	import view.primeFaces.surfaceComponents.components.MainApplication;
	import view.primeFaces.surfaceComponents.components.Button;	

	public class EditingSurfaceReader
	{
		private static var CLASS_LOOKUP:Object;
		
		public static function fromXML(surface:EditingSurface, xml:XML, visualEditorType:String):void
		{
			initReader(visualEditorType);
			
			function itemFromXML(parent:IVisualElementContainer, itemXML:XML):ISurfaceComponent
			{
				var name:String = itemXML.name();
				if(!(name in CLASS_LOOKUP))
				{
					throw new Error("Unknown item " + name);
				}
				var type:Class = CLASS_LOOKUP[name];
				var item:ISurfaceComponent = new type() as ISurfaceComponent;
				if(item === null)
				{
					throw new Error("Failed to create surface component: " + name);
				}
				item.fromXML(itemXML, itemFromXML);
				parent.addElement(IVisualElement(item));
				surface.addItem(item);
				return item;
			}
			var elements:XMLList = xml.elements();
			var elementCount:int = elements.length();
			for(var i:int = 0; i < elementCount; i++)
			{
				var elementXML:XML = elements[i];
				itemFromXML(surface, elementXML);
			}
		}
		
		private static function initReader(visualEditorType:String):void
		{
            CLASS_LOOKUP = {};

			if (visualEditorType == VisualEditorType.FLEX)
            {
                CLASS_LOOKUP[view.flex.surfaceComponents.components.MainApplication.ELEMENT_NAME] =
                        view.flex.surfaceComponents.components.MainApplication;

                CLASS_LOOKUP[view.flex.surfaceComponents.components.Button.ELEMENT_NAME] =
                        view.flex.surfaceComponents.components.Button;
                CLASS_LOOKUP[Container.ELEMENT_NAME] = Container;
                CLASS_LOOKUP[Calendar.ELEMENT_NAME] = Calendar;
                CLASS_LOOKUP[CheckBox.ELEMENT_NAME] = CheckBox;
                CLASS_LOOKUP[DropDownList.ELEMENT_NAME] = DropDownList;
                CLASS_LOOKUP[Hyperlink.ELEMENT_NAME] = Hyperlink;
                CLASS_LOOKUP[Image.ELEMENT_NAME] = Image;
                CLASS_LOOKUP[Input.ELEMENT_NAME] = Input;
                CLASS_LOOKUP[List.ELEMENT_NAME] = List;
                CLASS_LOOKUP[RadioButton.ELEMENT_NAME] = RadioButton;
                CLASS_LOOKUP[Table.ELEMENT_NAME] = Table;
                CLASS_LOOKUP[Tabs.ELEMENT_NAME] = Tabs;
                CLASS_LOOKUP[Text.ELEMENT_NAME] = Text;
                CLASS_LOOKUP[Tree.ELEMENT_NAME] = Tree;
                CLASS_LOOKUP[Window.ELEMENT_NAME] = Window;
            }
			else
            {
                CLASS_LOOKUP[view.primeFaces.surfaceComponents.components.MainApplication.ELEMENT_NAME] =
                        view.primeFaces.surfaceComponents.components.MainApplication;
                CLASS_LOOKUP[view.primeFaces.surfaceComponents.components.Button.ELEMENT_NAME] =
                        view.primeFaces.surfaceComponents.components.Button;
                CLASS_LOOKUP["Container"] =
                        view.primeFaces.surfaceComponents.components.Container;
            }
		}
	}
}
