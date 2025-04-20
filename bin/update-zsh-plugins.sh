#!/usr/bin/bash
main() {
    ZSH_PLUGIN_PATH="${HOME}/.local/share/zsh/plugins"
    if [ -z "${ZSH_PLUGIN_PATH}" ]; then
        # TODO: try to export from .zshrc
        echo '"ZSH_PLUGIN_PATH" var is empty, should be exported in ".zshrc". Plugins will not be installed...'
    else
        echo "Updating plugins"
        update_plugins
    fi
}


update_plugins() {
    cd "${ZSH_PLUGIN_PATH}"
    for d in */; do
        echo "Updating ${d}:"
        cd "$d"; git pull; cd ..;
    done
}

main "$@"; exit
