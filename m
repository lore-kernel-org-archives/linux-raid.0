From: BillStuff <billstuff2001@sbcglobal.net>
Subject: Re: Raid5 hang in 3.14.19
Date: Sun, 05 Oct 2014 11:05:08 -0500
Message-ID: <54316C34.6090304@sbcglobal.net>
References: <5425E9D6.1050102@sbcglobal.net>	<20140929122533.3b91a543@notabene.brown>	<5428D863.7090409@sbcglobal.net>	<20140929140818.1086972e@notabene.brown>	<5428DFE1.9080600@sbcglobal.net>	<20140930075950.1d1e3865@notabene.brown>	<542B1EDC.7060803@sbcglobal.net> <20141001085409.41399b13@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141001085409.41399b13@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09/30/2014 05:54 PM, NeilBrown wrote:
> [removed alot of stuff about raid5 check hanging]
> Thanks for the testing!  You have included enough information.
> I didn't really like that 'sync_starting' variable when I wrote the patch,
> but it seemed do the right thing.  It doesn't.
>
> If md_check_recovery() runs again immediately after scheduling the sync
> thread to run, it will not have set sync_starting but will find ->sync_thread
> is NULL and so will clear MD_RECOVERY_RUNNING.  The next time it runs, that
> flag is still clear and ->sync_thread is not NULL so it will try to stop the
> thread, which deadlocks.
>
> This patch on top of what you have should fix it... but I might end up
> redoing the logic a bit.
>
Neil,

With the second patch, my test has been running well for close to 5 days 
now,
but something odd happened yesterday.

It's on a raid1 array (md1) with both ext3 and xfs on LVM, but I suspect 
it happened silently on my
raid5 test also.

md1 : active raid1 sdh3[0] sdg3[1]
       76959296 blocks [2/2] [UU]
       [=>...................]  check =  9.7% (7532800/76959296) 
finish=108.8min speed=10628K/sec
       bitmap: 0/1 pages [0KB], 65536KB chunk



Again this is running kernel builds, read / write loops, and remove/ 
(re)add / check loops.
At some point while removing a disk from the array, something bad 
happened, the errors below
appeared in the log, and the ext3 filesystem remounted readonly. xfs 
plowed right on through.
There's no evidence of any read or write errors to the member disks, 
either in logs or on the
disks themselves, and the raid1 checks came back with zero mismatches. 
fsck for the ext3 fs
complained a lot but the filesystem came back into a useable state and 
I've restarted my tests.
Below, dm-3 is xfs, dm-1 is ext3. The interesting stuff happens around 
12:27:04. This was
immediately after (or during?) removing sdh3 from md1.

