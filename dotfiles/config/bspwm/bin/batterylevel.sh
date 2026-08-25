#!/bin/bash

notified_20=false
notified_10=false
notified_5=false

last_notify=0
cooldown=900  # 15 minutos

get_battery_values() {
  local path=$1

  if [ -f "$path/energy_now" ]; then
    now=$(cat "$path/energy_now")
    full=$(cat "$path/energy_full")
  else
    now=$(cat "$path/charge_now")
    full=$(cat "$path/charge_full")
  fi

  echo "$now $full"
}

while true; do
  total_now=0
  total_full=0

  ac_status=$(cat /sys/class/power_supply/AC*/online 2>/dev/null | head -n1)

  for bat in /sys/class/power_supply/BAT*; do
    [ -d "$bat" ] || continue
    read now full < <(get_battery_values "$bat")

    total_now=$((total_now + now))
    total_full=$((total_full + full))
  done

  if [ "$total_full" -eq 0 ]; then
    sleep 60
    continue
  fi

  percent=$((100 * total_now / total_full))
  now_time=$(date +%s)

  if [ "$ac_status" -eq 0 ]; then

    if (( now_time - last_notify < cooldown )); then
      sleep 120
      continue
    fi

    if [ "$percent" -le 5 ] && [ "$notified_5" = false ]; then
      dunstify -u critical "💀 CRÍTICO" "Conectá el cargador YA ($percent%)"
      notified_5=true
      last_notify=$now_time

    elif [ "$percent" -le 10 ] && [ "$notified_10" = false ]; then
      dunstify -u normal "⚠️ Muy baja" "Quedan $percent%"
      notified_10=true
      last_notify=$now_time

    elif [ "$percent" -le 20 ] && [ "$notified_20" = false ]; then
      dunstify -u low "🔋 Batería baja" "Quedan $percent%"
      notified_20=true
      last_notify=$now_time
    fi

  else
    notified_20=false
    notified_10=false
    notified_5=false
  fi

  sleep 120
done
