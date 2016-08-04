From: Yi Zhang <yizhan@redhat.com>
Subject: INFO: task systemd-udevd:794 blocked for more than 600 seconds
 observed after mdadm -G operation
Date: Thu, 4 Aug 2016 12:01:19 -0400 (EDT)
Message-ID: <1363340670.11420734.1470326479339.JavaMail.zimbra@redhat.com>
References: <2047059297.11279583.1470314510395.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2047059297.11279583.1470314510395.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

Hello folks

Seems I hit one issue that task blocked issue on 4.7.0 during write journal testing, could anyone help check it? 
I have list the log and reproduce steps below, thanks.

Log:
[  106.688135] md: bind<sdb1>
[  106.688301] md: bind<sdc1>
[  106.689831] md: bind<sdd1>
[  106.689897] md: bind<sdf1>
[  106.710079] md: bind<sde1>
[  106.804284] raid6: sse2x1   gen()  6707 MB/s
[  106.821281] raid6: sse2x1   xor()  5667 MB/s
[  106.838284] raid6: sse2x2   gen()  8875 MB/s
[  106.855282] raid6: sse2x2   xor()  6230 MB/s
[  106.872278] raid6: sse2x4   gen() 10359 MB/s
[  106.889278] raid6: sse2x4   xor()  7697 MB/s
[  106.889280] raid6: using algorithm sse2x4 gen() 10359 MB/s
[  106.889281] raid6: .... xor() 7697 MB/s, rmw enabled
[  106.889282] raid6: using ssse3x2 recovery algorithm
[  106.907347] async_tx: api initialized (async)
[  106.924571] xor: automatically using best checksumming function:
[  106.934274]    avx       : 19356.000 MB/sec
[  107.036697] md: raid6 personality registered for level 6
[  107.036699] md: raid5 personality registered for level 5
[  107.036700] md: raid4 personality registered for level 4
[  107.037215] md/raid:md0: device sdd1 operational as raid disk 2
[  107.037217] md/raid:md0: device sdc1 operational as raid disk 1
[  107.037218] md/raid:md0: device sdb1 operational as raid disk 0
[  107.037508] md/raid:md0: allocated 4374kB
[  107.037533] md/raid:md0: raid level 5 active with 3 out of 4 devices, algorithm 2
[  107.037534] RAID conf printout:
[  107.037535]  --- level:5 rd:4 wd:3
[  107.037536]  disk 0, o:1, dev:sdb1
[  107.037537]  disk 1, o:1, dev:sdc1
[  107.037538]  disk 2, o:1, dev:sdd1
[  107.037548] md/raid:md0: using device sdf1 as journal
[  107.037829] md0: detected capacity change from 0 to 32187088896
[  107.037849] RAID conf printout:
[  107.037853]  --- level:5 rd:4 wd:3
[  107.037855]  disk 0, o:1, dev:sdb1
[  107.037857]  disk 1, o:1, dev:sdc1
[  107.037858]  disk 2, o:1, dev:sdd1
[  107.037860]  disk 3, o:1, dev:sde1
[  107.037945] md: recovery of RAID array md0
[  107.037948] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[  107.037949] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
[  107.037954] md: using 128k window, over a total of 10477568k.
[  216.232974] md: md0: recovery done.
[  216.431212] RAID conf printout:
[  216.431216]  --- level:5 rd:4 wd:4
[  216.431218]  disk 0, o:1, dev:sdb1
[  216.431219]  disk 1, o:1, dev:sdc1
[  216.431220]  disk 2, o:1, dev:sdd1
[  216.431221]  disk 3, o:1, dev:sde1
[  222.897854] md/raid:md0: Disk failure on sdf1, disabling device.
md/raid:md0: Operation continuing on 4 devices.
[  223.174949] RAID conf printout:
[  223.174952]  --- level:5 rd:4 wd:4
[  223.174953]  disk 0, o:1, dev:sdb1
[  223.174954]  disk 1, o:1, dev:sdc1
[  223.174955]  disk 2, o:1, dev:sdd1
[  223.174956]  disk 3, o:1, dev:sde1
[  241.640253] md: unbind<sdf1>
[  241.643448] md: export_rdev(sdf1)
[  261.329087] md: bind<sdf1>
[  261.607691] RAID conf printout:
[  261.607694]  --- level:5 rd:4 wd:4
[  261.607695]  disk 0, o:1, dev:sdb1
[  261.607696]  disk 1, o:1, dev:sdc1
[  261.607697]  disk 2, o:1, dev:sdd1
[  261.607698]  disk 3, o:1, dev:sde1
[  292.581113] RAID conf printout:
[  292.581116]  --- level:5 rd:5 wd:5
[  292.581118]  disk 0, o:1, dev:sdb1
[  292.581119]  disk 1, o:1, dev:sdc1
[  292.581120]  disk 2, o:1, dev:sdd1
[  292.581121]  disk 3, o:1, dev:sde1
[  292.581121]  disk 4, o:1, dev:sdf1
[  292.581199] md: reshape of RAID array md0
[  292.581202] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[  292.581204] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for reshape.
[  292.581214] md: using 128k window, over a total of 10477568k.
[ 1201.734199] INFO: task systemd-udevd:794 blocked for more than 600 seconds.
[ 1201.734204]       Not tainted 4.7.0 #5
[ 1201.734204] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1201.734206] systemd-udevd   D ffff8800310a77b0     0   794      1 0x00000000
[ 1201.734209]  ffff8800310a77b0 0000000000000001 ffff880031de0000 ffff8807cd3c5688
[ 1201.734211]  ffff8800310a8000 0000000000000000 0000000000000002 ffff8807c3e4c100
[ 1201.734213]  0000000000000000 ffff8800310a77c8 ffffffff816e4935 ffff8807cd3c5400
[ 1201.734214] Call Trace:
[ 1201.734220]  [<ffffffff816e4935>] schedule+0x35/0x80
[ 1201.734226]  [<ffffffffa09a0ba9>] raid5_make_request+0x8b9/0xce0 [raid456]
[ 1201.734229]  [<ffffffff810d0240>] ? prepare_to_wait_event+0xf0/0xf0
[ 1201.734233]  [<ffffffff8156758e>] md_make_request+0xee/0x230
[ 1201.734236]  [<ffffffff81320803>] generic_make_request+0x103/0x1d0
[ 1201.734237]  [<ffffffff81320947>] submit_bio+0x77/0x150
[ 1201.734240]  [<ffffffff813183bb>] ? bio_alloc_bioset+0x1ab/0x2d0
[ 1201.734242]  [<ffffffff81254ecd>] ? alloc_page_buffers+0x5d/0xb0
[ 1201.734244]  [<ffffffff81256a1f>] submit_bh_wbc+0x12f/0x160
[ 1201.734246]  [<ffffffff81256d58>] block_read_full_page+0x208/0x380
[ 1201.734248]  [<ffffffff81259000>] ? I_BDEV+0x20/0x20
[ 1201.734250]  [<ffffffff812597e8>] blkdev_readpage+0x18/0x20
[ 1201.734253]  [<ffffffff81197718>] do_read_cache_page+0x138/0x300
[ 1201.734255]  [<ffffffff812597d0>] ? blkdev_writepages+0x40/0x40
[ 1201.734257]  [<ffffffff811978f9>] read_cache_page+0x19/0x20
[ 1201.734259]  [<ffffffff81333b50>] read_dev_sector+0x80/0xb0
[ 1201.734261]  [<ffffffff81337f14>] read_lba+0x104/0x1c0
[ 1201.734263]  [<ffffffff8133852a>] find_valid_gpt+0xfa/0x710
[ 1201.734266]  [<ffffffff811d7d00>] ? vmap_page_range_noflush+0x190/0x380
[ 1201.734267]  [<ffffffff81338b40>] ? find_valid_gpt+0x710/0x710
[ 1201.734269]  [<ffffffff81338bc9>] efi_partition+0x89/0x440
[ 1201.734271]  [<ffffffff81359209>] ? snprintf+0x49/0x70
[ 1201.734273]  [<ffffffff81338b40>] ? find_valid_gpt+0x710/0x710
[ 1201.734275]  [<ffffffff81335b31>] check_partition+0x101/0x1f0
[ 1201.734277]  [<ffffffff81334462>] rescan_partitions+0xc2/0x2c0
[ 1201.734279]  [<ffffffff8132f294>] __blkdev_reread_part+0x64/0x70
[ 1201.734281]  [<ffffffff8132f2c3>] blkdev_reread_part+0x23/0x40
[ 1201.734282]  [<ffffffff8132fd3a>] blkdev_ioctl+0x46a/0x8f0
[ 1201.734284]  [<ffffffff81259aa1>] block_ioctl+0x41/0x50
[ 1201.734286]  [<ffffffff812323b6>] do_vfs_ioctl+0xa6/0x5c0
[ 1201.734288]  [<ffffffff81232949>] SyS_ioctl+0x79/0x90
[ 1201.734290]  [<ffffffff81274d67>] ? SyS_flock+0x117/0x1a0
[ 1201.734292]  [<ffffffff816e86b2>] entry_SYSCALL_64_fastpath+0x1a/0xa4
[ 1201.734305] INFO: task md0_reshape:4089 blocked for more than 600 seconds.
[ 1201.734306]       Not tainted 4.7.0 #5
[ 1201.734307] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1201.734308] md0_reshape     D ffff88080db77ac0     0  4089      2 0x00000080
[ 1201.734310]  ffff88080db77ac0 0000000000000000 ffff8807d6724380 ffff8807cd3c5670
[ 1201.734311]  ffff88080db78000 ffff88080db77b20 ffff8807cd3c5670 0000000000000c20
[ 1201.734313]  ffff8807cd3c5418 ffff88080db77ad8 ffffffff816e4935 ffff8807cd3c5400
[ 1201.734314] Call Trace:
[ 1201.734316]  [<ffffffff816e4935>] schedule+0x35/0x80
[ 1201.734319]  [<ffffffffa099fe8b>] raid5_get_active_stripe+0x20b/0x670 [raid456]
[ 1201.734321]  [<ffffffff810d0240>] ? prepare_to_wait_event+0xf0/0xf0
[ 1201.734323]  [<ffffffffa09a4733>] reshape_request+0x4d3/0x8a0 [raid456]
[ 1201.734326]  [<ffffffffa09a4e21>] raid5_sync_request+0x321/0x3a0 [raid456]
[ 1201.734327]  [<ffffffff810cfc54>] ? __wake_up+0x44/0x50
[ 1201.734329]  [<ffffffff8156ce97>] md_do_sync+0x9e7/0xf60
[ 1201.734332]  [<ffffffff810c200d>] ? update_curr+0xed/0x180
[ 1201.734333]  [<ffffffff810c025e>] ? account_entity_dequeue+0xae/0xd0
[ 1201.734336]  [<ffffffff81098d43>] ? kernel_sigaction+0x43/0xe0
[ 1201.734339]  [<ffffffff81566dc6>] md_thread+0x136/0x150
[ 1201.734341]  [<ffffffff81566c90>] ? find_pers+0x70/0x70
[ 1201.734343]  [<ffffffff810ab678>] kthread+0xd8/0xf0
[ 1201.734344]  [<ffffffff816e88bf>] ret_from_fork+0x1f/0x40
[ 1201.734346]  [<ffffffff810ab5a0>] ? kthread_park+0x60/0x60


