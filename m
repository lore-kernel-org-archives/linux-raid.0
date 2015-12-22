From: Stanislav Samsonov <slava@annapurnalabs.com>
Subject: raid5 async_xor: sleep in atomic
Date: Tue, 22 Dec 2015 13:58:33 +0200
Message-ID: <CAFskJNhmU-N5_odOZV54x10Ku=7SSDnaMz5EtCbKddye+AGReg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Kernel 4.1.3 : there is some troubling kernel message that shows up
after enabling CONFIG_DEBUG_ATOMIC_SLEEP and testing DMA XOR
acceleration for raid5:

BUG: sleeping function called from invalid context at mm/mempool.c:320
in_atomic(): 1, irqs_disabled(): 0, pid: 1048, name: md127_raid5
INFO: lockdep is turned off.
CPU: 1 PID: 1048 Comm: md127_raid5 Not tainted 4.1.15.alpine.1-dirty #1
Hardware name: Annapurna Labs Alpine
[<c00169d8>] (unwind_backtrace) from [<c0012a78>] (show_stack+0x10/0x14)
[<c0012a78>] (show_stack) from [<c07462ec>] (dump_stack+0x80/0xb4)
[<c07462ec>] (dump_stack) from [<c00bf2f0>] (mempool_alloc+0x68/0x13c)
[<c00bf2f0>] (mempool_alloc) from [<c041c9b4>]
(dmaengine_get_unmap_data+0x24/0x4c)
[<c041c9b4>] (dmaengine_get_unmap_data) from [<c03a8084>]
(async_xor_val+0x60/0x3a0)
[<c03a8084>] (async_xor_val) from [<c058e4c0>] (raid_run_ops+0xb70/0x1248)
[<c058e4c0>] (raid_run_ops) from [<c05915d4>] (handle_stripe+0x1068/0x22a8)
[<c05915d4>] (handle_stripe) from [<c0592ae4>]
(handle_active_stripes+0x2d0/0x3dc)
[<c0592ae4>] (handle_active_stripes) from [<c059300c>] (raid5d+0x384/0x5b0)
[<c059300c>] (raid5d) from [<c059db6c>] (md_thread+0x114/0x138)
[<c059db6c>] (md_thread) from [<c0042d54>] (kthread+0xe4/0x104)
[<c0042d54>] (kthread) from [<c000f658>] (ret_from_fork+0x14/0x3c)

The reason is that async_xor_val() in crypto/async_tx/async_xor.c is
called in atomic context (preemption disabled) by raid_run_ops(). Then
it calls dmaengine_get_unmap_data() an then mempool_alloc() with
GFP_NOIO flag - this allocation type might sleep under some condition.

Checked latest kernel 4.3 and it has exactly same flow.

Any advice regarding this issue?

Thanks,
Slava Samsonov
