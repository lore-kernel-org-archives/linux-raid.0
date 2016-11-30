From: Shaohua Li <shli@kernel.org>
Subject: Re: [BUG] MD/RAID1 hung forever on bitmap_startwrite+0x122
Date: Tue, 29 Nov 2016 16:08:38 -0800
Message-ID: <20161130000838.ahkicokl6ccbrf5x@kernel.org>
References: <CAMGffEmvr2rJrAmb+qpq-FdFVMxisH14f_VwWMTTyAXpc_saMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAMGffEmvr2rJrAmb+qpq-FdFVMxisH14f_VwWMTTyAXpc_saMQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jinpu Wang <jinpu.wang@profitbricks.com>
Cc: linux-raid@vger.kernel.org, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

On Mon, Nov 28, 2016 at 09:45:07AM +0100, Jinpu Wang wrote:
> Hi folks,
> 
> We hit another hung task on bitmap_startwrite with our test machines, this time
> it's hung in bitmap_startwrite.
> 
> We build MD/RAID1 over 2 block devices exported via IB,
> bitmap=internal. KVM build on top of
> RAID1 on compute node, disks are on remote storage node, one storage
> node crash/reboot, multiple raid1 on multiple compute node KVM run
> into hung task:
> 
> [106204.343870] INFO: task kvm:37669 blocked for more than 180 seconds.
> 
> [106204.344138]       Tainted: G          IO    4.4.28-1-pserver #1
> 
> [106204.344385] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> 
> [106204.344798] kvm             D ffff882037723710     0 37669      1 0x00000000
> 
> [106204.344805]  ffff882037723710 ffff882038f08d00 ffff882029770d00
> ffff8820377236d8
> 
> [106204.344809]  ffff8820377236d8 ffff882037724000 0000000000308648
> 0000000000000008
> 
> [106204.344813]  ffff880f9bd9e8c0 ffff882037723768 ffff882037723728
> ffffffff81811c60
> 
> [106204.344818] Call Trace:
> 
> [106204.344831]  [<ffffffff81811c60>] schedule+0x30/0x80
> 
> [106204.344841]  [<ffffffffa09d31a2>] bitmap_startwrite+0x122/0x190 [md_mod]
> 
> [106204.344848]  [<ffffffff813f660b>] ? bio_clone_bioset+0x11b/0x310
> 
> [106204.344853]  [<ffffffff810956b0>] ? wait_woken+0x80/0x80
> 
> [106204.344859]  [<ffffffffa0cc5127>] 0xffffffffa0cc5127
> 
> [106204.344865]  [<ffffffffa09c4863>] md_set_array_sectors+0xac3/0xe20 [md_mod]
> 
> [106204.344871]  [<ffffffff813faa94>] ? generic_make_request_checks+0x234/0x4c0
> 
> [106204.344875]  [<ffffffff813fdb91>] blk_prologue_bio+0x91/0xc0
> 
> [106204.344879]  [<ffffffff813fd54e>] generic_make_request+0xfe/0x1e0
> 
> [106204.344883]  [<ffffffff813fd692>] submit_bio+0x62/0x150
> 
> [106204.344892]  [<ffffffff811d3257>] do_blockdev_direct_IO+0x2317/0x2ba0
> 
> [106204.344897]  [<ffffffff810b9999>] ? __remove_hrtimer+0x89/0xa0
> 
> [106204.344903]  [<ffffffff8173c08f>] ? udp_poll+0x1f/0xb0
> 
> [106204.344908]  [<ffffffff816b71c7>] ? sock_poll+0x57/0x120
> 
> [106204.344913]  [<ffffffff811cdbf0>] ? I_BDEV+0x10/0x10
> 
> [106204.344918]  [<ffffffff811d3b1e>] __blockdev_direct_IO+0x3e/0x40
> 
> [106204.344922]  [<ffffffff811ce287>] blkdev_direct_IO+0x47/0x50
> 
> [106204.344930]  [<ffffffff81132c60>] generic_file_direct_write+0xb0/0x170
> 
> [106204.344934]  [<ffffffff81132ded>] __generic_file_write_iter+0xcd/0x1f0
> 
> [106204.344943]  [<ffffffff81184ff8>] ? kmem_cache_free+0x78/0x190
> 
> [106204.344948]  [<ffffffff811ce4c0>] ? bd_unlink_disk_holder+0xf0/0xf0
> 
> [106204.344952]  [<ffffffff811ce547>] blkdev_write_iter+0x87/0x110
> 
> [106204.344956]  [<ffffffff811ce4c0>] ? bd_unlink_disk_holder+0xf0/0xf0
> 
> [106204.344962]  [<ffffffff811dec56>] aio_run_iocb+0x236/0x2a0
> 
> [106204.344966]  [<ffffffff811dd183>] ? eventfd_ctx_read+0x53/0x200
> 
> [106204.344973]  [<ffffffff811b3bbf>] ? __fget_light+0x1f/0x60
> 
> [106204.344976]  [<ffffffff811b3c0e>] ? __fdget+0xe/0x10
> 
> [106204.344980]  [<ffffffff811dfb5a>] do_io_submit+0x23a/0x4d0
> 
> [106204.344985]  [<ffffffff811dfdfb>] SyS_io_submit+0xb/0x10
> 
> [106204.344989]  [<ffffffff818154d7>] entry_SYSCALL_64_fastpath+0x12/0x6a
> 
> [106384.345330] INFO: task kvm:37669 blocked for more than 180 seconds.
> 
> [106384.345621]       Tainted: G          IO    4.4.28-1-pserver #1
> 
> [106384.345866] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> 
> [106384.346275] kvm             D ffff882037723710     0 37669      1 0x00000000
> 
> [106384.346282]  ffff882037723710 ffff882038f08d00 ffff882029770d00
> ffff8820377236d8
> 
> [106384.346286]  ffff8820377236d8 ffff882037724000 0000000000308648
> 0000000000000008
> 
> [106384.346290]  ffff880f9bd9e8c0 ffff882037723768 ffff882037723728
> ffffffff81811c60
> 
> [106384.346294] Call Trace:
> 
> [106384.346308]  [<ffffffff81811c60>] schedule+0x30/0x80
> 
> [106384.346317]  [<ffffffffa09d31a2>] bitmap_startwrite+0x122/0x190 [md_mod]
> 
> [106384.346325]  [<ffffffff813f660b>] ? bio_clone_bioset+0x11b/0x310
> 
> [106384.346330]  [<ffffffff810956b0>] ? wait_woken+0x80/0x80
> 
> [106384.346336]  [<ffffffffa0cc5127>] 0xffffffffa0cc5127
> 
> [106384.346341]  [<ffffffffa09c4863>] md_set_array_sectors+0xac3/0xe20 [md_mod]
> 
> [106384.346347]  [<ffffffff813faa94>] ? generic_make_request_checks+0x234/0x4c0
> 
> [106384.346352]  [<ffffffff813fdb91>] blk_prologue_bio+0x91/0xc0
> 
> [106384.346356]  [<ffffffff813fd54e>] generic_make_request+0xfe/0x1e0
> 
> [106384.346360]  [<ffffffff813fd692>] submit_bio+0x62/0x150
> 
> [106384.346369]  [<ffffffff811d3257>] do_blockdev_direct_IO+0x2317/0x2ba0
> 
> 
> (gdb) l *bitmap_startwrite+0x122
> 
> 0x121d2 is in bitmap_startwrite (drivers/md/bitmap.c:1396).
> 
> 
> 
> 1394                 if (unlikely(COUNTER(*bmc) == COUNTER_MAX)) {
> 
> 1395                         DEFINE_WAIT(__wait);
> 
> 1396                         /* note that it is safe to do the prepare_to_wait
> 
> 1397                          * after the test as long as we do it
> before dropping
> 
> 1398                          * the spinlock.
> 
> 1399                          */
> 
> 1400                         prepare_to_wait(&bitmap->overflow_wait, &__wait,
> 
> 1401                                         TASK_UNINTERRUPTIBLE);
> 
> 1402                         spin_unlock_irq(&bitmap->counts.lock);
> 
> 1403                         schedule();
> 
> 1404                         finish_wait(&bitmap->overflow_wait, &__wait);
> 
> 1405                         continue;
> 
> 1406                 }
> 
> so seem KVM is waiting on overflow_wait queue, but somehow no one wake
> him up. During reboot one storage, raid1 has a lot IO errors in that
> time, I guess some error handle part is broken.
> 
> I haven't have a reproducer, just want to report to community, in case
> this is known bug, or anyone has patch already :)

Does the kernel report the raid disk is faulty and gets removed? Is this a
real hang, eg maybe we are waitting for IO error reported.
