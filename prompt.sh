get_local_ip() {
    if [ "$(uname -o)" = "GNU/Linux" ]; then
        local_ip="$(ip route get 1 | awk -F'src' '{print $2; exit}')"
        local_ip="${local_ip/uid*}"
        [ -z "$local_ip" ] && local_ip="$(ifconfig -a | awk '/broadcast/ {print $2; exit}')"
        echo ${local_ip}
    else
        # "Mac OS X" | "macOS" | "iPhone OS")
        interface="$(route get 1 | awk -F': ' '/interface/ {printf $2; exit}')"
        local_ip="$(ipconfig getifaddr "$interface")"
        echo $local_ip
    fi
}

exit_val(){
    exit_value=$?
    [ $exit_value -ne 0 ] && echo -e "\e[1;31m$exit_value \e[0m"
}

git_branch(){
    ! which git>/dev/null && return 0
    branch="`git branch 2>/dev/null | grep "^\*" | sed -e "s/^\*\ //"`"
    if [ "${branch}" != "" ];then
        if [ "${branch}" = "(no branch)" ];then
            branch="(`git rev-parse --short HEAD`...)"
        fi
        echo -e " git:(\e[1;35m$branch\e[0m)"
    fi
}

export PS1='$(exit_val)\u@\h \[\033[01;32m\]$(get_local_ip)\[\033[01;36m\] \W\[\033[00m\]$(git_branch) $ '
