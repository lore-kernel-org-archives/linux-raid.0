From: Brian Kelly <bkelly@unidata.ucar.edu>
Subject: Help Please!  mdadm hangs when using nbd or gnbd
Date: Wed, 22 Feb 2006 17:25:24 -0700
Message-ID: <43FD00F4.3080308@unidata.ucar.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hail to the Great Linux RAID Gurus!  I humbly seek any assistance you 
can offer.

I am building a couple of 20 TB logical volumes from six storage nodes 
each offering two 8TB raw storage devices built with Broadcom RAIDCore 
BC4852 SATA cards.  Each storage node (called leadstor1-6) needs to 
publish its two raw devices with iSCSI, nbd or gnbd over a gigabit 
network which the head node (leadstor) combines into a RAID 5 volume 
using mdadm.

My problem is that when using nbd or gnbd the original build of the 
array on the head node quickly halts, as if a deadlock has occurred.  I 
have this problem with RAID 1 and RAID 5 configurations regardless of 
the size of the storage node published devices.  Here's a demonstration 
with two 4 TB drives being mirrored using nbd:

*** Begin Demonstration ***

[root@leadstor nbd-2.8.3]# uname -a
Linux leadstor.unidata.ucar.edu 2.6.15-1.1831_FC4smp #1 SMP Tue Feb 7 
13:51:52 EST 2006 x86_64 x86_64 x86_64 GNU/Linux

 >>> I start by preparing the system for nbd and md devices

[root@leadstor ~]# modprobe nbd
[root@leadstor ~]# cd /dev
[root@leadstor dev]# ./MAKEDEV nb
[root@leadstor dev]# ./MAKEDEV md

 >>> I then mount two 4TB volumes from leadstor5 and leadstor6

[root@leadstor dev]# cd /opt/nbd-2.8.3
[root@leadstor nbd-2.8.3]# ./nbd-client leadstor5 2002 /dev/nb5
Negotiation: ..size = 3899484160KB
bs=1024, sz=3899484160
[root@leadstor nbd-2.8.3]# ./nbd-client leadstor6 2002 /dev/nb6
Negotiation: ..size = 3899484160KB
bs=1024, sz=3899484160

 >>> I confirm the volumes are mounted properly

[root@leadstor nbd-2.8.3]# fdisk -l /dev/nb5

Disk /dev/nb5: 3993.0 GB, 3993071779840 bytes
255 heads, 63 sectors/track, 485463 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

Disk /dev/nb5 doesn't contain a valid partition table
[root@leadstor nbd-2.8.3]# fdisk -l /dev/nb6

Disk /dev/nb6: 3993.0 GB, 3993071779840 bytes
255 heads, 63 sectors/track, 485463 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

Disk /dev/nb6 doesn't contain a valid partition table

 >>> I prepare the drives to be used in mdadm

[root@leadstor nbd-2.8.3]# mdadm -V
mdadm - v1.12.0 - 14 June 2005
[root@leadstor nbd-2.8.3]# mdadm --zero-superblock /dev/nb5
[root@leadstor nbd-2.8.3]# mdadm --zero-superblock /dev/nb6

 >>> I create a device to mirror the two volumes

[root@leadstor nbd-2.8.3]# mdadm --create /dev/md2 -l 1 -n 2 /dev/nb5 
/dev/nb6
mdadm: array /dev/md2 started.

 >>> And watch the progress in /proc/mdstat

[root@leadstor nbd-2.8.3]# date
Wed Feb 22 16:18:55 MST 2006
[root@leadstor nbd-2.8.3]# cat /proc/mdstat
Personalities : [raid1]
md2 : active raid1 nbd6[1] nbd5[0]
      3899484096 blocks [2/2] [UU]
      [>....................]  resync =  0.0% (1408/3899484096) 
finish=389948.2min speed=156K/sec

md1 : active raid1 sdb3[1] sda3[0]
      78188288 blocks [2/2] [UU]

md0 : active raid1 sdb1[1] sda1[0]
      128384 blocks [2/2] [UU]

unused devices: <none>

 >>> But no more has been done a minute later

