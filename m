From: Larkin Lowrey <llowrey@nuclearwinter.com>
Subject: Raid5 device hangs in active state
Date: Sun, 08 Jan 2012 16:03:10 -0600
Message-ID: <4F0A129E.5020706@nuclearwinter.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've been chasing a fault since "upgrading" from Fedora 15 to Fedora 16.
When under heavy IO load my root volume will hang and block any
additional writes. Reading appears to be ok but I can't tell if I'm
reading the actual md device or cache memory. This problem occurs most
often when doing a weekly check of all md devices in the early AM hours
and particularly when the check fires before my backup job completes.
The checks do appear to complete normally, and without error.

There are no error or warning messages in any log or in the console.
There is no indication of any problem except that any IO of the root
volume will hang and ctrl-c does not get me back to a prompt.

Interestingly, to me, when in this state, 'iostat -dx 1' shows the root
LVM volume at 100% utilization yet neither the mv physical volume nor
any of the constituent devices show any activity and all read 0%
utilization. IO wait reads 50% (6 core machine) so it appears that
something is waiting for an event that will never occur.

The md device showed a value of 26 for stripe_cache_active during the
most recent occurrence and that number did not change over time.
Further, mdadm -D /dev/md0 showed the following:

dev/md0:
        Version : 1.2
  Creation Time : Tue Dec 21 16:28:52 2010
     Raid Level : raid5
     Array Size : 2180641792 (2079.62 GiB 2232.98 GB)
  Used Dev Size : 311520256 (297.09 GiB 319.00 GB)
   Raid Devices : 8
  Total Devices : 8
    Persistence : Superblock is persistent

    Update Time : Sun Jan  8 03:31:42 2012
          State : active
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           Name : ****.****.com:1  (local to host ****.****.com)
           UUID : 4e95a658:13a5a387:dd62bdbe:ea655271
         Events : 736102

    Number   Major   Minor   RaidDevice State
       0       8        2        0      active sync   /dev/sda2
       1       8       18        1      active sync   /dev/sdb2
       9       8       34        2      active sync   /dev/sdc2
       3       8       50        3      active sync   /dev/sdd2
       4       8       66        4      active sync   /dev/sde2
       5       8       82        5      active sync   /dev/sdf2
       6       8       98        6      active sync   /dev/sdg2
       8       8      114        7      active sync   /dev/sdh2

I noted that state is active and not idle. The output of 'mdadm -D
/dev/md0' did not change between executions.

It appears that either something is deadlocked somewhere or some other
event was missed and something is waiting forever for it to happen. I
was able to read from /dev/md0 and all the constituent devices via dd
and 'smartctl -a' did not indicate any problems. I was able to read from
/proc/mdstat and no problems were indicated.

I have no idea how to debug this further. What else should I look at
when I encounter this problem? What kind of logging can I enable which
might show additional, and hopefully useful, information when the
problem occurs?

I'm running Fedora 16 with the latest packages updated via yum. The
mdadm is v3.2.2 - 17th June 2011 and the kernel is 3.1.6-1.fc16.x86_64.

I have 6 devices connected to the AMD SB850 ACHI SATA controller and 2
devices to the built-in JMicron JMB362/363 controller to make /dev/md0.
I also have 6 devices connected to 3 sil3132 SATA controllers to make
/dev/md1. I have never encountered this problem with md1 but its I/O is
no where near as great.

Suggestions?

--Larkin
