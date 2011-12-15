From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: ''force'' continutation of a rebuild?
Date: Thu, 15 Dec 2011 12:36:19 -0800
Message-ID: <3b2qr8xpq2.ln2@goaway.wombat.san-francisco.ca.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello all,

I have another seminewbie question.  I had an issue, likely hardware
related, which forced me to reboot a machine with a RAID6 during a
rebuild after a previous drive failure.  Now, after some other hardware
issues, I've been able to successfully assemble the array, but it
seems to be in an odd state:

# mdadm -D /dev/md0
/dev/md0:
        Version : 1.01
  Creation Time : Thu Sep 29 21:26:35 2011
     Raid Level : raid6
     Array Size : 13671797440 (13038.44 GiB 13999.92 GB)
  Used Dev Size : 1953113920 (1862.63 GiB 1999.99 GB)
   Raid Devices : 9
  Total Devices : 11
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Thu Dec 15 12:19:41 2011
          State : clean, degraded
 Active Devices : 8
Working Devices : 11
 Failed Devices : 0
  Spare Devices : 3

     Chunk Size : 64K

           Name : 0
           UUID : 24363b01:90deb9b5:4b51e5df:68b8b6ea
         Events : 102730

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       6       8      113        1      active sync   /dev/sdh1
      11       8      177        2      spare rebuilding   /dev/sdl1
       3       8       65        3      active sync   /dev/sde1
       4       8       81        4      active sync   /dev/sdf1
       9       8      145        5      active sync   /dev/sdj1
      10       8       97        6      active sync   /dev/sdg1
       7       8      129        7      active sync   /dev/sdi1
       8       8      161        8      active sync   /dev/sdk1

      12       8      225        -      spare   /dev/sdo1
      13       8       49        -      spare   /dev/sdd1

# cat /proc/mdstat 
Personalities : [raid6] [raid5] [raid4] 
md0 : active raid6 sdd1[13](S) sdb1[0] sdo1[12](S) sdk1[8] sdi1[7]
sdg1[10] sdj1[9] sdf1[4] sde1[3] sdl1[11] sdh1[6]
      13671797440 blocks super 1.1 level 6, 64k chunk, algorithm 2 [9/8]
[UU_UUUUUU]
      
unused devices: <none>

I'm interpreting this as that a member is missing, but for some reason
the rebuild on sdl1 has not restarted.  What would be the next logical
step to take?  I've found some posts which imply that setting sync_action
to repair will work, but I'm a little wary of doing that without knowing
how risky that is.  Or, reading Documentation/md.txt, perhaps I should
set it to "recover"?  Or "resync", since it's possible the array was not
shut down cleanly?

FWIW, I have started the array, activated the LVM volume, and am running
xfs_repair -n (which is not supposed to do any writes), but otherwise
haven't risked modifying the filesystem (e.g., by mounting it).  So far
the xfs_repair seems fine, and has not reported any errors.

Thanks for your help (and patience).

--keith

-- 
kkeller@wombat.san-francisco.ca.us


