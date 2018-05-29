package view.primeFaces.surfaceComponents.components
{
    import flash.events.Event;
    
    import components.MaskedTextInput;
    
    import utils.XMLCodeUtils;
    
    import view.interfaces.IHistorySurfaceComponent;
    import view.interfaces.IIdAttribute;
    import view.interfaces.IPrimeFacesSurfaceComponent;
    import view.primeFaces.propertyEditors.InputMaskPropertyEditor;
    import view.suportClasses.PropertyChangeReference;

    [Exclude(name="propertiesChangedEvents", kind="property")]
    [Exclude(name="propertyChangeFieldReference", kind="property")]
    [Exclude(name="propertyEditorClass", kind="property")]
    [Exclude(name="isUpdating", kind="property")]
    [Exclude(name="toXML", kind="method")]
    [Exclude(name="fromXML", kind="method")]
    [Exclude(name="toCode", kind="method")]
    [Exclude(name="updatePropertyChangeReference", kind="method")]

    /**
     * <p>Representation of PrimeFaces inputMask component.</p>
     *
     * <strong>Visual Editor XML:</strong>
     * <pre>
     * &lt;InputMask
     * <b>Attributes</b>
     * id=""
     * width="100"
     * height="30"
     * value=""
     * mask="(999) 999-9999"/&gt;
     * </pre>
     *
     * <strong>PrimeFaces output:</strong>
     * <pre>
     * &lt;p:inputMask
     * <b>Attributes</b>
     * id=""
     * style="width:110px;height:30px;"
     * value=""
     * mask="(999) 999-9999"/&gt;
     * </pre>
     */
    public class InputMask extends MaskedTextInput implements IPrimeFacesSurfaceComponent, IIdAttribute, IHistorySurfaceComponent
    {
        public static const PRIME_FACES_XML_ELEMENT_NAME:String = "inputMask";
        public static const ELEMENT_NAME:String = "InputMask";

        public function InputMask()
        {
            super();

            this.maskText = "(999) 999-9999";
            this.mouseChildren = false;
            this.showMaskWhileWrite = false;

            this.toolTip = "";
            this.width = 100;
            this.height = 30;
            this.minWidth = 20;
            this.minHeight = 20;

            _propertiesChangedEvents = [
                "widthChanged",
                "heightChanged",
                "explicitMinWidthChanged",
                "explicitMinHeightChanged",
                "textChanged",
                "idAttributeChanged",
                "maskTextChanged"
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

        private var _idAttribute:String;
        /**
         * <p>PrimeFaces: <strong>id (Optional)</strong></p>
         *
         * @example
         * <strong>Visual Editor XML:</strong>
         * <listing version="3.0">&lt;InputMask id=""/&gt;</listing>
         * @example
         * <strong>PrimeFaces:</strong>
         * <listing version="3.0">&lt;p:inputMask id=""/&gt;</listing>
         */
        public function get idAttribute():String
        {
            return _idAttribute;
        }
		
		[Bindable("idAttributeChanged")]
        public function set idAttribute(value:String):void
        {
            if (_idAttribute != value)
            {
				_propertyChangeFieldReference = new PropertyChangeReference(this, "idAttribute", _idAttribute, value);
				
                _idAttribute = value;
                dispatchEvent(new Event("idAttributeChanged"))
            }
        }

        /**
         * <p>PrimeFaces: <strong>value</strong></p>
         *
         * @example
         * <strong>Visual Editor XML:</strong>
         * <listing version="3.0">&lt;InputMask value=""/&gt;</listing>
         * @example
         * <strong>PrimeFaces:</strong>
         * <listing version="3.0">&lt;p:inputMask value=""/&gt;</listing>
         */
        override public function get text():String
        {
            return super.text;
        }

        [Bindable("maskTextChanged")]
        /**
         * <p>PrimeFaces: <strong>mask</strong></p>
         *
         * @default "(999) 999-9999"
         *
         * @example
         * <strong>Visual Editor XML:</strong>
         * <listing version="3.0">&lt;InputMask mask="(999) 999-9999"/&gt;</listing>
         * @example
         * <strong>PrimeFaces:</strong>
         * <listing version="3.0">&lt;p:inputMask mask="(999) 999-9999"/&gt;</listing>
         */
        override public function get maskText():String
        {
            return super.maskText;
        }

        public function get propertyEditorClass():Class
        {
            return InputMaskPropertyEditor;
        }

        private var _propertiesChangedEvents:Array;

        public function get propertiesChangedEvents():Array
        {
            return _propertiesChangedEvents;
        }

		override protected function updatePropertyChangeReference(fieldName:String, oldValue:*, newValue:*):void
		{
			_propertyChangeFieldReference = new PropertyChangeReference(this, fieldName, oldValue, newValue);
		}
		
        public function toXML():XML
        {
            var xml:XML = new XML("<" + ELEMENT_NAME + "/>");

            XMLCodeUtils.setSizeFromComponentToXML(this, xml);

            xml.@mask = this.maskText;
            xml.@value = this.text;

            if (this.idAttribute)
            {
                xml.@id = this.idAttribute;
            }

            return xml;
        }

        public function fromXML(xml:XML, callback:Function):void
        {
            XMLCodeUtils.setSizeFromXMLToComponent(xml, this);

            this.maskText = xml.@mask;
            this.text = xml.@value;
            this.idAttribute = xml.@id;
        }

        public function toCode():XML
        {
            var xml:XML = new XML("<" + PRIME_FACES_XML_ELEMENT_NAME + "/>");
            var primeFacesNamespace:Namespace = new Namespace("p", "http://primefaces.org/ui");
            xml.addNamespace(primeFacesNamespace);
            xml.setNamespace(primeFacesNamespace);

            XMLCodeUtils.addSizeHtmlStyleToXML(xml, this.width, this.height, this.percentWidth, this.percentHeight);

            xml.@value = this.text;
            xml.@mask = this.maskText;

            if (this.idAttribute)
            {
                xml.@id = this.idAttribute;
            }

            return xml;
        }
    }
}
