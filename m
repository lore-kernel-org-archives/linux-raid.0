From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: problem changing raid level with Ubuntu 10.04 / 2.6.32 / mdadm
 3.1.1
Date: Wed, 3 Feb 2010 20:05:13 +0100 (CET)
Message-ID: <alpine.DEB.1.10.1002031944020.31777@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I tested to go from raid5 to raid6 and grow it at the same time as per an 
article I read that Niel Brown wrote, but I'm having trouble.

Am I missing something?

root@swmike-test:~/mdadm-3.1.1# uname -a
Linux swmike-test 2.6.32-12-generic #16-Ubuntu SMP Wed Jan 27 18:34:19 UTC 2010 i686 GNU/Linux

root@swmike-test:~/mdadm-3.1.1# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
[raid4] [raid10]
md0 : active raid5 sdg[5](S) sdf[4](S) sde[3] sdc[1] sdb2[0]
       4208896 blocks super 1.2 level 5, 64k chunk, algorithm 2 [3/3] [UUU]
       bitmap: 0/9 pages [0KB], 128KB chunk

root@swmike-test:~/mdadm-3.1.1# ./mdadm --grow /dev/md0 --level=6 --raid-disks=5
mdadm level of /dev/md0 changed to raid6
mdadm: Need to backup 384K of critical section..
mdadm: Cannot set device shape for /dev/md0
mdadm: aborting level change

[ 7172.535609] raid5: device sde operational as raid disk 2
[ 7172.535613] raid5: device sdc operational as raid disk 1
[ 7172.535615] raid5: device sdb2 operational as raid disk 0
[ 7172.535965] raid5: allocated 4222kB for md0
[ 7172.557813] 2: w=1 pa=0 pr=4 m=2 a=18 r=4 op1=0 op2=0
[ 7172.557817] 1: w=2 pa=0 pr=4 m=2 a=18 r=4 op1=0 op2=0
[ 7172.557819] 0: w=3 pa=0 pr=4 m=2 a=18 r=4 op1=0 op2=0
[ 7172.557822] raid5: raid level 6 set md0 active with 3 out of 4 devices, algorithm 18
[ 7172.557825] RAID5 conf printout:
[ 7172.557826]  --- rd:4 wd:3
[ 7172.557829]  disk 0, o:1, dev:sdb2
[ 7172.557831]  disk 1, o:1, dev:sdc
[ 7172.557832]  disk 2, o:1, dev:sde
[ 7173.066112] raid5: device sde operational as raid disk 2
[ 7173.066115] raid5: device sdc operational as raid disk 1
[ 7173.066118] raid5: device sdb2 operational as raid disk 0
[ 7173.066424] raid5: allocated 3179kB for md0
[ 7173.101841] 2: w=1 pa=0 pr=3 m=1 a=2 r=3 op1=0 op2=0
[ 7173.101845] 1: w=2 pa=0 pr=3 m=1 a=2 r=3 op1=0 op2=0
[ 7173.101847] 0: w=3 pa=0 pr=3 m=1 a=2 r=3 op1=0 op2=0
[ 7173.101850] raid5: raid level 5 set md0 active with 3 out of 3 devices, algorithm 2
[ 7173.101852] RAID5 conf printout:
[ 7173.101853]  --- rd:3 wd:3
[ 7173.101855]  disk 0, o:1, dev:sdb2
[ 7173.101857]  disk 1, o:1, dev:sdc
[ 7173.101859]  disk 2, o:1, dev:sde

root@swmike-test:~/mdadm-3.1.1# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
[raid4] [raid10]
md0 : active raid5 sdg[5](S) sdf[4](S) sde[3] sdc[1] sdb2[0]
       4208896 blocks super 1.2 level 5, 64k chunk, algorithm 2 [3/3] [UUU]
       bitmap: 0/9 pages [0KB], 128KB chunk

So I thought I'd try to just test the level change:

root@swmike-test:~/mdadm-3.1.1# ./mdadm --grow /dev/md0 --level=6 --raid-disks=4 --backup-file=/backup-file
mdadm level of /dev/md0 changed to raid6
mdadm: Cannot set device shape for /dev/md0
mdadm: aborting level change

[ 7554.027702] raid5: device sde operational as raid disk 2
[ 7554.027705] raid5: device sdc operational as raid disk 1
[ 7554.027708] raid5: device sdb2 operational as raid disk 0
[ 7554.028067] raid5: allocated 4222kB for md0
[ 7554.040795] 2: w=1 pa=0 pr=4 m=2 a=18 r=4 op1=0 op2=0
[ 7554.040798] 1: w=2 pa=0 pr=4 m=2 a=18 r=4 op1=0 op2=0
[ 7554.040801] 0: w=3 pa=0 pr=4 m=2 a=18 r=4 op1=0 op2=0
[ 7554.040804] raid5: raid level 6 set md0 active with 3 out of 4 devices, algorithm 18
[ 7554.040806] RAID5 conf printout:
[ 7554.040808]  --- rd:4 wd:3
[ 7554.040810]  disk 0, o:1, dev:sdb2
[ 7554.040812]  disk 1, o:1, dev:sdc
[ 7554.040814]  disk 2, o:1, dev:sde
[ 7555.517552] raid5: device sde operational as raid disk 2
[ 7555.517555] raid5: device sdc operational as raid disk 1
[ 7555.517558] raid5: device sdb2 operational as raid disk 0
[ 7555.517890] raid5: allocated 3179kB for md0
[ 7555.549619] 2: w=1 pa=0 pr=3 m=1 a=2 r=3 op1=0 op2=0
[ 7555.549622] 1: w=2 pa=0 pr=3 m=1 a=2 r=3 op1=0 op2=0
[ 7555.549625] 0: w=3 pa=0 pr=3 m=1 a=2 r=3 op1=0 op2=0
[ 7555.549627] raid5: raid level 5 set md0 active with 3 out of 3 devices, algorithm 2
[ 7555.549629] RAID5 conf printout:
[ 7555.549631]  --- rd:3 wd:3
[ 7555.549633]  disk 0, o:1, dev:sdb2
[ 7555.549635]  disk 1, o:1, dev:sdc
[ 7555.549637]  disk 2, o:1, dev:sde

root@swmike-test:~/mdadm-3.1.1# ./mdadm --grow /dev/md0 --raid-disks=4
mdadm: Need to backup 384K of critical section..
mdadm: Cannot set device shape for /dev/md0: Device or resource busy

[ 7616.412076] md: couldn't update array info. -16

What could cause this? It doesn't work with the one ubuntu is shipping 
either:

root@swmike-test:~# mdadm --version
mdadm - v2.6.7.1 - 15th October 2008
root@swmike-test:~# mdadm --grow /dev/md0 --raid-disks=4
mdadm: Need to backup 384K of critical section..
mdadm: Cannot set device size/shape for /dev/md0: Device or resource busy

[ 7746.764080] md: couldn't update array info. -16

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
