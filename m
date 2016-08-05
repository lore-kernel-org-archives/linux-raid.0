From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: INFO: task systemd-udevd:794 blocked for more than 600 seconds
 observed after mdadm -G operation
Date: Fri, 5 Aug 2016 02:39:37 -0400
Message-ID: <57A434A9.2020501@suse.com>
References: <1363340670.11420734.1470326479339.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1363340670.11420734.1470326479339.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yi Zhang <yizhan@redhat.com>, linux-raid@vger.kernel.org
Cc: shli@fb.com, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids



On 08/04/2016 12:01 PM, Yi Zhang wrote:

> [ 1201.734199] INFO: task systemd-udevd:794 blocked for more than 600 seconds.
> [ 1201.734204]       Not tainted 4.7.0 #5
> [ 1201.734204] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 1201.734206] systemd-udevd   D ffff8800310a77b0     0   794      1 0x00000000
> [ 1201.734209]  ffff8800310a77b0 0000000000000001 ffff880031de0000 ffff8807cd3c5688
> [ 1201.734211]  ffff8800310a8000 0000000000000000 0000000000000002 ffff8807c3e4c100
> [ 1201.734213]  0000000000000000 ffff8800310a77c8 ffffffff816e4935 ffff8807cd3c5400
> [ 1201.734214] Call Trace:
> [ 1201.734220]  [<ffffffff816e4935>] schedule+0x35/0x80
> [ 1201.734226]  [<ffffffffa09a0ba9>] raid5_make_request+0x8b9/0xce0 [raid456]
> [ 1201.734229]  [<ffffffff810d0240>] ? prepare_to_wait_event+0xf0/0xf0
> [ 1201.734233]  [<ffffffff8156758e>] md_make_request+0xee/0x230
> [ 1201.734236]  [<ffffffff81320803>] generic_make_request+0x103/0x1d0
> [ 1201.734237]  [<ffffffff81320947>] submit_bio+0x77/0x150
> [ 1201.734240]  [<ffffffff813183bb>] ? bio_alloc_bioset+0x1ab/0x2d0
> [ 1201.734242]  [<ffffffff81254ecd>] ? alloc_page_buffers+0x5d/0xb0
> [ 1201.734244]  [<ffffffff81256a1f>] submit_bh_wbc+0x12f/0x160
> [ 1201.734246]  [<ffffffff81256d58>] block_read_full_page+0x208/0x380
> [ 1201.734248]  [<ffffffff81259000>] ? I_BDEV+0x20/0x20
> [ 1201.734250]  [<ffffffff812597e8>] blkdev_readpage+0x18/0x20
> [ 1201.734253]  [<ffffffff81197718>] do_read_cache_page+0x138/0x300
> [ 1201.734255]  [<ffffffff812597d0>] ? blkdev_writepages+0x40/0x40
> [ 1201.734257]  [<ffffffff811978f9>] read_cache_page+0x19/0x20
> [ 1201.734259]  [<ffffffff81333b50>] read_dev_sector+0x80/0xb0
> [ 1201.734261]  [<ffffffff81337f14>] read_lba+0x104/0x1c0
> [ 1201.734263]  [<ffffffff8133852a>] find_valid_gpt+0xfa/0x710
> [ 1201.734266]  [<ffffffff811d7d00>] ? vmap_page_range_noflush+0x190/0x380
> [ 1201.734267]  [<ffffffff81338b40>] ? find_valid_gpt+0x710/0x710
> [ 1201.734269]  [<ffffffff81338bc9>] efi_partition+0x89/0x440
> [ 1201.734271]  [<ffffffff81359209>] ? snprintf+0x49/0x70
> [ 1201.734273]  [<ffffffff81338b40>] ? find_valid_gpt+0x710/0x710
> [ 1201.734275]  [<ffffffff81335b31>] check_partition+0x101/0x1f0
> [ 1201.734277]  [<ffffffff81334462>] rescan_partitions+0xc2/0x2c0
> [ 1201.734279]  [<ffffffff8132f294>] __blkdev_reread_part+0x64/0x70
> [ 1201.734281]  [<ffffffff8132f2c3>] blkdev_reread_part+0x23/0x40
> [ 1201.734282]  [<ffffffff8132fd3a>] blkdev_ioctl+0x46a/0x8f0
> [ 1201.734284]  [<ffffffff81259aa1>] block_ioctl+0x41/0x50
> [ 1201.734286]  [<ffffffff812323b6>] do_vfs_ioctl+0xa6/0x5c0
> [ 1201.734288]  [<ffffffff81232949>] SyS_ioctl+0x79/0x90
> [ 1201.734290]  [<ffffffff81274d67>] ? SyS_flock+0x117/0x1a0
> [ 1201.734292]  [<ffffffff816e86b2>] entry_SYSCALL_64_fastpath+0x1a/0xa4
> [ 1201.734305] INFO: task md0_reshape:4089 blocked for more than 600 seconds.
> [ 1201.734306]       Not tainted 4.7.0 #5
> [ 1201.734307] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 1201.734308] md0_reshape     D ffff88080db77ac0     0  4089      2 0x00000080
> [ 1201.734310]  ffff88080db77ac0 0000000000000000 ffff8807d6724380 ffff8807cd3c5670
> [ 1201.734311]  ffff88080db78000 ffff88080db77b20 ffff8807cd3c5670 0000000000000c20
> [ 1201.734313]  ffff8807cd3c5418 ffff88080db77ad8 ffffffff816e4935 ffff8807cd3c5400
> [ 1201.734314] Call Trace:
> [ 1201.734316]  [<ffffffff816e4935>] schedule+0x35/0x80
> [ 1201.734319]  [<ffffffffa099fe8b>] raid5_get_active_stripe+0x20b/0x670 [raid456]
> [ 1201.734321]  [<ffffffff810d0240>] ? prepare_to_wait_event+0xf0/0xf0
> [ 1201.734323]  [<ffffffffa09a4733>] reshape_request+0x4d3/0x8a0 [raid456]
> [ 1201.734326]  [<ffffffffa09a4e21>] raid5_sync_request+0x321/0x3a0 [raid456]
> [ 1201.734327]  [<ffffffff810cfc54>] ? __wake_up+0x44/0x50
> [ 1201.734329]  [<ffffffff8156ce97>] md_do_sync+0x9e7/0xf60
> [ 1201.734332]  [<ffffffff810c200d>] ? update_curr+0xed/0x180
> [ 1201.734333]  [<ffffffff810c025e>] ? account_entity_dequeue+0xae/0xd0
> [ 1201.734336]  [<ffffffff81098d43>] ? kernel_sigaction+0x43/0xe0
> [ 1201.734339]  [<ffffffff81566dc6>] md_thread+0x136/0x150
> [ 1201.734341]  [<ffffffff81566c90>] ? find_pers+0x70/0x70
> [ 1201.734343]  [<ffffffff810ab678>] kthread+0xd8/0xf0
> [ 1201.734344]  [<ffffffff816e88bf>] ret_from_fork+0x1f/0x40
> [ 1201.734346]  [<ffffffff810ab5a0>] ? kthread_park+0x60/0x60
>
>
> Reproduce steps:
>
> #mdadm -CR /dev/md0 -l5 -n4 /dev/sd[b-e]1 --write-journal /dev/sdf1
> #mdadm --wait /dev/md0
> #mdadm /dev/md0 -f /dev/sdf1
> #mdadm /dev/md0 -r /dev/sdf1
> #mdadm /dev/md0 -a /dev/sdf1
> #mdadm -D /dev/md0
> /dev/md0:
>          Version : 1.2
>    Creation Time : Thu Aug  4 20:37:41 2016
>       Raid Level : raid5
>       Array Size : 31432704 (29.98 GiB 32.19 GB)
>    Used Dev Size : 10477568 (9.99 GiB 10.73 GB)
>     Raid Devices : 4
>    Total Devices : 5
>      Persistence : Superblock is persistent
>
>      Update Time : Thu Aug  4 20:40:16 2016
>            State : clean
>   Active Devices : 4
> Working Devices : 5
>   Failed Devices : 0
>    Spare Devices : 1
>
>           Layout : left-symmetric
>       Chunk Size : 512K
>
>             Name : dhcp-12-125.nay.redhat.com:0  (local to host dhcp-12-125.nay.redhat.com)
>             UUID : 09607542:a8dccc81:f5d2f80c:c586923f
>           Events : 22
>
>      Number   Major   Minor   RaidDevice State
>         0       8       17        0      active sync   /dev/sdb1
>         1       8       33        1      active sync   /dev/sdc1
>         2       8       49        2      active sync   /dev/sdd1
>         5       8       65        3      active sync   /dev/sde1
>
>         4       8       81        -      spare   /dev/sdf1
>
> #mdadm -G -n5 /dev/md0