[root@leadstor nbd-2.8.3]# date
Wed Feb 22 16:19:49 MST 2006
[root@leadstor nbd-2.8.3]# cat /proc/mdstat
Personalities : [raid1]
md2 : active raid1 nbd6[1] nbd5[0]
      3899484096 blocks [2/2] [UU]
      [>....................]  resync =  0.0% (1408/3899484096) 
finish=2599655.1min speed=23K/sec

md1 : active raid1 sdb3[1] sda3[0]
      78188288 blocks [2/2] [UU]

md0 : active raid1 sdb1[1] sda1[0]
      128384 blocks [2/2] [UU]

unused devices: <none>

 >>> And later still, no more of the resync has been done

[root@leadstor nbd-2.8.3]# date
Wed Feb 22 16:20:38 MST 2006
[root@leadstor nbd-2.8.3]# cat /proc/mdstat
Personalities : [raid1]
md2 : active raid1 nbd6[1] nbd5[0]
      3899484096 blocks [2/2] [UU]
      [>....................]  resync =  0.0% (1408/3899484096) 
finish=4679379.2min speed=13K/sec

md1 : active raid1 sdb3[1] sda3[0]
      78188288 blocks [2/2] [UU]

md0 : active raid1 sdb1[1] sda1[0]
      128384 blocks [2/2] [UU]

unused devices: <none>

 >>> At this point, the resync is stuck and the system is idle.  I have 
left it overnight, but it progresses no further.  100% of the time this 
test will stop at 1408 on the rebuild.  With other configurations, the 
number will change (for example, it was 1280 for a 6 column RAID 5), but 
always halt at the same spot.

 >>> Nothing is logged in the system files

[root@leadstor nbd-2.8.3]# tail -15 /var/log/messages
Feb 22 15:48:35 leadstor kernel: parport: PnPBIOS parport detected.
Feb 22 15:48:35 leadstor kernel: parport0: PC-style at 0x378, irq 7 [PCSPP]
Feb 22 15:48:35 leadstor kernel: lp0: using parport0 (interrupt-driven).
Feb 22 15:48:35 leadstor kernel: lp0: console ready
Feb 22 15:48:37 leadstor fstab-sync[2585]: removed all generated mount 
points
Feb 22 16:01:00 leadstor sshd(pam_unix)[3000]: session opened for user 
root by root(uid=0)
Feb 22 16:06:10 leadstor kernel: nbd: registered device at major 43
Feb 22 16:07:43 leadstor sshd(pam_unix)[3199]: session opened for user 
root by root(uid=0)
Feb 22 16:18:51 leadstor kernel: md: bind<nbd5>
Feb 22 16:18:51 leadstor kernel: md: bind<nbd6>
Feb 22 16:18:51 leadstor kernel: raid1: raid set md2 active with 2 out 
of 2 mirrors
Feb 22 16:18:51 leadstor kernel: md: syncing RAID array md2
Feb 22 16:18:51 leadstor kernel: md: minimum _guaranteed_ reconstruction 
speed: 1000 KB/sec/disc.
Feb 22 16:18:51 leadstor kernel: md: using maximum available idle IO 
bandwidth (but not more than 200000 KB/sec) for reconstruction.
Feb 22 16:18:51 leadstor kernel: md: using 128k window, over a total of 
3899484096 blocks.

 >>> And one last check of the rebuild

[root@leadstor nbd-2.8.3]# date
Wed Feb 22 16:33:50 MST 2006
[root@leadstor nbd-2.8.3]# cat /proc/mdstat
Personalities : [raid1]
md2 : active raid1 nbd6[1] nbd5[0]
      3899484096 blocks [2/2] [UU]
      [>....................]  resync =  0.0% (1408/3899484096) 
finish=38994826.8min speed=1K/sec

md1 : active raid1 sdb3[1] sda3[0]
      78188288 blocks [2/2] [UU]

md0 : active raid1 sdb1[1] sda1[0]
      128384 blocks [2/2] [UU]

unused devices: <none>

 >>> Now if I try to abort the build, the command also hangs

[root@leadstor nbd-2.8.3]# mdadm --misc --stop /dev/md2
* never returns*

 >>> But I can connect with another shell and poke around

