export PATH
export VISUAL=nvim
export EDITOR=$VISUAL

export LC_LL=en_US.UTF-8
export LANG=en_US.UTF-8

export HISTFILE=$HOME/.cache/zsh/zsh_history
export LESSHISTFILE=$HOME/.cache/less/lesshst
export MPLCONFIGDIR=$HOME/.cache/matplotlib
export PYTHONSTARTUP=$HOME/.config/python/python-startup.py

export FZF_DEFAULT_COMMAND='fd --type f --ignore-file ~/.config/fd/fdignore'

export LS_COLORS=$(printf %s            \
                     'no=90:'           \
                     'di=01;34:'        \
                     'ex=01;32:'        \
                     'ln=35:'           \
                     'mh=31:'           \
                     '*.mp3=33:'        \
                     '*.md=04;93:'      \
                     '*.ttf=95:'        \
                     '*.otf=95:'        \
                     '*.png=04;92:'     \
                     '*.jpg=04;92')