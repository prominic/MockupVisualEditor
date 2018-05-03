package view.suportClasses
{
	import flash.events.Event;
	
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	
	import spark.components.Group;
	
	import view.EditingSurface;
	import view.suportClasses.events.PropertyEditorChangeEvent;
	import view.interfaces.IPropertyEditor;
	import view.interfaces.ISurfaceComponent;

	[Event(name="change",type="flash.events.Event")]
    [Event(name="propertyEditorChanged",type="view.suportClasses.events.PropertyEditorChangeEvent")]
	[Event(name="propertyEditorItemDeleting",type="view.suportClasses.events.PropertyEditorChangeEvent")]
	public class BasePropertyEditor extends Group implements IPropertyEditor
	{
		public function BasePropertyEditor()
		{
			this.addEventListener(Event.ADDED, propertyEditor_addedHandler);
			this.addEventListener(Event.REMOVED, propertyEditor_removedHandler);
		}

		private var _propertyEditors:Vector.<IPropertyEditor> = new <IPropertyEditor>[];

		private var _surface:EditingSurface;

		public function get surface():EditingSurface
		{
			return this._surface;
		}

		public function set surface(value:EditingSurface):void
		{
			if(this._surface === value)
			{
				return;
			}

			this._surface = value;

			var editorCount:int = this._propertyEditors.length;
			for(var i:int = 0; i < editorCount; i++)
			{
				var editor:IPropertyEditor = this._propertyEditors[i];
				editor.surface = this._surface;
			}
		}

		private var _selectedItem:ISurfaceComponent = null;

		[Bindable("change")]
		public function get selectedItem():ISurfaceComponent
		{
			return this._selectedItem;
		}

		public function set selectedItem(value:ISurfaceComponent):void
		{
			if(this._selectedItem === value)
			{
				return;
			}

			if (value)
			{
				registerPropertyChangedEvents(value);
			}

			_selectedItem = value;

			var editorCount:int = this._propertyEditors.length;
			for(var j:int = 0; j < editorCount; j++)
			{
				var editor:IPropertyEditor = this._propertyEditors[j];
				editor.selectedItem = this._selectedItem;
			}
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function beforeSelectedItemDeletes(event:Event):void
		{
			var selectedItemIndexToParent:int = IVisualElementContainer(_selectedItem.parent).getElementIndex(_selectedItem as IVisualElement);
			if (event.target.hasOwnProperty("isUpdating") && !event.target.isUpdating)
			{
				var tmpChangeRef:PropertyChangeReference = new PropertyChangeReference(_selectedItem);
				tmpChangeRef.fieldClassIndexToParent = selectedItemIndexToParent;
				tmpChangeRef.fieldClassParent = _selectedItem.parent as IVisualElementContainer;
				dispatchEvent(new PropertyEditorChangeEvent(PropertyEditorChangeEvent.PROPERTY_EDITOR_ITEM_DELETING, tmpChangeRef));
			}
		}
		
        private function onSelectedItemPropertyChanged(event:Event):void
        {
			if (event.target.hasOwnProperty("propertyChangeFieldReference") && event.target.propertyChangeFieldReference &&
				event.target.hasOwnProperty("isUpdating") && !event.target.isUpdating)
			{
				dispatchEvent(new PropertyEditorChangeEvent(PropertyEditorChangeEvent.PROPERTY_EDITOR_CHANGED, event.target.propertyChangeFieldReference));
			}
		    //dispatchEvent(new Event("propertyEditorChanged", true));
        }

		private function populatePropertyEditors(target:IVisualElement):void
		{
			if(target is IPropertyEditor)
			{
				var editor:IPropertyEditor = IPropertyEditor(target);
				this._propertyEditors.push(editor);
				editor.surface = this._surface;
				editor.selectedItem = this._selectedItem;
			}
			if(target is IVisualElementContainer)
			{
				var container:IVisualElementContainer = IVisualElementContainer(target);
				var elementCount:int = container.numElements;
				for(var i:int = 0; i < elementCount; i++)
				{
					var element:IVisualElement = container.getElementAt(i);
					this.populatePropertyEditors(element);
				}
			}
		}

		private function cleanupPropertyEditors(target:IVisualElement):void
		{
			if(target is IPropertyEditor)
			{
				var editor:IPropertyEditor = IPropertyEditor(target);
				var index:int = this._propertyEditors.indexOf(editor);
				if(index !== -1)
				{
					this._propertyEditors.removeAt(index);
				}
				editor.selectedItem = null;
				editor.surface = null;
			}
			if(target is IVisualElementContainer)
			{
				var container:IVisualElementContainer = IVisualElementContainer(target);
				var elementCount:int = container.numElements;
				for(var i:int = 0; i < elementCount; i++)
				{
					var element:IVisualElement = container.getElementAt(i);
					this.cleanupPropertyEditors(element);
				}
			}
		}

        private function registerPropertyChangedEvents(surfaceComponent:ISurfaceComponent):void
        {
            if (!surfaceComponent.propertiesChangedEvents) return;
			
			surfaceComponent.addEventListener(PropertyEditorChangeEvent.PROPERTY_EDITOR_ITEM_DELETING, beforeSelectedItemDeletes, false, 0, true);

            var propertiesChangedEventsCount:int = surfaceComponent.propertiesChangedEvents.length;
            for(var i:int = 0; i < propertiesChangedEventsCount; i++)
            {
                surfaceComponent.addEventListener(surfaceComponent.propertiesChangedEvents[i], onSelectedItemPropertyChanged);
            }
        }

        private function unregisterPropertyChangedEvents(surfaceComponent:ISurfaceComponent):void
        {
            if (!surfaceComponent) return;
            if (!surfaceComponent.propertiesChangedEvents) return;
			
			surfaceComponent.removeEventListener(PropertyEditorChangeEvent.PROPERTY_EDITOR_ITEM_DELETING, beforeSelectedItemDeletes);

            var propertiesChangedEventsCount:int = surfaceComponent.propertiesChangedEvents.length;
            for(var i:int = 0; i < propertiesChangedEventsCount; i++)
            {
                surfaceComponent.removeEventListener(surfaceComponent.propertiesChangedEvents[i], onSelectedItemPropertyChanged);
            }
        }

        private function propertyEditor_addedHandler(event:Event):void
		{
			var object:IVisualElement = event.target as IVisualElement;
			if(object === null || object === this)
			{
				return;
			}
			this.populatePropertyEditors(object);
		}

		private function propertyEditor_removedHandler(event:Event):void
		{
			var object:IVisualElement = event.target as IVisualElement;
			if (object === this)
			{
				unregisterPropertyChangedEvents(_selectedItem);
			}

			if(object === null || object === this)
			{
				return;
			}
			
			this.cleanupPropertyEditors(object);
		}
	}
}
