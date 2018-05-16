package view.primeFaces.surfaceComponents.components
{
    import flash.events.Event;
    
    import mx.controls.Tree;
    
    import utils.XMLCodeUtils;
    
    import view.interfaces.IHistorySurfaceComponent;
    import view.interfaces.IPrimeFacesSurfaceComponent;
    import view.primeFaces.propertyEditors.TreePropertyEditor;
    import view.suportClasses.PropertyChangeReference;

    public class Tree extends mx.controls.Tree implements IPrimeFacesSurfaceComponent, IHistorySurfaceComponent
    {
        public static const PRIME_FACES_XML_ELEMENT_NAME:String = "tree";
        public static const ELEMENT_NAME:String = "Tree";

        public function Tree()
        {
            super();

            this.mouseChildren = false;
            this.width = 120;
            this.height = 120;
            this.minWidth = 20;
            this.minHeight = 20;

            this.showRoot = false;
            this.setStyle("folderOpenIcon", null);
            this.setStyle("folderClosedIcon", null);
            this.setStyle("defaultLeafIcon", null);

            this.labelField = "label";

            _propertiesChangedEvents = [
                "widthChanged",
                "heightChanged",
                "explicitMinWidthChanged",
                "explicitMinHeightChanged",
				"treeVarChanged",
				"treeValueChanged"
            ];

            var data:Array = [
                    {
                        label: "Node 0",
                        children: [
                            { label: "Node 0.0",
                              children: [
                                  {label: "Node 0.0.0"},
                                  {label: "Node 0.0.1"}
                            ]},
                            { label: "Node 0.1",
                              children: [
                                  {label: "Node 0.1.0"}
                              ]}
                        ]
                    },
                    {
                        label: "Node 1",
                        children: [
                            {
                                label: "Node 1.0",
                                children: [
                                    {label: "Node 1.0.0"}
                            ]},
                            {
                                label: "Node 1.1"
                            }
                        ]
                    },
                    {
                        label: "Node 2"
                    }
             ];

            this.dataProvider = data;
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
		
		private var _treeVar:String = "";
		[Bindable("treeVarChanged")]
		public function get treeVar():String
		{
			return _treeVar;
		}
		public function set treeVar(value:String):void
		{
			if (_treeVar == value) return;
			
			_propertyChangeFieldReference = new PropertyChangeReference(this, "treeVar", _treeVar, value);
			
			_treeVar = value;
			dispatchEvent(new Event("treeVarChanged"));
		}
		
		private var _treeValue:String = "";
		[Bindable("treeValueChanged")]
		public function get treeValue():String
		{
			return _treeValue;
		}
		public function set treeValue(value:String):void
		{
			if (_treeValue == value) return;
			
			_propertyChangeFieldReference = new PropertyChangeReference(this, "treeValue", _treeValue, value);
			
			_treeValue = value;
			dispatchEvent(new Event("treeValueChanged"));
		}

        public function get propertyEditorClass():Class
        {
            return TreePropertyEditor;
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

            return xml;
        }

        public function fromXML(xml:XML, callback:Function):void
        {
            XMLCodeUtils.setSizeFromXMLToComponent(xml, this);
        }

        public function toCode():XML
        {
            var xml:XML = new XML("<" + PRIME_FACES_XML_ELEMENT_NAME + "/>");
            var primeFacesNamespace:Namespace = new Namespace("p", "http://primefaces.org/ui");
			var hNamespace:Namespace = new Namespace("h", "http://xmlns.jcp.org/jsf/html");
            xml.addNamespace(primeFacesNamespace);
            xml.setNamespace(primeFacesNamespace);

            XMLCodeUtils.addSizeHtmlStyleToXML(xml, this.width, this.height, this.percentWidth, this.percentHeight);
			
			if (treeVar != "") xml.@['var'] = treeVar;
			if (treeValue != "") xml.@value = treeValue;

            var node:XML = new XML("<treeNode/>");
            node.addNamespace(primeFacesNamespace);
            node.setNamespace(primeFacesNamespace);
			
			var outputText:XML;
			if (treeVar != "")
			{
				outputText = new XML("<outputText/>");
				outputText.addNamespace(hNamespace);
				outputText.setNamespace(hNamespace);
				outputText.@value = "#{"+ treeVar +"}";
				node.appendChild(outputText);
			}
			
            xml.appendChild(node);

            return xml;
        }
    }
}
