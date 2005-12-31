From: "Tom De Clercq" <tom@tomsworld.be>
Subject: Raid 5 array problem: 2 disks became spare in stead of member.
Date: Sat, 31 Dec 2005 17:45:22 +0100
Message-ID: <004d01c60e29$97f9b410$1b64a8c0@Tomsworld.local>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

First of all the best wishes for 2006.

I am searching for a solution for my raid since last Thursday.  What just 
happened I didn't know for sure, only thing I could see was that my server 
rebooted multiple times and my raid-5 array went offline.

Os debian stable: Linux tigger.tomsworld.local 2.6.11 #5 SMP Sun Jul 24 
23:55:45 CEST 2005 i686 GNU/Linux
Mdadm upgraded to the currently lastest stable version:
root@tigger:/home/tom# mdadm -V
mdadm - v2.2 - 5 December 2005


It is a raid-5 array 3*160 GB ATA disk. (mdadm output on the end of this 
mail)

But now at the moment 2 drives of the array are marked as spare.  I googled 
& searched the archives of this list but nothing seems to resolve the 
problem.


I tried booting with only the disks marked as "Spare", but the array 
wouldn't come up either.
Tried to boot with the 1 disk of the array one other: same result.

I'm trying to force the spare disk into being an array member again.

Could someone of you give me any idea how I could resolve this matter?

Some info:

/etc/raidtab

raiddev /dev/md0
raid-level 5
nr-raid-disks 3
nr-spare-disks 0
persistent-superblock 1
parity-algorithm left-symmetric
chunk-size 32
device /dev/hde1
raid-disk 0
device /dev/hdf1
raid-disk 1
device /dev/hdh1
raid-disk 2


root@tigger:/tmp/mdctl-0.5# mdadm --examine /dev/hde1
/dev/hde1:
Magic : a92b4efc
Version : 00.90.01
UUID : 6644de41:0e38ffb1:e5f77c38:825553ae
Creation Time : Tue May 31 21:24:31 2005
Raid Level : raid5
Raid Devices : 3
Total Devices : 3
Preferred Minor : 0

Update Time : Thu Dec 29 11:33:33 2005
State : clean
Active Devices : 1
Working Devices : 3
Failed Devices : 2
Spare Devices : 2
Checksum : 1ed2c2c5 - correct
Events : 0.75536395

Layout : left-symmetric
Chunk Size : 32K

Number Major Minor RaidDevice State
this 3 33 1 3 spare /dev/hde1

0 0 33 65 0 active sync /dev/hdf1
1 1 0 0 1 faulty removed
2 2 0 0 2 faulty removed
3 3 33 1 3 spare /dev/hde1
4 4 34 65 4 spare /dev/hdh1
root@tigger:/tmp/mdctl-0.5# mdadm --examine /dev/hdf1
/dev/hdf1:
Magic : a92b4efc
Version : 00.90.01
UUID : 6644de41:0e38ffb1:e5f77c38:825553ae
Creation Time : Tue May 31 21:24:31 2005
Raid Level : raid5
Raid Devices : 3
Total Devices : 3
Preferred Minor : 0

Update Time : Thu Dec 29 11:33:33 2005
State : clean
Active Devices : 1
Working Devices : 3
Failed Devices : 2
Spare Devices : 2
Checksum : 1ed2c301 - correct
Events : 0.75536395

Layout : left-symmetric
Chunk Size : 32K

Number Major Minor RaidDevice State
this 0 33 65 0 active sync /dev/hdf1

0 0 33 65 0 active sync /dev/hdf1
1 1 0 0 1 faulty removed
2 2 0 0 2 faulty removed
3 3 33 1 1 spare /dev/hde1
4 4 34 65 2 spare /dev/hdh1
root@tigger:/tmp/mdctl-0.5# mdadm --examine /dev/hdh1
/dev/hdh1:
Magic : a92b4efc
Version : 00.90.01
UUID : 6644de41:0e38ffb1:e5f77c38:825553ae
Creation Time : Tue May 31 21:24:31 2005
Raid Level : raid5
Raid Devices : 3
Total Devices : 3
Preferred Minor : 0

Update Time : Thu Dec 29 11:33:33 2005
State : clean
Active Devices : 1
Working Devices : 3
Failed Devices : 2
Spare Devices : 2
Checksum : 1ed2c308 - correct
Events : 0.75536395

Layout : left-symmetric
Chunk Size : 32K

Number Major Minor RaidDevice State
this 4 34 65 4 spare /dev/hdh1

0 0 33 65 0 active sync /dev/hdf1
1 1 0 0 1 faulty removed
2 2 0 0 2 faulty removed
3 3 33 1 3 spare /dev/hde1
4 4 34 65 4 spare /dev/hdh1
root@tigger:/tmp/mdctl-0.5#
root@tigger:/tmp/mdctl-0.5# mdadm --create /dev/md0 -l5 -n3 /dev/hde1 
/dev/hdf1 /dev/hdh1
mdadm: /dev/hde1 appears to be part of a raid array:
level=5 devices=3 ctime=Tue May 31 21:24:31 2005
mdadm: /dev/hdf1 appears to contain an ext2fs file system
size=320159104K mtime=Thu Dec 29 09:51:49 2005
mdadm: /dev/hdf1 appears to be part of a raid array:
level=5 devices=3 ctime=Tue May 31 21:24:31 2005
mdadm: /dev/hdh1 appears to contain an ext2fs file system
size=341131652K mtime=Mon Dec 20 21:49:29 1971
mdadm: /dev/hdh1 appears to be part of a raid array:
level=5 devices=3 ctime=Tue May 31 21:24:31 2005
Continue creating array? n
mdadm: create aborted.
root@tigger:/tmp/mdctl-0.5#


Thanks a lot in advance. 


