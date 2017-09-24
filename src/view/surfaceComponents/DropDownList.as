package view.surfaceComponents
{
	import data.DataProviderListItem;

	import mx.collections.ArrayList;

	import spark.components.DropDownList;

	import view.ISurfaceComponent;
	import view.propertyEditors.DropDownListPropertyEditor;

	public class DropDownList extends spark.components.DropDownList
		implements ISurfaceComponent, IDataProviderComponent
	{
        private static const MXML_ELEMENT_NAME:String = "DropDownList";
		public static const ELEMENT_NAME:String = "dropdownlist";

		public function DropDownList()
		{
			this.mouseChildren = false;
			this.prompt = "Drop Down List";
			this.dataProvider = new ArrayList(
			[
				new DataProviderListItem("One"),
				new DataProviderListItem("Two"),
				new DataProviderListItem("Three"),
				new DataProviderListItem("Four"),
				new DataProviderListItem("Five"),
			]);
			this.width = 120;
			this.height = 30;
			this.minWidth = 20;
			this.minHeight = 20;
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
		}

		public function get propertyEditorClass():Class
		{
			return DropDownListPropertyEditor;
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
		}
    }
}
