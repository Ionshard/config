#Pat
export PATH=${PATH}:/home/kasuko/bin

#Toolchains
#export PATH=${PATH}:/home/kasuko/Programs/CodeSourcery/bin:/home/kasuko/code/Android/source/prebuilt/linux-x86/toolchain/arm-eabi-4.3.1/bin:/home/kasuko/Programs/gnuarm-4.0.2/bin:/home/kasuko/Programs/arm-crosstool/gcc-4.1.0-glibc-2.3.2/arm-unknown-linux-gnu/bin

# Completion
autoload -Uz compinit
zstyle ':completion:*' completer _complete _ignored
zstyle :compinstall filename "$HOME/.zshrc"
compinit

# VCS
#autoload -Uz vcs_info
#zstyle ':vcs_info:*' enable git svn bzr
#zstyle ':vcs_info:*' check-for-changes true
#zstyle ':vcs_info:*' unstagedstr '¹'
#zstyle ':vcs_info:*' stagedstr '²'
#zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b:%r'
#zstyle ':vcs_info:*' actionformats '(%b%u%c|%a) '
#zstyle ':vcs_info:*' formats '(%b%u%c) '
#zstyle ':vcs_info:*' nvcsformats ""

# Auto Mime Type Running
autoload -Uz zsh-mime-setup
autoload -Uz pick-web-browser
zstyle ':mime:*' mailcap ~/.mailcap
# Example: to make it not background an app
# zstyle ':mime:.txt:' flags needsterminal
zsh-mime-setup

#web
alias -s html=pick-web-browser
#gfx
alias -s xcf="gimp-remote"
alias -s png="mirage"
alias -s gif="mirage"
alias -s jpg="mirage"
# media files
alias -s pdf="epdfview"

#Colors
autoload -Uz colors
autoload -Uz zsh/terminfo
eval "$(dircolors -b)"
if [[ "$terminfo[colors]" -ge 8 ]]; then
    colors
fi
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
    eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
    eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
    (( count = $count + 1 ))
done
PR_NO_COLOUR="%{$terminfo[sgr0]%}"

### ZSH options
# pushd options
setopt auto_pushd # pushes visited dirs on a stack to popd
setopt pushd_silent # pushd silently
setopt pushd_to_home # "pushd" w/o args takes you home
# completion options
setopt auto_list # outputs completion opts immediately on ambig
setopt list_types # shows types of possible completion opts
setopt complete_in_word # complete while in mid of word, and don't move cursor
setopt extended_glob # extra zsh glob features
# history options
setopt share_history # all zsh sessions merge history
setopt hist_ignore_dups # don't put duplicates in history
setopt hist_reduce_blanks # remove extra spaces hist commands
# input/output options
setopt aliases # expand aliases
setopt clobber # allow > and >> to clobber/create files
setopt interactive_comments # allow comments in interactive shell
# job control options
setopt no_hup # don't kill bg jobs as terminal ends
unsetopt notify # output status of bg'd jobs just before prompt
# prompt options
setopt prompt_subst # allow param expansion, command subst, arith in prompt
# misc
unsetopt beep # never beep please
setopt auto_cd # you can cd by just typing a folder name
setopt vi # vim mode

#Aliases
alias date='date +"~ %I:%M %p on %A, the %eth of %B ~"'
alias ls='ls --color=auto'
alias ll='ls -l --color=auto'
alias la='ls -a --color=auto'
alias althack='telnet nethack.alt.org'
alias grep='grep --color=auto'
alias pacman="sudo pacman-color"
alias ftp="gftp-text"
#alias tram="transmission-remote"
alias top="htop"
alias music="ncmpcpp"
alias fm="pcmanfm . &> ~/.logs/pcman.log &"
#Ubuntu
alias install="sudo aptitude install"
alias search="aptitude search"
alias info="aptitude show"

# make special keys work as expected
bindkey "\e[1~" beginning-of-line
bindkey "\e[2~" quoted-insert
bindkey "\e[3~" delete-char
bindkey "\e[4~" end-of-line
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history
bindkey "\e[7~" beginning-of-line
bindkey "\e[8~" end-of-line
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
bindkey "\eOd" backward-word
bindkey "\eOc" forward-word
bindkey "\e[A" history-search-backward
bindkey "\e[B" history-search-forward

# Variables
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
EDITOR=/usr/bin/vim
VISUAL=/usr/bin/vim

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    local chroot="[$(cat /etc/debian_chroot)]"
fi

#local git='$vcs_info_msg_0_'

PROMPT='$PR_RED$chroot$PR_GREEN%m$PR_WHITE.$PR_BLUE%n$PR_WHITE '
#PROMPT+='$PR_YELLOW$vcs_info_msg_0_'
PROMPT+='$PR_MAGENTA%c$PR_WHITE:$PR_NO_COLOUR '

RPROMPT='%(?..%?)'


# Modified cd/ls functions
TODO_OPTIONS="--summary"

function precmd() {
	#Change Title to [chroot](branch)name@hostname pwd:
	case $TERM in
	    xterm*|rxvt*)
		print -Pn "\e]0;$chroot $git %n@%m: %~\a"
	        ;;
	esac

	psvar=()
	#vcs_info
}

ls()
{
        devtodo ${TODO_OPTIONS}
        /bin/ls --color=auto "$@"
}

cd()
{
        if builtin cd "$@"; then
		devtodo ${TODO_OPTIONS}
		/bin/ls --color=auto
        fi
}

# Devin's extract
xtr () {
    local ARCHIVE
    local archive
    local unrecognized
    local success
    for ARCHIVE in "$@"; do
        echo -n Extracting "$ARCHIVE"... ''
        archive=`echo "$ARCHIVE"|tr A-Z a-z`
        unrecognized=0
        success=0
        case "$archive" in
            *.tar)
                tar xf "$ARCHIVE" && success=1
                ;;
            *.tar.gz|*.tgz)
                tar xzf "$ARCHIVE" && success=1
                ;;
            *.tar.bz2|*.tbz2)
                tar xjf "$ARCHIVE" && success=1
                ;;
            *.gz)
                gunzip "$ARCHIVE" && success=1
                ;;
            *.bz2)
                bunzip2 "$ARCHIVE" && success=1
                ;;
            *.zip|*.jar|*.pk3|*.pk4)
                unzip -o -qq "$ARCHIVE" && success=1
                ;;
            *.rar)
                unrar e -y -idp -inul "$ARCHIVE" && success=1
                ;;
            *)
                unrecognized=1
                ;;
        esac
        if [ $unrecognized = 1 ]; then
            echo -e '[\e[31;1munrecognized file format\e[0m]'
        elif [ $success = 1 ]; then
            echo -e '[\e[32;1mOK\e[0m]'
        fi
    done
}

#Execute these as a terminal opens
date
devtodo ${TODO_OPTIONS}

