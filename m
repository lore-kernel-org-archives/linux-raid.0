From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: INFO: task pdflush:393 blocked for more than 120 seconds. & Call
 traces ...
Date: Sun, 20 Jul 2008 18:49:47 -0800 (AKDT)
Message-ID: <Pine.LNX.4.64.0807201848380.1688@filesrv1.baby-dragons.com>
References: <Pine.LNX.4.64.0807201656590.1196@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0807201656590.1196@filesrv1.baby-dragons.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

 	Hello All,  A follow up ... Sysrq-w & Sysrq-B output .  Hth ,  JimL

SysRq : Show Blocked State
Jul 21 02:22:26 filesrv2 kernel: SysRq : Show Blocked State
Jul 21 02:22:26 filesrv2 kernel:   task                PC stack   pid father
Jul 21 02:22:26 filesrv2 kernel: pdflush       D c8209f80  4748   393      2
Jul 21 02:22:26 filesrv2 kernel:        f75e5e58 00000046 f7f7ad50 c8209f80 f7f7a8a0 f75e5e24 c014fc57 00000000
Jul 21 02:22:26 filesrv2 kernel:        f7f7a8a0 e5d0dd00 c8209f80 f75e4000 c0819e00 c8209f80 f7f7aaf4 f75e5e44
Jul 21 02:22:26 filesrv2 kernel:        00000286 f75e5e80 f510de30 f75e5e58 c0142233 f510de00 f75e5e80 f510de30
Jul 21 02:22:26 filesrv2 kernel: Call Trace:
Jul 21 02:22:26 filesrv2 kernel:  [<c014fc57>] ? mark_held_locks+0x67/0x80
Jul 21 02:22:26 filesrv2 kernel:  [<c0142233>] ? add_wait_queue+0x33/0x50
Jul 21 02:22:26 filesrv2 kernel:  [<c03a7f85>] xfs_buf_wait_unpin+0xb5/0xe0
Jul 21 02:22:26 filesrv2 kernel:  [<c0127a60>] ? default_wake_function+0x0/0x10
Jul 21 02:22:26 filesrv2 kernel:  [<c0127a60>] ? default_wake_function+0x0/0x10
Jul 21 02:22:26 filesrv2 kernel:  [<c03a84fb>] xfs_buf_iorequest+0x4b/0x80
Jul 21 02:22:26 filesrv2 kernel:  [<c03adeee>] xfs_bdstrat_cb+0x3e/0x50
Jul 21 02:22:26 filesrv2 kernel:  [<c03a495c>] xfs_bwrite+0x5c/0xe0
Jul 21 02:22:26 filesrv2 kernel:  [<c039e941>] xfs_syncsub+0x121/0x2b0
Jul 21 02:22:26 filesrv2 kernel:  [<c018a43b>] ? lock_super+0x1b/0x20
Jul 21 02:22:26 filesrv2 kernel:  [<c018a43b>] ? lock_super+0x1b/0x20
Jul 21 02:22:26 filesrv2 kernel:  [<c039e1d8>] xfs_sync+0x48/0x70
Jul 21 02:22:26 filesrv2 kernel:  [<c03af833>] xfs_fs_write_super+0x23/0x30
Jul 21 02:22:26 filesrv2 kernel:  [<c018a80f>] sync_supers+0xaf/0xc0
Jul 21 02:22:26 filesrv2 kernel:  [<c0169259>] wb_kupdate+0x29/0x100
Jul 21 02:22:26 filesrv2 kernel:  [<c016a0cc>] ? __pdflush+0xcc/0x1a0
Jul 21 02:22:26 filesrv2 kernel:  [<c016a0d2>] __pdflush+0xd2/0x1a0
Jul 21 02:22:26 filesrv2 kernel:  [<c016a1a0>] ? pdflush+0x0/0x40
Jul 21 02:22:26 filesrv2 kernel:  [<c016a1d1>] pdflush+0x31/0x40
Jul 21 02:22:26 filesrv2 kernel:  [<c0169230>] ? wb_kupdate+0x0/0x100
Jul 21 02:22:26 filesrv2 kernel:  [<c016a1a0>] ? pdflush+0x0/0x40
Jul 21 02:22:26 filesrv2 kernel:  [<c0141e2c>] kthread+0x5c/0xa0
Jul 21 02:22:26 filesrv2 kernel:  [<c0141dd0>] ? kthread+0x0/0xa0
Jul 21 02:22:26 filesrv2 kernel:  [<c0103d67>] kernel_thread_helper+0x7/0x10
Jul 21 02:22:26 filesrv2 kernel:  =======================
Jul 21 02:22:26 filesrv2 kernel: kswapd0       D c8227f80  6088   394      2
Jul 21 02:22:26 filesrv2 kernel:        f75e7e08 00000046 f75e7dc8 c8227f80 f7e9e420 f7e9e420 c0806c77 f7ce6000
Jul 21 02:22:26 filesrv2 kernel:        00000000 e5d0dd00 c8227f80 f75e6000 f75e7de8 c8227f80 f7e9e674 f7ce6000
Jul 21 02:22:26 filesrv2 kernel:        f75e7e08 c01374b0 00000000 0016c52a 00000292 f75e7e18 0016c52a f75e7e88
Jul 21 02:22:27 filesrv2 kernel: Call Trace:
Jul 21 02:22:27 filesrv2 kernel:  [<c0806c77>] ? _spin_unlock_irqrestore+0x47/0x60
Jul 21 02:22:27 filesrv2 kernel:  [<c01374b0>] ? __mod_timer+0xa0/0xb0
Jul 21 02:22:27 filesrv2 kernel:  [<c0804f46>] schedule_timeout+0x46/0x90
Jul 21 02:22:27 filesrv2 kernel:  [<c0137b60>] ? process_timeout+0x0/0x10
Jul 21 02:22:27 filesrv2 kernel:  [<c0804f41>] ? schedule_timeout+0x41/0x90
Jul 21 02:22:27 filesrv2 kernel:  [<c0804e98>] io_schedule_timeout+0x48/0x90
Jul 21 02:22:27 filesrv2 kernel:  [<c016f6c2>] congestion_wait+0x72/0x90
Jul 21 02:22:27 filesrv2 kernel:  [<c0142410>] ? autoremove_wake_function+0x0/0x50
Jul 21 02:22:27 filesrv2 kernel:  [<c0168b55>] ? get_dirty_limits+0x15/0x1c0
Jul 21 02:22:27 filesrv2 kernel:  [<c0142410>] ? autoremove_wake_function+0x0/0x50
Jul 21 02:22:27 filesrv2 kernel:  [<c016913b>] throttle_vm_writeout+0x6b/0x80
Jul 21 02:22:27 filesrv2 kernel:  [<c016d0f7>] shrink_zone+0xd7/0xf0
Jul 21 02:22:27 filesrv2 kernel:  [<c016d7c5>] balance_pgdat+0x365/0x390
Jul 21 02:22:27 filesrv2 kernel:  [<c0806c77>] ? _spin_unlock_irqrestore+0x47/0x60
Jul 21 02:22:27 filesrv2 kernel:  [<c016c7d0>] ? isolate_pages_global+0x0/0x80
Jul 21 02:22:27 filesrv2 kernel:  [<c0142323>] ? prepare_to_wait+0x43/0x60
Jul 21 02:22:27 filesrv2 kernel:  [<c016d8d4>] kswapd+0xe4/0x150
Jul 21 02:22:27 filesrv2 kernel:  [<c0142410>] ? autoremove_wake_function+0x0/0x50
Jul 21 02:22:27 filesrv2 kernel:  [<c0142410>] ? autoremove_wake_function+0x0/0x50
Jul 21 02:22:27 filesrv2 kernel:  [<c0127bf6>] ? complete+0x46/0x60
Jul 21 02:22:27 filesrv2 kernel:  [<c016d7f0>] ? kswapd+0x0/0x150
Jul 21 02:22:27 filesrv2 kernel:  [<c0141e2c>] kthread+0x5c/0xa0
Jul 21 02:22:27 filesrv2 kernel:  [<c0141dd0>] ? kthread+0x0/0xa0
Jul 21 02:22:27 filesrv2 kernel:  [<c0103d67>] kernel_thread_helper+0x7/0x10
Jul 21 02:22:27 filesrv2 kernel:  =======================
Jul 21 02:22:27 filesrv2 kernel: bonnie++      D c81fff80  3804  3978   3976
Jul 21 02:22:27 filesrv2 kernel:        e5d67c1c 00000046 e5d67bdc c81fff80 e68dc920 e68dc920 c0806c77 f7c78000
Jul 21 02:22:27 filesrv2 kernel:        00000000 e69ca800 c81fff80 e5d66000 e5d67bfc c81fff80 e68dcb74 f7c78000
Jul 21 02:22:27 filesrv2 kernel:        e5d67c1c c01374b0 00000000 0016c52a 00000282 e5d67c2c 0016c52a e5d67c9c
Jul 21 02:22:27 filesrv2 kernel: Call Trace:
Jul 21 02:22:27 filesrv2 kernel:  [<c0806c77>] ? _spin_unlock_irqrestore+0x47/0x60
Jul 21 02:22:27 filesrv2 kernel:  [<c01374b0>] ? __mod_timer+0xa0/0xb0
Jul 21 02:22:27 filesrv2 kernel:  [<c0804f46>] schedule_timeout+0x46/0x90
Jul 21 02:22:27 filesrv2 kernel:  [<c0137b60>] ? process_timeout+0x0/0x10
Jul 21 02:22:27 filesrv2 kernel:  [<c0804f41>] ? schedule_timeout+0x41/0x90
Jul 21 02:22:27 filesrv2 kernel:  [<c0804e98>] io_schedule_timeout+0x48/0x90
Jul 21 02:22:27 filesrv2 kernel:  [<c016f6c2>] congestion_wait+0x72/0x90
Jul 21 02:22:27 filesrv2 kernel:  [<c0142410>] ? autoremove_wake_function+0x0/0x50
Jul 21 02:22:28 filesrv2 kernel:  [<c0168ce6>] ? get_dirty_limits+0x1a6/0x1c0
Jul 21 02:22:28 filesrv2 kernel:  [<c0142410>] ? autoremove_wake_function+0x0/0x50
Jul 21 02:22:28 filesrv2 kernel:  [<c0168e86>] balance_dirty_pages+0x186/0x320
Jul 21 02:22:28 filesrv2 kernel:  [<c01690c9>] balance_dirty_pages_ratelimited_nr+0x59/0x60
Jul 21 02:22:28 filesrv2 kernel:  [<c01640eb>] generic_perform_write+0x13b/0x180
Jul 21 02:22:28 filesrv2 kernel:  [<c0164197>] generic_file_buffered_write+0x67/0x110
Jul 21 02:22:28 filesrv2 kernel:  [<c03adc5e>] xfs_write+0x68e/0x8e0
Jul 21 02:22:28 filesrv2 kernel:  [<c05d3198>] ? scsi_softirq_done+0xa8/0x100
Jul 21 02:22:28 filesrv2 kernel:  [<c0417a09>] ? blk_done_softirq+0x39/0x80
Jul 21 02:22:28 filesrv2 kernel:  [<c03a963b>] xfs_file_aio_write+0x6b/0x80
Jul 21 02:22:28 filesrv2 kernel:  [<c0188b07>] do_sync_write+0xc7/0x120
Jul 21 02:22:28 filesrv2 kernel:  [<c0142410>] ? autoremove_wake_function+0x0/0x50
Jul 21 02:22:28 filesrv2 kernel:  [<c015116c>] ? __lock_release+0x3c/0x70
Jul 21 02:22:28 filesrv2 kernel:  [<c03e026f>] ? security_file_permission+0xf/0x20
Jul 21 02:22:28 filesrv2 kernel:  [<c0188709>] ? rw_verify_area+0x59/0xd0
Jul 21 02:22:28 filesrv2 kernel:  [<c0806bed>] ? _spin_unlock+0x1d/0x20
Jul 21 02:22:28 filesrv2 kernel:  [<c0188bf1>] vfs_write+0x91/0x160
Jul 21 02:22:28 filesrv2 kernel:  [<c0188d6d>] sys_write+0x3d/0x70
Jul 21 02:22:28 filesrv2 kernel:  [<c01030fa>] syscall_call+0x7/0xb
Jul 21 02:22:28 filesrv2 kernel:  =======================
Jul 21 02:22:28 filesrv2 kernel: bonnie++      D c81fff80  4016  3980   3977
Jul 21 02:22:28 filesrv2 kernel:        e5c2dc1c 00000046 e5c2dbdc c81fff80 e615ca20 e615ca20 c0806c77 f7c78000
Jul 21 02:22:28 filesrv2 kernel:        00000000 f690bd00 c81fff80 e5c2c000 e5c2dbfc c81fff80 e615cc74 f7c78000
Jul 21 02:22:28 filesrv2 kernel:        e5c2dc1c c01374b0 00000000 0016c52a 00000282 e5c2dc2c 0016c52a e5c2dc9c
Jul 21 02:22:28 filesrv2 kernel: Call Trace:
Jul 21 02:22:28 filesrv2 kernel:  [<c0806c77>] ? _spin_unlock_irqrestore+0x47/0x60
Jul 21 02:22:28 filesrv2 kernel:  [<c01374b0>] ? __mod_timer+0xa0/0xb0
Jul 21 02:22:28 filesrv2 kernel:  [<c0804f46>] schedule_timeout+0x46/0x90
Jul 21 02:22:28 filesrv2 kernel:  [<c0137b60>] ? process_timeout+0x0/0x10
Jul 21 02:22:28 filesrv2 kernel:  [<c0804f41>] ? schedule_timeout+0x41/0x90
Jul 21 02:22:28 filesrv2 kernel:  [<c0804e98>] io_schedule_timeout+0x48/0x90
Jul 21 02:22:28 filesrv2 kernel:  [<c016f6c2>] congestion_wait+0x72/0x90
Jul 21 02:22:28 filesrv2 kernel:  [<c0142410>] ? autoremove_wake_function+0x0/0x50
Jul 21 02:22:28 filesrv2 kernel:  [<c0168ce6>] ? get_dirty_limits+0x1a6/0x1c0
Jul 21 02:22:28 filesrv2 kernel:  [<c0142410>] ? autoremove_wake_function+0x0/0x50
Jul 21 02:22:28 filesrv2 kernel:  [<c0168e86>] balance_dirty_pages+0x186/0x320
Jul 21 02:22:28 filesrv2 kernel:  [<c01690c9>] balance_dirty_pages_ratelimited_nr+0x59/0x60
Jul 21 02:22:28 filesrv2 kernel:  [<c01640eb>] generic_perform_write+0x13b/0x180
Jul 21 02:22:29 filesrv2 kernel:  [<c0164197>] generic_file_buffered_write+0x67/0x110
Jul 21 02:22:29 filesrv2 kernel:  [<c03adc5e>] xfs_write+0x68e/0x8e0
Jul 21 02:22:29 filesrv2 kernel:  [<c0148486>] ? getnstimeofday+0x46/0x150
Jul 21 02:22:29 filesrv2 kernel:  [<c013788d>] ? run_timer_softirq+0xed/0x190
Jul 21 02:22:29 filesrv2 kernel:  [<c03a963b>] xfs_file_aio_write+0x6b/0x80
Jul 21 02:22:29 filesrv2 kernel:  [<c0188b07>] do_sync_write+0xc7/0x120
Jul 21 02:22:29 filesrv2 kernel:  [<c0142410>] ? autoremove_wake_function+0x0/0x50
Jul 21 02:22:29 filesrv2 kernel:  [<c015116c>] ? __lock_release+0x3c/0x70
Jul 21 02:22:29 filesrv2 kernel:  [<c03e026f>] ? security_file_permission+0xf/0x20
Jul 21 02:22:29 filesrv2 kernel:  [<c0188709>] ? rw_verify_area+0x59/0xd0
Jul 21 02:22:29 filesrv2 kernel:  [<c0806bed>] ? _spin_unlock+0x1d/0x20
Jul 21 02:22:29 filesrv2 kernel:  [<c0188bf1>] vfs_write+0x91/0x160
Jul 21 02:22:29 filesrv2 kernel:  [<c0188d6d>] sys_write+0x3d/0x70
Jul 21 02:22:29 filesrv2 kernel:  [<c01030fa>] syscall_call+0x7/0xb
Jul 21 02:22:29 filesrv2 kernel:  =======================
Jul 21 02:22:29 filesrv2 kernel: bonnie++      D c81fff80  4024  3982   3979
Jul 21 02:22:29 filesrv2 kernel:        e6565c1c 00000046 e6565bdc c81fff80 e6dc4b20 e6dc4b20 c0806c77 f7c78000
Jul 21 02:22:29 filesrv2 kernel:        e6565bec f654d800 c81fff80 e6564000 c0819e00 c81fff80 e6dc4d74 f7c78000
Jul 21 02:22:29 filesrv2 kernel:        e6565c1c c01374b0 00000000 0016c52a 00000282 e6565c2c 0016c52a e6565c9c
Jul 21 02:22:29 filesrv2 kernel: Call Trace:
Jul 21 02:22:29 filesrv2 kernel:  [<c0806c77>] ? _spin_unlock_irqrestore+0x47/0x60
Jul 21 02:22:29 filesrv2 kernel:  [<c01374b0>] ? __mod_timer+0xa0/0xb0
Jul 21 02:22:29 filesrv2 kernel:  [<c0804f46>] schedule_timeout+0x46/0x90
Jul 21 02:22:29 filesrv2 kernel:  [<c0137b60>] ? process_timeout+0x0/0x10
Jul 21 02:22:29 filesrv2 kernel:  [<c0804f41>] ? schedule_timeout+0x41/0x90
Jul 21 02:22:29 filesrv2 kernel:  [<c0804e98>] io_schedule_timeout+0x48/0x90
Jul 21 02:22:29 filesrv2 kernel:  [<c016f6c2>] congestion_wait+0x72/0x90
Jul 21 02:22:29 filesrv2 kernel:  [<c0142410>] ? autoremove_wake_function+0x0/0x50
Jul 21 02:22:29 filesrv2 kernel:  [<c0168ce6>] ? get_dirty_limits+0x1a6/0x1c0
Jul 21 02:22:29 filesrv2 kernel:  [<c0142410>] ? autoremove_wake_function+0x0/0x50
Jul 21 02:22:29 filesrv2 kernel:  [<c0168e86>] balance_dirty_pages+0x186/0x320
Jul 21 02:22:29 filesrv2 kernel:  [<c01690c9>] balance_dirty_pages_ratelimited_nr+0x59/0x60
Jul 21 02:22:29 filesrv2 kernel:  [<c01640eb>] generic_perform_write+0x13b/0x180
Jul 21 02:22:29 filesrv2 kernel:  [<c0164197>] generic_file_buffered_write+0x67/0x110
Jul 21 02:22:29 filesrv2 kernel:  [<c03adc5e>] xfs_write+0x68e/0x8e0
Jul 21 02:22:29 filesrv2 kernel:  [<c05d3198>] ? scsi_softirq_done+0xa8/0x100
Jul 21 02:22:29 filesrv2 kernel:  [<c014f234>] ? validate_chain+0x1c4/0x310
Jul 21 02:22:29 filesrv2 kernel:  [<c0417a09>] ? blk_done_softirq+0x39/0x80
Jul 21 02:22:30 filesrv2 kernel:  [<c03a963b>] xfs_file_aio_write+0x6b/0x80
Jul 21 02:22:30 filesrv2 kernel:  [<c0188b07>] do_sync_write+0xc7/0x120
Jul 21 02:22:30 filesrv2 kernel:  [<c0142410>] ? autoremove_wake_function+0x0/0x50
Jul 21 02:22:30 filesrv2 kernel:  [<c0806c67>] ? _spin_unlock_irqrestore+0x37/0x60
Jul 21 02:22:30 filesrv2 kernel:  [<c03e026f>] ? security_file_permission+0xf/0x20
Jul 21 02:22:30 filesrv2 kernel:  [<c0188709>] ? rw_verify_area+0x59/0xd0
Jul 21 02:22:30 filesrv2 kernel:  [<c0188bf1>] vfs_write+0x91/0x160
Jul 21 02:22:30 filesrv2 kernel:  [<c011ed65>] ? hrtick_set+0x85/0x110
Jul 21 02:22:30 filesrv2 kernel:  [<c0188d6d>] sys_write+0x3d/0x70
Jul 21 02:22:30 filesrv2 kernel:  [<c01030fa>] syscall_call+0x7/0xb
Jul 21 02:22:30 filesrv2 kernel:  =======================
Jul 21 02:22:30 filesrv2 kernel: bonnie++      D c8227f80  3988  3983   3981
Jul 21 02:22:30 filesrv2 kernel:        e6dabc1c 00000046 e6dabbdc c8227f80 e5c18020 e5c18020 c0806c77 f7ce6000
Jul 21 02:22:30 filesrv2 kernel:        e6dabbec e5d0dd00 c8227f80 e6daa000 c0819e00 c8227f80 e5c18274 f7ce6000
Jul 21 02:22:30 filesrv2 kernel:        e6dabc1c c01374b0 00000000 0016c52a 00000282 e6dabc2c 0016c52a e6dabc9c
Jul 21 02:22:30 filesrv2 kernel: Call Trace:
Jul 21 02:22:30 filesrv2 kernel:  [<c0806c77>] ? _spin_unlock_irqrestore+0x47/0x60
Jul 21 02:22:30 filesrv2 kernel:  [<c01374b0>] ? __mod_timer+0xa0/0xb0
Jul 21 02:22:30 filesrv2 kernel:  [<c0804f46>] schedule_timeout+0x46/0x90
Jul 21 02:22:30 filesrv2 kernel:  [<c0137b60>] ? process_timeout+0x0/0x10
Jul 21 02:22:30 filesrv2 kernel:  [<c0804f41>] ? schedule_timeout+0x41/0x90
Jul 21 02:22:30 filesrv2 kernel:  [<c0804e98>] io_schedule_timeout+0x48/0x90
Jul 21 02:22:30 filesrv2 kernel:  [<c016f6c2>] congestion_wait+0x72/0x90
Jul 21 02:22:30 filesrv2 kernel:  [<c0142410>] ? autoremove_wake_function+0x0/0x50
Jul 21 02:22:30 filesrv2 kernel:  [<c0168ce6>] ? get_dirty_limits+0x1a6/0x1c0
Jul 21 02:22:30 filesrv2 kernel:  [<c0142410>] ? autoremove_wake_function+0x0/0x50
Jul 21 02:22:30 filesrv2 kernel:  [<c0168e86>] balance_dirty_pages+0x186/0x320
Jul 21 02:22:30 filesrv2 kernel:  [<c01690c9>] balance_dirty_pages_ratelimited_nr+0x59/0x60
Jul 21 02:22:30 filesrv2 kernel:  [<c01640eb>] generic_perform_write+0x13b/0x180
Jul 21 02:22:30 filesrv2 kernel:  [<c0164197>] generic_file_buffered_write+0x67/0x110
Jul 21 02:22:30 filesrv2 kernel:  [<c03adc5e>] xfs_write+0x68e/0x8e0
Jul 21 02:22:30 filesrv2 kernel:  [<c0150849>] ? __lock_acquire+0x199/0x700
Jul 21 02:22:30 filesrv2 kernel:  [<c014f234>] ? validate_chain+0x1c4/0x310
Jul 21 02:22:30 filesrv2 kernel:  [<c03a963b>] xfs_file_aio_write+0x6b/0x80
Jul 21 02:22:30 filesrv2 kernel:  [<c0188b07>] do_sync_write+0xc7/0x120
Jul 21 02:22:30 filesrv2 kernel:  [<c0142410>] ? autoremove_wake_function+0x0/0x50
Jul 21 02:22:30 filesrv2 kernel:  [<c015116c>] ? __lock_release+0x3c/0x70
Jul 21 02:22:31 filesrv2 kernel:  [<c03e026f>] ? security_file_permission+0xf/0x20
Jul 21 02:22:31 filesrv2 kernel:  [<c0188709>] ? rw_verify_area+0x59/0xd0
Jul 21 02:22:31 filesrv2 kernel:  [<c0806bed>] ? _spin_unlock+0x1d/0x20
Jul 21 02:22:31 filesrv2 kernel:  [<c0188bf1>] vfs_write+0x91/0x160
Jul 21 02:22:31 filesrv2 kernel:  [<c0188d6d>] sys_write+0x3d/0x70
Jul 21 02:22:31 filesrv2 kernel:  [<c01030fa>] syscall_call+0x7/0xb
Jul 21 02:22:31 filesrv2 kernel:  =======================
Jul 21 02:22:31 filesrv2 kernel: bonnie++      D c8227f80  3948  3985   3984
Jul 21 02:22:31 filesrv2 kernel:        e6541c1c 00000046 e6541bdc c8227f80 e69a40a0 e69a40a0 c0806c77 f7ce6000
Jul 21 02:22:31 filesrv2 kernel:        00000000 f65e4580 c8227f80 e6540000 e6541bfc c8227f80 e69a42f4 f7ce6000
Jul 21 02:22:31 filesrv2 kernel:        e6541c1c c01374b0 00000000 0016c52a 00000282 e6541c2c 0016c52a e6541c9c
Jul 21 02:22:31 filesrv2 kernel: Call Trace:
Jul 21 02:22:31 filesrv2 kernel:  [<c0806c77>] ? _spin_unlock_irqrestore+0x47/0x60
Jul 21 02:22:31 filesrv2 kernel:  [<c01374b0>] ? __mod_timer+0xa0/0xb0
Jul 21 02:22:31 filesrv2 kernel:  [<c0804f46>] schedule_timeout+0x46/0x90
Jul 21 02:22:31 filesrv2 kernel:  [<c0137b60>] ? process_timeout+0x0/0x10
Jul 21 02:22:31 filesrv2 kernel:  [<c0804f41>] ? schedule_timeout+0x41/0x90
Jul 21 02:22:31 filesrv2 kernel:  [<c0804e98>] io_schedule_timeout+0x48/0x90
Jul 21 02:22:31 filesrv2 kernel:  [<c016f6c2>] congestion_wait+0x72/0x90
Jul 21 02:22:31 filesrv2 kernel:  [<c0142410>] ? autoremove_wake_function+0x0/0x50
Jul 21 02:22:31 filesrv2 kernel:  [<c0168ce6>] ? get_dirty_limits+0x1a6/0x1c0
Jul 21 02:22:31 filesrv2 kernel:  [<c0142410>] ? autoremove_wake_function+0x0/0x50
Jul 21 02:22:31 filesrv2 kernel:  [<c0168e86>] balance_dirty_pages+0x186/0x320
Jul 21 02:22:31 filesrv2 kernel:  [<c01690c9>] balance_dirty_pages_ratelimited_nr+0x59/0x60
Jul 21 02:22:31 filesrv2 kernel:  [<c01640eb>] generic_perform_write+0x13b/0x180
Jul 21 02:22:31 filesrv2 kernel:  [<c0164197>] generic_file_buffered_write+0x67/0x110
Jul 21 02:22:31 filesrv2 kernel:  [<c03adc5e>] xfs_write+0x68e/0x8e0
Jul 21 02:22:31 filesrv2 kernel:  [<c04162f0>] ? blk_run_queue+0x30/0x40
Jul 21 02:22:31 filesrv2 kernel:  [<c014f234>] ? validate_chain+0x1c4/0x310
Jul 21 02:22:31 filesrv2 kernel:  [<c0426ac0>] ? kobject_put+0x20/0x50
Jul 21 02:22:31 filesrv2 kernel:  [<c03a963b>] xfs_file_aio_write+0x6b/0x80
Jul 21 02:22:31 filesrv2 kernel:  [<c0188b07>] do_sync_write+0xc7/0x120
Jul 21 02:22:31 filesrv2 kernel:  [<c0142410>] ? autoremove_wake_function+0x0/0x50
Jul 21 02:22:31 filesrv2 kernel:  [<c015116c>] ? __lock_release+0x3c/0x70
Jul 21 02:22:31 filesrv2 kernel:  [<c03e026f>] ? security_file_permission+0xf/0x20
Jul 21 02:22:31 filesrv2 kernel:  [<c0188709>] ? rw_verify_area+0x59/0xd0
Jul 21 02:22:31 filesrv2 kernel:  [<c0806bed>] ? _spin_unlock+0x1d/0x20
Jul 21 02:22:32 filesrv2 kernel:  [<c0188bf1>] vfs_write+0x91/0x160
Jul 21 02:22:32 filesrv2 kernel:  [<c0188d6d>] sys_write+0x3d/0x70
Jul 21 02:22:32 filesrv2 kernel:  [<c01030fa>] syscall_call+0x7/0xb
Jul 21 02:22:32 filesrv2 kernel:  =======================
Jul 21 02:22:32 filesrv2 kernel: Sched Debug Version: v0.07, 2.6.26-rc9 #1
Jul 21 02:22:32 filesrv2 kernel: now at 15222615.902432 msecs
Jul 21 02:22:32 filesrv2 kernel:   .sysctl_sched_latency                    : 80.000000
Jul 21 02:22:32 filesrv2 kernel:   .sysctl_sched_min_granularity            : 16.000000
Jul 21 02:22:32 filesrv2 kernel:   .sysctl_sched_wakeup_granularity         : 40.000000
Jul 21 02:22:32 filesrv2 kernel:   .sysctl_sched_child_runs_first           : 0.000001
Jul 21 02:22:32 filesrv2 kernel:   .sysctl_sched_features                   : 895
Jul 21 02:22:32 filesrv2 kernel:
Jul 21 02:22:32 filesrv2 kernel: cpu#0, 3000.131 MHz
Jul 21 02:22:32 filesrv2 kernel:   .nr_running                    : 0
Jul 21 02:22:32 filesrv2 kernel:   .load                          : 0
Jul 21 02:22:32 filesrv2 kernel:   .nr_switches                   : 3337768
Jul 21 02:22:32 filesrv2 kernel:   .nr_load_updates               : 1522260
Jul 21 02:22:32 filesrv2 kernel:   .nr_uninterruptible            : 4294950199
Jul 21 02:22:32 filesrv2 kernel:   .jiffies                       : 1492261
Jul 21 02:22:32 filesrv2 kernel:   .next_balance                  : 1.492262
Jul 21 02:22:32 filesrv2 kernel:   .curr->pid                     : 0
Jul 21 02:22:32 filesrv2 kernel:   .clock                         : 15222610.006364
Jul 21 02:22:32 filesrv2 kernel:   .cpu_load[0]                   : 0
Jul 21 02:22:32 filesrv2 kernel:   .cpu_load[1]                   : 0
Jul 21 02:22:32 filesrv2 kernel:   .cpu_load[2]                   : 0
Jul 21 02:22:32 filesrv2 kernel:   .cpu_load[3]                   : 7
Jul 21 02:22:32 filesrv2 kernel:   .cpu_load[4]                   : 273
Jul 21 02:22:32 filesrv2 kernel:
Jul 21 02:22:32 filesrv2 kernel: cfs_rq[0]:
Jul 21 02:22:32 filesrv2 kernel:   .exec_clock                    : 642920.799359
Jul 21 02:22:32 filesrv2 kernel:   .MIN_vruntime                  : 0.000001
Jul 21 02:22:32 filesrv2 kernel:   .min_vruntime                  : 330974.786358
Jul 21 02:22:32 filesrv2 kernel:   .max_vruntime                  : 0.000001
Jul 21 02:22:32 filesrv2 kernel:   .spread                        : 0.000000
Jul 21 02:22:32 filesrv2 kernel:   .spread0                       : 0.000000
Jul 21 02:22:32 filesrv2 kernel:   .nr_running                    : 0
Jul 21 02:22:33 filesrv2 kernel:   .load                          : 0
Jul 21 02:22:33 filesrv2 kernel:   .bkl_count                     : 494
Jul 21 02:22:33 filesrv2 kernel:   .nr_spread_over                : 286
Jul 21 02:22:33 filesrv2 kernel:
Jul 21 02:22:33 filesrv2 kernel: runnable tasks:
Jul 21 02:22:33 filesrv2 kernel:             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
Jul 21 02:22:33 filesrv2 kernel: 
----------------------------------------------------------------------------------------------------------
Jul 21 02:22:33 filesrv2 kernel:
Jul 21 02:22:33 filesrv2 kernel: cpu#1, 3000.131 MHz
Jul 21 02:22:33 filesrv2 kernel:   .nr_running                    : 0
Jul 21 02:22:33 filesrv2 kernel:   .load                          : 0
Jul 21 02:22:33 filesrv2 kernel:   .nr_switches                   : 2861262
Jul 21 02:22:33 filesrv2 kernel:   .nr_load_updates               : 1522220
Jul 21 02:22:33 filesrv2 kernel:   .nr_uninterruptible            : 50685
Jul 21 02:22:33 filesrv2 kernel:   .jiffies                       : 1492261
Jul 21 02:22:33 filesrv2 kernel:   .next_balance                  : 1.492262
Jul 21 02:22:33 filesrv2 kernel:   .curr->pid                     : 0
Jul 21 02:22:33 filesrv2 kernel:   .clock                         : 15222611.752194
Jul 21 02:22:33 filesrv2 kernel:   .cpu_load[0]                   : 0
Jul 21 02:22:33 filesrv2 kernel:   .cpu_load[1]                   : 0
Jul 21 02:22:33 filesrv2 kernel:   .cpu_load[2]                   : 0
Jul 21 02:22:33 filesrv2 kernel:   .cpu_load[3]                   : 0
Jul 21 02:22:33 filesrv2 kernel:   .cpu_load[4]                   : 0
Jul 21 02:22:33 filesrv2 kernel:
Jul 21 02:22:33 filesrv2 kernel: cfs_rq[1]:
Jul 21 02:22:33 filesrv2 kernel:   .exec_clock                    : 419398.032151
Jul 21 02:22:33 filesrv2 kernel:   .MIN_vruntime                  : 0.000001
Jul 21 02:22:33 filesrv2 kernel:   .min_vruntime                  : 292919.287497
Jul 21 02:22:33 filesrv2 kernel:   .max_vruntime                  : 0.000001
Jul 21 02:22:33 filesrv2 kernel:   .spread                        : 0.000000
Jul 21 02:22:33 filesrv2 kernel:   .spread0                       : -38055.498861
Jul 21 02:22:33 filesrv2 kernel:   .nr_running                    : 0
Jul 21 02:22:33 filesrv2 kernel:   .load                          : 0
Jul 21 02:22:33 filesrv2 kernel:   .bkl_count                     : 761
Jul 21 02:22:33 filesrv2 kernel:   .nr_spread_over                : 123
Jul 21 02:22:33 filesrv2 kernel:
Jul 21 02:22:33 filesrv2 kernel: runnable tasks:
Jul 21 02:22:34 filesrv2 kernel:             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
Jul 21 02:22:34 filesrv2 kernel: 
----------------------------------------------------------------------------------------------------------
Jul 21 02:22:34 filesrv2 kernel:
Jul 21 02:22:34 filesrv2 kernel: cpu#2, 3000.131 MHz
Jul 21 02:22:34 filesrv2 kernel:   .nr_running                    : 0
Jul 21 02:22:34 filesrv2 kernel:   .load                          : 0
Jul 21 02:22:34 filesrv2 kernel:   .nr_switches                   : 2677505
Jul 21 02:22:34 filesrv2 kernel:   .nr_load_updates               : 1522197
Jul 21 02:22:34 filesrv2 kernel:   .nr_uninterruptible            : 47556
Jul 21 02:22:34 filesrv2 kernel:   .jiffies                       : 1492261
Jul 21 02:22:34 filesrv2 kernel:   .next_balance                  : 1.492262
Jul 21 02:22:34 filesrv2 kernel:   .curr->pid                     : 0
Jul 21 02:22:34 filesrv2 kernel:   .clock                         : 15222611.255017
Jul 21 02:22:34 filesrv2 kernel:   .cpu_load[0]                   : 0
Jul 21 02:22:34 filesrv2 kernel:   .cpu_load[1]                   : 0
Jul 21 02:22:34 filesrv2 kernel:   .cpu_load[2]                   : 0
Jul 21 02:22:34 filesrv2 kernel:   .cpu_load[3]                   : 0
Jul 21 02:22:34 filesrv2 kernel:   .cpu_load[4]                   : 0
Jul 21 02:22:34 filesrv2 kernel:
Jul 21 02:22:34 filesrv2 kernel: cfs_rq[2]:
Jul 21 02:22:34 filesrv2 kernel:   .exec_clock                    : 357349.234544
Jul 21 02:22:34 filesrv2 kernel:   .MIN_vruntime                  : 0.000001
Jul 21 02:22:34 filesrv2 kernel:   .min_vruntime                  : 242262.658966
Jul 21 02:22:34 filesrv2 kernel:   .max_vruntime                  : 0.000001
Jul 21 02:22:34 filesrv2 kernel:   .spread                        : 0.000000
Jul 21 02:22:34 filesrv2 kernel:   .spread0                       : -88712.127392
Jul 21 02:22:34 filesrv2 kernel:   .nr_running                    : 0
Jul 21 02:22:34 filesrv2 kernel:   .load                          : 0
Jul 21 02:22:34 filesrv2 kernel:   .bkl_count                     : 239
Jul 21 02:22:34 filesrv2 kernel:   .nr_spread_over                : 2
Jul 21 02:22:34 filesrv2 kernel:
Jul 21 02:22:34 filesrv2 kernel: runnable tasks:
Jul 21 02:22:34 filesrv2 kernel:             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
Jul 21 02:22:34 filesrv2 kernel: 
----------------------------------------------------------------------------------------------------------
Jul 21 02:22:34 filesrv2 kernel:
Jul 21 02:22:34 filesrv2 kernel: cpu#3, 3000.131 MHz
Jul 21 02:22:35 filesrv2 kernel:   .nr_running                    : 0
Jul 21 02:22:35 filesrv2 kernel:   .load                          : 0
Jul 21 02:22:35 filesrv2 kernel:   .nr_switches                   : 2531385
Jul 21 02:22:35 filesrv2 kernel:   .nr_load_updates               : 1522173
Jul 21 02:22:35 filesrv2 kernel:   .nr_uninterruptible            : 43246
Jul 21 02:22:35 filesrv2 kernel:   .jiffies                       : 1492261
Jul 21 02:22:35 filesrv2 kernel:   .next_balance                  : 1.492262
Jul 21 02:22:35 filesrv2 kernel:   .curr->pid                     : 0
Jul 21 02:22:35 filesrv2 kernel:   .clock                         : 15222611.880141
Jul 21 02:22:35 filesrv2 kernel:   .cpu_load[0]                   : 0
Jul 21 02:22:35 filesrv2 kernel:   .cpu_load[1]                   : 0
Jul 21 02:22:35 filesrv2 kernel:   .cpu_load[2]                   : 0
Jul 21 02:22:35 filesrv2 kernel:   .cpu_load[3]                   : 0
Jul 21 02:22:35 filesrv2 kernel:   .cpu_load[4]                   : 0
Jul 21 02:22:35 filesrv2 kernel:
Jul 21 02:22:35 filesrv2 kernel: cfs_rq[3]:
Jul 21 02:22:35 filesrv2 kernel:   .exec_clock                    : 340647.442318
Jul 21 02:22:35 filesrv2 kernel:   .MIN_vruntime                  : 0.000001
Jul 21 02:22:35 filesrv2 kernel:   .min_vruntime                  : 232666.851380
Jul 21 02:22:35 filesrv2 kernel:   .max_vruntime                  : 0.000001
Jul 21 02:22:35 filesrv2 kernel:   .spread                        : 0.000000
Jul 21 02:22:35 filesrv2 kernel:   .spread0                       : -98307.934978
Jul 21 02:22:35 filesrv2 kernel:   .nr_running                    : 0
Jul 21 02:22:35 filesrv2 kernel:   .load                          : 0
Jul 21 02:22:35 filesrv2 kernel:   .bkl_count                     : 1068
Jul 21 02:22:35 filesrv2 kernel:   .nr_spread_over                : 9
Jul 21 02:22:35 filesrv2 kernel:
Jul 21 02:22:35 filesrv2 kernel: runnable tasks:
Jul 21 02:22:35 filesrv2 kernel:             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
Jul 21 02:22:35 filesrv2 kernel: 
----------------------------------------------------------------------------------------------------------
Jul 21 02:22:35 filesrv2 kernel:
Jul 21 02:22:35 filesrv2 kernel: cpu#4, 3000.131 MHz
Jul 21 02:22:35 filesrv2 kernel:   .nr_running                    : 0
Jul 21 02:22:35 filesrv2 kernel:   .load                          : 0
Jul 21 02:22:35 filesrv2 kernel:   .nr_switches                   : 2701317
Jul 21 02:22:35 filesrv2 kernel:   .nr_load_updates               : 1522151
Jul 21 02:22:35 filesrv2 kernel:   .nr_uninterruptible            : 17571
Jul 21 02:22:35 filesrv2 kernel:   .jiffies                       : 1492261
Jul 21 02:22:36 filesrv2 kernel:   .next_balance                  : 1.492262
Jul 21 02:22:36 filesrv2 kernel:   .curr->pid                     : 0
Jul 21 02:22:36 filesrv2 kernel:   .clock                         : 15222612.505104
Jul 21 02:22:36 filesrv2 kernel:   .cpu_load[0]                   : 0
Jul 21 02:22:36 filesrv2 kernel:   .cpu_load[1]                   : 0
Jul 21 02:22:36 filesrv2 kernel:   .cpu_load[2]                   : 0
Jul 21 02:22:36 filesrv2 kernel:   .cpu_load[3]                   : 0
Jul 21 02:22:36 filesrv2 kernel:   .cpu_load[4]                   : 0
Jul 21 02:22:36 filesrv2 kernel:
Jul 21 02:22:36 filesrv2 kernel: cfs_rq[4]:
Jul 21 02:22:36 filesrv2 kernel:   .exec_clock                    : 346990.083365
Jul 21 02:22:36 filesrv2 kernel:   .MIN_vruntime                  : 0.000001
Jul 21 02:22:36 filesrv2 kernel:   .min_vruntime                  : 266891.845919
Jul 21 02:22:36 filesrv2 kernel:   .max_vruntime                  : 0.000001
Jul 21 02:22:36 filesrv2 kernel:   .spread                        : 0.000000
Jul 21 02:22:36 filesrv2 kernel:   .spread0                       : -64082.940439
Jul 21 02:22:36 filesrv2 kernel:   .nr_running                    : 0
Jul 21 02:22:36 filesrv2 kernel:   .load                          : 0
Jul 21 02:22:36 filesrv2 kernel:   .bkl_count                     : 47
Jul 21 02:22:36 filesrv2 kernel:   .nr_spread_over                : 10
Jul 21 02:22:36 filesrv2 kernel:
Jul 21 02:22:36 filesrv2 kernel: runnable tasks:
Jul 21 02:22:36 filesrv2 kernel:             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
Jul 21 02:22:36 filesrv2 kernel: 
----------------------------------------------------------------------------------------------------------
Jul 21 02:22:36 filesrv2 kernel:
Jul 21 02:22:36 filesrv2 kernel: cpu#5, 3000.131 MHz
Jul 21 02:22:36 filesrv2 kernel:   .nr_running                    : 1
Jul 21 02:22:36 filesrv2 kernel:   .load                          : 1024
Jul 21 02:22:36 filesrv2 kernel:   .nr_switches                   : 3342804
Jul 21 02:22:36 filesrv2 kernel:   .nr_load_updates               : 1522126
Jul 21 02:22:36 filesrv2 kernel:   .nr_uninterruptible            : 4294916119
Jul 21 02:22:36 filesrv2 kernel:   .jiffies                       : 1492261
Jul 21 02:22:36 filesrv2 kernel:   .next_balance                  : 1.492261
Jul 21 02:22:36 filesrv2 kernel:   .curr->pid                     : 0
Jul 21 02:22:36 filesrv2 kernel:   .clock                         : 15222616.497309
Jul 21 02:22:36 filesrv2 kernel:   .cpu_load[0]                   : 0
Jul 21 02:22:36 filesrv2 kernel:   .cpu_load[1]                   : 0
Jul 21 02:22:37 filesrv2 kernel:   .cpu_load[2]                   : 0
Jul 21 02:22:37 filesrv2 kernel:   .cpu_load[3]                   : 7
Jul 21 02:22:37 filesrv2 kernel:   .cpu_load[4]                   : 273
Jul 21 02:22:37 filesrv2 kernel:
Jul 21 02:22:37 filesrv2 kernel: cfs_rq[5]:
Jul 21 02:22:37 filesrv2 kernel:   .exec_clock                    : 641536.715838
Jul 21 02:22:37 filesrv2 kernel:   .MIN_vruntime                  : 382328.602316
Jul 21 02:22:37 filesrv2 kernel:   .min_vruntime                  : 382408.602316
Jul 21 02:22:37 filesrv2 kernel:   .max_vruntime                  : 382328.602316
Jul 21 02:22:37 filesrv2 kernel:   .spread                        : 0.000000
Jul 21 02:22:37 filesrv2 kernel:   .spread0                       : 51433.815958
Jul 21 02:22:37 filesrv2 kernel:   .nr_running                    : 1
Jul 21 02:22:37 filesrv2 kernel:   .load                          : 1024
Jul 21 02:22:37 filesrv2 kernel:   .bkl_count                     : 163
Jul 21 02:22:37 filesrv2 kernel:   .nr_spread_over                : 239
Jul 21 02:22:37 filesrv2 kernel:
Jul 21 02:22:37 filesrv2 kernel: runnable tasks:
Jul 21 02:22:37 filesrv2 kernel:             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
Jul 21 02:22:37 filesrv2 kernel: 
----------------------------------------------------------------------------------------------------------
Jul 21 02:22:37 filesrv2 kernel:            klogd  3226    382328.602316      2707   120    382328.602316       228.935534  15133445.068037
Jul 21 02:22:37 filesrv2 kernel:
Jul 21 02:22:37 filesrv2 kernel: cpu#6, 3000.131 MHz
Jul 21 02:22:37 filesrv2 kernel:   .nr_running                    : 0
Jul 21 02:22:37 filesrv2 kernel:   .load                          : 0
Jul 21 02:22:37 filesrv2 kernel:   .nr_switches                   : 2950078
Jul 21 02:22:37 filesrv2 kernel:   .nr_load_updates               : 1522096
Jul 21 02:22:37 filesrv2 kernel:   .nr_uninterruptible            : 4294920155
Jul 21 02:22:37 filesrv2 kernel:   .jiffies                       : 1492261
Jul 21 02:22:37 filesrv2 kernel:   .next_balance                  : 1.492262
Jul 21 02:22:37 filesrv2 kernel:   .curr->pid                     : 0
Jul 21 02:22:37 filesrv2 kernel:   .clock                         : 15222613.754873
Jul 21 02:22:37 filesrv2 kernel:   .cpu_load[0]                   : 0
Jul 21 02:22:37 filesrv2 kernel:   .cpu_load[1]                   : 0
Jul 21 02:22:37 filesrv2 kernel:   .cpu_load[2]                   : 0
Jul 21 02:22:37 filesrv2 kernel:   .cpu_load[3]                   : 0
Jul 21 02:22:37 filesrv2 kernel:   .cpu_load[4]                   : 0
Jul 21 02:22:37 filesrv2 kernel:
Jul 21 02:22:38 filesrv2 kernel: cfs_rq[6]:
Jul 21 02:22:38 filesrv2 kernel:   .exec_clock                    : 615284.569393
Jul 21 02:22:38 filesrv2 kernel:   .MIN_vruntime                  : 0.000001
Jul 21 02:22:38 filesrv2 kernel:   .min_vruntime                  : 379004.101119
Jul 21 02:22:38 filesrv2 kernel:   .max_vruntime                  : 0.000001
Jul 21 02:22:38 filesrv2 kernel:   .spread                        : 0.000000
Jul 21 02:22:38 filesrv2 kernel:   .spread0                       : 48029.314761
Jul 21 02:22:38 filesrv2 kernel:   .nr_running                    : 0
Jul 21 02:22:38 filesrv2 kernel:   .load                          : 0
Jul 21 02:22:38 filesrv2 kernel:   .bkl_count                     : 165
Jul 21 02:22:38 filesrv2 kernel:   .nr_spread_over                : 157
Jul 21 02:22:38 filesrv2 kernel:
Jul 21 02:22:38 filesrv2 kernel: runnable tasks:
Jul 21 02:22:38 filesrv2 kernel:             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
Jul 21 02:22:38 filesrv2 kernel: 
----------------------------------------------------------------------------------------------------------
Jul 21 02:22:38 filesrv2 kernel:
Jul 21 02:22:38 filesrv2 kernel: cpu#7, 3000.131 MHz
Jul 21 02:22:38 filesrv2 kernel:   .nr_running                    : 0
Jul 21 02:22:38 filesrv2 kernel:   .load                          : 0
Jul 21 02:22:38 filesrv2 kernel:   .nr_switches                   : 2857014
Jul 21 02:22:38 filesrv2 kernel:   .nr_load_updates               : 1522076
Jul 21 02:22:38 filesrv2 kernel:   .nr_uninterruptible            : 4294923660
Jul 21 02:22:38 filesrv2 kernel:   .jiffies                       : 1492261
Jul 21 02:22:38 filesrv2 kernel:   .next_balance                  : 1.492262
Jul 21 02:22:38 filesrv2 kernel:   .curr->pid                     : 0
Jul 21 02:22:38 filesrv2 kernel:   .clock                         : 15222614.379728
Jul 21 02:22:38 filesrv2 kernel:   .cpu_load[0]                   : 0
Jul 21 02:22:38 filesrv2 kernel:   .cpu_load[1]                   : 0
Jul 21 02:22:38 filesrv2 kernel:   .cpu_load[2]                   : 0
Jul 21 02:22:38 filesrv2 kernel:   .cpu_load[3]                   : 0
Jul 21 02:22:38 filesrv2 kernel:   .cpu_load[4]                   : 0
Jul 21 02:22:38 filesrv2 kernel:
Jul 21 02:22:38 filesrv2 kernel: cfs_rq[7]:
Jul 21 02:22:38 filesrv2 kernel:   .exec_clock                    : 587639.977405
Jul 21 02:22:38 filesrv2 kernel:   .MIN_vruntime                  : 0.000001
Jul 21 02:22:38 filesrv2 kernel:   .min_vruntime                  : 349315.888333
Jul 21 02:22:38 filesrv2 kernel:   .max_vruntime                  : 0.000001
Jul 21 02:22:38 filesrv2 kernel:   .spread                        : 0.000000
Jul 21 02:22:39 filesrv2 kernel:   .spread0                       : 18341.101975
Jul 21 02:22:39 filesrv2 kernel:   .nr_running                    : 0
Jul 21 02:22:39 filesrv2 kernel:   .load                          : 0
Jul 21 02:22:39 filesrv2 kernel:   .bkl_count                     : 377
Jul 21 02:22:39 filesrv2 kernel:   .nr_spread_over                : 116
Jul 21 02:22:39 filesrv2 kernel:
Jul 21 02:22:39 filesrv2 kernel: runnable tasks:
Jul 21 02:22:39 filesrv2 kernel:             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
Jul 21 02:22:39 filesrv2 kernel: 
----------------------------------------------------------------------------------------------------------
Jul 21 02:22:39 filesrv2 kernel:

