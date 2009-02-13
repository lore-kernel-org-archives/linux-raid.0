From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: very bad performance: md raid6 / 2.6.27.7
Date: Fri, 13 Feb 2009 11:12:05 -0600
Message-ID: <cccedfc60902130912g32c38602pd098bfa96aee7148@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I recently built a 4-disk raid6 to replace a 3-disk raid10,f2.  3 of
the 4 disks are from the raid10,f2.
I have a conundrum: read performance from the raid6 is occasionally
really, really awful, and highly variable. How slow? Sometimes as low
as 10MB/s (that reads as *ten* megabytes-per-second) but never more
than 140MB/s. On the average it's more like 50-60MB/s.

So I use the most handy-dandy tool, strace.  Strace shows me something
that explains why it's slow, but does not highlight the underlying
cause:

read(2) of 4MB takes an eyeball *average* of 0.12s, but I see that
some take quite a bit longer.
Here are the first 9 reads of the device:

11:03:37.195358 read(0, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
4194304) = 4194304 <0.069695>
11:03:37.265381 read(0, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
4194304) = 4194304 <0.024970>
11:03:37.290659 read(0, "\300;9\230\0\0\0\2\0\37\224M\0\0\0\0"...,
4194304) = 4194304 <0.027476>
11:03:37.318446 read(0, "\300;9\230\0\0\0\1\0\37\225\24\0000]\20"...,
4194304) = 4194304 <0.027327>
11:03:37.346074 read(0,
"\n\10\337\0\v\223\7S\371\3\350\v\10\337\0\v"..., 4194304) = 4194304
<0.028539>
11:03:37.374921 read(0,
"\r\1\244\0\224\1\222\0\17\330\17\306\17\260\17\214"..., 4194304) =
4194304 <0.025713>
11:03:37.400935 read(0,
"\377\377\377\377\377\377\377\377\2V\371\277\337\377\377\347"...,
4194304) = 4194304 <0.041939>
11:03:37.443170 read(0, "\201\2\0\0\202\2\0\0\203\2\0\0\0\0\365?"...,
4194304) = 4194304 <0.201095>
11:03:37.645672 read(0, "\201\2\0\0\202\2\0\0\203\2\0\0\0\0\365?"...,
4194304) = 4194304 <1.171630>

The system is otherwise bored - ambient I/O probably averages less than 150K/s.

When I use dstat to show what the underlying disks are doing, they are
getting (all 4 of them) 12-30 MB/s reads (again, clearly clustered
around the lower-end of 12-15 MB/s).

What might be going on here?

Details:

/dev/md0:
        Version : 1.01
  Creation Time : Mon Feb  9 20:56:40 2009
     Raid Level : raid6
     Array Size : 613409536 (584.99 GiB 628.13 GB)
  Used Dev Size : 613409536 (584.99 GiB 628.13 GB)
   Raid Devices : 4
  Total Devices : 4
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Fri Feb 13 11:11:50 2009
          State : active
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 64K

           Name : turnip:0  (local to host turnip)
           UUID : 7c88c253:bc904b7f:bda87b47:9c46cebe
         Events : 2416

    Number   Major   Minor   RaidDevice State
       0       8       20        0      active sync   /dev/sdb4
       1       8       36        1      active sync   /dev/sdc4
       4       8       68        2      active sync   /dev/sde4
       5       8       52        3      active sync   /dev/sdd4


-- 
Jon
