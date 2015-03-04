From: Terry Hardie <thardie@instartlogic.com>
Subject: Re: Hung RAID5 array with discard
Date: Wed, 4 Mar 2015 13:47:08 -0800
Message-ID: <CANHB05sb44ZD-31ceEWWSY0XdhWaU-Pq+NFRQSm-1qafHx1G2g@mail.gmail.com>
References: <CANHB05vDxWqfST41hXgfApthHuxdSuyJYCKqS4jkOa7OZ0kpsA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANHB05vDxWqfST41hXgfApthHuxdSuyJYCKqS4jkOa7OZ0kpsA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Well, I'm dissapointed no one responded to this. This basically means
linux RAID 4/5/6 and discard is fundamentally broken, and no one wants
to acknowledge it.

I hope someone finds this post while I still have my lab available and
I can help them troubleshoot this issue.

I tried this again today on 3.13.0-44-generic (Ubuntu) and was easily
able to reproduce it.

On Wed, Dec 17, 2014 at 7:08 PM, Terry Hardie <thardie@instartlogic.com> wrote:
> Hi,
>
> I am testing 3 SSDs (1TB Crucial M550 with DRZAT, and I tested they do
> return zeros after discard) with RAID5 and discard. I create the array
> with a 64k chunk size, and it starts to sync. During it's initial
> reconstruction, I do a mkfs.ext4, which starts to do the "Discarding
> device blocks". After a short period (I believe when the mkfs reaches
> the point where the reconstruction is at, all IO to the disks freezes,
> and mkfs does not advance. iostat shows 2 of the 3 drives at 100%
> utilization with no data read or written. After 2 minutes, I get the
> hung task dump. Most CPUs are idle, and here are a few which are not,
> which look like a deadlock to me:
>
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.154399] INFO:
> rcu_sched detected stalls on CPUs/tasks: { 4 5} (detected by 3,
> t=285032 jiffies, g=1160, c=1159, q=0)
>
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.154902] NMI
> backtrace for cpu 4
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.154904] CPU: 4 PID:
> 2146 Comm: md3_raid5 Tainted: G        W IOX 3.13.0-43-generic
> #72~precise1
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.154905] Hardware
> name: Supermicro SYS-2028TP-HC1R/X10DRT-P, BIOS 1.0a 08/28/2014
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.154906] task:
> ffff88202594c800 ti: ffff8810245a0000 task.ti: ffff8810245a0000
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.154907] RIP:
> 0010:[<ffffffff817644c1>]  [<ffffffff817644c1>]
> _raw_spin_lock_irqsave+0x41/0x60
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.154910] RSP:
> 0018:ffff8810245a1cc8  EFLAGS: 00000006
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.154911] RAX:
> 0000000000002ec5 RBX: ffff882028a6ec00 RCX: 0000000000007b78
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.154912] RDX:
> 0000000000000202 RSI: 0000000000007b78 RDI: ffff882028a6ec10
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.154913] RBP:
> ffff8810245a1cc8 R08: 0000000000007b76 R09: ffff882023629170
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.154914] R10:
> 0000000000000000 R11: ffff882028a6ec00 R12: ffff882028a6ee68
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.154915] R13:
> 0000000000000003 R14: 0000000000000002 R15: ffff882028a6ec10
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.154916] FS:
> 0000000000000000(0000) GS:ffff88103fc80000(0000)
> knlGS:0000000000000000
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.154917] CS:  0010
> DS: 0000 ES: 0000 CR0: 0000000080050033
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.154918] CR2:
> 00007f208c2d0000 CR3: 0000000001c0d000 CR4: 00000000001407e0
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.154919] Stack:
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.154920]
> ffff8810245a1d18 ffffffffa0149890 0000000000000002 ffff882028a6ee88
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.154923]
> ffff882028a6ee68 ffff882028a6ec00 0000000000000008 ffff882028a6ee68
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.154926]
> 0000000000000000 ffff882028a6ee50 ffff8810245a1d98 ffffffffa015212f
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.154929] Call Trace:
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.154933]
> [<ffffffffa0149890>] release_inactive_stripe_list+0x50/0x160 [raid456]
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.154937]
> [<ffffffffa015212f>] handle_active_stripes.isra.38+0x7f/0x190
> [raid456]
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.154940]
> [<ffffffffa0152758>] raid5d+0x198/0x2f0 [raid456]
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.154942]
> [<ffffffff815d30a7>] md_thread+0x117/0x150
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.154945]
> [<ffffffff810affe0>] ? __wake_up_sync+0x20/0x20
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.154947]
> [<ffffffff815d2f90>] ? md_rdev_init+0x110/0x110
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.154949]
> [<ffffffff8108fb59>] kthread+0xc9/0xe0
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.154952]
> [<ffffffff8108fa90>] ? flush_kthread_worker+0xb0/0xb0
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.154954]
> [<ffffffff8176d5bc>] ret_from_fork+0x7c/0xb0
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.154956]
> [<ffffffff8108fa90>] ? flush_kthread_worker+0xb0/0xb0
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.154957] Code: 1f 44
> 00 00 b8 00 00 02 00 f0 0f c1 07 89 c1 c1 e9 10 66 39 c1 75 05 48 89
> d0 5d c3 83 e1 fe 0f b7 f1 b8 00 80 00 00 44 0f b7 07 <66> 44 39 c1 74
> e6 f3 90 83 e8 01 75 ef 0f 1f 80 00 00 00 00 eb
>
>
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.155001] NMI
> backtrace for cpu 5
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.155003] CPU: 5 PID:
> 2147 Comm: md3_resync Tainted: G        W IOX 3.13.0-43-generic
> #72~precise1
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.155004] Hardware
> name: Supermicro SYS-2028TP-HC1R/X10DRT-P, BIOS 1.0a 08/28/2014
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.155005] task:
> ffff88202594b000 ti: ffff8810274a0000 task.ti: ffff8810274a0000
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.155006] RIP:
> 0010:[<ffffffffa01483b7>]  [<ffffffffa01483b7>]
> __find_stripe+0x57/0xa0 [raid456]
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.155010] RSP:
> 0018:ffff8810274a1b68  EFLAGS: 00000006
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.155011] RAX:
> ffff882027092da0 RBX: 0000000000a30c10 RCX: 0000000000000001
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.155012] RDX:
> 0000000000000c10 RSI: 0000000000a30c10 RDI: ffff882028a6ec00
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.155013] RBP:
> ffff8810274a1b88 R08: 0000000000000000 R09: 0000000000000000
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.155014] R10:
> 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.155015] R13:
> ffff882028a6ec00 R14: 0000000000000000 R15: ffff882028a6eda8
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.155016] FS:
> 0000000000000000(0000) GS:ffff88103fca0000(0000)
> knlGS:0000000000000000
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.155017] CS:  0010
> DS: 0000 ES: 0000 CR0: 0000000080050033
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.155018] CR2:
> 00000000006e1dc8 CR3: 0000000001c0d000 CR4: 00000000001407e0
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.155019] Stack:
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.155020]
> ffff8810274a1ba8 ffff882028a6ec00 000000007b767b00 ffff882028a6ec10
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.155023]
> ffff8810274a1c28 ffffffffa0150555 ffff882023773b50 ffff882028a6eda8
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.155026]
> 0000000200000001 ffff882028a6ec08 0000000000000000 0000000000a30c10
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.155029] Call Trace:
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.155033]
> [<ffffffffa0150555>] get_active_stripe+0x115/0x3e0 [raid456]
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.155036]
> [<ffffffffa014aea8>] ? release_stripe+0x68/0x100 [raid456]
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.155040]
> [<ffffffffa0154f3b>] sync_request+0x11b/0x2a0 [raid456]
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.155042]
> [<ffffffff815d5ccf>] md_do_sync+0x84f/0xdb0
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.155046]
> [<ffffffff810affe0>] ? __wake_up_sync+0x20/0x20
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.155048]
> [<ffffffff815d30a7>] md_thread+0x117/0x150
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.155050]
> [<ffffffff815d2f90>] ? md_rdev_init+0x110/0x110
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.155052]
> [<ffffffff8108fb59>] kthread+0xc9/0xe0
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.155054]
> [<ffffffff8108fa90>] ? flush_kthread_worker+0xb0/0xb0
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.155057]
> [<ffffffff8176d5bc>] ret_from_fork+0x7c/0xb0
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.155059]
> [<ffffffff8108fa90>] ? flush_kthread_worker+0xb0/0xb0
> Dec 18 00:57:41 unassigned-hostname kernel: [ 1606.155060] Code: e2 f8
> 0f 00 00 48 8b 04 02 48 85 c0 75 25 f6 05 29 25 01 00 04 75 3e 31 c0
> 48 83 c4 08 5b 41 5c 41 5d 5d c3 66 44 39 60 30 74 ee <48> 8b 00 48 85
> c0 74 db 48 39 58 38 75 f2 eb e9 48 89 f2 48 c7
>
> Dec 18 00:58:57 unassigned-hostname kernel: [ 1682.670082] INFO: task
> mkfs.ext4:2235 blocked for more than 120 seconds.
> Dec 18 00:58:57 unassigned-hostname kernel: [ 1682.670109]
> Tainted: G        W IOX 3.13.0-43-generic #72~precise1
> Dec 18 00:58:57 unassigned-hostname kernel: [ 1682.670130] "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Dec 18 00:58:57 unassigned-hostname kernel: [ 1682.670155] mkfs.ext4
>     D ffff881024fe39e0     0  2235   2080 0x00000000
> Dec 18 00:58:57 unassigned-hostname kernel: [ 1682.670158]
> ffff882026eafa68 0000000000000082 ffff88103fc73480 ffff882026eaffd8
> Dec 18 00:58:57 unassigned-hostname kernel: [ 1682.670162]
> 0000000000013480 0000000000013480 ffff8820293e8000 ffff88202208b000
> Dec 18 00:58:57 unassigned-hostname kernel: [ 1682.670165]
> ffff882026eafa78 ffff882028a6ec00 ffff882028a6ed98 ffff882028a6ec0c
> Dec 18 00:58:57 unassigned-hostname kernel: [ 1682.670169] Call Trace:
> Dec 18 00:58:57 unassigned-hostname kernel: [ 1682.670175]
> [<ffffffff81760ae9>] schedule+0x29/0x70
> Dec 18 00:58:57 unassigned-hostname kernel: [ 1682.670181]
> [<ffffffffa01506e3>] get_active_stripe+0x2a3/0x3e0 [raid456]
> Dec 18 00:58:57 unassigned-hostname kernel: [ 1682.670185]
> [<ffffffff8134c152>] ? blk_check_plugged+0x72/0xb0
> Dec 18 00:58:57 unassigned-hostname kernel: [ 1682.670189]
> [<ffffffff810affe0>] ? __wake_up_sync+0x20/0x20
> Dec 18 00:58:57 unassigned-hostname kernel: [ 1682.670193]
> [<ffffffffa0155e44>] make_discard_request+0x108/0x12c4 [raid456]
> Dec 18 00:58:57 unassigned-hostname kernel: [ 1682.670196]
> [<ffffffff810affe0>] ? __wake_up_sync+0x20/0x20
> Dec 18 00:58:57 unassigned-hostname kernel: [ 1682.670201]
> [<ffffffffa0155c91>] make_request+0x581/0x590 [raid456]
> Dec 18 00:58:57 unassigned-hostname kernel: [ 1682.670204]
> [<ffffffff8109cfd6>] ? ttwu_do_activate.constprop.82+0x66/0x70
> Dec 18 00:58:57 unassigned-hostname kernel: [ 1682.670207]
> [<ffffffff8109d097>] ? ttwu_queue+0xb7/0xd0
> Dec 18 00:58:57 unassigned-hostname kernel: [ 1682.670210]
> [<ffffffff8109f950>] ? try_to_wake_up+0x190/0x210
> Dec 18 00:58:57 unassigned-hostname kernel: [ 1682.670212]
> [<ffffffff815d2c53>] md_make_request+0xd3/0x230
> Dec 18 00:58:57 unassigned-hostname kernel: [ 1682.670216]
> [<ffffffff8115b085>] ? mempool_alloc_slab+0x15/0x20
> Dec 18 00:58:57 unassigned-hostname kernel: [ 1682.670219]
> [<ffffffff8134ceb7>] generic_make_request.part.62+0x77/0xb0
> Dec 18 00:58:57 unassigned-hostname kernel: [ 1682.670222]
> [<ffffffff8134d428>] generic_make_request+0x68/0x70
> Dec 18 00:58:57 unassigned-hostname kernel: [ 1682.670225]
> [<ffffffff8134d4a8>] submit_bio+0x78/0x160
> Dec 18 00:58:57 unassigned-hostname kernel: [ 1682.670228]
> [<ffffffff81202f80>] ? bio_alloc_bioset+0xa0/0x1d0
> Dec 18 00:58:57 unassigned-hostname kernel: [ 1682.670232]
> [<ffffffff813578c0>] blkdev_issue_discard+0x1f0/0x2a0
> Dec 18 00:58:57 unassigned-hostname kernel: [ 1682.670235]
> [<ffffffff8135c1f4>] blkdev_ioctl+0x354/0x810
> Dec 18 00:58:57 unassigned-hostname kernel: [ 1682.670238]
> [<ffffffff8101361d>] ? __switch_to+0x16d/0x4d0
> Dec 18 00:58:57 unassigned-hostname kernel: [ 1682.670241]
> [<ffffffff81204370>] block_ioctl+0x40/0x50
> Dec 18 00:58:57 unassigned-hostname kernel: [ 1682.670244]
> [<ffffffff811dd5c5>] do_vfs_ioctl+0x75/0x2c0
> Dec 18 00:58:57 unassigned-hostname kernel: [ 1682.670247]
> [<ffffffff817606be>] ? __schedule+0x38e/0x700
> Dec 18 00:58:57 unassigned-hostname kernel: [ 1682.670249]
> [<ffffffff811dd8a1>] SyS_ioctl+0x91/0xb0
> Dec 18 00:58:57 unassigned-hostname kernel: [ 1682.670252]
> [<ffffffff8176d66d>] system_call_fastpath+0x1a/0x1f
>
>
>
>
> If I do the mkfs.ext4 after the initial reconstruction is done, is
> gets all the way through. I don't want to put this system into
> production, since this could mean this condition could show up in the
> future if the array needs to reconstruct again at a future point while
> in service.
>
> This is a test system in a lab, so I'd be happy to try some tests.
>
> Terry
