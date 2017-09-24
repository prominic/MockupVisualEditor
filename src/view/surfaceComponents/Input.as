package view.surfaceComponents
{
	import spark.components.TextInput;

	import view.ISurfaceComponent;
	import view.propertyEditors.InputPropertyEditor;

	public class Input extends spark.components.TextInput implements ISurfaceComponent
	{
        private static const MXML_ELEMENT_NAME:String = "TextInput";
		public static const ELEMENT_NAME:String = "input";

		public function Input()
		{
			this.editable = false;
			this.selectable = false;
			this.text = "Text Input|";
			this.toolTip = "";
			this.width = 100;
			this.height = 30;
			this.minWidth = 20;
			this.minHeight = 20;
		}

		public function get propertyEditorClass():Class
		{
			return InputPropertyEditor;
		}

		public function toXML():XML
		{
			var xml:XML = new XML("<" + ELEMENT_NAME + "/>");

			setCommonXMLAttributes(xml);

			return xml;
		}

		public function fromXML(xml:XML, callback:Function):void
		{
			this.x = xml.@x;
			this.y = xml.@y;
			this.width = xml.@width;
			this.height = xml.@height;
			this.text = xml.@text;
		}

        public function toMXML():XML
        {
            var xml:XML = new XML("<" + MXML_ELEMENT_NAME + "/>");
            var sparkNamespace:Namespace = new Namespace("s", "library://ns.adobe.com/flex/spark");
            xml.addNamespace(sparkNamespace);
            xml.setNamespace(sparkNamespace);

            setCommonXMLAttributes(xml);

            return xml;
        }

        private function setCommonXMLAttributes(xml:XML):void
		{
            xml.@x = this.x;
            xml.@y = this.y;
            xml.@width = this.width;
            xml.@height = this.height;
            xml.@text = this.text;
		}
    }
}