Oct  4 12:26:01 xplane kernel: md: unbind<sdg3>
Oct  4 12:26:01 xplane kernel: md: export_rdev(sdg3)
Oct  4 12:26:11 xplane kernel: md: bind<sdg3>
Oct  4 12:26:11 xplane kernel: RAID1 conf printout:
Oct  4 12:26:11 xplane kernel:  --- wd:1 rd:2
Oct  4 12:26:11 xplane kernel:  disk 0, wo:0, o:1, dev:sdh3
Oct  4 12:26:11 xplane kernel:  disk 1, wo:1, o:1, dev:sdg3
Oct  4 12:26:12 xplane kernel: md: recovery of RAID array md1
Oct  4 12:26:12 xplane kernel: md: minimum _guaranteed_  speed: 10000 
KB/sec/disk.
Oct  4 12:26:12 xplane kernel: md: using maximum available idle IO 
bandwidth (but not more than 200000 KB/sec) for recovery.
Oct  4 12:26:12 xplane kernel: md: using 128k window, over a total of 
76959296k.
Oct  4 12:27:03 xplane kernel: md: md1: recovery done.
Oct  4 12:27:03 xplane kernel: RAID1 conf printout:
Oct  4 12:27:03 xplane kernel:  --- wd:2 rd:2
Oct  4 12:27:03 xplane kernel:  disk 0, wo:0, o:1, dev:sdh3
Oct  4 12:27:03 xplane kernel:  disk 1, wo:0, o:1, dev:sdg3
Oct  4 12:27:04 xplane kernel: md/raid1:md1: Disk failure on sdh3, 
disabling device.
Oct  4 12:27:04 xplane kernel: md/raid1:md1: Operation continuing on 1 
devices.
Oct  4 12:27:05 xplane kernel: quiet_error: 912 callbacks suppressed
Oct  4 12:27:05 xplane kernel: Buffer I/O error on device dm-3, logical 
block 6331468
Oct  4 12:27:05 xplane kernel: lost page write due to I/O error on dm-3
Oct  4 12:27:05 xplane kernel: Buffer I/O error on device dm-3, logical 
block 6331469
Oct  4 12:27:05 xplane kernel: lost page write due to I/O error on dm-3
Oct  4 12:27:05 xplane kernel: Buffer I/O error on device dm-3, logical 
block 6331470
Oct  4 12:27:05 xplane kernel: lost page write due to I/O error on dm-3
Oct  4 12:27:05 xplane kernel: Buffer I/O error on device dm-3, logical 
block 6331471
Oct  4 12:27:05 xplane kernel: lost page write due to I/O error on dm-3
Oct  4 12:27:05 xplane kernel: Buffer I/O error on device dm-3, logical 
block 6331472
Oct  4 12:27:05 xplane kernel: lost page write due to I/O error on dm-3
Oct  4 12:27:05 xplane kernel: Buffer I/O error on device dm-3, logical 
block 6331473
Oct  4 12:27:05 xplane kernel: lost page write due to I/O error on dm-3
Oct  4 12:27:05 xplane kernel: Buffer I/O error on device dm-3, logical 
block 6331474
Oct  4 12:27:05 xplane kernel: lost page write due to I/O error on dm-3
Oct  4 12:27:05 xplane kernel: Buffer I/O error on device dm-3, logical 
block 6331475
Oct  4 12:27:05 xplane kernel: lost page write due to I/O error on dm-3
Oct  4 12:27:05 xplane kernel: Buffer I/O error on device dm-3, logical 
block 6331476
Oct  4 12:27:05 xplane kernel: lost page write due to I/O error on dm-3
Oct  4 12:27:05 xplane kernel: Buffer I/O error on device dm-3, logical 
block 6331477
Oct  4 12:27:05 xplane kernel: lost page write due to I/O error on dm-3
Oct  4 12:27:05 xplane kernel: Aborting journal on device dm-1.
Oct  4 12:27:05 xplane kernel: EXT3-fs (dm-1): error in ext3_new_blocks: 
Journal has aborted
Oct  4 12:27:05 xplane kernel: EXT3-fs (dm-1): error: 
ext3_journal_start_sb: Detected aborted journal
Oct  4 12:27:05 xplane kernel: EXT3-fs (dm-1): error: remounting 
filesystem read-only
Oct  4 12:27:05 xplane kernel: EXT3-fs (dm-1): error: 
ext3_journal_start_sb: Detected aborted journal
Oct  4 12:27:05 xplane kernel: EXT3-fs (dm-1): error in 
ext3_writeback_write_end: IO failure
Oct  4 12:27:05 xplane kernel: EXT3-fs (dm-1): error in ext3_new_inode: 
Journal has aborted
Oct  4 12:27:05 xplane kernel: EXT3-fs (dm-1): error in ext3_new_inode: 
Journal has aborted
Oct  4 12:27:05 xplane kernel: EXT3-fs (dm-1): error in ext3_orphan_add: 
Journal has aborted
Oct  4 12:27:05 xplane kernel: EXT3-fs (dm-1): error in ext3_new_inode: 
Journal has aborted
Oct  4 12:27:05 xplane kernel: EXT3-fs (dm-1): error in ext3_new_inode: 
Journal has aborted
Oct  4 12:27:05 xplane kernel: EXT3-fs (dm-1): error in 
ext3_dirty_inode: IO failure
Oct  4 12:27:05 xplane kernel: RAID1 conf printout:
Oct  4 12:27:05 xplane kernel:  --- wd:1 rd:2
Oct  4 12:27:05 xplane kernel:  disk 0, wo:1, o:0, dev:sdh3
Oct  4 12:27:05 xplane kernel:  disk 1, wo:0, o:1, dev:sdg3
Oct  4 12:27:05 xplane kernel: RAID1 conf printout:
Oct  4 12:27:05 xplane kernel:  --- wd:1 rd:2
Oct  4 12:27:05 xplane kernel:  disk 1, wo:0, o:1, dev:sdg3
Oct  4 12:27:14 xplane kernel: md: unbind<sdh3>
Oct  4 12:27:14 xplane kernel: md: export_rdev(sdh3)
Oct  4 12:27:24 xplane kernel: md: bind<sdh3>
Oct  4 12:27:24 xplane kernel: RAID1 conf printout:
Oct  4 12:27:24 xplane kernel:  --- wd:1 rd:2
Oct  4 12:27:24 xplane kernel:  disk 0, wo:1, o:1, dev:sdh3
Oct  4 12:27:24 xplane kernel:  disk 1, wo:0, o:1, dev:sdg3
Oct  4 12:27:24 xplane kernel: md: recovery of RAID array md1
Oct  4 12:27:24 xplane kernel: md: minimum _guaranteed_  speed: 10000 
KB/sec/disk.
Oct  4 12:27:24 xplane kernel: md: using maximum available idle IO 
bandwidth (but not more than 200000 KB/sec) for recovery.
Oct  4 12:27:24 xplane kernel: md: using 128k window, over a total of 
76959296k.
Oct  4 12:27:33 xplane kernel: md: md1: recovery done.
Oct  4 12:27:33 xplane kernel: RAID1 conf printout:
Oct  4 12:27:33 xplane kernel:  --- wd:2 rd:2
Oct  4 12:27:33 xplane kernel:  disk 0, wo:0, o:1, dev:sdh3
Oct  4 12:27:33 xplane kernel:  disk 1, wo:0, o:1, dev:sdg3
Oct  4 12:27:35 xplane kernel: md: data-check of RAID array md1
Oct  4 12:27:35 xplane kernel: md: minimum _guaranteed_  speed: 10000 
KB/sec/disk.
Oct  4 12:27:35 xplane kernel: md: using maximum available idle IO 
bandwidth (but not more than 200000 KB/sec) for data-check.
Oct  4 12:27:35 xplane kernel: md: using 128k window, over a total of 
76959296k.
Oct  4 12:29:59 xplane kernel: __journal_remove_journal_head: freeing 
b_committed_data

It seems like something got out of sync as the disk was being removed, 
but before the remove completed.

Again, this is 3.14.19 with these 8 patches:
       md/raid1: intialise start_next_window for READ case to avoid hang
       md/raid1:  be more cautious where we read-balance during resync.
       md/raid1: clean up request counts properly in close_sync()
       md/raid1: make sure resync waits for conflicting writes to complete.
       md/raid1: Don't use next_resync to determine how far resync has 
progressed
       md/raid1: update next_resync under resync_lock.
       md/raid1: count resync requests in nr_pending.
       md/raid1: fix_read_error should act on all non-faulty devices.

       and the two patches for the check start hang.

Any ideas on what happened here?

Thanks,
Bill


