From: Paul Johnson <pauljohn32@gmail.com>
Subject: had trouble re-building a raid 1 array; can you explain what was
	wrong?
Date: Wed, 4 Nov 2009 23:12:20 -0600
Message-ID: <13e802630911042112j1bd1d9dfya87b45e2f298f692@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've found a workaround for a problem with a raid 1
array. I'm posting to share the "solution" and to
ask why this went wrong in the first place.

On an old test machine, I have 2 4-year-old
Seagate IDE drives in raid1 mirror for my home
partition. One failed and Seagate was very very
pleasant to replace it. I didn't even need a receipt!
They just went by the serial number to conclude I
was in warranty.

I followed "the usual" procedure for failed
drives. mdadm marked the drive as a failure and then I
removed it from the array.  Then I tried to
add it back into the raid 1.

One of the HOWTOs I relied on was this one:
http://www.howtoforge.com/replacing_hard_disks_in_a_raid1_array

Here's what went wrong. After being added, the new drive
 went through a long "recovery" process--2 hours--but when
it finished, the new drive was marked as "spare" and the
raid 1 array continued to show only one drive was active.

Every time the system restarts, the new drive tries
to resync itself, it copies for 2 hours, but it never
enters the array. It is always spare.

In the end, gave up trying to fix /dev/md0.
I "guessed" a solution--create a new /dev/md1
device and refit the system to use that. I explain that
fix below, in case the same problem hits other
people.

But I'm still curious to know why it did not work.

Now the details:

The raid1 array was /dev/md0 and it used disks sdb1
and sdc1 and the one that failed was sdb1.

Here's what I saw while the new drive was being added:

# cat /proc/mdstat
Personalities : [raid1]
md0 : active raid1 sdc1[1] sdb1[2]
     244195904 blocks [2/1] [_U]
     [==================>..]  recovery = 94.4% (230658240/244195904)
finish=6.9min speed=32396K/sec

unused devices: <none>


# mdadm --examine /dev/sdb1
/dev/sdb1:
         Magic : a92b4efc
       Version : 0.90.00
          UUID : 37e6e9b6:34cdfcb2:63afba50:8b88d6fc
 Creation Time : Sat Aug 18 19:10:40 2007
    Raid Level : raid1
 Used Dev Size : 244195904 (232.88 GiB 250.06 GB)
    Array Size : 244195904 (232.88 GiB 250.06 GB)
  Raid Devices : 2
 Total Devices : 2
Preferred Minor : 0

   Update Time : Thu Oct 29 00:35:50 2009
         State : clean
 Active Devices : 1
Working Devices : 2
 Failed Devices : 0
 Spare Devices : 1
      Checksum : a557d3b3 - correct
        Events : 6874


     Number   Major   Minor   RaidDevice State
this     2       8       17        2      spare   /dev/sdb1

  0     0       0        0        0      removed
  1     1       8       33        1      active sync   /dev/sdc1
  2     2       8       17        2      spare   /dev/sdb1


After the rebuild was done, here's the situation: the
new drive is a spare:


# mdadm --examine /dev/sdc1
/dev/sdc1:
         Magic : a92b4efc
       Version : 0.90.00
          UUID : 37e6e9b6:34cdfcb2:63afba50:8b88d6fc
 Creation Time : Sat Aug 18 19:10:40 2007
    Raid Level : raid1
 Used Dev Size : 244195904 (232.88 GiB 250.06 GB)
    Array Size : 244195904 (232.88 GiB 250.06 GB)
  Raid Devices : 2
 Total Devices : 2
Preferred Minor : 0

   Update Time : Thu Oct 29 00:35:50 2009
         State : clean
 Active Devices : 1
Working Devices : 2
 Failed Devices : 0
 Spare Devices : 1
      Checksum : a557d3c7 - correct
        Events : 6874


     Number   Major   Minor   RaidDevice State
this     1       8       33        1      active sync   /dev/sdc1

  0     0       0        0        0      removed
  1     1       8       33        1      active sync   /dev/sdc1
  2     2       8       17        2      spare   /dev/sdb1


# mdadm --query /dev/md0
/dev/md0: 232.88GiB raid1 2 devices, 1 spare. Use mdadm --detail for
more detail.


