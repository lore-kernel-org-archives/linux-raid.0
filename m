From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: bug in mdadm?
Date: Sat, 29 May 2004 11:46:10 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200405291546.i4TFkEB18374@www.watkins-home.com>
References: <c9a50k$it6$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c9a50k$it6$1@sea.gmane.org>
To: 'Mario 'BitKoenig' Holbe' <Mario.Holbe@RZ.TU-Ilmenau.DE>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

No!  It's a bug.  It's been reported here before.  I have a RAID5 with 14
disks and 1 spare.  It reports Raid devices 14, Total 13, Active 14, working
12, failed 1 and spare 1.  I should have data loss!  But nothing is wrong,
see below.

Guy

# mdadm -D /dev/md2
/dev/md2:
        Version : 00.90.00
  Creation Time : Fri Dec 12 17:29:50 2003
     Raid Level : raid5
     Array Size : 230980672 (220.28 GiB 236.57 GB)
    Device Size : 17767744 (16.94 GiB 18.24 GB)
   Raid Devices : 14
  Total Devices : 13
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Mon Mar  1 20:32:41 2004
          State : dirty, no-errors
 Active Devices : 14
Working Devices : 12
 Failed Devices : 1
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 64K

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
      13      65        1       13      active sync   /dev/sdq1
      14       8       33       14        /dev/sdc1
           UUID : 8357a389:8853c2d1:f160d155:6b4e1b99

# cat /proc/mdstat
Personalities : [raid0] [raid1] [raid5]
read_ahead 1024 sectors
md2 : active raid5 sdc1[14] sdq1[13] sdj1[12] sdp1[11] sdi1[10] sdo1[9]
sdh1[8] sdn1[7] sdg1[6] sdm1[5] sdf1[4] sdl1[3] sde1[2] sdk1[1] sdd1[0]
      230980672 blocks level 5, 64k chunk, algorithm 2 [14/14]
[UUUUUUUUUUUUUU]

md0 : active raid1 sdb1[1] sda1[0]
      264960 blocks [2/2] [UU]

md1 : active raid1 sdb2[1] sda2[0]
      17510784 blocks [2/2] [UU]

unused devices: <none>


-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Mario 'BitKoenig'
Holbe
Sent: Saturday, May 29, 2004 10:00 AM
To: linux-raid@vger.kernel.org
Subject: Re: bug in mdadm?

Bernd Schubert <Bernd.Schubert@tc.pci.uni-heidelberg.de> wrote:
> for one of our raid1 devices 'mdadm -D' reports 3 devices and 1
> failed device, though I'm pretty sure that I specified
> '--raid-devices=2' when I created that raid-array.
[...]
>    Raid Devices : 2

You did.

>   Total Devices : 3

Plus one spare disk.

>  Active Devices : 2
> Working Devices : 2

Two mirrors up and running.

>  Failed Devices : 1
>   Spare Devices : 0

One disk failed or out-of-sync or something like that.

[moved from above]
> One another system, 'mdadm -D' reports the correct numbers.

What do you expect as 'correct'?
Did you move *all* the physical disks of the one
system to the other?
Did you also move your mdadm.conf (if you didn't
move the disk with the root-fs), if there is one?

> The data from /proc/mdstat report the correct numbers.
> Any ideas whats the reason for this? Is it a bug in mdadm or has the
> superblock really wrong data?

Well, perhaps there is any partition somewhere else
on your disks with the same UUID, which gets merged
to md0 as spare disk: Did you remove a mirror from
md0 in the past and add another one?

Another chance could be you are using mdadm's 'spare
groups'. I don't know, what mdadm does show in this
case.


regards,
   Mario
-- 
reich sein heisst nicht, einen Ferrari zu kaufen, sondern einen zu
verbrennen
                                               Dietmar Wischmeier

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


