From: CoolCold <coolthecold@gmail.com>
Subject: XFS on top RAID10 with odd drives count and 2 near copies
Date: Fri, 10 Feb 2012 19:17:01 +0400
Message-ID: <CAGqmV7o7AQFY1K-1JLDk02Cv6GpAUQFjiSdM2Wbdbu6Zh_t0Wg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I've got server with 7 SATA drives ( Hetzner's XS13 to be precise )
and created mdadm's raid10 with two near copies, then put LVM on it.
Now I'm planning to create xfs filesystem, but a bit confused about
stripe width/stripe unit values.

As drives count is 7 and copies count is 2, so simple calculation
gives me datadrives count "3.5" which looks ugly. If I understand the
whole idea of sunit/swidth right, it should fill (or buffer) the full
stripe (sunit * data disks) and then do write, so optimization takes
place and all disks will work at once.

My imagination draws such data distribution:

A1 A1 A2 A2 A3 A3 A4
A4 A5 A5 A6 A6 A7 A7
A8 A8 A9 A9 A10 A10 A11
A11 ...

So, there are two optimal variants to do writes:
a) 4 chunks write to affect 7 drives (one drive will be affected twice)
b) 7 chunks write to affect 7 drives (every drive will be affected
twice, but may be caching/merging will take place somehow)

My read load going be near random read ( sending pictures over http )
and looks like it doesn't matter how it will be set with sunit/swidth.

My current raid setup is:
    root@datastor1:~# cat /proc/mdstat
    Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
    md3 : active raid10 sdg5[6] sdf5[5] sde5[4] sdd5[3] sdc5[2] sdb5[1] sda5[0]
          10106943808 blocks super 1.2 64K chunks 2 near-copies [7/7] [UUUUUUU]
          [>....................]  resync =  0.8%
(81543680/10106943808) finish=886.0min speed=188570K/sec
          bitmap: 76/76 pages [304KB], 65536KB chunk



Almost default mkfs.xfs creating options produced:

    root@datastor1:~# mkfs.xfs -l lazy-count=1 /dev/data/db -f
    meta-data=/dev/data/db       isize=256    agcount=32, agsize=16777216 blks
             =                       sectsz=512   attr=2, projid32bit=0
    data     =                       bsize=4096   blocks=536870912, imaxpct=5
             =                       sunit=16     swidth=112 blks
    naming   =version 2              bsize=4096   ascii-ci=0
    log      =internal log           bsize=4096   blocks=262144, version=2
             =                       sectsz=512   sunit=16 blks, lazy-count=1
    realtime =none                   extsz=4096   blocks=0, rtextents=0


As I can see, it is created 112/16 = 7 chunks swidth, which correlate
with my version b) , and I guess I will leave it this way.

So, I'll be glad if anyone can review my thoughts and share yours.


-- 
Best regards,
[COOLCOLD-RIPN]
