From: Harland Christofferson <debian-user@zerocrossings.com>
Subject: raid1 with kernel 2.6.9-2-k7
Date: Wed, 05 Jan 2005 20:20:36 -0500
Message-ID: <jUsT.aNoTheR.mEsSaGe.iD.11049747968563@24.45.154.254>
Reply-To: debian-user@zerocrossings.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso8859-1
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I upgraded to 2.6.9-2-k7 on Debian. My raid array does not seem to 
be working:

# cat /proc/mdstat
Personalities : [raid1] 
md0 : inactive
unused devices: <none>

my raidtab file is:

# cat /etc/raidtab 
raiddev /dev/md0
        raid-level      1
        nr-raid-disks   2
        nr-spare-disks  0
        chunk-size     4
        persistent-superblock 1
        device          /dev/hda
        raid-disk       0
        device          /dev/hdc
        raid-disk       1

when i probe w/ mdstat:

# mdadm -D /dev/md0
/dev/md0:
        Version : 00.90.01
  Creation Time : Wed Jan  5 20:14:11 2005
     Raid Level : raid1
    Device Size : 40146560 (38.28 GiB 41.11 GB)
     Raid Disks : 2
    Total Disks : 0
Preferred Minor : 0
    Persistance : Superblock is persistant

    Update Time : Wed Dec 31 19:00:00 1969
          State : dirty, no-errors
  Active Drives : 0
 Working Drives : 0
  Failed Drives : 0
   Spare Drives : 0


    Number   Major   Minor   RaidDisk   State
       0       0        0       -1      removed
       1       0        0       -1      removed

and when i try to mkraid i get:

# mkraid  /dev/md0
handling MD device /dev/md0
analyzing super-block
disk 0: /dev/hda, 40146624kB, raid superblock at 40146560kB
/dev/hda appears to be already part of a raid array -- use -f to
force the destruction of the old superblock
mkraid: aborted, see the syslog and /proc/mdstat for potential clues.

and the kern.log says:

Jan  5 20:14:11 trader kernel: md: could not bd_claim hda.
Jan  5 20:14:11 trader kernel: md: error, md_import_device() returned 
-16


do i have any hope of fixing this? if so, how?!

thanks!

----------------------------------------------------------------------
Zero Crossings, Inc. -- Embedded and Digital Signal Processing Systems

http://www.zerocrossings.com/










