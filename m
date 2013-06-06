From: Nic Wolfe <nic@wolfeden.ca>
Subject: RAID6 growing interrupted, array won't assemble or resume growing
Date: Thu, 6 Jun 2013 00:41:06 -0600
Message-ID: <CAGjXdAhMHEFFc1C0XUSY_K1ZxwaRG-x=NEw9H2Aiv+YtNat-tw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

First a little bit of background about my setup and how I got into this state:

I'm running an older version of ubuntu with a 2.6.24.5 kernel and
mdadm 2.6.3. I had a 5x2TB raid6 array which I attempted to grow to a
6x2TB array. While it was growing I had some hardware problems and the
disks in the array sporadically connected/disconnected. This put the
array in a bad state.

After fixing my hardware issues and getting the PC back up I had a
problem where after booting mdadm would consume all my RAM trying to
assemble my array (oom_killer started killing indiscriminately and I
couldn't get on the PC to shut it down, had to power cycle it). I
added some more memory (from 2GB to 4GB) and mdadm now only takes up
about 70% before it exits with no results that I can tell. Below are
the processes which run when I boot:

root      3052  0.0  0.0   1704   468 ?        S<   23:23   0:00
/lib/udev/watershed /sbin/mdadm --assemble --scan --no-degraded
root      3053  0.0  0.0   1704   460 ?        S<   23:23   0:00
/lib/udev/watershed /sbin/mdadm --assemble --scan --no-degraded
root      3054  0.0  0.0   1704   460 ?        S<   23:23   0:00
/lib/udev/watershed /sbin/mdadm --assemble --scan --no-degraded
root      3055  0.0  0.0   1704   460 ?        S<   23:23   0:00
/lib/udev/watershed /sbin/mdadm --assemble --scan --no-degraded
root      3056  0.0  0.0   1704   464 ?        S<   23:23   0:00
/lib/udev/watershed /sbin/mdadm --assemble --scan --no-degraded
root      6677  0.0  0.0   2084   336 ?        Ss   23:26   0:00
/sbin/mdadm --monitor --pid-file /var/run/mdadm/monitor.pid
--daemonise --scan --syslog
root      7072 42.1 67.1 2768196 2766984 ?     R<   23:42   7:01
/sbin/mdadm --assemble --scan --no-degraded




So anyway now that I have the system stable and all 6 drives hooked up
I would very much like to get the array working again.

I have the following in my mdadm.conf: ARRAY /dev/md1 level=raid6
num-devices=5 UUID=4672ced4:81401dbc:52723fc8:3fe02f5a
(it is currently commented out, note that it didn't get updated after
growing to 6)

Below is the --examine for all 6 drives:

midgetspy@MidgetNAS:~$ sudo mdadm --examine /dev/sda
mdadm: No md superblock detected on /dev/sda.
midgetspy@MidgetNAS:~$ sudo mdadm --examine /dev/sdb
/dev/sdb:
          Magic : a92b4efc
        Version : 00.91.00
           UUID : 4672ced4:81401dbc:52723fc8:3fe02f5a (local to host MidgetNAS)
  Creation Time : Wed Jun  2 21:11:18 2010
     Raid Level : raid6
  Used Dev Size : 1953431488 (1862.94 GiB 2000.31 GB)
     Array Size : 7813725952 (7451.75 GiB 8001.26 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 1

  Reshape pos'n : 665856 (650.36 MiB 681.84 MB)
  Delta Devices : 1 (5->6)

    Update Time : Mon Oct 22 21:06:07 2012
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 146b8c4a - correct
         Events : 0.1323352

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8      176        2      active sync

   0     0       0        0        0      removed
   1     1       8      192        1      active sync
   2     2       8      176        2      active sync
   3     3       0        0        3      faulty removed
   4     4       0        0        4      faulty removed
   5     5      65        0        5      active sync

   midgetspy@MidgetNAS:~$ sudo mdadm --examine /dev/sdc
/dev/sdc:
          Magic : a92b4efc
        Version : 00.91.00
           UUID : 4672ced4:81401dbc:52723fc8:3fe02f5a (local to host MidgetNAS)
  Creation Time : Wed Jun  2 21:11:18 2010
     Raid Level : raid6
  Used Dev Size : 1953431488 (1862.94 GiB 2000.31 GB)
     Array Size : 7813725952 (7451.75 GiB 8001.26 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 1

  Reshape pos'n : 665856 (650.36 MiB 681.84 MB)
  Delta Devices : 1 (5->6)

    Update Time : Mon Oct 22 21:06:07 2012
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 146b8c58 - correct
         Events : 0.1323352

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8      192        1      active sync

   0     0       0        0        0      removed
   1     1       8      192        1      active sync
   2     2       8      176        2      active sync
   3     3       0        0        3      faulty removed
   4     4       0        0        4      faulty removed
   5     5      65        0        5      active sync

   midgetspy@MidgetNAS:~$ sudo mdadm --examine /dev/sdd
/dev/sdd:
          Magic : a92b4efc
        Version : 00.91.00
           UUID : 4672ced4:81401dbc:52723fc8:3fe02f5a (local to host MidgetNAS)
  Creation Time : Wed Jun  2 21:11:18 2010
     Raid Level : raid6
  Used Dev Size : 1953431488 (1862.94 GiB 2000.31 GB)
     Array Size : 7813725952 (7451.75 GiB 8001.26 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 1

  Reshape pos'n : 665856 (650.36 MiB 681.84 MB)
  Delta Devices : 1 (5->6)

    Update Time : Mon Oct 22 21:05:39 2012
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 146b8c05 - correct
         Events : 0.1323342

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8      208        0      active sync

   0     0       8      208        0      active sync
   1     1       8      192        1      active sync
   2     2       8      176        2      active sync
   3     3       8      224        3      active sync
   4     4       8      240        4      active sync
   5     5      65        0        5      active sync

midgetspy@MidgetNAS:~$ sudo mdadm --examine /dev/sde
/dev/sde:
          Magic : a92b4efc
        Version : 00.91.00
           UUID : 4672ced4:81401dbc:52723fc8:3fe02f5a (local to host MidgetNAS)
  Creation Time : Wed Jun  2 21:11:18 2010
     Raid Level : raid6
  Used Dev Size : 1953431488 (1862.94 GiB 2000.31 GB)
     Array Size : 7813725952 (7451.75 GiB 8001.26 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 1

  Reshape pos'n : 665856 (650.36 MiB 681.84 MB)
  Delta Devices : 1 (5->6)

    Update Time : Mon Oct 22 21:05:58 2012
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 146b8c4b - correct
         Events : 0.1323350

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8      224        3      active sync

   0     0       0        0        0      removed
   1     1       8      192        1      active sync
   2     2       8      176        2      active sync
   3     3       8      224        3      active sync
   4     4       8      240        4      active sync
   5     5      65        0        5      active sync

midgetspy@MidgetNAS:~$ sudo mdadm --examine /dev/sdf
/dev/sdf:
          Magic : a92b4efc
        Version : 00.91.00
           UUID : 4672ced4:81401dbc:52723fc8:3fe02f5a (local to host MidgetNAS)
  Creation Time : Wed Jun  2 21:11:18 2010
     Raid Level : raid6
  Used Dev Size : 1953431488 (1862.94 GiB 2000.31 GB)
     Array Size : 7813725952 (7451.75 GiB 8001.26 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 1

  Reshape pos'n : 665856 (650.36 MiB 681.84 MB)
  Delta Devices : 1 (5->6)

    Update Time : Mon Oct 22 21:05:58 2012
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 146b8c5d - correct
         Events : 0.1323350

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4       8      240        4      active sync

   0     0       0        0        0      removed
   1     1       8      192        1      active sync
   2     2       8      176        2      active sync
   3     3       8      224        3      active sync
   4     4       8      240        4      active sync
   5     5      65        0        5      active sync


How should I proceed? I'm far enough out of my depth that I'm hesitant
to try anything for fear of causing more damage. Should I update my
mdadm.conf to have num-devices=6 and see if it sorts itself out? Try
to force assemble the 5 drives with superblocks? Create a "new" array
out of them?

Any input would be greatly appreciated.

Thanks,

Nic
