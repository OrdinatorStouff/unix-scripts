#! /bin/bash
# ssh_fprint (Bourne shell script) -- Show all host key fingerprints & ASCII art
# https://raw.githubusercontent.com/unixnut/scripts/master/ssh_fprint
#
# Based on server_ssh_fingerprints v0.2 by Kepi <kepi@igloonet.cz>
#
# MIT License
#
# Print fingerprint matrix for all allowed Host Keys
# with all allowed ciphers and MD5 and SHA-256 algos
#
# Changelog:
#
# 2018-03-11 (0.2):
# - Support for newer versions of OpenSSH
# - Added visual keys for all algos too - only in recent OpenSSH versions
# 2018-04-29 (0.3):
# - Strips DSA key
# - Ensures output format is the same regardless of OpenSSH version
# - Also produces ASCII art for older OpenSSH versions
# - Uses openssl instead of sha256sum and xxd
# - Logic and indenting cleanups
# - Works with gawk (sub() wasn't stripping HostKey prefix from line)
# - Uses default when HostKey not set in sshd_config

# standard sshd config path
SSHD_CONFIG=/etc/ssh/sshd_config

# helper functions
function tablize {
    awk '{printf(" | %-7s | %-7s | %-51s |\n", $1, $2, $3)}'
}
LINE=" +---------+---------+-----------------------------------------------------+"


# Warning: don't use in a pipe, because a pipe runs in a
# subshell and thus would throw away changes to global variables
function parse_fp {
    local algo=$1 n=0 filter line

    if [ "$2" = old ] ; then
        # Older OpenSSH versions don't include the hash algorithm prefix
        filter="s/^\\([^ =]*\\).*/\\1/"
    else
        # Newer OpenSSH versions do include the hash algorithm prefix; remove
        filter="s/^${algo^^}:\\([^ =]*\\).*/\\1/"
    fi

    while read line
    do
        n=$((n + 1))
        if [[ $n -eq 1 ]] ; then
            ALGOS[$algo]=$(echo "$line" | sed "$filter")
        else
            # Alter old versions' ASCII art box to include algorithm
            if [ "$line" = "+-----------------+" ] ; then
                case $algo in
                    md5)    line="+------[MD5]------+" ;;
                    sha256) line="+----[SHA256]-----+" ;;
                esac
            fi

            ASCII[$n]="${ASCII[$n]} ${line}"
        fi
    done
}


# *** MAINLINE ***
# header
echo "$LINE"
echo "Cipher" "Algo" "Fingerprint" | tablize
echo "$LINE"

declare -A ALGOS
declare -a ASCII

# fingerprints
hostkey_files=$(awk '/^HostKey/ { print $2 ".pub" }' $SSHD_CONFIG)
if [ -z "$hostkey_files" ] ; then
    # If HostKey not set in $SSHD_CONFIG, use the default
    hostkey_files='/etc/ssh/ssh_host_rsa_key.pub
/etc/ssh/ssh_host_ecdsa_key.pub
/etc/ssh/ssh_host_ed25519_key.pub'
fi
# (Fake piping into while loop by using a redirect, because a pipe runs in a
# subshell and thus would throw away changes to global variables)
while read -r host_key
do
    cipher=$(echo "$host_key" |
               sed -r 's/^.*ssh_host_([^_]+)_key\.pub$/\1/' |
               tr 'a-z' 'A-Z')
    if [ "$cipher" = DSA ] ; then
        continue
    fi

    if [[ -f "$host_key" ]] ; then
        if ssh-keygen -E md5 -l -f "$host_key" &>/dev/null
        then
            for algo in md5 sha256 ; do
                parse_fp $algo < <(ssh-keygen -E $algo -lv -f "$host_key" |
                                       sed '/^[0-9]/ s/^[^ ]* \([^ ]*\).*/\1/')
            done
        else
            parse_fp md5 old < <(ssh-keygen -lv -f "$host_key" |
                                     sed '/^[0-9]/ s/^[^ ]* \([^ ]*\).*/\1/')
            # Note: no ASCII art
            # TO-DO: Use https://github.com/atoponce/keyart Python script
            parse_fp sha256 old < <(cut -f2 -d' ' "$host_key" |
                                        base64 -d |
                                        openssl dgst -sha256 -binary |
                                        base64)
        fi

        echo "$cipher" MD5 "${ALGOS[md5]}" | tablize
        echo "$cipher" SHA-256 "${ALGOS[sha256]}" | tablize
        echo "$LINE"
    fi
done < <(echo "$hostkey_files")

echo
for line in "${ASCII[@]}"; do
    echo "$line"
done


# vim: set tabstop=4 shiftwidth=4 :
# Local Variables:
# tab-width: 4
# end:

