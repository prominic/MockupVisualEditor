package view.surfaceComponents
{
	import flash.events.Event;

	import spark.components.CheckBox;

	import view.ISurfaceComponent;
	import view.propertyEditors.CheckBoxPropertyEditor;

	public class CheckBox extends spark.components.CheckBox implements ISurfaceComponent
	{
		public static const ELEMENT_NAME:String = "checkbox";

		public function CheckBox()
		{
			this.label = "Check Box";
			this.toolTip = "";
			this.width = 90;
			this.height = 30;
			this.minWidth = 20;
			this.minHeight = 20;
		}

		public function get propertyEditorClass():Class
		{
			return CheckBoxPropertyEditor;
		}

		public function toXML():XML
		{
			var xml:XML = new XML("<" + ELEMENT_NAME + "/>");
			xml.@x = this.x;
			xml.@y = this.y;
			xml.@width = this.width;
			xml.@height = this.height;
			xml.@text = this.label;
			xml.@selected = this.selected;
			return xml;
		}

		public function fromXML(xml:XML, callback:Function):void
		{
			this.x = xml.@x;
			this.y = xml.@y;
			this.width = xml.@width;
			this.height = xml.@height;
			this.label = xml.@text;
			this.selected = xml.@selected === "true";
		}

		override protected function buttonReleased():void
		{
			//we don't want the selection to change on the editing surface
		}
	}
}