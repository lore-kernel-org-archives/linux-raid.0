From: Shaohua Li <shli@kernel.org>
Subject: Re: [MD] Crash with 4.12+ kernel and high disk load -- bisected to
 4ad23a976413: MD: use per-cpu counter for writes_pending
Date: Mon, 7 Aug 2017 21:51:03 -0700
Message-ID: <20170808045103.xpi32xkjidjuxczq@kernel.org>
References: <ee7921d2-d3ff-2381-1f05-2c07b8001d08@unsolicited.net>
 <c2df7906-67b2-b33f-0e82-49e6ef53f5f1@unsolicited.net>
 <20170807112025.GA3094@light.dominikbrodowski.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170807112025.GA3094@light.dominikbrodowski.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: NeilBrown <neilb@suse.com>, Shaohua Li <shli@fb.com>, David R <david@unsolicited.net>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Aug 07, 2017 at 01:20:25PM +0200, Dominik Brodowski wrote:
> Neil, Shaohua,
> 
> following up on David R's bug message: I have observed something similar
> on v4.12.[345] and v4.13-rc4, but not on v4.11. This is a RAID1 (on bare
> metal partitions, /dev/sdaX and /dev/sdbY linked together). In case it
> matters: Further upwards are cryptsetup, a DM volume group, then logical
> volumes, and then filesystems (ext4, but also happened with xfs).
> 
> In a tedious bisect (the bug wasn't as quickly reproducible as I would like,
> but happened when I repeatedly created large lvs and filled them with some
> content, while compiling kernels in parallel), I was able to track this
> down to:
> 
> 
> commit 4ad23a976413aa57fe5ba7a25953dc35ccca5b71
> Author: NeilBrown <neilb@suse.com>
> Date:   Wed Mar 15 14:05:14 2017 +1100
> 
>     MD: use per-cpu counter for writes_pending
>     
>     The 'writes_pending' counter is used to determine when the
>     array is stable so that it can be marked in the superblock
>     as "Clean".  Consequently it needs to be updated frequently
>     but only checked for zero occasionally.  Recent changes to
>     raid5 cause the count to be updated even more often - once
>     per 4K rather than once per bio.  This provided
>     justification for making the updates more efficient.
> 
>     ...
> 
> 
> CC'ing tj@kernel.org, as 4ad23a976413 is the first (and only?) user
> of percpu_ref_switch_to_atomic_sync() introduced in 210f7cdcf088.
> 
> Applying a415c0f10627 on top of 4ad23a976413 does *not* fix the issue, but
> reverting all of a2bfc6753065, a415c0f10627 and 4ad23a976413 seems to fix
> the issue for v4.12.5.

Spent some time to check this one, unfortunately I can't find how that patch
makes rcu stall. the percpu part looks good to me too. Can you double check if
reverting 4ad23a976413aa57 makes the issue go away? When the rcu stall happens,
what the /sys/block/md/md0/array_state? please also attach /proc/mdstat. When
you say the mdx_raid1 threads are in 'R' state, can you double check if the
/proc/pid/stack always 0xffffffffff?

