From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Preparation advice?
Date: Sun, 28 Nov 2004 13:00:54 -0500
Message-ID: <200411281800.iASI0xN00332@www.watkins-home.com>
References: <6d5bedd8041128053635740144@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6d5bedd8041128053635740144@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Ewan Grantham' <ewan.grantham@gmail.com>, 'David Greaves' <david@dgreaves.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is normal (IMO) for a 2.4 kernel.
I think it has been fixed in the 2.6 kernel.  But I have never used the
newer kernel, so I can't confirm that.  It may have been a newer version of
mdadm, not the kernel, not sure.

My numbers are much worse!
I have 14 disks and 1 spare.
   Raid Devices : 14
  Total Devices : 13

 Active Devices : 14
Working Devices : 12
 Failed Devices : 1
  Spare Devices : 1

    Number   Major   Minor   RaidDevice State
       0       8       49        0      active sync   /dev/sdd1
       1       8      161        1      active sync   /dev/sdk1
       2       8       65        2      active sync   /dev/sde1
       3       8      177        3      active sync   /dev/sdl1
       4       8       81        4      active sync   /dev/sdf1
       5       8      193        5      active sync   /dev/sdm1
       6       8       97        6      active sync   /dev/sdg1
       7       8      209        7      active sync   /dev/sdn1
       8       8      113        8      active sync   /dev/sdh1
       9       8      225        9      active sync   /dev/sdo1
      10       8      129       10      active sync   /dev/sdi1
      11       8      241       11      active sync   /dev/sdp1
      12       8      145       12      active sync   /dev/sdj1
      13       8       33       13      active sync   /dev/sdc1
      14      65        1       14        /dev/sdq1

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Ewan Grantham
Sent: Sunday, November 28, 2004 8:37 AM
To: David Greaves
Cc: linux-raid@vger.kernel.org
Subject: Re: Preparation advice?

On Sun, 28 Nov 2004 11:04:51 +0000, David Greaves <david@dgreaves.com>
wrote:
> Ewan's running 2.4.27 and may have an inconsistency with mdadm counting
> the number of raid devices.
...
> /dev/md0:
>         Version : 00.90.00
>   Creation Time : Sat Nov 27 07:32:34 2004
>      Raid Level : raid5
>      Array Size : 735334656 (701.27 GiB 752.98 GB)
>     Device Size : 245111552 (233.76 GiB 250.99 GB)
>    Raid Devices : 4
>   Total Devices : 5
> Preferred Minor : 0
>     Persistence : Superblock is persistent
> 
>     Update Time : Sat Nov 27 14:14:24 2004
>           State : dirty
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 1
>   Spare Devices : 0
...
> what does
>  cat /proc/mdstat
> say?

As noted above, I'm getting an "interesting" discrepancy between the 4
devices I specified in my create and the results from mdadm. The
device seems to be working fine after transferring and playing several
files, but I find the "failed devices" bit particularly concerning.
Haven't found any way to get mdadm to tell me which device it thinks
has failed.

As for the command above, I get:
Personalities : [raid5]
read_ahead 1024 sectors
md0 : active raid5 hdd1[3] hdb1[2] sdd1[1] sdc1[0]
      735334656 blocks level 5, 128k chunk, algorithm 2 [4/4] [UUUU]

unused devices: <none>

Which is what I would have expected. Any ideas?
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

