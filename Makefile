home := home
flags := -v --restow --dotfiles
ignore := '\.md$$'

.PHONY: home
home: bin i3 zsh
	stow $(flags) --ignore $(ignore) -t $$HOME $(home)

.PHONY: bin
bin:
	stow $(flags) --ignore $(ignore) -t $$HOME/.local/bin bin

# i3 needs all the custom binaries installed
.PHONY: i3
i3: bin
	stow $(flags) --ignore $(ignore) -t $$HOME/.config i3

.PHONY: zsh
zsh:
	stow $(flags) --ignore $(ignore) --ignore 'zshrc.luke|\.sh$$' -t $$HOME zsh
	./zsh/install-zsh.sh
