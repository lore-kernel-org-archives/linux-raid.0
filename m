From: Byungchul Park <byungchul.park@lge.com>
Subject: Re: [PATCH v4] bcache: Don't reinvent the wheel but use existing
 llist API
Date: Tue, 5 Sep 2017 11:37:31 +0900
Message-ID: <20170905023731.GR3240@X58A-UD3R>
References: <1502426543-15229-1-git-send-email-byungchul.park@lge.com>
 <20170818012426.GX20323@X58A-UD3R>
 <34c37201-1ec8-270e-91b0-a8d94b7a7d6e@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <34c37201-1ec8-270e-91b0-a8d94b7a7d6e@coly.li>
Sender: linux-bcache-owner@vger.kernel.org
To: Coly Li <i@coly.li>
Cc: kent.overstreet@gmail.com, shli@kernel.org, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, nborisov@suse.com, linux-kernel@vger.kernel.org, kernel-team@lge.com
List-Id: linux-raid.ids

On Fri, Aug 18, 2017 at 02:04:20PM +0800, Coly Li wrote:
> On 2017/8/18 上午9:24, Byungchul Park wrote:
> > On Fri, Aug 11, 2017 at 01:42:23PM +0900, Byungchul Park wrote:
> >> Although llist provides proper APIs, they are not used. Make them used.
> > 
> > Any opinions about this?
> > 
> 
> The patch is good. If Eric has no time, I will take care of it later.

I would be appriciated if you take this at this window :)

> Thanks.
> 
> Coly
> 
> >>
> >> Signed-off-by: Byungchul Park <byungchul.park@lge.com>
> >> Acked-by: Coly Li <colyli@suse.de>
> >> ---
> >>  drivers/md/bcache/closure.c | 15 ++-------------
> >>  1 file changed, 2 insertions(+), 13 deletions(-)
> >>
> >> diff --git a/drivers/md/bcache/closure.c b/drivers/md/bcache/closure.c
> >> index 864e673..7d5286b 100644
> >> --- a/drivers/md/bcache/closure.c
> >> +++ b/drivers/md/bcache/closure.c
> >> @@ -70,21 +70,10 @@ void __closure_wake_up(struct closure_waitlist *wait_list)
> >>  	list = llist_del_all(&wait_list->list);
> >>  
> >>  	/* We first reverse the list to preserve FIFO ordering and fairness */
> >> -
> >> -	while (list) {
> >> -		struct llist_node *t = list;
> >> -		list = llist_next(list);
> >> -
> >> -		t->next = reverse;
> >> -		reverse = t;
> >> -	}
> >> +	reverse = llist_reverse_order(list);
> >>  
> >>  	/* Then do the wakeups */
> >> -
> >> -	while (reverse) {
> >> -		cl = container_of(reverse, struct closure, list);
> >> -		reverse = llist_next(reverse);
> >> -
> >> +	llist_for_each_entry(cl, reverse, list) {
> >>  		closure_set_waiting(cl, 0);
> >>  		closure_sub(cl, CLOSURE_WAITING + 1);
> >>  	}
> >> -- 
> >> 1.9.1
