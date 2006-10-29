From: Matt Thrailkill <matt@modestolan.com>
Subject: Raid 0 breakage (maybe)
Date: Sat, 28 Oct 2006 22:40:00 -0700
Message-ID: <1162100400.17928.9.camel@stoneburner.xwredwing.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi.

Last night, I upgraded from Ubuntu 6.06 to Ubuntu 6.10.  I have a Linux
sw raid0 running on two drives, just using the raw devices rather than
any partitions on them.  The Ubuntu 6.06 kernel would simply see the
superblocks on boot and start up the array automagically for me.  The
6.10 kernel does not.  I don't know if this is an Ubuntu thing, a Linux
kernel issue (2.6.17 now), or something else.

I try and start my array by hand with mdadm, and I get weird stuff.
Basically, check this out:
root@stoneburner:~# mdadm --assemble /dev/md0 /dev/hde /dev/hdi
mdadm: cannot open device /dev/hde: Device or resource busy
mdadm: /dev/hde has no superblock - assembly aborted

You'd think hde or hdi were busted.  But I can do a `mdadm
-E /dev/hde /dev/hdi` just fine:
root@stoneburner:~# mdadm -E /dev/hde /dev/hdi
/dev/hde:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : dd994e72:2ceb7a88:c43ed7bf:cd2e62fb
  Creation Time : Sun Feb 15 02:57:53 2004
     Raid Level : raid0
    Device Size : 36151808 (34.48 GiB 37.02 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 2

    Update Time : Mon Aug  1 19:55:30 2005
          State : active
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : ca633808 - correct
         Events : 0.247

     Chunk Size : 4K

      Number   Major   Minor   RaidDevice State
this     1      56        0        1      active sync   /dev/hdi

   0     0      33        0        0      active sync   /dev/hde
   1     1      56        0        1      active sync   /dev/hdi
/dev/hdi:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : dd994e72:2ceb7a88:c43ed7bf:cd2e62fb
  Creation Time : Sun Feb 15 02:57:53 2004
     Raid Level : raid0
    Device Size : 36151808 (34.48 GiB 37.02 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 2

    Update Time : Mon Aug  1 19:55:30 2005
          State : active
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : ca6337ef - correct
         Events : 0.247

     Chunk Size : 4K

      Number   Major   Minor   RaidDevice State
this     0      33        0        0      active sync   /dev/hde

   0     0      33        0        0      active sync   /dev/hde
   1     1      56        0        1      active sync   /dev/hdi

It seems like it shouldn't be able to query the superblocks if the
devices are supposedly busy.  Any ideas?  Here is my dmesg also:
http://people.ucsc.edu/~mthrailk/edgy-dmesg

The ide startup is relatively uneventful, but what is strange is that md
starting up is very quiet.  It doesn't load the raid0 module, but if I
load it by hand later, it doesn't make a difference at all with the
above commands.

I await your advice, thanks!
-- 
Matt Thrailkill <matt@modestolan.com>

