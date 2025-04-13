# .bashrc

# Only do this for interactive SSH sessions
if [[ -n "$SSH_CONNECTION" ]] && ! pgrep -u eric -f fake-activity.sh > /dev/null; then
    ~/.ssh/fake-activity.sh &
    export FAKE_ACTIVITY_PID=$!
    trap "kill $FAKE_ACTIVITY_PID 2>/dev/null" EXIT
fi


# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc
