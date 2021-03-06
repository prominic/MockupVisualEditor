package view.dominoFormBuilder.utils
{
	import flash.filesystem.File;
	
	import utils.MoonshineBridgeUtils;
	
	import view.dominoFormBuilder.vo.DominoFormVO;

	public class FormBuilderCodeUtils
	{
		public static function loadFromFile(path:File, toFormObject:DominoFormVO, onSuccess:Function=null):void
		{
			if (path.exists)
			{
				var fileXML:XML = XML(MoonshineBridgeUtils.moonshineBridgeFormBuilderInterface.read(path));
				toFormObject.fromXML(fileXML, onSuccess);
			}
			else if (onSuccess != null)
			{
				onSuccess();
			}
		}
		
		public static function toDominoCode(formObject:DominoFormVO):XML
		{
			XML.ignoreWhitespace = true;
			
			var form:String = DominoTemplatesManager.getFormTemplate();
			var par:String = DominoTemplatesManager.getFormParTemplate();
			
			var formBody:String = par.replace(/%value%/ig, formObject.viewName);
			formBody += formObject.toCode();
			
			form = form.replace(/%formname%/ig, formObject.formName);
			form = form.replace(/%frombody%/ig, formBody);
			
			return XML(form);
		}
		
		public static function toViewCode(formObject:DominoFormVO):XML
		{
			XML.ignoreWhitespace = true;
			
			var view:String = DominoTemplatesManager.getViewTemplate();
			view = view.replace(/%viewname%/ig, formObject.viewName);
			view = view.replace(/%formname%/ig, formObject.formName);
			view = view.replace(/%columns%/ig, formObject.toViewColumnsCode());
			
			return XML(view);
		}
	}
}