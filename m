From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: Re: [PATCH] md/raid5: init batch_xxx for new sh at resize_stripes
Date: Mon, 4 May 2015 15:51:03 +0800
Message-ID: <20150504075103.GH3858@yliu-dev.sh.intel.com>
References: <1430718624-8988-1-git-send-email-yuanhan.liu@linux.intel.com>
 <20150504172424.283b7727@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150504172424.283b7727@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Shaohua Li <shli@kernel.org>, Fengguang Wu <fengguang.wu@intel.com>
List-Id: linux-raid.ids

On Mon, May 04, 2015 at 05:24:24PM +1000, NeilBrown wrote:
> On Mon,  4 May 2015 13:50:24 +0800 Yuanhan Liu <yuanhan.liu@linux.intel.com>
> wrote:
> 
> > This is to fix a kernel NULL dereference oops introduced by commit
> > 59fc630b("RAID5: batch adjacent full stripe write"), which introduced
> > several batch_xxx fields, and did initiation for them at grow_one_stripes(),
> > but forgot to do same at resize_stripes().
> > 
> > This oops can be easily triggered by following steps:
> > 
> >     __create RAID5 /dev/md0
> >     __grow /dev/md0
> >     mdadm --wait /dev/md0
> >     dd if=/dev/zero of=/dev/md0
> > 
> > Here is the detailed oops log:
...
> > 
> > Cc: Shaohua Li <shli@kernel.org>
> > Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> > ---
> >  drivers/md/raid5.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > index 697d77a..7b074f7 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> > @@ -2217,6 +2217,10 @@ static int resize_stripes(struct r5conf *conf, int newsize)
> >  				if (!p)
> >  					err = -ENOMEM;
> >  			}
> > +
> > +		spin_lock_init(&nsh->batch_lock);
> > +		INIT_LIST_HEAD(&nsh->batch_list);
> > +		nsh->batch_head = NULL;
> >  		release_stripe(nsh);
> >  	}
> >  	/* critical section pass, GFP_NOIO no longer needed */
> 
> Thanks!
> 
> However I already have the following fix queued - though not pushed  out

Yeah, much cleaner.


> you.  I probably would have got it into -rc2 except that I was chasing
> another raid5 bug.  The
> 	BUG_ON(sh->batch_head);
> 
> in handle_stripe_fill() fires when I run the mdadm selftests.  I got caught
> up chasing that and didn't push the other fix.

I am not aware of there is a selftests for raid. I'd like to add it to our 0day
kernel testing in near future so that we could catch bugs and bisect it down in
first time ;)

	--yliu
> 
> 
> From 3dd8ba734349e602fe17d647ce3da5f4a13748aa Mon Sep 17 00:00:00 2001
> From: NeilBrown <neilb@suse.de>
> Date: Thu, 30 Apr 2015 11:24:28 +1000
> Subject: [PATCH] md/raid5 new alloc_stripe function.
> 
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 77dfd720aaa0..91a1e8b26b52 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -1971,17 +1971,30 @@ static void raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
>  	put_cpu();
>  }
>  
> +static struct stripe_head *alloc_stripe(struct kmem_cache *sc, gfp_t gfp)
> +{
> +	struct stripe_head *sh;
> +
> +	sh = kmem_cache_zalloc(sc, gfp);
> +	if (sh) {
> +		spin_lock_init(&sh->stripe_lock);
> +		spin_lock_init(&sh->batch_lock);
> +		INIT_LIST_HEAD(&sh->batch_list);
> +		INIT_LIST_HEAD(&sh->lru);
> +		atomic_set(&sh->count, 1);
> +	}
> +	return sh;
> +}
>  static int grow_one_stripe(struct r5conf *conf, gfp_t gfp)
>  {
>  	struct stripe_head *sh;
> -	sh = kmem_cache_zalloc(conf->slab_cache, gfp);
> +
> +	sh = alloc_stripe(conf->slab_cache, gfp);
>  	if (!sh)
>  		return 0;
>  
>  	sh->raid_conf = conf;
>  
> -	spin_lock_init(&sh->stripe_lock);
> -
>  	if (grow_buffers(sh, gfp)) {
>  		shrink_buffers(sh);
>  		kmem_cache_free(conf->slab_cache, sh);
> @@ -1990,13 +2003,8 @@ static int grow_one_stripe(struct r5conf *conf, gfp_t gfp)
>  	sh->hash_lock_index =
>  		conf->max_nr_stripes % NR_STRIPE_HASH_LOCKS;
>  	/* we just created an active stripe so... */
> -	atomic_set(&sh->count, 1);
>  	atomic_inc(&conf->active_stripes);
> -	INIT_LIST_HEAD(&sh->lru);
>  
> -	spin_lock_init(&sh->batch_lock);
> -	INIT_LIST_HEAD(&sh->batch_list);
> -	sh->batch_head = NULL;
>  	release_stripe(sh);
>  	conf->max_nr_stripes++;
>  	return 1;
> @@ -2109,13 +2117,11 @@ static int resize_stripes(struct r5conf *conf, int newsize)
>  		return -ENOMEM;
>  
>  	for (i = conf->max_nr_stripes; i; i--) {
> -		nsh = kmem_cache_zalloc(sc, GFP_KERNEL);
> +		nsh = alloc_stripe(sc, GFP_KERNEL);
>  		if (!nsh)
>  			break;
>  
>  		nsh->raid_conf = conf;
> -		spin_lock_init(&nsh->stripe_lock);
> -
>  		list_add(&nsh->lru, &newstripes);
>  	}
>  	if (i) {
> @@ -2142,13 +2148,11 @@ static int resize_stripes(struct r5conf *conf, int newsize)
>  				    lock_device_hash_lock(conf, hash));
>  		osh = get_free_stripe(conf, hash);
>  		unlock_device_hash_lock(conf, hash);
> -		atomic_set(&nsh->count, 1);
> +
>  		for(i=0; i<conf->pool_size; i++) {
>  			nsh->dev[i].page = osh->dev[i].page;
>  			nsh->dev[i].orig_page = osh->dev[i].page;
>  		}
> -		for( ; i<newsize; i++)
> -			nsh->dev[i].page = NULL;
>  		nsh->hash_lock_index = hash;
>  		kmem_cache_free(conf->slab_cache, osh);
>  		cnt++;
> 


