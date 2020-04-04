import bindbc.libsoundio;
import core.thread: Thread;

import std.stdio: writeln, writefln;
import std.exception: enforce;
import std.math: fmod, sin, PI;
import std.string: fromStringz;

// /dev/*midi*  = legacy
// /dev/snd/... = alsa devices
// aseqdump --list
// aseqdump -=port=28:0
// amidi --dump -p xxx
//
// libraries: asound pthread

struct SoundContext
{
	@nogc: nothrow: pure: @safe: private:
	enum maxSounds = 32;

	PlayingSound[maxSounds] sounds;

}

struct PlayingSound
{
	// returns true if done
	bool function(short[] toFill) sampleFunc;
	void* params;
	void* state;
	long progress;
}

enum sampleRate = 44100;
enum A0freq = 440;
enum TAU = 2 * PI;

// note: must be immutable, shared or __gshared or else it will be thread-local, which means the callback gets its own empty array
immutable float[] soundSample;

shared static this() {
	// Not done at compile time since it currently gives an out of memory
	soundSample = genSample(A0freq, sampleRate, 2.0);
}

immutable(float[]) genSample(int hz, int sampleRate, float secs) {
	import std.range, std.algorithm;
	import std.exception: assumeUnique;
	return iota(0, cast(int) (sampleRate * secs)).map!(
		x => 0.25f * customWave(cast(float) x * A0freq / sampleRate)).array.assumeUnique;
}

float customWave(float phase) {
	import std.random;
	return uniform(0.9, 1.1) * sin(phase / 2 * TAU) ^^ 4 - 0.5;
}

auto adsr(float peak, int attack) {
	import std.range, std.algorithm;
	auto amplitude = chain(iota(0, peak, 0.01), iota(0.5, 0, 0), iota(0.5, 0, 0));
}

/// Initialise the dynamic bindings
void loadDynamic() {
	LibsoundioSupport status;
	version(Windows) {
		version(X86_64)
			status = loadLibsoundio("libsoundio-x64.dll");
		else version(X86)
			status = loadLibsoundio("libsoundio-x86.dll");
		else
			static assert(0, "unsupported Windows architecture");
	} else {
		status = loadLibsoundio("libsoundio.so.2");
	}

	if (status == LibsoundioSupport.noLibrary) assert(0, "could not find libsoundio library");
	if (status == LibsoundioSupport.badLibrary) assert(0, "error when loading libsoundio symbols");
}

void main() {
	//soundSample = genSample(A0freq, sampleRate, 2.0);
	loadDynamic();

	auto audioThread = new Thread({
		try {playSine();} catch (Exception e) {writeln("Audio error: ", e.msg); throw e;}
	}).start();

	audioThread.join; // wait
}

void handleError(int err, lazy string prefix = "Soundio error: ") {
	if (err > 0) throw new Exception(prefix ~ soundio_strerror(err).fromStringz.idup);
}

int playSine() {
	SoundIoBackend backend = SoundIoBackend.SoundIoBackendNone;
	backend = SoundIoBackend.SoundIoBackendDummy;
	backend = SoundIoBackend.SoundIoBackendPulseAudio;
	auto soundio = enforce(soundio_create(), "Out of memory for soundio");
	scope (exit) soundio_destroy(soundio);
	handleError(soundio_connect_backend(soundio, backend),  "Error connecting soundio: ");
	writeln("Backend: ", soundio_backend_name(soundio.current_backend).fromStringz.idup);
	soundio_flush_events(soundio);
	const default_out_device_index = soundio_default_output_device_index(soundio);
	enforce(default_out_device_index >= 0, "No output device found");
	auto device = enforce(soundio_get_output_device(
		soundio, default_out_device_index), "Out of memory");
	scope (exit) soundio_device_unref(device);
	writeln("Output device: ", device.name.fromStringz);
	auto outstream = soundio_outstream_create(device);
	scope (exit) soundio_outstream_destroy(outstream);
	outstream.format = SoundIoFormatFloat32NE;
	assert(soundio_device_supports_format(device, SoundIoFormatFloat32NE));
	outstream.write_callback = &write_callback;
	writeln(outstream.layout_error);
	handleError(soundio_outstream_open(outstream), "Unable to open device: ");
	// outstream->layout = soundio_device_supports_layout(device, stereo) ? *stereo : device->layouts[0];
	writeln(*outstream);
	writeln(outstream.layout_error);
	writefln("Software latency: %f\n", outstream.software_latency);
	writeln(outstream.layout_error);
	handleError(outstream.layout_error, "Unable to set channel layout: ");
	handleError(soundio_outstream_start(outstream), "Unable to start device: ");
	while (true) soundio_wait_events(soundio);
	// return 0;
}

static float seconds_offset = 0.0f;

import core.stdc.stdio;

extern(C) static void write_callback(SoundIoOutStream* outstream, int frame_count_min, int frame_count_max)
{
	printf("%d %d\n", frame_count_min, frame_count_max);
	const SoundIoChannelLayout* layout = &outstream.layout;
	float float_sample_rate = outstream.sample_rate;
	float seconds_per_frame = 1.0f / float_sample_rate;
	SoundIoChannelArea* areas;
	int frames_left = frame_count_max;

	while (frames_left > 0) {
		int frame_count = frames_left;
		if (auto err = soundio_outstream_begin_write(outstream, &areas, &frame_count)) return;
		if (!frame_count) break;

		float pitch = 440.0f;
		float radians_per_second = pitch * 2.0f * PI;
		for (int frame = 0; frame < frame_count; frame += 1) {

			float fac = cast(float) outstream.sample_rate / sampleRate;
			int index = cast(int) ((seconds_offset + frame * seconds_per_frame) * sampleRate * fac);
			//printf("%d %d\n", index, soundSample.length);
			//static int index = 0;	index++;
			float sample = 0;
			if (index < soundSample.length)
				sample = soundSample[index];
			else
				sample = 0; //sin((seconds_offset + frame * seconds_per_frame) * radians_per_second);

			for (int channel = 0; channel < layout.channel_count; channel += 1) {
				float* ptr = cast(float*)(areas[channel].ptr + areas[channel].step * frame);
				*ptr = sample;
			}
		}
		seconds_offset = (seconds_offset + seconds_per_frame * frame_count); //, 1.0f); //fmod

		if (auto err = soundio_outstream_end_write(outstream)) return;

		frames_left -= frame_count;
	}
}