Last login: Wed Feb 22 16:07:43 2006 from robin.unidata.ucar.edu
[root@leadstor ~]# ps -eaf | grep md
root       578     9  0 15:48 ?        00:00:00 [md1_raid1]
root       579     9  0 15:48 ?        00:00:00 [md0_raid1]
root      2181     1  0 15:48 ?        00:00:00 mdadm --monitor --scan 
-f --pid-file=/var/run/mdadm/mdadm.pid
root      2258     1  0 15:48 ?        00:00:00 [krfcommd]
root      3298     9  0 16:18 ?        00:00:00 [md2_raid1]
root      3299     9  0 16:18 ?        00:00:00 [md2_resync]
root      3384  3049  0 16:35 pts/1    00:00:00 mdadm --misc --stop /dev/md2
root      3426  3399  0 16:37 pts/2    00:00:00 grep md

 >>> But all the md2 processes are wedged and can not be killed

[root@leadstor ~]# kill -9 3298 3299 3384
[root@leadstor ~]# ps -eaf | grep md
root       578     9  0 15:48 ?        00:00:00 [md1_raid1]
root       579     9  0 15:48 ?        00:00:00 [md0_raid1]
root      2181     1  0 15:48 ?        00:00:00 mdadm --monitor --scan 
-f --pid-file=/var/run/mdadm/mdadm.pid
root      2258     1  0 15:48 ?        00:00:00 [krfcommd]
root      3298     9  0 16:18 ?        00:00:00 [md2_raid1]
root      3299     9  0 16:18 ?        00:00:00 [md2_resync]
root      3384  3049  0 16:35 pts/1    00:00:00 mdadm --misc --stop /dev/md2
root      3431  3399  0 16:38 pts/2    00:00:00 grep md

 >>> So, to get rid of these processes I reboot the system and have to 
power down the box since the shutdown process stops when unloading 
iptables or md

 >>> The head node is running Fedora Core 4 with the latest 2.6.15smp 
kernel since it was mentioned that some deadlock issues were fixed 
there.  It is running two Opteron CPUs at 1600MHz and has 2GB of RAM.  
The storage nodes are FC4 2.6.14 but with a single CPU and 1 GB of RAM.  
All systems are using nbd-2.8.3, but the problem systems are the same 
when using gnbd in Red Hat's GFS cluster software.  The systems 
interconnect with a dedicated gigabit copper network.

*** End Demonstration ***

This problem seems to exist on both single and multi-threaded kernels.  
When I repeat the procedure, but on one of the uni-processor systems, 
the resync gets further but still hangs.  Here's where it hung on leadstor1:

[root@leadstor1 nbd-2.8.3]# uname -a
Linux leadstor1.unidata.ucar.edu 2.6.14-1.1653_FC4 #1 Tue Dec 13 
21:34:16 EST 2005 x86_64 x86_64 x86_64 GNU/Linux
[root@leadstor1 nbd-2.8.3]# cat /proc/mdstat
Personalities : [raid1]
md2 : active raid1 nbd6[1] nbd5[0]
      3899484096 blocks [2/2] [UU]
      [>....................]  resync =  0.0% (1409024/3899484096) 
finish=1936.4min speed=33548K/sec

md1 : active raid1 sdb3[1] sda3[0]
      78188288 blocks [2/2] [UU]

md0 : active raid1 sdb1[1] sda1[0]
      128384 blocks [2/2] [UU]

unused devices: <none>

In addition to nbd and gnbd, I have used iSCSI to mount the storage 
node's volumes.  With iet-0.4.12b and open-iscsi-1.0-485, mdadm worked 
well.  I'm trying other solutions because the head node would always 
crash before getting through a rebuild which I suspect is a problem of 
open-iscsi, the hardware or both.  I was also hoping mdadm would handle 
failures better when using native block devices.

I've spent the last few days trying different combinations to pinpoint 
the problem, but configuration seems to make no difference.  Any FC4 
system trying to RAID 1 or RAID 5 any size nbd volumes from any 
system(s) will hang.  However, and array built without ndb works fine.

So, I would like to get this nbd/mdadm configuration working, but I am 
uncertain where best to look next.  I would think it best to determine 
where this hang is happening, but my code and kernel debugging skills 
are not the best.  Would anyone have suggestions on good tests for me to 
run or where else I should look?

My thanks in advance and my apologies if I'm missing something blatantly 
obvious.

Brian
