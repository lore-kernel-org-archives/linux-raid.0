From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 0/3] md fixes for 2.6.32-rc
Date: Wed, 7 Oct 2009 15:34:51 +1100
Message-ID: <19148.6763.744052.261830@notabene.brown>
References: <20091002011747.24095.70355.stgit@dwillia2-linux.ch.intel.com>
	<19141.32211.742547.19481@notabene.brown>
	<1254875779.16798.10.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Tuesday October 6
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On Tuesday October 6, dan.j.williams@intel.com wrote:
> >From 0496c92cf6ac1f4f7dde6d416707988991d87d41 Mon Sep 17 00:00:00 2001
> From: Dan Williams <dan.j.williams@intel.com>
> Date: Sat, 3 Oct 2009 13:47:05 -0700
> Subject: [PATCH] md/raid456: downlevel multicore operations to raid_run_ops
> 
> The percpu conversion allowed a straightforward handoff of stripe
> processing to the async subsytem that initially showed some modest gains
> (+4%).  However, this model is too simplistic and leads to stripes
> bouncing between raid5d and the async thread pool for every invocation
> of handle_stripe().  As reported by Holger this can fall into a
> pathological situation severely impacting throughput (6x performance
> loss).
> 
> By downleveling the parallelism to raid_run_ops the pathological
> stripe_head bouncing is eliminated.  This version still exhibits an
> average 11% throughput loss for:
> 
> 	mdadm --create /dev/md0 /dev/sd[b-q] -n 16 -l 6
> 	echo 1024 > /sys/block/md0/md/stripe_cache_size
> 	dd if=/dev/zero of=/dev/md0 bs=1024k count=2048
> 
> ...but the results are at least stable and can be used as a base for
> further multicore experimentation.

Thanks.

One little change needed:


>  static int grow_one_stripe(raid5_conf_t *conf)
>  {
>  	struct stripe_head *sh;
> @@ -1213,6 +1243,9 @@ static int grow_one_stripe(raid5_conf_t *conf)
>  	memset(sh, 0, sizeof(*sh) + (conf->raid_disks-1)*sizeof(struct r5dev));
>  	sh->raid_conf = conf;
>  	spin_lock_init(&sh->lock);
> +	#ifdef CONFIG_MULTICORE_RAID456
> +	init_waitqueue_head(&sh->ops.wait_for_ops);
> +	#endif
>  
>  	if (grow_buffers(sh, conf->raid_disks)) {
>  		shrink_buffers(sh, conf->raid_disks);

This addition is needed in resize_stripes too.

NeilBrown
