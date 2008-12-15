From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: Awful Raid10,f2 performance
Date: Mon, 15 Dec 2008 07:33:36 -0600
Message-ID: <cccedfc60812150533p31974f4bye490958dbc974212@mail.gmail.com>
References: <cccedfc60806020711o39ccd321h5e410c963d8bf3b1@mail.gmail.com>
	 <48440953.3040004@wpkg.org>
	 <cccedfc60806020809t73794ce6w539c6b0d247a264f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60806020809t73794ce6w539c6b0d247a264f@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
Cc: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

A follow-up to an earlier post about weird slowness with RAID10,f2 and
3 drives. This morning's "check" operation is proceeding very slowly,
for some reason.

dstat is showing 14-15MB/s worth of read I/O (0 or negligible write
I/O) on each of the 3 drives which comprise the raid10,f2.

According to /proc/mdstat this is the current rate:

      [================>....]  check = 82.9% (381575040/460057152)
finish=60.6min speed=21554K/sec

The sync_speed_min is 40000, sync_speed_max is 200000, and there is no
other I/O on the system to speak of.

blockdev shows:

blockdev --getra /dev/sdb /dev/sdc /dev/sde
256
256
256

I just now tried setting it to 64K (65536) on each device and that did
not seem to make much difference.

As you may recall from earlier posts, these drives are easily capable
of twice or even three times this rate or more even at the inner
tracks (70-80MB/s each on the outer tracks, 35-40MB/s on the inner
tracks).

What might be going on here?

kernel: 2.6.25.18-0.2-default x86_64
mdadm --detail

/dev/md0:
        Version : 0.90
  Creation Time : Fri May 23 23:24:20 2008
     Raid Level : raid10
     Array Size : 460057152 (438.74 GiB 471.10 GB)
  Used Dev Size : 306704768 (292.50 GiB 314.07 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 0
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Mon Dec 15 07:31:11 2008
          State : active, recovering
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : far=2
     Chunk Size : 64K

 Rebuild Status : 84% complete

           UUID : ff4e969d:2f07be4e:8c61e068:8406cdc0
         Events : 0.7676

    Number   Major   Minor   RaidDevice State
       0       8       20        0      active sync   /dev/sdb4
       1       8       68        1      active sync   /dev/sde4
       2       8       36        2      active sync   /dev/sdc4

-- 
Jon
