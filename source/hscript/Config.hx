package hscript;

class Config {
	/** Runs support for custom classes in these **/
	public static final ALLOWED_CUSTOM_CLASSES = [
		''
	];

	/** Runs support for abstract support in these **/
	public static final ALLOWED_ABSTRACT_AND_ENUM = [
		''
	];

	/**
		Incase any of your files fail
		These are the module names
	**/
	public static final DISALLOW_CUSTOM_CLASSES = [
		'funkin.display.performance.FPSDisplay',
		'funkin.display.performance.MemoryDisplay',
		'funkin.display.performance.PerformanceDisplay',
		'funkin.display.Watermark'
	];

	/**
		Incase any of your files fail
		These are the module names
	**/
	public static final DISALLOW_ABSTRACT_AND_ENUM = [

	];
}
