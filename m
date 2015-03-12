From: Paul Boven <boven@jive.nl>
Subject: Raid 5: all devices marked spare, cannot assemble
Date: Thu, 12 Mar 2015 13:21:40 +0100
Message-ID: <550184D4.8060104@jive.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi folks,

I have a rather curious issue with one of our storage machines. The 
machine has 36x 4TB disks (SuperMicro 847 chassis) which are divided 
over 4 dual SAS-HBAs and the on-board SAS. These disks are in RAID5 
configurations, 6 raids of 6 disks each. Recently the machine ran out of 
memory (it has 32GB, and no swapspace as it boots from SATA-DOM) and the 
last entries in the syslog are from the OOM-killer. The machine is 
running Ubuntu 14.04.02 LTS, mdadm 3.2.5-5ubuntu4.1.

After doing a hard reset, the machine booted fine but one of the raids 
needed to resync. Worse, another of the raid5s will not assemble at all. 
All the drives are marked SPARE. Relevant output from /proc/mdstat (one 
working and the broken array):

md14 : active raid5 sdc1[2] sdag1[6] sde1[4] sdi1[3] sdz1[0] sdu1[1]
       19534425600 blocks super 1.2 level 5, 512k chunk, algorithm 2 
[6/6] [UUUUUU]

md15 : inactive sdd1[6](S) sdad1[0](S) sdy1[3](S) sdv1[4](S) sdm1[2](S) 
sdq1[1](S)
       23441313792 blocks super 1.2

Using 'mdadm --examine' on each of the drives from the broken md15, I get:

sdd1: Spare, Events: 0
sdad1: Active device 0, Events 194
sdy1: Active device 3, Events 194
sdv1: Active device 4, Events 194
sdm1: Active device 2, Events 194
sdq1: Active device 1, Events 194

This numbering corresponds to how the raid5 was created when I installed 
the machine:

mdadm --create /dev/md15 -l 5 -n 6 /dev/sdad1 /dev/sdq1 /dev/sdm1 
/dev/sdy1 /dev/sdv1 /dev/sdd1

Possible clues from /var/log/syslog:

md/raid:md13: not clean -- starting background reconstruction
(at 14 seconds uptime).

md15 isn't even mentioned in the boot-time syslog, only once I manually 
try to assemble it did I get these errors:

md: kicking non-fresh sdd1 from array!
md: unbind<sdd1>
md: export_rdev(sdd1)
md/raid:md15: not clean -- starting background reconstruction
md/raid:md15: device sdy1 operational as raid disk 3
md/raid:md15: device sdv1 operational as raid disk 4
md/raid:md15: device sdad1 operational as raid disk 0
md/raid:md15: device sdq1 operational as raid disk 1
md/raid:md15: device sdm1 operational as raid disk 2
md/raid:md15: allocated 0kB
md/raid:md15: cannot start dirty degraded array.
RAID conf printout:
--- level:5 rd:6 wd:5
disk 0, o:1, dev:sdad1
disk 1, o:1, dev:sdq1
disk 2, o:1, dev:sdm1
disk 3, o:1, dev:sdy1
disk 4, o:1, dev:sdv1
md/raid:md15: failed to run raid set.
md: pers->run() failed ...

So the questions I'd like to pose are:

* Why does this raid5 not assemble? Only one drive (sdd) seems to be 
missing (marked spare), although I see no real issues with it and can 
read from it fine. There should still be enough drives to start the array.

# mdadm --assemble /dev/md15 --run

Returns without any error message, but leaves /proc/mdstat unchanged.

* How can the data be recovered, and the machine brought into production 
again

And of course

* What went wrong, and how can we guard against this?

Any insights and help are much appreciated.

Regards, Paul Boven.
-- 
Paul Boven <boven@jive.nl> +31 (0)521-596547
Unix/Linux/Networking specialist
Joint Institute for VLBI in Europe - www.jive.nl
VLBI - It's a fringe science
