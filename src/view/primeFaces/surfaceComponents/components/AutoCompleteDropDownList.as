package view.primeFaces.surfaceComponents.components
{
    import flash.events.Event;
    
    import mx.collections.ArrayList;
    import mx.events.CollectionEvent;
    import mx.events.CollectionEventKind;
    
    import spark.components.ComboBox;
    
    import data.DataProviderListItem;
    
    import utils.XMLCodeUtils;
    
    import view.interfaces.IDataProviderComponent;
    import view.interfaces.IHistorySurfaceComponent;
    import view.interfaces.IPrimeFacesSurfaceComponent;
    import view.interfaces.ISelectableItemsComponent;
    import view.primeFaces.propertyEditors.AutoCompleteDropDownListPropertyEditor;
    import view.primeFaces.surfaceComponents.skins.AutoCompleteDropDownListSkin;
    import view.suportClasses.PropertyChangeReference;

    public class AutoCompleteDropDownList extends ComboBox implements IPrimeFacesSurfaceComponent,
            IDataProviderComponent, ISelectableItemsComponent, IHistorySurfaceComponent
    {
        public static const PRIME_FACES_XML_ELEMENT_NAME:String = "autoComplete";
        public static const ELEMENT_NAME:String = "DropDownList";

        public function AutoCompleteDropDownList()
        {
            super();

            this.setStyle("skinClass", AutoCompleteDropDownListSkin);
            this.setStyle("borderColor", "#a8a8a8");

            this.mouseChildren = false;

            this.dataProvider = new ArrayList(
                    [
                        new DataProviderListItem("One"),
                        new DataProviderListItem("Two"),
                        new DataProviderListItem("Three"),
                        new DataProviderListItem("Four"),
                        new DataProviderListItem("Five")
                    ]);

            this.selectedIndex = 0;

            this.width = 120;
            this.height = 30;
            this.minWidth = 20;
            this.minHeight = 20;

            _propertiesChangedEvents = [
                "widthChanged",
                "heightChanged",
                "explicitMinWidthChanged",
                "explicitMinHeightChanged",
                "dropDownListChanged",
                "multipleChanged"
            ];
        }
		
		private var _propertyChangeFieldReference:PropertyChangeReference;
		public function get propertyChangeFieldReference():PropertyChangeReference
		{
			return _propertyChangeFieldReference;
		}
		
		public function set propertyChangeFieldReference(value:PropertyChangeReference):void
		{
			_propertyChangeFieldReference = value;
		}
		
		private var _isUpdating:Boolean;
		public function get isUpdating():Boolean
		{
			return _isUpdating;
		}
		
		public function set isUpdating(value:Boolean):void
		{
			_isUpdating = value;
		}
		
		public function restorePropertyOnChangeReference(nameField:String, value:*, eventType:String=null):void
		{
			this[nameField.toString()] = value;
		}

        private var _multiple:Boolean;
		[Bindable("multipleChanged")]
        public function get multiple():Boolean
        {
            return _multiple;
        }

        public function set multiple(value:Boolean):void
        {
            if (_multiple != value)
            {
				_propertyChangeFieldReference = new PropertyChangeReference(this, "multiple", _multiple, value);
				
                _multiple = value;
                dispatchEvent(new Event("multipleChanged"));
            }
        }

        public function get propertyEditorClass():Class
        {
            return AutoCompleteDropDownListPropertyEditor;
        }

        private var _propertiesChangedEvents:Array;
        public function get propertiesChangedEvents():Array
        {
            return _propertiesChangedEvents;
        }

        public function toXML():XML
        {
            var xml:XML = new XML("<" + ELEMENT_NAME + "/>");

            XMLCodeUtils.setSizeFromComponentToXML(this, xml);

            xml.@multiple = this.multiple;

            return xml;
        }

        public function fromXML(xml:XML, callback:Function):void
        {
            XMLCodeUtils.setSizeFromXMLToComponent(xml, this);

            this.multiple = xml.@multiple == "true";
        }

        public function toCode():XML
        {
            var xml:XML = new XML("<" + PRIME_FACES_XML_ELEMENT_NAME + "/>");
            var primeFacesNamespace:Namespace = new Namespace("p", "http://primefaces.org/ui");
            xml.addNamespace(primeFacesNamespace);
            xml.setNamespace(primeFacesNamespace);

            xml.@dropdown = true;
            xml.@multiple = this.multiple;

            XMLCodeUtils.addSizeHtmlStyleToXML(xml, this.width, this.height, this.percentWidth, this.percentHeight);

            return xml;
        }

        override protected function dataProvider_collectionChangeHandler(event:Event):void
        {
            super.dataProvider_collectionChangeHandler(event);

            if (event is CollectionEvent)
            {
                var ce:CollectionEvent = CollectionEvent(event);

                if (ce.kind == CollectionEventKind.ADD || ce.kind == CollectionEventKind.REMOVE)
                {
                    dispatchEvent(new Event("dropDownListChanged"));
                }
            }
        }
    }
}
