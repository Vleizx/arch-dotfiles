#!/bin/bash

get() {
    [ -f "$1" ] && cat "$1" || echo 0
}

energy_now=0
energy_full=0
power_now=0
percent=''
battery_count=0

for battery in /sys/class/power_supply/BAT*; do
    [ -d "$battery" ] || continue
    battery_count=$((battery_count + 1))

    now=$(get "$battery/energy_now")
    full=$(get "$battery/energy_full")
    power=$(get "$battery/power_now")

    [ "$full" -gt 0 ] || full=$(get "$battery/energy_full_design")
    energy_now=$((energy_now + now))
    energy_full=$((energy_full + full))
    power_now=$((power_now + power))

    [ -n "$percent" ] || percent=$(get "$battery/capacity")
done

if [ "$energy_full" -gt 0 ]; then
    percent=$((100 * energy_now / energy_full))
fi

if [ "$power_now" -gt 0 ] && [ "$energy_now" -gt 0 ]; then
    total_minutes=$((energy_now * 60 / power_now))
    h=$((total_minutes / 60))
    m=$((total_minutes % 60))
    time=$(printf "%02d:%02d" "$h" "$m")
else
    time=""
fi

if [ "$battery_count" -eq 0 ]; then
    echo ""
    exit 0
elif [ "$percent" -ge 90 ]; then icon=""
elif [ "$percent" -ge 70 ]; then icon=""
elif [ "$percent" -ge 50 ]; then icon=""
elif [ "$percent" -ge 25 ]; then icon=""
else icon=""
fi

for adapter in /sys/class/power_supply/AC* /sys/class/power_supply/ADP*; do
    if [ -f "$adapter/online" ] && [ "$(cat "$adapter/online")" = "1" ]; then
        icon=""
        break
    fi
done

echo "$icon $percent% $time"
