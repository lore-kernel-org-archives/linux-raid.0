From: "Christian Pernegger" <pernegger@gmail.com>
Subject: Help! 3ware 7508-8: i/o errors, now arry not recognized anymore ...
Date: Wed, 12 Mar 2008 17:12:24 +0100
Message-ID: <bb145bd20803120912h3dd1227fk3a88dfc98e1900be@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

First off sorry for the OT post, I figured maybe some of the lurkers
know about hardware RAID, too ...

I was migrating data to the new (md-based) file server when suddenly
some read errors popped up during the copy jobs on the source:

tar: ***: File shrank by 233882532 bytes; padding with zeros
tar: ***: Cannot stat: Input/output error
tar: ***: Cannot stat: Input/output error
...
tar: ***: Cannot stat: No such file or directory
tar: ***: Cannot stat: No such file or directory
...

and in dmesg:

3w-xxxx: scsi4: AEN: WARNING: Sector repair occurred: Port #3.
sd 4:0:0:0: WARNING: Command (0x28) timed out, resetting card.
3w-xxxx: scsi4: AEN drain failed, retrying.
sd 4:0:0:0: scsi: Device offlined - not ready after error recovery
sd 4:0:0:0: scsi: Device offlined - not ready after error recovery
sd 4:0:0:0: scsi: Device offlined - not ready after error recovery
sd 4:0:0:0: scsi: Device offlined - not ready after error recovery
sd 4:0:0:0: rejecting I/O to offline device
sd 4:0:0:0: rejecting I/O to offline device
Buffer I/O error on device sde1, logical block 76218370
lost page write due to I/O error on sde1
sd 4:0:0:0: rejecting I/O to offline device
Buffer I/O error on device sde1, logical block 372670466
lost page write due to I/O error on sde1
sd 4:0:0:0: rejecting I/O to offline device
Buffer I/O error on device sde1, logical block 502595586
lost page write due to I/O error on sde1
sd 4:0:0:0: rejecting I/O to offline device
sd 4:0:0:0: rejecting I/O to offline device
EXT3-fs error (device sde1): ext3_get_inode_loc: unable to read inode
block - inode=490818, block=502595586
Aborting journal on device sde1.
sd 4:0:0:0: rejecting I/O to offline device
Buffer I/O error on device sde1, logical block 132
lost page write due to I/O error on sde1
sd 4:0:0:0: rejecting I/O to offline device
Buffer I/O error on device sde1, logical block 0
lost page write due to I/O error on sde1
EXT3-fs error (device sde1) in ext3_reserve_inode_write: IO failure
sd 4:0:0:0: rejecting I/O to offline device
Buffer I/O error on device sde1, logical block 0
lost page write due to I/O error on sde1
EXT3-fs error (device sde1) in ext3_dirty_inode: IO failure
sd 4:0:0:0: rejecting I/O to offline device
Buffer I/O error on device sde1, logical block 0
lost page write due to I/O error on sde1
sd 4:0:0:0: rejecting I/O to offline device
EXT3-fs error (device sde1): ext3_get_inode_loc: unable to read inode
block - inode=490826, block=502595586
sd 4:0:0:0: rejecting I/O to offline device
Buffer I/O error on device sde1, logical block 0
lost page write due to I/O error on sde1
sd 4:0:0:0: rejecting I/O to offline device
EXT3-fs error (device sde1): ext3_get_inode_loc: unable to read inode
block - inode=490823, block=502595586
sd 4:0:0:0: rejecting I/O to offline device
Buffer I/O error on device sde1, logical block 0
lost page write due to I/O error on sde1
sd 4:0:0:0: rejecting I/O to offline device
EXT3-fs error (device sde1): ext3_get_inode_loc: unable to read inode
block - inode=490819, block=502595586
sd 4:0:0:0: rejecting I/O to offline device
Buffer I/O error on device sde1, logical block 0
lost page write due to I/O error on sde1
sd 4:0:0:0: rejecting I/O to offline device
EXT3-fs error (device sde1): ext3_get_inode_loc: unable to read inode
block - inode=490825, block=502595586
sd 4:0:0:0: rejecting I/O to offline device
sd 4:0:0:0: rejecting I/O to offline device
EXT3-fs error (device sde1): ext3_get_inode_loc: unable to read inode
block - inode=490820, block=502595586
sd 4:0:0:0: rejecting I/O to offline device
sd 4:0:0:0: rejecting I/O to offline device
EXT3-fs error (device sde1): ext3_get_inode_loc: unable to read inode
block - inode=490824, block=502595586
sd 4:0:0:0: rejecting I/O to offline device
sd 4:0:0:0: rejecting I/O to offline device
EXT3-fs error (device sde1): ext3_get_inode_loc: unable to read inode
block - inode=490821, block=502595586
sd 4:0:0:0: rejecting I/O to offline device
sd 4:0:0:0: rejecting I/O to offline device
EXT3-fs error (device sde1): ext3_find_entry: reading directory #72737 offset 0
sd 4:0:0:0: rejecting I/O to offline device
sd 4:0:0:0: rejecting I/O to offline device
EXT3-fs error (device sde1): ext3_find_entry: reading directory #72737 offset 0
sd 4:0:0:0: rejecting I/O to offline device
sd 4:0:0:0: rejecting I/O to offline device
EXT3-fs error (device sde1): ext3_find_entry: reading directory #72737 offset 0
sd 4:0:0:0: rejecting I/O to offline device
sd 4:0:0:0: rejecting I/O to offline device
EXT3-fs error (device sde1): ext3_find_entry: reading directory #72737 offset 0
sd 4:0:0:0: rejecting I/O to offline device
sd 4:0:0:0: rejecting I/O to offline device
EXT3-fs error (device sde1): ext3_find_entry: reading directory #72737 offset 0
sd 4:0:0:0: rejecting I/O to offline device
sd 4:0:0:0: rejecting I/O to offline device
EXT3-fs error (device sde1): ext3_find_entry: reading directory #72737 offset 0
sd 4:0:0:0: rejecting I/O to offline device
sd 4:0:0:0: rejecting I/O to offline device
EXT3-fs error (device sde1): ext3_find_entry: reading directory #72737 offset 0
sd 4:0:0:0: rejecting I/O to offline device
sd 4:0:0:0: rejecting I/O to offline device
EXT3-fs error (device sde1): ext3_find_entry: reading directory #72737 offset 0
sd 4:0:0:0: rejecting I/O to offline device
sd 4:0:0:0: rejecting I/O to offline device
EXT3-fs error (device sde1): ext3_find_entry: reading directory #72737 offset 0
sd 4:0:0:0: rejecting I/O to offline device
sd 4:0:0:0: rejecting I/O to offline device
EXT3-fs error (device sde1): ext3_find_entry: reading directory #72737 offset 0
sd 4:0:0:0: rejecting I/O to offline device
sd 4:0:0:0: rejecting I/O to offline device
EXT3-fs error (device sde1): ext3_find_entry: reading directory #72737 offset 0
sd 4:0:0:0: rejecting I/O to offline device
sd 4:0:0:0: rejecting I/O to offline device
EXT3-fs error (device sde1): ext3_find_entry: reading directory #72737 offset 0
sd 4:0:0:0: rejecting I/O to offline device
sd 4:0:0:0: rejecting I/O to offline device
EXT3-fs error (device sde1): ext3_find_entry: reading directory #72737 offset 0
sd 4:0:0:0: rejecting I/O to offline device
sd 4:0:0:0: rejecting I/O to offline device
EXT3-fs error (device sde1): ext3_find_entry: reading directory #72737 offset 0
sd 4:0:0:0: rejecting I/O to offline device
sd 4:0:0:0: rejecting I/O to offline device
EXT3-fs error (device sde1): ext3_find_entry: reading directory #72737 offset 0
sd 4:0:0:0: rejecting I/O to offline device
sd 4:0:0:0: rejecting I/O to offline device
EXT3-fs error (device sde1): ext3_find_entry: reading directory #72737 offset 0
sd 4:0:0:0: rejecting I/O to offline device
sd 4:0:0:0: rejecting I/O to offline device
EXT3-fs error (device sde1): ext3_find_entry: reading directory #72737 offset 0
sd 4:0:0:0: rejecting I/O to offline device
sd 4:0:0:0: rejecting I/O to offline device
EXT3-fs error (device sde1): ext3_find_entry: reading directory #72737 offset 0
sd 4:0:0:0: rejecting I/O to offline device
sd 4:0:0:0: rejecting I/O to offline device
EXT3-fs error (device sde1): ext3_find_entry: reading directory #72737 offset 0
sd 4:0:0:0: rejecting I/O to offline device
sd 4:0:0:0: rejecting I/O to offline device
EXT3-fs error (device sde1): ext3_find_entry: reading directory #72737 offset 0
sd 4:0:0:0: rejecting I/O to offline device
sd 4:0:0:0: rejecting I/O to offline device
EXT3-fs error (device sde1): ext3_find_entry: reading directory #69857 offset 0
sd 4:0:0:0: rejecting I/O to offline device
sd 4:0:0:0: rejecting I/O to offline device
EXT3-fs error (device sde1): ext3_find_entry: reading directory #69857 offset 0
sd 4:0:0:0: rejecting I/O to offline device
sd 4:0:0:0: rejecting I/O to offline device
ext3_abort called.
EXT3-fs error (device sde1): ext3_journal_start_sb: Detected aborted journal
Remounting filesystem read-only
sd 4:0:0:0: rejecting I/O to offline device
EXT3-fs error (device sde1): ext3_find_entry: reading directory #69857 offset 0
sd 4:0:0:0: rejecting I/O to offline device
printk: 26 messages suppressed.
Buffer I/O error on device sde1, logical block 132
lost page write due to I/O error on sde1

Problem is, it's not just a dead disk. The controller now denies that
there ever was a RAID5 connected to it. tw_cli shows

ports 0,1,2: unused disks
ports 3, 4: JBOD (i.e. two disks passed through to the OS)
ports 5, 6, 7:  unused disks

The copy job was the only access at the time of the crash and that
should have been only reading so maybe some data is still there. If
only I could get the controller to recognize the array ... can't have
zapped the superblocks on all 8 disks, can it?

Thanks,

C.

P.S. The 3ware is an 7506-8 using Debian stable in-kernel driver (2.6.18 IIRC)
