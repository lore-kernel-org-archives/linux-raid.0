From: Alex <mysqlstudent@gmail.com>
Subject: Possible data corruption after rebuild
Date: Fri, 6 Jul 2012 12:09:43 -0400
Message-ID: <CAB1R3sjHtWwE7=MOqTzS7omiE-ebxqBPNaMMh-+_AYw3WgLtxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I had a situation where after rebooting all three drives of a RAID5
array were marked as spares. I rebuild the array using "mdadm -C
/dev/md1 -e 1.1 --level 5 -n 3  --chunk 512 --assume-clean /dev/sda2
/dev/sdb2 /dev/sdc2" and mdstat showed it was again assembled. The
filesystem types on /dev/sdb were all "Linux" instead of "Linux raid
autodetect", so I changed them back.

/dev/md2 also has a problem, and I have no idea what to do there either.

When I tried to fsck it to be sure it was intact, it prompted me that
there was a problem with the superblock, and I answered Yes to "Fix?".

After there being a number of further errors, I quit fsck, and am here for help.

Did I perhaps assemble the array in the wrong disk order? Is there
another superblock that may be useful here and how would I find it?

I'm really concerned that I've lost the data and really hope someone
has some ideas.

# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md1 : active raid5 sda2[0] sdc2[2] sdb2[1]
      51196928 blocks super 1.1 level 5, 512k chunk, algorithm 2 [3/3] [UUU]

md2 : active raid5 sdc3[0] sdb3[2] sda3[1]
      1890300928 blocks super 1.1 level 5, 512k chunk, algorithm 2 [3/3] [UUU]

md0 : active raid1 sdc1[0] sdb1[1]
      255988 blocks super 1.0 [3/2] [U_U]

unused devices: <none>

# mdadm -E /dev/md1
mdadm: No md superblock detected on /dev/md1.

# mdadm --detail /dev/md1
/dev/md1:
        Version : 1.1
  Creation Time : Fri Jul  6 13:41:54 2012
     Raid Level : raid5
     Array Size : 51196928 (48.83 GiB 52.43 GB)
  Used Dev Size : 25598464 (24.41 GiB 26.21 GB)
   Raid Devices : 3
  Total Devices : 3
    Persistence : Superblock is persistent

    Update Time : Fri Jul  6 16:01:18 2012
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : sysresccd:1  (local to host sysresccd)
           UUID : 4ce6925e:b6cbd20e:7f3efbfc:668295fe
         Events : 2

    Number   Major   Minor   RaidDevice State
       0       8        2        0      active sync   /dev/sda2
       1       8       18        1      active sync   /dev/sdb2
       2       8       34        2      active sync   /dev/sdc2

Thanks for any ideas,
Alex
