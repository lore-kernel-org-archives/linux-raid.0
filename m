From: Steve Cousins <steve.cousins@maine.edu>
Subject: Re: bad performance on RAID 5
Date: Thu, 18 Jan 2007 13:29:25 -0500
Message-ID: <45AFBC85.8020500@maine.edu>
References: <45AE9640.1040500@start.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45AE9640.1040500@start.no>
Sender: linux-raid-owner@vger.kernel.org
To: Sevrin Robstad <quackyo@start.no>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sevrin Robstad wrote:
> I'm suffering from bad performance on my RAID5.
> 
> a "echo check >/sys/block/md0/md/sync_action"
> 
> gives a speed at only about 5000K/sec , and HIGH load average :

What do you get when you try something like:

time dd if=/dev/zero of=/mount-point/test.dat bs=1024k count=1024

where /mount-point is where /dev/md0 is mounted.

This will create a 1 GiB file and it will tell you how long it takes to 
create it.  Also, I'd try running Bonnie++ on it to see what the 
different performance values are.

I don't know a lot about the md sync process but I remember having my 
sync action stuck at a low value at one point and it didn't have 
anything to do with the performance of the RAID array in general.

Steve

> # uptime
> 20:03:55 up 8 days, 19:55,  1 user,  load average: 11.70, 4.04, 1.52
> 
> kernel is 2.6.18.1.2257.fc5
> mdadm is v2.5.5
> 
> the system consist of an athlon XP1,2GHz and two Sil3114 4port S-ATA PCI 
> cards with a total of 6  250gb S-ATA drives connected.
> 
> [root@compaq ~]# mdadm --detail /dev/md0
> /dev/md0:
>        Version : 00.90.03
>  Creation Time : Tue Dec  5 00:33:01 2006
>     Raid Level : raid5
>     Array Size : 1218931200 (1162.46 GiB 1248.19 GB)
>    Device Size : 243786240 (232.49 GiB 249.64 GB)
>   Raid Devices : 6
>  Total Devices : 6
> Preferred Minor : 0
>    Persistence : Superblock is persistent
> 
>    Update Time : Wed Jan 17 23:14:39 2007
>          State : clean
> Active Devices : 6
> Working Devices : 6
> Failed Devices : 0
>  Spare Devices : 0
> 
>         Layout : left-symmetric
>     Chunk Size : 256K
> 
>           UUID : 27dce477:6f45d11b:77377d08:732fa0e6
>         Events : 0.58
> 
>    Number   Major   Minor   RaidDevice State
>       0       8        1        0      active sync   /dev/sda1
>       1       8       17        1      active sync   /dev/sdb1
>       2       8       33        2      active sync   /dev/sdc1
>       3       8       49        3      active sync   /dev/sdd1
>       4       8       65        4      active sync   /dev/sde1
>       5       8       81        5      active sync   /dev/sdf1
> [root@compaq ~]#
> 
> 
> Sevrin
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
______________________________________________________________________
  Steve Cousins, Ocean Modeling Group    Email: cousins@umit.maine.edu
  Marine Sciences, 452 Aubert Hall       http://rocky.umeoce.maine.edu
  Univ. of Maine, Orono, ME 04469        Phone: (207) 581-4302


