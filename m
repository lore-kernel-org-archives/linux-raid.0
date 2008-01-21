From: "Mike Snitzer" <snitzer@gmail.com>
Subject: 2.6.22.16 MD raid1 doesn't mark removed disk faulty, MD thread goes UN
Date: Mon, 21 Jan 2008 18:04:10 -0500
Message-ID: <170fa0d20801211504y5ebea9adka614817619d7a05f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Under 2.6.22.16, I physically pulled a SATA disk (/dev/sdac, connected to
an aacraid controller) that was acting as the local raid1 member of
/dev/md30.

Linux MD didn't see an /dev/sdac1 error until I tried forcing the issue by
doing a read (with dd) from /dev/md30:

Jan 21 17:08:07 lab17-233 kernel: sd 2:0:27:0: [sdac] Result:
hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Jan 21 17:08:07 lab17-233 kernel: sd 2:0:27:0: [sdac] Sense Key :
Hardware Error [current]
Jan 21 17:08:07 lab17-233 kernel: Info fld=0x0
Jan 21 17:08:07 lab17-233 kernel: sd 2:0:27:0: [sdac] Add. Sense:
Internal target failure
Jan 21 17:08:07 lab17-233 kernel: end_request: I/O error, dev sdac, sector 71
Jan 21 17:08:07 lab17-233 kernel: printk: 3 messages suppressed.
Jan 21 17:08:07 lab17-233 kernel: raid1: sdac1: rescheduling sector 8
Jan 21 17:08:07 lab17-233 kernel: raid1: sdac1: rescheduling sector 16
Jan 21 17:08:07 lab17-233 kernel: raid1: sdac1: rescheduling sector 24
Jan 21 17:08:07 lab17-233 kernel: raid1: sdac1: rescheduling sector 32
Jan 21 17:08:07 lab17-233 kernel: raid1: sdac1: rescheduling sector 40
Jan 21 17:08:07 lab17-233 kernel: raid1: sdac1: rescheduling sector 48
Jan 21 17:08:07 lab17-233 kernel: raid1: sdac1: rescheduling sector 56
Jan 21 17:08:07 lab17-233 kernel: raid1: sdac1: rescheduling sector 64
Jan 21 17:08:07 lab17-233 kernel: raid1: sdac1: rescheduling sector 72
Jan 21 17:08:07 lab17-233 kernel: raid1: sdac1: rescheduling sector 80
Jan 21 17:08:07 lab17-233 kernel: sd 2:0:27:0: [sdac] Result:
hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Jan 21 17:08:07 lab17-233 kernel: sd 2:0:27:0: [sdac] Sense Key :
Hardware Error [current]
Jan 21 17:08:07 lab17-233 kernel: Info fld=0x0
Jan 21 17:08:07 lab17-233 kernel: sd 2:0:27:0: [sdac] Add. Sense:
Internal target failure
Jan 21 17:08:07 lab17-233 kernel: end_request: I/O error, dev sdac, sector 343
Jan 21 17:08:08 lab17-233 kernel: sd 2:0:27:0: [sdac] Result:
hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Jan 21 17:08:08 lab17-233 kernel: sd 2:0:27:0: [sdac] Sense Key :
Hardware Error [current]
Jan 21 17:08:08 lab17-233 kernel: Info fld=0x0
...
Jan 21 17:08:12 lab17-233 kernel: sd 2:0:27:0: [sdac] Add. Sense:
Internal target failure
Jan 21 17:08:12 lab17-233 kernel: end_request: I/O error, dev sdac, sector 3399
Jan 21 17:08:12 lab17-233 kernel: printk: 765 messages suppressed.
Jan 21 17:08:12 lab17-233 kernel: raid1: sdac1: rescheduling sector 3336

However, the MD layer still hasn't marked the sdac1 member faulty:

md30 : active raid1 nbd2[1](W) sdac1[0]
      4016204 blocks super 1.0 [2/2] [UU]
      bitmap: 1/8 pages [4KB], 256KB chunk

The dd I used to read from /dev/md30 is blocked on IO:

