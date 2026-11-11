#!/usr/bin/env bash
# Shows a notification for each failed GitHub Actions run on the default branch
# of the repos below.
#
# Usage: github-pipeline-check.sh [--daemon]
#   without flag  check now and show all failed runs
#   --daemon      check once a day and report each failed run only once

REPOS="
Scewo/toradex-manifest
Scewo/meta-scewo-imx8
Scewo/go-gui
Scewo/imx8-configuration-daemon-rs
Scewo/imx8-kv-client
Scewo/imx8-kv-rpmsg-gateway
Scewo/imx8-kv-server
Scewo/imx8-kv-tcp-proxy
Scewo/imx8-notifications-daemon-rs
Scewo/imx8-scewo-library
Scewo/imx8-scewo-messages
Scewo/imx8-speaker-daemon-rs
Scewo/m7-cortex
Scewo/toolbox
"

CHECK_INTERVAL_SECONDS=$((24 * 60 * 60))
# sleep does not count time in suspend, so wake often and compare wall-clock time.
WAKE_INTERVAL_SECONDS=$((15 * 60))
LOOKBACK_DAYS=3

state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/github-pipeline-check"
reported_runs_file="$state_dir/reported-runs"
last_check_file="$state_dir/last-check"

failed_run_count=0

log_error() {
    echo "github-pipeline-check: $*" >&2
}

report_failed_runs() {
    local repo=$1 branch since runs id workflow title url key
    branch=$(gh repo view "$repo" --json defaultBranchRef -q .defaultBranchRef.name) || return 1
    since=$(date -u -d "$LOOKBACK_DAYS days ago" +%Y-%m-%d)
    # Status and conclusion are those of the last attempt; a re-run keeps the run ID.
    runs=$(gh run list -R "$repo" --branch "$branch" --status completed --created ">=$since" --limit 100 \
        --json databaseId,conclusion,workflowName,displayTitle,url \
        -q '.[] | select(.conclusion == "failure" or .conclusion == "timed_out" or .conclusion == "startup_failure")
               | [.databaseId, .workflowName, .displayTitle, .url] | @tsv') || return 1

    while IFS=$'\t' read -r id workflow title url; do
        [ -n "$id" ] || continue
        key="$repo $id"
        if [ "$mode" = daemon ]; then
            grep -qxF "$key" "$reported_runs_file" && continue
            echo "$key" >>"$reported_runs_file"
        fi
        failed_run_count=$((failed_run_count + 1))
        echo "Failed: $workflow ($repo) $url"
        notify-send --urgency=critical --app-name=github-pipeline-check \
            "Failed: $workflow ($repo)" "$title on $branch"$'\n'"$url"
    done <<<"$runs"
}

check_all_repos() {
    local repo all_ok=0
    for repo in $REPOS; do
        report_failed_runs "$repo" || {
            log_error "could not check $repo"
            all_ok=1
        }
    done
    return $all_ok
}

case "$1" in
    --daemon) mode=daemon ;;
    "") mode=once ;;
    *)
        echo "usage: $(basename "$0") [--daemon]" >&2
        exit 2
        ;;
esac

if ! command -v gh >/dev/null 2>&1; then
    log_error "gh is not installed"
    exit 1
fi

if [ "$mode" = once ]; then
    check_all_repos
    status=$?
    if [ "$status" -eq 0 ] && [ "$failed_run_count" -eq 0 ]; then
        echo "No failed runs in the last $LOOKBACK_DAYS days"
        notify-send --app-name=github-pipeline-check "GitHub pipelines" "No failed runs in the last $LOOKBACK_DAYS days"
    fi
    exit "$status"
fi

mkdir -p "$state_dir"
touch "$reported_runs_file"

while true; do
    last_check=$(cat "$last_check_file" 2>/dev/null || echo 0)
    if [ $(($(date +%s) - last_check)) -ge "$CHECK_INTERVAL_SECONDS" ]; then
        if check_all_repos; then
            date +%s >"$last_check_file"
        else
            log_error "will retry in $WAKE_INTERVAL_SECONDS seconds"
        fi
        tail -n 1000 "$reported_runs_file" >"$reported_runs_file.tmp" && mv "$reported_runs_file.tmp" "$reported_runs_file"
    fi
    sleep "$WAKE_INTERVAL_SECONDS"
done
