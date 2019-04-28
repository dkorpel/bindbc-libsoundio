module bindbc.libsoundio;

public import bindbc.libsoundio.types;

version(BindBC_Static) version = BindLibsoundio_Static;
version(BindLibsoundio_Static) public import bindbc.libsoundio.bindstatic;
else public import bindbc.libsoundio.binddynamic;

// Below are inline functions directly in the header, not in the lib

/// A frame is one sample per channel.
pragma(inline, true) int soundio_get_bytes_per_frame(SoundIoFormat format, int channel_count) {
	return soundio_get_bytes_per_sample(format) * channel_count;
}

/// Sample rate is the number of frames per second.
pragma(inline, true) int soundio_get_bytes_per_second(SoundIoFormat format, int channel_count, int sample_rate) {
	return soundio_get_bytes_per_frame(format, channel_count) * sample_rate;
}
