From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 005 of 13] md: Allow stripes to be expanded in
 preparation for expanding an array.
Date: Thu, 16 Mar 2006 21:50:47 -0800
Message-ID: <20060316215047.65f411d4.akpm@osdl.org>
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
> +static int resize_stripes(raid5_conf_t *conf, int newsize)
>  +{
>  +	/* make all the stripes able to hold 'newsize' devices.
>  +	 * New slots in each stripe get 'page' set to a new page.
>  +	 * We allocate all the new stripes first, then if that succeeds,
>  +	 * copy everything across.
>  +	 * Finally we add new pages.  This could fail, but we leave
>  +	 * the stripe cache at it's new size, just with some pages empty.
>  +	 *
>  +	 * We use GFP_NOIO allocations as IO to the raid5 is blocked
>  +	 * at some points in this operation.
>  +	 */
>  +	struct stripe_head *osh, *nsh;
>  +	struct list_head newstripes, oldstripes;

You can use LIST_HEAD() here, avoid the separate INIT_LIST_HEAD().


>  +	struct disk_info *ndisks;
>  +	int err = 0;
>  +	kmem_cache_t *sc;
>  +	int i;
>  +
>  +	if (newsize <= conf->pool_size)
>  +		return 0; /* never bother to shrink */
>  +
>  +	sc = kmem_cache_create(conf->cache_name[1-conf->active_name],
>  +			       sizeof(struct stripe_head)+(newsize-1)*sizeof(struct r5dev),
>  +			       0, 0, NULL, NULL);

kmem_cache_create() internally does a GFP_KERNEL allocation.

>  +	if (!sc)
>  +		return -ENOMEM;
>  +	INIT_LIST_HEAD(&newstripes);
>  +	for (i = conf->max_nr_stripes; i; i--) {
>  +		nsh = kmem_cache_alloc(sc, GFP_NOIO);

So either this can use GFP_KERNEL, or we have a problem.
