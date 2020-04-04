module bindbc.libsoundio.binddynamic;

version(BindLibsoundio_Static) {}
else version = BindLibsoundio_Dynamic;

version(BindLibsoundio_Dynamic):

import bindbc.loader;
import bindbc.libsoundio.types;

extern(C) @nogc nothrow {

	static if (libsoundioSupport >= LibsoundioSupport.libsoundio11) {
		alias psoundio_version_string = const(char)* function();
		alias psoundio_version_major = int function();
		alias psoundio_version_minor = int function();
		alias psoundio_version_patch = int function();
	}

	alias psoundio_create = SoundIo* function();
	alias psoundio_destroy = void function(SoundIo* soundio);
	alias psoundio_connect = int function(SoundIo* soundio);
	alias psoundio_connect_backend = int function(SoundIo* soundio, SoundIoBackend backend);
	alias psoundio_disconnect = void function(SoundIo* soundio);
	alias psoundio_strerror = const(char)* function(int error);
	alias psoundio_backend_name = const(char)* function(SoundIoBackend backend);
	alias psoundio_backend_count = int function(SoundIo* soundio);
	alias psoundio_get_backend = SoundIoBackend function(SoundIo* soundio, int index);
	alias psoundio_have_backend = bool function(SoundIoBackend backend);
	alias psoundio_flush_events = void function(SoundIo* soundio);
	alias psoundio_wait_events = void function(SoundIo* soundio);
	alias psoundio_wakeup = void function(SoundIo* soundio);
	alias psoundio_force_device_scan = void function(SoundIo* soundio);
	alias psoundio_channel_layout_equal = bool function(const(SoundIoChannelLayout)* a, const(SoundIoChannelLayout)* b);
	alias psoundio_get_channel_name = const(char)* function(SoundIoChannelId id);
	alias psoundio_parse_channel_id = SoundIoChannelId function(const(char)* str, int str_len);
	alias psoundio_channel_layout_builtin_count = int function();
	alias psoundio_channel_layout_get_builtin = const(SoundIoChannelLayout)* function(int index);
	alias psoundio_channel_layout_get_default = const(SoundIoChannelLayout)* function(int channel_count);
	alias psoundio_channel_layout_find_channel = int function(const(SoundIoChannelLayout)* layout, SoundIoChannelId channel);
	alias psoundio_channel_layout_detect_builtin = bool function(SoundIoChannelLayout* layout);
	alias psoundio_best_matching_channel_layout = const(SoundIoChannelLayout)* function(const(SoundIoChannelLayout)* preferred_layouts, int preferred_layout_count, const(SoundIoChannelLayout)* available_layouts, int available_layout_count);
	alias psoundio_sort_channel_layouts = void function(SoundIoChannelLayout* layouts, int layout_count);
	alias psoundio_get_bytes_per_sample = int function(SoundIoFormat format);
	alias psoundio_format_string = const(char)* function(SoundIoFormat format);
	alias psoundio_input_device_count = int function(SoundIo* soundio);
	alias psoundio_output_device_count = int function(SoundIo* soundio);
	alias psoundio_get_input_device = SoundIoDevice* function(SoundIo* soundio, int index);
	alias psoundio_get_output_device = SoundIoDevice* function(SoundIo* soundio, int index);
	alias psoundio_default_input_device_index = int function(SoundIo* soundio);
	alias psoundio_default_output_device_index = int function(SoundIo* soundio);
	alias psoundio_device_ref = void function(SoundIoDevice* device);
	alias psoundio_device_unref = void function(SoundIoDevice* device);
	alias psoundio_device_equal = bool function(const(SoundIoDevice)* a, const(SoundIoDevice)* b);
	alias psoundio_device_sort_channel_layouts = void function(SoundIoDevice* device);
	alias psoundio_device_supports_format = bool function(SoundIoDevice* device, SoundIoFormat format);
	alias psoundio_device_supports_layout = bool function(SoundIoDevice* device, const(SoundIoChannelLayout)* layout);
	alias psoundio_device_supports_sample_rate = bool function(SoundIoDevice* device, int sample_rate);
	alias psoundio_device_nearest_sample_rate = int function(SoundIoDevice* device, int sample_rate);
	alias psoundio_outstream_create = SoundIoOutStream* function(SoundIoDevice* device);
	alias psoundio_outstream_destroy = void function(SoundIoOutStream* outstream);
	alias psoundio_outstream_open = int function(SoundIoOutStream* outstream);
	alias psoundio_outstream_start = int function(SoundIoOutStream* outstream);
	alias psoundio_outstream_begin_write = int function(SoundIoOutStream* outstream, SoundIoChannelArea** areas, int* frame_count);
	alias psoundio_outstream_end_write = int function(SoundIoOutStream* outstream);
	alias psoundio_outstream_clear_buffer = int function(SoundIoOutStream* outstream);
	alias psoundio_outstream_pause = int function(SoundIoOutStream* outstream, bool pause);
	alias psoundio_outstream_get_latency = int function(SoundIoOutStream* outstream, double* out_latency);

	static if (libsoundioSupport >= LibsoundioSupport.libsoundio20) {
		alias psoundio_outstream_set_volume = int function(SoundIoOutStream* outstream, double volume);
	}

	alias psoundio_instream_create = SoundIoInStream* function(SoundIoDevice* device);
	alias psoundio_instream_destroy = void function(SoundIoInStream* instream);
	alias psoundio_instream_open = int function(SoundIoInStream* instream);
	alias psoundio_instream_start = int function(SoundIoInStream* instream);
	alias psoundio_instream_begin_read = int function(SoundIoInStream* instream, SoundIoChannelArea** areas, int* frame_count);
	alias psoundio_instream_end_read = int function(SoundIoInStream* instream);
	alias psoundio_instream_pause = int function(SoundIoInStream* instream, bool pause);
	alias psoundio_instream_get_latency = int function(SoundIoInStream* instream, double* out_latency);
	alias psoundio_ring_buffer_create = SoundIoRingBuffer* function(SoundIo* soundio, int requested_capacity);
	alias psoundio_ring_buffer_destroy = void function(SoundIoRingBuffer* ring_buffer);
	alias psoundio_ring_buffer_capacity = int function(SoundIoRingBuffer* ring_buffer);
	alias psoundio_ring_buffer_write_ptr = char* function(SoundIoRingBuffer* ring_buffer);
	alias psoundio_ring_buffer_advance_write_ptr = void function(SoundIoRingBuffer* ring_buffer, int count);
	alias psoundio_ring_buffer_read_ptr = char* function(SoundIoRingBuffer* ring_buffer);
	alias psoundio_ring_buffer_advance_read_ptr = void function(SoundIoRingBuffer* ring_buffer, int count);
	alias psoundio_ring_buffer_fill_count = int function(SoundIoRingBuffer* ring_buffer);
	alias psoundio_ring_buffer_free_count = int function(SoundIoRingBuffer* ring_buffer);
	alias psoundio_ring_buffer_clear = void function(SoundIoRingBuffer* ring_buffer);
}