Thanks,
Shaohua
> In addition, I can provide the following stack traces, which appear in dmesg
> around the time the system becomes more or less unusuable, with one or more
> of the md[0123]_raid1 threads in the "R" state.
> 
> ... <nothing spectacular> ...
> [  142.275244] INFO: rcu_sched self-detected stall on CPU
> [  142.275386]  4-...: (5999 ticks this GP) idle=d8a/140000000000001/0 softirq=2404/2404 fqs=2954
> [  142.275441]   (t=6000 jiffies g=645 c=644 q=199031)
> [  142.275490] NMI backtrace for cpu 4
> [  142.275537] CPU: 4 PID: 1164 Comm: md2_raid1 Not tainted 4.12.4 #2
> [  142.275586] Hardware name: MSI MS-7522/MSI X58 Pro (MS-7522)  , BIOS V8.14B8 11/09/2012
> [  142.275640] Call Trace:
> [  142.275683]  <IRQ>
> [  142.275728]  dump_stack+0x4d/0x6a
> [  142.275775]  nmi_cpu_backtrace+0x9b/0xa0
> [  142.275822]  ? irq_force_complete_move+0xf0/0xf0
> [  142.275869]  nmi_trigger_cpumask_backtrace+0x8f/0xc0
> [  142.275918]  arch_trigger_cpumask_backtrace+0x14/0x20
> [  142.275967]  rcu_dump_cpu_stacks+0x8f/0xd9
> [  142.276016]  rcu_check_callbacks+0x62e/0x780
> [  142.276064]  ? acct_account_cputime+0x17/0x20
> [  142.276111]  update_process_times+0x2a/0x50
> [  142.276159]  tick_sched_handle.isra.18+0x2d/0x30
> [  142.276222]  tick_sched_timer+0x38/0x70
> [  142.276283]  __hrtimer_run_queues+0xbe/0x120
> [  142.276345]  hrtimer_interrupt+0xa3/0x190
> [  142.276408]  local_apic_timer_interrupt+0x33/0x60
> [  142.276471]  smp_apic_timer_interrupt+0x33/0x50
> [  142.276534]  apic_timer_interrupt+0x86/0x90
> [  142.276598] RIP: 0010:__wake_up+0x44/0x50
> [  142.276658] RSP: 0018:ffffc90000f8fd88 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff10
> [  142.276742] RAX: ffffffff81a84bc0 RBX: ffff880235cf8800 RCX: 0000000000000000
> [  142.276809] RDX: ffffffff81a84bd8 RSI: 0000000000000246 RDI: ffffffff81a84bd0
> [  142.276876] RBP: ffffc90000f8fd98 R08: 0000000000000000 R09: 0000000000000001
> [  142.276943] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880235cf8800
> [  142.277009] R13: ffff880235eb2c28 R14: 0000000000000001 R15: 0000000000000000
> [  142.277076]  </IRQ>
> [  142.277136]  md_check_recovery+0x30b/0x4a0
> [  142.277199]  raid1d+0x4c/0x810
> [  142.277258]  md_thread+0x11a/0x150
> [  142.277319]  ? md_thread+0x11a/0x150
> [  142.277379]  ? __wake_up_common+0x80/0x80
> [  142.277442]  kthread+0x11a/0x150
> [  142.277502]  ? find_pers+0x70/0x70
> [  142.277562]  ? __kthread_create_on_node+0x140/0x140
> [  142.277625]  ret_from_fork+0x22/0x30
> 
> ... or this one (on v4.12.5):
> [ 1294.560172] INFO: rcu_sched self-detected stall on CPU  
> [ 1294.560285]  2-...: (6000 ticks this GP) idle=f06/140000000000001/0 softirq=140681/140681 fqs=2988
> [ 1294.560365]   (t=6001 jiffies g=28666 c=28665 q=129416)
> [ 1294.560426] NMI backtrace for cpu 2
> [ 1294.560483] CPU: 2 PID: 1173 Comm: md3_raid1 Not tainted 4.12.5 #1
> [ 1294.560543] Hardware name: MSI MS-7522/MSI X58 Pro (MS-7522)  , BIOS V8.14B8 11/09/2012
> [ 1294.560621] Call Trace:
> [ 1294.560675]  <IRQ>
> [ 1294.560732]  dump_stack+0x4d/0x6a
> [ 1294.560789]  nmi_cpu_backtrace+0x9b/0xa0
> [ 1294.560847]  ? irq_force_complete_move+0xf0/0xf0
> [ 1294.560905]  nmi_trigger_cpumask_backtrace+0x8f/0xc0   
> [ 1294.560964]  arch_trigger_cpumask_backtrace+0x14/0x20
> [ 1294.561024]  rcu_dump_cpu_stacks+0x8f/0xd9
> [ 1294.561083]  rcu_check_callbacks+0x62e/0x780
> [ 1294.561141]  ? acct_account_cputime+0x17/0x20
> [ 1294.561200]  update_process_times+0x2a/0x50
> [ 1294.561258]  tick_sched_handle.isra.18+0x2d/0x30
> [ 1294.561316]  tick_sched_timer+0x38/0x70
> [ 1294.561373]  __hrtimer_run_queues+0xbe/0x120
> [ 1294.561430]  hrtimer_interrupt+0xa3/0x190
> [ 1294.561489]  local_apic_timer_interrupt+0x33/0x60
> [ 1294.561547]  smp_apic_timer_interrupt+0x33/0x50
> [ 1294.561606]  apic_timer_interrupt+0x86/0x90
> [ 1294.561666] RIP: 0010:raid1d+0x94/0x7f0
> [ 1294.561722] RSP: 0000:ffffc90002133dd0 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff10
> [ 1294.561800] RAX: ffff880233facc00 RBX: ffff880233facc14 RCX: 0000000000000000
> [ 1294.561863] RDX: ffffc90002133e50 RSI: 0000000000000246 RDI: ffff880233facc00
> [ 1294.561925] RBP: ffffc90002133e90 R08: 0000000000000000 R09: 0000000000000001
> [ 1294.561987] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880235924800
> [ 1294.562049] R13: ffff880233facc28 R14: ffff880236259600 R15: 0000000000000000
> [ 1294.562112]  </IRQ>
> [ 1294.562166]  md_thread+0x11a/0x150
> [ 1294.562222]  ? md_thread+0x11a/0x150
> [ 1294.562279]  ? __wake_up_common+0x80/0x80
> [ 1294.562337]  kthread+0x11a/0x150
> [ 1294.562393]  ? find_pers+0x70/0x70
> [ 1294.562449]  ? __kthread_create_on_node+0x140/0x140
> [ 1294.562508]  ? umh_complete+0x20/0x20
> [ 1294.562565]  ? call_usermodehelper_exec_async+0x13f/0x150
> [ 1294.562624]  ret_from_fork+0x22/0x30
> 
> ... or on 4.13.0-rc4 (with softlockup debug enabled):
> [  832.805574] watchdog: BUG: soft lockup - CPU#4 stuck for 22s! [md2_raid1:1238]
> [  832.805643] CPU: 4 PID: 1238 Comm: md2_raid1 Not tainted 4.13.0-rc4 #1
> [  832.805704] Hardware name: MSI MS-7522/MSI X58 Pro (MS-7522)  , BIOS V8.14B8 11/09/2012
> [  832.805783] task: ffff8802340d5c00 task.stack: ffffc90000fa4000
> [  832.805847] RIP: 0010:_raw_spin_lock_irqsave+0x7/0x30
> [  832.805906] RSP: 0018:ffffc90000fa7d20 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff10
> [  832.805984] RAX: 0000000000000000 RBX: 0000000000000246 RCX: 0000000000000000
> [  832.806046] RDX: 0000000000000001 RSI: 0000000000000003 RDI: ffff8802357ad850
> [  832.806109] RBP: ffffc90000fa7d28 R08: 0000000000000000 R09: 0000000000000001
> [  832.806171] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> [  832.806233] R13: 0000000000000003 R14: 0000000000000001 R15: 0000000000000000
> [  832.806296] FS:  0000000000000000(0000) GS:ffff88023fd00000(0000) knlGS:0000000000000000
> [  832.806374] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033   
> [  832.806434] CR2: 000014c452f99e48 CR3: 0000000001a0a000 CR4: 00000000000006e0
> [  832.806496] Call Trace:
> [  832.806554]  __wake_up+0x1e/0x50
> [  832.806612]  md_wakeup_thread+0x2f/0x60
> [  832.806669]  mddev_unlock+0x86/0xd0
> [  832.806726]  md_check_recovery+0x1c6/0x4a0
> [  832.806783]  raid1d+0x4c/0x7f0unted filesystem with ordered data mode. Opts: (null)
> [  832.806839]  md_thread+0x11a/0x150
> [  832.806895]  ? md_thread+0x11a/0x150
> [  832.806951]  ? __wake_up_common+0x80/0x80
> [  832.807010]  kthread+0x11a/0x150
> [  832.807066]  ? state_show+0x310/0x310
> [  832.807122]  ? __kthread_create_on_node+0x140/0x140
> [  832.807181]  ret_from_fork+0x22/0x30
> [  832.807237] Code: 00 00 00 00 31 c0 ba 01 00 00 00 f0 0f b1 17 85 c0 75 01 c3 55 89 c6 48 89 e5 e8 25 e6 a5 ff 5d c3 0f 1f 00 55 48 89 e5 53 9c 5b <fa> 31 c0 ba 01 00 00 00 f0 0f b1 17 85 c0 75 06 48 89 d8 5b 5d
> [  836.654936] watchdog: BUG: soft lockup - CPU#3 stuck for 24s! [md3_raid1:1246]
> [  836.655017] CPU: 3 PID: 1246 Comm: md3_raid1 Tainted: G             L  4.13.0-rc4 #1
> [  836.655095] Hardware name: MSI MS-7522/MSI X58 Pro (MS-7522)  , BIOS V8.14B8 11/09/2012Automount Point.
> [  836.655174] task: ffff880235cfb980 task.stack: ffffc90002640000
> [  836.655237] RIP: 0010:raid1d+0x94/0x7f0
> [  836.655294] RSP: 0018:ffffc90002643dd0 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff10
> [  836.655372] RAX: ffff880235da7900 RBX: ffff880235da7914 RCX: 0000000000000000(null)
> [  836.655434] RDX: ffffc90002643e50 RSI: 0000000000000246 RDI: ffff880235da7900 from PID 1
> [  836.655497] RBP: ffffc90002643e90 R08: 0000000000000000 R09: 0000000000000001
> [  836.655560] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880233bcb000
> [  836.655625] R13: ffff880235da7928 R14: ffff880235cfb980 R15: 0000000000000000
> [  836.655687] FS:  0000000000000000(0000) GS:ffff88023fcc0000(0000) knlGS:0000000000000000
> [  836.655766] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  836.655826] CR2: 000000adf6140e40 CR3: 0000000001a0a000 CR4: 00000000000006e0
> [  836.655888] Call Trace:
> [  836.655944]  md_thread+0x11a/0x150
> [  836.656001]  ? md_thread+0x11a/0x150
> [  836.656059]  ? __wake_up_common+0x80/0x80
> [  836.656117]  kthread+0x11a/0x150
> [  836.656173]  ? state_show+0x310/0x310
> [  836.656230]  ? __kthread_create_on_node+0x140/0x140
> [  836.656289]  ? umh_complete+0x20/0x20
>    836.656346]  ? call_usermodehelper_exec_async+0x13f/0x150
>    836.656407]  ret_from_fork+0x22/0x30
>    836.656463] Code: ff 48 8d 58 14 48 8d 45 a0 48 89 85 48 ff ff ff 48 8b bd 48 ff ff ff e8 cb 32 e5 ff 48 8b 85 68 ff ff ff 48 89 45 80 48 8b 7d 80 <e8> f7 b4 ff ff 48 89 df e8 6f be 19 00 48 8b 8d 68 ff ff ff 48
> 
> Yet another one (this is commit e265eb3a)
> [  129.019946] INFO: rcu_sched self-detected stall on CPU
> [  129.020087]  4-...: (6000 ticks this GP) idle=1a3/140000000000001/0 softirq=2598/2598 fqs=2939
> [  129.020138]   (t=6001 jiffies g=1214 c=1213 q=64003)
> [  129.020187] NMI backtrace for cpu 4
> [  129.020230] CPU: 4 PID: 1161 Comm: md2_raid1 Not tainted 4.11.0-00587-ge265eb3a #4
> [  129.020279] Hardware name: MSI MS-7522/MSI X58 Pro (MS-7522)  , BIOS V8.14B8 11/09/2012
> [  129.020328] Call Trace:
> [  129.020369]  <IRQ>
> [  129.020412]  dump_stack+0x4d/0x65
> [  129.020454]  nmi_cpu_backtrace+0x9b/0xa0
> [  129.020497]  ? irq_force_complete_move+0xf0/0xf0
> [  129.020541]  nmi_trigger_cpumask_backtrace+0x8f/0xc0
> [  129.020586]  arch_trigger_cpumask_backtrace+0x14/0x20
> [  129.020631]  rcu_dump_cpu_stacks+0x8f/0xca
> [  129.020690]  rcu_check_callbacks+0x651/0x7b0
> [  129.020749]  ? acct_account_cputime+0x17/0x20
> [  129.020807]  update_process_times+0x2a/0x50
> [  129.020865]  tick_sched_handle.isra.18+0x2d/0x30
> [  129.020924]  tick_sched_timer+0x38/0x70
> [  129.020981]  __hrtimer_run_queues+0xba/0x150
> [  129.021038]  hrtimer_interrupt+0xa3/0x190
> [  129.021097]  local_apic_timer_interrupt+0x33/0x60
> [  129.021156]  smp_apic_timer_interrupt+0x33/0x50
> [  129.021214]  apic_timer_interrupt+0x86/0x90
> [  129.021273] RIP: 0010:mutex_unlock+0x13/0x30
> [  129.021330] RSP: 0018:ffffc90000f87d58 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff10
> [  129.021408] RAX: ffff880234d98b00 RBX: ffff880232f89700 RCX: 0000000000000000
> [  129.021470] RDX: ffff880234d98b00 RSI: 0000000000000000 RDI: ffff880235250358
> [  129.021532] RBP: ffffc90000f87d98 R08: 0000000000000000 R09: 0000000000000000
> [  129.021595] R10: ffffc90000f87ea8 R11: 0000000000000000 R12: ffff880235250000
> [  129.021657] R13: ffff880232f89128 R14: ffff880234d98b00 R15: 0000000000000000
> [  129.021719]  </IRQ>
> [  129.021773]  ? bitmap_daemon_work+0x1c9/0x330
> [  129.021831]  md_check_recovery+0x22/0x4a0
> [  129.021888]  raid1d+0x4c/0x840
> [  129.021944]  md_thread+0x11a/0x150
> [  129.022000]  ? md_thread+0x11a/0x150
> [  129.022056]  ? __wake_up_common+0x80/0x80
> [  129.022114]  kthread+0x11a/0x150
> [  129.022169]  ? find_pers+0x70/0x70
> [  129.022226]  ? __kthread_create_on_node+0x140/0x140
> [  129.022284]  ret_from_fork+0x29/0x40
> 
> 
> .config snippts:
> 
> CONFIG_MD_AUTODETECT=y
> # CONFIG_MD_LINEAR is not set
> # CONFIG_MD_RAID0 is not set
> CONFIG_MD_RAID1=y
> # CONFIG_MD_RAID10 is not set
> # CONFIG_MD_RAID456 is not set
> # CONFIG_MD_MULTIPATH is not set
> # CONFIG_MD_FAULTY is not set
> # CONFIG_AMD_IOMMU is not set
> # CONFIG_MCE_AMD_INJ is not set
> CONFIG_BLK_DEV_DM_BUILTIN=y
> # CONFIG_DM_MQ_DEFAULT is not set
> # CONFIG_DM_DEBUG is not set
> CONFIG_DM_BUFIO=y
> # CONFIG_DM_DEBUG_BLOCK_MANAGER_LOCKING is not set
> CONFIG_DM_CRYPT=y
> CONFIG_DM_SNAPSHOT=y
> # CONFIG_DM_THIN_PROVISIONING is not set
> # CONFIG_DM_CACHE is not set
> # CONFIG_DM_ERA is not set
> CONFIG_DM_MIRROR=y
> # CONFIG_DM_LOG_USERSPACE is not set
> # CONFIG_DM_RAID is not set
> CONFIG_DM_ZERO=y
> # CONFIG_DM_MULTIPATH is not set
> # CONFIG_DM_DELAY is not set
> CONFIG_DM_UEVENT=y
> # CONFIG_DM_FLAKEY is not set
> # CONFIG_DM_VERITY is not set
> # CONFIG_DM_SWITCH is not set
> # CONFIG_DM_LOG_WRITES is not set
> # CONFIG_DM_INTEGRITY is not set
> # CONFIG_RCU_EXPERT is not set
> CONFIG_RCU_STALL_COMMON=y
> CONFIG_RCU_NEED_SEGCBLIST=y
> # CONFIG_TREE_RCU_TRACE is not set
> # CONFIG_SPARSE_RCU_POINTER is not set
> # CONFIG_RCU_PERF_TEST is not set
> # CONFIG_RCU_TORTURE_TEST is not set
> CONFIG_RCU_CPU_STALL_TIMEOUT=60
> # CONFIG_RCU_TRACE is not set
> # CONFIG_RCU_EQS_DEBUG is not set
> CONFIG_NO_HZ_COMMON=y
> # CONFIG_HZ_PERIODIC is not set
> CONFIG_NO_HZ_IDLE=y
> # CONFIG_NO_HZ_FULL is not set
> CONFIG_NO_HZ=y
> CONFIG_HZ_100=y
> # CONFIG_HZ_250 is not set
> # CONFIG_HZ_300 is not set
> # CONFIG_HZ_1000 is not set
> CONFIG_HZ=100
> 
> 
> Any ideas?
> 
> Best,
> 	Dominik
> 
> 
> PS: Unfortunately, the hardware where I can easily test this will be
> gone somewhen tomorrow.
