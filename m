From: "TJ Harrell" <systemloc@earthlink.net>
Subject: Re: Add disks to RAID5 array
Date: Thu, 22 Jul 2004 13:59:04 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <002501c47015$93ee5230$0201a8c0@windows>
References: <S266727AbUGVQUG/20040722162006Z+461@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org, robin-lists@robinbowes.com
List-Id: linux-raid.ids

Check out the "raidreconf" utility. It will grow RAID 5 arrays onto new
disks. It will not expand the partitions on the raid, though. For that
you'll need a utility like resize2fs.

----- Original Message ----- 
From: <robin-lists@robinbowes.com>
To: <linux-raid@vger.kernel.org>
Sent: Thursday, July 22, 2004 12:20 PM
Subject: Add disks to RAID5 array


> Hi,
>
> I had intended to build a RAID5 array using 6 x 250GB drives. However, 3
of
> 6 drives have proven to be faulty and have been RMA'd.
>
> I've successfully built the array using the remaining 3 x 250GB drives
> (details below)
>
> Now, when I get the other three disks back, how do I add them to this
array
> and increase the size of the array? Is this possible?
>
> Thanks,
>
> R.
>
>
>
> [root@dude root]# mdadm --detail /dev/md5
> /dev/md5:
>         Version : 00.90.01
>   Creation Time : Thu Jul 22 14:13:50 2004
>      Raid Level : raid5
>      Array Size : 487283200 (464.71 GiB 498.98 GB)
>     Device Size : 243641600 (232.35 GiB 249.49 GB)
>    Raid Devices : 3
>   Total Devices : 3
> Preferred Minor : 5
>     Persistence : Superblock is persistent
>
>     Update Time : Thu Jul 22 17:00:18 2004
>           State : clean
>  Active Devices : 3
> Working Devices : 3
>  Failed Devices : 0
>   Spare Devices : 0
>
>          Layout : left-symmetric
>      Chunk Size : 128K
>
>     Number   Major   Minor   RaidDevice State
>        0       8        2        0      active sync   /dev/sda2
>        1       8       18        1      active sync   /dev/sdb2
>        2       8       34        2      active sync   /dev/sdc2
>            UUID : dde32a88:4b9bf7c1:1a634922:efbac4b0
>          Events : 0.448136
>
> --
> http://robinbowes.com
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


