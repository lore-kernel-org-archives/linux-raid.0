From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: Re: [PATCH 1/3] raid5: call clear_batch_ready before set
 STRIPE_ACTIVE
Date: Fri, 19 Jun 2020 16:16:06 +0200
Message-ID: <acdb9e17-acf4-1e0e-f3cc-b90a1bf9748c@cloud.ionos.com>
References: <20200616092552.1754-1-guoqing.jiang@cloud.ionos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200616092552.1754-1-guoqing.jiang@cloud.ionos.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: song@kernel.org
List-Id: linux-raid.ids

On 6/16/20 11:25 AM, Guoqing Jiang wrote:
> [593764.644269] stripe state: 2003
> kernel: [593764.644299] ------------[ cut here ]------------
> kernel: [593764.644308] WARNING: CPU: 12 PID: 856 at drivers/md/raid5.c:4625 break_stripe_batch_list+0x203/0x240 [raid456]

This happens with our own kernel, so the line number can't match with 
upstream kernel.

static void break_stripe_batch_list(struct stripe_head *head_sh,
                                     unsigned long handle_flags)
{
         struct stripe_head *sh, *next;
         int i;
         int do_wakeup = 0;

         list_for_each_entry_safe(sh, next, &head_sh->batch_list, 
batch_list) {

                 list_del_init(&sh->batch_list);

*WARN_ONCE(sh->state & ((1 << STRIPE_ACTIVE) |*

The warning was happened at above line.

Thanks,
Guoqing
