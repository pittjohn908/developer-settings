if [ -r "$HOME/.bash_aliases" ]; then
    source "$HOME/.bash_aliases"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="eastwood"

HIST_STAMPS="yyyy-mm-dd"
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000

HISTORY_IGNORE="(ls|cd|pwd|exit|cd)*"

setopt EXTENDED_HISTORY      # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY    # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY         # Share history between all sessions.
setopt HIST_IGNORE_DUPS      # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS  # Delete an old recorded event if a new event is a duplicate.
setopt HIST_IGNORE_SPACE     # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS     # Do not write a duplicate event to the history file.
setopt HIST_VERIFY           # Do not execute immediately upon history expansion.
setopt APPEND_HISTORY        # append to history file (Default)
setopt HIST_NO_STORE         # Don't store history commands
setopt HIST_REDUCE_BLANKS    # Remove superfluous blanks from each command line being added to the history.

export FZF_DEFAULT_COMMAND='ag --hidden -g ""'
plugins=(
    brew 
    git 
    gcloud 
    fzf 
    zsh-syntax-highlighting 
    zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh
fpath+=("$(brew --prefix)/share/zsh/site-functions")
eval "$(fzf --zsh)"

# User Functions

cdl() {
    cd "$1" && ls
}

mkcd() {
    mkdir -p "$1" && cd "$1"
}

extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar x $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}


prettyjson() {
    if ! command -v python3 &> /dev/null || ! command -v pygmentize &> /dev/null; then
        echo "Error: This function requires Python 3 and Pygments. Please install them."
        return 1
    fi

    if [ -t 0 ]; then  # Data from a file or argument
        if [ $# -eq 0 ]; then
            echo "Usage: prettyjson <file>"
            return 1
        elif [ ! -f "$1" ]; then
            echo "Error: File not found: $1"
            return 1
        fi
        python3 -m json.tool "$1" | pygmentize -l json
    else  # Data from standard input
        python3 -m json.tool | pygmentize -l json
    fi
}

prettyjson_clipboard() {
    if ! command -v python3 &> /dev/null || ! command -v pygmentize &> /dev/null; then
        echo "Error: This function requires Python 3 and Pygments. Please install them."
        return 1
    fi

    pbpaste | python3 -m json.tool | pygmentize -l json
}
