From: Neil Brown <neilb@suse.de>
Subject: Re: + md-raid10-fix-use-after-free-of-bio.patch added to -mm tree
Date: Mon, 30 Jul 2007 17:34:02 +1000
Message-ID: <18093.37994.408428.500569@notabene.brown>
References: <200707290655.l6T6tOfA012547@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from akpm@linux-foundation.org on Saturday July 28
Sender: linux-raid-owner@vger.kernel.org
To: akpm@linux-foundation.org
Cc: m.hampel@gmx.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday July 28, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      md: raid10: fix use-after-free of bio
> has been added to the -mm tree.  Its filename is
>      md-raid10-fix-use-after-free-of-bio.patch
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> out what to do about this
> 
> ------------------------------------------------------
> Subject: md: raid10: fix use-after-free of bio
> From: Maik Hampel <m.hampel@gmx.de>
> 
> In case of read errors raid10d tries to print a nice error message,
> unfortunately using data from an already put bio.
> 

Thanks for catching that Maik!

> 
> diff -puN drivers/md/raid10.c~md-raid10-fix-use-after-free-of-bio drivers/md/raid10.c
> --- a/drivers/md/raid10.c~md-raid10-fix-use-after-free-of-bio
> +++ a/drivers/md/raid10.c
> @@ -1534,7 +1534,6 @@ static void raid10d(mddev_t *mddev)
>  			bio = r10_bio->devs[r10_bio->read_slot].bio;
>  			r10_bio->devs[r10_bio->read_slot].bio =
>  				mddev->ro ? IO_BLOCKED : NULL;
> -			bio_put(bio);
>  			mirror = read_balance(conf, r10_bio);
>  			if (mirror == -1) {
>  				printk(KERN_ALERT "raid10: %s: unrecoverable I/O"
> @@ -1542,8 +1541,10 @@ static void raid10d(mddev_t *mddev)
>  				       bdevname(bio->bi_bdev,b),
>  				       (unsigned long long)r10_bio->sector);
>  				raid_end_bio_io(r10_bio);
> +				bio_put(bio);

and for catching that Andrew!

Acked-By: NeilBrown <neilb@suse.de>


>  			} else {
>  				const int do_sync = bio_sync(r10_bio->master_bio);
> +				bio_put(bio);
>  				rdev = conf->mirrors[mirror].rdev;
>  				if (printk_ratelimit())
>  					printk(KERN_ERR "raid10: %s: redirecting sector %llu to"
> _
> 
> Patches currently in -mm which might be from m.hampel@gmx.de are
> 
> md-raid10-fix-use-after-free-of-bio.patch
