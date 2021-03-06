help:
	@echo "Usage: make install[-zsh|-vim|-micro|-tmux]|clean|get-fontawesome|ssh-keygen|chsh"
install:
	! which zsh || make install-zsh
	! which tmux || make install-tmux
	! which micro || make install-micro
	! which vim || make install-vim
	[ -z "$$XDG_SESSION_TYPE" ] || make get-fontawesome
	make ssh-keygen
	make chsh
clean:
	find vim -mindepth 1 -not -path 'vim/colors/*' -not -path vim/colors -not -path vim/vimrc -exec rm -rf {} \+
	rm -rf lightline
install-zsh:
	@echo "\n\n\033[103;30mInstalling zsh...\033[0m"
	[ ! -d ~/.antigen ] && git clone https://github.com/zsh-users/antigen.git ~/.antigen || echo Antigen is already installed
	cp zshrc ~/.zshrc
	echo >> ~/.zshrc
	cat zshrc.local >> ~/.zshrc
install-micro:
	@echo "\n\n\033[103;30mConfiguring micro...\033[0m"
	mkdir -p ~/.config
	rm -rf ~/.config/micro
	cp -R micro ~/.config/micro
install-tmux:
	@echo "\n\n\033[103;30mConfiguring tmux...\033[0m"
	cp tmux.conf ~/.tmux.conf
install-vim: clean
	@echo "\n\n\033[103;30mConfiguring vim...\033[0m"
	# Lightline
	git clone https://github.com/itchyny/lightline.vim.git lightline
	mv lightline/autoload lightline/plugin vim
	rm -rf lightline
	# Lastplace
	curl -qo vim/plugin/vim-lastplace.vim https://raw.githubusercontent.com/dietsche/vim-lastplace/master/plugin/vim-lastplace.vim
	# Install
	cp vim/vimrc ~/.vimrc
	rm -rf ~/.vim
	cp -R vim ~/.vim
	rm -f ~/.vim/vimrc
get-fontawesome:
	@echo "\n\n\033[103;30mDownloading FontAwesome...\033[0m"
	[ -d ~/.local/share/fonts ] || mkdir -p ~/.local/share/fonts
	[ -f ~/.local/share/fonts/fontawesome-webfont.ttf ] || ( wget https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/fonts/fontawesome-webfont.ttf -O ~/.local/share/fonts/fontawesome-webfont.ttf && fc-cache -fv )
ssh-keygen:
	@echo "\n\n\033[103;30mGenerating SSH key if none exists...\033[0m"
	[ -d ~/.ssh ] || ( mkdir ~/.ssh && chmod 700 ~/.ssh )
	find ~/.ssh/ -name '*.pub' >/dev/null && (echo "\033[32m" && cat ~/.ssh/*.pub && echo "\033[0m") || (ssh-keygen -t ed25519 -N "" -f ~/.ssh/id && echo "\033[32m" && cat ~/.ssh/id.pub && echo "\033[0m")
	[ -f ~/.ssh/authorized_keys ] || ( touch ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys )
chsh:
	@echo "\n\n\033[103;30mChanging shell to $$(which zsh) if not already set...\033[0m"
	[ "$$(getent passwd $$(id -u) | cut -d: -f7)" = "$$(which zsh)" ] || (echo "\033[1m" && chsh -s "$$(which zsh)" && echo "\033[0m")
