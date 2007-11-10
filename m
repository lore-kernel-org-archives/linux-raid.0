From: Chris Eddington <chrise@synplicity.com>
Subject: Re: Raid5 assemble after dual sata port failure
Date: Fri, 09 Nov 2007 16:28:58 -0800
Message-ID: <4734FB4A.4070401@synplicity.com>
References: <47321FDF.8060207@synplicity.com> <4732E5F0.7080805@dgreaves.com> <4734CFE5.8070305@synplicity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4734CFE5.8070305@synplicity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Eddington <chrise@synplicity.com>
Cc: David Greaves <david@dgreaves.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi David,

I ran xfs_check and get this:
ERROR: The filesystem has valuable metadata changes in a log which needs to
be replayed.  Mount the filesystem to replay the log, and unmount it before
re-running xfs_check.  If you are unable to mount the filesystem, then use
the xfs_repair -L option to destroy the log and attempt a repair.
Note that destroying the log may cause corruption -- please attempt a mount
of the filesystem before doing this.

After mounting (which fails) and re-running xfs_check it gives the same 
message.

The array info details are below and seems it is running correctly ??  I 
interpret the message above as actually a good sign - seems that 
xfs_check sees the filesystem but the log file and maybe the most 
currently written data is corrupted or will be lost.  But I'd like to 
hear some advice/guidance before doing anything permanent with 
xfs_repair.  I also would like to confirm somehow that the array is in 
the right order, etc.  Appreciate your feedback.

Thks,
Chris



--------------------
cat /etc/mdadm/mdadm.conf
DEVICE /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1
ARRAY /dev/md0 level=raid5 num-devices=4 
UUID=bc74c21c:9655c1c6:ba6cc37a:df870496
MAILADDR root

cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sda1[0] sdd1[2] sdb1[1]
      1465151808 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]
     
unused devices: <none>

mdadm -D /dev/md0
/dev/md0:
        Version : 00.90.03
  Creation Time : Sun Nov  5 14:25:01 2006
     Raid Level : raid5
     Array Size : 1465151808 (1397.28 GiB 1500.32 GB)
    Device Size : 488383936 (465.76 GiB 500.11 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Fri Nov  9 16:26:31 2007
          State : clean, degraded
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : bc74c21c:9655c1c6:ba6cc37a:df870496
         Events : 0.4880384

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       8       49        2      active sync   /dev/sdd1
       3       0        0        3      removed



Chris Eddington wrote:
> Thanks David.
>
> I've had cable/port failures in the past and after re-adding the 
> drive, the order changed - I'm not sure why, but I noticed it sometime 
> ago but don't remember the exact order.
>
> My initial attempt to assemble, it came up with only two drives in the 
> array.  Then I tried assembling with --force and that brought up 3 of 
> the drives.  At that point I thought I was good, so I tried mount 
> /dev/md0 and it failed.  Would that have written to the disk?  I'm 
> using XFS.
>
> After that, I tried assembling with different drive orders on the 
> command line, i.e. mdadm -Av --force /dev/md0 /dev/sda1, ... thinking 
> that the order might not be right.
>
> At the moment I can't access the machine, but I'll try fsck -n and 
> send you the other info later this evening.
>
> Many thanks,
> Chris
>

