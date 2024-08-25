package options;

import openfl.Lib;
import lime.app.Application;


enum OptionType {
	BOOL;
	INT;
	FLOAT;
	PERCENT;
	STRING;
	KEYBIND;
	STATE;
	TEXT;
}

class Option extends FlxSpriteGroup
{
	private var variable:String = null; //Variable from ClientPrefs.hx
	public var defaultValue:Dynamic = null;
	public var description:String = '';

	public var options:Array<String> = null;
	public var curOption:Int = 0;

	public var minValue:Float = 0;
	public var maxValue:Float = 0;

	public var defaultKeys:Keybind = null; //Only used in keybind type
	public var keys:Keybind = null; //Only used in keybind type

	public var saveHeight:Float = 0;

	public function new(description:String = '', variable:String = '', type:OptionType = BOOL, ?minValue:Float = 0, ?maxValue:Float = 0, ?options:Array<String> = null)
	{
		super();

		this.options = options;
		this.description = description;

		if(this.type != KEYBIND && variable != '') this.defaultValue = Reflect.getProperty(ClientPrefs.defaultData, variable);

		switch(type)
		{
			case BOOL:
				if(defaultValue == null) defaultValue = false;
			case INT, FLOAT:
				if(defaultValue == null) defaultValue = 0;
			case PERCENT:
				if(defaultValue == null) defaultValue = 1;
			case STRING:
				if(options.length > 0)
					defaultValue = options[0];
				if(defaultValue == null)
					defaultValue = '';
			case KEYBIND:
				defaultValue = '';
				defaultKeys = {gamepad: 'NONE', keyboard: 'NONE'};
				keys = {gamepad: 'NONE', keyboard: 'NONE'};
		}

		if(getValue() == null)
			setValue(defaultValue);

		switch(type)
		{
			case STRING:
				var num:Int = options.indexOf(getValue());
				if(num > -1) curOption = num;
		}

		switch(type)
		{
			case BOOL:
				addBool();
			case INT, FLOAT, PERCENT:
				addData();
			case STRING:
				addString();
			case TEXT:
				addText();
		}
	}

	function addBool() {
		saveHeight = 40;

		var text = new FlxText(40, 0, 0, description, 20);
		text.font = Paths.font('montserrat.ttf'); 	
        text.antialiasing = ClientPrefs.data.antialiasing;	
        text.y += saveHeight / 2 - text.height / 2;
        add(text);

		var rect = new BoolRect(0, 0, 1030, 40, this);
		add(rect);
	}

	function addData() {
		
	}

	function addString() {
		
	}

	function addText() {
		var text = new FlxText(40, 0, 0, description, 20);
		text.font = Paths.font('montserrat.ttf'); 	
        text.antialiasing = ClientPrefs.data.antialiasing;	
        text.y += saveHeight / 2 - text.height / 2;
        add(text);
	}

	public function change()
	{
		if(onChange != null)
			onChange();
	}

	dynamic public function getValue():Dynamic
	{
		var value = Reflect.getProperty(ClientPrefs.data, variable);
		if(type == KEYBIND) return !Controls.instance.controllerMode ? value.keyboard : value.gamepad;
		return value;
	}

	dynamic public function setValue(value:Dynamic)
	{
		if(type == KEYBIND)
		{
			var keys = Reflect.getProperty(ClientPrefs.data, variable);
			if(!Controls.instance.controllerMode) keys.keyboard = value;
			else keys.gamepad = value;
			return value;
		}
		return Reflect.setProperty(ClientPrefs.data, variable, value);
	}
}