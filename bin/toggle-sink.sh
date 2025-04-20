#! /usr/bin/env bash

set -eu

# Get the ID for the current DEFAULT_SINK
defaultSink=$(pactl info | grep "Default Sink: " | awk '{ print $3 }')

# Query the list of all available sinks
sinks=()
i=0
while read line; do
    index=$(echo $line | awk '{ print $1 }')
    sinks[${#sinks[@]}]=$index

    # Find the current DEFAULT_SINK
    if grep -q "$defaultSink" <<< "$line"; then
        defaultPos=$i
    fi

    i=$(( i + 1 ))
done <<< "$(pactl list sinks short)"

echo "${sinks[@]}"
echo "Default sync $defaultSink" 
echo "Default pos $defaultPos"

sink_len=${#sinks[@]}
echo "sink len $sink_len"
# Compute the ID of the new DEFAULT_SINK
newDefaultPos=$defaultPos
oldDefaultPos=$defaultPos
newDefaultSink=0
i=1
while [  $(( oldDefaultPos )) -eq $(( defaultPos )) ]; do
    if [ $(( i )) -eq $(( sink_len )) ]; then
        echo "No other sink available"
        exit 0
    fi
    newDefaultPos=$(( (defaultPos + i) % ${#sinks[@]} ))
    newDefaultSink=${sinks[$newDefaultPos]}
    echo "Trying sink $newDefaultSink"
    # Update the DEFAULT_SINK
    pacmd set-default-sink "$newDefaultSink"

    # Find new default sink
    j=0
    defaultSink=$(pactl info | grep "Default Sink: " | awk '{ print $3 }')
    while read line; do
        index=$(echo $line | awk '{ print $1 }')
        # Find the current DEFAULT_SINK
        if grep -q "$defaultSink" <<< "$line"; then
            defaultPos=$j
        fi

        j=$(( j + 1 ))
    done <<< "$(pactl list sinks short)"

    i=$(( i + 1 ))
done

echo "New default sink $defaultSink"

# Move all current playing streams to the new DEFAULT_SINK
while read stream; do
    # Check whether there is a stream playing in the first place
    if [ -z "$stream" ]; then
        break
    fi

    streamId=$(echo $stream | awk '{ print $1 }')
    pactl move-sink-input $streamId @DEFAULT_SINK@
done <<< "$(pactl list short sink-inputs)"
