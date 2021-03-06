package view.dominoFormBuilder.vo
{
	import view.dominoFormBuilder.utils.DominoTemplatesManager;

	[Bindable] public class DominoFormFieldVO
	{
		public static const ELEMENT_NAME:String = "field";
		
		public var name:String;
		public var label:String = "";
		public var description:String = "";
		public var type:String = FormBuilderFieldType.fieldTypes.getItemAt(0) as String;
		public var editable:String = FormBuilderEditableType.editableTypes.getItemAt(0) as String;
		public var formula:String = "";
		public var sortOption:Object = FormBuilderSortingType.sortTypes.getItemAt(0);
		public var isMultiValue:Boolean;
		public var isIncludeInView:Boolean = true;
		
		public function DominoFormFieldVO()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  PUBLIC API
		//
		//--------------------------------------------------------------------------
		
		public function fromXML(value:XML, callback:Function=null):void
		{
			this.name = value.@name;
			this.type = value.@type;
			this.editable = value.@editable;
			this.isMultiValue = (value.@isMultiValue == "true") ? true : false;
			this.isIncludeInView = (value.@isIncludeInView == "true") ? true : false;
			
			for each (var sortType:Object in FormBuilderSortingType.sortTypes.source)
			{
				if (value.@sortOption == sortType.label)
				{
					this.sortOption = sortType;
					break;
				}
			}
			
			this.label = value.label;
			this.description = value.description;
			this.formula = value.formula;
		}
		
		public function toXML():XML
		{
			var xml:XML = new XML("<" + ELEMENT_NAME + "/>");
			
			xml.@name = name;
			xml.@type = type;
			xml.@editable = editable;
			xml.@sortOption = sortOption.label;
			xml.@isMultiValue = isMultiValue.toString();
			xml.@isIncludeInView = isIncludeInView.toString();
			
			var tempXML:XML = <label/>;
			tempXML.appendChild(new XML("\<![CDATA[" + label + "]]\>"));
			xml.appendChild(tempXML);
			
			tempXML = <description/>;
			tempXML.appendChild(new XML("\<![CDATA[" + description + "]]\>"));
			xml.appendChild(tempXML);
			
			tempXML = <formula/>;
			tempXML.appendChild(new XML("\<![CDATA[" + formula + "]]\>"));
			xml.appendChild(tempXML);
			
			return xml;
		}
		
		//--------------------------------------------------------------------------
		//
		//  DXL/XML
		//
		//--------------------------------------------------------------------------
		
		public function toCode():String
		{
			var row:String = DominoTemplatesManager.getTableRowTemplate();
			var cell:String = DominoTemplatesManager.getTableCellTemplate();
			
			// for now until Dmytro provides
			// template of table-row having predefined
			// table-column/cell, we'll generate manual 3
			var tmpAllColumns:String = "";
			var tmpField:String;
			for (var i:int; i < 3; i++)
			{
				tmpAllColumns = cell.replace(/%cellbody%/ig, label);
				
				tmpField = DominoTemplatesManager.getFieldTemplate(type, isMultiValue, editable);
				if (tmpField)
				{
					tmpField = tmpField.replace(/%fieldname%/ig, name);
					tmpField = tmpField.replace(/%computedvalue%/ig, formula);
				}
				tmpAllColumns += cell.replace(/%cellbody%/ig, tmpField ? tmpField : '');
				
				tmpAllColumns += cell.replace(/%cellbody%/ig, description);
			}
			
			row = row.replace(/%cells%/ig, tmpAllColumns);
			return row;
		}
	}
}