__gshared {
	static if (libsoundioSupport >= LibsoundioSupport.libsoundio11) {
		psoundio_version_string soundio_version_string;
		psoundio_version_major soundio_version_major;
		psoundio_version_minor soundio_version_minor;
		psoundio_version_patch soundio_version_patch;
	}
	psoundio_create soundio_create;
	psoundio_destroy soundio_destroy;
	psoundio_connect soundio_connect;
	psoundio_connect_backend soundio_connect_backend;
	psoundio_disconnect soundio_disconnect;
	psoundio_strerror soundio_strerror;
	psoundio_backend_name soundio_backend_name;
	psoundio_backend_count soundio_backend_count;
	psoundio_get_backend soundio_get_backend;
	psoundio_have_backend soundio_have_backend;
	psoundio_flush_events soundio_flush_events;
	psoundio_wait_events soundio_wait_events;
	psoundio_wakeup soundio_wakeup;
	psoundio_force_device_scan soundio_force_device_scan;
	psoundio_channel_layout_equal soundio_channel_layout_equal;
	psoundio_get_channel_name soundio_get_channel_name;
	psoundio_parse_channel_id soundio_parse_channel_id;
	psoundio_channel_layout_builtin_count soundio_channel_layout_builtin_count;
	psoundio_channel_layout_get_builtin soundio_channel_layout_get_builtin;
	psoundio_channel_layout_get_default soundio_channel_layout_get_default;
	psoundio_channel_layout_find_channel soundio_channel_layout_find_channel;
	psoundio_channel_layout_detect_builtin soundio_channel_layout_detect_builtin;
	psoundio_best_matching_channel_layout soundio_best_matching_channel_layout;
	psoundio_sort_channel_layouts soundio_sort_channel_layouts;
	psoundio_get_bytes_per_sample soundio_get_bytes_per_sample;
	psoundio_format_string soundio_format_string;
	psoundio_input_device_count soundio_input_device_count;
	psoundio_output_device_count soundio_output_device_count;
	psoundio_get_input_device soundio_get_input_device;
	psoundio_get_output_device soundio_get_output_device;
	psoundio_default_input_device_index soundio_default_input_device_index;
	psoundio_default_output_device_index soundio_default_output_device_index;
	psoundio_device_ref soundio_device_ref;
	psoundio_device_unref soundio_device_unref;
	psoundio_device_equal soundio_device_equal;
	psoundio_device_sort_channel_layouts soundio_device_sort_channel_layouts;
	psoundio_device_supports_format soundio_device_supports_format;
	psoundio_device_supports_layout soundio_device_supports_layout;
	psoundio_device_supports_sample_rate soundio_device_supports_sample_rate;
	psoundio_device_nearest_sample_rate soundio_device_nearest_sample_rate;
	psoundio_outstream_create soundio_outstream_create;
	psoundio_outstream_destroy soundio_outstream_destroy;
	psoundio_outstream_open soundio_outstream_open;
	psoundio_outstream_start soundio_outstream_start;
	psoundio_outstream_begin_write soundio_outstream_begin_write;
	psoundio_outstream_end_write soundio_outstream_end_write;
	psoundio_outstream_clear_buffer soundio_outstream_clear_buffer;
	psoundio_outstream_pause soundio_outstream_pause;
	psoundio_outstream_get_latency soundio_outstream_get_latency;

	static if (libsoundioSupport >= LibsoundioSupport.libsoundio20) {
		psoundio_outstream_set_volume soundio_outstream_set_volume;
	}

	psoundio_instream_create soundio_instream_create;
	psoundio_instream_destroy soundio_instream_destroy;
	psoundio_instream_open soundio_instream_open;
	psoundio_instream_start soundio_instream_start;
	psoundio_instream_begin_read soundio_instream_begin_read;
	psoundio_instream_end_read soundio_instream_end_read;
	psoundio_instream_pause soundio_instream_pause;
	psoundio_instream_get_latency soundio_instream_get_latency;
	psoundio_ring_buffer_create soundio_ring_buffer_create;
	psoundio_ring_buffer_destroy soundio_ring_buffer_destroy;
	psoundio_ring_buffer_capacity soundio_ring_buffer_capacity;
	psoundio_ring_buffer_write_ptr soundio_ring_buffer_write_ptr;
	psoundio_ring_buffer_advance_write_ptr soundio_ring_buffer_advance_write_ptr;
	psoundio_ring_buffer_read_ptr soundio_ring_buffer_read_ptr;
	psoundio_ring_buffer_advance_read_ptr soundio_ring_buffer_advance_read_ptr;
	psoundio_ring_buffer_fill_count soundio_ring_buffer_fill_count;
	psoundio_ring_buffer_free_count soundio_ring_buffer_free_count;
	psoundio_ring_buffer_clear soundio_ring_buffer_clear;
}

