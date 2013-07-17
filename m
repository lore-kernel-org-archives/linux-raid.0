From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: RAID1 repair GPF crash w/3.10-rc7
Date: Wed, 17 Jul 2013 17:01:18 -0400
Message-ID: <20130717170118.6b3fcf37@jlaw-desktop.mno.stratus.com>
References: <alpine.DEB.2.02.1307012118450.6694@jlaw-desktop.mno.stratus.com>
	<alpine.DEB.2.02.1307031634440.9749@jlaw-desktop.mno.stratus.com>
	<20130704105337.2a06cbfd@notabene.brown>
	<20130708160656.6cb8e74b@jlaw-desktop.mno.stratus.com>
	<20130717161230.2d96fa62@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130717161230.2d96fa62@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, kmo@daterainc.com
List-Id: linux-raid.ids

On Wed, 17 Jul 2013 16:12:30 +1000
NeilBrown <neilb@suse.de> wrote:

> Hi,
>  just letting you know I've decided to fix this differently for 3.11 and
>  3.10.y.
> 
> I noticed there was another problem in that code, in that the len argument
> passed to memcmp was bv_len which might have been modified.
> 
> So I moved the "fix up the bio" code to the top of the function and applied
> it to all relevant bios.
> 
> I'd still like to go with bio_rewind or similar, but it's probably best for
> that to wait for the other bio stuff to settle.  Maybe it won't be needed.
> 
> NeilBrown
> 
> 
> commit 9a3856f56b467425e13a19d95524524e76eab040
> Author: NeilBrown <neilb@suse.de>
> Date:   Wed Jul 17 15:19:29 2013 +1000
> 
>     md/raid1: fix bio handling problems in process_checks()
>     
>     Recent change to use bio_copy_data() in raid1 when repairing
>     an array is faulty.
>     
>     The underlying may have changed the bio in various ways using
>     bio_advance and these need to be undone not just for the 'sbio' which
>     is being copied to, but also the 'pbio' (primary) which is being
>     copied from.
>     
>     So perform the reset on all bios that were read from and do it early.
>     
>     This also ensure that the sbio->bi_io_vec[j].bv_len passed to
>     memcmp is correct.
>     
>     Reported-by: Joe Lawrence <joe.lawrence@stratus.com>
>     Signed-off-by: NeilBrown <neilb@suse.de>
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index ec73458..d60412c 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1849,6 +1849,36 @@ static int process_checks(struct r1bio *r1_bio)
>  	int i;
>  	int vcnt;
>  
> +	/* Fix variable parts of all bios */
> +	vcnt = (r1_bio->sectors + PAGE_SIZE / 512 - 1) >> (PAGE_SHIFT - 9);
> +	for (i = 0; i < conf->raid_disks * 2; i++) {
> +		int j;
> +		int size;
> +		struct bio *b = r1_bio->bios[i];
> +		if (b->bi_end_io != end_sync_read)
> +			continue;
> +		/* fixup the bio for reuse */
> +		bio_reset(b);
> +		b->bi_vcnt = vcnt;
> +		b->bi_size = r1_bio->sectors << 9;
> +		b->bi_sector = r1_bio->sector +
> +			conf->mirrors[i].rdev->data_offset;
> +		b->bi_bdev = conf->mirrors[i].rdev->bdev;
> +		b->bi_end_io = end_sync_read;
> +		b->bi_private = r1_bio;
> +
> +		size = b->bi_size;
> +		for (j = 0; j < vcnt ; j++) {
> +			struct bio_vec *bi;
> +			bi = &b->bi_io_vec[j];
> +			bi->bv_offset = 0;
> +			if (size > PAGE_SIZE)
> +				bi->bv_len = PAGE_SIZE;
> +			else
> +				bi->bv_len = size;
> +			size -= PAGE_SIZE;
> +		}
> +	}
>  	for (primary = 0; primary < conf->raid_disks * 2; primary++)
>  		if (r1_bio->bios[primary]->bi_end_io == end_sync_read &&
>  		    test_bit(BIO_UPTODATE, &r1_bio->bios[primary]->bi_flags)) {
> @@ -1857,12 +1887,10 @@ static int process_checks(struct r1bio *r1_bio)
>  			break;
>  		}
>  	r1_bio->read_disk = primary;
> -	vcnt = (r1_bio->sectors + PAGE_SIZE / 512 - 1) >> (PAGE_SHIFT - 9);
>  	for (i = 0; i < conf->raid_disks * 2; i++) {
>  		int j;
>  		struct bio *pbio = r1_bio->bios[primary];
>  		struct bio *sbio = r1_bio->bios[i];
> -		int size;
>  
>  		if (sbio->bi_end_io != end_sync_read)
>  			continue;
> @@ -1888,27 +1916,6 @@ static int process_checks(struct r1bio *r1_bio)
>  			rdev_dec_pending(conf->mirrors[i].rdev, mddev);
>  			continue;
>  		}
> -		/* fixup the bio for reuse */
> -		bio_reset(sbio);
> -		sbio->bi_vcnt = vcnt;
> -		sbio->bi_size = r1_bio->sectors << 9;
> -		sbio->bi_sector = r1_bio->sector +
> -			conf->mirrors[i].rdev->data_offset;
> -		sbio->bi_bdev = conf->mirrors[i].rdev->bdev;
> -		sbio->bi_end_io = end_sync_read;
> -		sbio->bi_private = r1_bio;
> -
> -		size = sbio->bi_size;
> -		for (j = 0; j < vcnt ; j++) {
> -			struct bio_vec *bi;
> -			bi = &sbio->bi_io_vec[j];
> -			bi->bv_offset = 0;
> -			if (size > PAGE_SIZE)
> -				bi->bv_len = PAGE_SIZE;
> -			else
> -				bi->bv_len = size;
> -			size -= PAGE_SIZE;
> -		}
>  
>  		bio_copy_data(sbio, pbio);
>  	}

Hi Neil, this version looks good so far in my testing.  Thanks for fixing.

-- Joe
