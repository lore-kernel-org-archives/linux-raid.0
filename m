From: Vladimir Trebicky <trebicky@xhost.cz>
Subject: Ext3 inconsistencies
Date: Tue, 19 Aug 2003 18:17:20 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <12932735343.20030819181720@xhost.cz>
Reply-To: =?ISO-8859-2?B?VmxhZGlt7XIgVPhlYmlja/0=?= <trebicky@xhost.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

   recently, I did a e2fsck -nf /dev/md0 (running ext3 rootfs 1GB).
   I have some    disturbing messages that I wish to discuss and ask
   whether it has something to do with my RAID1:

many many many many lines like this one:
Illegal block #13 (1951605306) in inode 31988.  IGNORED.
...
Inode 1666, i_size is 2977903, should be 3895296.  Fix? no
Inode 1666, i_blocks is 5832, should be 184.  Fix? no
Inode 2795 has illegal block(s).  Clear? no
Deleted inode 17419 has zero dtime.  Fix? no
Error while iterating over blocks in inode 32049: Illegal indirect block found

I also did e2fsck -nf /dev/md1 (ext3 storage 37GB):

Inodes that were part of a corrupted orphan linked list found.  Fix? no
Inode 833967 was part of the orphaned inode list.  IGNORED.
Deleted inode 833969 has zero dtime.  Fix? no
Block bitmap differences:  -(130932--130933) -1671850
-(1671852--1671921)...
...
Free blocks count wrong for group #3 (18820, counted=18818).
Free blocks count wrong (8555707, counted=8555705).
Inode bitmap differences:  -833967 -833969
Directories count wrong for group #51 (13, counted=12).

I would like to ask which of the messages are critical? What means
IGNORED? Why I have so many (!) Illegal blocks (Ignored)? I'm afraid
to do real e2fsck (readwrite) until I know whether it is safe and
wheter I won't lose any data.

-- 
Thanks for help,
 Vladimir Trebicky                          mailto:trebicky@xhost.cz

