#!/bin/sh
input=$(cat)

out=$(printf '%s' "$input" | jq -r '
  [
    (.context_window.used_percentage // empty | "ctx \(.)%"),
    (.rate_limits.five_hour.used_percentage // empty | "5h \(.)%"),
    (.rate_limits.seven_day.used_percentage // empty | "7d \(.)%")
  ] | join(" · ")' 2>/dev/null)
printf '%s' "$out"
