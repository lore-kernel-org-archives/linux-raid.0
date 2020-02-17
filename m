From: Georgi Nikolov <gnikolov@icdsoft.com>
Subject: Re: Pausing md check hangs
Date: Mon, 17 Feb 2020 14:14:40 +0200
Message-ID: <88ecd551-f8ac-badc-9c62-1e3f7ee4f55d@icdsoft.com>
References: <2ce8813c-fd3e-5e78-39ac-049ddfa79ff6@icdsoft.com>
 <CAPhsuW4Jc-qef9uW-JSut90qOpDc_4VoAFpMU8KwqnK7EeT_xg@mail.gmail.com>
 <ac3ae81d-8dad-8b4e-bc61-fc37514e3929@icdsoft.com>
 <CAPhsuW4JJiDroE33m0=XE9PxtUOncK3--waY_zxxbAT9j+1m6g@mail.gmail.com>
 <cc483055-45de-4bd2-8a4f-71e9c8ed6b90@icdsoft.com>
 <CAPhsuW6wZ_n1BVP6+nZ12MgnkM1OgmzSs+KeC0tGDvX-RG3KvA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------3A225A30193F7C0351014E22"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPhsuW6wZ_n1BVP6+nZ12MgnkM1OgmzSs+KeC0tGDvX-RG3KvA@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <song@kernel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------3A225A30193F7C0351014E22
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

I found old log file with kernel prints. May be it will give more 
insights of what was happening.
In the meantime i will try to get more fresh info.
> Hmm... This is weird. Could you try use perf or some other tools to get insights
> on what the thread is doing?
>
> Thanks,
> Song
Regards,
Georgi Nikolov

--------------3A225A30193F7C0351014E22
Content-Type: text/x-log; charset=UTF-8;
 name="supermicro-03-12-2019.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="supermicro-03-12-2019.log"