Also with 4.7+, I can't find the same issue, but md0_reshape is in 'D' 
state from my side
(actually I can't find reshape is in-progress by 'cat /proc/mdstat').

linux241:~ # mdadm -G -n5 /dev/md0
mdadm: Need to backup 6144K of critical section..
linux241:~ # cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 vdf1[4] vde1[5] vdd1[2] vdc1[1] vdb1[0]
       9431040 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/5] 
[UUUUU]

unused devices: <none>
linux241:~ # ps aux|grep md|grep D
root      1890  0.0  0.0      0     0 ?        D    14:09   0:00 
[md0_reshape]
linux241:~ # cat /proc/1890/stack
[<ffffffffa05423b9>] reshape_request+0x5c9/0x840 [raid456]
[<ffffffffa054283f>] raid5_sync_request+0x20f/0x3a0 [raid456]
[<ffffffffa043f03b>] md_do_sync+0x8fb/0xe60 [md_mod]
[<ffffffffa043a691>] md_thread+0x111/0x130 [md_mod]
[<ffffffff8108a649>] kthread+0xc9/0xe0
[<ffffffff815e87bf>] ret_from_fork+0x1f/0x40
[<ffffffffffffffff>] 0xffffffffffffffff

Then the array can't be stop successfully after '-G', and the stack of 
reshape is
also changed,

