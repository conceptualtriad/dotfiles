# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
#if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
#fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
#if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
#fi

autoload -Uz compinit promptinit
compinit
promptinit
zstyle ':completion:*' menu select
setopt COMPLETE_ALIASES
setopt appendhistory            # Append to history, don't overwrite
setopt hist_ignore_dups         # Don't save multiple instances of a command when run one after another
setopt inc_append_history       # Write to the history after each command
#setopt menucomplete             # Show completion on first TAB
setopt prompt_subst             # Perform substitutions within the prompt
setopt share_history            # Share the history between multiple shells

zstyle ':completion::complete:*' gain-privileges 1

# This will set the default prompt theme
# prompt fade

# Load .bash_aliases if file exists 
if [ -f /home/darryl/.bash_aliases ]; then
    . /home/darryl/.bash_aliases
fi

#vi mode
bindkey -v

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"      beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"       end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"    overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}" backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"    delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"        up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"      down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"      backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"     forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"    beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"  end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}" reverse-menu-complete

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

#autocomplete for pmbootstrap
autoload bashcompinit
bashcompinit
#eval "$(register-python-argcomplete pmbootstrap)"

[[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search

#bindkey ' vi-backward-kill-word
#bindkey ' ' vi-forward-word
#bindkey ' vi-backward-kill-word
#bindkey '' _history-complete-newer
#bindkey '' _history-complete-older
bindkey '\e[1;3D' vi-backward-kill-word
bindkey '\e[1;3C' vi-forward-word

#bindkey '^?' vi-backward-kill-word

#^[[1;5A    ^[[1;5B
#^[[1;5A    ^[[1;5B

## Use vim keys in tab complete menu:
#bindkey -M menuselect 'h' vi-backward-char
#bindkey -M menuselect 'k' vi-up-line-or-history
#bindkey -M menuselect 'l' vi-forward-char
#bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.bash_history

# Allow switching buffers without saving
set hidden

# Initiate fasd fuzzy search
eval "$(fasd --init auto)"

source /usr/share/autojump/autojump.sh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#777777'
#source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh 2>/dev/null
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

# Load version control information
autoload -Uz vcs_info
precmd() { vcs_info }

# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
# zstyle ':vcs_info:*' unstagedstr ' *'
# zstyle ':vcs_info:*' stagedstr ' +'
zstyle ':vcs_info:*' formats ' %b %u %c'

# Set up the prompt (with git branch name)
PROMPT='%K{green} %n@%m %k%K{#333333}%F{green}%f %(5~|%-2~/…/%3~|%4~) %k%F{#333333}%K{#555555}%f%k%K{#555555} ${vcs_info_msg_0_} %k%F{#555555}%f$prompt_newline%F{#F1E9E5}⮞⮞⮞%f '

# just testing variables
# myVar=$(ls | head -n 1)
# echo $myVar

# some cool unicode characters
# ꧂ ↪ ⎉ ☣ ➯ ⮞ 𝄞 𝄢

#source ~/Programs/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
#[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
