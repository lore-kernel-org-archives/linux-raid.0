From: mella.nicolas@gmail.com
Subject: Corrupted RAID 50 (aparently?) array. Help needed.
Date: Thu, 28 Feb 2008 10:42:04 -0500
Message-ID: <25971327.1204213324763.JavaMail.root@wombat.diezmil.com>
Reply-To: mella.nicolas@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi list,

Hope someone can give me the right direction on how to resolve this.

I have 12 hard drives with RAID software. (250 GB each disk) I just know it was a 2 TB array. The old operating system which supported the array is no longer online. (just in case someone asks me to check the mdadm.conf file)

From what I can see with mdadm,is that there are 2 x RAID5 arrays of 990.72 GB each. (2 TB the whole array). So I believed that there is a RAID0 between both RAID5 arrays. Right? (RAID 50) The first RAID5 group is composed by 5 discs, all of them active. Here is the post: (all /dev/sdb4 /dev/sdc4 /dev/sdd4 /dev/sde4 /dev/sdf4 are similar and have the same UUID)

# mdadm --examine /dev/sdb4

----------------------------
/dev/sdb4:
          Magic : a92b4efc
        Version : 00.91.00
           UUID : 48b86fc7:adbd7bbe:df7c7359:36df38af
  Creation Time : Tue Apr 24 18:14:28 2007
     Raid Level : raid5
  Used Dev Size : 241873792 (230.67 GiB 247.68 GB)
     Array Size : 967495168 (922.68 GiB 990.72 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0

  Reshape pos'n : 0
      New Level : raid0
     New Layout : left-asymmetric
  New Chunksize : 0

    Update Time : Mon Nov 29 21:01:33 1999
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 42da3120 - correct
         Events : 0.61

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       3        4        0      active sync

   0     0       3        4        0      active sync
   1     1      22        4        1      active sync
   2     2      33        4        2      active sync
   3     3      34        4        3      active sync
   4     4      56        4        4      active sync
---------------------

But If I try to assemble this 1st RAID5 array:

# mdadm --assemble /dev/md0 /dev/sdb4 /dev/sdc4 /dev/sdd4 /dev/sde4 /dev/sdf4
mdadm: Failed to restore critical section for reshape, sorry.

Is not possible. I also try the build option:

# mdadm --build /dev/md0 -l5 -n5 --assume-clean /dev/sdb4 /dev/sdc4 /dev/sdd4 /dev/sde4 /dev/sdf4
mdadm: Raid level 5 not permitted with --build.

On the other hand there is the second RAID5 group which outputs the following:

------------------
# mdadm --examine /dev/sdg4 
/dev/sdg4:
          Magic : a92b4efc
        Version : 00.91.00
           UUID : 384bd728:158c759c:e9be7911:01187b1f
  Creation Time : Tue Apr 24 18:14:48 2007
     Raid Level : raid5
  Used Dev Size : 241873792 (230.67 GiB 247.68 GB)
     Array Size : 967495168 (922.68 GiB 990.72 GB)
   Raid Devices : 5
  Total Devices : 6
Preferred Minor : 1

  Reshape pos'n : 0
      New Level : raid0
     New Layout : left-asymmetric
  New Chunksize : 0

    Update Time : Mon Nov 29 21:01:36 1999
          State : active
 Active Devices : 4
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 2
       Checksum : 6eb7dc84 - correct
         Events : 0.65

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1      89        4        1      active sync

   0     0       0        0        0      faulty removed
   1     1      89        4        1      active sync
   2     2      90        4        2      active sync
   3     3      91        4        3      active sync
   4     4     120        4        4      active sync
   5     5     121        4        5      spare
   6     6      88        4        6      spare
------------------------------------

The 2nd RAID5 group was composed by 7 disks (I believed, as shown above). 1 disks is faulty and 2 disks are spare. But even though with the remaining 4 disks I could try to assemble this RAID5, but I have the same result as with the 1st RAID5. (mdadm: Failed to restore critical section for reshape, sorry.)

Do you have any idea on how to re-assemble this RAID 50 array ?

Thanks for any advice & help.

Nicolas

PS:

# mdadm -V
mdadm - v2.6 - 21 December 2006

Linux lab-suse 2.6.16.46-0.12-smp #1 SMP Thu May 17 14:00:09 UTC 2007 x86_64 x86_64 x86_64 GNU/Linux

--
This message was sent on behalf of mella.nicolas@gmail.com at openSubscriber.com
http://www.opensubscriber.com/messages/linux-raid@vger.kernel.org/topic.html