linux241:~ # ps aux|grep md|grep D
root      1890  0.0  0.0      0     0 ?        D    14:09   0:00 
[md0_reshape]
root      1961  0.0  0.1  19864  2016 pts/1    D+   14:13   0:00 mdadm -Ss
root      1962  0.0  0.2  43240  2288 ?        D    14:13   0:00 
/usr/lib/systemd/systemd-udevd
linux241:~ # cat /proc/1890/stack
[<ffffffffa043f2ab>] md_do_sync+0xb6b/0xe60 [md_mod]
[<ffffffffa043a691>] md_thread+0x111/0x130 [md_mod]
[<ffffffff8108a649>] kthread+0xc9/0xe0
[<ffffffff815e87bf>] ret_from_fork+0x1f/0x40
[<ffffffffffffffff>] 0xffffffffffffffff
linux241:~ # cat /proc/1961/stack
[<ffffffff8108a8da>] kthread_stop+0x4a/0x110
[<ffffffffa043dff4>] md_unregister_thread+0x44/0x80 [md_mod]
[<ffffffffa04431ab>] md_reap_sync_thread+0x1b/0x180 [md_mod]
[<ffffffffa0443451>] action_store+0x141/0x2a0 [md_mod]
[<ffffffffa043f619>] md_attr_store+0x79/0xb0 [md_mod]
[<ffffffff81269fca>] sysfs_kf_write+0x3a/0x50
[<ffffffff8126961b>] kernfs_fop_write+0x11b/0x1a0
[<ffffffff811f04e8>] __vfs_write+0x28/0x120
[<ffffffff811f1342>] vfs_write+0xb2/0x1b0
[<ffffffff811f2686>] SyS_write+0x46/0xa0
[<ffffffff815e85b2>] entry_SYSCALL_64_fastpath+0x1a/0xa4
[<ffffffffffffffff>] 0xffffffffffffffff

Since the steps work for raid5 (add vdf1 as spare), I guess that '-G'  
can't co-operate
with raid5-cache well so far. Just FYI.

Thanks,
Guoqing
