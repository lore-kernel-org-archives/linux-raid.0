From: Skip Coombe <skipcoombe@gmail.com>
Subject: Mounting MD raid1 array blocked by "Stale NFS file handle"
Date: Wed, 20 Jun 2012 08:12:49 -0400
Message-ID: <CAO7BsSmJiQb6PCmf+j6RnxVSFpDkK9w2wmimx86PqQxd+kY6Nw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Can't seem to get around error

mount: Stale NFS file handle

details:
Linux xenon 3.0.0-12-generic-pae #20-Ubuntu SMP Fri Oct 7 16:37:17 UTC
2011 i686 i686 i386 GNU/Linux

mdadm - v3.1.4 - 31st August 2010

array appears to be OK:
$ sudo mdadm -D /dev/md1
[sudo] password for skip:
/dev/md1:
Version : 1.2
Creation Time : Thu Dec 29 15:52:40 2011
Raid Level : raid1
Array Size : 488384400 (465.76 GiB 500.11 GB)
Used Dev Size : 488384400 (465.76 GiB 500.11 GB)
Raid Devices : 2
Total Devices : 2
Persistence : Superblock is persistent

Update Time : Fri Jun 15 21:44:19 2012
State : clean
Active Devices : 2
Working Devices : 2
Failed Devices : 0
Spare Devices : 0

Name : xenon:1 (local to host xenon)
UUID : bd87c6e8:0253a174:e97be67c:5470db08
Events : 54

Number Major Minor RaidDevice State
0 8 33 0 active sync /dev/sdc1
1 8 49 1 active sync /dev/sdd1

Components and array appear in blkid:
$ blkid
...
/dev/sdc1: UUID="bd87c6e8-0253-a174-e97b-e67c5470db08"
UUID_SUB="7a254626-be94-dfcf-ea30-cbea9a17bdd8" LABEL="xenon:1"
TYPE="linux_raid_member"
/dev/sdd1: UUID="bd87c6e8-0253-a174-e97b-e67c5470db08"
UUID_SUB="d4d9c1e1-36cb-3f87-9030-ac37525f6046" LABEL="xenon:1"
TYPE="linux_raid_member"
...
LABEL="xenon:0" TYPE="linux_raid_member"
/dev/md1: UUID="dadb7d1c-daa2-4e56-8ef7-2816db397289" TYPE="ext2"
/dev/md1p1: UUID="6b30cdc5-25da-4575-b883-c1966e901b84" TYPE="ext2"

and in /proc/partitions
...
8 32 488386584 sdc
8 33 488385560 sdc1
8 48 488386584 sdd
8 49 488385560 sdd1
...
9 1 488384400 md1
259 0 488383376 md1p1

But mounting by device or UUID results in same error:

$ sudo mount -t ext2 -U dadb7d1c-daa2-4e56-8ef7-2816db397289 /mnt/back
mount: Stale NFS file handle

$ sudo mount -t ext2 /dev/md1 /mnt/back
mount: Stale NFS file handle

I do not have NFS intalled, only ssh and smb.

Any help will be appreciated. Please point out any info I have missed.

Thanks,

Skip

--
Skip Coombe
skip.coombe@gmail.com
