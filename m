From: James Ralston <qralston+ml.linux-raid@andrew.cmu.edu>
Subject: how to swap devices to increase mirror size?
Date: Wed, 22 Jan 2003 19:04:56 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0301221900450.11300-100000@pcmy.sei.cmu.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

What is the recommend way to increase the capacity of a mirror on the
fly?

What seemed obvious to me (remove and then replace each part of the
mirror in turn) doesn't work:

E.g. (for simulation purposes):

   Device Boot    Start       End    Blocks   Id  System
/dev/sdb1             1        33    265041   fd  Linux raid autodetect
/dev/sdb2            34        99    530145   fd  Linux raid autodetect

   Device Boot    Start       End    Blocks   Id  System
/dev/sdc1             1        33    265041   fd  Linux raid autodetect
/dev/sdc2            34        99    530145   fd  Linux raid autodetect

$ mdadm --create /dev/md0 --verbose --level=mirror --raid-devices=2 /dev/sdb1 /dev/sdc1
mdadm: array /dev/md0 started.

$ cat /proc/mdstat
Personalities : [raid1] 
read_ahead 1024 sectors
md0 : active raid1 sdc1[1] sdb1[0]
      264960 blocks [2/2] [UU]
unused devices: <none>

$ mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.00
  Creation Time : Wed Jan 22 18:40:33 2003
     Raid Level : raid1
     Array Size : 264960 (258.75 MiB 271.31 MB)
    Device Size : 264960 (258.75 MiB 271.31 MB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0
    Persistence : Superblock is persistent
    Update Time : Wed Jan 22 18:40:33 2003
          State : dirty, no-errors
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       8       33        1      active sync   /dev/sdc1
           UUID : 441d90a6:0f20b7cf:0ac9ed56:52bee387

Ok, let's remove sdc1 and replace it with sdc2:

$ mdadm /dev/md0 -f /dev/sdc1 -r /dev/sdc1 -a /dev/sdc2
mdadm: set /dev/sdc1 faulty in /dev/md0
mdadm: hot removed /dev/sdc1
mdadm: hot added /dev/sdc2

But no joy; /dev/sdc2 won't take as mirror:

$ mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.00
  Creation Time : Wed Jan 22 18:40:33 2003
     Raid Level : raid1
     Array Size : 264960 (258.75 MiB 271.31 MB)
    Device Size : 264960 (258.75 MiB 271.31 MB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0
    Persistence : Superblock is persistent
    Update Time : Wed Jan 22 18:42:13 2003
          State : dirty, no-errors
 Active Devices : 1
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 1
    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       0        0        1      faulty removed
       2       8       34        2        /dev/sdc2
           UUID : 441d90a6:0f20b7cf:0ac9ed56:52bee387

$ cat /proc/mdstat 
Personalities : [raid1] 
read_ahead 1024 sectors
md0 : active raid1 sdc2[2] sdb1[0]
      264960 blocks [2/1] [U_]
unused devices: <none>

The mirror won't rebuild /dev/sdc2 to match /dev/sdb1.

What do I have to do in order to get /dev/sdc2 to *replace* /dev/sdc1
in the array?

If the answer is "you can't do that", then what is the recommended
method for doing what I'm trying to do?

Thanks,

-- 
James Ralston, Information Technology
Software Engineering Institute
Carnegie Mellon University, Pittsburgh, PA, USA

