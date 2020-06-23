From: Song Liu <song@kernel.org>
Subject: Re: [PATCH 1/3] raid5: call clear_batch_ready before set STRIPE_ACTIVE
Date: Tue, 23 Jun 2020 16:58:56 -0700
Message-ID: <CAPhsuW70kML70Xi3MhubCGBWnLDg0L7sPKwKe9HZHsQHwtzEEQ@mail.gmail.com>
References: <20200616092552.1754-1-guoqing.jiang@cloud.ionos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200616092552.1754-1-guoqing.jiang@cloud.ionos.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Jun 16, 2020 at 2:25 AM Guoqing Jiang
<guoqing.jiang@cloud.ionos.com> wrote:
>
> We tried to only put the head sh of batch list to handle_list, then the
> handle_stripe doesn't handle other members in the batch list. However,
> we still got the calltrace in break_stripe_batch_list.
>
> [593764.644269] stripe state: 2003
> kernel: [593764.644299] ------------[ cut here ]------------
> kernel: [593764.644308] WARNING: CPU: 12 PID: 856 at drivers/md/raid5.c:4625 break_stripe_batch_list+0x203/0x240 [raid456]
> [...]
> kernel: [593764.644363] Call Trace:
> kernel: [593764.644370]  handle_stripe+0x907/0x20c0 [raid456]
> kernel: [593764.644376]  ? __wake_up_common_lock+0x89/0xc0
> kernel: [593764.644379]  handle_active_stripes.isra.57+0x35f/0x570 [raid456]
> kernel: [593764.644382]  ? raid5_wakeup_stripe_thread+0x96/0x1f0 [raid456]
> kernel: [593764.644385]  raid5d+0x480/0x6a0 [raid456]
> kernel: [593764.644390]  ? md_thread+0x11f/0x160
> kernel: [593764.644392]  md_thread+0x11f/0x160
> kernel: [593764.644394]  ? wait_woken+0x80/0x80
> kernel: [593764.644396]  kthread+0xfc/0x130
> kernel: [593764.644398]  ? find_pers+0x70/0x70
> kernel: [593764.644399]  ? kthread_create_on_node+0x70/0x70
> kernel: [593764.644401]  ret_from_fork+0x1f/0x30
>
> As we can see, the stripe was set with STRIPE_ACTIVE and STRIPE_HANDLE,
> and only handle_stripe could set those flags then return. And since the
> stipe was already in the batch list, we need to return earlier before
> set the two flags.
>
> And after dig a little about git history especially commit 3664847d95e6
> ("md/raid5: fix a race condition in stripe batch"), it seems the batched
> stipe still could be handled by handle_stipe, then handle_stipe needs to
> return earlier if clear_batch_ready to return true.
>
> Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
> ---
> Another alternative would be just not warn if STRIPE_ACTIVE is valid for
> the batched list.
>
> What do you think?
>

This patch looks good to me (haven't tested yet). Let's try with this one.

Thanks,
Song
