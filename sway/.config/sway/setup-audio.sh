#!/bin/bash

if ! pactl list short sinks | grep -q virtual_out; then
    pactl load-module module-null-sink sink_name=virtual_out sink_properties=device.description="VirtualOut"
fi

if ! pactl list short sinks | grep -q voice_chat; then
    pactl load-module module-null-sink sink_name=voice_chat sink_properties=device.description="VoiceChat"
fi

pactl set-default-sink virtual_out

# Left channel
pw-link virtual_out:monitor_FL alsa_output.pci-0000_01_00.1.hdmi-stereo-extra1:playback_FL
pw-link virtual_out:monitor_FL alsa_output.usb-SteelSeries_Arctis_Nova_3-00.analog-stereo:playback_FL
pw-link voice_chat:monitor_FL alsa_output.usb-SteelSeries_Arctis_Nova_3-00.analog-stereo:playback_FL

# Right channel
pw-link virtual_out:monitor_FR alsa_output.pci-0000_01_00.1.hdmi-stereo-extra1:playback_FR
pw-link virtual_out:monitor_FR alsa_output.usb-SteelSeries_Arctis_Nova_3-00.analog-stereo:playback_FR
pw-link voice_chat:monitor_FR alsa_output.usb-SteelSeries_Arctis_Nova_3-00.analog-stereo:playback_FR
