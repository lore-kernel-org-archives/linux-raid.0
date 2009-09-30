From: sidmanm <sidmanm@yahoo.com>
Subject: Cannnot umount to fix a corrupted Superblock on Buffalo Terastation
 (Linux) RAID 5
Date: Tue, 29 Sep 2009 19:50:18 -0700 (PDT)
Message-ID: <25674181.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I suspect that I have a corrupted Superblock, but am stuck with what I can do
next....I have a Buffalo Terastation Pro that runs on Linux.  I tried to run
xfs_repair, but xfs_repair wants me to umount; umount is busy, and am
hesitant to umount -F....any guidance is greatly appreciated.

Here's the log from my telnet session:

TS-TGLE79 login: myroot
root@TS-TGLE79:~# xfs_repair /dev/md1
xfs_repair: warning - cannot get sector size from block device /dev/md1:
Invalid argument
Phase 1 - find and verify superblock...
sb root inode value 18446744073709551615 (NULLFSINO) inconsistent with
calculated value 256
resetting superblock root inode pointer to 256
sb realtime bitmap inode 18446744073709551615 (NULLFSINO) inconsistent with
calculated value 257
resetting superblock realtime bitmap ino pointer to 257
sb realtime summary inode 18446744073709551615 (NULLFSINO) inconsistent with
calculated value 258
resetting superblock realtime summary ino pointer to 258
Phase 2 - using internal log
- zero log...
ERROR: The filesystem has valuable metadata changes in a log which needs to
be replayed. Mount the filesystem to replay the log, and unmount it before
re-running xfs_repair. If you are unable to mount the filesystem, then use
the -L option to destroy the log and attempt a repair.
Note that destroying the log may cause corruption -- please attempt a mount
of the filesystem before doing this.

root@TS-TGLE79:~# mount
/dev/md0 on / type auto (rw,noatime)
proc on /proc type proc (rw)
/dev/shm on /mnt/ram type tmpfs (rw,mode=1777,size=15m)
/dev/ram1 on /tmp type ext2 (rw)
devpts on /dev/pts type devpts (rw,gid=5,mode=620)
/proc/bus/usb on /proc/bus/usb type usbdevfs (rw)

root@TS-TGLE79:~# umount /dev/md0
umount: /: device is busy

Any guidance is greatly appreciated.

Kind thanks,

Michael
-- 
View this message in context: http://www.nabble.com/Cannnot-umount-to-fix-a-corrupted-Superblock-on-Buffalo-Terastation-%28Linux%29-RAID-5-tp25674181p25674181.html
Sent from the linux-raid mailing list archive at Nabble.com.

