From: NeilBrown <neilb@suse.de>
Subject: Re: raid device gets read-only
Date: Fri, 21 Jan 2011 22:50:30 +1100
Message-ID: <20110121225030.4a4c6868@notabene.brown>
References: <20110121100351.GC29627@udo>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110121100351.GC29627@udo>
Sender: linux-raid-owner@vger.kernel.org
To: Udo Hortian <udo_hortian@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 21 Jan 2011 11:03:51 +0100 Udo Hortian <udo_hortian@web.de> wrote:

> Hello,
> 
> I am using Linux software RAID since years and without problems so far.
> Not I got a problem on a system using a RAID 1 as its root filesystem.
> 
> Normally, there is only little IO-access on the machine. Recently, I tried
> to delete many files (about 5 GB) and the rm command did not had
> success. Some files were deleted, but then it complained the filesystem
> being read-only (which it was not before). dmesg tells me the
> following:
> 
> [4138404.185508] EXT3-fs error (device md1): ext3_free_blocks_sb: bit
> already cleared for block 6637603
> [4138404.185594] Aborting journal on device md1.
> [4138404.188665] ext3_abort called.
> [4138404.188716] EXT3-fs error (device md1): ext3_journal_start_sb:
> Detected aborted journal
> [4138404.188780] Remounting filesystem read-only
> [4138404.210977] Remounting filesystem read-only
> [4138404.211852] EXT3-fs error (device md1) in ext3_free_blocks_sb:
> Journal has aborted
> [4138404.211974] EXT3-fs error (device md1) in ext3_free_blocks_sb:
> Journal has aborted
> [4138404.212035] EXT3-fs error (device md1) in ext3_reserve_inode_write:
> Journal has aborted
> [4138404.212085] EXT3-fs error (device md1) in ext3_truncate: Journal
> has aborted
> [4138404.212134] EXT3-fs error (device md1) in ext3_reserve_inode_write:
> Journal has aborted
> [4138404.212183] EXT3-fs error (device md1) in ext3_orphan_del: Journal
> has aborted
> [4138404.212231] EXT3-fs error (device md1) in ext3_reserve_inode_write:
> Journal has aborted
> [4138404.234253] __journal_remove_journal_head: freeing b_committed_data
> [4138404.234313] __journal_remove_journal_head: freeing
> b_committed_data[4138404.234354] __journal_remove_journal_head: freeing
> b_committed_data
> [4138404.234414] __journal_remove_journal_head: freeing
> b_committed_data[4138544.649154] ext3_abort called.
> [4138544.649202] EXT3-fs error (device md1): ext3_remount: Abort forced
> by user[4138551.221721] ext3_abort called.
> [4138551.221774] EXT3-fs error (device md1): ext3_remount: Abort forced
> by user[4138551.224418] ext3_abort called.
> [4138551.224466] EXT3-fs error (device md1): ext3_remount: Abort forced
> by user
> 
> It looks like an ext3 problem and I am not sure about the reason. Why I
> am posting to this list of the following: I tried to remount the
> filesystem in rw-mode, but it failed with the following error:
> 
> # mount -t ext3 -o remount,rw /dev/md1 /
> mount: block device /dev/md1 is write-protected, mounting read-only

This message is slightly misleading.
When ext3 detects an error and makes the filesystem read-only it also marks
the file system as having an error and any subsequent attempt to remount,rw
will failed with this error.

You need to unmount and fsck to fix this.  Obviously you cannot do that with
'/', but if you reboot it will automatically fsck and fix things up for you.

NeilBrown



> 
> So I am asking myself, why /dev/md1 got write-protected.
> 
> Concerning the raid-device I can provide the following information:
> 
> # mdadm --detail /dev/md1
> /dev/md1:
>         Version : 00.90
>   Creation Time : Sat Aug 16 13:00:01 2008
>      Raid Level : raid1
>      Array Size : 39070016 (37.26 GiB 40.01 GB)
>   Used Dev Size : 39070016 (37.26 GiB 40.01 GB)
>    Raid Devices : 2
>   Total Devices : 2
> Preferred Minor : 1
>     Persistence : Superblock is persistent
> 
>     Update Time : Thu Jan 20 21:52:13 2011
>           State : clean
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
> 
>            UUID : 109aa1d3:714fc116:8dd4536c:05742218
>          Events : 0.74
> 
>     Number   Major   Minor   RaidDevice State
>        0       3        3        0      active sync   /dev/hda3
>        1      22        3        1      active sync   /dev/hdc3
> 
> 
> # ls -l /dev/md1
> brw-rw---- 1 root disk 9, 1 2011-01-20 21:41 /dev/md1
> 
> As far as I can tell, this looks normal. Also, I did not see any problems concerning the underlying devices in dmesg.
> 
> Can anyone give hints what is going wrong here? 
> 
> Best,
> Udo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

