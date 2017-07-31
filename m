From: Simon Kirby <sim@hostway.ca>
Subject: raid1 lockups on 4.12.x
Date: Mon, 31 Jul 2017 11:36:16 -0700
Message-ID: <20170731183616.GD22429@hostway.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I recently upgraded two old boxes to 4.12.3 only to find that they
started to lock up several times per day. I upgraded to 4.12.4 and the
problem persisted. Downgrading to 4.11.11 seems to have stopped the
issue.

I captured the following with nmi_watchdog=1 and a serial console while
on 4.12.4.

[ 9672.236351] NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [md2_raid1:1704]
[ 9672.236351] Modules linked in: nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack serio_raw evdev e1000
[ 9672.236351] CPU: 0 PID: 1704 Comm: md2_raid1 Not tainted 4.12.4-hw #6
[ 9672.236351] Hardware name: Dell Computer Corporation PowerEdge 750              /0R1479, BIOS A03 10/22/2004
[ 9672.236351] task: f4a1a100 task.stack: f47fa000
[ 9672.236351] EIP: md_check_recovery+0x2d4/0x460 
[ 9672.236351] EFLAGS: 00000246 CPU: 0
[ 9672.236351] EAX: 00000000 EBX: f448ec00 ECX: 00000001 EDX: 00000000
[ 9672.236351] ESI: 00000000 EDI: 00000000 EBP: f47fbe38 ESP: f47fbe28
[ 9672.236351]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[ 9672.236351] CR0: 80050033 CR2: b77c0000 CR3: 31501000 CR4: 000006d0
[ 9672.236351] Call Trace:
[ 9672.236351]  raid1d+0x27/0x16f0
[ 9672.236351]  ? ktime_get+0x44/0x100
[ 9672.236351]  ? lapic_next_event+0x13/0x20
[ 9672.236351]  ? clockevents_program_event+0x9d/0x150
[ 9672.236351]  ? __hrtimer_run_queues+0x13a/0x210
[ 9672.236351]  ? hrtimer_interrupt+0xb0/0x190
[ 9672.236351]  ? smp_apic_timer_interrupt+0x33/0x40
[ 9672.236351]  ? apic_timer_interrupt+0x32/0x38
[ 9672.236351]  ? perf_trace_thermal_power_cpu_limit+0x68/0x120
[ 9672.344374]  md_thread+0x116/0x140
[ 9672.344374]  ? do_wait_intr+0x70/0x70
[ 9672.344374]  kthread+0xe3/0x110
[ 9672.344374]  ? md_register_thread+0xc0/0xc0
[ 9672.344374]  ? __kthread_init_worker+0x90/0x90
[ 9672.344374]  ret_from_fork+0x19/0x24
[ 9672.344374] Code: 68 01 00 00 ef f0 0f ba b3 68 01 00 00 05 72 47 8b b3 08 01 00 00 85 f6 0f 85 d9 fe ff ff f0 80 a3 68 01 00 00 fe b9 01 00 00 00 <ba> 03 00 00 00 c7 04 24 00 00 00 00 b8 c0 a8 bc c1 e8 86 d9 97

later, there were (looping) backtraces such as:

