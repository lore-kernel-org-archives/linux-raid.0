From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch]raid5: delete another BUG_ON
Date: Tue, 15 Apr 2014 09:12:54 +0800
Message-ID: <20140415011254.GA26852@kernel.org>
References: <20140414061417.GA26258@kernel.org>
 <20140415084703.46b99886@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140415084703.46b99886@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Apr 15, 2014 at 08:47:03AM +1000, NeilBrown wrote:
> On Mon, 14 Apr 2014 14:14:17 +0800 Shaohua Li <shli@kernel.org> wrote:
> 
> > 
> > I hit another BUG_ON with e240c1839d11152b0355442. In __get_priority_stripe(),
> > stripe count equals to 0 initially. Between atomic_inc and BUG_ON,
> > get_active_stripe() finds the stripe. So the stripe count isn't 1 any more.
> > 
> > Signed-off-by: Shaohua Li <shli@fusionio.com>
> > ---
> >  drivers/md/raid5.c |    1 -
> >  1 file changed, 1 deletion(-)
> > 
> > Index: linux/drivers/md/raid5.c
> > ===================================================================
> > --- linux.orig/drivers/md/raid5.c	2014-04-14 11:44:11.448492119 +0800
> > +++ linux/drivers/md/raid5.c	2014-04-14 11:52:19.158359774 +0800
> > @@ -4371,7 +4371,6 @@ static struct stripe_head *__get_priorit
> >  	}
> >  	list_del_init(&sh->lru);
> >  	atomic_inc(&sh->count);
> > -	BUG_ON(atomic_read(&sh->count) != 1);
> >  	return sh;
> >  }
> >  
> 
> What if we made those two lines:
>  
>   BUG_ON(atomic_inc_return(&sh->count) != 1);

Ok if we want to keep the BUG_ON.


Subject: raid5: fix a race of stripe count check

I hit another BUG_ON with e240c1839d11152b0355442. In __get_priority_stripe(),
stripe count equals to 0 initially. Between atomic_inc and BUG_ON,
get_active_stripe() finds the stripe. So the stripe count isn't 1 any more.

V2: keeps the BUG_ON suggested by Neil.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2014-04-15 08:17:02.061599785 +0800
+++ linux/drivers/md/raid5.c	2014-04-15 08:18:01.096857614 +0800
@@ -4370,8 +4370,7 @@ static struct stripe_head *__get_priorit
 		sh->group = NULL;
 	}
 	list_del_init(&sh->lru);
-	atomic_inc(&sh->count);
-	BUG_ON(atomic_read(&sh->count) != 1);
+	BUG_ON(atomic_inc_return(&sh->count) != 1);
 	return sh;
 }
 
