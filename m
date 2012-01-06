From: Art -kwaak- van Breemen <ard@telegraafnet.nl>
Subject: Re: raid 1 bug with write-mostly and administrative failed disk
Date: Fri, 6 Jan 2012 22:41:16 +0100
Message-ID: <20120106214115.GF3692@telegraafnet.nl>
References: <20120105213023.GB3692@telegraafnet.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120105213023.GB3692@telegraafnet.nl>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jan 05, 2012 at 10:30:23PM +0100, Art -kwaak- van Breemen wrote:
> This is the test setup:
> mdadm --stop /dev/md5
> mdadm --zero-superblock /dev/sda8
> mdadm --zero-superblock /dev/sdb8
> mdadm --create -l 1 -n 2 --metadata=0.90 --bitmap=internal --bitmap-chunk=1024 --write-behind=2048 /dev/md5 /dev/sdb8 -W /dev/sda8
> (wait until finished)
> mdadm --fail /dev/md5 /dev/sdb8
> # And this to trigger the bug:
> dd if=/dev/md5 of=/dev/null bs=10k count=1

Original test:
- size b < size a; a == write-mostly; write-behind; metadata
  0.90; disk b "fails"
Allright: variations:
- metadata 1.2 -> crash
- size a == size b -> crash
- no write mostly disks -> OK
- fail disk a instead of disk b -> OK
- no write behind or bitmap chunk options, just the writemostly
  -> crash

The failure is persistent accross reboots. Once you only have
write-mostly disks, you are in trouble.

This leaves us with a minimal amount of testoptions:
mdadm --create -l 1 -n 2 --bitmap=internal /dev/md3 /dev/sdb6 -W /dev/sda6
# wait for the rebuild to finish
mdadm --fail /dev/md3 /dev/sdb6
dd if=/dev/md3 of=/dev/null bs=10k count=1

- tested this on 2.6.37 -> OK
- tested this on 2.6.38.8 -> OK
- tested this on 3.0.9 -> OK
- tested this on 3.0.9 -> OK
- tested this on 3.1.4 -> crash
- tested this on 3.2 -> crash
So this is a (major!) regression between 3.0.9 and 3.1.4.

Allright: I've managed to make the test even smaller:
mdadm --create -l 1 -n 2 --bitmap=internal /dev/md3 -W /dev/sdb6 /dev/sda6

Basically I think it boils down to this: if we only have
write-mostly, we probably do not have disks to read from.