# mdadm --detail /dev/md0
/dev/md0:
       Version : 0.90
 Creation Time : Sat Aug 18 19:10:40 2007
    Raid Level : raid1
    Array Size : 244195904 (232.88 GiB 250.06 GB)
 Used Dev Size : 244195904 (232.88 GiB 250.06 GB)
  Raid Devices : 2
 Total Devices : 2
Preferred Minor : 0
   Persistence : Superblock is persistent

   Update Time : Thu Oct 29 00:35:50 2009
         State : clean, degraded, recovering
 Active Devices : 1
Working Devices : 2
 Failed Devices : 0
 Spare Devices : 1

 Rebuild Status : 97% complete

          UUID : 37e6e9b6:34cdfcb2:63afba50:8b88d6fc
        Events : 0.6874

   Number   Major   Minor   RaidDevice State
      2       8       17        0      spare rebuilding   /dev/sdb1
      1       8       33        1      active sync   /dev/sdc1


After that, rebuilding seems finished:


# cat /proc/mdstat
Personalities : [raid1]
md0 : active raid1 sdc1[1] sdb1[2]
     244195904 blocks [2/1] [_U]

But I have only 1 drive in the active array:

# mdadm --detail /dev/md0
/dev/md0:
       Version : 0.90
 Creation Time : Sat Aug 18 19:10:40 2007
    Raid Level : raid1
    Array Size : 244195904 (232.88 GiB 250.06 GB)
 Used Dev Size : 244195904 (232.88 GiB 250.06 GB)
  Raid Devices : 2
 Total Devices : 2
Preferred Minor : 0
   Persistence : Superblock is persistent

   Update Time : Thu Oct 29 00:43:21 2009
         State : clean, degraded
 Active Devices : 1
Working Devices : 2
 Failed Devices : 0
 Spare Devices : 1

          UUID : 37e6e9b6:34cdfcb2:63afba50:8b88d6fc
        Events : 0.6880

   Number   Major   Minor   RaidDevice State
      2       8       17        0      spare rebuilding   /dev/sdb1
      1       8       33        1      active sync   /dev/sdc1


# mdadm --examine /dev/sdb1
/dev/sdb1:
         Magic : a92b4efc
       Version : 0.90.00
          UUID : 37e6e9b6:34cdfcb2:63afba50:8b88d6fc
 Creation Time : Sat Aug 18 19:10:40 2007
    Raid Level : raid1
 Used Dev Size : 244195904 (232.88 GiB 250.06 GB)
    Array Size : 244195904 (232.88 GiB 250.06 GB)
  Raid Devices : 2
 Total Devices : 2
Preferred Minor : 0

   Update Time : Thu Oct 29 00:44:02 2009
         State : clean
 Active Devices : 1
Working Devices : 2
 Failed Devices : 0
 Spare Devices : 1
      Checksum : a557d5af - correct
        Events : 6882


     Number   Major   Minor   RaidDevice State
this     2       8       17        2      spare   /dev/sdb1

  0     0       0        0        0      removed
  1     1       8       33        1      active sync   /dev/sdc1
  2     2       8       17        2      spare   /dev/sdb1



I tried a lot of ways to set this right.
I tried "grow" the array, set the number of spares
to 0, and so forth. No success.


After a lot of tries, I gave up trying to get /dev/md0 to work.
So I stopped it, and the used the "--assume-clean" option to
create a new array on md1. I found that suggestion here

http://neverusethisfont.com/blog/tags/mdadm/


# mdadm -S /dev/md0

# mdadm --create --assume-clean --level=1 --raid-devices=2 /dev/md1
 /dev/sdc1 /dev/sdb1

That works! So I just needed to reset the configuration
to use that.  First,  grab the metadata


# mdadm --detail --scan
ARRAY /dev/md1 metadata=0.90 UUID=6a408f8b:515f605f:bfe78010:bc810f04

And revise the mdadm.conf file

# cat /etc/mdadm.conf

DEVICE /dev/sdb1 /dev/sdc1
ARRAY /dev/md1 level=raid1 num-devices=2
UUID=6a408f8b:515f605f:bfe78010:bc810f04  devices=/dev/sdc1,/dev/sdb1

And I changed /etc/fstab to point at md1, not md0.

But why did /dev/md0 hate me in the first place?

I wonder if it was personal :(



-- 
Paul E. Johnson
Professor, Political Science
1541 Lilac Lane, Room 504
University of Kansas