private SharedLib lib;
private LibsoundioSupport loadedVersion;

/**
 * Unloads the shared libsoundio library.
 * If no libsoundio shared library was succesfully loaded, it does nothing.
 * This is not required to do at program exit, but if you want to prematurely
 * free memory or reload a new version this function is of use.
 * After unloading, no libsoundio functions may be called before succesfully calling loadLibsoundio again.
 */
void unloadLibsoundio()
{
	if(lib != invalidHandle) {
		lib.unload();
	}
}

/**
 * Load a libsoundio dynamic library by automatically trying common names
 * for the library. If you want to specify which dynamic library should be 
 * loaded, refer to the overload that takes a libName parameter.
 */
LibsoundioSupport loadLibsoundio()
{
	version(Windows) {
		const(char)[][1] libNames = ["libsoundio.dll"];
	} else version(OSX) {
		const(char)[][1] libNames = ["libsoundio.dylib"]; //todo: verify this
	} else version(Posix) {

		static if (libsoundioSupport >= LibsoundioSupport.libsoundio20) {
			const(char)[][6] libNames = [
			"libsoundio.so",
			"/usr/local/lib/libsoundio.so",
			"libsoundio.so.2",
			"/usr/local/lib/libsoundio.so.2",
			"libsoundio.so.2.0.0",
			"/usr/local/lib/libsoundio.so.2.0.0",
			];
		} else {
			const(char)[][14] libNames = [
			"libsoundio.so",
			"/usr/local/lib/libsoundio.so",
			"libsoundio.so.1",
			"/usr/local/lib/libsoundio.so.1",
			"libsoundio.so.1.1.0",
			"/usr/local/lib/libsoundio.so.1.1.0",
			"libsoundio.so.1.0.3",
			"/usr/local/lib/libsoundio.so.1.0.3",
			"libsoundio.so.1.0.2",
			"/usr/local/lib/libsoundio.so.1.0.2",
			"libsoundio.so.1.0.1",
			"/usr/local/lib/libsoundio.so.1.0.1",
			"libsoundio.so.1.0.0",
			"/usr/local/lib/libsoundio.so.1.0.0",
			];
		}
	}

	LibsoundioSupport ret;
    foreach(name; libNames) {
        ret = loadLibsoundio(name.ptr);
        if(ret != LibsoundioSupport.noLibrary) break;
    }
	return ret;
}

