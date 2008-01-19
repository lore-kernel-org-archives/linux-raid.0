From: "Steve Fairbairn" <steve@fairbairn-family.com>
Subject: mdadm error when trying to replace a failed drive in RAID5 array
Date: Sat, 19 Jan 2008 23:08:43 -0000
Message-ID: <182d01c85af0$3c6d3520$0603a8c0@meanmachine>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="windows-1250"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi All,

Firstly, I must express my thanks to Neil Brown for being willing to
respond to the direct email I sent him as I couldn't for the life of me
find any forums on mdadm or this list...

I have a Software RAID 5 device configured, but one of the drives
failed. I removed the drive with the following command...

mdadm /dev/md0 --remove /dev/hdc1

[root@space ~]# cat /proc/mdstat 
Personalities : [raid6] [raid5] [raid4] 
md1 : active raid5 hdk1[5] hdi1[3] hdh1[2] hdg1[1] hde1[0]
      976590848 blocks level 5, 64k chunk, algorithm 2 [5/4] [UUUU_]
      [====>................]  recovery = 22.1% (54175872/244147712)
finish=3615.3min speed=872K/sec
      
md0 : active raid5 sdd1[4] sdc1[2] sdb1[1] sda1[0]
      1953535744 blocks level 5, 64k chunk, algorithm 2 [5/4] [UUU_U]
      
unused devices: <none>

Please ignore /dev/md1 for now at least.  Now my array (/dev/md0) shows
the following...

[root@space ~]# mdadm -QD /dev/md0
/dev/md0:
Version : 00.90.03
Creation Time : Wed Jan 9 18:57:53 2008
Raid Level : raid5
Array Size : 1953535744 (1863.04 GiB 2000.42 GB)
Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
Raid Devices : 5
Total Devices : 4
Preferred Minor : 0
Persistence : Superblock is persistent

Update Time : Tue Jan 4 04:28:03 2005
State : clean, degraded
Active Devices : 4
Working Devices : 4
Failed Devices : 0
Spare Devices : 0

Layout : left-symmetric
Chunk Size : 64K

UUID : 382c157a:405e0640:c30f9e9e:888a5e63
Events : 0.337650

Number Major Minor RaidDevice State
0 8 1 0 active sync /dev/sda1
1 8 17 1 active sync /dev/sdb1
2 8 33 2 active sync /dev/sdc1
3 0 0 3 removed
4 8 49 4 active sync /dev/sdd1

Now, when I try to insert the replacement drive back in, I get the
following...

[root@space ~]# mdadm /dev/md0 --add /dev/hdc1
mdadm: add new device failed for /dev/hdc1 as 5: Invalid argument

It seems to be that mdadm is trying to add the device as number 5
instead of replacing number 3, but I have no idea why, or how to make it
replace number 3.

--- Neil has explained to me already that the drive should be added as
5, and then switched to 3 after a a rebuild is complete.  Neil aslo
asked me if dmesg showed up anything when I tried adding the drive

[root@space mdadm-2.6.4]# dmesg | tail
...
md: hdc1 has invalid sb, not importing!
md: md_import_device returned -22
md: hdc1 has invalid sb, not importing!
md: md_import_device returned -22

I have updated mdadm to the latest version I can find...

[root@space ~]# mdadm --version
mdadm - v2.6.4 - 19th October 2007

Still get the same error. I'm hoping someone will have some suggestion
as to how to sort this out. Backing up nearly 2TB of data isn't really a
viable option for me, so I'm quite desperate to get the redundancy back.

My linux distribution is a relatively new installation from CentOS 5.1
ISOs.  The Kernel version is 

[root@space ~]# uname -a
Linux space.homenet.com 2.6.18-53.1.4.el5 #1 SMP Fri Nov 30 00:45:55 EST
2007 x86_64 x86_64 x86_64 GNU/Linux

Many Thanks,

Steve.


No virus found in this outgoing message.
Checked by AVG Free Edition. 
Version: 7.5.516 / Virus Database: 269.19.7/1232 - Release Date:
18/01/2008 19:32
 

