From: Clemens Koller <clemens.koller@anagramm.de>
Subject: Error mounting a reiserfs on renamed raid1
Date: Fri, 25 Jan 2008 01:48:32 +0100
Message-ID: <479931E0.3020909@anagramm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi there.

I am new to this list, however didn't find this effect nor a
solution to my problem in the archives or with google:

short story:
------------
A single raid1 as /dev/md0 containing a reiserfs (with important data)
assembled during boot works just fine:
$ cat /proc/mdstat
Personalities : [linear] [raid0] [raid1]
md0 : active raid1 hdg1[1] hde1[0]
       293049600 blocks [2/2] [UU]

The same raid1 moved to another machine as a fourth raid can be
assembled manually as /dev/md3 (to work around naming conflicts),
but it cannot be mounted anymore:
$ mdadm --assemble /dev/md3 --update=super-minor -m0 /dev/hde /dev/hdg
does not complain. /dev/md3 is created. But
$ mount /dev/md3 /raidmd3 gives:

Jan 24 20:24:10 rio kernel: md: md3 stopped.
Jan 24 20:24:10 rio kernel: md: bind<hdg>
Jan 24 20:24:10 rio kernel: md: bind<hde>
Jan 24 20:24:10 rio kernel: raid1: raid set md3 active with 2 out of 2 mirrors
Jan 24 20:24:12 rio kernel: ReiserFS: md3: warning: sh-2021: reiserfs_fill_super: can not find reiserfs on md3

Adding  -t reiserfs doesn't work either.
So, the renaming or reassembling doesn't work, even if /dev/md3 is present
and mdadm --detail /dev/md3 tells that everything is fine?!


long story:
-----------
There are two machines: an old server and a new server.
Servers are in production environment, so there are no risky things to do.
It's all kernel 2.6.23.12 (will try 2.6.23.14 tomorrow) and
mdadm - v2.6.4 - 19th October 2007
Distribution is CRUX (everything vanilla, similar to LFS)

Old server was has it's root on /dev/hda and data on /dev/md0 which is
an Promise PDC20269 dual ATA raid1 configuration consisting of /dev/hde and /dev/hdg.
Everything is reiserfs and working fine.

This machine should be migrated over to a new server with:
With VIA dual SATA raid1 configuration, three partitions for the system, swap and data.
/dev/sd[ab][123] became: /dev/md[012]
md0 is /
md1 is swap
md2 is data.
everything is ext3!

So I plugged the old PDC20269 with the harddisks to the new machine. During boot,
md complains about a duplicate md0:

Jan 24 20:21:44 rio kernel: md: Autodetecting RAID arrays.
Jan 24 20:21:44 rio kernel: md: autorun ...
Jan 24 20:21:44 rio kernel: md: considering sdb3 ...
Jan 24 20:21:44 rio kernel: md:  adding sdb3 ...
Jan 24 20:21:44 rio kernel: md: sdb2 has different UUID to sdb3
Jan 24 20:21:44 rio kernel: md: sdb1 has different UUID to sdb3
Jan 24 20:21:45 rio kernel: md:  adding sda3 ...
Jan 24 20:21:45 rio kernel: md: sda2 has different UUID to sdb3
Jan 24 20:21:45 rio kernel: md: sda1 has different UUID to sdb3
Jan 24 20:21:45 rio kernel: md: hdg1 has different UUID to sdb3
Jan 24 20:21:45 rio kernel: md: hde1 has different UUID to sdb3
Jan 24 20:21:45 rio kernel: md: created md2
Jan 24 20:21:45 rio kernel: md: bind<sda3>
Jan 24 20:21:45 rio kernel: md: bind<sdb3>
Jan 24 20:21:45 rio kernel: md: running: <sdb3><sda3>
Jan 24 20:21:46 rio kernel: raid1: raid set md2 active with 2 out of 2 mirrors
Jan 24 20:21:46 rio kernel: md: considering sdb2 ...
Jan 24 20:21:46 rio kernel: md:  adding sdb2 ...
Jan 24 20:21:46 rio kernel: md: sdb1 has different UUID to sdb2
Jan 24 20:21:46 rio kernel: md:  adding sda2 ...
Jan 24 20:21:46 rio kernel: md: sda1 has different UUID to sdb2
Jan 24 20:21:46 rio kernel: md: hdg1 has different UUID to sdb2
Jan 24 20:21:46 rio kernel: md: hde1 has different UUID to sdb2
Jan 24 20:21:46 rio kernel: md: created md1
Jan 24 20:21:46 rio kernel: md: bind<sda2>
Jan 24 20:21:47 rio kernel: md: bind<sdb2>
Jan 24 20:21:47 rio kernel: md: running: <sdb2><sda2>
Jan 24 20:21:47 rio kernel: raid1: raid set md1 active with 2 out of 2 mirrors
Jan 24 20:21:47 rio kernel: md: considering sdb1 ...
Jan 24 20:21:47 rio kernel: md:  adding sdb1 ...
Jan 24 20:21:47 rio kernel: md:  adding sda1 ...
Jan 24 20:21:47 rio kernel: md: hdg1 has different UUID to sdb1
Jan 24 20:21:47 rio kernel: md: hde1 has different UUID to sdb1
Jan 24 20:21:47 rio kernel: md: created md0
Jan 24 20:21:48 rio kernel: md: bind<sda1>
Jan 24 20:21:48 rio kernel: md: bind<sdb1>
Jan 24 20:21:48 rio kernel: md: running: <sdb1><sda1>
Jan 24 20:21:48 rio kernel: raid1: raid set md0 active with 2 out of 2 mirrors
Jan 24 20:21:48 rio kernel: md: considering hdg1 ...
Jan 24 20:21:48 rio kernel: md:  adding hdg1 ...
Jan 24 20:21:48 rio kernel: md:  adding hde1 ...
Jan 24 20:21:48 rio kernel: md: md0 already running, cannot run hdg1
Jan 24 20:21:48 rio kernel: md: export_rdev(hde1)
Jan 24 20:21:49 rio kernel: md: export_rdev(hdg1)
Jan 24 20:21:49 rio kernel: md: ... autorun DONE.

short story continues here...
I use the full hd[eg] disks for the raid1 with only a single
partition. The partitions are
$ fdisk -l /dev/hde

Disk /dev/hde: 300.0 GB, 300090728448 bytes
255 heads, 63 sectors/track, 36483 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x1bd3d309

    Device Boot      Start         End      Blocks   Id  System
/dev/hde1               1       36483   293049666   fd  Linux raid autodetect

When I plug the old hd[eg] raid back to be a single raid1 in the system,
everything works fine. So nothing was actually broken.

What did I do wrong?

How can I just change md0 to md3 keeping everything else as is?

Thank you,

Clemens