/**
 * Load a specific libsoundio dynamic library from a file path.
 * params
 * 	libName: a zero-terminated string denoting the file path to the shared library file to load.
 */
LibsoundioSupport loadLibsoundio(const(char)* libName)
{
	lib = load(libName);
	if(lib == invalidHandle) {
		return LibsoundioSupport.noLibrary; 
	}
	
	const errCount = errorCount();

	lib.bindSymbol(cast(void**)&soundio_create,"soundio_create");
	lib.bindSymbol(cast(void**)&soundio_destroy,"soundio_destroy");
	lib.bindSymbol(cast(void**)&soundio_connect,"soundio_connect");
	lib.bindSymbol(cast(void**)&soundio_connect_backend,"soundio_connect_backend");
	lib.bindSymbol(cast(void**)&soundio_disconnect,"soundio_disconnect");
	lib.bindSymbol(cast(void**)&soundio_strerror,"soundio_strerror");
	lib.bindSymbol(cast(void**)&soundio_backend_name,"soundio_backend_name");
	lib.bindSymbol(cast(void**)&soundio_backend_count,"soundio_backend_count");
	lib.bindSymbol(cast(void**)&soundio_get_backend,"soundio_get_backend");
	lib.bindSymbol(cast(void**)&soundio_have_backend,"soundio_have_backend");
	lib.bindSymbol(cast(void**)&soundio_flush_events,"soundio_flush_events");
	lib.bindSymbol(cast(void**)&soundio_wait_events,"soundio_wait_events");
	lib.bindSymbol(cast(void**)&soundio_wakeup,"soundio_wakeup");
	lib.bindSymbol(cast(void**)&soundio_force_device_scan,"soundio_force_device_scan");
	lib.bindSymbol(cast(void**)&soundio_channel_layout_equal,"soundio_channel_layout_equal");
	lib.bindSymbol(cast(void**)&soundio_get_channel_name,"soundio_get_channel_name");
	lib.bindSymbol(cast(void**)&soundio_parse_channel_id,"soundio_parse_channel_id");
	lib.bindSymbol(cast(void**)&soundio_channel_layout_builtin_count,"soundio_channel_layout_builtin_count");
	lib.bindSymbol(cast(void**)&soundio_channel_layout_get_builtin,"soundio_channel_layout_get_builtin");
	lib.bindSymbol(cast(void**)&soundio_channel_layout_get_default,"soundio_channel_layout_get_default");
	lib.bindSymbol(cast(void**)&soundio_channel_layout_find_channel,"soundio_channel_layout_find_channel");
	lib.bindSymbol(cast(void**)&soundio_channel_layout_detect_builtin,"soundio_channel_layout_detect_builtin");
	lib.bindSymbol(cast(void**)&soundio_best_matching_channel_layout,"soundio_best_matching_channel_layout");
	lib.bindSymbol(cast(void**)&soundio_sort_channel_layouts,"soundio_sort_channel_layouts");
	lib.bindSymbol(cast(void**)&soundio_get_bytes_per_sample,"soundio_get_bytes_per_sample");
	lib.bindSymbol(cast(void**)&soundio_format_string,"soundio_format_string");
	lib.bindSymbol(cast(void**)&soundio_input_device_count,"soundio_input_device_count");
	lib.bindSymbol(cast(void**)&soundio_output_device_count,"soundio_output_device_count");
	lib.bindSymbol(cast(void**)&soundio_get_input_device,"soundio_get_input_device");
	lib.bindSymbol(cast(void**)&soundio_get_output_device,"soundio_get_output_device");
	lib.bindSymbol(cast(void**)&soundio_default_input_device_index,"soundio_default_input_device_index");
	lib.bindSymbol(cast(void**)&soundio_default_output_device_index,"soundio_default_output_device_index");
	lib.bindSymbol(cast(void**)&soundio_device_ref,"soundio_device_ref");
	lib.bindSymbol(cast(void**)&soundio_device_unref,"soundio_device_unref");
	lib.bindSymbol(cast(void**)&soundio_device_equal,"soundio_device_equal");
	lib.bindSymbol(cast(void**)&soundio_device_sort_channel_layouts,"soundio_device_sort_channel_layouts");
	lib.bindSymbol(cast(void**)&soundio_device_supports_format,"soundio_device_supports_format");
	lib.bindSymbol(cast(void**)&soundio_device_supports_layout,"soundio_device_supports_layout");
	lib.bindSymbol(cast(void**)&soundio_device_supports_sample_rate,"soundio_device_supports_sample_rate");
	lib.bindSymbol(cast(void**)&soundio_device_nearest_sample_rate,"soundio_device_nearest_sample_rate");
	lib.bindSymbol(cast(void**)&soundio_outstream_create,"soundio_outstream_create");
	lib.bindSymbol(cast(void**)&soundio_outstream_destroy,"soundio_outstream_destroy");
	lib.bindSymbol(cast(void**)&soundio_outstream_open,"soundio_outstream_open");
	lib.bindSymbol(cast(void**)&soundio_outstream_start,"soundio_outstream_start");
	lib.bindSymbol(cast(void**)&soundio_outstream_begin_write,"soundio_outstream_begin_write");
	lib.bindSymbol(cast(void**)&soundio_outstream_end_write,"soundio_outstream_end_write");
	lib.bindSymbol(cast(void**)&soundio_outstream_clear_buffer,"soundio_outstream_clear_buffer");
	lib.bindSymbol(cast(void**)&soundio_outstream_pause,"soundio_outstream_pause");
	lib.bindSymbol(cast(void**)&soundio_outstream_get_latency,"soundio_outstream_get_latency");

	lib.bindSymbol(cast(void**)&soundio_instream_create,"soundio_instream_create");
	lib.bindSymbol(cast(void**)&soundio_instream_destroy,"soundio_instream_destroy");
	lib.bindSymbol(cast(void**)&soundio_instream_open,"soundio_instream_open");
	lib.bindSymbol(cast(void**)&soundio_instream_start,"soundio_instream_start");
	lib.bindSymbol(cast(void**)&soundio_instream_begin_read,"soundio_instream_begin_read");
	lib.bindSymbol(cast(void**)&soundio_instream_end_read,"soundio_instream_end_read");
	lib.bindSymbol(cast(void**)&soundio_instream_pause,"soundio_instream_pause");
	lib.bindSymbol(cast(void**)&soundio_instream_get_latency,"soundio_instream_get_latency");
	lib.bindSymbol(cast(void**)&soundio_ring_buffer_create,"soundio_ring_buffer_create");
	lib.bindSymbol(cast(void**)&soundio_ring_buffer_destroy,"soundio_ring_buffer_destroy");
	lib.bindSymbol(cast(void**)&soundio_ring_buffer_capacity,"soundio_ring_buffer_capacity");
	lib.bindSymbol(cast(void**)&soundio_ring_buffer_write_ptr,"soundio_ring_buffer_write_ptr");
	lib.bindSymbol(cast(void**)&soundio_ring_buffer_advance_write_ptr,"soundio_ring_buffer_advance_write_ptr");
	lib.bindSymbol(cast(void**)&soundio_ring_buffer_read_ptr,"soundio_ring_buffer_read_ptr");
	lib.bindSymbol(cast(void**)&soundio_ring_buffer_advance_read_ptr,"soundio_ring_buffer_advance_read_ptr");
	lib.bindSymbol(cast(void**)&soundio_ring_buffer_fill_count,"soundio_ring_buffer_fill_count");
	lib.bindSymbol(cast(void**)&soundio_ring_buffer_free_count,"soundio_ring_buffer_free_count");
	lib.bindSymbol(cast(void**)&soundio_ring_buffer_clear,"soundio_ring_buffer_clear");
	
	loadedVersion = libsoundioSupport.libsoundio10;
	
	static if (libsoundioSupport >= LibsoundioSupport.libsoundio11) {
		lib.bindSymbol(cast(void**)&soundio_version_string,"soundio_version_string");
		lib.bindSymbol(cast(void**)&soundio_version_major,"soundio_version_major");
		lib.bindSymbol(cast(void**)&soundio_version_minor,"soundio_version_minor");
		lib.bindSymbol(cast(void**)&soundio_version_patch,"soundio_version_patch");
		
		loadedVersion = libsoundioSupport.libsoundio11;
	}

	static if (libsoundioSupport >= LibsoundioSupport.libsoundio20) {
		lib.bindSymbol(cast(void**)&soundio_outstream_set_volume,"soundio_outstream_set_volume");
		
		loadedVersion = libsoundioSupport.libsoundio20;
	}

	if (errorCount() != errCount) return LibsoundioSupport.badLibrary;
	
	return loadedVersion;
}
