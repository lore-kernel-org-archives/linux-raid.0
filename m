From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: an idea for enhancement of raid-1 to do striping
Date: Fri, 16 Jan 2004 18:59:14 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040116175914.GA30548@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

An idea for a RAID 1 like mirror with striping (not implemented yet)

Maybe you can telle me whether the idea is viable oand worth
implementing.

Analyses:

RAID 1 does not give performance enhancements for sequential reads,
while it gives some enhancement when multiple operations are concurrent,
due to its optimizing of head movements. This is because RAID 1 does not allow for striping,
that is that the different disks can read data for a file at the same time.
The problem is especially disk seek times, which with current technology
(2004) is about 8 ms on the most common 7200 RPM IDE disks.
A problem is also latency time, which is the time it takes in average to reach
the right sector once a disk read/write head has been positioned on a track,
this is directly related to the rotation
speed of the disk, for a 7200 RPM disk it is about 4 ms. You can in average get maybe 40 MB/s thruput
for these types of disk, that is per 8 ms 320 KB, or 160 KB per 4 ms is transferred.
So in the time you would need to access a specific sector, (access time
plus latency time) you could have transferred about half a meg of data instead.
The seek and latency times are thus very time consuming, and if you can 
lower them, much is gained. Cylinder track to track seek time can be about 1 ms.

Design: Striping with mirroring:

The idea is here to let reading be simultaneous on the two disks
and with as little seek and latency time as possible.
This would mean sequential reads (and writes) of all sectors on a track,
and minimizing cylinder track to track seek times to the minimum,
which occurs with adjacant tracks.
Buffering in the hardisk may speed up this smoothening the read or write process.

If we alternate the chunks on each of the two disks, we will get a striping effect.
The mirroring of the data can then be done by using the second half of the disks
and alternating the mirror chunks also there. The alternating should then
be swiched so one disk contains all the data of the file system, and
the loss of one of the disks would still leave all the data
available on the other disk.

You can get even improved performance with employing more disks,
and also if one or more of these disk fail, there will be improved
performance anyway, as the remaining disks can do some striping.

Using the first half of the disks as the primary chunks and the
second half of the disks as mirror backup should also improve
performance slightly, especially for reads. Restricting reads to make seeks
over only half of the size of the partitions should improve average seek 
times with a little less than double speed, and using the beginning of the disks where rotation
speeds and thus transfer rates are typically somewhat faster than in the end of the
partition should also do a little to improving performance.

The scheme allows for speeding up disk performance on normal pc
systems by a factor of a little less than 2, using the 2 dma channels on a normal 
IDE controller and relatively cheap standard IDE disks.

The scheme could be called RAID-A to signify that it is almost
a RAID-1 solution.


Chunk layout for two disks:

    disk 1                        disk 2

  --------------              -----------------
  !            !              !               !
  !            !              !               !
  !            !              !               !
  ! chunk 1    !              !   chunk 2     !
  !            !              !               !
  !            !              !               !
  !            !              !               !
  --------------              -----------------
  !            !              !               !
  !            !              !               !
  !            !              !               !
  ! chunk 3    !              !   chunk 4     !
  !            !              !               !
  !            !              !               !
  !            !              !               !
  !            !              !               !
  !            !              !               !
  --------------              -----------------
  !            !              !               !
  !            !              !               !
  !            !              !               !
  !            !              !               !
  ! chunk 5    !              !   chunk 6     !
  !            !              !               !
  !            !              !               !
  !            !              !               !
  --------------              -----------------
  !            !              !               !
  !            !              !               !


..... half the size of the smaller disk.....

  !            !              !               !
  !            !              !               !
  !            !              !               !
  !            !              !               !
  --------------              -----------------
  !            !              !               !
  !            !              !               !
  !            !              !               !
  ! chunk 2    !              !   chunk 1     !
  ! mirror     !              !   mirror      !
  !            !              !               !
  !            !              !               !
  --------------              -----------------
  !            !              !               !
  !            !              !               !
  !            !              !               !
  ! chunk 4    !              !   chunk 3     !
  ! mirror     !              !   mirror      !
  !            !              !               !

Best regards
Keld Simonsen
