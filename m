From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: raid1 + 2.6.27.7 issues
Date: Mon, 9 Feb 2009 10:36:38 -0600
Message-ID: <cccedfc60902090836n76e5e6e6mfd149db5ac2f5d2b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I found some time to get back to some raid1 issues I have been having.


Briefly:

I have a pair of machines each with an 80G hard drive. One machine exports
this hard drive over NBD (network block device) to the other. When both
devices are available, they are combined via MD into a raid1. The raid1
looks like this:

/dev/md11:
        Version : 1.00
  Creation Time : Mon Dec 15 07:06:13 2008
     Raid Level : raid1
     Array Size : 78123988 (74.50 GiB 80.00 GB)
  Used Dev Size : 156247976 (149.01 GiB 160.00 GB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Mon Feb  9 09:53:13 2009
          State : active, degraded, recovering
 Active Devices : 1
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 1

 Rebuild Status : 9% complete

           Name : turnip:11  (local to host turnip)
           UUID : cf24d099:9e174a79:2a2f6797:dcff1420
         Events : 90220

    Number   Major   Minor   RaidDevice State
       2      43        0        0      writemostly spare rebuilding
/dev/nbd0
       3       8        0        1      active sync   /dev/sda




The typical use case for me is this: I will run the array (/dev/md11) in
degraded mode (without /dev/nbd0) for a week or so.
At some point, I will try to synchronize the underlying devices. To do this
I use:

mdadm /dev/md11 --re-add /dev/nbd0

The issues I encounter are this: the array goes into *recovery* mode rather
than *resync*, despite the fact that /dev/nbd0 was at one point a full
member (in sync) of the array. Typically, less than 1/3 of the array needs
to be resynchronized, often much less than that. I base this off of the
--examine-bitmap output from /dev/sda. Today it says:

Bitmap : 19074 bits (chunks), 6001 dirty (31.5%)

which is a substantially higher percentage than usual.

Indications of a problem: --examine and --examine-bitmap have an Events
count which agrees for /dev/sda but does *not* agree for /dev/nbd0. From
today, the --examine and --examine-bitmap output from /dev/nbd0:

          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : cf24d099:9e174a79:2a2f6797:dcff1420
           Name : turnip:11  (local to host turnip)
  Creation Time : Mon Dec 15 07:06:13 2008
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 160086384 (76.34 GiB 81.96 GB)
     Array Size : 156247976 (74.50 GiB 80.00 GB)
  Used Dev Size : 156247976 (74.50 GiB 80.00 GB)
   Super Offset : 160086512 sectors
          State : clean
    Device UUID : 01524a75:c309869c:6da972c9:084115c6

Internal Bitmap : 2 sectors from superblock
      Flags : write-mostly
    Update Time : Mon Feb  9 09:52:58 2009
       Checksum : 64058b3b - correct
         Events : 90192

    Array Slot : 2 (failed, failed, empty, 1)
   Array State : _u 2 failed
        Filename : /dev/nbd0
           Magic : 6d746962
         Version : 4
            UUID : cf24d099:9e174a79:2a2f6797:dcff1420
          Events : 81596
  Events Cleared : 81570
           State : OK
       Chunksize : 4 MB
          Daemon : 5s flush period
      Write Mode : Allow write behind, max 256
       Sync Size : 78123988 (74.50 GiB 80.00 GB)
          Bitmap : 19074 bits (chunks), 0 dirty (0.0%)


As you can see, --examine says that there are 90192 events, and
--examine-bitmap says there are 81596 events.

So that seems to be a bug or some other issue.

What am I doing wrong that causes the array to go into "recovery" instead of
"resync" mode? It's clearly showing /dev/nbd0 as a *spare* - does this have
anything to do with it?



--
Jon
