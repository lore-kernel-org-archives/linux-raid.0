From: raincatsdogs@me.com
Subject: inactive device
Date: Wed, 15 Dec 2010 14:20:37 +0100
Message-ID: <C7BDC8B0-E26E-4E42-9D71-DF90C4A80784@me.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

My name is Paolo from Italy (bad english)
I am not subscribed to the list

I am using a Ubuntu 10.04 x64 desktop and try to create a raid1 with a couple of disk.
After the removal of the super block from the 2 discs (--zero-superblock) I assembled the raid with the command
"mdadm --create --auto=md -b internal --symlink=no -l raid1 -n2 --force /dev/md0 /dev/sdc /dev/sdd"
My intention is not to partition the raid (md_d0p1, md_d0p2, etc..); does not create links to the disks in /etc, and finally have the bitmap in order to accelerate the reconstruction.
After launching the command, the construction is done and the raid is completed. Format the new device /dev/md0 and everything works.

After rebooting the operating system the problem start.
1.Mdstat reports:
paolo@machiavelli:~$ cat /proc/mdstat 
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
md_d0 : inactive sdd[1](S)
      312571136 blocks

2.and in /etc I find the device md0 partitioned into 4: md_d0p1, md_d0p2,md_d0p3,md_d0p4

I do not understand why then the device /dev/md0 became /dev/md_d0, despite the command --auto=md
also do not understand why the device md_d0 is inactive and mdstat shows a (S) (I can not find documentation about this symbol)

It seems that the options "--auto=md --symlink=no" wonts work!
Or maybe the mdadm command syntax is wrong?
Thanks
