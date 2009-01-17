From: Iain Rauch <groups@email.iain.rauch.co.uk>
Subject: Re: RAID 6 recovery (it's not looking good) *Even More problems*
Date: Sat, 17 Jan 2009 13:13:17 +0000
Message-ID: <C59789ED.C0DF%groups@email.iain.rauch.co.uk>
References: <C594D15A.C070%groups@email.iain.rauch.co.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C594D15A.C070%groups@email.iain.rauch.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: Bernd Schubert <bs@q-leap.de>
List-Id: linux-raid.ids

OK, Now I think I've screwed things up royally.

After cloning the partition of the 1.5TB disk to a replacement 500, it
wouldn't assemble as it had a different UUID.

So I tried assembling with assume clean and the first time I got
mount: /dev/md0: can't read superblock

So I tried a different order and got
mount: Structure needs cleaning

And then trying the first order again I got
mdadm: failed to open /dev/sdp1 after earlier success - aborting

One drive started rebuilding so that must be of no use, one drive is very
dodgy and I wouldn't trust that it has correct data. One drive is the
replacement that got a different UUID somehow. So the problem is there are
three drives that have issues - plus sdp as the above error.

I still haven't formatted the 1.5TB drive if you think that could be of any
use but I'd just like to know if it's time to give up.


Iain


> I finally got the array to a state where it has 24/24 drives up.
> Unfortunately after a copying some data onto it, it now comes up with IO
> errors.
> 
> 
> Please help,
> 
> Iain.
> 
> 
> Here's what I've done so far:
> 
> root@skinner:/# umount /mnt/md0raid
> umount: /mnt/md0raid: device is busy
> umount: /mnt/md0raid: device is busy
> root@skinner:/# fuser -m /mnt/md0raid
> Cannot stat /mnt/md0raid: Input/output error
> Cannot stat /mnt/md0raid: Input/output error
> Cannot stat /mnt/md0raid: Input/output error
> Cannot stat file /proc/9651/fd/4: Input/output error
> root@skinner:/# fuser -m /dev/md0
> Cannot stat file /proc/9651/fd/4: Input/output error
> root@skinner:/# umount -l /mnt/md0raid
> root@skinner:/# xfs_check /dev/md0
> xfs_check: /dev/md0 contains a mounted and writable filesystem
> 
> fatal error -- couldn't initialize XFS library
> root@skinner:/# dmesg | grep -i xfs
> [196225.294919] XFS mounting filesystem md0
> [196226.008338] Ending clean XFS mount for filesystem: md0
> [204347.455334] XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1563 of
> file fs/xfs/xfs_alloc.c.  Caller 0xf8c21e90
> [204347.455374]  [<f8c215eb>] xfs_free_ag_extent+0x53b/0x730 [xfs]
> [204347.455400]  [<f8c21e90>] xfs_free_extent+0xe0/0x110 [xfs]
> [204347.455441]  [<f8c21e90>] xfs_free_extent+0xe0/0x110 [xfs]
> [204347.455503]  [<f8c2d360>] xfs_bmap_finish+0x140/0x190 [xfs]
> [204347.455535]  [<f8c37900>] xfs_bunmapi+0x0/0xfb0 [xfs]
> [204347.455555]  [<f8c55fcf>] xfs_itruncate_finish+0x24f/0x3b0 [xfs]
> [204347.455618]  [<f8c77289>] xfs_inactive+0x469/0x500 [xfs]
> [204347.455660]  [<f8c825e2>] xfs_fs_clear_inode+0x32/0x70 [xfs]
> [204347.455779] xfs_force_shutdown(md0,0x8) called from line 4261 of file
> fs/xfs/xfs_bmap.c.  Return address = 0xf8c82fec
> 
> root@skinner:/# xfs_repair -n /dev/md0
> xfs_repair: /dev/md0 contains a mounted and writable filesystem
> 
> fatal error -- couldn't initialize XFS library
> root@skinner:/# xfs_repair -fn /dev/md0
>         - creating 2 worker thread(s)
> Phase 1 - find and verify superblock...
>         - reporting progress in intervals of 15 minutes
> Phase 2 - using internal log
>         - scan filesystem freespace and inode maps...
>         - 01:52:55: scanning filesystem freespace - 118 of 118 allocation
> groups done
>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan (but don't clear) agi unlinked lists...
>         - 01:52:55: scanning agi unlinked lists - 118 of 118 allocation
> groups done
>         - process known inodes and perform inode discovery...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
> data fork in ino 1075468390 claims free block 838867328
> <snip>
> data fork in ino 1075468390 claims free block 838867811
>         - agno = 4
> bad nblocks 1863041 for inode 2147484215, would reset to 1898317
>         - agno = 5
>         - agno = 6
>         - agno = 7
> data fork in ino 3221610517 claims free block 3623910585
> imap claims in-use inode 3221610517 is free, would correct imap
>         - agno = 8
> <snip>
>         - agno = 117
> data fork in ino 3758128252 claims free block 2952790138
> data fork in ino 3758128252 claims free block 2952790139
> imap claims in-use inode 3758128252 is free, would correct imap
>         - 02:02:39: process known inodes and inode discovery - 55360 of
> 55360 inodes done
>         - process newly discovered inodes...
>         - 02:02:39: process newly discovered inodes - 118 of 118 allocation
> groups done
> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
>         - 02:06:26: setting up duplicate extent list - 24 of 118 allocation
> groups done
>     - 02:06:26: Phase 4: elapsed time 3 minutes, 47 seconds - processed 6
> allocation groups per minute
>     - 02:06:26: Phase 4: 20% done - estimated remaining time 14 minutes, 49
> seconds
>         - 02:21:26: setting up duplicate extent list - 75 of 118 allocation
> groups done
>     - 02:21:26: Phase 4: elapsed time 18 minutes, 47 seconds - processed 3
> allocation groups per minute
>     - 02:21:26: Phase 4: 63% done - estimated remaining time 10 minutes, 46
> seconds
>         - 02:36:26: setting up duplicate extent list - 104 of 118 allocation
> groups done
>     - 02:36:26: Phase 4: elapsed time 33 minutes, 47 seconds - processed 3
> allocation groups per minute
>     - 02:36:26: Phase 4: 88% done - estimated remaining time 4 minutes, 32
> seconds
>         - 02:42:59: setting up duplicate extent list - 118 of 118 allocation
> groups done
>         - 02:51:26: setting up duplicate extent list - 118 of 118 allocation
> groups done
>     - 02:51:26: Phase 4: elapsed time 48 minutes, 47 seconds - processed 2
> allocation groups per minute
>     - 02:51:26: Phase 4: 100% done - estimated remaining time
>         - 03:06:26: setting up duplicate extent list - 118 of 118 allocation
> groups done
>     - 03:06:26: Phase 4: elapsed time 1 hour, 3 minutes, 47 seconds -
> processed 1 allocation groups per minute
>     - 03:06:26: Phase 4: 100% done - estimated remaining time
>         - 03:21:27: setting up duplicate extent list - 118 of 118 allocation
> groups done
>     - 03:21:27: Phase 4: elapsed time 1 hour, 18 minutes, 48 seconds -
> processed 1 allocation groups per minute
>     - 03:21:27: Phase 4: 100% done - estimated remaining time
>         - 03:36:26: setting up duplicate extent list - 118 of 118 allocation
> groups done
>     - 03:36:26: Phase 4: elapsed time 1 hour, 33 minutes, 47 seconds -
> processed 1 allocation groups per minute
>     - 03:36:26: Phase 4: 100% done - estimated remaining time
>         - 03:51:26: setting up duplicate extent list - 118 of 118 allocation
> groups done
>     - 03:51:26: Phase 4: elapsed time 1 hour, 48 minutes, 47 seconds -
> processed 1 allocation groups per minute
>     - 03:51:26: Phase 4: 100% done - estimated remaining time
>         - check for inodes claiming duplicate blocks...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - 04:06:26: check for inodes claiming duplicate blocks - 12480 of
> 55360 inodes done
>     - 04:06:26: Phase 4: elapsed time 2 hours, 3 minutes, 47 seconds -
> processed 100 inodes per minute
>     - 04:06:26: Phase 4: 22% done - estimated remaining time 7 hours, 5
> minutes, 18 seconds
>         - agno = 3
> entry ":2eDS_Store" at block 0 offset 72 in directory inode 1073752707
> references free inode 1073752709
>     would clear inode number in entry at offset 72...
> entry ":2eDS_Store" at block 0 offset 72 in directory inode 1073752708
> references free inode 1073753109
>     would clear inode number in entry at offset 72...
> entry ":2epar_done" at block 0 offset 72 in directory inode 1073753094
> references free inode 1073753095
>     would clear inode number in entry at offset 72...
>         - agno = 4
> bad nblocks 1863041 for inode 2147484215, would reset to 1898317
>         - 04:21:26: check for inodes claiming duplicate blocks - 23744 of
> 55360 inodes done
>     - 04:21:26: Phase 4: elapsed time 2 hours, 18 minutes, 47 seconds -
> processed 171 inodes per minute
>     - 04:21:26: Phase 4: 42% done - estimated remaining time 3 hours, 4
> minutes, 47 seconds
>         - agno = 5
>         - agno = 6
> entry ":2eDS_Store" at block 0 offset 72 in directory inode 3221234251
> references free inode 3221234252
>     would clear inode number in entry at offset 72...
> entry ":2epar_done" at block 0 offset 96 in directory inode 3221234251
> references free inode 3221234253
>     would clear inode number in entry at offset 96...
>         - 04:36:26: check for inodes claiming duplicate blocks - 39360 of
> 55360 inodes done
>     - 04:36:26: Phase 4: elapsed time 2 hours, 33 minutes, 47 seconds -
> processed 255 inodes per minute
>     - 04:36:26: Phase 4: 71% done - estimated remaining time 1 hour, 2
> minutes, 30 seconds
>         - agno = 7
>         - agno = 117
>         - 04:51:26: check for inodes claiming duplicate blocks - 49664 of
> 55360 inodes done
>     - 04:51:26: Phase 4: elapsed time 2 hours, 48 minutes, 47 seconds -
> processed 294 inodes per minute
>     - 04:51:26: Phase 4: 89% done - estimated remaining time 19 minutes, 21
> seconds
>         - 04:59:54: check for inodes claiming duplicate blocks - 55360 of
> 55360 inodes done
> No modify flag set, skipping phase 5
> Phase 6 - check inode connectivity...
>         - traversing filesystem starting at / ...
> entry ":2eDS_Store" in directory inode 1073752707 points to free inode
> 1073752709, would junk entry
> entry ":2eDS_Store" in directory inode 1073752708 points to free inode
> 1073753109, would junk entry
> entry ":2epar_done" in directory inode 1073753094 points to free inode
> 1073753095, would junk entry
> entry ":2eDS_Store" in directory inode 3221234251 points to free inode
> 3221234252, would junk entry
> entry ":2epar_done" in directory inode 3221234251 points to free inode
> 3221234253, would junk entry
>         - 05:02:01: traversing filesystem - 118 of 118 allocation groups
> done
>         - traversal finished ...
>         - traversing all unattached subtrees ...
>         - traversals finished ...
>         - moving disconnected inodes to lost+found ...
> disconnected inode 3758128252, would move to lost+found
> Phase 7 - verify link counts...
>         - 05:02:05: verify link counts - 55360 of 55360 inodes done
> No modify flag set, skipping filesystem flush and exiting.
> root@skinner:/# 
> 
> Syslog has got lots of these:
> 
> Jan 15 00:01:45 skinner kernel: [203766.124587] SCSI device sdd: 976773168
> 512-byte hdwr sectors (500108 MB)
> Jan 15 00:01:45 skinner kernel: [203766.132971] sdd: Write Protect is off
> Jan 15 00:01:45 skinner kernel: [203766.132976] sdd: Mode Sense: 00 3a 00 00
> Jan 15 00:01:45 skinner kernel: [203766.134301] SCSI device sdd: write
> cache: enabled, read cache: enabled, doesn't support DPO or FUA
> Jan 15 00:01:58 skinner kernel: [203780.291734] ata17.00: exception Emask
> 0x10 SAct 0x0 SErr 0x90000 action 0x2 frozen
> Jan 15 00:01:58 skinner kernel: [203780.291763] ata17.00: cmd
> c8/00:20:5f:24:7b/00:00:00:00:00/e2 tag 0 cdb 0x0 data 16384 in
> Jan 15 00:01:58 skinner kernel: [203780.291765]          res
> ff/ff:ff:ff:ff:ff/d0:d0:d0:d0:d0/ff Emask 0x12 (ATA bus error)
> Jan 15 00:01:58 skinner kernel: [203780.292896] ata17: hard resetting port
> Jan 15 00:01:59 skinner kernel: [203781.551363] ata17: COMRESET failed
> (device not ready)
> Jan 15 00:01:59 skinner kernel: [203781.551404] ata17: hardreset failed,
> retrying in 5 secs
> Jan 15 00:02:04 skinner kernel: [203786.548252] ata17: hard resetting port
> Jan 15 00:02:05 skinner kernel: [203787.427001] ata17: SATA link up 1.5 Gbps
> (SStatus 113 SControl 310)
> Jan 15 00:02:06 skinner kernel: [203787.443227] ata17.00: configured for
> UDMA/33
> Jan 15 00:02:06 skinner kernel: [203787.443238] ata17: EH complete
> 
> Syslog around when it happened:
> 
> Jan 15 00:11:15 skinner kernel: [204335.803986] SCSI device sde: write
> cache: enabled, read cache: enabled, doesn't support DPO or FUA
> Jan 15 00:11:15 skinner kernel: [204336.338284] raid5:md0: read error
> corrected (8 sectors at 58272000 on sde1)
> Jan 15 00:11:15 skinner kernel: [204336.338290] raid5:md0: read error
> corrected (8 sectors at 58272008 on sde1)
> Jan 15 00:11:15 skinner afpd[9470]: 3214789.36KB read, 6901.94KB written
> Jan 15 00:11:15 skinner afpd[9470]: dsi_stream_write: Broken pipe
> Jan 15 00:11:15 skinner afpd[9470]: Connection terminated
> Jan 15 00:11:15 skinner afpd[9651]: Warning: No CNID scheme for volume
> /mnt/md0raid/. Using default.
> Jan 15 00:11:15 skinner afpd[9651]: Setting uid/gid to 0/0
> Jan 15 00:11:15 skinner afpd[9651]: CNID DB initialized using Sleepycat
> Software: Berkeley DB 4.2.52: (December  3, 2003)
> Jan 15 00:11:17 skinner afpd[5506]: server_child[1] 9470 exited 1
> Jan 15 00:11:17 skinner afpd[9651]: ipc_write: command: 2, pid: 9651,
> msglen: 24
> Jan 15 00:11:17 skinner afpd[5506]: ipc_read: command: 2, pid: 9651, len: 24
> Jan 15 00:11:17 skinner afpd[5506]: Setting clientid (len 16) for 9651,
> boottime 496E72CC
> Jan 15 00:11:17 skinner afpd[5506]: ipc_get_session: len: 24, idlen 16, time
> 496e72cc
> Jan 15 00:11:17 skinner afpd[9651]: ipc_write: command: 2, pid: 9651,
> msglen: 24
> Jan 15 00:11:17 skinner afpd[5506]: ipc_read: command: 2, pid: 9651, len: 24
> Jan 15 00:11:17 skinner afpd[5506]: Setting clientid (len 16) for 9651,
> boottime 496E72CC
> Jan 15 00:11:17 skinner afpd[5506]: ipc_get_session: len: 24, idlen 16, time
> 496e72cc
> Jan 15 00:11:17 skinner afpd[9653]: ASIP session:548(5) from
> 192.168.0.2:49345(8)
> Jan 15 00:11:17 skinner afpd[5506]: server_child[1] 9653 done
> Jan 15 00:11:26 skinner kernel: [204347.455334] XFS internal error
> XFS_WANT_CORRUPTED_GOTO at line 1563 of file fs/xfs/xfs_alloc.c.  Caller
> 0xf8c21e90
> Jan 15 00:11:26 skinner kernel: [204347.455374]  [pg0+947631595/1069122560]
> xfs_free_ag_extent+0x53b/0x730 [xfs]
> Jan 15 00:11:26 skinner kernel: [204347.455400]  [pg0+947633808/1069122560]
> xfs_free_extent+0xe0/0x110 [xfs]
> Jan 15 00:11:26 skinner kernel: [204347.455441]  [pg0+947633808/1069122560]
> xfs_free_extent+0xe0/0x110 [xfs]
> Jan 15 00:11:26 skinner kernel: [204347.455503]  [pg0+947680096/1069122560]
> xfs_bmap_finish+0x140/0x190 [xfs]
> Jan 15 00:11:26 skinner kernel: [204347.455535]  [pg0+947722496/1069122560]
> xfs_bunmapi+0x0/0xfb0 [xfs]
> Jan 15 00:11:26 skinner kernel: [204347.455555]  [pg0+947847119/1069122560]
> xfs_itruncate_finish+0x24f/0x3b0 [xfs]
> Jan 15 00:11:26 skinner kernel: [204347.455618]  [pg0+947982985/1069122560]
> xfs_inactive+0x469/0x500 [xfs]
> Jan 15 00:11:26 skinner kernel: [204347.455645]  [mutex_lock+8/32]
> mutex_lock+0x8/0x20
> Jan 15 00:11:26 skinner kernel: [204347.455660]  [pg0+948028898/1069122560]
> xfs_fs_clear_inode+0x32/0x70 [xfs]
> Jan 15 00:11:26 skinner kernel: [204347.455679]  [dentry_iput+132/144]
> dentry_iput+0x84/0x90
> Jan 15 00:11:26 skinner kernel: [204347.455688]  [clear_inode+159/336]
> clear_inode+0x9f/0x150
> Jan 15 00:11:26 skinner kernel: [204347.455691]
> [truncate_inode_pages+23/32] truncate_inode_pages+0x17/0x20
> Jan 15 00:11:26 skinner kernel: [204347.455698]
> [generic_delete_inode+234/256] generic_delete_inode+0xea/0x100
> Jan 15 00:11:26 skinner kernel: [204347.455704]  [iput+86/112]
> iput+0x56/0x70
> Jan 15 00:11:26 skinner kernel: [204347.455709]  [do_unlinkat+238/336]
> do_unlinkat+0xee/0x150
> Jan 15 00:11:26 skinner kernel: [204347.455747]  [syscall_call+7/11]
> syscall_call+0x7/0xb
> Jan 15 00:11:26 skinner kernel: [204347.455775]  =======================
> Jan 15 00:11:26 skinner kernel: [204347.455779] xfs_force_shutdown(md0,0x8)
> called from line 4261 of file fs/xfs/xfs_bmap.c.  Return address =
> 0xf8c82fec
> Jan 15 00:11:26 skinner kernel: [204347.520962] Filesystem "md0": Corruption
> of in-memory data detected.  Shutting down filesystem: md0
> Jan 15 00:11:26 skinner kernel: [204347.520989] Please umount the
> filesystem, and rectify the problem(s)
> 
> sdc seems to have had a few erros hourly or so before this happened
>   (ATA Error Count: 104)
> sdd doesn't have any SMART errors.
> sde shows Spin_Up_Time: 8320, last error at disk power-on lifetime: 56 hours
> In fact quite a few disks seem to have had non fatal errors recently.
> 
> 
>> On Fri, Dec 19, 2008 at 12:29:30PM +0000, Iain Rauch wrote:
>>>> I'm still tired (now even more ;-) ). Just check again if /dev/sdu really
>>>> was the latest to fail and if so, clone this one.
>>>> I also suggest to reassemble it without an immediate raid-rebuild.
>>>> First check your data and only then add a new drives to the raid.
>>>> Once you start a raid-rebuild.
>>>> there is no way to go back. We recently also had the problem of three
>>>> failed disks  but we only could get back the data by not assembling the
>>>> array with the latest failed disk, but with the 2nd latest (don't ask why).
>>>> 
>>>> So in short
>>>> 
>>>> 1) clone disk
>>>> 
>>>> 2) mdadm --assemble --force /dev/mdX /dev/sda1 /dev/sdb1 ... /dev/sdx1
>>>> 
>>>> ===> Use only **22** devices here.
>>>> 
>>>> 3) Mount and check data, maybe even a read-only fsck
>>>> 
>>>> 4) Add two new disks.
>>>> 
>>>> 
>>>> Hope it helps,
>>>> Bernd
>>> 
>>> Well I cloned the disk and force started the array with 22 drives. I mounted
>>> the file system read-only and it did appear to be intact :)
>> 
>> I'm glad to hear that.
>> 
>>> 
>>> The problem is I cloned the failed drive to a 1.5TB Seagate, and it has the
>>> freezing issue. After 12h of rebuilding (out of 50) that drive got kicked.
>>> I'm gonna see if updating the FW on the drive helps, but otherwise I'll just
>>> have to get another decent drive.
>>> 
>>> Is there any way to have mdadm be more patient and not kick the drive, or
>>> let me put it back in and continue the rebuild of another drive? I don't
>>> believe the drive will operate for 50h straight.
>> 
>> I think this would continue the rebuild if you would use bitmaps. You may
>> add bitmaps by using "mdadm --grow --bitmap=internal /dev/mdX", but I'm not
>> sure if it will work on a degrade md device. At least it won't work during
>> rebuild phase.
>> 
>> Cheers,
>> Bernd
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


