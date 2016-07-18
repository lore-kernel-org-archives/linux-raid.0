From: Chien Lee <chienlee@qnap.com>
Subject: Raid1 rcu stall while I/O stress test
Date: Mon, 18 Jul 2016 17:58:28 +0800
Message-ID: <CAByoP06DYZNf=P4fJw2ay4cA53Zgvb6sLO68LxghMP7u2MM3Uw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, NeilBrown <neilb@suse.com>, shli@kernel.org, owner-linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,


Recently raid1 happen rcu stall when I do I/O stress test. The raid1
is not in resync/rebuild/reshape/degraded status at the same time.


The Kernel version is 3.19.8 and here is the call trace in the kernel log.


<3>[427882.025091] INFO: rcu_sched self-detected stall on CPU { 2}
(t=60000 jiffies g=23546697 c=23546696 q=316936)
<6>[427882.035342] Task dump for CPU 2:
<6>[427882.038694] kworker/u8:2 R running task 0 438 2 0x00000008
<6>[427882.045989] Workqueue: dm-thin do_worker [dm_thin_pool]
<4>[427882.051388] 0000000000000082 ffff88017fd03db8 ffffffff8107279c
0000000000000002
<4>[427882.059108] ffffffff81bde180 ffff88017fd03dd8 ffffffff8107280a
ffff88017fd03e58
<4>[427882.066836] 0000000000000003 ffff88017fd03e08 ffffffff8109bee9
ffff88017fd12040
<4>[427882.074568] Call Trace:
<4>[427882.077137] <IRQ> [<ffffffff8107279c>] sched_show_task+0xac/0xe0
<4>[427882.083510] [<ffffffff8107280a>] dump_cpu_task+0x3a/0x50
<4>[427882.089034] [<ffffffff8109bee9>] rcu_dump_cpu_stacks+0x89/0xe0
<4>[427882.095078] [<ffffffff8109d563>] rcu_check_callbacks+0x313/0x550
<4>[427882.101291] [<ffffffff810a02e2>] update_process_times+0x32/0x60
<4>[427882.107419] [<ffffffff810ae115>] tick_sched_handle+0x35/0x50
<4>[427882.113285] [<ffffffff810ae27f>] tick_sched_timer+0x3f/0x70
<4>[427882.119068] [<ffffffff810a0b0d>] __run_hrtimer+0x3d/0xc0
<4>[427882.124591] [<ffffffff810a1276>] hrtimer_interrupt+0xe6/0x230
<4>[427882.130549] [<ffffffff81057a1d>] ? __do_softirq+0x15d/0x220
<4>[427882.136333] [<ffffffff810326c4>] local_apic_timer_interrupt+0x34/0x70
<4>[427882.142982] [<ffffffff8103342c>] smp_apic_timer_interrupt+0x3c/0x60
<4>[427882.149458] [<ffffffff818bb06a>] apic_timer_interrupt+0x6a/0x70
<4>[427882.155586] <EOI> [<ffffffff810eacd7>] ? mempool_alloc+0x47/0x130
<4>[427882.162048] [<ffffffff81337097>] ? bio_clone_bioset+0x77/0x300
<4>[427882.168089] [<ffffffff810eacd7>] ? mempool_alloc+0x47/0x130
<4>[427882.173870] [<ffffffff816334da>] bio_clone_mddev+0x1a/0x30
<4>[427882.179566] [<ffffffff816176f8>] make_request+0x608/0xe90
<4>[427882.185173] [<ffffffff8133b915>] ?
generic_make_request_checks+0x125/0x2f0
<4>[427882.192254] [<ffffffff816362ae>] md_make_request+0x7e/0x260
<4>[427882.198037] [<ffffffff81645759>] ? dm_put_live_table+0x9/0x10
<4>[427882.203991] [<ffffffff81645ef9>] ? dm_request+0x99/0x110
<4>[427882.209511] [<ffffffff8133bb7e>] generic_make_request+0x9e/0xf0
<4>[427882.215652] [<ffffffffa0186bfd>] issue+0x3d/0xb0 [dm_thin_pool]
<4>[427882.221786] [<ffffffffa0186c97>] remap_and_issue+0x27/0x40 [dm_thin_pool]
<4>[427882.228787] [<ffffffffa0187378>]
inc_remap_and_issue_cell+0xb8/0xd0 [dm_thin_pool]
<4>[427882.236566] [<ffffffffa0186c97>] ? remap_and_issue+0x27/0x40
[dm_thin_pool]
<4>[427882.243740] [<ffffffffa01874bf>]
process_prepared_mapping+0x12f/0x140 [dm_thin_pool]
<4>[427882.251694] [<ffffffffa01875e5>] schedule_zero+0x115/0x160 [dm_thin_pool]
<4>[427882.258694] [<ffffffffa0188788>] process_cell+0x618/0x620 [dm_thin_pool]
<4>[427882.265603] [<ffffffff810eacd7>] ? mempool_alloc+0x47/0x130
<4>[427882.271388] [<ffffffff8137054a>] ? sort+0x13a/0x200
<4>[427882.276477] [<ffffffff813703e0>] ? u32_swap+0x10/0x10
<4>[427882.281743] [<ffffffffa0185860>] ?
dm_thin_volume_is_full+0x30/0x30 [dm_thin_pool]
<4>[427882.289527] [<ffffffffa0189f9f>] do_worker+0x2af/0x820 [dm_thin_pool]
<4>[427882.296198] [<ffffffff81066021>] ? pwq_activate_first_delayed+0x11/0x20
<4>[427882.303035] [<ffffffff81069403>] process_one_work+0x103/0x2f0
<4>[427882.309015] [<ffffffff81069a17>] worker_thread+0x117/0x390
<4>[427882.314729] [<ffffffff81069900>] ? rescuer_thread+0x2e0/0x2e0
<4>[427882.320683] [<ffffffff8106d85e>] kthread+0xde/0xf0
<4>[427882.325684] [<ffffffff8106d780>] ? kthreadd+0x150/0x150
<4>[427882.331120] [<ffffffff818ba1c8>] ret_from_fork+0x58/0x90
<4>[427882.336640] [<ffffffff8106d780>] ? kthreadd+0x150/0x150


Anyone can give me some advice or help.


Thanks,


-- 

Chien Lee
