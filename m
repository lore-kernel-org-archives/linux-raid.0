From: Coly Li <i@coly.li>
Subject: Re: [PATCH 06/14] md/bcache: Use %pS printk format for direct
 addresses
Date: Thu, 7 Sep 2017 12:50:18 +0800
Message-ID: <29e5f2a8-c829-0aba-5b06-1501c98690a6@coly.li>
References: <1504729681-3504-1-git-send-email-deller@gmx.de>
 <1504729681-3504-7-git-send-email-deller@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1504729681-3504-7-git-send-email-deller@gmx.de>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Helge Deller <deller@gmx.de>
Cc: linux-kernel@vger.kernel.org, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Petr Mladek <pmladek@suse.com>, Andrew Morton <akpm@linux-foundation.org>, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2017/9/7 上午4:27, Helge Deller wrote:
> Use the %pS instead of the %pF printk format specifier for printing symbols
> from direct addresses. This is needed for the ia64, ppc64 and parisc64
> architectures.
> 
> Signed-off-by: Helge Deller <deller@gmx.de>
> Cc: linux-bcache@vger.kernel.org
> Cc: linux-raid@vger.kernel.org
> ---
>  drivers/md/bcache/closure.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/bcache/closure.c b/drivers/md/bcache/closure.c
> index 864e673..0b0c9bc 100644
> --- a/drivers/md/bcache/closure.c
> +++ b/drivers/md/bcache/closure.c
> @@ -175,7 +175,7 @@ static int debug_seq_show(struct seq_file *f, void *data)
>  	list_for_each_entry(cl, &closure_list, all) {
>  		int r = atomic_read(&cl->remaining);
>  
> -		seq_printf(f, "%p: %pF -> %pf p %p r %i ",
> +		seq_printf(f, "%p: %pS -> %pf p %p r %i ",
>  			   cl, (void *) cl->ip, cl->fn, cl->parent,
>  			   r & CLOSURE_REMAINING_MASK);
>  
> @@ -187,7 +187,7 @@ static int debug_seq_show(struct seq_file *f, void *data)
>  			   r & CLOSURE_SLEEPING	? "Sl" : "");
>  
>  		if (r & CLOSURE_WAITING)
> -			seq_printf(f, " W %pF\n",
> +			seq_printf(f, " W %pS\n",
>  				   (void *) cl->waiting_on);
>  
>  		seq_printf(f, "\n");
> 

It is unclear to me, that if %pF is used, on ia64/ppc64/parisc64 a
function descriptor conversion happens, what negative effect exactly
takes place ? Or you just want to unify the out put format, and get rid
of extra conversion information ?

Thanks.

-- 
Coly Li