Dec  3 11:42:17 supermicro kernel: [684461.491490] NMI backtrace for cpu 30
Dec  3 11:42:17 supermicro kernel: [684461.491490] CPU: 30 PID: 67325 Comm: kworker/u146:9 Not tainted 4.19.0-6-amd64 #1 Debian 4.19.67-2+deb10u2
Dec  3 11:42:17 supermicro kernel: [684461.491490] Hardware name: Supermicro Super Server/X11DPH-T, BIOS 2.1 06/15/2018
Dec  3 11:42:17 supermicro kernel: [684461.491491] Workqueue: raid5wq raid5_do_work [raid456]
Dec  3 11:42:17 supermicro kernel: [684461.491491] RIP: 0010:native_queued_spin_lock_slowpath+0x15f/0x190
Dec  3 11:42:17 supermicro kernel: [684461.491492] Code: c1 ee 12 83 e0 03 83 ee 01 48 c1 e0 04 48 63 f6 48 05 00 2d 02 00 48 03 04 f5 20 e7 ee a3 48 89 10 8b 42 08 85 c0 75 09 f3 90 <8b> 42 08 85 c0 74 f7 48 8b 02 48 85 c0 74 88 48 89 c6 0f 0d 08 eb
Dec  3 11:42:17 supermicro kernel: [684461.491492] RSP: 0018:ffff9f787f503e18 EFLAGS: 00000046
Dec  3 11:42:17 supermicro kernel: [684461.491493] RAX: 0000000000000000 RBX: 0000000000000086 RCX: 00000000007c0000
Dec  3 11:42:17 supermicro kernel: [684461.491493] RDX: ffff9f787f522d00 RSI: 0000000000000034 RDI: ffff9f586c41a418
Dec  3 11:42:17 supermicro kernel: [684461.491493] RBP: 0000000ffffda200 R08: 0000000000000000 R09: ffffffffa350cd00
Dec  3 11:42:17 supermicro kernel: [684461.491494] R10: ffff9f774a2e1880 R11: 0000000000000001 R12: ffff9f586c41a418
Dec  3 11:42:17 supermicro kernel: [684461.491494] R13: 0000000000dae786 R14: 0000000000000028 R15: ffffd4d77f9c3820
Dec  3 11:42:17 supermicro kernel: [684461.491494] FS:  0000000000000000(0000) GS:ffff9f787f500000(0000) knlGS:0000000000000000
Dec  3 11:42:17 supermicro kernel: [684461.491494] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Dec  3 11:42:17 supermicro kernel: [684461.491495] CR2: 0000680c92fd4080 CR3: 00000004b820a003 CR4: 00000000007626e0
Dec  3 11:42:17 supermicro kernel: [684461.491495] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Dec  3 11:42:17 supermicro kernel: [684461.491495] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Dec  3 11:42:17 supermicro kernel: [684461.491495] PKRU: 55555554
Dec  3 11:42:17 supermicro kernel: [684461.491495] Call Trace:
Dec  3 11:42:17 supermicro kernel: [684461.491496]  <IRQ>
Dec  3 11:42:17 supermicro kernel: [684461.491496]  _raw_spin_lock_irqsave+0x32/0x40
Dec  3 11:42:17 supermicro kernel: [684461.491496]  find_iova+0x14/0x40
Dec  3 11:42:17 supermicro kernel: [684461.491496]  free_iova+0xe/0x20
Dec  3 11:42:17 supermicro kernel: [684461.491496]  fq_ring_free+0x9c/0xd0
Dec  3 11:42:17 supermicro kernel: [684461.491497]  fq_flush_timeout+0x5f/0x90
Dec  3 11:42:17 supermicro kernel: [684461.491497]  ? fq_ring_free+0xd0/0xd0
Dec  3 11:42:17 supermicro kernel: [684461.491497]  call_timer_fn+0x2b/0x130
Dec  3 11:42:17 supermicro kernel: [684461.491497]  run_timer_softirq+0x3d1/0x410
Dec  3 11:42:17 supermicro kernel: [684461.491498]  __do_softirq+0xde/0x2d8
Dec  3 11:42:17 supermicro kernel: [684461.491498]  irq_exit+0xba/0xc0
Dec  3 11:42:17 supermicro kernel: [684461.491498]  smp_apic_timer_interrupt+0x74/0x140
Dec  3 11:42:17 supermicro kernel: [684461.491498]  apic_timer_interrupt+0xf/0x20
Dec  3 11:42:17 supermicro kernel: [684461.491498]  </IRQ>
Dec  3 11:42:17 supermicro kernel: [684461.491498] RIP: 0010:_raw_spin_unlock_irqrestore+0x11/0x20
Dec  3 11:42:17 supermicro kernel: [684461.491499] Code: 40 5c 01 00 48 8b 12 83 e2 08 74 cc eb 9f 90 90 90 90 90 90 90 90 90 90 90 0f 1f 44 00 00 c6 07 00 0f 1f 40 00 48 89 f7 57 9d <0f> 1f 44 00 00 c3 66 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 8b 07
Dec  3 11:42:17 supermicro kernel: [684461.491499] RSP: 0018:ffffb4f7be317580 EFLAGS: 00000283 ORIG_RAX: ffffffffffffff13
Dec  3 11:42:17 supermicro kernel: [684461.491500] RAX: ffff9f53939872c0 RBX: ffff9f586c41a418 RCX: ffff9f5844d3d201
Dec  3 11:42:17 supermicro kernel: [684461.491500] RDX: ffff9f5865334340 RSI: 0000000000000283 RDI: 0000000000000283
Dec  3 11:42:17 supermicro kernel: [684461.491500] RBP: 000000000000007d R08: 0000000001180000 R09: ffffffffa351ca94
Dec  3 11:42:17 supermicro kernel: [684461.491501] R10: 0000000000000000 R11: 000000000000003b R12: ffff9f755823cd00
Dec  3 11:42:17 supermicro kernel: [684461.491501] R13: 0000000000000080 R14: ffffffffffffff80 R15: ffffffffffffff80
Dec  3 11:42:17 supermicro kernel: [684461.491501]  ? dmar_insert_one_dev_info+0xd4/0x4f0
Dec  3 11:42:17 supermicro kernel: [684461.491501]  alloc_iova+0x11f/0x140
Dec  3 11:42:17 supermicro kernel: [684461.491502]  alloc_iova_fast+0x56/0x242
Dec  3 11:42:17 supermicro kernel: [684461.491502]  intel_alloc_iova+0xa7/0xc0
Dec  3 11:42:17 supermicro kernel: [684461.491502]  intel_map_sg+0xb2/0x1c0
Dec  3 11:42:17 supermicro kernel: [684461.491502]  scsi_dma_map+0x52/0x70 [scsi_mod]
Dec  3 11:42:17 supermicro kernel: [684461.491502]  _base_build_sg_scmd_ieee+0x80/0x4f0 [mpt3sas]
Dec  3 11:42:17 supermicro kernel: [684461.491503]  ? scsi_init_sgtable+0x42/0x80 [scsi_mod]
Dec  3 11:42:17 supermicro kernel: [684461.491503]  ? scsi_init_io+0x48/0x1b0 [scsi_mod]
Dec  3 11:42:17 supermicro kernel: [684461.491503]  scsih_qcmd+0x315/0x440 [mpt3sas]
Dec  3 11:42:17 supermicro kernel: [684461.491503]  scsi_dispatch_cmd+0x95/0x230 [scsi_mod]
Dec  3 11:42:17 supermicro kernel: [684461.491503]  scsi_queue_rq+0x527/0x610 [scsi_mod]
Dec  3 11:42:17 supermicro kernel: [684461.491504]  blk_mq_dispatch_rq_list+0x38c/0x590
Dec  3 11:42:17 supermicro kernel: [684461.491504]  ? elevator_find+0x41/0x60
Dec  3 11:42:17 supermicro kernel: [684461.491504]  ? deadline_remove_request+0x55/0xc0
Dec  3 11:42:17 supermicro kernel: [684461.491504]  ? dd_dispatch_request+0x1e1/0x260
Dec  3 11:42:17 supermicro kernel: [684461.491504]  blk_mq_do_dispatch_sched+0x76/0x120
Dec  3 11:42:17 supermicro kernel: [684461.491505]  blk_mq_sched_dispatch_requests+0x11e/0x170
Dec  3 11:42:17 supermicro kernel: [684461.491505]  __blk_mq_run_hw_queue+0x4e/0xe0
Dec  3 11:42:17 supermicro kernel: [684461.491505]  __blk_mq_delay_run_hw_queue+0x143/0x160
Dec  3 11:42:17 supermicro kernel: [684461.491505]  blk_mq_run_hw_queue+0x88/0x110
Dec  3 11:42:17 supermicro kernel: [684461.491506]  blk_mq_flush_plug_list+0x11e/0x280
Dec  3 11:42:17 supermicro kernel: [684461.491506]  blk_flush_plug_list+0xe9/0x240
Dec  3 11:42:17 supermicro kernel: [684461.491506]  blk_mq_make_request+0x3c0/0x530
Dec  3 11:42:17 supermicro kernel: [684461.491506]  generic_make_request+0x1a4/0x400
Dec  3 11:42:17 supermicro kernel: [684461.491506]  ? apic_timer_interrupt+0xa/0x20
Dec  3 11:42:17 supermicro kernel: [684461.491507]  ops_run_io+0x7c3/0xd30 [raid456]
Dec  3 11:42:17 supermicro kernel: [684461.491507]  ? ops_complete_check+0x50/0x50 [raid456]
Dec  3 11:42:17 supermicro kernel: [684461.491507]  handle_stripe+0xc5a/0x1fb0 [raid456]
Dec  3 11:42:17 supermicro kernel: [684461.491507]  handle_active_stripes.isra.72+0x3d2/0x5b0 [raid456]
Dec  3 11:42:17 supermicro kernel: [684461.491507]  raid5_do_work+0x9f/0x1d0 [raid456]
Dec  3 11:42:17 supermicro kernel: [684461.491508]  ? __switch_to_asm+0x35/0x70
Dec  3 11:42:17 supermicro kernel: [684461.491508]  ? finish_wait+0x80/0x80
Dec  3 11:42:17 supermicro kernel: [684461.491508]  process_one_work+0x1a7/0x3a0
Dec  3 11:42:17 supermicro kernel: [684461.491508]  worker_thread+0x1fa/0x390
Dec  3 11:42:17 supermicro kernel: [684461.491508]  ? create_worker+0x1a0/0x1a0
Dec  3 11:42:17 supermicro kernel: [684461.491508]  kthread+0x112/0x130
Dec  3 11:42:17 supermicro kernel: [684461.491509]  ? kthread_bind+0x30/0x30
Dec  3 11:42:17 supermicro kernel: [684461.491509]  ret_from_fork+0x35/0x40
Dec  3 12:05:34 supermicro kernel: [685858.818674] mpt3sas_cm0: log_info(0x30030101): originator(IOP), code(0x03), sub_code(0x0101)
Dec  3 12:05:40 supermicro kernel: [685864.290471] mpt3sas_cm1: log_info(0x30030101): originator(IOP), code(0x03), sub_code(0x0101)
Dec  3 12:10:27 supermicro kernel: [686151.620557] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
Dec  3 12:10:27 supermicro kernel: [686151.620952] rcu: 	68-....: (257 ticks this GP) idle=61e/1/0x4000000000000000 softirq=6778540/6778540 fqs=2416 
Dec  3 12:10:27 supermicro kernel: [686151.621312] rcu: 	(detected by 7, t=5252 jiffies, g=55048417, q=9937)
Dec  3 12:10:27 supermicro kernel: [686151.621677] Sending NMI from CPU 7 to CPUs 68:
Dec  3 12:10:27 supermicro kernel: [686151.623017] NMI backtrace for cpu 68
Dec  3 12:10:27 supermicro kernel: [686151.623018] CPU: 68 PID: 354 Comm: ksoftirqd/68 Not tainted 4.19.0-6-amd64 #1 Debian 4.19.67-2+deb10u2
Dec  3 12:10:27 supermicro kernel: [686151.623018] Hardware name: Supermicro Super Server/X11DPH-T, BIOS 2.1 06/15/2018
Dec  3 12:10:27 supermicro kernel: [686151.623018] RIP: 0010:native_queued_spin_lock_slowpath+0x15f/0x190
Dec  3 12:10:27 supermicro kernel: [686151.623019] Code: c1 ee 12 83 e0 03 83 ee 01 48 c1 e0 04 48 63 f6 48 05 00 2d 02 00 48 03 04 f5 20 e7 ee a3 48 89 10 8b 42 08 85 c0 75 09 f3 90 <8b> 42 08 85 c0 74 f7 48 8b 02 48 85 c0 74 88 48 89 c6 0f 0d 08 eb
Dec  3 12:10:27 supermicro kernel: [686151.623019] RSP: 0018:ffffb4f78d393d28 EFLAGS: 00000046
Dec  3 12:10:27 supermicro kernel: [686151.623020] RAX: 0000000000000000 RBX: 0000000000000082 RCX: 0000000001140000
Dec  3 12:10:27 supermicro kernel: [686151.623020] RDX: ffff9f787fa22d00 RSI: 0000000000000001 RDI: ffff9f586c41a418
Dec  3 12:10:27 supermicro kernel: [686151.623021] RBP: 0000000ffffcf380 R08: 0000000000000000 R09: ffffffffa350cd00
Dec  3 12:10:27 supermicro kernel: [686151.623021] R10: ffff9f7723a867c0 R11: 0000000000000001 R12: ffff9f586c41a418
Dec  3 12:10:27 supermicro kernel: [686151.623021] R13: 0000000000dba141 R14: 00000000000000de R15: ffffd4f77f703820
Dec  3 12:10:27 supermicro kernel: [686151.623022] FS:  0000000000000000(0000) GS:ffff9f787fa00000(0000) knlGS:0000000000000000
Dec  3 12:10:27 supermicro kernel: [686151.623022] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Dec  3 12:10:27 supermicro kernel: [686151.623022] CR2: 00007f8b55bec000 CR3: 00000004b820a004 CR4: 00000000007626e0
Dec  3 12:10:27 supermicro kernel: [686151.623023] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Dec  3 12:10:27 supermicro kernel: [686151.623023] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Dec  3 12:10:27 supermicro kernel: [686151.623023] PKRU: 55555554
Dec  3 12:10:27 supermicro kernel: [686151.623023] Call Trace:
Dec  3 12:10:27 supermicro kernel: [686151.623023]  _raw_spin_lock_irqsave+0x32/0x40
Dec  3 12:10:27 supermicro kernel: [686151.623024]  find_iova+0x14/0x40
Dec  3 12:10:27 supermicro kernel: [686151.623024]  free_iova+0xe/0x20
Dec  3 12:10:27 supermicro kernel: [686151.623024]  fq_ring_free+0x9c/0xd0
Dec  3 12:10:27 supermicro kernel: [686151.623024]  fq_flush_timeout+0x5f/0x90
Dec  3 12:10:27 supermicro kernel: [686151.623024]  ? fq_ring_free+0xd0/0xd0
Dec  3 12:10:27 supermicro kernel: [686151.623025]  call_timer_fn+0x2b/0x130
Dec  3 12:10:27 supermicro kernel: [686151.623025]  run_timer_softirq+0x3d1/0x410
Dec  3 12:10:27 supermicro kernel: [686151.623025]  ? __switch_to_asm+0x35/0x70
Dec  3 12:10:27 supermicro kernel: [686151.623025]  ? __switch_to_asm+0x41/0x70
Dec  3 12:10:27 supermicro kernel: [686151.623025]  ? __switch_to_asm+0x35/0x70
Dec  3 12:10:27 supermicro kernel: [686151.623026]  ? __switch_to_asm+0x41/0x70
Dec  3 12:10:27 supermicro kernel: [686151.623026]  ? __switch_to+0x8c/0x440
Dec  3 12:10:27 supermicro kernel: [686151.623026]  ? __switch_to_asm+0x41/0x70
Dec  3 12:10:27 supermicro kernel: [686151.623026]  ? __switch_to_asm+0x35/0x70
Dec  3 12:10:27 supermicro kernel: [686151.623026]  __do_softirq+0xde/0x2d8
Dec  3 12:10:27 supermicro kernel: [686151.623026]  ? sort_range+0x20/0x20
Dec  3 12:10:27 supermicro kernel: [686151.623027]  run_ksoftirqd+0x26/0x40
Dec  3 12:10:27 supermicro kernel: [686151.623027]  smpboot_thread_fn+0xc5/0x160
Dec  3 12:10:27 supermicro kernel: [686151.623027]  kthread+0x112/0x130
Dec  3 12:10:27 supermicro kernel: [686151.623027]  ? kthread_bind+0x30/0x30
Dec  3 12:10:27 supermicro kernel: [686151.623027]  ret_from_fork+0x35/0x40
Dec  3 12:22:02 supermicro kernel: [686846.268562] rcu: INFO: rcu_sched self-detected stall on CPU
Dec  3 12:22:02 supermicro kernel: [686846.268995] rcu: 	11-....: (1 GPs behind) idle=662/0/0x3 softirq=9077521/9077522 fqs=2438 
Dec  3 12:22:02 supermicro kernel: [686846.269401] rcu: 	 (t=5250 jiffies g=55070037 q=1074)
Dec  3 12:22:02 supermicro kernel: [686846.269835] NMI backtrace for cpu 11
Dec  3 12:22:02 supermicro kernel: [686846.270218] CPU: 11 PID: 0 Comm: swapper/11 Not tainted 4.19.0-6-amd64 #1 Debian 4.19.67-2+deb10u2
Dec  3 12:22:02 supermicro kernel: [686846.270609] Hardware name: Supermicro Super Server/X11DPH-T, BIOS 2.1 06/15/2018
Dec  3 12:22:02 supermicro kernel: [686846.271005] Call Trace:
Dec  3 12:22:02 supermicro kernel: [686846.271382]  <IRQ>
Dec  3 12:22:02 supermicro kernel: [686846.271750]  dump_stack+0x5c/0x80
Dec  3 12:22:02 supermicro kernel: [686846.272105]  nmi_cpu_backtrace.cold.4+0x13/0x50
Dec  3 12:22:02 supermicro kernel: [686846.272457]  ? lapic_can_unplug_cpu.cold.29+0x3b/0x3b
Dec  3 12:22:02 supermicro kernel: [686846.272799]  nmi_trigger_cpumask_backtrace+0xf9/0xfb
Dec  3 12:22:02 supermicro kernel: [686846.273129]  rcu_dump_cpu_stacks+0x9b/0xcb
Dec  3 12:22:02 supermicro kernel: [686846.273468]  rcu_check_callbacks.cold.81+0x1db/0x335
Dec  3 12:22:02 supermicro kernel: [686846.273799]  ? tick_sched_do_timer+0x60/0x60
Dec  3 12:22:02 supermicro kernel: [686846.274128]  update_process_times+0x28/0x60
Dec  3 12:22:02 supermicro kernel: [686846.274454]  tick_sched_handle+0x22/0x60
Dec  3 12:22:02 supermicro kernel: [686846.274783]  tick_sched_timer+0x37/0x70
Dec  3 12:22:02 supermicro kernel: [686846.275096]  __hrtimer_run_queues+0x100/0x280
Dec  3 12:22:02 supermicro kernel: [686846.275405]  hrtimer_interrupt+0x100/0x220
Dec  3 12:22:02 supermicro kernel: [686846.275710]  smp_apic_timer_interrupt+0x6a/0x140
Dec  3 12:22:02 supermicro kernel: [686846.276011]  apic_timer_interrupt+0xf/0x20
Dec  3 12:22:02 supermicro kernel: [686846.276312] RIP: 0010:_raw_spin_unlock_irqrestore+0x11/0x20
Dec  3 12:22:02 supermicro kernel: [686846.276620] Code: 40 5c 01 00 48 8b 12 83 e2 08 74 cc eb 9f 90 90 90 90 90 90 90 90 90 90 90 0f 1f 44 00 00 c6 07 00 0f 1f 40 00 48 89 f7 57 9d <0f> 1f 44 00 00 c3 66 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 8b 07
Dec  3 12:22:02 supermicro kernel: [686846.277281] RSP: 0018:ffff9f587f8c3e88 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
Dec  3 12:22:02 supermicro kernel: [686846.277625] RAX: 00000000000004e0 RBX: ffffd4d77fb41818 RCX: 000000000000000d
Dec  3 12:22:02 supermicro kernel: [686846.277975] RDX: 0000000000000001 RSI: 0000000000000286 RDI: 0000000000000286
Dec  3 12:22:02 supermicro kernel: [686846.278328] RBP: 000000000000000d R08: 00000000000255a0 R09: ffffffffa350d27c
Dec  3 12:22:02 supermicro kernel: [686846.278683] R10: ffffeb7bd9e0b000 R11: 0000000000000001 R12: ffff9f586c41ab30
Dec  3 12:22:02 supermicro kernel: [686846.279041] R13: 0000000000000286 R14: ffff9f586c41a418 R15: ffffd4d77fb43820
Dec  3 12:22:02 supermicro kernel: [686846.279404]  ? apic_timer_interrupt+0xa/0x20
Dec  3 12:22:02 supermicro kernel: [686846.279831]  ? fq_ring_free+0x9c/0xd0
Dec  3 12:22:02 supermicro kernel: [686846.280212]  fq_flush_timeout+0x6a/0x90
Dec  3 12:22:02 supermicro kernel: [686846.280591]  ? fq_ring_free+0xd0/0xd0
Dec  3 12:22:02 supermicro kernel: [686846.280982]  call_timer_fn+0x2b/0x130
Dec  3 12:22:02 supermicro kernel: [686846.281361]  run_timer_softirq+0x3d1/0x410
Dec  3 12:22:02 supermicro kernel: [686846.281744]  ? __hrtimer_run_queues+0x130/0x280
Dec  3 12:22:02 supermicro kernel: [686846.282130]  ? recalibrate_cpu_khz+0x10/0x10
Dec  3 12:22:02 supermicro kernel: [686846.282518]  ? ktime_get+0x3a/0xa0
Dec  3 12:22:02 supermicro kernel: [686846.282911]  __do_softirq+0xde/0x2d8
Dec  3 12:22:02 supermicro kernel: [686846.283305]  irq_exit+0xba/0xc0
Dec  3 12:22:02 supermicro kernel: [686846.283727]  smp_apic_timer_interrupt+0x74/0x140
Dec  3 12:22:02 supermicro kernel: [686846.284137]  apic_timer_interrupt+0xf/0x20
Dec  3 12:22:02 supermicro kernel: [686846.284561]  </IRQ>
Dec  3 12:22:02 supermicro kernel: [686846.284960] RIP: 0010:cpuidle_enter_state+0xb9/0x320
Dec  3 12:22:02 supermicro kernel: [686846.285364] Code: e8 1c d1 b0 ff 80 7c 24 0b 00 74 17 9c 58 0f 1f 44 00 00 f6 c4 02 0f 85 3b 02 00 00 31 ff e8 2e b6 b6 ff fb 66 0f 1f 44 00 00 <48> b8 ff ff ff ff f3 01 00 00 48 2b 1c 24 ba ff ff ff 7f 48 39 c3
Dec  3 12:22:02 supermicro kernel: [686846.286223] RSP: 0018:ffffb4f78c713e90 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
Dec  3 12:22:02 supermicro kernel: [686846.286657] RAX: ffff9f587f8e20c0 RBX: 000270a9f2cd7f68 RCX: 000000000000001f
Dec  3 12:22:02 supermicro kernel: [686846.287088] RDX: 000270a9f2cd7f68 RSI: 0000000037a7018e RDI: 0000000000000000
Dec  3 12:22:02 supermicro kernel: [686846.287519] RBP: ffff9f587f8eb100 R08: 0000000000000002 R09: 0000000000021980
Dec  3 12:22:02 supermicro kernel: [686846.287941] R10: 007c33fa47129860 R11: ffff9f587f8e10a8 R12: 0000000000000001
Dec  3 12:22:02 supermicro kernel: [686846.288356] R13: ffffffffa40b7258 R14: 0000000000000001 R15: 0000000000000000
Dec  3 12:22:02 supermicro kernel: [686846.288771]  do_idle+0x236/0x280
Dec  3 12:22:02 supermicro kernel: [686846.289188]  cpu_startup_entry+0x6f/0x80
Dec  3 12:22:02 supermicro kernel: [686846.289643]  start_secondary+0x1a4/0x1f0
Dec  3 12:22:02 supermicro kernel: [686846.290074]  secondary_startup_64+0xa4/0xb0
Dec  3 12:31:04 supermicro kernel: [687388.374049] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
Dec  3 12:31:04 supermicro kernel: [687388.374534] rcu: 	27-....: (1 GPs behind) idle=f42/1/0x4000000000000000 softirq=6918976/6918978 fqs=2489 
Dec  3 12:31:04 supermicro kernel: [687388.375011] rcu: 	(detected by 4, t=5252 jiffies, g=55083373, q=2525)
Dec  3 12:31:04 supermicro kernel: [687388.375459] Sending NMI from CPU 4 to CPUs 27:
Dec  3 12:31:04 supermicro kernel: [687388.376867] NMI backtrace for cpu 27
Dec  3 12:31:04 supermicro kernel: [687388.376867] CPU: 27 PID: 149 Comm: ksoftirqd/27 Not tainted 4.19.0-6-amd64 #1 Debian 4.19.67-2+deb10u2
Dec  3 12:31:04 supermicro kernel: [687388.376868] Hardware name: Supermicro Super Server/X11DPH-T, BIOS 2.1 06/15/2018
Dec  3 12:31:04 supermicro kernel: [687388.376868] RIP: 0010:native_queued_spin_lock_slowpath+0x15f/0x190
Dec  3 12:31:04 supermicro kernel: [687388.376869] Code: c1 ee 12 83 e0 03 83 ee 01 48 c1 e0 04 48 63 f6 48 05 00 2d 02 00 48 03 04 f5 20 e7 ee a3 48 89 10 8b 42 08 85 c0 75 09 f3 90 <8b> 42 08 85 c0 74 f7 48 8b 02 48 85 c0 74 88 48 89 c6 0f 0d 08 eb
Dec  3 12:31:04 supermicro kernel: [687388.376869] RSP: 0018:ffffb4f78cd2bd38 EFLAGS: 00000046
Dec  3 12:31:04 supermicro kernel: [687388.376870] RAX: 0000000000000000 RBX: 0000000000000082 RCX: 0000000000700000
Dec  3 12:31:04 supermicro kernel: [687388.376870] RDX: ffff9f787f462d00 RSI: 0000000000000002 RDI: ffff9f586c41a418
Dec  3 12:31:04 supermicro kernel: [687388.376871] RBP: ffffd4f77fc41818 R08: 00000000000c0000 R09: ffffffffa350cd01
Dec  3 12:31:04 supermicro kernel: [687388.376871] R10: ffff9f7770ed2880 R11: 0000000000000001 R12: ffff9f7770ed2a80
Dec  3 12:31:04 supermicro kernel: [687388.376871] R13: 0000000000dc002e R14: 00000000000000ba R15: ffffd4f77fc43820
Dec  3 12:31:04 supermicro kernel: [687388.376872] FS:  0000000000000000(0000) GS:ffff9f787f440000(0000) knlGS:0000000000000000
Dec  3 12:31:04 supermicro kernel: [687388.376872] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Dec  3 12:31:04 supermicro kernel: [687388.376872] CR2: 00007f8b6dce78a0 CR3: 00000004b820a004 CR4: 00000000007626e0
Dec  3 12:31:04 supermicro kernel: [687388.376873] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Dec  3 12:31:04 supermicro kernel: [687388.376873] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Dec  3 12:31:04 supermicro kernel: [687388.376873] PKRU: 55555554
Dec  3 12:31:04 supermicro kernel: [687388.376873] Call Trace:
Dec  3 12:31:04 supermicro kernel: [687388.376873]  _raw_spin_lock_irqsave+0x32/0x40
Dec  3 12:31:04 supermicro kernel: [687388.376874]  __free_iova+0x14/0x40
Dec  3 12:31:04 supermicro kernel: [687388.376874]  fq_ring_free+0x9c/0xd0
Dec  3 12:31:04 supermicro kernel: [687388.376874]  fq_flush_timeout+0x5f/0x90
Dec  3 12:31:04 supermicro kernel: [687388.376874]  ? fq_ring_free+0xd0/0xd0
Dec  3 12:31:04 supermicro kernel: [687388.376874]  call_timer_fn+0x2b/0x130
Dec  3 12:31:04 supermicro kernel: [687388.376875]  run_timer_softirq+0x3d1/0x410
Dec  3 12:31:04 supermicro kernel: [687388.376875]  ? __switch_to_asm+0x35/0x70
Dec  3 12:31:04 supermicro kernel: [687388.376875]  ? __switch_to_asm+0x41/0x70
Dec  3 12:31:04 supermicro kernel: [687388.376875]  ? __switch_to_asm+0x35/0x70
Dec  3 12:31:04 supermicro kernel: [687388.376875]  ? __switch_to_asm+0x41/0x70
Dec  3 12:31:04 supermicro kernel: [687388.376876]  ? __switch_to+0x8c/0x440
Dec  3 12:31:04 supermicro kernel: [687388.376876]  ? __switch_to_asm+0x41/0x70
Dec  3 12:31:04 supermicro kernel: [687388.376876]  ? __switch_to_asm+0x35/0x70
Dec  3 12:31:04 supermicro kernel: [687388.376876]  __do_softirq+0xde/0x2d8
Dec  3 12:31:04 supermicro kernel: [687388.376876]  ? sort_range+0x20/0x20
Dec  3 12:31:04 supermicro kernel: [687388.376877]  run_ksoftirqd+0x26/0x40
Dec  3 12:31:04 supermicro kernel: [687388.376877]  smpboot_thread_fn+0xc5/0x160
Dec  3 12:31:04 supermicro kernel: [687388.376877]  kthread+0x112/0x130
Dec  3 12:31:04 supermicro kernel: [687388.376877]  ? kthread_bind+0x30/0x30
Dec  3 12:31:04 supermicro kernel: [687388.376878]  ret_from_fork+0x35/0x40
Dec  3 12:40:05 supermicro kernel: [687929.412330] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
Dec  3 12:40:05 supermicro kernel: [687929.412780] rcu: 	20-....: (1 GPs behind) idle=942/0/0x1 softirq=7068858/7068859 fqs=2578 
Dec  3 12:40:05 supermicro kernel: [687929.413191] rcu: 	(detected by 36, t=5252 jiffies, g=55089529, q=11835)
Dec  3 12:40:05 supermicro kernel: [687929.413585] Sending NMI from CPU 36 to CPUs 20:
Dec  3 12:40:05 supermicro kernel: [687929.414937] NMI backtrace for cpu 20
Dec  3 12:40:05 supermicro kernel: [687929.414937] CPU: 20 PID: 0 Comm: swapper/20 Not tainted 4.19.0-6-amd64 #1 Debian 4.19.67-2+deb10u2
Dec  3 12:40:05 supermicro kernel: [687929.414938] Hardware name: Supermicro Super Server/X11DPH-T, BIOS 2.1 06/15/2018
Dec  3 12:40:05 supermicro kernel: [687929.414938] RIP: 0010:native_queued_spin_lock_slowpath+0x15f/0x190
Dec  3 12:40:05 supermicro kernel: [687929.414939] Code: c1 ee 12 83 e0 03 83 ee 01 48 c1 e0 04 48 63 f6 48 05 00 2d 02 00 48 03 04 f5 20 e7 ee a3 48 89 10 8b 42 08 85 c0 75 09 f3 90 <8b> 42 08 85 c0 74 f7 48 8b 02 48 85 c0 74 88 48 89 c6 0f 0d 08 eb
Dec  3 12:40:05 supermicro kernel: [687929.414939] RSP: 0018:ffff9f787f283e28 EFLAGS: 00000046
Dec  3 12:40:05 supermicro kernel: [687929.414939] RAX: 0000000000000000 RBX: 0000000000000086 RCX: 0000000000540000
Dec  3 12:40:05 supermicro kernel: [687929.414940] RDX: ffff9f787f2a2d00 RSI: 0000000000000037 RDI: ffff9f586c41a418
Dec  3 12:40:05 supermicro kernel: [687929.414940] RBP: ffffd4d77ff41818 R08: 0000000000200000 R09: ffff9f587f006d00
Dec  3 12:40:05 supermicro kernel: [687929.414940] R10: ffff9f50d59b15c0 R11: 0000000000000001 R12: ffff9f50d59b13c0
Dec  3 12:40:05 supermicro kernel: [687929.414941] R13: 0000000000dc1918 R14: 000000000000003d R15: ffffd4d77ff43820
Dec  3 12:40:05 supermicro kernel: [687929.414941] FS:  0000000000000000(0000) GS:ffff9f787f280000(0000) knlGS:0000000000000000
Dec  3 12:40:05 supermicro kernel: [687929.414941] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Dec  3 12:40:05 supermicro kernel: [687929.414941] CR2: 0000148196e28000 CR3: 00000004b820a006 CR4: 00000000007626e0
Dec  3 12:40:05 supermicro kernel: [687929.414942] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Dec  3 12:40:05 supermicro kernel: [687929.414942] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Dec  3 12:40:05 supermicro kernel: [687929.414942] PKRU: 55555554
Dec  3 12:40:05 supermicro kernel: [687929.414942] Call Trace:
Dec  3 12:40:05 supermicro kernel: [687929.414942]  <IRQ>
Dec  3 12:40:05 supermicro kernel: [687929.414942]  _raw_spin_lock_irqsave+0x32/0x40
Dec  3 12:40:05 supermicro kernel: [687929.414943]  __free_iova+0x14/0x40
Dec  3 12:40:05 supermicro kernel: [687929.414943]  fq_ring_free+0x9c/0xd0
Dec  3 12:40:05 supermicro kernel: [687929.414943]  fq_flush_timeout+0x5f/0x90
Dec  3 12:40:05 supermicro kernel: [687929.414943]  ? fq_ring_free+0xd0/0xd0
Dec  3 12:40:05 supermicro kernel: [687929.414943]  call_timer_fn+0x2b/0x130
Dec  3 12:40:05 supermicro kernel: [687929.414944]  run_timer_softirq+0x3d1/0x410
Dec  3 12:40:05 supermicro kernel: [687929.414944]  ? __hrtimer_run_queues+0x130/0x280
Dec  3 12:40:05 supermicro kernel: [687929.414944]  ? recalibrate_cpu_khz+0x10/0x10
Dec  3 12:40:05 supermicro kernel: [687929.414944]  ? ktime_get+0x3a/0xa0
Dec  3 12:40:05 supermicro kernel: [687929.414944]  __do_softirq+0xde/0x2d8
Dec  3 12:40:05 supermicro kernel: [687929.414945]  irq_exit+0xba/0xc0
Dec  3 12:40:05 supermicro kernel: [687929.414945]  smp_apic_timer_interrupt+0x74/0x140
Dec  3 12:40:05 supermicro kernel: [687929.414945]  apic_timer_interrupt+0xf/0x20
Dec  3 12:40:05 supermicro kernel: [687929.414945]  </IRQ>
Dec  3 12:40:05 supermicro kernel: [687929.414945] RIP: 0010:cpuidle_enter_state+0xb9/0x320
Dec  3 12:40:05 supermicro kernel: [687929.414946] Code: e8 1c d1 b0 ff 80 7c 24 0b 00 74 17 9c 58 0f 1f 44 00 00 f6 c4 02 0f 85 3b 02 00 00 31 ff e8 2e b6 b6 ff fb 66 0f 1f 44 00 00 <48> b8 ff ff ff ff f3 01 00 00 48 2b 1c 24 ba ff ff ff 7f 48 39 c3
Dec  3 12:40:05 supermicro kernel: [687929.414946] RSP: 0018:ffffb4f78c75be90 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
Dec  3 12:40:05 supermicro kernel: [687929.414947] RAX: ffff9f787f2a20c0 RBX: 000271a620a13e77 RCX: 000000000000001f
Dec  3 12:40:05 supermicro kernel: [687929.414947] RDX: 000271a620a13e77 RSI: 0000000037a7018e RDI: 0000000000000000
Dec  3 12:40:05 supermicro kernel: [687929.414947] RBP: ffff9f787f2ab100 R08: 0000000000000002 R09: 0000000000021980
Dec  3 12:40:05 supermicro kernel: [687929.414947] R10: 007c363e498f01be R11: ffff9f787f2a10a8 R12: 0000000000000003
Dec  3 12:40:05 supermicro kernel: [687929.414948] R13: ffffffffa40b7318 R14: 0000000000000003 R15: 0000000000000000
Dec  3 12:40:05 supermicro kernel: [687929.414948]  do_idle+0x236/0x280
Dec  3 12:40:05 supermicro kernel: [687929.414948]  cpu_startup_entry+0x6f/0x80
Dec  3 12:40:05 supermicro kernel: [687929.414948]  start_secondary+0x1a4/0x1f0
Dec  3 12:40:05 supermicro kernel: [687929.414948]  secondary_startup_64+0xa4/0xb0
Dec  3 12:55:29 supermicro kernel: [688853.462701] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
Dec  3 12:55:29 supermicro kernel: [688853.463207] rcu: 	7-....: (1 GPs behind) idle=fc6/0/0x1 softirq=9039032/9039033 fqs=2418 
Dec  3 12:55:29 supermicro kernel: [688853.463652] rcu: 	(detected by 46, t=5252 jiffies, g=55108589, q=6076)
Dec  3 12:55:29 supermicro kernel: [688853.464094] Sending NMI from CPU 46 to CPUs 7:
Dec  3 12:55:29 supermicro kernel: [688853.465494] NMI backtrace for cpu 7
Dec  3 12:55:29 supermicro kernel: [688853.465495] CPU: 7 PID: 0 Comm: swapper/7 Not tainted 4.19.0-6-amd64 #1 Debian 4.19.67-2+deb10u2
Dec  3 12:55:29 supermicro kernel: [688853.465495] Hardware name: Supermicro Super Server/X11DPH-T, BIOS 2.1 06/15/2018
Dec  3 12:55:29 supermicro kernel: [688853.465495] RIP: 0010:native_queued_spin_lock_slowpath+0x15f/0x190
Dec  3 12:55:29 supermicro kernel: [688853.465496] Code: c1 ee 12 83 e0 03 83 ee 01 48 c1 e0 04 48 63 f6 48 05 00 2d 02 00 48 03 04 f5 20 e7 ee a3 48 89 10 8b 42 08 85 c0 75 09 f3 90 <8b> 42 08 85 c0 74 f7 48 8b 02 48 85 c0 74 88 48 89 c6 0f 0d 08 eb
Dec  3 12:55:29 supermicro kernel: [688853.465496] RSP: 0018:ffff9f587f7c3e28 EFLAGS: 00000046
Dec  3 12:55:29 supermicro kernel: [688853.465497] RAX: 0000000000000000 RBX: 0000000000000086 RCX: 0000000000200000
Dec  3 12:55:29 supermicro kernel: [688853.465497] RDX: ffff9f587f7e2d00 RSI: 0000000000000029 RDI: ffff9f586c41a418
Dec  3 12:55:29 supermicro kernel: [688853.465497] RBP: ffffd4d780041818 R08: 0000000000100000 R09: ffffffffa350cd00
Dec  3 12:55:29 supermicro kernel: [688853.465498] R10: ffff9f581d6954c0 R11: 0000000000000001 R12: ffff9f581d695000
Dec  3 12:55:29 supermicro kernel: [688853.465498] R13: 0000000000dc574d R14: 00000000000000e5 R15: ffffd4d780043820
Dec  3 12:55:29 supermicro kernel: [688853.465498] FS:  0000000000000000(0000) GS:ffff9f587f7c0000(0000) knlGS:0000000000000000
Dec  3 12:55:29 supermicro kernel: [688853.465499] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Dec  3 12:55:29 supermicro kernel: [688853.465499] CR2: 000070c6429657f0 CR3: 00000004b820a003 CR4: 00000000007626e0
Dec  3 12:55:29 supermicro kernel: [688853.465499] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Dec  3 12:55:29 supermicro kernel: [688853.465499] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Dec  3 12:55:29 supermicro kernel: [688853.465500] PKRU: 55555554
Dec  3 12:55:29 supermicro kernel: [688853.465500] Call Trace:
Dec  3 12:55:29 supermicro kernel: [688853.465500]  <IRQ>
Dec  3 12:55:29 supermicro kernel: [688853.465500]  _raw_spin_lock_irqsave+0x32/0x40
Dec  3 12:55:29 supermicro kernel: [688853.465500]  __free_iova+0x14/0x40
Dec  3 12:55:29 supermicro kernel: [688853.465501]  fq_ring_free+0x9c/0xd0
Dec  3 12:55:29 supermicro kernel: [688853.465501]  fq_flush_timeout+0x5f/0x90
Dec  3 12:55:29 supermicro kernel: [688853.465501]  ? fq_ring_free+0xd0/0xd0
Dec  3 12:55:29 supermicro kernel: [688853.465501]  call_timer_fn+0x2b/0x130
Dec  3 12:55:29 supermicro kernel: [688853.465501]  run_timer_softirq+0x3d1/0x410
Dec  3 12:55:29 supermicro kernel: [688853.465502]  ? __hrtimer_run_queues+0x130/0x280
Dec  3 12:55:29 supermicro kernel: [688853.465502]  ? recalibrate_cpu_khz+0x10/0x10
Dec  3 12:55:29 supermicro kernel: [688853.465502]  ? ktime_get+0x3a/0xa0
Dec  3 12:55:29 supermicro kernel: [688853.465502]  __do_softirq+0xde/0x2d8
Dec  3 12:55:29 supermicro kernel: [688853.465502]  irq_exit+0xba/0xc0
Dec  3 12:55:29 supermicro kernel: [688853.465503]  smp_apic_timer_interrupt+0x74/0x140
Dec  3 12:55:29 supermicro kernel: [688853.465503]  apic_timer_interrupt+0xf/0x20
Dec  3 12:55:29 supermicro kernel: [688853.465503]  </IRQ>
Dec  3 12:55:29 supermicro kernel: [688853.465503] RIP: 0010:cpuidle_enter_state+0xb9/0x320
Dec  3 12:55:29 supermicro kernel: [688853.465504] Code: e8 1c d1 b0 ff 80 7c 24 0b 00 74 17 9c 58 0f 1f 44 00 00 f6 c4 02 0f 85 3b 02 00 00 31 ff e8 2e b6 b6 ff fb 66 0f 1f 44 00 00 <48> b8 ff ff ff ff f3 01 00 00 48 2b 1c 24 ba ff ff ff 7f 48 39 c3
Dec  3 12:55:29 supermicro kernel: [688853.465504] RSP: 0018:ffffb4f78c6f3e90 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
Dec  3 12:55:29 supermicro kernel: [688853.465505] RAX: ffff9f587f7e20c0 RBX: 0002727d48f34618 RCX: 000000000000001f
Dec  3 12:55:29 supermicro kernel: [688853.465505] RDX: 0002727d48f34618 RSI: 0000000037a7018e RDI: 0000000000000000
Dec  3 12:55:29 supermicro kernel: [688853.465505] RBP: ffff9f587f7eb100 R08: 0000000000000002 R09: 0000000000021980
Dec  3 12:55:29 supermicro kernel: [688853.465505] R10: 007c382d25dae100 R11: ffff9f587f7e10a8 R12: 0000000000000003
Dec  3 12:55:29 supermicro kernel: [688853.465506] R13: ffffffffa40b7318 R14: 0000000000000003 R15: 0000000000000000
Dec  3 12:55:29 supermicro kernel: [688853.465506]  do_idle+0x236/0x280
Dec  3 12:55:29 supermicro kernel: [688853.465506]  cpu_startup_entry+0x6f/0x80
Dec  3 12:55:29 supermicro kernel: [688853.465506]  start_secondary+0x1a4/0x1f0
Dec  3 12:55:29 supermicro kernel: [688853.465507]  secondary_startup_64+0xa4/0xb0
Dec  3 13:05:13 supermicro kernel: [689437.845326] mpt3sas_cm0: log_info(0x30030101): originator(IOP), code(0x03), sub_code(0x0101)
Dec  3 13:05:14 supermicro kernel: [689438.607808] mpt3sas_cm1: log_info(0x30030101): originator(IOP), code(0x03), sub_code(0x0101)
Dec  3 14:05:07 supermicro kernel: [693032.368940] mpt3sas_cm0: log_info(0x30030101): originator(IOP), code(0x03), sub_code(0x0101)
Dec  3 14:05:08 supermicro kernel: [693033.090980] mpt3sas_cm1: log_info(0x30030101): originator(IOP), code(0x03), sub_code(0x0101)
Dec  3 14:15:31 supermicro kernel: [693655.666060] md: md2: data-check interrupted.
Dec  3 14:15:33 supermicro kernel: [693657.746216] md: md3: data-check interrupted.
Dec  3 14:15:35 supermicro kernel: [693660.047721] md: md4: data-check interrupted.
Dec  3 14:18:55 supermicro kernel: [693860.191381] INFO: task qemu-system-x86:18753 blocked for more than 120 seconds.
Dec  3 14:18:55 supermicro kernel: [693860.191759]       Not tainted 4.19.0-6-amd64 #1 Debian 4.19.67-2+deb10u2
Dec  3 14:18:55 supermicro kernel: [693860.192128] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec  3 14:18:55 supermicro kernel: [693860.192498] qemu-system-x86 D    0 18753      1 0x00000000
Dec  3 14:18:55 supermicro kernel: [693860.192843] Call Trace:
Dec  3 14:18:55 supermicro kernel: [693860.193181]  ? __schedule+0x2a2/0x870
Dec  3 14:18:55 supermicro kernel: [693860.193509]  schedule+0x28/0x80
Dec  3 14:18:55 supermicro kernel: [693860.193834]  md_write_start+0x14b/0x220 [md_mod]
Dec  3 14:18:55 supermicro kernel: [693860.194157]  ? finish_wait+0x80/0x80
Dec  3 14:18:55 supermicro kernel: [693860.194547]  ? finish_wait+0x80/0x80
Dec  3 14:18:55 supermicro kernel: [693860.194910]  raid5_make_request+0x83/0xb60 [raid456]
Dec  3 14:18:55 supermicro kernel: [693860.195285]  ? try_to_wake_up+0x54/0x490
Dec  3 14:18:55 supermicro kernel: [693860.195635]  ? kmem_cache_alloc+0x37/0x1c0
Dec  3 14:18:55 supermicro kernel: [693860.195967]  ? finish_wait+0x80/0x80
Dec  3 14:18:55 supermicro kernel: [693860.196296]  ? finish_wait+0x80/0x80
Dec  3 14:18:55 supermicro kernel: [693860.196629]  md_handle_request+0x119/0x190 [md_mod]
Dec  3 14:18:55 supermicro kernel: [693860.196954]  md_make_request+0x78/0x160 [md_mod]
Dec  3 14:18:55 supermicro kernel: [693860.197281]  generic_make_request+0x1a4/0x400
Dec  3 14:18:55 supermicro kernel: [693860.197607]  submit_bio+0x45/0x140
Dec  3 14:18:55 supermicro kernel: [693860.197934]  blkdev_direct_IO+0x3b2/0x3f0
Dec  3 14:18:55 supermicro kernel: [693860.198260]  ? aio_fsync_work+0x90/0x90
Dec  3 14:18:55 supermicro kernel: [693860.198586]  generic_file_direct_write+0x96/0x160
Dec  3 14:18:55 supermicro kernel: [693860.198914]  __generic_file_write_iter+0xb7/0x1c0
Dec  3 14:18:55 supermicro kernel: [693860.199264]  blkdev_write_iter+0xa0/0x120
Dec  3 14:18:55 supermicro kernel: [693860.199608]  ? common_file_perm+0x5b/0xf0
Dec  3 14:18:55 supermicro kernel: [693860.199948]  aio_write+0x119/0x1a0
Dec  3 14:18:55 supermicro kernel: [693860.200286]  ? io_submit_one+0x90/0x7c0
Dec  3 14:18:55 supermicro kernel: [693860.200625]  ? io_submit_one+0x90/0x7c0
Dec  3 14:18:55 supermicro kernel: [693860.200959]  ? kmem_cache_alloc+0x192/0x1c0
Dec  3 14:18:55 supermicro kernel: [693860.201293]  io_submit_one+0x5b3/0x7c0
Dec  3 14:18:55 supermicro kernel: [693860.201595]  ? __wake_up_common+0x7a/0x190
Dec  3 14:18:55 supermicro kernel: [693860.201890]  __x64_sys_io_submit+0xa2/0x180
Dec  3 14:18:55 supermicro kernel: [693860.202181]  ? ksys_read+0xb7/0xd0
Dec  3 14:18:55 supermicro kernel: [693860.202469]  do_syscall_64+0x53/0x110
Dec  3 14:18:55 supermicro kernel: [693860.202756]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
Dec  3 14:18:55 supermicro kernel: [693860.203045] RIP: 0033:0x7fe06dea5f59
Dec  3 14:18:55 supermicro kernel: [693860.203355] Code: Bad RIP value.
Dec  3 14:18:55 supermicro kernel: [693860.203642] RSP: 002b:00007fe06b649f78 EFLAGS: 00000246 ORIG_RAX: 00000000000000d1
Dec  3 14:18:55 supermicro kernel: [693860.203944] RAX: ffffffffffffffda RBX: 00007fe06b64b290 RCX: 00007fe06dea5f59
Dec  3 14:18:55 supermicro kernel: [693860.204279] RDX: 00007fe06b649fc0 RSI: 0000000000000001 RDI: 00007fe068086000
Dec  3 14:18:55 supermicro kernel: [693860.204619] RBP: 00007fe068086000 R08: 00007fe06b64b5c8 R09: 0000000000000001
Dec  3 14:18:55 supermicro kernel: [693860.204951] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
Dec  3 14:18:55 supermicro kernel: [693860.205286] R13: 000000000000000b R14: 00007fe06b649fc0 R15: 00007fe058250e50
Dec  3 14:18:55 supermicro kernel: [693860.205623] INFO: task qemu-system-x86:18754 blocked for more than 120 seconds.
Dec  3 14:18:55 supermicro kernel: [693860.205933]       Not tainted 4.19.0-6-amd64 #1 Debian 4.19.67-2+deb10u2
Dec  3 14:18:55 supermicro kernel: [693860.206238] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec  3 14:18:55 supermicro kernel: [693860.206555] qemu-system-x86 D    0 18754      1 0x00000000
Dec  3 14:18:55 supermicro kernel: [693860.206879] Call Trace:
Dec  3 14:18:55 supermicro kernel: [693860.207194]  ? __schedule+0x2a2/0x870
Dec  3 14:18:55 supermicro kernel: [693860.207533]  ? blk_flush_plug_list+0xcf/0x240
Dec  3 14:18:55 supermicro kernel: [693860.207848]  schedule+0x28/0x80
Dec  3 14:18:55 supermicro kernel: [693860.208156]  md_write_start+0x14b/0x220 [md_mod]
Dec  3 14:18:55 supermicro kernel: [693860.208464]  ? finish_wait+0x80/0x80
Dec  3 14:18:55 supermicro kernel: [693860.208780]  ? finish_wait+0x80/0x80
Dec  3 14:18:55 supermicro kernel: [693860.209077]  raid5_make_request+0x83/0xb60 [raid456]
Dec  3 14:18:55 supermicro kernel: [693860.209376]  ? try_to_wake_up+0x54/0x490
Dec  3 14:18:55 supermicro kernel: [693860.209672]  ? kmem_cache_alloc+0x192/0x1c0
Dec  3 14:18:55 supermicro kernel: [693860.209974]  ? finish_wait+0x80/0x80
Dec  3 14:18:55 supermicro kernel: [693860.210296]  ? finish_wait+0x80/0x80
Dec  3 14:18:55 supermicro kernel: [693860.210600]  md_handle_request+0x119/0x190 [md_mod]
Dec  3 14:18:55 supermicro kernel: [693860.210908]  md_make_request+0x78/0x160 [md_mod]
Dec  3 14:18:55 supermicro kernel: [693860.211229]  generic_make_request+0x1a4/0x400
Dec  3 14:18:55 supermicro kernel: [693860.211558]  submit_bio+0x45/0x140
Dec  3 14:18:55 supermicro kernel: [693860.211867]  blkdev_direct_IO+0x3b2/0x3f0
Dec  3 14:18:55 supermicro kernel: [693860.212175]  ? aio_fsync_work+0x90/0x90
Dec  3 14:18:55 supermicro kernel: [693860.212493]  generic_file_direct_write+0x96/0x160
Dec  3 14:18:55 supermicro kernel: [693860.212794]  __generic_file_write_iter+0xb7/0x1c0
Dec  3 14:18:55 supermicro kernel: [693860.213096]  blkdev_write_iter+0xa0/0x120
Dec  3 14:18:55 supermicro kernel: [693860.213399]  ? common_file_perm+0x5b/0xf0
Dec  3 14:18:55 supermicro kernel: [693860.213699]  aio_write+0x119/0x1a0
Dec  3 14:18:55 supermicro kernel: [693860.213999]  ? ttwu_do_wakeup+0x19/0x140
Dec  3 14:18:55 supermicro kernel: [693860.214361]  ? kvm_arch_set_irq_inatomic+0x92/0xb0 [kvm]
Dec  3 14:18:55 supermicro kernel: [693860.214704]  ? kmem_cache_alloc+0x170/0x1c0
Dec  3 14:18:55 supermicro kernel: [693860.215046]  io_submit_one+0x5b3/0x7c0
Dec  3 14:18:55 supermicro kernel: [693860.215400]  ? __wake_up_common+0x7a/0x190
Dec  3 14:18:55 supermicro kernel: [693860.215717]  __x64_sys_io_submit+0xa2/0x180
Dec  3 14:18:55 supermicro kernel: [693860.216034]  ? ksys_write+0xb7/0xd0
Dec  3 14:18:55 supermicro kernel: [693860.216350]  do_syscall_64+0x53/0x110
Dec  3 14:18:55 supermicro kernel: [693860.216673]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
Dec  3 14:18:55 supermicro kernel: [693860.216982] RIP: 0033:0x7fe06dea5f59
Dec  3 14:18:55 supermicro kernel: [693860.217291] Code: Bad RIP value.
Dec  3 14:18:55 supermicro kernel: [693860.217598] RSP: 002b:00007fe06ae48f58 EFLAGS: 00000246 ORIG_RAX: 00000000000000d1
Dec  3 14:18:55 supermicro kernel: [693860.217918] RAX: ffffffffffffffda RBX: 00007fe06ae4a290 RCX: 00007fe06dea5f59
Dec  3 14:18:55 supermicro kernel: [693860.218240] RDX: 00007fe06ae48fa0 RSI: 0000000000000050 RDI: 00007fe068081000
Dec  3 14:18:55 supermicro kernel: [693860.218566] RBP: 00007fe068081000 R08: 00007fe06ae4a5c8 R09: 0000000000000050
Dec  3 14:18:55 supermicro kernel: [693860.218886] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000050
Dec  3 14:18:55 supermicro kernel: [693860.219201] R13: 000000000000000b R14: 00007fe06ae48fa0 R15: 000276dadbe7948f
Dec  3 14:18:55 supermicro kernel: [693860.219553] INFO: task md4_resync:60178 blocked for more than 120 seconds.
Dec  3 14:18:55 supermicro kernel: [693860.219880]       Not tainted 4.19.0-6-amd64 #1 Debian 4.19.67-2+deb10u2
Dec  3 14:18:55 supermicro kernel: [693860.220210] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec  3 14:18:55 supermicro kernel: [693860.220548] md4_resync      D    0 60178      2 0x80000000
Dec  3 14:18:55 supermicro kernel: [693860.220884] Call Trace:
Dec  3 14:18:55 supermicro kernel: [693860.221223]  ? __schedule+0x2a2/0x870
Dec  3 14:18:55 supermicro kernel: [693860.221536]  schedule+0x28/0x80
Dec  3 14:18:55 supermicro kernel: [693860.221842]  md_do_sync.cold.86+0x7e8/0x911 [md_mod]
Dec  3 14:18:55 supermicro kernel: [693860.222151]  ? finish_wait+0x80/0x80
Dec  3 14:18:55 supermicro kernel: [693860.222459]  ? __switch_to_asm+0x35/0x70
Dec  3 14:18:55 supermicro kernel: [693860.222769]  ? md_rdev_init+0xb0/0xb0 [md_mod]
Dec  3 14:18:55 supermicro kernel: [693860.223078]  md_thread+0x94/0x150 [md_mod]
Dec  3 14:18:55 supermicro kernel: [693860.223412]  kthread+0x112/0x130
Dec  3 14:18:55 supermicro kernel: [693860.223733]  ? kthread_bind+0x30/0x30
Dec  3 14:18:55 supermicro kernel: [693860.224052]  ret_from_fork+0x35/0x40
Dec  3 14:18:55 supermicro kernel: [693860.224406] INFO: task kworker/u145:1:12075 blocked for more than 120 seconds.
Dec  3 14:18:55 supermicro kernel: [693860.224762]       Not tainted 4.19.0-6-amd64 #1 Debian 4.19.67-2+deb10u2
Dec  3 14:18:55 supermicro kernel: [693860.225123] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec  3 14:18:55 supermicro kernel: [693860.225504] kworker/u145:1  D    0 12075      2 0x80000000
Dec  3 14:18:55 supermicro kernel: [693860.225845] Workqueue: raid5wq raid5_do_work [raid456]
Dec  3 14:18:55 supermicro kernel: [693860.226182] Call Trace:
Dec  3 14:18:55 supermicro kernel: [693860.226516]  ? __schedule+0x2a2/0x870
Dec  3 14:18:55 supermicro kernel: [693860.226850]  schedule+0x28/0x80
Dec  3 14:18:55 supermicro kernel: [693860.227183]  raid5_do_work+0xe7/0x1d0 [raid456]
Dec  3 14:18:55 supermicro kernel: [693860.227550]  ? __switch_to_asm+0x41/0x70
Dec  3 14:18:55 supermicro kernel: [693860.227896]  ? finish_wait+0x80/0x80
Dec  3 14:18:55 supermicro kernel: [693860.228240]  process_one_work+0x1a7/0x3a0
Dec  3 14:18:55 supermicro kernel: [693860.228585]  worker_thread+0x30/0x390
Dec  3 14:18:55 supermicro kernel: [693860.228930]  ? create_worker+0x1a0/0x1a0
Dec  3 14:18:55 supermicro kernel: [693860.229262]  kthread+0x112/0x130
Dec  3 14:18:55 supermicro kernel: [693860.229593]  ? kthread_bind+0x30/0x30
Dec  3 14:18:55 supermicro kernel: [693860.229925]  ret_from_fork+0x35/0x40
Dec  3 14:18:55 supermicro kernel: [693860.230280] INFO: task kworker/u145:5:26258 blocked for more than 120 seconds.
Dec  3 14:18:55 supermicro kernel: [693860.230628]       Not tainted 4.19.0-6-amd64 #1 Debian 4.19.67-2+deb10u2
Dec  3 14:18:55 supermicro kernel: [693860.230980] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec  3 14:18:55 supermicro kernel: [693860.231343] kworker/u145:5  D    0 26258      2 0x80000000
Dec  3 14:18:55 supermicro kernel: [693860.231710] Workqueue: raid5wq raid5_do_work [raid456]
Dec  3 14:18:55 supermicro kernel: [693860.232075] Call Trace:
Dec  3 14:18:55 supermicro kernel: [693860.232440]  ? __schedule+0x2a2/0x870
Dec  3 14:18:55 supermicro kernel: [693860.232806]  schedule+0x28/0x80
Dec  3 14:18:55 supermicro kernel: [693860.233157]  raid5_do_work+0xe7/0x1d0 [raid456]
Dec  3 14:18:55 supermicro kernel: [693860.233511]  ? __switch_to_asm+0x41/0x70
Dec  3 14:18:55 supermicro kernel: [693860.233858]  ? finish_wait+0x80/0x80
Dec  3 14:18:55 supermicro kernel: [693860.234199]  process_one_work+0x1a7/0x3a0
Dec  3 14:18:55 supermicro kernel: [693860.234604]  worker_thread+0x30/0x390
Dec  3 14:18:55 supermicro kernel: [693860.234985]  ? create_worker+0x1a0/0x1a0
Dec  3 14:18:55 supermicro kernel: [693860.235381]  kthread+0x112/0x130
Dec  3 14:18:55 supermicro kernel: [693860.235726]  ? kthread_bind+0x30/0x30
Dec  3 14:18:55 supermicro kernel: [693860.236066]  ret_from_fork+0x35/0x40
Dec  3 14:18:55 supermicro kernel: [693860.236408] INFO: task kworker/u145:8:42676 blocked for more than 120 seconds.
Dec  3 14:18:55 supermicro kernel: [693860.236751]       Not tainted 4.19.0-6-amd64 #1 Debian 4.19.67-2+deb10u2
Dec  3 14:18:55 supermicro kernel: [693860.237077] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec  3 14:18:55 supermicro kernel: [693860.237410] kworker/u145:8  D    0 42676      2 0x80000000
Dec  3 14:18:55 supermicro kernel: [693860.237749] Workqueue: raid5wq raid5_do_work [raid456]
Dec  3 14:18:55 supermicro kernel: [693860.238088] Call Trace:
Dec  3 14:18:55 supermicro kernel: [693860.238424]  ? __schedule+0x2a2/0x870
Dec  3 14:18:55 supermicro kernel: [693860.238760]  schedule+0x28/0x80
Dec  3 14:18:55 supermicro kernel: [693860.239096]  raid5_do_work+0xe7/0x1d0 [raid456]
Dec  3 14:18:55 supermicro kernel: [693860.239459]  ? __switch_to_asm+0x41/0x70
Dec  3 14:18:55 supermicro kernel: [693860.239806]  ? finish_wait+0x80/0x80
Dec  3 14:18:55 supermicro kernel: [693860.240152]  process_one_work+0x1a7/0x3a0
Dec  3 14:18:55 supermicro kernel: [693860.240499]  worker_thread+0x30/0x390
Dec  3 14:18:55 supermicro kernel: [693860.240846]  ? create_worker+0x1a0/0x1a0
Dec  3 14:18:55 supermicro kernel: [693860.241199]  kthread+0x112/0x130
Dec  3 14:18:55 supermicro kernel: [693860.241524]  ? kthread_bind+0x30/0x30
Dec  3 14:18:55 supermicro kernel: [693860.241842]  ret_from_fork+0x35/0x40
Dec  3 14:18:55 supermicro kernel: [693860.242191] INFO: task kworker/u145:13:61325 blocked for more than 120 seconds.
Dec  3 14:18:55 supermicro kernel: [693860.242512]       Not tainted 4.19.0-6-amd64 #1 Debian 4.19.67-2+deb10u2
Dec  3 14:18:55 supermicro kernel: [693860.242833] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec  3 14:18:55 supermicro kernel: [693860.243164] kworker/u145:13 D    0 61325      2 0x80000000
Dec  3 14:18:55 supermicro kernel: [693860.243528] Workqueue: raid5wq raid5_do_work [raid456]
Dec  3 14:18:55 supermicro kernel: [693860.243874] Call Trace:
Dec  3 14:18:55 supermicro kernel: [693860.244221]  ? __schedule+0x2a2/0x870
Dec  3 14:18:55 supermicro kernel: [693860.244630]  schedule+0x28/0x80
Dec  3 14:18:55 supermicro kernel: [693860.245020]  raid5_do_work+0xe7/0x1d0 [raid456]
Dec  3 14:18:55 supermicro kernel: [693860.245408]  ? __switch_to_asm+0x41/0x70
Dec  3 14:18:55 supermicro kernel: [693860.245745]  ? finish_wait+0x80/0x80
Dec  3 14:18:55 supermicro kernel: [693860.246080]  process_one_work+0x1a7/0x3a0
Dec  3 14:18:55 supermicro kernel: [693860.246443]  worker_thread+0x30/0x390
Dec  3 14:18:55 supermicro kernel: [693860.246791]  ? create_worker+0x1a0/0x1a0
Dec  3 14:18:55 supermicro kernel: [693860.247132]  kthread+0x112/0x130
Dec  3 14:18:55 supermicro kernel: [693860.247471]  ? kthread_bind+0x30/0x30
Dec  3 14:18:55 supermicro kernel: [693860.247800]  ret_from_fork+0x35/0x40
Dec  3 14:18:55 supermicro kernel: [693860.248128] INFO: task mdadm-checkarra:62221 blocked for more than 120 seconds.
Dec  3 14:18:55 supermicro kernel: [693860.248457]       Not tainted 4.19.0-6-amd64 #1 Debian 4.19.67-2+deb10u2
Dec  3 14:18:55 supermicro kernel: [693860.248794] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec  3 14:18:55 supermicro kernel: [693860.249125] mdadm-checkarra D    0 62221  61335 0x00000000
Dec  3 14:18:55 supermicro kernel: [693860.249459] Call Trace:
Dec  3 14:18:55 supermicro kernel: [693860.249790]  ? __schedule+0x2a2/0x870
Dec  3 14:18:55 supermicro kernel: [693860.250141]  schedule+0x28/0x80
Dec  3 14:18:55 supermicro kernel: [693860.250481]  schedule_timeout+0x26d/0x390
Dec  3 14:18:55 supermicro kernel: [693860.250822]  ? complete+0x3b/0x50
Dec  3 14:18:55 supermicro kernel: [693860.251161]  wait_for_completion+0x11f/0x190
Dec  3 14:18:55 supermicro kernel: [693860.251534]  ? wake_up_q+0x70/0x70
Dec  3 14:18:55 supermicro kernel: [693860.251884]  kthread_stop+0x42/0xf0
Dec  3 14:18:55 supermicro kernel: [693860.252229]  md_unregister_thread+0x60/0x70 [md_mod]
Dec  3 14:18:55 supermicro kernel: [693860.252578]  md_reap_sync_thread+0x15/0x170 [md_mod]
Dec  3 14:18:55 supermicro kernel: [693860.252925]  action_store+0x142/0x2a0 [md_mod]
Dec  3 14:18:55 supermicro kernel: [693860.253252]  md_attr_store+0x7c/0xc0 [md_mod]
Dec  3 14:18:55 supermicro kernel: [693860.253573]  kernfs_fop_write+0x116/0x190
Dec  3 14:18:55 supermicro kernel: [693860.253886]  vfs_write+0xa5/0x1a0
Dec  3 14:18:55 supermicro kernel: [693860.254195]  ksys_write+0x57/0xd0
Dec  3 14:18:55 supermicro kernel: [693860.254560]  do_syscall_64+0x53/0x110
Dec  3 14:18:55 supermicro kernel: [693860.254906]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
Dec  3 14:18:55 supermicro kernel: [693860.255260] RIP: 0033:0x7fea75a86504
Dec  3 14:18:55 supermicro kernel: [693860.255623] Code: Bad RIP value.
Dec  3 14:18:55 supermicro kernel: [693860.255938] RSP: 002b:00007ffc9b9594f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
Dec  3 14:18:55 supermicro kernel: [693860.256268] RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 00007fea75a86504
Dec  3 14:18:55 supermicro kernel: [693860.256607] RDX: 0000000000000005 RSI: 0000562beab4c2c0 RDI: 0000000000000001
Dec  3 14:18:55 supermicro kernel: [693860.256934] RBP: 0000562beab4c2c0 R08: 000000000000000a R09: 00007fea75b16e80
Dec  3 14:18:55 supermicro kernel: [693860.257264] R10: 000000000000000a R11: 0000000000000246 R12: 00007fea75b58760
Dec  3 14:18:55 supermicro kernel: [693860.257594] R13: 0000000000000005 R14: 00007fea75b53760 R15: 0000000000000005
Dec  3 14:20:56 supermicro kernel: [693981.028816] INFO: task qemu-system-x86:18753 blocked for more than 120 seconds.
Dec  3 14:20:56 supermicro kernel: [693981.029818]       Not tainted 4.19.0-6-amd64 #1 Debian 4.19.67-2+deb10u2
Dec  3 14:20:56 supermicro kernel: [693981.030228] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec  3 14:20:56 supermicro kernel: [693981.030610] qemu-system-x86 D    0 18753      1 0x00000000
Dec  3 14:20:56 supermicro kernel: [693981.030950] Call Trace:
Dec  3 14:20:56 supermicro kernel: [693981.031286]  ? __schedule+0x2a2/0x870
Dec  3 14:20:56 supermicro kernel: [693981.031597]  schedule+0x28/0x80
Dec  3 14:20:56 supermicro kernel: [693981.031937]  md_write_start+0x14b/0x220 [md_mod]
Dec  3 14:20:56 supermicro kernel: [693981.032274]  ? finish_wait+0x80/0x80
Dec  3 14:20:56 supermicro kernel: [693981.032584]  ? finish_wait+0x80/0x80
Dec  3 14:20:56 supermicro kernel: [693981.032928]  raid5_make_request+0x83/0xb60 [raid456]
Dec  3 14:20:56 supermicro kernel: [693981.033280]  ? try_to_wake_up+0x54/0x490
Dec  3 14:20:56 supermicro kernel: [693981.033615]  ? kmem_cache_alloc+0x37/0x1c0
Dec  3 14:20:56 supermicro kernel: [693981.033950]  ? finish_wait+0x80/0x80
Dec  3 14:20:56 supermicro kernel: [693981.034290]  ? finish_wait+0x80/0x80
Dec  3 14:20:56 supermicro kernel: [693981.034615]  md_handle_request+0x119/0x190 [md_mod]
Dec  3 14:20:56 supermicro kernel: [693981.034941]  md_make_request+0x78/0x160 [md_mod]
Dec  3 14:20:56 supermicro kernel: [693981.035269]  generic_make_request+0x1a4/0x400
Dec  3 14:20:56 supermicro kernel: [693981.035611]  submit_bio+0x45/0x140
Dec  3 14:20:56 supermicro kernel: [693981.035932]  blkdev_direct_IO+0x3b2/0x3f0
Dec  3 14:20:56 supermicro kernel: [693981.036248]  ? aio_fsync_work+0x90/0x90
Dec  3 14:20:56 supermicro kernel: [693981.036558]  generic_file_direct_write+0x96/0x160
Dec  3 14:20:56 supermicro kernel: [693981.036892]  __generic_file_write_iter+0xb7/0x1c0
Dec  3 14:20:56 supermicro kernel: [693981.037205]  blkdev_write_iter+0xa0/0x120
Dec  3 14:20:56 supermicro kernel: [693981.037519]  ? common_file_perm+0x5b/0xf0
Dec  3 14:20:56 supermicro kernel: [693981.037832]  aio_write+0x119/0x1a0
Dec  3 14:20:56 supermicro kernel: [693981.038154]  ? io_submit_one+0x90/0x7c0
Dec  3 14:20:56 supermicro kernel: [693981.038458]  ? io_submit_one+0x90/0x7c0
Dec  3 14:20:56 supermicro kernel: [693981.038758]  ? kmem_cache_alloc+0x192/0x1c0
Dec  3 14:20:56 supermicro kernel: [693981.039057]  io_submit_one+0x5b3/0x7c0
Dec  3 14:20:56 supermicro kernel: [693981.039357]  ? __wake_up_common+0x7a/0x190
Dec  3 14:20:56 supermicro kernel: [693981.039657]  __x64_sys_io_submit+0xa2/0x180
Dec  3 14:20:56 supermicro kernel: [693981.040011]  ? ksys_read+0xb7/0xd0
Dec  3 14:20:56 supermicro kernel: [693981.040348]  do_syscall_64+0x53/0x110
Dec  3 14:20:56 supermicro kernel: [693981.040687]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
Dec  3 14:20:56 supermicro kernel: [693981.041026] RIP: 0033:0x7fe06dea5f59
Dec  3 14:20:56 supermicro kernel: [693981.041336] Code: Bad RIP value.
Dec  3 14:20:56 supermicro kernel: [693981.041644] RSP: 002b:00007fe06b649f78 EFLAGS: 00000246 ORIG_RAX: 00000000000000d1
Dec  3 14:20:56 supermicro kernel: [693981.041972] RAX: ffffffffffffffda RBX: 00007fe06b64b290 RCX: 00007fe06dea5f59
Dec  3 14:20:56 supermicro kernel: [693981.042289] RDX: 00007fe06b649fc0 RSI: 0000000000000001 RDI: 00007fe068086000
Dec  3 14:20:56 supermicro kernel: [693981.042606] RBP: 00007fe068086000 R08: 00007fe06b64b5c8 R09: 0000000000000001
Dec  3 14:20:56 supermicro kernel: [693981.042925] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
Dec  3 14:20:56 supermicro kernel: [693981.043238] R13: 000000000000000b R14: 00007fe06b649fc0 R15: 00007fe058250e50
Dec  3 14:20:56 supermicro kernel: [693981.043549] INFO: task qemu-system-x86:18754 blocked for more than 120 seconds.
Dec  3 14:20:56 supermicro kernel: [693981.043859]       Not tainted 4.19.0-6-amd64 #1 Debian 4.19.67-2+deb10u2
Dec  3 14:20:56 supermicro kernel: [693981.044172] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec  3 14:20:56 supermicro kernel: [693981.044508] qemu-system-x86 D    0 18754      1 0x00000000
Dec  3 14:20:56 supermicro kernel: [693981.044856] Call Trace:
Dec  3 14:20:56 supermicro kernel: [693981.045187]  ? __schedule+0x2a2/0x870
Dec  3 14:20:56 supermicro kernel: [693981.045516]  ? blk_flush_plug_list+0xcf/0x240
Dec  3 14:20:56 supermicro kernel: [693981.045829]  schedule+0x28/0x80
Dec  3 14:20:56 supermicro kernel: [693981.046147]  md_write_start+0x14b/0x220 [md_mod]
Dec  3 14:20:56 supermicro kernel: [693981.046446]  ? finish_wait+0x80/0x80
Dec  3 14:20:56 supermicro kernel: [693981.046744]  ? finish_wait+0x80/0x80
Dec  3 14:20:56 supermicro kernel: [693981.047040]  raid5_make_request+0x83/0xb60 [raid456]
Dec  3 14:20:56 supermicro kernel: [693981.047339]  ? try_to_wake_up+0x54/0x490
Dec  3 14:20:56 supermicro kernel: [693981.047635]  ? kmem_cache_alloc+0x192/0x1c0
Dec  3 14:20:56 supermicro kernel: [693981.047936]  ? finish_wait+0x80/0x80
Dec  3 14:20:56 supermicro kernel: [693981.048235]  ? finish_wait+0x80/0x80
Dec  3 14:20:56 supermicro kernel: [693981.048529]  md_handle_request+0x119/0x190 [md_mod]
Dec  3 14:20:56 supermicro kernel: [693981.048854]  md_make_request+0x78/0x160 [md_mod]
Dec  3 14:20:56 supermicro kernel: [693981.049161]  generic_make_request+0x1a4/0x400
Dec  3 14:20:56 supermicro kernel: [693981.049473]  submit_bio+0x45/0x140
Dec  3 14:20:56 supermicro kernel: [693981.049808]  blkdev_direct_IO+0x3b2/0x3f0
Dec  3 14:20:56 supermicro kernel: [693981.050147]  ? aio_fsync_work+0x90/0x90
Dec  3 14:20:56 supermicro kernel: [693981.050485]  generic_file_direct_write+0x96/0x160
Dec  3 14:20:56 supermicro kernel: [693981.050838]  __generic_file_write_iter+0xb7/0x1c0
Dec  3 14:20:56 supermicro kernel: [693981.051139]  blkdev_write_iter+0xa0/0x120
Dec  3 14:20:56 supermicro kernel: [693981.051441]  ? common_file_perm+0x5b/0xf0
Dec  3 14:20:56 supermicro kernel: [693981.051742]  aio_write+0x119/0x1a0
Dec  3 14:20:56 supermicro kernel: [693981.052041]  ? ttwu_do_wakeup+0x19/0x140
Dec  3 14:20:56 supermicro kernel: [693981.052367]  ? kvm_arch_set_irq_inatomic+0x92/0xb0 [kvm]
Dec  3 14:20:56 supermicro kernel: [693981.052690]  ? kmem_cache_alloc+0x170/0x1c0
Dec  3 14:20:56 supermicro kernel: [693981.053001]  io_submit_one+0x5b3/0x7c0
Dec  3 14:20:56 supermicro kernel: [693981.053313]  ? __wake_up_common+0x7a/0x190
Dec  3 14:20:56 supermicro kernel: [693981.053630]  __x64_sys_io_submit+0xa2/0x180
Dec  3 14:20:56 supermicro kernel: [693981.053957]  ? ksys_write+0xb7/0xd0
Dec  3 14:20:56 supermicro kernel: [693981.054264]  do_syscall_64+0x53/0x110
Dec  3 14:20:56 supermicro kernel: [693981.054570]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
Dec  3 14:20:56 supermicro kernel: [693981.054881] RIP: 0033:0x7fe06dea5f59
Dec  3 14:20:56 supermicro kernel: [693981.055191] Code: Bad RIP value.
Dec  3 14:20:56 supermicro kernel: [693981.055507] RSP: 002b:00007fe06ae48f58 EFLAGS: 00000246 ORIG_RAX: 00000000000000d1
Dec  3 14:20:56 supermicro kernel: [693981.055828] RAX: ffffffffffffffda RBX: 00007fe06ae4a290 RCX: 00007fe06dea5f59
Dec  3 14:20:56 supermicro kernel: [693981.056151] RDX: 00007fe06ae48fa0 RSI: 0000000000000050 RDI: 00007fe068081000
Dec  3 14:20:56 supermicro kernel: [693981.056477] RBP: 00007fe068081000 R08: 00007fe06ae4a5c8 R09: 0000000000000050
Dec  3 14:20:56 supermicro kernel: [693981.056804] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000050
Dec  3 14:20:56 supermicro kernel: [693981.057146] R13: 000000000000000b R14: 00007fe06ae48fa0 R15: 000276dadbe7948f

--------------3A225A30193F7C0351014E22--
