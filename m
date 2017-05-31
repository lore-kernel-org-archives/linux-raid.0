From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [PATCH] bcache: Fix a sleep-in-atomic bug
Date: Tue, 30 May 2017 23:52:10 -0800
Message-ID: <20170531075209.xrcvxp3uh3yjupiv@moria.home.lan>
References: <1496215420-15819-1-git-send-email-baijiaju1990@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1496215420-15819-1-git-send-email-baijiaju1990@163.com>
Sender: linux-bcache-owner@vger.kernel.org
To: Jia-Ju Bai <baijiaju1990@163.com>
Cc: shli@kernel.org, axboe@fb.com, mchristi@redhat.com, git@linux.ewheeler.net, colyli@suse.de, akpm@linux-foundation.org, wangyijing@huawei.com, mingo@kernel.org, mhocko@suse.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Wed, May 31, 2017 at 03:23:40PM +0800, Jia-Ju Bai wrote:
> The driver may sleep under a spin lock, and the function call path is:
> journal_wait_for_write (acquire the lock by spin_lock)
>   closure_sync
>     schedule --> may sleep

This patch is incorrect, you've introduced a double unlock.

Did you actually observe a sleep in atomic?

> 
> To fix it, the lock is released before "closure_sync", and the lock is 
> acquired again after this function.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>
> ---
>  drivers/md/bcache/journal.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
> index 1198e53..ad47c36 100644
> --- a/drivers/md/bcache/journal.c
> +++ b/drivers/md/bcache/journal.c
> @@ -724,6 +724,7 @@ static struct journal_write *journal_wait_for_write(struct cache_set *c,
>  			btree_flush_write(c);
>  		}
>  
> +		spin_unlock(&c->journal.lock);
>  		closure_sync(&cl);
>  		spin_lock(&c->journal.lock);
>  		wait = true;
> -- 
> 1.7.9.5
> 
> 
