From: Marcin Krol <admin@domeny.pl>
Subject: Deleting mdadm RAID arrays
Date: Tue, 5 Feb 2008 11:42:19 +0100
Message-ID: <200802051142.19625.admin@domeny.pl>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello everyone,

I have had a problem with RAID array (udev messed up disk names, I've had RAID on
disks only, without raid partitions) on Debian Etch server with 6 disks and so I decided 
to rearrange this. 

Deleted the disks from (2 RAID-5) arrays, deleted the md* devices from /dev,
created /dev/sd[a-f]1 Linux raid auto-detect partitions and rebooted the host.

Now the mdadm startup script is writing in loop a message like "mdadm: warning: /dev/sda1 and 
/dev/sdb1 have similar superblocks. If they are not identical, --zero the superblock ... "

The host can't boot up now because of this.

If I boot the server with some disks, I can't even zero that superblock:

% mdadm --zero-superblock /dev/sdb1
mdadm: Couldn't open /dev/sdb1 for write - not zeroing

It's the same even after:

% mdadm --manage /dev/md2 --fail /dev/sdb1
mdadm: set /dev/sdb1 faulty in /dev/md2


Now, I have NEVER created /dev/md2 array, yet it show up automatically!

% cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [raid1]
md2 : active(auto-read-only) raid1 sdb1[1]
      390708736 blocks [3/1] [_U_]

md1 : inactive sda1[2]
      390708736 blocks

unused devices: <none>


Questions:

1. Where this info on array resides?! I have deleted /etc/mdadm/mdadm.conf 
and /dev/md devices and yet it comes seemingly out of nowhere.

2. How can I delete that damn array so it doesn't hang my server up in a loop?


-- 
Marcin Krol

