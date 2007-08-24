From: Neil Brown <neilb@suse.de>
Subject: Re: [patch 1/1] md: Software Raid autodetect dev list not array
Date: Fri, 24 Aug 2007 13:37:29 +1000
Message-ID: <18126.21113.981032.286298@notabene.brown>
References: <200708222058.45480.mjevans1983@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Michael J. Evans on Wednesday August 22
Sender: linux-raid-owner@vger.kernel.org
To: "Michael J. Evans" <mjevans1983@comcast.net>
Cc: Ingo Molnar <mingo@redhat.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Michael J . Evans" <mjevans1983@gmail.com>
List-Id: linux-raid.ids

On Wednesday August 22, mjevans1983@comcast.net wrote:
> From: Michael J. Evans <mjevans1983@gmail.com>
> 
> In current release kernels the md module (Software RAID) uses a static array
>  (dev_t[128]) to store partition/device info temporarily for autostart.
> 
> This patch replaces that static array with a list.

I must admit that I'm not very keen on this.
I would much rather that in-kernel autodetect were deprecated rather
than enhanced.

Just use 'mdadm' in an initrd, or during normal boot, to assemble all
your arrays.

However.....

> =============================================================
> --- linux/drivers/md/md.c.orig	2007-08-21 03:19:42.511576248 -0700
> +++ linux/drivers/md/md.c	2007-08-21 04:30:09.775525710 -0700
> @@ -24,4 +24,6 @@
> 
> +   - autodetect dev list not array: Michael J. Evans <mjevans1983@gmail.com>
> +
>     This program is free software; you can redistribute it and/or modify
>     it under the terms of the GNU General Public License as published by
>     the Free Software Foundation; either version 2, or (at your option)
> @@ -5752,13 +5754,25 @@ void md_autodetect_dev(dev_t dev)
>   * Searches all registered partitions for autorun RAID arrays
>   * at boot time.
>   */
> -static dev_t detected_devices[128];
> -static int dev_cnt;
> +
> +static LIST_HEAD(all_detected_devices);
> +/* FIXME : Should these 4 lines instead go in to include/linux/raid/md_k.h ? 

No.  No-one outside this file uses them, so they are fine where they
are.

> */
> +struct detected_devices_node {
> +	struct list_head list;
> +	dev_t dev;
> +};
>  
>  void md_autodetect_dev(dev_t dev)
>  {
> -	if (dev_cnt >= 0 && dev_cnt < 127)
> -		detected_devices[dev_cnt++] = dev;
> +	struct detected_devices_node *node_detected_dev;
> +	node_detected_dev = kzalloc(sizeof(*node_detected_dev), GFP_KERNEL);\
> +	if (node_detected_dev) {
> +		node_detected_dev->dev = dev;
> +		list_add(&node_detected_dev->list, &all_detected_devices);

Probably list_add_tail would be better so the ordering is the same as
it was before?


> +	} else {
> +		printk(KERN_CRIT "md: kzAlloc node failed, skipping device."
> +				 " : 0x%p.\n", node_detected_dev);
> +	}



>  }
>  
>  
> @@ -5765,7 +5779,13 @@ static void autostart_arrays(int part)
>  static void autostart_arrays(int part)
>  {
>  	mdk_rdev_t *rdev;
> -	int i;
> +	struct detected_devices_node *node_detected_dev;
> +	dev_t dev;
> +	int i_scanned, i_passed, i_loops;
> +	signed int i_found;
> +	i_scanned = 0;
> +	i_passed = 0;
> +	i_loops = 0;

i_passed is never used.

And what is the point of i_loops (and i_scanned)?  The comments
at the top of the patch should explain this if there is a good reason.

>  
>  	printk(KERN_INFO "md: Autodetecting RAID arrays.\n");
>  
> @@ -5772,3 +5792,11 @@ static void autostart_arrays(int part)
> -	for (i = 0; i < dev_cnt; i++) {
> -		dev_t dev = detected_devices[i];
> -
> +		/* FIXME: max 'int' #DEFINEd somewhere?  not   0x7FFFFFFF ? */
> +	while (!list_empty(&all_detected_devices) && i_loops < 0x7FFFFFFF) {
> +		i_scanned++;
> +		node_detected_dev = NULL;
> +		node_detected_dev = list_entry(all_detected_devices.next,
> +					struct detected_devices_node, list);
> +		if (node_detected_dev) {

list_entry will *never* return NULL.   It simply doesn't pointer
arithmetic.  (Well, I guess it could return NULL if it was passed
NULL, and the struct-offset were 0, but that isn't the case here).

So you don't need this 'if' at all.

> +			list_del(&node_detected_dev->list);
> +			dev = node_detected_dev->dev;
> +			kfree(node_detected_dev);
> +		/* Indent is now off by one, but the old code is after this. */

so you don't need to worrying about indents.


> @@ -5781,8 +5809,16 @@ static void autostart_arrays(int part)
>  			continue;
>  		}
>  		list_add(&rdev->same_set, &pending_raid_disks);
> +		/* Indent is now off by one, but the old code is above this. */
> +
> +		} else {
> +			printk(KERN_CRIT "md: Invalid list node, skipping.\n");
> +		}
> +		i_loops++;
>  	}
> -	dev_cnt = 0;
> +
> +	printk(KERN_INFO "md: Passes %d : Scanned %d and added %d devices.\n",
> +						i_loops, i_scanned, i_passed);
>  
>  	autorun_devices(part);
>  }


I'm not dead-set against the change, and if you tidy it up I'll
probably accept it, but I really think you would be better off skipping
the in-kernel autodetect stuff altogether and use mdadm to assemble
your arrays.

NeilBrown
