package funkin.util;

class MemoryUtil {
	public static function getUsedBytes():Int {
		#if cpp
		return cpp.vm.Gc.memInfo(cpp.vm.Gc.MEM_INFO_USAGE);
		#elseif hl
		return Math.floor(hl.Gc.stats().currentMemory);
		#else
		return openfl.system.System.totalMemory;
		#end
	}

	public static function getAllocatedBytes():Int {
		#if cpp
		return cpp.vm.Gc.memInfo(cpp.vm.Gc.MEM_INFO_RESERVED);
		#elseif hl
		return Math.floor(hl.Gc.stats().totalAllocated);
		#else
		return 0;
		#end
	}

	public static function getFreeBytes():Int {
		return getAllocatedBytes() - getUsedBytes();
	}
}
