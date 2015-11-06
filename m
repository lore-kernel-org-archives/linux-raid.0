From: Jiri Kosina <jikos@kernel.org>
Subject: Re: [PATCH] bcache: Really show state of work pending bit
Date: Fri, 6 Nov 2015 20:55:17 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1511061507140.23146@pobox.suse.cz>
References: <1444048792-22847-1-git-send-email-pmladek@suse.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444048792-22847-1-git-send-email-pmladek@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Petr Mladek <pmladek@suse.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, Tejun Heo <tj@kernel.org>, Neil Brown <neilb@suse.com>, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 5 Oct 2015, Petr Mladek wrote:

> WORK_STRUCT_PENDING is a mask for testing the pending bit.
> test_bit() expects the number of the bit and we need to
> use WORK_STRUCT_PENDING_BIT there.
> 
> Also work_data_bits() is defined in workqueues.h now.
> 
> I have noticed this just by chance when looking how
> WORK_STRUCT_PENDING_BIT is used. The change is compile
> tested.
> 
> Signed-off-by: Petr Mladek <pmladek@suse.com>
> ---
>  drivers/md/bcache/closure.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/md/bcache/closure.c b/drivers/md/bcache/closure.c
> index 7a228de95fd7..9eaf1d6e8302 100644
> --- a/drivers/md/bcache/closure.c
> +++ b/drivers/md/bcache/closure.c
> @@ -167,8 +167,6 @@ EXPORT_SYMBOL(closure_debug_destroy);
>  
>  static struct dentry *debug;
>  
> -#define work_data_bits(work) ((unsigned long *)(&(work)->data))
> -
>  static int debug_seq_show(struct seq_file *f, void *data)
>  {
>  	struct closure *cl;
> @@ -182,7 +180,7 @@ static int debug_seq_show(struct seq_file *f, void *data)
>  			   r & CLOSURE_REMAINING_MASK);
>  
>  		seq_printf(f, "%s%s%s%s\n",
> -			   test_bit(WORK_STRUCT_PENDING,
> +			   test_bit(WORK_STRUCT_PENDING_BIT,

I don't see this in linux-next as of today, so I am picking it up for 4.4.

-- 
Jiri Kosina 
SUSE Labs
