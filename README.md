# bindbc-libsoundio
Static and dynamic bindings for [libsoundio](http://libsound.io/), a low-level library for playing and recording sounds.
You won't be simply calling `playSound()` or something, but instead find an input/output device and provide a callback writing samples to a buffer.
For more high level audio functions, you might want to check out [SDL](http://code.dlang.org/packages/bindbc-sdl).
If you want cross-platform access to the audio drivers and have total control, this library is a great fit.
Comparisons with other audio libraries can be found on the [libsoundio wiki](https://github.com/andrewrk/libsoundio/wiki).

The bindings are `@nogc` and `nothrow` compatible and can be compiled for compatibility with `-betterC`.
If you only want static bindings, check out WebFreak's [dsoundio](https://github.com/WebFreak001/dsoundio).

## Warning: this readme is work in progress

## Usage
### Windows
Get a [release](http://libsound.io/#releases) for libsoundio.
Add this package to your project. Ensure the right shared library are in the same folder as your executible.
Here is an example for Windows, where you extracted the dlls to the lib folder and renamed them:
__dub.json__
```
"dependencies": {
    "bindbc-libsoundio": "~>0.1.0",
}
"copyFiles-windows-x64" ["libs/libsoundio-x64.dll"]
"copyFiles-windows-x86_64" ["libs/libsoundio-x86.dll"]

}
```

__dub.sdl__
```
dependency "bindbc-libsoundio" version="~>0.1.0"
copyFiles "libs/libsoundio-x86.dll" platform="windows-x86"
copyFiles "libs/libsoundio-x64.dll" platform="windows-x86_64"
```

This assumes you put the libraries in a lib folder and renamed them to include -x86 or -64.

### Linux
On Linux, you need to build libsoundio yourself. Assuming a standard Ubuntu/Debian installation, this should work:
```
sudo apt-get install libpulse-dev cmake
git clone https://github.com/andrewrk/libsoundio
cd libsoundio
mkdir build
cd build
cmake ..
make
sudo make install
```
For more detailed instructions, see: TODO
Explanation:
- First you need to install CMake because libsoundio uses that to generate makefiles / a Visual Studio Project / whatever C build set-up you want.
- Then you clone libsoundio, and enter the directory, and make a build folder.
- `make` will build the static and dynamic libraries, and also the examples.
To do this, first you need to get development
packages for an audio backend, or else only the 'Dummy' (silence) back-end will be available.

Example code can be found below.

```D
import bindbc.libsoundio;
import core.thread: Thread;

import std.stdio: writeln;
import std.exception: enforce;
import std.math: fmod, sin, PI;

void main() {
	LoadStatus status;
	version(Windows) {
		version(X86_64)
			status = loadLibsoundio("libsoundio-x64.dll");
		else version(X86)
			status = loadLibsoundio("libsoundio-x86.dll");
		else
			static assert(0, "unsupported Windows architecture");
	} else {
		status = loadLibsoundio(); // use default name
	}

	if (status == LoadStatus.noLibrary) assert(0, "could not find libsoundio library");
	if (status == LoadStatus.badLibrary) assert(0, "error when loading libsoundio symbols");
	assert(status == LoadStatus.success);

	auto audioThread = new Thread({
		try {playSine();} catch (Exception e) {writeln("Audio error: ", e.msg);}
	}).start();

	audioThread.join; // wait
}

void handleError(int err, lazy string prefix = "Soundio error: ") {
	import std.string: fromStringz;
	if (err > 0) throw new Exception(prefix ~ soundio_strerror(err).fromStringz.idup);
}

int playSine() {
	import std.string: fromStringz;
	auto soundio = enforce(soundio_create(), "Out of memory for soundio");
	scope (exit) soundio_destroy(soundio);
	handleError(soundio_connect(soundio),  "Error connecting soundio: ");
	soundio_flush_events(soundio);
	int default_out_device_index = soundio_default_output_device_index(soundio);
	enforce(default_out_device_index >= 0, "No output device found");
	auto device = enforce(soundio_get_output_device(
		soundio, default_out_device_index), "Out of memory");
	scope (exit) soundio_device_unref(device);
	writeln("Output device: ", device.name.fromStringz);
	auto outstream = soundio_outstream_create(device);
	scope (exit) soundio_outstream_destroy(outstream);
	outstream.format = SoundIoFormatFloat32NE;
	outstream.write_callback = &write_callback;
	handleError(soundio_outstream_open(outstream), "Unable to open device: ");
	handleError(outstream.layout_error, "Unable to set channel layout: ");
	handleError(soundio_outstream_start(outstream), "Unable to start device: ");
	while (true) soundio_wait_events(soundio);
	// return 0;
}

static float seconds_offset = 0.0f;

extern(C) static void write_callback(SoundIoOutStream* outstream, int frame_count_min, int frame_count_max)
{
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
			float sample = sin((seconds_offset + frame * seconds_per_frame) * radians_per_second);
			for (int channel = 0; channel < layout.channel_count; channel += 1) {
				float* ptr = cast(float*)(areas[channel].ptr + areas[channel].step * frame);
				*ptr = sample;
			}
		}
		seconds_offset = fmod(seconds_offset + seconds_per_frame * frame_count, 1.0f);

		if (auto err = soundio_outstream_end_write(outstream)) return;

		frames_left -= frame_count;
	}
}
```
