package view.suportClasses
{
	import flash.events.Event;
	
	import spark.components.ButtonBarButton;
	import spark.components.NavigatorContent;
	
	import view.VisualEditor;
	import view.interfaces.IHistorySurfaceComponent;
	import view.interfaces.IHistorySurfaceCustomHandlerComponent;
	import view.primeFaces.surfaceComponents.components.TabView;

	public class PropertyChangeReferenceTabView extends PropertyChangeReference
	{
		public function PropertyChangeReferenceTabView(fieldClass:IHistorySurfaceComponent, fieldName:String=null, fieldLastValue:*=null, fieldNewValue:*=null)
		{
			super(fieldClass, fieldName, fieldLastValue, fieldNewValue);
		}
		
		override protected function changeItem(value:*, editor:VisualEditor):void
		{
			var i:Object;
			if (fieldName && (value is Array))
			{
				if (fieldName == "label")
				{
					var selectedTab:NavigatorContent;
					var item:ButtonBarButton;
					for each (i in value)
					{
						selectedTab = TabView(this.fieldClass).getItemAt(i.field) as NavigatorContent;
						item = TabView(this.fieldClass).tabBar.dataGroup.getElementAt(i.field) as ButtonBarButton;
						selectedTab.label = i.value;
						item.label = i.value;
					}
					
					TabView(this.fieldClass).dispatchEvent(new Event(TabView.EVENT_CHILDREN_UPDATED));
				}
			}
			else if (!fieldName && (value is Array))
			{
				for each (i in value)
				{
					IHistorySurfaceCustomHandlerComponent(fieldClass).restorePropertyOnChangeReference(i.field, i.value);
				}
			}
			else if (fieldName)
			{
				// assigning single field change
				IHistorySurfaceCustomHandlerComponent(fieldClass).restorePropertyOnChangeReference(fieldName, value);
			}
			
			editor.componentsOrganizer.updateItemWithPropertyChanges(this, true);
		}
	}
}