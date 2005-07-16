From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [patch] linear does not need chunksize
Date: Sun, 17 Jul 2005 09:22:10 +1000
Message-ID: <17113.38562.489541.760889@cse.unsw.edu.au>
References: <20050716231236.1851A8DC9@gandalf.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Michael Tokarev on Sunday July 17
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday July 17, mjt@tls.msk.ru wrote:
> When debugging some weird raid failure case, we come
> across a problem when kernel disallows assembling a
> linear array with zero chunksize, printing
> 'no chunksize specified' in dmesg and mdadm failing
> with EINVAL.  The following patch fixes the problem
> (the patch is with large context to show why the change).
> 
> Note chunk size is never used on linear array.  The
> only usage of chunk_size member is in /proc/mdstat,
> as "rounding" parameter (linear.c) - looks like it
> should be removed too.

This statement isn't entirely true, though it took me a little while
to remind myself exactly how linear.c does use chunk_size.

linear_run in linear.c uses rdev->size for each devices.
in md.c rdev->size is set by a call to calc_dev_size()
calc_dev_size *does* use chunk_size (if it is non-zero)

However that doesn't make your patch wrong, as a zero chunk size
certainly seems to be handled correctly by linear.  However I might
spend a little while reviewing that aspect of the code before I pass
on this patch.

Thanks,
NeilBrown


> 
> Signed-Off-By: Michael Tokarev <mjt@tls.msk.ru>
> 
> --- linux-2.6.12/drivers/md/md.c.orig	2005-06-17 23:48:29.000000000 +0400
> +++ linux-2.6.12/drivers/md/md.c	2005-07-17 03:07:05.000000000 +0400
> @@ -1516,21 +1516,21 @@ static int do_md_run(mddev_t * mddev)
>  
>  	/*
>  	 * Analyze all RAID superblock(s)
>  	 */
>  	if (!mddev->raid_disks)
>  		analyze_sbs(mddev);
>  
>  	chunk_size = mddev->chunk_size;
>  	pnum = level_to_pers(mddev->level);
>  
> -	if ((pnum != MULTIPATH) && (pnum != RAID1)) {
> +	if ((pnum != MULTIPATH) && (pnum != RAID1) && (pnum != LINEAR)) {
>  		if (!chunk_size) {
>  			/*
>  			 * 'default chunksize' in the old md code used to
>  			 * be PAGE_SIZE, baaad.
>  			 * we abort here to be on the safe side. We don't
>  			 * want to continue the bad practice.
>  			 */
>  			printk(KERN_ERR 
>  				"no chunksize specified, see 'man raidtab'\n");
>  			return -EINVAL;
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
