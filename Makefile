vim := vim

test: vendor/vimrc
	@env HOME="$(shell pwd)/vendor" ${vim} -Nu $< "+Vader! test/*" && echo OK

vim: vendor/vimrc
	@env HOME="$(shell pwd)/vendor" ${vim} -Nu $<

vendor/vimrc: vendor/vader.vim
	@mkdir -p ./vendor
	@echo "filetype off" > $@
	@echo "set rtp+=vendor/vader.vim" >> $@
	@echo "set rtp+=." >> $@
	@echo "filetype plugin indent on" >> $@
	@echo "syntax enable" >> $@

vendor/vader.vim:
	@mkdir -p ./vendor
	@git clone https://github.com/junegunn/vader.vim.git ./vendor/vader.vim

.PHONY: test vendor/vimrc doc
