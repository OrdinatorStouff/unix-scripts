#! /bin/bash
# harden sshd script

# current timestamp variable
TS=$(date +%Y%m%dT%H%M%S)

# generate new host keys and ONLY RSA-4096 and ed25519
rm -f /etc/ssh/ssh_host_*
ssh-keygen -t rsa -b 4096 -o -a 100 -f /etc/ssh/ssh_host_rsa_key -q -N ""
ssh-keygen -t ed25519 -a 100 -f /etc/ssh/ssh_host_ed25519_key -q -N ""

# remove weak DH primes from moduli
mv /etc/ssh/moduli "/etc/ssh/moduli.backup.$TS"
awk '$5 >= 3071' "/etc/ssh/moduli.backup.$TS" > /etc/ssh/moduli

# generate new moduli and add to base file
ssh-keygen -G "/etc/ssh/moduli_new_3071.${TS}" -b 3071
ssh-keygen -T /etc/ssh/moduli -f "/etc/ssh/moduli_new_3071.$TS"
