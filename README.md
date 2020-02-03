# ademco-honeywell-stuff
Scripts i've written for improving my QOL when dealing with my ademco/honeywell vista 128 security system.
They're rather specific to my needs, but maybe they'll help you out too.


## Scripts
### translateLog.sh
I created a logging setup that stores the messages output from the serial port on the panel with a timestamp. 
(I used a python script called `grabserial` to do this.

but these are rather cryptic, so I wrote a bash  script to translate these message into a more human readable format.

### etc/init.d/ademcoLog
simple script to log the messages from the panel

Example log:
```
[20-02-02 19:25:06 0.002266] 1BnqF6061000113190202200086
[20-02-02 19:25:06 0.002265] 1BnqF5063000113190202200085
[20-02-02 19:25:06 0.002299] 1BnqF5060000113190202200088
[20-02-02 19:25:06 0.002276] 1BnqF6060000113190202200087
[20-02-02 19:25:06 0.002272] 1BnqF6063000113190202200084
[20-02-02 20:49:23 5056.996597] 08XF009A
[20-02-02 20:50:00 37.062337] 08XN0092
[20-02-02 20:50:01 0.498828] 1BnqBD000000149200202200082
[20-02-02 21:29:37 2375.958723] 1BnqF5115000129210202200087
[20-02-02 21:47:24 1067.236811] 1BnqF5052000147210202200087

```

Example output:
```

[20-02-02 19:25:06 0.002266] 1BnqF6061000113190202200086✓ Mode nq F606100011319020220 Event: 20-02-02 19:13 Zn:061 Prt:1 User:000 - Fault Restore
[20-02-02 19:25:06 0.002265] 1BnqF5063000113190202200085✓ Mode nq F506300011319020220 Event: 20-02-02 19:13 Zn:063 Prt:1 User:000 - Faults
[20-02-02 19:25:06 0.002299] 1BnqF5060000113190202200088✓ Mode nq F506000011319020220 Event: 20-02-02 19:13 Zn:060 Prt:1 User:000 - Faults
[20-02-02 19:25:06 0.002276] 1BnqF6060000113190202200087✓ Mode nq F606000011319020220 Event: 20-02-02 19:13 Zn:060 Prt:1 User:000 - Fault Restore
[20-02-02 19:25:06 0.002272] 1BnqF6063000113190202200084✓ Mode nq F606300011319020220 Event: 20-02-02 19:13 Zn:063 Prt:1 User:000 - Fault Restore
[20-02-02 20:49:23 5056.996597] 08XF009A❌Mode XF Communication OFF
[20-02-02 20:50:00 37.062337] 08XN0092✓ Mode XN Communication ON
[20-02-02 20:50:01 0.498828] 1BnqBD000000149200202200082✓ Mode nq BD00000014920020220 Event: 20-02-02 20:49 Zn:000 Prt:1 User:000 - Program Mode Exit
[20-02-02 21:29:37 2375.958723] 1BnqF5115000129210202200087✓ Mode nq F511500012921020220 Event: 20-02-02 21:29 Zn:115 Prt:1 User:000 - Faults
[20-02-02 21:47:24 1067.236811] 1BnqF5052000147210202200087✓ Mode nq F505200014721020220 Event: 20-02-02 21:47 Zn:052 Prt:1 User:000 - Faults

```

## Resources

http://library.ademconet.com/MWT/fs2/0/506.pdf  
This file seems to assume you have a system with < 100 zones/users, but in my experience, 
it seems they just slightly altered the protocol, adding an extra digit where necessary.