[34552.236353] NMI watchdog: BUG: soft lockup - CPU#0 stuck for 23s! [md0_raid1:1684]
[34552.236353] Modules linked in: nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack serio_raw evdev e1000
[34552.236353] CPU: 0 PID: 1684 Comm: md0_raid1 Tainted: G             L  4.12.4-hw #6
[34552.236353] Hardware name: Dell Computer Corporation PowerEdge 750              /0R1479, BIOS A03 10/22/2004
[34552.236353] task: f4a95280 task.stack: f52c0000
[34552.236353] EIP: _raw_spin_unlock_irqrestore+0xa/0x10
[34552.236353] EFLAGS: 00000292 CPU: 0
[34552.236353] EAX: 00000292 EBX: f46a3d08 ECX: 00000001 EDX: 00000292
[34552.236353] ESI: 00000292 EDI: 00000003 EBP: f52c1de4 ESP: f52c1de4
[34552.236353]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[34552.236353] CR0: 80050033 CR2: 08062e00 CR3: 347af000 CR4: 000006d0
[34552.236353] Call Trace:
[34552.236353]  __wake_up+0x40/0x50
[34552.236353]  md_wakeup_thread+0x2b/0x30
[34552.236353]  mddev_unlock+0x74/0xc0
[34552.236353]  md_check_recovery+0x1c3/0x460
[34552.324380]  raid1d+0x27/0x16f0
[34552.324380]  ? ktime_get+0x44/0x100
[34552.324380]  ? lapic_next_event+0x13/0x20
[34552.324380]  ? clockevents_program_event+0x9d/0x150
[34552.324380]  ? __hrtimer_run_queues+0x13a/0x210
[34552.344366]  ? smp_apic_timer_interrupt+0x33/0x40
[34552.344366]  ? apic_timer_interrupt+0x32/0x38
[34552.344366]  ? perf_trace_thermal_power_cpu_limit+0xb/0x120
[34552.344366]  md_thread+0x116/0x140
[34552.344366]  ? do_wait_intr+0x70/0x70
[34552.344366]  kthread+0xe3/0x110
[34552.344366]  ? md_register_thread+0xc0/0xc0
[34552.344366]  ? __kthread_init_worker+0x90/0x90
[34552.344366]  ret_from_fork+0x19/0x24
[34552.344366] Code: 00 f0 0f b1 0a 85 c0 75 08 b0 01 5d c3 8d 74 26 00 31 c0 5d c3 8d b6 00 00 00 00 8d bf 00 00 00 00 55 89 e5 c6 00 00 89 d0 50 9d <8d> 74 26 00 5d c3 55 89 c1 89 e5 b8 00 ff ff ff f0 0f c1 01 89
[34567.020353] INFO: rcu_sched self-detected stall on CPU
[34567.020361]  0-...: (104347 ticks this GP) idle=d52/140000000000001/0 softirq=615378/615378 fqs=52025
[34567.020361]   (t=105006 jiffies g=349461 c=349460 q=85)
[34567.020361] NMI backtrace for cpu 0
[34567.020361] CPU: 0 PID: 1684 Comm: md0_raid1 Tainted: G             L  4.12.4-hw #6
[34567.020361] Hardware name: Dell Computer Corporation PowerEdge 750              /0R1479, BIOS A03 10/22/2004
[34567.020361] Call Trace:
[34567.020361]  dump_stack+0x58/0x78
[34567.020361]  nmi_cpu_backtrace+0xa6/0xb0
[34567.020361]  nmi_trigger_cpumask_backtrace+0x92/0xd0
[34567.020361]  ? irq_force_complete_move+0xd0/0xd0
[34567.020361]  arch_trigger_cpumask_backtrace+0x10/0x20
[34567.020361]  rcu_dump_cpu_stacks+0x64/0xa7
[34567.020361]  rcu_check_callbacks+0x6af/0x710
[34567.020361]  ? account_process_tick+0x54/0x130
[34567.020361]  update_process_times+0x2a/0x60   
[34567.020361]  tick_sched_handle.isra.11+0x30/0x60
[34567.020361]  tick_sched_timer+0x3b/0x80
[34567.020361]  __hrtimer_run_queues+0xb0/0x210
[34567.020361]  ? tick_nohz_handler+0xa0/0xa0  
[34567.020361]  hrtimer_interrupt+0x95/0x190   
[34567.020361]  local_apic_timer_interrupt+0x2a/0x50
[34567.020361]  smp_apic_timer_interrupt+0x2e/0x40  
[34567.020361]  apic_timer_interrupt+0x32/0x38
[34567.020361] EIP: _raw_spin_unlock_irqrestore+0xa/0x10
[34567.020361] EFLAGS: 00000292 CPU: 0
[34567.020361] EAX: 00000292 EBX: f448e5f0 ECX: 00000001 EDX: 00000292
[34567.020361] ESI: 00000292 EDI: 00000003 EBP: f52c1e00 ESP: f52c1e00
[34567.020361]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[34567.020361]  __wake_up+0x40/0x50
[34567.020361]  md_check_recovery+0x1bc/0x460
[34567.020361]  raid1d+0x27/0x16f0
[34567.020361]  ? ktime_get+0x44/0x100
[34567.020361]  ? lapic_next_event+0x13/0x20
[34567.020361]  ? clockevents_program_event+0x9d/0x150
[34567.020361]  ? __hrtimer_run_queues+0x13a/0x210
[34567.020361]  ? hrtimer_interrupt+0xb0/0x190
[34567.020361]  ? hrtimer_interrupt+0xb0/0x190
[34567.020361]  ? smp_apic_timer_interrupt+0x33/0x40
[34567.020361]  ? apic_timer_interrupt+0x32/0x38
[34567.020361]  md_thread+0x116/0x140
[34567.020361]  ? do_wait_intr+0x70/0x70
[34567.020361]  kthread+0xe3/0x110
[34567.020361]  ? md_register_thread+0xc0/0xc0
[34567.020361]  ? __kthread_init_worker+0x90/0x90
[34567.020361]  ret_from_fork+0x19/0x24
[34592.236352] NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [md0_raid1:1684]
[34592.236352] Modules linked in: nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack serio_raw evdev e1000
[34592.236352] CPU: 0 PID: 1684 Comm: md0_raid1 Tainted: G             L  4.12.4-hw #6
[34592.236352] Hardware name: Dell Computer Corporation PowerEdge 750              /0R1479, BIOS A03 10/22/2004
[34592.236352] task: f4a95280 task.stack: f52c0000
[34592.236352] EIP: _raw_spin_unlock_irqrestore+0xa/0x10
[34592.236352] EFLAGS: 00000292 CPU: 0
[34592.236352] EAX: 00000292 EBX: c1bca8c0 ECX: 00000001 EDX: 00000292
[34592.236352] ESI: 00000292 EDI: 00000003 EBP: f52c1e00 ESP: f52c1e00
[34592.236352]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[34592.236352] CR0: 80050033 CR2: 08062e00 CR3: 347af000 CR4: 000006d0
[34592.236352] Call Trace:
[34592.236352]  __wake_up+0x40/0x50
[34592.236352]  md_check_recovery+0x2ea/0x460
[34592.236352]  raid1d+0x27/0x16f0
[34592.236352]  ? ktime_get+0x44/0x100
[34592.236352]  ? lapic_next_event+0x13/0x20
[34592.236352]  ? clockevents_program_event+0x9d/0x150
[34592.236352]  ? __hrtimer_run_queues+0x13a/0x210
[34592.236352]  ? tick_program_event+0x41/0x80
[34592.236352]  ? hrtimer_interrupt+0xb0/0x190
[34592.344366]  ? irq_exit+0x58/0xb0
[34592.344366]  ? smp_apic_timer_interrupt+0x33/0x40
[34592.344366]  ? apic_timer_interrupt+0x32/0x38
[34592.356384]  ? perf_trace_thermal_power_cpu_limit+0xb/0x120
[34592.356384]  md_thread+0x116/0x140
[34592.356384]  ? do_wait_intr+0x70/0x70
[34592.356384]  kthread+0xe3/0x110
[34592.356384]  ? md_register_thread+0xc0/0xc0
[34592.356384]  ? __kthread_init_worker+0x90/0x90
[34592.356384]  ret_from_fork+0x19/0x24
[34592.356384] Code: 00 f0 0f b1 0a 85 c0 75 08 b0 01 5d c3 8d 74 26 00 31 c0 5d c3 8d b6 00 00 00 00 8d bf 00 00 00 00 55 89 e5 c6 00 00 89 d0 50 9d <8d> 74 26 00 5d c3 55 89 c1 89 e5 b8 00 ff ff ff f0 0f c1 01 89 

Config here: http://0x.ca/sim/ref/4.12.4-32/config

Simon-
