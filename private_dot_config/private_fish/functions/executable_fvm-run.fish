function fvm-run
    # Detect connected Android device ID (from `fvm flutter devices`)
    set device (fvm flutter devices | grep -o 'BD[0-9A-Z]\+' | head -n 1)

    if test -n "$device"
        echo "📱 Android device detected: $device"
        fvm flutter run -d $device $argv
    else
        echo "🖥️ No Android device found, running on Linux..."
        fvm flutter run -d linux $argv
    end
end

