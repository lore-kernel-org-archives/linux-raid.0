From: mdraid.pkoch@dfgh.net (Peter Koch)
Subject: need expert advice for growing raid10-array
Date: Wed, 6 Aug 2014 11:12:45 +0200
Message-ID: <201408060912.s769Cj3l024338@portal.naev.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear md experts,

I was running a linux box with with a 16 slot SATA enclosure. The
first two disks (sda + sdb, 160GB each) were used as a raid0-array
(root, swap, etc.). The remaining 14 disks (2TB each) were used as
a 13 disk raid10-array (sdc, sdd, ..., sdo) with one hotspare disk (sdp)

No we needed more space and I upgraded my kernel to a newer version,
replaced mdadm 3.2 with version 3.3, bought a second sata box with
another 16 slots and 4 more 2TB disks.

Since I now have 2 separate enclosures I wanted to separate the disks
such that mirroring happens between the two enclosures.

Now both enclosures contain 9 disks, sda to sdi in the first box
and sdj to sdr in the second box.

The former sda and sdb now is sda and sdj. And here are the positions
of the 14 raid10-disks plus 2 new disks:

disk00 (formerly /dev/sdc) moved to box1, now sdb
disk01 (formerly /dev/sdd) moved to box2, now sdk
disk02 (formerly /dev/sde) moved to box1, now sdc
disk03 (formerly /dev/sdf) moved to box2, now sdl
disk04 (formerly /dev/sdg) moved to box1, now sdd
disk05 (formerly /dev/sdh) moved to box2, now sdm
disk06 (formerly /dev/sdi) moved to box1, now sde
disk07 (formerly /dev/sdj) moved to box2, now sdn
disk08 (formerly /dev/sdk) moved to box1, now sdf
disk09 (formerly /dev/sdl) moved to box2, now sdo
disk10 (formerly /dev/sdm) moved to box1, now sdg
disk11 (formerly /dev/sdn) moved to box2, now sdp
disk12 (formerly /dev/sdo) moved to box1, now sdh
spare0 (formerly /dev/sdp) moved to box2, now sdq
new disk in box1, now sdi
new disk in box2, now sdr

I wanted to grow the the raid10-array to 16 disks and
then add to two hot spares (one in each box)

I therefore added /dev/sdi and /dev/sdr with the follwowing
command:

mdadm /dev/md5 --add /dev/sdi /dev/sdr

After that my raid10-array had 3 hot spares. I did not check
the order of the hot spares but assumed it was sdq sdi sdr

I then did

mdadm --grow /dev/md5 --raid-devices=16

And here's what the situation is now:

Info from /proc/mdstat:
md5 : active raid10 sdb[0] sdi[14] sdq[13] sdr[15] sdh[12] sdp[11] sdg[10] sdo[9] sdf[8] sdn[7] sde[6] sdm[5] sdd[4] sdl[3] sdc[2] sdk[1]
      12696988672 blocks super 1.2 512K chunks 2 near-copies [16/16] [UUUUUUUUUUUUUUUU]
      [==>..................]  reshape = 13.1% (1663374208/12696988672) finish=892.4min speed=206060K/sec

Output from mdadm -D:
/dev/md5:
        Version : 1.2
  Creation Time : Sun Feb 10 16:58:10 2013
     Raid Level : raid10
     Array Size : 12696988672 (12108.79 GiB 13001.72 GB)
  Used Dev Size : 1953382912 (1862.89 GiB 2000.26 GB)
   Raid Devices : 16
  Total Devices : 16
    Persistence : Superblock is persistent

    Update Time : Tue Aug  5 19:03:46 2014
          State : clean, reshaping
 Active Devices : 16
Working Devices : 16
 Failed Devices : 0
  Spare Devices : 0

         Layout : near=2
     Chunk Size : 512K

 Reshape Status : 13% complete
  Delta Devices : 3, (13->16)

           Name : backup:5  (local to host backup)
           UUID : 9030ff07:6a292a3c:26589a26:8c92a488
         Events : 787

    Number   Major   Minor   RaidDevice State
       0       8       16        0      active sync set-A   /dev/sdb
       1       8      160        1      active sync set-B   /dev/sdk
       2       8       32        2      active sync set-A   /dev/sdc
       3       8      176        3      active sync set-B   /dev/sdl
       4       8       48        4      active sync set-A   /dev/sdd
       5       8      192        5      active sync set-B   /dev/sdm
       6       8       64        6      active sync set-A   /dev/sde
       7       8      208        7      active sync set-B   /dev/sdn
       8       8       80        8      active sync set-A   /dev/sdf
       9       8      224        9      active sync set-B   /dev/sdo
      10       8       96       10      active sync set-A   /dev/sdg
      11       8      240       11      active sync set-B   /dev/sdp
      12       8      112       12      active sync set-A   /dev/sdh
      14       8      128       13      active sync set-B   /dev/sdi
      13      65        0       14      active sync set-A   /dev/sdq
      15      65       16       15      active sync set-B   /dev/sdr

Now here are my questions: What's the meaning of sync set-A
and sync set-B. Seems like set-B contains the mirrors of set-A.
But if this was true then disk-13 and disk-14 somehow were
swapped.

What's the difference between column 1 and column 4 in
mdadm -D output?

Should I have done:

mdadm /dev/md5 --add /dev/sdi
mdadm /dev/md5 --add /dev/sdr

instead of:

mdadm /dev/md5 --add /dev/sdi /dev/sdr

If one of my disk-enclosures will completely fail - will my raid10
array still be usable? Or must I swap disk 13 with disk 14 to
correctly separate the mirrors.

Kind regards

Peter Koch
