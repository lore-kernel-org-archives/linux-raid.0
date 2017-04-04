From: Marc Smith <marc.smith@mcc.edu>
Subject: md-cluster Oops 4.9.13
Date: Tue, 4 Apr 2017 10:06:22 -0400
Message-ID: <CAHkw+Lcr1+sWsQPK_ijfTHwG+zxRYT+iNhWGdpYTNxVuQi8TOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I encountered an oops this morning when stopping a MD array
(md-cluster)... there were 4 md-cluster array started, and they were
in the middle of a rebuild. I stopped the first one and then stopped
the second one immediately after and got the oops, here is a
transcript of what was on my terminal session:

[root@brimstone-1b ~]# mdadm --stop /dev/md/array1
mdadm: stopped /dev/md/array1
[root@brimstone-1b ~]# mdadm --stop /dev/md/array2

Message from syslogd@brimstone-1b at Tue Apr  4 09:54:40 2017 ...
brimstone-1b kernel: [649162.174685] BUG: unable to handle kernel NULL
pointer dereference at 0000000000000098

Using Linux 4.9.13 and here is the output from the kernel messages:

--snip--
[649158.014731] dlm: 5b3b8f94-7875-b323-5bb8-29fa6866f4a8: leaving the
lockspace group...
[649158.015233] dlm: 5b3b8f94-7875-b323-5bb8-29fa6866f4a8: group event done 0 0
[649158.015303] dlm: 5b3b8f94-7875-b323-5bb8-29fa6866f4a8:
release_lockspace final free
[649158.015331] md: unbind<nvme0n1p1>
[649158.042540] md: export_rdev(nvme0n1p1)
[649158.042546] md: unbind<nvme1n1p1>
[649158.048501] md: export_rdev(nvme1n1p1)
[649161.759022] md127: detected capacity change from 1000068874240 to 0
[649161.759025] md: md127 stopped.
[649162.174685] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000098
[649162.174727] IP: [<ffffffff81868b40>] recv_daemon+0x1e9/0x373
[649162.174766] PGD 0
[649162.174776]
[649162.174792] Oops: 0000 [#1] SMP
[649162.174806] Modules linked in: qla2xxx bonding mlx5_core bna
[649162.174850] CPU: 53 PID: 37118 Comm: md127_cluster_r Not tainted
4.9.13-esos.prod #1
[649162.174902] Hardware name: Supermicro SSG-2028R-DN2R40L/X10DSN-TS,
BIOS 2.0 10/28/2016
[649162.174926] task: ffff88105a259880 task.stack: ffffc9002fb54000
[649162.174946] RIP: 0010:[<ffffffff81868b40>]  [<ffffffff81868b40>]
recv_daemon+0x1e9/0x373
[649162.175287] RSP: 0018:ffffc9002fb57e00  EFLAGS: 00010282
[649162.175462] RAX: ffff88084fa22d40 RBX: ffff881015807000 RCX:
0000000000000000
[649162.175799] RDX: 0000000000000000 RSI: 0000000000000001 RDI:
ffff881015807000
[649162.176132] RBP: ffff88105a27e400 R08: 0000000000019b40 R09:
ffff88084fa22d40
[649162.176464] R10: ffffc90006493e38 R11: 000000204867dce0 R12:
0000000000000000
[649162.176796] R13: ffff88085a3e4d80 R14: 00000000024ed800 R15:
00000000024fd800
[649162.177130] FS:  0000000000000000(0000) GS:ffff88105f440000(0000)
knlGS:0000000000000000
[649162.177467] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[649162.177641] CR2: 0000000000000098 CR3: 0000000002010000 CR4:
00000000003406e0
[649162.177974] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[649162.178307] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[649162.178640] Stack:
[649162.178804]  ffff88105a27e430 ffff881059e9e700 ffff88084fa22d40
0000000000000001
[649162.179151]  00000000024ed800 00000000024fd800 0000000000000000
0000000000000000
[649162.179502]  0000000000000000 000000004d2f4151 ffff8810152256c0
ffff88105a259880
[649162.179853] Call Trace:
[649162.180028]  [<ffffffff810686f8>] ? do_group_exit+0x39/0x91
[649162.180206]  [<ffffffff8188245a>] ? md_thread+0xff/0x113
[649162.180383]  [<ffffffff8108fde5>] ? wake_up_bit+0x1b/0x1b
[649162.180558]  [<ffffffff8188235b>] ? md_wait_for_blocked_rdev+0xe4/0xe4
[649162.180736]  [<ffffffff8107abf0>] ? kthread+0xc2/0xca
[649162.180910]  [<ffffffff8107ab2e>] ? kthread_park+0x4e/0x4e
[649162.181092]  [<ffffffff81a89ee2>] ? ret_from_fork+0x22/0x30
[649162.181267] Code: 00 e8 db 8d 8b ff 48 85 c0 0f 84 32 01 00 00 44
89 20 4c 89 70 08 48 89 df 4c 89 78 10 48 8b 53 08 be 01 00 00 00 48
89 44 24 10 <ff> 92 98 00 00 00 48 8b 53 08 31 f6 48 89 df ff 92 98 00
00 00
[649162.182024] RIP  [<ffffffff81868b40>] recv_daemon+0x1e9/0x373
[649162.182201]  RSP <ffffc9002fb57e00>
[649162.182369] CR2: 0000000000000098
[649162.183031] ---[ end trace 71c20646840bbbd3 ]---
[649162.183278] BUG: unable to handle kernel NULL pointer dereference
at           (null)
[649162.183801] IP: [<ffffffff8108f91e>] __wake_up_common+0x1d/0x73
[649162.184100] PGD 0
[649162.184170]
[649162.184459] Oops: 0000 [#2] SMP
[649162.184687] Modules linked in: qla2xxx bonding mlx5_core bna
[649162.185242] CPU: 53 PID: 37118 Comm: md127_cluster_r Tainted: G
  D         4.9.13-esos.prod #1
[649162.185640] Hardware name: Supermicro SSG-2028R-DN2R40L/X10DSN-TS,
BIOS 2.0 10/28/2016
[649162.186036] task: ffff88105a259880 task.stack: ffffc9002fb54000
[649162.186272] RIP: 0010:[<ffffffff8108f91e>]  [<ffffffff8108f91e>]
__wake_up_common+0x1d/0x73
[649162.186734] RSP: 0018:ffffc9002fb57e78  EFLAGS: 00010046
[649162.186966] RAX: 0000000000000286 RBX: ffffc9002fb57f20 RCX:
0000000000000000
[649162.187357] RDX: 0000000000000000 RSI: 0000000000000003 RDI:
ffffc9002fb57f20
[649162.187749] RBP: ffffc9002fb57f28 R08: 0000000000000000 R09:
0000000000000000
[649162.188157] R10: 00000000ffff8810 R11: 000000000000ffa0 R12:
0000000000000003
[649162.188548] R13: 0000000000000000 R14: 0000000000000000 R15:
0000000000000001
[649162.188939] FS:  0000000000000000(0000) GS:ffff88105f440000(0000)
knlGS:0000000000000000
[649162.189330] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[649162.189562] CR2: 0000000000000000 CR3: 0000000002010000 CR4:
00000000003406e0
[649162.189952] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[649162.190341] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[649162.190730] Stack:
[649162.190955]  0000000000000000 ffffc9002fb57f20 ffffc9002fb57f18
0000000000000286
[649162.191605]  ffffc9002fb57f10 0000000000000000 0000000000030001
ffffffff810900f7
[649162.192252]  0000000000000000 ffff88105a259880 0000000000000001
ffffffff810633f4
[649162.192897] Call Trace:
[649162.193124]  [<ffffffff810900f7>] ? complete+0x2b/0x3a
[649162.193357]  [<ffffffff810633f4>] ? mm_release+0xe3/0xed
[649162.193589]  [<ffffffff8106745c>] ? do_exit+0x265/0x886
[649162.193824]  [<ffffffff81a8b6e7>] ? rewind_stack_do_exit+0x17/0x20
[649162.194058] Code: 07 00 00 00 00 48 89 47 08 48 89 47 10 c3 41 57
41 56 41 89 d7 41 55 41 54 41 89 cd 55 53 48 8d 6f 08 41 51 48 8b 57
08 41 89 f4 <48> 8b 1a 48 8d 42 e8 48 83 eb 18 48 8d 50 18 48 39 ea 74
36 4c
[649162.198789] RIP  [<ffffffff8108f91e>] __wake_up_common+0x1d/0x73
[649162.199085]  RSP <ffffc9002fb57e78>
[649162.199310] CR2: 0000000000000000
[649162.199536] ---[ end trace 71c20646840bbbd4 ]---
[649162.199764] Fixing recursive fault but reboot is needed!
[649225.679190] INFO: rcu_sched self-detected stall on CPU
[649225.679480]         46-...: (59999 ticks this GP)
idle=6dd/140000000000001/0 softirq=118748/118748 fqs=15000
[649225.679862]          (t=60001 jiffies g=395492 c=395491 q=3050)
[649225.680153] Task dump for CPU 46:
[649225.680373] killall         R  running task        0 37212      1 0x0000000c
[649225.680726]  0000000000000000 ffffffff81081cbf 000000000000002e
ffffffff82049000
[649225.681352]  ffffffff810e4ef5 ffffffff82049000 ffff88105f297640
ffffc9002fb9fbe8
[649225.681981]  0000000000000001 ffffffff810a63d1 0000000000000bea
000000000000002e
[649225.682610] Call Trace:
[649225.682828]  <IRQ>
[649225.682901]  [<ffffffff81081cbf>] ? sched_show_task+0xc3/0xd0
[649225.687385]  [<ffffffff810e4ef5>] ? rcu_dump_cpu_stacks+0x72/0x95
[649225.687616]  [<ffffffff810a63d1>] ? rcu_check_callbacks+0x227/0x604
[649225.687844]  [<ffffffff810a8c41>] ? update_process_times+0x23/0x45
[649225.688073]  [<ffffffff810b4094>] ? tick_sched_handle+0x2e/0x38
[649225.688300]  [<ffffffff810b40cd>] ? tick_sched_timer+0x2f/0x53
[649225.688527]  [<ffffffff810a9414>] ? __hrtimer_run_queues+0x71/0xe8
[649225.688754]  [<ffffffff810a963a>] ? hrtimer_interrupt+0x8b/0x145
[649225.688984]  [<ffffffff8102d94b>] ? smp_apic_timer_interrupt+0x34/0x43
[649225.689213]  [<ffffffff81a8a88f>] ? apic_timer_interrupt+0x7f/0x90
[649225.689439]  <EOI>
[649225.689509]  [<ffffffff810916a5>] ? queued_spin_lock_slowpath+0x48/0x15d
[649225.689951]  [<ffffffff81177018>] ? pid_revalidate+0x52/0xa0
[649225.690178]  [<ffffffff81132989>] ? lookup_fast+0x1f5/0x267
[649225.690405]  [<ffffffff81134a03>] ? path_openat+0x39d/0xeb1
[649225.690630]  [<ffffffff81132900>] ? lookup_fast+0x16c/0x267
[649225.690858]  [<ffffffff81079105>] ? get_pid_task+0x5/0xf
[649225.691091]  [<ffffffff8113a5bb>] ? dput+0x30/0x1cb
[649225.691315]  [<ffffffff811336c0>] ? path_lookupat+0xea/0xfe
[649225.691541]  [<ffffffff8113555f>] ? do_filp_open+0x48/0x9e
[649225.691767]  [<ffffffff81062b07>] ? get_task_mm+0x10/0x33
[649225.691994]  [<ffffffff813a28b3>] ? lockref_put_or_lock+0x3a/0x50
[649225.692221]  [<ffffffff8113a65a>] ? dput+0xcf/0x1cb
[649225.692446]  [<ffffffff8112799b>] ? do_sys_open+0x135/0x1bc
[649225.692671]  [<ffffffff8112799b>] ? do_sys_open+0x135/0x1bc
[649225.692898]  [<ffffffff81a89ca0>] ? entry_SYSCALL_64_fastpath+0x13/0x94
[649225.693127] INFO: rcu_sched detected stalls on CPUs/tasks:
[649225.693413]         46-...: (60001 ticks this GP)
idle=6dd/140000000000000/0 softirq=118748/118748 fqs=15001
[649225.693786]         (detected by 33, t=60015 jiffies, g=395492,
c=395491, q=3050)
[649225.694070] Task dump for CPU 46:
[649225.694284] killall         R  running task        0 37212      1 0x0000000c
[649225.694627]  ffffffff00000000 ffff881014971d18 ffff881022ddc020
ffff88105b9d5ec0
[649225.695236]  ffffc9002fb9fdc0 ffffffff811336c0 000000002fb9fe38
0000000000000001
[649225.695844]  ffffc9002fb9fef0 ffffc9002fb9ff0c 00000000000090fe
00007f540db18690
[649225.696452] Call Trace:
[649225.696668]  [<ffffffff811336c0>] ? path_lookupat+0xea/0xfe
[649225.696888]  [<ffffffff8113555f>] ? do_filp_open+0x48/0x9e
[649225.697108]  [<ffffffff81062b07>] ? get_task_mm+0x10/0x33
[649225.697328]  [<ffffffff813a28b3>] ? lockref_put_or_lock+0x3a/0x50
[649225.697549]  [<ffffffff8113a65a>] ? dput+0xcf/0x1cb
[649225.697770]  [<ffffffff8112799b>] ? do_sys_open+0x135/0x1bc
[649225.697989]  [<ffffffff8112799b>] ? do_sys_open+0x135/0x1bc
[649225.698211]  [<ffffffff81a89ca0>] ? entry_SYSCALL_64_fastpath+0x13/0x94
--snip--

Perhaps this is already fixed in later versions? Let me know if you
need any additional information.


Thanks,

Marc
