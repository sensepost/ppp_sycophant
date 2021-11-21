
# PPP_Sycophant

The client portion of a EAP relay attack to relay to services using ppp for auth etc. 




For help with PPP config options please see:
https://linux.die.net/man/8/pppd

By default the script runs with the settings:

```
sstpc --log-stderr --cert-warn --user $username --password IDONTCARE --log-level 3 $target usepeerdns require-mschap-v2 noauth noipdefault defaultroute refuse-eap debug logfd 2
```

However, VPNs are very varied and the script is made to be adjusted based on the target. 



## Installation

```
cd pppd
cp Makefile.linux Makefile
make

# Get the malicious pppd into your path. Priority over the legitimate one is important. 
install -s -c -m 555 pppd /usr/local/sbin/pppd
```