Jan 21 17:13:55 lab17-233 kernel: dd            D 00000afa9cf5c346
0 12337   7702 (NOTLB)
Jan 21 17:13:55 lab17-233 kernel:  ffff81010c449868 0000000000000082
0000000000000000 ffffffff80268f14
Jan 21 17:13:55 lab17-233 kernel:  ffff81015da6f320 ffff81015de532c0
0000000000000008 ffff81012d9d7780
Jan 21 17:13:55 lab17-233 kernel:  ffff81015fae2880 0000000000004926
ffff81012d9d7970 00000001802879a0
Jan 21 17:13:55 lab17-233 kernel: Call Trace:
Jan 21 17:13:55 lab17-233 kernel:  [<ffffffff80268f14>] mempool_alloc+0x24/0xda
Jan 21 17:13:55 lab17-233 kernel:  [<ffffffff88b91381>]
:raid1:wait_barrier+0x84/0xc2
Jan 21 17:13:55 lab17-233 kernel:  [<ffffffff8022d8fa>]
default_wake_function+0x0/0xe
Jan 21 17:13:55 lab17-233 kernel:  [<ffffffff88b92093>]
:raid1:make_request+0x83/0x5c0
Jan 21 17:13:55 lab17-233 kernel:  [<ffffffff80305acd>]
__make_request+0x57f/0x668
Jan 21 17:13:55 lab17-233 kernel:  [<ffffffff80302dc7>]
generic_make_request+0x26e/0x2a9
Jan 21 17:13:55 lab17-233 kernel:  [<ffffffff80268f14>] mempool_alloc+0x24/0xda
Jan 21 17:13:55 lab17-233 kernel:  [<ffffffff8030db39>] __next_cpu+0x19/0x28
Jan 21 17:13:55 lab17-233 kernel:  [<ffffffff80305162>] submit_bio+0xb6/0xbd
Jan 21 17:13:55 lab17-233 kernel:  [<ffffffff802aba6a>] submit_bh+0xdf/0xff
Jan 21 17:13:55 lab17-233 kernel:  [<ffffffff802ae188>]
block_read_full_page+0x271/0x28e
Jan 21 17:13:55 lab17-233 kernel:  [<ffffffff802b0b27>]
blkdev_get_block+0x0/0x46
Jan 21 17:13:55 lab17-233 kernel:  [<ffffffff803103ad>]
radix_tree_insert+0xcb/0x18c
Jan 21 17:13:55 lab17-233 kernel:  [<ffffffff8026d003>]
__do_page_cache_readahead+0x16d/0x1df
Jan 21 17:13:55 lab17-233 kernel:  [<ffffffff80248c51>] getnstimeofday+0x32/0x8d
Jan 21 17:13:55 lab17-233 kernel:  [<ffffffff80247e5e>] ktime_get_ts+0x1a/0x4e
Jan 21 17:13:55 lab17-233 kernel:  [<ffffffff80265543>] delayacct_end+0x7d/0x88
Jan 21 17:13:55 lab17-233 kernel:  [<ffffffff8026d0c8>]
blockable_page_cache_readahead+0x53/0xb2
Jan 21 17:13:55 lab17-233 kernel:  [<ffffffff8026d1a9>]
make_ahead_window+0x82/0x9e
Jan 21 17:13:55 lab17-233 kernel:  [<ffffffff8026d34f>]
page_cache_readahead+0x18a/0x1c1
Jan 21 17:13:55 lab17-233 kernel:  [<ffffffff8026723c>]
do_generic_mapping_read+0x135/0x3fc
Jan 21 17:13:55 lab17-233 kernel:  [<ffffffff80266755>]
file_read_actor+0x0/0x170
Jan 21 17:13:55 lab17-233 kernel:  [<ffffffff80268d7c>]
generic_file_aio_read+0x119/0x155
Jan 21 17:13:55 lab17-233 kernel:  [<ffffffff8028d7b4>] do_sync_read+0xc9/0x10c
Jan 21 17:13:55 lab17-233 kernel:  [<ffffffff802457a9>]
autoremove_wake_function+0x0/0x2e
Jan 21 17:13:55 lab17-233 kernel:  [<ffffffff802791ce>]
do_mmap_pgoff+0x639/0x7a5
Jan 21 17:13:55 lab17-233 kernel:  [<ffffffff8028dfce>] vfs_read+0xcb/0x153
Jan 21 17:13:55 lab17-233 kernel:  [<ffffffff8028e36a>] sys_read+0x45/0x6e
Jan 21 17:13:55 lab17-233 kernel:  [<ffffffff80209d9c>] tracesys+0xdc/0xe1
Jan 21 17:13:55 lab17-233 kernel:

The md30 kernel thread is waiting on IO, under live crash I see the
md30_raid1 thread has:

crash> ps | grep md30_raid1
   8744      2   1  ffff81013e39d800  UN   0.0       0      0  [md30_raid1]
crash> bt 8744
PID: 8744   TASK: ffff81013e39d800  CPU: 1   COMMAND: "md30_raid1"
 #0 [ffff81013e363cc0] schedule at ffffffff80457ddc
 #1 [ffff81013e363db8] raid1d at ffffffff88b93539
 #2 [ffff81013e363ed8] md_thread at ffffffff803d4f9d
 #3 [ffff81013e363f28] kthread at ffffffff80245651
 #4 [ffff81013e363f48] kernel_thread at ffffffff8020aa38
crash> dis ffffffff88b93520 10
0xffffffff88b93520 <raid1d+2412>:       add    %eax,(%rax)
0xffffffff88b93522 <raid1d+2414>:       add    %al,(%rax)
0xffffffff88b93524 <raid1d+2416>:       sti
0xffffffff88b93525 <raid1d+2417>:       mov    (%r14),%rax
0xffffffff88b93528 <raid1d+2420>:       mov    0x260(%rax),%rdi
0xffffffff88b9352f <raid1d+2427>:       callq  0xffffffff88b912e0 <raid1_unplug>
0xffffffff88b93534 <raid1d+2432>:       callq  0xffffffff80457480
<__sched_text_start>
0xffffffff88b93539 <raid1d+2437>:       mov    %rbx,%rdi
0xffffffff88b9353c <raid1d+2440>:       callq  0xffffffff80459796
<_spin_lock_irq>
0xffffffff88b93541 <raid1d+2445>:       jmp    0xffffffff88b934f4 <raid1d+2368>

Any insight on this would be extremely helpful.

regards,
Mike
