From: Georgi Nikolov <gnikolov@icdsoft.com>
Subject: Re: Pausing md check hangs
Date: Mon, 17 Feb 2020 15:15:42 +0200
Message-ID: <fbd369ff-e0ac-9db3-9c26-8cc0be7ff0d9@icdsoft.com>
References: <2ce8813c-fd3e-5e78-39ac-049ddfa79ff6@icdsoft.com>
 <CAPhsuW4Jc-qef9uW-JSut90qOpDc_4VoAFpMU8KwqnK7EeT_xg@mail.gmail.com>
 <ac3ae81d-8dad-8b4e-bc61-fc37514e3929@icdsoft.com>
 <CAPhsuW4JJiDroE33m0=XE9PxtUOncK3--waY_zxxbAT9j+1m6g@mail.gmail.com>
 <cc483055-45de-4bd2-8a4f-71e9c8ed6b90@icdsoft.com>
 <CAPhsuW6wZ_n1BVP6+nZ12MgnkM1OgmzSs+KeC0tGDvX-RG3KvA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------728BE3EF25B76081DD2CF359"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPhsuW6wZ_n1BVP6+nZ12MgnkM1OgmzSs+KeC0tGDvX-RG3KvA@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <song@kernel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------728BE3EF25B76081DD2CF359
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

I have managed to gather fresh data. Attached are logs from 'perf' and 
'echo l > /proc/sysrq-trigger'.
It seems that thread is locked in 'analyse_stripe'.

Regards,
Georgi Nikolov

--------------728BE3EF25B76081DD2CF359
Content-Type: text/x-log; charset=UTF-8;
 name="supermicro-17-02-2020-perf.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="supermicro-17-02-2020-perf.log"

# perf top
   5.53%  md10_raid6       [kernel]                      [k] analyse_stripe                                     1684:md10_raid6
   2.12%  md10_raid6       [kernel]                      [k] ops_run_io                                         1684:md10_raid6


# perf top -p $(pidof md10_raid6)
  51.01%  [kernel]  [k] analyse_stripe
  20.31%  [kernel]  [k] ops_run_io
   7.78%  [kernel]  [k] handle_stripe
   7.05%  [kernel]  [k] __list_del_entry_valid
   4.85%  [kernel]  [k] handle_active_stripes.isra.78
   2.39%  [kernel]  [k] queue_work_on
   1.92%  [kernel]  [k] do_release_stripe
   1.88%  [kernel]  [k] raid5_wakeup_stripe_thread
   1.20%  [kernel]  [k] __release_stripe
   0.21%  [kernel]  [k] _raw_spin_lock_irq
   0.17%  [kernel]  [k] release_stripe_list
   0.16%  [kernel]  [k] r5c_is_writeback
   0.15%  [kernel]  [k] r5l_log_disk_error
   0.15%  [kernel]  [k] raid5d
   0.10%  [kernel]  [k] release_inactive_stripe_list
   0.10%  [kernel]  [k] md_check_recovery
   0.09%  [kernel]  [k] __list_add_valid
   0.08%  [kernel]  [k] rcu_all_qs
   0.07%  [kernel]  [k] private_find_iova
   0.06%  [kernel]  [k] _cond_resched
   0.04%  [kernel]  [k] native_queued_spin_lock_slowpath
   0.04%  [kernel]  [k] mutex_trylock
   0.03%  [kernel]  [k] rb_erase
   0.03%  [kernel]  [k] llist_reverse_order
   0.02%  [kernel]  [k] _raw_spin_lock_irqsave
   0.01%  [kernel]  [k] r5l_flush_stripe_to_raid
   0.01%  [kernel]  [k] fq_ring_free
   0.01%  [kernel]  [k] task_tick_fair
   0.01%  [kernel]  [k] ktime_get
   0.01%  [kernel]  [k] __slab_free
   0.01%  [kernel]  [k] update_curr
   0.01%  [kernel]  [k] rcu_sched_clock_irq
   0.01%  [kernel]  [k] irq_exit
   0.00%  [kernel]  [k] rb_next
   0.00%  [kernel]  [k] unfreeze_partials.isra.82
   0.00%  [kernel]  [k] qi_submit_sync
   0.00%  [kernel]  [k] free_iova_fast
   0.00%  [kernel]  [k] enqueue_task_fair
   0.00%  [kernel]  [k] kmem_cache_free
   0.00%  [kernel]  [k] run_timer_softirq
   0.00%  [kernel]  [k] update_rq_clock
   0.00%  [kernel]  [k] __update_load_avg_se
   0.00%  [kernel]  [k] interrupt_entry


--------------728BE3EF25B76081DD2CF359
Content-Type: text/x-log; charset=UTF-8;
 name="supermicro-17-02-2020.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="supermicro-17-02-2020.log"

