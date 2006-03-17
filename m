From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 005 of 13] md: Allow stripes to be expanded in
 preparation for expanding an array.
Date: Thu, 16 Mar 2006 21:57:39 -0800
Message-ID: <20060316215739.2b11cb82.akpm@osdl.org>
References: <20060317154017.15880.patches@notabene>
	<1060317044745.16072@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1060317044745.16072@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> wrote:
>
> +	/* Got them all.
>  +	 * Return the new ones and free the old ones.
>  +	 * At this point, we are holding all the stripes so the array
>  +	 * is completely stalled, so now is a good time to resize
>  +	 * conf->disks.
>  +	 */
>  +	ndisks = kzalloc(newsize * sizeof(struct disk_info), GFP_NOIO);
>  +	if (ndisks) {
>  +		for (i=0; i<conf->raid_disks; i++)
>  +			ndisks[i] = conf->disks[i];
>  +		kfree(conf->disks);
>  +		conf->disks = ndisks;
>  +	} else
>  +		err = -ENOMEM;
>  +	while(!list_empty(&newstripes)) {
>  +		nsh = list_entry(newstripes.next, struct stripe_head, lru);
>  +		list_del_init(&nsh->lru);
>  +		for (i=conf->raid_disks; i < newsize; i++)
>  +			if (nsh->dev[i].page == NULL) {
>  +				struct page *p = alloc_page(GFP_NOIO);
>  +				nsh->dev[i].page = p;
>  +				if (!p)
>  +					err = -ENOMEM;
>  +			}
>  +		release_stripe(nsh);
>  +	}
>  +	while(!list_empty(&oldstripes)) {
>  +		osh = list_entry(oldstripes.next, struct stripe_head, lru);
>  +		list_del(&osh->lru);
>  +		kmem_cache_free(conf->slab_cache, osh);
>  +	}
>  +	kmem_cache_destroy(conf->slab_cache);
>  +	conf->slab_cache = sc;
>  +	conf->active_name = 1-conf->active_name;
>  +	conf->pool_size = newsize;
>  +	return err;
>  +}

Are you sure the -ENOMEM handling here is solid?  It looks.... strange.

There are a few more GFP_NOIOs in this function, which can possibly become
GFP_KERNEL.
