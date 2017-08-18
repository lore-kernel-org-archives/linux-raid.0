From: Byungchul Park <byungchul.park@lge.com>
Subject: Re: [PATCH v4] bcache: Don't reinvent the wheel but use existing
 llist API
Date: Fri, 18 Aug 2017 10:24:26 +0900
Message-ID: <20170818012426.GX20323@X58A-UD3R>
References: <1502426543-15229-1-git-send-email-byungchul.park@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1502426543-15229-1-git-send-email-byungchul.park@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
To: kent.overstreet@gmail.com, shli@kernel.org
Cc: linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, i@coly.li, nborisov@suse.com, linux-kernel@vger.kernel.org, kernel-team@lge.com
List-Id: linux-raid.ids

On Fri, Aug 11, 2017 at 01:42:23PM +0900, Byungchul Park wrote:
> Although llist provides proper APIs, they are not used. Make them used.

Any opinions about this?

> 
> Signed-off-by: Byungchul Park <byungchul.park@lge.com>
> Acked-by: Coly Li <colyli@suse.de>
> ---
>  drivers/md/bcache/closure.c | 15 ++-------------
>  1 file changed, 2 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/md/bcache/closure.c b/drivers/md/bcache/closure.c
> index 864e673..7d5286b 100644
> --- a/drivers/md/bcache/closure.c
> +++ b/drivers/md/bcache/closure.c
> @@ -70,21 +70,10 @@ void __closure_wake_up(struct closure_waitlist *wait_list)
>  	list = llist_del_all(&wait_list->list);
>  
>  	/* We first reverse the list to preserve FIFO ordering and fairness */
> -
> -	while (list) {
> -		struct llist_node *t = list;
> -		list = llist_next(list);
> -
> -		t->next = reverse;
> -		reverse = t;
> -	}
> +	reverse = llist_reverse_order(list);
>  
>  	/* Then do the wakeups */
> -
> -	while (reverse) {
> -		cl = container_of(reverse, struct closure, list);
> -		reverse = llist_next(reverse);
> -
> +	llist_for_each_entry(cl, reverse, list) {
>  		closure_set_waiting(cl, 0);
>  		closure_sub(cl, CLOSURE_WAITING + 1);
>  	}
> -- 
> 1.9.1
