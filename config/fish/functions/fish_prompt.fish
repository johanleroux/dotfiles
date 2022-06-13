## Left Prompt
function fish_prompt
	# Set the annoying greeting to empty
	set fish_greeting
	set -l last_status $status
	
        # Show the current working directory
	set_color normal
	echo -n ' '
	echo -n (prompt_pwd)
	set_color green
	echo -n (git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/')
	set_color normal
	echo -n ' '
end

## Window title
function fish_title
    set -q argv[1]; or set argv fish
    echo (fish_prompt_pwd_dir_length=1 pwd): $argv;
end

## Coloring
set fish_color_autosuggestion brblack
set fish_color_command normal
set fish_color_comment black
set fish_color_cwd blue
set fish_color_cwd_root red
set fish_color_end magenta
set fish_color_error yellow
set fish_color_escape cyan
set fish_color_history_current cyan
set fish_color_host normal
set fish_color_match blue
set fish_color_normal normal
set fish_color_operator cyan
set fish_color_param blue
set fish_color_quote green
set fish_color_redirection blue
set fish_color_search_match --background=black
set fish_color_selection blue
set fish_color_status red
set fish_color_user red
set fish_pager_color_completion blue
set fish_pager_color_description yellow
set fish_pager_color_prefix cyan
set fish_pager_color_progress cyan

## Aliases
alias ls "ls --group-directories-first"
alias lsl "ls --group-directories-first -lh"
alias clone "git clone --depth 1"
alias nah "git reset --hard && git clean -df"
alias branches "git branch | sort -V"

## Keybinding
set fish_key_bindings fish_default_key_bindings