Some more debugging info: after the fail (as seen in my first
post), processors start to lockup hard 1 by 1.
So again: first:
------------[ cut here ]------------
kernel BUG at drivers/scsi/scsi_lib.c:1153!
invalid opcode: 0000 [#1] SMP 
CPU 2 
Modules linked in: e1000 bnx2 dcdbas psmouse evdev

Pid: 2768, comm: md3_raid1 Not tainted 3.2.0-d64-i7 #1 Dell Inc. PowerEdge 1950/0DT097
RIP: 0010:[<ffffffff8136f90e>]  [<ffffffff8136f90e>] scsi_setup_fs_cmnd+0xae/0xf0
RSP: 0018:ffff880222f4db70  EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff880221e2d600 RCX: 0000000000000001
RDX: 0000000000000000 RSI: ffff880221e2d600 RDI: ffff880222f99000
RBP: ffff880222f99000 R08: 0000000000000086 R09: 0000000000000001
R10: 4000000000000000 R11: 0000000000000000 R12: ffff880221e2d600
R13: ffff880222f99000 R14: ffff880221bf9c00 R15: 0000000000000800
FS:  0000000000000000(0000) GS:ffff88022fc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000a31008 CR3: 0000000220ee4000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process md3_raid1 (pid: 2768, threadinfo ffff880222f4c000, task ffff880220ebcb30)
Stack:
 ffff880220d51ef8 ffff880221e2d600 ffff880222f960b8 ffffffff813bd5ec
 ffff880222ffd810 0000000000000000 0100000000000000 ffffffff00000000
 0000000000000002 ffff880220d51ef8 ffff880222824908 ffff880221e2d600
Call Trace:
 [<ffffffff813bd5ec>] ? sd_prep_fn+0x15c/0xe10
 [<ffffffff812a6a2f>] ? blk_peek_request+0xbf/0x220
 [<ffffffff8136ed50>] ? scsi_request_fn+0x60/0x570
 [<ffffffff812a7229>] ? queue_unplugged+0x49/0xd0
 [<ffffffff812a7492>] ? blk_flush_plug_list+0x1e2/0x230
 [<ffffffff812a74eb>] ? blk_finish_plug+0xb/0x30
 [<ffffffff8143e17c>] ? raid1d+0x76c/0xec0
 [<ffffffff81093063>] ? lock_timer_base+0x33/0x70
 [<ffffffff81458187>] ? md_thread+0x117/0x150
 [<ffffffff810a4d40>] ? wake_up_bit+0x40/0x40
 [<ffffffff81458070>] ? md_register_thread+0x100/0x100
 [<ffffffff81458070>] ? md_register_thread+0x100/0x100
 [<ffffffff810a4836>] ? kthread+0x96/0xa0
 [<ffffffff815750f4>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff810a47a0>] ? kthread_worker_fn+0x180/0x180
 [<ffffffff815750f0>] ? gs_change+0xb/0xb
Code: 00 00 0f 1f 00 48 83 c4 08 5b 5d c3 90 48 89 ef be 20 00 00 00 e8 83 93 ff ff 48 89 c7 48 85 c0 74 db 48 89 83 e8 00 00 00 eb 91 <0f> 0b eb fe 48 8b 00 48 85 c0 0f 84 67 ff ff ff 48 8b 40 50 48 
RIP  [<ffffffff8136f90e>] scsi_setup_fs_cmnd+0xae/0xf0
 RSP <ffff880222f4db70>
---[ end trace 9045ba4c41e91f50 ]---

And then we get:
------------[ cut here ]------------
WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x98/0xc0()
Hardware name: PowerEdge 1950
Watchdog detected hard LOCKUP on cpu 2
Modules linked in: e1000 bnx2 dcdbas psmouse evdev
Pid: 2768, comm: md3_raid1 Tainted: G      D      3.2.0-d64-i7 #1
Call Trace:
 <NMI>  [<ffffffff8108454b>] ? warn_slowpath_common+0x7b/0xc0
 [<ffffffff81084645>] ? warn_slowpath_fmt+0x45/0x50
 [<ffffffff810d2bf8>] ? watchdog_overflow_callback+0x98/0xc0
 [<ffffffff810fc99a>] ? __perf_event_overflow+0x9a/0x1f0
 [<ffffffff810aa905>] ? sched_clock_local+0x15/0x80
 [<ffffffff81052db9>] ? intel_pmu_handle_irq+0x149/0x280
 [<ffffffff81042b78>] ? do_nmi+0x108/0x360
 [<ffffffff8157384a>] ? nmi+0x1a/0x20
 [<ffffffff81573052>] ? _raw_spin_lock_irqsave+0x22/0x30
 <<EOE>>  [<ffffffff812b7d82>] ? cfq_exit_single_io_context+0x32/0x90
 [<ffffffff812b7e04>] ? cfq_exit_io_context+0x24/0x40
 [<ffffffff812aa7df>] ? exit_io_context+0x4f/0x70
 [<ffffffff81088aaa>] ? do_exit+0x58a/0x850
 [<ffffffff815705e4>] ? printk+0x40/0x45
 [<ffffffff81042652>] ? oops_end+0x72/0xa0
 [<ffffffff810403a4>] ? do_invalid_op+0x84/0xa0
 [<ffffffff8136f90e>] ? scsi_setup_fs_cmnd+0xae/0xf0
 [<ffffffff812b8687>] ? cfq_init_prio_data+0x67/0x120
 [<ffffffff812b8d73>] ? cfq_get_queue+0x523/0x5b0
 [<ffffffff81574f75>] ? invalid_op+0x15/0x20
 [<ffffffff8136f90e>] ? scsi_setup_fs_cmnd+0xae/0xf0
 [<ffffffff813bd5ec>] ? sd_prep_fn+0x15c/0xe10
 [<ffffffff812a6a2f>] ? blk_peek_request+0xbf/0x220
 [<ffffffff8136ed50>] ? scsi_request_fn+0x60/0x570
 [<ffffffff812a7229>] ? queue_unplugged+0x49/0xd0
 [<ffffffff812a7492>] ? blk_flush_plug_list+0x1e2/0x230
 [<ffffffff812a74eb>] ? blk_finish_plug+0xb/0x30
 [<ffffffff8143e17c>] ? raid1d+0x76c/0xec0
 [<ffffffff81093063>] ? lock_timer_base+0x33/0x70
 [<ffffffff81458187>] ? md_thread+0x117/0x150
 [<ffffffff810a4d40>] ? wake_up_bit+0x40/0x40
 [<ffffffff81458070>] ? md_register_thread+0x100/0x100
 [<ffffffff81458070>] ? md_register_thread+0x100/0x100
 [<ffffffff810a4836>] ? kthread+0x96/0xa0
 [<ffffffff815750f4>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff810a47a0>] ? kthread_worker_fn+0x180/0x180
 [<ffffffff815750f0>] ? gs_change+0xb/0xb
---[ end trace 9045ba4c41e91f51 ]---
And:
------------[ cut here ]------------
WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x98/0xc0()
Hardware name: PowerEdge 1950
Watchdog detected hard LOCKUP on cpu 3
Modules linked in: e1000 bnx2 dcdbas psmouse evdev
Pid: 1256, comm: md0_raid1 Tainted: G      D W    3.2.0-d64-i7 #1
Call Trace:
 <NMI>  [<ffffffff8108454b>] ? warn_slowpath_common+0x7b/0xc0
 [<ffffffff81084645>] ? warn_slowpath_fmt+0x45/0x50
 [<ffffffff810d2bf8>] ? watchdog_overflow_callback+0x98/0xc0
 [<ffffffff810fc99a>] ? __perf_event_overflow+0x9a/0x1f0
 [<ffffffff810aa905>] ? sched_clock_local+0x15/0x80
 [<ffffffff81052db9>] ? intel_pmu_handle_irq+0x149/0x280
 [<ffffffff81042b78>] ? do_nmi+0x108/0x360
 [<ffffffff8157384a>] ? nmi+0x1a/0x20
 [<ffffffff8157307a>] ? _raw_spin_lock_irq+0x1a/0x30
 <<EOE>>  [<ffffffff812a75d5>] ? blk_queue_bio+0xc5/0x350
 [<ffffffff812a581f>] ? generic_make_request+0xaf/0xe0
 [<ffffffff812a58be>] ? submit_bio+0x6e/0xf0
 [<ffffffff81458f37>] ? md_super_write+0x67/0xc0
 [<ffffffff814592a6>] ? md_update_sb+0x316/0x560
 [<ffffffff8145a97a>] ? md_check_recovery+0x29a/0x6a0
 [<ffffffff8143da42>] ? raid1d+0x32/0xec0
 [<ffffffff81458187>] ? md_thread+0x117/0x150
 [<ffffffff810a4d40>] ? wake_up_bit+0x40/0x40
 [<ffffffff81458070>] ? md_register_thread+0x100/0x100
 [<ffffffff81458070>] ? md_register_thread+0x100/0x100
 [<ffffffff810a4836>] ? kthread+0x96/0xa0
 [<ffffffff815750f4>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff810a47a0>] ? kthread_worker_fn+0x180/0x180
 [<ffffffff815750f0>] ? gs_change+0xb/0xb
---[ end trace 9045ba4c41e91f52 ]---

I think that it means something in the block handling gets locked.
Anyway, off to home.

Regards,
Ard
