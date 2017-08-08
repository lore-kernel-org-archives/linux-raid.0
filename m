From: Byungchul Park <byungchul.park@lge.com>
Subject: Re: [RESEND PATCH] bcache: Don't reinvent the wheel but use existing
 llist API
Date: Tue, 8 Aug 2017 13:12:33 +0900
Message-ID: <20170808041233.GR20323@X58A-UD3R>
References: <1502095121-14337-1-git-send-email-byungchul.park@lge.com>
 <b37c4038-d95f-ca81-5789-825ebfc6d425@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b37c4038-d95f-ca81-5789-825ebfc6d425@coly.li>
Sender: linux-kernel-owner@vger.kernel.org
To: Coly Li <i@coly.li>
Cc: kent.overstreet@gmail.com, shli@kernel.org, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@lge.com
List-Id: linux-raid.ids

On Mon, Aug 07, 2017 at 06:18:35PM +0800, Coly Li wrote:
> On 2017/8/7 下午4:38, Byungchul Park wrote:
> > Although llist provides proper APIs, they are not used. Make them used.
> > 
> > Signed-off-by: Byungchul Park <byungchul.park@lge.com
> Only have a question about why not using llist_for_each_entry(), it's

Hello,

The reason is to keep the original logic unchanged. The logic already
does as if it's the safe version against removal.

> still OK with llist_for_each_entry_safe(). The rested part is good to me.
> 
> Acked-by: Coly Li <colyli@suse.de>
> 
> > ---
> >  drivers/md/bcache/closure.c | 17 +++--------------
> >  1 file changed, 3 insertions(+), 14 deletions(-)
> > 
> > diff --git a/drivers/md/bcache/closure.c b/drivers/md/bcache/closure.c
> > index 864e673..1841d03 100644
> > --- a/drivers/md/bcache/closure.c
> > +++ b/drivers/md/bcache/closure.c
> > @@ -64,27 +64,16 @@ void closure_put(struct closure *cl)
> >  void __closure_wake_up(struct closure_waitlist *wait_list)
> >  {
> >  	struct llist_node *list;
> > -	struct closure *cl;
> > +	struct closure *cl, *t;
> >  	struct llist_node *reverse = NULL;
> >  
> >  	list = llist_del_all(&wait_list->list);
> >  
> >  	/* We first reverse the list to preserve FIFO ordering and fairness */
> > -
> > -	while (list) {
> > -		struct llist_node *t = list;
> > -		list = llist_next(list);
> > -
> > -		t->next = reverse;
> > -		reverse = t;
> > -	}
> > +	reverse = llist_reverse_order(list);
> >  
> >  	/* Then do the wakeups */
> > -
> > -	while (reverse) {
> > -		cl = container_of(reverse, struct closure, list);
> > -		reverse = llist_next(reverse);
> > -
> > +	llist_for_each_entry_safe(cl, t, reverse, list) {
> 
> Just wondering why not using llist_for_each_entry(), or you use the
> _safe version on purpose ?

If I use llist_for_each_entry(), then it would change the original
behavior. Is it ok?

Thank you,
Byungchul