[1377726.075474] NMI backtrace for cpu 42
[1377726.075693] NMI backtrace for cpu 18
[1377726.075694] CPU: 18 PID: 1684 Comm: md10_raid6 Tainted: G        W         5.4.0-0.bpo.2-amd64 #1 Debian 5.4.8-1~bpo10+1
[1377726.075694] Hardware name: Supermicro Super Server/X11DPH-T, BIOS 2.1 06/15/2018
[1377726.075694] RIP: 0010:ops_run_io+0x119/0xda0 [raid456]
[1377726.075695] Code: f8 f0 48 0f ba 30 06 0f 82 4c 01 00 00 f0 48 0f ba 30 05 0f 82 58 0b 00 00 f0 48 0f ba 30 16 0f 82 1f 0b 00 00 83 6c 24 10 01 <83> 7c 24 10 ff 75 ad 44 8b 4c 24 2c 4d 89 e6 4c 8b 7c 24 70 45 85
[1377726.075695] RSP: 0018:ffffa88420867b48 EFLAGS: 00000202
[1377726.075696] RAX: ffff8e23eb980508 RBX: 0000000000000008 RCX: 00000000000002d0
[1377726.075696] RDX: 0000000000000002 RSI: ffffa88420867c90 RDI: 0000000000000508
[1377726.075696] RBP: ffffa88420867c90 R08: 0000000000000004 R09: 0000000000000000
[1377726.075697] R10: 0000000000000000 R11: ffff8e10220be000 R12: ffff8e10220be000
[1377726.075697] R13: ffff8e23eb980048 R14: ffff8e10220be000 R15: ffff8e23eb980000
[1377726.075697] FS:  0000000000000000(0000) GS:ffff8e307f200000(0000) knlGS:0000000000000000
[1377726.075697] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[1377726.075698] CR2: 00006da7ed7d8000 CR3: 000000018500a002 CR4: 00000000007626e0
[1377726.075698] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[1377726.075698] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[1377726.075698] PKRU: 55555554
[1377726.075698] Call Trace:
[1377726.075699]  ? analyse_stripe+0x7c/0x730 [raid456]
[1377726.075699]  handle_stripe+0xc32/0x2230 [raid456]
[1377726.075699]  ? __switch_to_asm+0x40/0x70
[1377726.075699]  ? __switch_to_asm+0x34/0x70
[1377726.075700]  handle_active_stripes.isra.78+0x3b8/0x590 [raid456]
[1377726.075700]  raid5d+0x392/0x5b0 [raid456]
[1377726.075700]  ? md_register_thread+0xd0/0xd0 [md_mod]
[1377726.075700]  ? schedule_timeout+0x20d/0x310
[1377726.075700]  ? md_register_thread+0xd0/0xd0 [md_mod]
[1377726.075700]  md_thread+0x94/0x150 [md_mod]
[1377726.075701]  ? finish_wait+0x80/0x80
[1377726.075701]  kthread+0x112/0x130
[1377726.075701]  ? kthread_park+0x80/0x80
[1377726.075701]  ret_from_fork+0x35/0x40
[1377726.086941] CPU: 42 PID: 70277 Comm: bash Tainted: G        W         5.4.0-0.bpo.2-amd64 #1 Debian 5.4.8-1~bpo10+1
[1377726.087383] Hardware name: Supermicro Super Server/X11DPH-T, BIOS 2.1 06/15/2018
[1377726.087810] Call Trace:
[1377726.088261]  dump_stack+0x66/0x90
[1377726.088685]  nmi_cpu_backtrace.cold.7+0x13/0x50
[1377726.089111]  ? lapic_can_unplug_cpu.cold.31+0x37/0x37
[1377726.089529]  nmi_trigger_cpumask_backtrace+0xf9/0xfb
[1377726.089926]  __handle_sysrq.cold.12+0x66/0x11c
[1377726.090322]  write_sysrq_trigger+0x30/0x40
[1377726.090715]  proc_reg_write+0x39/0x60
[1377726.091168]  vfs_write+0xa5/0x1a0
[1377726.091652]  ksys_write+0x59/0xd0
[1377726.092043]  do_syscall_64+0x52/0x160
[1377726.092476]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[1377726.092903] RIP: 0033:0x7f5d93937504
[1377726.093333] Code: 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b3 0f 1f 80 00 00 00 00 48 8d 05 f9 61 0d 00 8b 00 85 c0 75 13 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 54 c3 0f 1f 00 41 54 49 89 d4 55 48 89 f5 53
[1377726.094200] RSP: 002b:00007ffc51f8e028 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[1377726.094606] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f5d93937504
[1377726.095004] RDX: 0000000000000002 RSI: 000055ccc0fb3d00 RDI: 0000000000000001
[1377726.095391] RBP: 000055ccc0fb3d00 R08: 000000000000000a R09: 00007f5d939c7e80
[1377726.095798] R10: 000000000000000a R11: 0000000000000246 R12: 00007f5d93a09760
[1377726.096230] R13: 0000000000000002 R14: 00007f5d93a04760 R15: 0000000000000002
[1377726.096703] Sending NMI from CPU 42 to CPUs 0-17,19-41,43-71:
[1377726.097192] NMI backtrace for cpu 0 skipped: idling at intel_idle+0x85/0x130
[1377726.097285] NMI backtrace for cpu 1 skipped: idling at intel_idle+0x85/0x130
[1377726.097383] NMI backtrace for cpu 2 skipped: idling at intel_idle+0x85/0x130
[1377726.097483] NMI backtrace for cpu 3 skipped: idling at intel_idle+0x85/0x130
[1377726.097579] NMI backtrace for cpu 4 skipped: idling at intel_idle+0x85/0x130
[1377726.097679] NMI backtrace for cpu 5 skipped: idling at intel_idle+0x85/0x130
[1377726.097681] NMI backtrace for cpu 6 skipped: idling at intel_idle+0x85/0x130
[1377726.097782] NMI backtrace for cpu 7 skipped: idling at intel_idle+0x85/0x130
[1377726.097880] NMI backtrace for cpu 8 skipped: idling at intel_idle+0x85/0x130
[1377726.097980] NMI backtrace for cpu 9 skipped: idling at intel_idle+0x85/0x130
[1377726.098078] NMI backtrace for cpu 10 skipped: idling at intel_idle+0x85/0x130
[1377726.098270] NMI backtrace for cpu 11 skipped: idling at intel_idle+0x85/0x130
[1377726.098351] NMI backtrace for cpu 12
[1377726.098352] CPU: 12 PID: 0 Comm: swapper/12 Tainted: G        W         5.4.0-0.bpo.2-amd64 #1 Debian 5.4.8-1~bpo10+1
[1377726.098352] Hardware name: Supermicro Super Server/X11DPH-T, BIOS 2.1 06/15/2018
[1377726.098352] RIP: 0010:__rq_qos_done_bio+0x0/0x30
[1377726.098353] Code: 8b 40 10 48 85 c0 74 0e 48 89 ea 4c 89 e6 48 89 df e8 84 61 62 00 48 8b 5b 18 48 85 db 75 dd 5b 5d 41 5c c3 66 0f 1f 44 00 00 <0f> 1f 44 00 00 55 48 89 f5 53 48 89 fb 48 8b 03 48 8b 40 30 48 85
[1377726.098354] RSP: 0018:ffffa8840cafce48 EFLAGS: 00000282
[1377726.098354] RAX: ffff8e3037b262a0 RBX: ffff8e223339ac48 RCX: ffff8e223339ad48
[1377726.098355] RDX: 0000000000000000 RSI: ffff8e223339ac48 RDI: ffff8e1076d25858
[1377726.098355] RBP: 0000000000051000 R08: 0000000000001000 R09: ffff8e223339ad48
[1377726.098355] R10: ffff8e3069196e00 R11: 0000000000000000 R12: 0000000000001000
[1377726.098356] R13: ffff8e1026971f80 R14: 0000000000030000 R15: 0000000000000000
[1377726.098356] FS:  0000000000000000(0000) GS:ffff8e107f900000(0000) knlGS:0000000000000000
[1377726.098356] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[1377726.098356] CR2: 00007f4cc1973e60 CR3: 000000018500a002 CR4: 00000000007626e0
[1377726.098357] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[1377726.098357] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[1377726.098357] PKRU: 55555554
[1377726.098357] Call Trace:
[1377726.098357]  <IRQ>
[1377726.098358]  bio_endio+0x5c/0x170
[1377726.098358]  blk_update_request+0xe4/0x2e0
[1377726.098358]  scsi_end_request+0x29/0x150 [scsi_mod]
[1377726.098358]  scsi_io_completion+0x78/0x520 [scsi_mod]
[1377726.098359]  blk_done_softirq+0xa1/0xd0
[1377726.098359]  __do_softirq+0xdf/0x2e5
[1377726.098359]  irq_exit+0xa3/0xb0
[1377726.098359]  do_IRQ+0x56/0xe0
[1377726.098359]  common_interrupt+0xf/0xf
[1377726.098359]  </IRQ>
[1377726.098360] RIP: 0010:cpuidle_enter_state+0xbc/0x450
[1377726.098360] Code: e8 e9 95 ad ff 80 7c 24 13 00 74 17 9c 58 0f 1f 44 00 00 f6 c4 02 0f 85 67 03 00 00 31 ff e8 bb be b3 ff fb 66 0f 1f 44 00 00 <45> 85 e4 0f 88 92 02 00 00 49 63 cc 4c 8b 3c 24 4c 2b 7c 24 08 48
[1377726.098361] RSP: 0018:ffffa8840c71be78 EFLAGS: 00000246 ORIG_RAX: ffffffffffffffdd
[1377726.098361] RAX: ffff8e107f92a6c0 RBX: ffffffffa3ab7800 RCX: 000000000000001f
[1377726.098361] RDX: 0004e508daaeb465 RSI: 0000000037a6f674 RDI: 0000000000000000
[1377726.098362] RBP: ffffc863fe733100 R08: 0000000000000002 R09: 0000000000029f40
[1377726.098362] R10: 0115db11c0f998cc R11: ffff8e107f929580 R12: 0000000000000003
[1377726.098362] R13: ffffffffa3ab7938 R14: 0000000000000003 R15: 0000000000000000
[1377726.098362]  ? cpuidle_enter_state+0x97/0x450
[1377726.098363]  cpuidle_enter+0x29/0x40
[1377726.098363]  do_idle+0x228/0x270
[1377726.098363]  cpu_startup_entry+0x19/0x20
[1377726.098363]  start_secondary+0x15f/0x1b0
[1377726.098363]  secondary_startup_64+0xa4/0xb0
[1377726.098468] NMI backtrace for cpu 13 skipped: idling at intel_idle+0x85/0x130
[1377726.098520] NMI backtrace for cpu 14 skipped: idling at intel_idle+0x85/0x130
[1377726.098630] NMI backtrace for cpu 15
[1377726.098631] CPU: 15 PID: 1512 Comm: md2_raid6 Tainted: G        W         5.4.0-0.bpo.2-amd64 #1 Debian 5.4.8-1~bpo10+1
[1377726.098631] Hardware name: Supermicro Super Server/X11DPH-T, BIOS 2.1 06/15/2018
[1377726.098631] RIP: 0010:r5l_log_disk_error+0x27/0x30 [raid456]
[1377726.098632] Code: 00 00 00 0f 1f 44 00 00 48 8b 87 30 05 00 00 48 85 c0 74 0e 48 8b 00 48 8b 80 b8 00 00 00 83 e0 01 c3 48 8b 47 28 48 8b 40 28 <48> c1 e8 03 83 e0 01 c3 90 0f 1f 44 00 00 41 57 41 56 41 55 41 54
[1377726.098632] RSP: 0018:ffffa8840f997d40 EFLAGS: 00000046
[1377726.098633] RAX: 0000000000000000 RBX: ffff8e106ec6e000 RCX: 0000000000000001
[1377726.098633] RDX: ffffffffffffffff RSI: 00000000ffffffff RDI: ffff8e106ec6e000
[1377726.098634] RBP: ffffa8840f997eb0 R08: 0000000000000002 R09: 0000000000029f40
[1377726.098634] R10: 0115db11c1059786 R11: ffffffffa3a46958 R12: 0000000000000000
[1377726.098634] R13: 0000000000000000 R14: ffff8e106ec6e0a8 R15: 0000000000000000
[1377726.098635] FS:  0000000000000000(0000) GS:ffff8e107f9c0000(0000) knlGS:0000000000000000
[1377726.098635] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[1377726.098636] CR2: 000074189ef82020 CR3: 00000039e55dc006 CR4: 00000000007626e0
[1377726.098636] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[1377726.098637] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[1377726.098637] PKRU: 55555554
[1377726.098637] Call Trace:
[1377726.098637]  handle_active_stripes.isra.78+0x495/0x590 [raid456]
[1377726.098638]  ? raid5_wakeup_stripe_thread+0x98/0x220 [raid456]
[1377726.098638]  raid5d+0x392/0x5b0 [raid456]
[1377726.098639]  ? md_register_thread+0xd0/0xd0 [md_mod]
[1377726.098639]  ? schedule_timeout+0x20d/0x310
[1377726.098639]  ? md_register_thread+0xd0/0xd0 [md_mod]
[1377726.098639]  md_thread+0x94/0x150 [md_mod]
[1377726.098640]  ? finish_wait+0x80/0x80
[1377726.098640]  kthread+0x112/0x130
[1377726.098640]  ? kthread_park+0x80/0x80
[1377726.098640]  ret_from_fork+0x35/0x40
[1377726.098675] NMI backtrace for cpu 16 skipped: idling at intel_idle+0x85/0x130
[1377726.098774] NMI backtrace for cpu 17 skipped: idling at intel_idle+0x85/0x130
[1377726.098871] NMI backtrace for cpu 19
[1377726.098872] CPU: 19 PID: 29358 Comm: md2_resync Tainted: G        W         5.4.0-0.bpo.2-amd64 #1 Debian 5.4.8-1~bpo10+1
[1377726.098872] Hardware name: Supermicro Super Server/X11DPH-T, BIOS 2.1 06/15/2018
[1377726.098873] RIP: 0010:raid5_sync_request+0x174/0x3b0 [raid456]
[1377726.098874] Code: 4c 89 e6 4c 89 f7 e8 0b b3 ff ff 48 89 c3 48 85 c0 0f 84 14 02 00 00 41 8b 46 44 85 c0 0f 8e 2c 02 00 00 49 8b 96 20 03 00 00 <83> e8 01 bf 01 00 00 00 48 8d 0c 40 48 8d 42 18 48 8d 34 c8 31 c9
[1377726.098874] RSP: 0018:ffffa88420cc7cc8 EFLAGS: 00000202
[1377726.098875] RAX: 0000000000000008 RBX: ffff8e24816c8000 RCX: ffffa88420cc79bc
[1377726.098876] RDX: ffff8e30782ef440 RSI: 0000000000049694 RDI: 0000000000000000
[1377726.098876] RBP: ffff8e3077cc9000 R08: ffffa88420cc79c0 R09: 0000000000000400
[1377726.098877] R10: 0000000000000003 R11: 0000000000000000 R12: 00000000125a5028
[1377726.098877] R13: ffffa88420cc7cc8 R14: ffff8e106ec6e000 R15: ffffa88420cc7d7c
[1377726.098878] FS:  0000000000000000(0000) GS:ffff8e307f240000(0000) knlGS:0000000000000000
[1377726.098878] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[1377726.098879] CR2: 0000172747c49b68 CR3: 000000018500a006 CR4: 00000000007626e0
[1377726.098879] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[1377726.098880] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[1377726.098880] PKRU: 55555554
[1377726.098880] Call Trace:
[1377726.098881]  ? cpumask_next+0x16/0x20
[1377726.098881]  ? is_mddev_idle+0xcc/0x12a [md_mod]
[1377726.098881]  md_do_sync.cold.90+0x424/0x953 [md_mod]
[1377726.098882]  ? update_load_avg+0x7c/0x610
[1377726.098882]  ? sock_def_error_report+0x40/0x60
[1377726.098882]  ? __switch_to_asm+0x34/0x70
[1377726.098883]  ? finish_wait+0x80/0x80
[1377726.098883]  ? md_register_thread+0xd0/0xd0 [md_mod]
[1377726.098883]  md_thread+0x94/0x150 [md_mod]
[1377726.098884]  kthread+0x112/0x130
[1377726.098884]  ? kthread_park+0x80/0x80
[1377726.098884]  ret_from_fork+0x35/0x40
[1377726.098885] NMI backtrace for cpu 20 skipped: idling at intel_idle+0x85/0x130
[1377726.098973] NMI backtrace for cpu 21 skipped: idling at intel_idle+0x85/0x130
[1377726.099022] NMI backtrace for cpu 22 skipped: idling at intel_idle+0x85/0x130
[1377726.099126] NMI backtrace for cpu 24 skipped: idling at intel_idle+0x85/0x130
[1377726.099144] NMI backtrace for cpu 23
[1377726.099145] CPU: 23 PID: 58578 Comm: kworker/u146:15 Tainted: G        W         5.4.0-0.bpo.2-amd64 #1 Debian 5.4.8-1~bpo10+1
[1377726.099145] Hardware name: Supermicro Super Server/X11DPH-T, BIOS 2.1 06/15/2018
[1377726.099145] Workqueue: raid5wq raid5_do_work [raid456]
[1377726.099146] RIP: 0010:memcmp+0x16/0x40
[1377726.099147] Code: 01 48 39 f8 75 f0 c3 48 89 f8 c3 66 0f 1f 84 00 00 00 00 00 48 85 d2 74 2e 0f b6 07 0f b6 0e 29 c8 75 23 b9 01 00 00 00 eb 13 <44> 0f b6 04 0f 44 0f b6 0c 0e 48 83 c1 01 45 29 c8 75 06 48 39 d1
[1377726.099148] RSP: 0018:ffffa884221df958 EFLAGS: 00000287
[1377726.099148] RAX: 0000000000000000 RBX: ffffe26cffa4ce80 RCX: 0000000000000259
[1377726.099149] RDX: 0000000000001000 RSI: ffff8e306933a000 RDI: ffff8e0bc46fa000
[1377726.099149] RBP: 0000000000000008 R08: 0000000000000000 R09: 00000000000000fe
[1377726.099150] R10: ffff8e306933a000 R11: ffffffffc0382000 R12: ffffa884221dfb18
[1377726.099150] R13: 0000000000000000 R14: ffff8e3035898030 R15: ffff8e3035898038
[1377726.099151] FS:  0000000000000000(0000) GS:ffff8e307f340000(0000) knlGS:0000000000000000
[1377726.099151] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[1377726.099151] CR2: 000077ec6ca912a0 CR3: 000000018500a006 CR4: 00000000007626e0
[1377726.099152] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[1377726.099152] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[1377726.099152] PKRU: 55555554
[1377726.099152] Call Trace:
[1377726.099153]  async_syndrome_val+0x1de/0x707 [async_pq]
[1377726.099153]  ? raid_run_ops+0x1460/0x1460 [raid456]
[1377726.099153]  ? blk_account_io_start+0xb2/0x160
[1377726.099153]  ? bio_attempt_back_merge+0x80/0xe0
[1377726.099154]  ? blk_attempt_plug_merge+0x111/0x120
[1377726.099154]  ? blk_mq_make_request+0x33f/0x5d0
[1377726.099154]  ops_run_check_pq+0xa4/0x110 [raid456]
[1377726.099154]  raid_run_ops+0x1d0/0x1460 [raid456]
[1377726.099155]  handle_stripe+0xd12/0x2230 [raid456]
[1377726.099155]  ? __blk_mq_delay_run_hw_queue+0x140/0x160
[1377726.099155]  handle_active_stripes.isra.78+0x3b8/0x590 [raid456]
[1377726.099156]  raid5_do_work+0x9e/0x1d0 [raid456]
[1377726.099156]  ? try_to_wake_up+0x215/0x640
[1377726.099156]  process_one_work+0x1a7/0x360
[1377726.099156]  worker_thread+0x30/0x390
[1377726.099156]  ? create_worker+0x1a0/0x1a0
[1377726.099157]  kthread+0x112/0x130
[1377726.099157]  ? kthread_park+0x80/0x80
[1377726.099157]  ret_from_fork+0x35/0x40
[1377726.099174] NMI backtrace for cpu 25 skipped: idling at intel_idle+0x85/0x130
[1377726.099249] NMI backtrace for cpu 26
[1377726.099250] CPU: 26 PID: 29414 Comm: md6_resync Tainted: G        W         5.4.0-0.bpo.2-amd64 #1 Debian 5.4.8-1~bpo10+1
[1377726.099251] Hardware name: Supermicro Super Server/X11DPH-T, BIOS 2.1 06/15/2018
[1377726.099251] RIP: 0010:try_to_wake_up+0x553/0x640
[1377726.099252] Code: a3 48 89 fe 4c 01 fa 48 81 c2 e0 0b 00 00 e8 04 66 34 00 84 c0 0f 84 c6 fc ff ff 48 8b 04 24 49 8b 8c 07 78 09 00 00 48 8b 11 <eb> 1c f6 c2 08 75 6a 48 89 d6 48 89 d0 48 83 ce 08 f0 48 0f b1 31
[1377726.099253] RSP: 0018:ffffa88420f8fb40 EFLAGS: 00000002
[1377726.099254] RAX: ffff8e107fc40000 RBX: ffff8e3036e15800 RCX: ffff8e1077e24200
[1377726.099255] RDX: 0000000080204800 RSI: ffff8e3036e15830 RDI: ffff8e3036e15830
[1377726.099256] RBP: 000000000000002b R08: 0000000000000002 R09: 0000000000029f40
[1377726.099256] R10: 0115db11c11a940c R11: 0000000000000000 R12: 0000000000000000
[1377726.099257] R13: ffff8e3036e15f6c R14: 0000000000000087 R15: 000000000002a6c0
[1377726.099258] FS:  0000000000000000(0000) GS:ffff8e307f400000(0000) knlGS:0000000000000000
[1377726.099258] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[1377726.099259] CR2: 00006edee52f6020 CR3: 000000018500a003 CR4: 00000000007626e0
[1377726.099259] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[1377726.099259] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[1377726.099260] PKRU: 55555554
[1377726.099260] Call Trace:
[1377726.099261]  ? __switch_to_asm+0x40/0x70
[1377726.099261]  ? __switch_to_asm+0x34/0x70
[1377726.099261]  autoremove_wake_function+0x11/0x50
[1377726.099262]  __wake_up_common+0x7a/0x180
[1377726.099262]  __wake_up_common_lock+0x7a/0xc0
[1377726.099263]  raid5_release_stripe+0x10f/0x120 [raid456]
[1377726.099263]  raid5_sync_request+0x1e3/0x3b0 [raid456]
[1377726.099264]  ? cpumask_next+0x16/0x20
[1377726.099264]  ? is_mddev_idle+0xcc/0x12a [md_mod]
[1377726.099264]  md_do_sync.cold.90+0x424/0x953 [md_mod]
[1377726.099265]  ? update_load_avg+0x7c/0x610
[1377726.099265]  ? sock_def_error_report+0x40/0x60
[1377726.099266]  ? __switch_to_asm+0x34/0x70
[1377726.099266]  ? finish_wait+0x80/0x80
[1377726.099266]  ? md_register_thread+0xd0/0xd0 [md_mod]
[1377726.099267]  md_thread+0x94/0x150 [md_mod]
[1377726.099267]  kthread+0x112/0x130
[1377726.099268]  ? kthread_park+0x80/0x80
[1377726.099268]  ret_from_fork+0x35/0x40
[1377726.099278] NMI backtrace for cpu 27 skipped: idling at intel_idle+0x85/0x130
[1377726.099311] NMI backtrace for cpu 28 skipped: idling at intel_idle+0x85/0x130
[1377726.099371] NMI backtrace for cpu 30 skipped: idling at intel_idle+0x85/0x130
[1377726.099374] NMI backtrace for cpu 29 skipped: idling at intel_idle+0x85/0x130
[1377726.099523] NMI backtrace for cpu 31 skipped: idling at intel_idle+0x85/0x130
[1377726.099541] NMI backtrace for cpu 32
[1377726.099543] CPU: 32 PID: 11834 Comm: kworker/u146:27 Tainted: G        W         5.4.0-0.bpo.2-amd64 #1 Debian 5.4.8-1~bpo10+1
[1377726.099543] Hardware name: Supermicro Super Server/X11DPH-T, BIOS 2.1 06/15/2018
[1377726.099544] Workqueue: raid5wq raid5_do_work [raid456]
[1377726.099544] RIP: 0010:analyse_stripe+0x480/0x730 [raid456]
[1377726.099546] Code: 0f 84 4b fc ff ff 41 83 44 24 18 01 e9 40 fc ff ff f0 41 80 65 02 df 49 8b 83 20 03 00 00 4c 01 f8 4c 8b 30 f0 41 80 65 02 f7 <4d> 85 f6 0f 85 cb fc ff ff 45 31 f6 31 c0 e9 eb fc ff ff 49 03 41
[1377726.099546] RSP: 0018:ffffa8842118fbc8 EFLAGS: 00000246
[1377726.099547] RAX: ffff8e30782ef4d0 RBX: 0000000000000006 RCX: 0000000000000000
[1377726.099547] RDX: 0000000000000000 RSI: ffffa8842118fc90 RDI: ffff8e106ec6e000
[1377726.099547] RBP: ffff8e1c535e54e0 R08: 0000000000000000 R09: 0000000000000000
[1377726.099548] R10: 0000000000000006 R11: ffff8e106ec6e000 R12: ffffa8842118fc90
[1377726.099548] R13: ffff8e1c535e5f88 R14: ffff8e3044d67e00 R15: 0000000000000090
[1377726.099548] FS:  0000000000000000(0000) GS:ffff8e307f580000(0000) knlGS:0000000000000000
[1377726.099549] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[1377726.099549] CR2: 000067954901b7f0 CR3: 000000018500a002 CR4: 00000000007626e0
[1377726.099549] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[1377726.099550] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[1377726.099550] PKRU: 55555554
[1377726.099550] Call Trace:
[1377726.099550]  handle_stripe+0x136/0x2230 [raid456]
[1377726.099551]  ? __blk_mq_delay_run_hw_queue+0x140/0x160
[1377726.099551]  handle_active_stripes.isra.78+0x3b8/0x590 [raid456]
[1377726.099551]  ? raid5_wakeup_stripe_thread+0x98/0x220 [raid456]
[1377726.099552]  raid5_do_work+0x9e/0x1d0 [raid456]
[1377726.099552]  ? try_to_wake_up+0x215/0x640
[1377726.099552]  process_one_work+0x1a7/0x360
[1377726.099552]  worker_thread+0x1fa/0x390
[1377726.099553]  ? create_worker+0x1a0/0x1a0
[1377726.099553]  kthread+0x112/0x130
[1377726.099553]  ? kthread_park+0x80/0x80
[1377726.099553]  ret_from_fork+0x35/0x40
[1377726.099573] NMI backtrace for cpu 34 skipped: idling at intel_idle+0x85/0x130
[1377726.099580] NMI backtrace for cpu 33 skipped: idling at intel_idle+0x85/0x130
[1377726.099671] NMI backtrace for cpu 36 skipped: idling at intel_idle+0x85/0x130
[1377726.099673] NMI backtrace for cpu 35 skipped: idling at intel_idle+0x85/0x130
[1377726.099809] NMI backtrace for cpu 37 skipped: idling at intel_idle+0x85/0x130
[1377726.099908] NMI backtrace for cpu 38 skipped: idling at intel_idle+0x85/0x130
[1377726.099971] NMI backtrace for cpu 39 skipped: idling at intel_idle+0x85/0x130
[1377726.100067] NMI backtrace for cpu 40 skipped: idling at intel_idle+0x85/0x130
[1377726.100169] NMI backtrace for cpu 41 skipped: idling at intel_idle+0x85/0x130
[1377726.100226] NMI backtrace for cpu 43
[1377726.100227] CPU: 43 PID: 1400 Comm: kworker/43:1H Tainted: G        W         5.4.0-0.bpo.2-amd64 #1 Debian 5.4.8-1~bpo10+1
[1377726.100228] Hardware name: Supermicro Super Server/X11DPH-T, BIOS 2.1 06/15/2018
[1377726.100228] Workqueue: kblockd blk_mq_run_work_fn
[1377726.100229] RIP: 0010:blk_rq_map_sg+0x571/0x6e0
[1377726.100230] Code: 48 8b 44 24 08 89 54 24 60 be 01 00 00 00 48 89 44 24 58 8b 04 24 89 44 24 64 4d 8b 12 4d 85 d2 0f 84 f1 00 00 00 41 8b 42 2c <45> 8b 72 28 45 8b 6a 30 89 44 24 1c e9 11 fb ff ff 89 c6 4d 8b 03
[1377726.100230] RSP: 0018:ffffa88420263bd8 EFLAGS: 00000286
[1377726.100231] RAX: 0000000000000000 RBX: ffff8e0f015d0e60 RCX: 0000000000001000
[1377726.100231] RDX: 0000000000001000 RSI: 0000000000000001 RDI: ffff8e22e9a9a3f8
[1377726.100232] RBP: 0000002427c98000 R08: 0000000000001000 R09: ffff8e3033808000
[1377726.100232] R10: ffff8e1d4be18ab8 R11: 0000000000000001 R12: 00000032530be000
[1377726.100232] R13: 0000000000000000 R14: 0000000000000000 R15: ffff8e10241bd800
[1377726.100233] FS:  0000000000000000(0000) GS:ffff8e107fc40000(0000) knlGS:0000000000000000
[1377726.100233] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[1377726.100233] CR2: 0000721583a47730 CR3: 000000018500a004 CR4: 00000000007626e0
[1377726.100234] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[1377726.100234] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[1377726.100234] PKRU: 55555554
[1377726.100234] Call Trace:
[1377726.100235]  scsi_init_io+0x64/0x160 [scsi_mod]
[1377726.100235]  sd_init_command+0x221/0xb10 [sd_mod]
[1377726.100235]  scsi_queue_rq+0x31d/0x9f0 [scsi_mod]
[1377726.100235]  blk_mq_dispatch_rq_list+0x41a/0x5b0
[1377726.100236]  ? syscall_return_via_sysret+0x10/0x7f
[1377726.100236]  ? __switch_to_asm+0x34/0x70
[1377726.100236]  ? elv_rb_del+0x1f/0x30
[1377726.100237]  ? deadline_remove_request+0x55/0xc0
[1377726.100237]  blk_mq_do_dispatch_sched+0x76/0x110
[1377726.100237]  blk_mq_sched_dispatch_requests+0x11b/0x170
[1377726.100237]  __blk_mq_run_hw_queue+0x52/0x110
[1377726.100238]  process_one_work+0x1a7/0x360
[1377726.100238]  worker_thread+0x30/0x390
[1377726.100238]  ? create_worker+0x1a0/0x1a0
[1377726.100238]  kthread+0x112/0x130
[1377726.100238]  ? kthread_park+0x80/0x80
[1377726.100239]  ret_from_fork+0x35/0x40
[1377726.100266] NMI backtrace for cpu 44 skipped: idling at intel_idle+0x85/0x130
[1377726.100374] NMI backtrace for cpu 45 skipped: idling at intel_idle+0x85/0x130
[1377726.100466] NMI backtrace for cpu 46 skipped: idling at intel_idle+0x85/0x130
[1377726.100624] NMI backtrace for cpu 47 skipped: idling at intel_idle+0x85/0x130
[1377726.100665] NMI backtrace for cpu 48 skipped: idling at intel_idle+0x85/0x130
[1377726.100803] NMI backtrace for cpu 49 skipped: idling at intel_idle+0x85/0x130
[1377726.100950] NMI backtrace for cpu 50
[1377726.100951] CPU: 50 PID: 1511 Comm: md5_raid6 Tainted: G        W         5.4.0-0.bpo.2-amd64 #1 Debian 5.4.8-1~bpo10+1
[1377726.100952] Hardware name: Supermicro Super Server/X11DPH-T, BIOS 2.1 06/15/2018
[1377726.100952] RIP: 0010:memcmp+0x29/0x40
[1377726.100953] Code: 00 48 85 d2 74 2e 0f b6 07 0f b6 0e 29 c8 75 23 b9 01 00 00 00 eb 13 44 0f b6 04 0f 44 0f b6 0c 0e 48 83 c1 01 45 29 c8 75 06 <48> 39 d1 75 e8 c3 44 89 c0 c3 31 c0 c3 66 2e 0f 1f 84 00 00 00 00
[1377726.100953] RSP: 0018:ffffa8840f967958 EFLAGS: 00000246
[1377726.100954] RAX: 0000000000000000 RBX: 00000000dac1b5c0 RCX: 0000000000000248
[1377726.100954] RDX: 0000000000001000 RSI: ffff8e303627a000 RDI: ffff8e27306d7000
[1377726.100955] RBP: 0000000000000000 R08: 0000000000000000 R09: 000000000000005e
[1377726.100955] R10: ffff8e1f9d62b000 R11: 0000000000000004 R12: ffffa8840f967b18
[1377726.100955] R13: 0000000000000000 R14: ffff8e3036328030 R15: ffff8e3036328038
[1377726.100956] FS:  0000000000000000(0000) GS:ffff8e107fe00000(0000) knlGS:0000000000000000
[1377726.100956] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[1377726.100956] CR2: 00001b221a938a98 CR3: 000000018500a004 CR4: 00000000007626e0
[1377726.100957] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[1377726.100957] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[1377726.100957] PKRU: 55555554
[1377726.100957] Call Trace:
[1377726.100958]  async_syndrome_val+0x2a0/0x707 [async_pq]
[1377726.100958]  ? raid_run_ops+0x1460/0x1460 [raid456]
[1377726.100958]  ? __switch_to_asm+0x40/0x70
[1377726.100959]  ? __switch_to_asm+0x40/0x70
[1377726.100959]  ? __switch_to_asm+0x34/0x70
[1377726.100959]  ? __switch_to_asm+0x40/0x70
[1377726.100959]  ? __switch_to_asm+0x34/0x70
[1377726.100960]  ? __switch_to_asm+0x40/0x70
[1377726.100960]  ? __switch_to_asm+0x34/0x70
[1377726.100960]  ? __switch_to_asm+0x40/0x70
[1377726.100960]  ? __switch_to_asm+0x34/0x70
[1377726.100961]  ? __switch_to_asm+0x40/0x70
[1377726.100961]  ? __switch_to_asm+0x34/0x70
[1377726.100961]  ? __switch_to_asm+0x40/0x70
[1377726.100962]  ? __switch_to_asm+0x34/0x70
[1377726.100962]  ? __switch_to_asm+0x40/0x70
[1377726.100962]  ? __switch_to_asm+0x34/0x70
[1377726.100962]  ? __switch_to_asm+0x40/0x70
[1377726.100962]  ? __switch_to_asm+0x34/0x70
[1377726.100963]  ? __switch_to_asm+0x40/0x70
[1377726.100963]  ? __switch_to_asm+0x34/0x70
[1377726.100963]  ? __switch_to_asm+0x40/0x70
[1377726.100963]  ? update_group_capacity+0x25/0x1b0
[1377726.100964]  ? cpumask_next_and+0x19/0x20
[1377726.100964]  ? update_sd_lb_stats+0x636/0x710
[1377726.100964]  ops_run_check_pq+0xa4/0x110 [raid456]
[1377726.100965]  raid_run_ops+0x1d0/0x1460 [raid456]
[1377726.100965]  handle_stripe+0xd12/0x2230 [raid456]
[1377726.100965]  handle_active_stripes.isra.78+0x3b8/0x590 [raid456]
[1377726.100965]  raid5d+0x392/0x5b0 [raid456]
[1377726.100966]  ? md_register_thread+0xd0/0xd0 [md_mod]
[1377726.100966]  ? schedule_timeout+0x20d/0x310
[1377726.100966]  ? md_register_thread+0xd0/0xd0 [md_mod]
[1377726.100966]  md_thread+0x94/0x150 [md_mod]
[1377726.100967]  ? finish_wait+0x80/0x80
[1377726.100967]  kthread+0x112/0x130
[1377726.100967]  ? kthread_park+0x80/0x80
[1377726.100967]  ret_from_fork+0x35/0x40
[1377726.100969] NMI backtrace for cpu 51 skipped: idling at intel_idle+0x85/0x130
[1377726.101061] NMI backtrace for cpu 52 skipped: idling at intel_idle+0x85/0x130
[1377726.101160] NMI backtrace for cpu 53 skipped: idling at intel_idle+0x85/0x130
[1377726.101165] NMI backtrace for cpu 54 skipped: idling at intel_idle+0x85/0x130
[1377726.101270] NMI backtrace for cpu 55 skipped: idling at intel_idle+0x85/0x130
[1377726.101360] NMI backtrace for cpu 56 skipped: idling at intel_idle+0x85/0x130
[1377726.101461] NMI backtrace for cpu 57 skipped: idling at intel_idle+0x85/0x130
[1377726.101510] NMI backtrace for cpu 58 skipped: idling at intel_idle+0x85/0x130
[1377726.101563] NMI backtrace for cpu 59 skipped: idling at intel_idle+0x85/0x130
[1377726.101599] NMI backtrace for cpu 60 skipped: idling at intel_idle+0x85/0x130
[1377726.101659] NMI backtrace for cpu 61 skipped: idling at intel_idle+0x85/0x130
[1377726.101728] NMI backtrace for cpu 62
[1377726.101729] CPU: 62 PID: 62874 Comm: kworker/u146:30 Tainted: G        W         5.4.0-0.bpo.2-amd64 #1 Debian 5.4.8-1~bpo10+1
[1377726.101729] Hardware name: Supermicro Super Server/X11DPH-T, BIOS 2.1 06/15/2018
[1377726.101730] Workqueue: raid5wq raid5_do_work [raid456]
[1377726.101731] RIP: 0010:memcmp+0x29/0x40
[1377726.101732] Code: 00 48 85 d2 74 2e 0f b6 07 0f b6 0e 29 c8 75 23 b9 01 00 00 00 eb 13 44 0f b6 04 0f 44 0f b6 0c 0e 48 83 c1 01 45 29 c8 75 06 <48> 39 d1 75 e8 c3 44 89 c0 c3 31 c0 c3 66 2e 0f 1f 84 00 00 00 00
[1377726.101732] RSP: 0018:ffffa8840fbe3958 EFLAGS: 00000246
[1377726.101733] RAX: 0000000000000000 RBX: ffffe26cfedc0640 RCX: 00000000000004f5
[1377726.101733] RDX: 0000000000001000 RSI: ffff8e3037019000 RDI: ffff8df644e2a000
[1377726.101734] RBP: 0000000000000008 R08: 0000000000000000 R09: 00000000000000d2
[1377726.101734] R10: ffff8e3037019000 R11: ffffffffc0382000 R12: ffffa8840fbe3b18
[1377726.101735] R13: 0000000000000000 R14: ffff8e30359d8030 R15: ffff8e30359d8038
[1377726.101735] FS:  0000000000000000(0000) GS:ffff8e307f880000(0000) knlGS:0000000000000000
[1377726.101736] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[1377726.101736] CR2: 0000731dc3ee37f0 CR3: 000000018500a002 CR4: 00000000007626e0
[1377726.101737] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[1377726.101738] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[1377726.101738] PKRU: 55555554
[1377726.101738] Call Trace:
[1377726.101739]  async_syndrome_val+0x1de/0x707 [async_pq]
[1377726.101740]  ? raid_run_ops+0x1460/0x1460 [raid456]
[1377726.101740]  ? blk_account_io_start+0xb2/0x160
[1377726.101740]  ? bio_attempt_back_merge+0x80/0xe0
[1377726.101741]  ? blk_attempt_plug_merge+0x111/0x120
[1377726.101742]  ? blk_mq_make_request+0x33f/0x5d0
[1377726.101742]  ops_run_check_pq+0xa4/0x110 [raid456]
[1377726.101743]  raid_run_ops+0x1d0/0x1460 [raid456]
[1377726.101743]  handle_stripe+0xd12/0x2230 [raid456]
[1377726.101744]  handle_active_stripes.isra.78+0x3b8/0x590 [raid456]
[1377726.101744]  raid5_do_work+0x9e/0x1d0 [raid456]
[1377726.101745]  ? try_to_wake_up+0x215/0x640
[1377726.101745]  process_one_work+0x1a7/0x360
[1377726.101745]  worker_thread+0x30/0x390
[1377726.101746]  ? create_worker+0x1a0/0x1a0
[1377726.101746]  kthread+0x112/0x130
[1377726.101746]  ? kthread_park+0x80/0x80
[1377726.101747]  ret_from_fork+0x35/0x40
[1377726.101761] NMI backtrace for cpu 64 skipped: idling at intel_idle+0x85/0x130
[1377726.101838] NMI backtrace for cpu 63
[1377726.101839] CPU: 63 PID: 73502 Comm: kworker/u146:8 Tainted: G        W         5.4.0-0.bpo.2-amd64 #1 Debian 5.4.8-1~bpo10+1
[1377726.101839] Hardware name: Supermicro Super Server/X11DPH-T, BIOS 2.1 06/15/2018
[1377726.101840] Workqueue: raid5wq raid5_do_work [raid456]
[1377726.101840] RIP: 0010:raid6_avx5122_gen_syndrome+0x3c/0x160 [raid6_pq]
[1377726.101841] Code: 49 89 d5 41 54 4c 8d 3c c5 00 00 00 00 49 89 f4 55 53 48 8b 1c c2 4a 8b 6c 3a 08 e8 ee 27 6f e2 62 f1 fd 48 6f 05 44 51 01 00 <62> f1 f5 48 ef c9 4d 85 e4 0f 84 ff 00 00 00 45 8d 5e fc 4f 8b 54
[1377726.101842] RSP: 0018:ffffa88421c67770 EFLAGS: 00000202
[1377726.101842] RAX: 0000000080000000 RBX: ffff8e10773db000 RCX: ffff8e1773df8000
[1377726.101843] RDX: ffff8e30359e0050 RSI: 0000000000001000 RDI: 0000000000000008
[1377726.101843] RBP: ffff8e303701a000 R08: ffff8e30359e0050 R09: ffffffffc0343200
[1377726.101843] R10: 0000000000000007 R11: 0000000000000000 R12: 0000000000001000
[1377726.101844] R13: ffff8e30359e0050 R14: 0000000000000008 R15: 0000000000000030
[1377726.101844] FS:  0000000000000000(0000) GS:ffff8e307f8c0000(0000) knlGS:0000000000000000
[1377726.101844] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[1377726.101845] CR2: 00007cadb309f5e0 CR3: 000000018500a004 CR4: 00000000007626e0
[1377726.101845] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[1377726.101845] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[1377726.101846] PKRU: 55555554
[1377726.101846] Call Trace:
[1377726.101846]  async_gen_syndrome+0x353/0x750 [async_pq]
[1377726.101846]  ? elv_rb_del+0x1f/0x30
[1377726.101847]  ? deadline_remove_request+0x55/0xc0
[1377726.101847]  ? elv_rb_del+0x1f/0x30
[1377726.101847]  ? deadline_remove_request+0x55/0xc0
[1377726.101847]  ? blk_mq_do_dispatch_sched+0xb1/0x110
[1377726.101848]  ? xor_avx_5+0x2a/0x370 [xor]
[1377726.101848]  ? xor_avx_3+0x20/0x250 [xor]
[1377726.101848]  ? async_xor+0x28a/0x5b0 [async_xor]
[1377726.101848]  ? alloc_iova+0xf2/0x140
[1377726.101849]  async_syndrome_val+0x246/0x707 [async_pq]
[1377726.101849]  ? raid_run_ops+0x1460/0x1460 [raid456]
[1377726.101849]  ? bio_attempt_back_merge+0x80/0xe0
[1377726.101849]  ? deadline_read_expire_show+0x30/0x30
[1377726.101850]  ? elv_merged_request+0x40/0x50
[1377726.101850]  ? blk_mq_sched_try_merge+0x157/0x180
[1377726.101850]  ? dd_bio_merge+0x59/0xa0
[1377726.101850]  ? blk_mq_make_request+0xe5/0x5d0
[1377726.101851]  ops_run_check_pq+0xa4/0x110 [raid456]
[1377726.101851]  raid_run_ops+0x1d0/0x1460 [raid456]
[1377726.101851]  ? ops_complete_check+0x50/0x50 [raid456]
[1377726.101852]  ? account_entity_enqueue+0x9c/0xd0
[1377726.101852]  handle_stripe+0xd12/0x2230 [raid456]
[1377726.101852]  ? enqueue_task_fair+0x94/0x4d0
[1377726.101852]  handle_active_stripes.isra.78+0x3b8/0x590 [raid456]
[1377726.101853]  raid5_do_work+0x9e/0x1d0 [raid456]
[1377726.101853]  ? try_to_wake_up+0x215/0x640
[1377726.101853]  process_one_work+0x1a7/0x360
[1377726.101853]  worker_thread+0x30/0x390
[1377726.101854]  ? create_worker+0x1a0/0x1a0
[1377726.101854]  kthread+0x112/0x130
[1377726.101854]  ? kthread_park+0x80/0x80
[1377726.101855]  ret_from_fork+0x35/0x40
[1377726.101857] NMI backtrace for cpu 65 skipped: idling at intel_idle+0x85/0x130
[1377726.101859] NMI backtrace for cpu 66 skipped: idling at intel_idle+0x85/0x130
[1377726.101961] NMI backtrace for cpu 68 skipped: idling at intel_idle+0x85/0x130
[1377726.102009] NMI backtrace for cpu 67 skipped: idling at intel_idle+0x85/0x130
[1377726.102110] NMI backtrace for cpu 69 skipped: idling at intel_idle+0x85/0x130
[1377726.102139] NMI backtrace for cpu 70
[1377726.102140] CPU: 70 PID: 11558 Comm: kworker/u146:26 Tainted: G        W         5.4.0-0.bpo.2-amd64 #1 Debian 5.4.8-1~bpo10+1
[1377726.102140] Hardware name: Supermicro Super Server/X11DPH-T, BIOS 2.1 06/15/2018
[1377726.102141] Workqueue: raid5wq raid5_do_work [raid456]
[1377726.102142] RIP: 0010:memcmp+0x16/0x40
[1377726.102143] Code: 01 48 39 f8 75 f0 c3 48 89 f8 c3 66 0f 1f 84 00 00 00 00 00 48 85 d2 74 2e 0f b6 07 0f b6 0e 29 c8 75 23 b9 01 00 00 00 eb 13 <44> 0f b6 04 0f 44 0f b6 0c 0e 48 83 c1 01 45 29 c8 75 06 48 39 d1
[1377726.102143] RSP: 0018:ffffa88421037958 EFLAGS: 00000283
[1377726.102144] RAX: 0000000000000000 RBX: ffffe26cffbdd480 RCX: 0000000000000c58
[1377726.102144] RDX: 0000000000001000 RSI: ffff8e306f752000 RDI: ffff8e1d12b31000
[1377726.102145] RBP: 0000000000000008 R08: 0000000000000000 R09: 00000000000000c4
[1377726.102145] R10: ffff8e306f752000 R11: ffffffffc0382000 R12: ffffa88421037b18
[1377726.102145] R13: 0000000000000000 R14: ffff8e3031068030 R15: ffff8e3031068038
[1377726.102146] FS:  0000000000000000(0000) GS:ffff8e307fa80000(0000) knlGS:0000000000000000
[1377726.102146] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[1377726.102146] CR2: 000071cfdd5f6160 CR3: 000000018500a004 CR4: 00000000007626e0
[1377726.102147] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[1377726.102147] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[1377726.102147] PKRU: 55555554
[1377726.102147] Call Trace:
[1377726.102148]  async_syndrome_val+0x1de/0x707 [async_pq]
[1377726.102148]  ? raid_run_ops+0x1460/0x1460 [raid456]
[1377726.102148]  ? bio_attempt_back_merge+0x80/0xe0
[1377726.102148]  ? deadline_read_expire_show+0x30/0x30
[1377726.102149]  ? elv_merged_request+0x40/0x50
[1377726.102149]  ? blk_mq_sched_try_merge+0x157/0x180
[1377726.102149]  ? dd_bio_merge+0x59/0xa0
[1377726.102150]  ? blk_mq_make_request+0xe5/0x5d0
[1377726.102150]  ops_run_check_pq+0xa4/0x110 [raid456]
[1377726.102150]  raid_run_ops+0x1d0/0x1460 [raid456]
[1377726.102150]  ? __update_load_avg_cfs_rq+0x1d5/0x2c0
[1377726.102151]  ? account_entity_enqueue+0x9c/0xd0
[1377726.102151]  handle_stripe+0xd12/0x2230 [raid456]
[1377726.102151]  ? enqueue_task_fair+0x94/0x4d0
[1377726.102152]  handle_active_stripes.isra.78+0x3b8/0x590 [raid456]
[1377726.102152]  raid5_do_work+0x9e/0x1d0 [raid456]
[1377726.102152]  ? try_to_wake_up+0x215/0x640
[1377726.102153]  process_one_work+0x1a7/0x360
[1377726.102153]  worker_thread+0x30/0x390
[1377726.102153]  ? create_worker+0x1a0/0x1a0
[1377726.102153]  kthread+0x112/0x130
[1377726.102154]  ? kthread_park+0x80/0x80
[1377726.102156]  ret_from_fork+0x35/0x40
[1377726.102198] NMI backtrace for cpu 71 skipped: idling at intel_idle+0x85/0x130


--------------728BE3EF25B76081DD2CF359--