Reproduce steps:

#mdadm -CR /dev/md0 -l5 -n4 /dev/sd[b-e]1 --write-journal /dev/sdf1
#mdadm --wait /dev/md0 
#mdadm /dev/md0 -f /dev/sdf1
#mdadm /dev/md0 -r /dev/sdf1
#mdadm /dev/md0 -a /dev/sdf1
#mdadm -D /dev/md0 
/dev/md0:
        Version : 1.2
  Creation Time : Thu Aug  4 20:37:41 2016
     Raid Level : raid5
     Array Size : 31432704 (29.98 GiB 32.19 GB)
  Used Dev Size : 10477568 (9.99 GiB 10.73 GB)
   Raid Devices : 4
  Total Devices : 5
    Persistence : Superblock is persistent

    Update Time : Thu Aug  4 20:40:16 2016
          State : clean 
 Active Devices : 4
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 512K

           Name : dhcp-12-125.nay.redhat.com:0  (local to host dhcp-12-125.nay.redhat.com)
           UUID : 09607542:a8dccc81:f5d2f80c:c586923f
         Events : 22

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       8       33        1      active sync   /dev/sdc1
       2       8       49        2      active sync   /dev/sdd1
       5       8       65        3      active sync   /dev/sde1

       4       8       81        -      spare   /dev/sdf1

#mdadm -G -n5 /dev/md0

Best Regards,
  Yi Zhang


