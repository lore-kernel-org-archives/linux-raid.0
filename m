From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: raid6: general protection fault in async_copy_data
Date: Tue, 5 May 2015 10:14:18 +0200
Message-ID: <CAGRgLy439G+AtYkxzPh=2jBZ=GRtFggYE1kMyLAfadaeghz0xA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Hi Neil,
we had the following crash:

[86399.862150] general protection fault: 0000 [#1] SMP
[86399.881970] CPU 1
[86399.882264] Pid: 17989, comm: md4_raid6 Tainted: GF       W  O
3.8.13-030813-generic #201305111843 Bochs Bochs
[86399.883681] RIP: 0010:[<ffffffff8135d446>]  [<ffffffff8135d446>]
memcpy+0x6/0x110
[86399.884886] RSP: 0018:ffff8800a78e5a80  EFLAGS: 00010286
[86399.885629] RAX: 4588966d912cea06 RBX: ffff8800a78e4000 RCX: 0000000000001000
[86399.886605] RDX: 0000000000001000 RSI: ffff8800a7ed2000 RDI: 4588966d912cea06
[86399.887586] RBP: ffff8800a78e5ae8 R08: 0000000000001000 R09: ffff8800a78e5b20
[86399.888603] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[86399.889593] R13: ffff8800a78e5b20 R14: 0000000000001000 R15: 0000000000000000
[86399.890551] FS:  0000000000000000(0000) GS:ffff88011fd00000(0000)
knlGS:0000000000000000
[86399.891648] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[86399.892504] CR2: 00007f10cb8ae966 CR3: 0000000113bfc000 CR4: 00000000001406e0
[86399.893493] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[86399.894458] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[86399.895426] Process md4_raid6 (pid: 17989, threadinfo
ffff8800a78e4000, task ffff8800a7dc0000)
[86399.896629] Stack:
[86399.896930]  ffffffffa05061c5 ffff88000ab6fa06 ffffffff816ed725
ffffea00029fb480
[86399.898005]  51160e39b619d7e4 0000000000000000 000000000ab6fa06
ffff8800c696b938
[86399.899082]  000000003eca7624 ffff880084dc1ac0 0000000000001000
0000000000000002
[86399.900293] Call Trace:
[86399.900660]  [<ffffffffa05061c5>] ? async_memcpy+0x1c5/0x1000 [async_memcpy]
[86399.901653]  [<ffffffff816ed725>] ? _raw_spin_lock_irq+0x15/0x20
[86399.902655]  [<ffffffffa05a5090>] async_copy_data+0x100/0x140 [raid456]
[86399.903557]  [<ffffffffa05abe20>] handle_stripe+0x13e0/0x2380 [raid456]
[86399.904531]  [<ffffffff815739de>] ? dm_dispatch_request+0x3e/0x70
[86399.905388]  [<ffffffff81097c33>] ? update_curr+0x143/0x1f0
[86399.906151]  [<ffffffff816eb03d>] ? mutex_lock+0x1d/0x50
[86399.906888]  [<ffffffffa05adea5>] handle_active_stripes+0x165/0x200 [raid456]
[86399.907857]  [<ffffffff8156ab8e>] ? md_check_recovery.part.49+0x3e/0x530
[86399.908811]  [<ffffffffa05ae28a>] raid5d+0x34a/0x570 [raid456]
[86399.909614]  [<ffffffff8156344d>] md_thread+0x10d/0x140
[86399.910356]  [<ffffffff8107fc10>] ? add_wait_queue+0x60/0x60
[86399.911149]  [<ffffffff81563340>] ? md_rdev_init+0x140/0x140
[86399.911955]  [<ffffffff8107f050>] kthread+0xc0/0xd0
[86399.912668]  [<ffffffff8107ef90>] ? flush_kthread_worker+0xb0/0xb0
[86399.913528]  [<ffffffff816f61ec>] ret_from_fork+0x7c/0xb0
[86399.914267]  [<ffffffff8107ef90>] ? flush_kthread_worker+0xb0/0xb0
[86399.915109] Code: 74 13 48 8b 43 58 48 2b 43 50 88 43 4e 48 83 c4
08 5b 5d c3 90 e8 fb fd ff ff eb e6 90 90 90 90 90 90 90 90 90 48 89
f8 48 89 d1 <f3> a4 c3 03 83 e2 07 f3 48 a5 89 d1 f3 a4 c3 20 4c 8b 06
4c 8b
[86399.919028] RIP  [<ffffffff8135d446>] memcpy+0x6/0x110

Can you maybe advise what is happening here? Our kernel is 3.8.13.

Thanks,
Alex.
