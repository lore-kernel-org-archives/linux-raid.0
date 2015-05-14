From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: Re: [PATCH 3/3] md/raid5: per hash value and exclusive
 wait_for_stripe
Date: Thu, 14 May 2015 13:55:08 +0800
Message-ID: <20150514055508.GJ3124@yliu-dev.sh.intel.com>
References: <1430275735-20290-1-git-send-email-yuanhan.liu@linux.intel.com>
 <1430275735-20290-3-git-send-email-yuanhan.liu@linux.intel.com>
 <20150514154511.26b74f5b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150514154511.26b74f5b@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Thu, May 14, 2015 at 03:45:11PM +1000, NeilBrown wrote:
> On Wed, 29 Apr 2015 10:48:55 +0800 Yuanhan Liu <yuanhan.liu@linux.intel.com>
> wrote:
> 
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > index 64d5bea..697d77a 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> > @@ -344,7 +344,8 @@ static void release_inactive_stripe_list(struct r5conf *conf,
> >  					 int hash)
> >  {
> >  	int size;
> > -	bool do_wakeup = false;
> > +	unsigned long do_wakeup = 0;
> > +	int i = 0;
> >  	unsigned long flags;
> >  
> >  	if (hash == NR_STRIPE_HASH_LOCKS) {
> > @@ -365,15 +366,19 @@ static void release_inactive_stripe_list(struct r5conf *conf,
> >  			    !list_empty(list))
> >  				atomic_dec(&conf->empty_inactive_list_nr);
> >  			list_splice_tail_init(list, conf->inactive_list + hash);
> > -			do_wakeup = true;
> > +			do_wakeup |= 1 << (size - 1);
> >  			spin_unlock_irqrestore(conf->hash_locks + hash, flags);
> >  		}
> >  		size--;
> >  		hash--;
> >  	}
> >  
> > +	for (i = 0; i < NR_STRIPE_HASH_LOCKS; i++) {
> > +		if (do_wakeup & (1 << i))
> > +			wake_up(&conf->wait_for_stripe[i]);
> > +	}
> > +
> 
> hi,
>  I've been doing some testing and got a lock-up in resize_stripes, waiting
>  on wait_for_stripe[].
> 
>  Looking at the above code,  I think
>       do_wakeup |= 1 << (size - 1);
>  should be
>       do_wakeup |= 1 << hash;
> 
>  do you agree?  Or am I missing something?

Right. Sorry for the careless mistake.

	--yliu
