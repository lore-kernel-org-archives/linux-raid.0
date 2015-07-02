From: Shaohua Li <shli@fb.com>
Subject: Re: [PATCH V4 00/13] MD: a caching layer for raid5/6
Date: Thu, 2 Jul 2015 10:11:18 -0700
Message-ID: <20150702171104.GA683150@devbig257.prn2.facebook.com>
References: <cover.1435094582.git.shli@fb.com>
 <20150702032516.GB10378@yliu-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150702032516.GB10378@yliu-dev.sh.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: linux-raid@vger.kernel.org, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

On Thu, Jul 02, 2015 at 11:25:16AM +0800, Yuanhan Liu wrote:
> Hi Shaohua,
> 
> I gave it a quick test(dd if=/dev/zero of=/dev/md0) in a KVM, and
> here I met a kernel oops.
> 
>     [   14.768563] BUG: unable to handle kernel NULL pointer dereference at   (null)
>     [   14.769153] IP: [<c1383b13>] xor_sse_3_pf64+0x67/0x207
>     [   14.769585] *pde = 00000000
>     [   14.769822] Oops: 0000 [#1] SMP
>     [   14.770092] Modules linked in:
>     [   14.770349] CPU: 0 PID: 2234 Comm: md0_raid5 Not tainted 4.1.0+ #18
>     [   14.770854] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
>     [   14.771859] task: f62c5e80 ti: f04ec000 task.ti: f04ec000
>     [   14.772287] EIP: 0060:[<c1383b13>] EFLAGS: 00010246 CPU: 0
>     [   14.772327] EIP is at xor_sse_3_pf64+0x67/0x207
>     [   14.772327] EAX: 00000010 EBX: 00000000 ECX: e2a99000 EDX: f48ae000
>     [   14.772327] ESI: f48ae000 EDI: 00000010 EBP: f04edcd8 ESP: f04edccc
>     [   14.772327]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
>     [   14.772327] CR0: 80050033 CR2: 00000000 CR3: 22ac5000 CR4: 000006d0
>     [   14.772327] Stack:
>     [   14.772327]  c1c4d96c 00000000 00000001 f04edcf8 c1382bcf 00000000 00000002 c112d2e5
>     [   14.772327]  00000000 f04edd98 00000002 f04edd30 c138554b f6a2e028 00000001 f6f51b30
>     [   14.772327]  00000002 00000000 f48ae000 f6a2e028 00001000 f04edd40 00000002 00000000
>     [   14.772327] Call Trace:
>     [   14.772327]  [<c1382bcf>] xor_blocks+0x3a/0x6d
>     [   14.772327]  [<c112d2e5>] ? page_address+0xb8/0xc0
>     [   14.772327]  [<c138554b>] async_xor+0xf3/0x113
>     [   14.772327]  [<c186d954>] raid_run_ops+0xf73/0x1025
>     [   14.772327]  [<c186d954>] ? raid_run_ops+0xf73/0x1025
>     [   14.772327]  [<c16ce8b9>] handle_stripe+0x120/0x199b
>     [   14.772327]  [<c10c7df4>] ? clockevents_program_event+0xfb/0x118
>     [   14.772327]  [<c10c94f7>] ? tick_program_event+0x5f/0x68
>     [   14.772327]  [<c10be529>] ? hrtimer_interrupt+0xa3/0x134
>     [   14.772327]  [<c16d0366>] handle_active_stripes.isra.37+0x232/0x2b5
>     [   14.772327]  [<c16d0701>] raid5d+0x267/0x44c
>     [   14.772327]  [<c18717e6>] ? schedule_timeout+0x1c/0x14d
>     [   14.772327]  [<c1872011>] ? _raw_spin_lock_irqsave+0x1f/0x3d
>     [   14.772327]  [<c16f684a>] md_thread+0x103/0x112
>     [   14.772327]  [<c10a3146>] ? wait_woken+0x62/0x62
>     [   14.772327]  [<c16f6747>] ? md_wait_for_blocked_rdev+0xda/0xda
>     [   14.772327]  [<c108d44e>] kthread+0xa4/0xa9
>     [   14.772327]  [<c1872401>] ret_from_kernel_thread+0x21/0x30
>     [   14.772327]  [<c108d3aa>] ? kthread_create_on_node+0x104/0x104
>     
> 
> I dug it a while, and came up with following fix. Does it make sense
> to you?
> 
> ----
> diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
> index e1bce26..063ac50 100644
> --- a/crypto/async_tx/async_xor.c
> +++ b/crypto/async_tx/async_xor.c
> @@ -30,6 +30,7 @@
>  #include <linux/dma-mapping.h>
>  #include <linux/raid/xor.h>
>  #include <linux/async_tx.h>
> +#include <linux/highmem.h>
> 
>  /* do_async_xor - dma map the pages and perform the xor with an engine */
>  static __async_inline struct dma_async_tx_descriptor *
> @@ -127,7 +128,7 @@ do_sync_xor(struct page *dest, struct page **src_list, unsigned int offset,
>         /* convert to buffer pointers */
>         for (i = 0; i < src_cnt; i++)
>                 if (src_list[i])
> -                       srcs[xor_src_cnt++] = page_address(src_list[i]) + offset;
> +                       srcs[xor_src_cnt++] = kmap_atomic(src_list[i]) + offset;
>         src_cnt = xor_src_cnt;
>         /* set destination address */
>         dest_buf = page_address(dest) + offset;
> @@ -140,6 +141,9 @@ do_sync_xor(struct page *dest, struct page **src_list, unsigned int offset,
>                 xor_src_cnt = min(src_cnt, MAX_XOR_BLOCKS);
>                 xor_blocks(xor_src_cnt, len, dest_buf, &srcs[src_off]);
> 
> +               for(i = src_off; i < src_off + xor_src_cnt; i++)
> +                       kunmap_atomic(srcs[i]);
> +
>                 /* drop completed sources */
>                 src_cnt -= xor_src_cnt;
>                 src_off += xor_src_cnt;

Thanks! This is the side effect of skip_copy, I think. skip_copy isn't
enabled by default, so we don't hit it before, while my previous test
was done with x86_64. We should see this with skip_copy enabled even
without the cache patches.

The patch does make sense. There are other async APIs using page_address
too: async_raid6_recov.c, async_pq.c, can you please fix them? You can
check them with raid6.

Thanks,
Shaohua
