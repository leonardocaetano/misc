@echo off

if not exist %USERPROFILE%\AppData\Local\nvim-data\site\autoload (
   mkdir -p %USERPROFILE%\AppData\Local\nvim-data\site\autoload
)

del %USERPROFILE%\AppData\Local\nvim-data\site\autoload\plug.vim
curl -o %USERPROFILE%\AppData\Local\nvim-data\site\autoload\plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

if not exist %USERPROFILE%\AppData\Local\nvim (
   mkdir -p %USERPROFILE%\AppData\Local\nvim
)

del %USERPROFILE%\AppData\Local\nvim\init.vim
mklink /h %USERPROFILE%\AppData\Local\nvim\init.vim c:\dev\dotfiles\nvim\init.vim