</SysRq : Show Blocked State>



SysRq : Show Locks Held
Jul 21 02:19:55 filesrv2 kernel: SysRq : HELP : loglevel0-8 reBoot 
show-all-locks(D) tErm Full kIll saK aLlcpus showMem Nice powerOff showPc 
show-all-timers(Q) unRaw Sync showTasks Unmount shoW-blocked-tasks
Jul 21 02:19:58 filesrv2 kernel: SysRq : Show Locks Held
Jul 21 02:19:58 filesrv2 kernel:
Jul 21 02:19:58 filesrv2 kernel: Showing all locks held in the system:
Jul 21 02:19:58 filesrv2 kernel: 2 locks held by pdflush/393:
Jul 21 02:19:58 filesrv2 kernel:  #0:  (&type->s_umount_key#17){----}, at: [<c018a7b2>] sync_supers+0x52/0xc0
Jul 21 02:19:58 filesrv2 kernel:  #1:  (&type->s_lock_key#7){--..}, at: [<c018a43b>] lock_super+0x1b/0x20
Jul 21 02:19:58 filesrv2 kernel: 1 lock held by agetty/3729:
Jul 21 02:19:58 filesrv2 kernel:  #0:  (&tty->atomic_read_lock){--..}, at: [<c04ac500>] read_chan+0x3d0/0x540
Jul 21 02:19:58 filesrv2 kernel: 1 lock held by agetty/3730:
Jul 21 02:19:58 filesrv2 kernel:  #0:  (&tty->atomic_read_lock){--..}, at: [<c04ac500>] read_chan+0x3d0/0x540
Jul 21 02:19:58 filesrv2 kernel: 1 lock held by agetty/3731:
Jul 21 02:19:58 filesrv2 kernel:  #0:  (&tty->atomic_read_lock){--..}, at: [<c04ac500>] read_chan+0x3d0/0x540
Jul 21 02:19:58 filesrv2 kernel: 1 lock held by agetty/3732:
Jul 21 02:19:58 filesrv2 kernel:  #0:  (&tty->atomic_read_lock){--..}, at: [<c04ac500>] read_chan+0x3d0/0x540
Jul 21 02:19:58 filesrv2 kernel: 1 lock held by agetty/3733:
Jul 21 02:19:58 filesrv2 kernel:  #0:  (&tty->atomic_read_lock){--..}, at: [<c04ac500>] read_chan+0x3d0/0x540
Jul 21 02:19:58 filesrv2 kernel: 1 lock held by agetty/3734:
Jul 21 02:19:58 filesrv2 kernel:  #0:  (&tty->atomic_read_lock){--..}, at: [<c04ac500>] read_chan+0x3d0/0x540
Jul 21 02:19:58 filesrv2 kernel: 1 lock held by agetty/3735:
Jul 21 02:19:58 filesrv2 kernel:  #0:  (&tty->atomic_read_lock){--..}, at: [<c04ac500>] read_chan+0x3d0/0x540
Jul 21 02:19:58 filesrv2 kernel: 1 lock held by bash/3750:
Jul 21 02:19:58 filesrv2 kernel:  #0:  (&tty->atomic_read_lock){--..}, at: [<c04ac500>] read_chan+0x3d0/0x540
Jul 21 02:19:58 filesrv2 kernel: 1 lock held by bash/3776:
Jul 21 02:19:58 filesrv2 kernel:  #0:  (&tty->atomic_read_lock){--..}, at: [<c04ac500>] read_chan+0x3d0/0x540
Jul 21 02:19:58 filesrv2 kernel: 2 locks held by bonnie++/3978:
Jul 21 02:19:58 filesrv2 kernel:  #0:  (&sb->s_type->i_mutex_key#9){--..}, at: [<c03ad8a2>] xfs_write+0x2d2/0x8e0
Jul 21 02:19:58 filesrv2 kernel:  #1:  (&(&ip->i_iolock)->mr_lock){--..}, at: [<c03810bc>] xfs_ilock+0x7c/0xa0
Jul 21 02:19:58 filesrv2 kernel: 2 locks held by bonnie++/3980:
Jul 21 02:19:58 filesrv2 kernel:  #0:  (&sb->s_type->i_mutex_key#9){--..}, at: [<c03ad8a2>] xfs_write+0x2d2/0x8e0
Jul 21 02:19:58 filesrv2 kernel:  #1:  (&(&ip->i_iolock)->mr_lock){--..}, at: [<c03810bc>] xfs_ilock+0x7c/0xa0
Jul 21 02:19:58 filesrv2 kernel: 2 locks held by bonnie++/3982:
Jul 21 02:19:58 filesrv2 kernel:  #0:  (&sb->s_type->i_mutex_key#9){--..}, at: [<c03ad8a2>] xfs_write+0x2d2/0x8e0
Jul 21 02:19:58 filesrv2 kernel:  #1:  (&(&ip->i_iolock)->mr_lock){--..}, at: [<c03810bc>] xfs_ilock+0x7c/0xa0
Jul 21 02:19:58 filesrv2 kernel: 2 locks held by bonnie++/3983:
Jul 21 02:19:58 filesrv2 kernel:  #0:  (&sb->s_type->i_mutex_key#9){--..}, at: [<c03ad8a2>] xfs_write+0x2d2/0x8e0
Jul 21 02:19:58 filesrv2 kernel:  #1:  (&(&ip->i_iolock)->mr_lock){--..}, at: [<c03810bc>] xfs_ilock+0x7c/0xa0
Jul 21 02:19:58 filesrv2 kernel: 2 locks held by bonnie++/3985:
Jul 21 02:19:58 filesrv2 kernel:  #0:  (&sb->s_type->i_mutex_key#9){--..}, at: [<c03ad8a2>] xfs_write+0x2d2/0x8e0
Jul 21 02:19:58 filesrv2 kernel:  #1:  (&(&ip->i_iolock)->mr_lock){--..}, at: [<c03810bc>] xfs_ilock+0x7c/0xa0
Jul 21 02:19:59 filesrv2 kernel:
Jul 21 02:19:59 filesrv2 kernel: =============================================
Jul 21 02:19:59 filesrv2 kernel:

</SysRq : Show Locks Held>




-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network&System Engineer | 2133    McCullam Ave |  Give me Linux  |
| babydr@baby-dragons.com | Fairbanks, AK. 99701 |   only  on  AXP |
+------------------------------------------------------------------+
