#!/bin/sh
input=$(cat)

out=$(printf '%s' "$input" | jq -r '
  [
    (.context_window.used_percentage // empty | "ctx \((.*10 | round) / 10)%"),
    (.rate_limits.five_hour.used_percentage // empty | "5h \((.*10 | round) / 10)%"),
    (.rate_limits.seven_day.used_percentage // empty | "7d \((.*10 | round) / 10)%")
  ] | join(" · ")' 2>/dev/null)
printf '%s' "$out"
