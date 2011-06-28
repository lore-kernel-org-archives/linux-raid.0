From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 4/8] md/raid: use printk_ratelimited instead of
 printk_ratelimit
Date: Tue, 28 Jun 2011 16:45:40 +1000
Message-ID: <20110628164540.4b22deae@notabene.brown>
References: <cover.1307199715.git.christian.dietrich@informatik.uni-erlangen.de>
	<2c759de6a8afa764cfaa32e2ea99b0f0099140d7.1307199715.git.christian.dietrich@informatik.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2c759de6a8afa764cfaa32e2ea99b0f0099140d7.1307199715.git.christian.dietrich@informatik.uni-erlangen.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, trivial@kernel.org
List-Id: linux-raid.ids

On Sat, 4 Jun 2011 17:36:21 +0200 Christian Dietrich
<christian.dietrich@informatik.uni-erlangen.de> wrote:

> As per printk_ratelimit comment, it should not be used
> 
> Signed-off-by: Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de>
> ---
>  drivers/md/raid1.c  |   22 ++++++++++++----------
>  drivers/md/raid10.c |   22 ++++++++++++----------
>  drivers/md/raid5.c  |   39 +++++++++++++++++++--------------------
>  3 files changed, 43 insertions(+), 40 deletions(-)

Thanks.  I've applied this one to my 'md' tree.

NeilBrown



> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 5d09609..30af10e 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -35,6 +35,7 @@
>  #include <linux/delay.h>
>  #include <linux/blkdev.h>
>  #include <linux/seq_file.h>
> +#include <linux/ratelimit.h>
>  #include "md.h"
>  #include "raid1.h"
>  #include "bitmap.h"
> @@ -287,10 +288,11 @@ static void raid1_end_read_request(struct bio *bio, int error)
>  		 * oops, read error:
>  		 */
>  		char b[BDEVNAME_SIZE];
> -		if (printk_ratelimit())
> -			printk(KERN_ERR "md/raid1:%s: %s: rescheduling sector %llu\n",
> -			       mdname(conf->mddev),
> -			       bdevname(conf->mirrors[mirror].rdev->bdev,b), (unsigned long long)r1_bio->sector);
> +		printk_ratelimited(KERN_ERR "md/raid1:%s: %s: "
> +				   "rescheduling sector %llu\n",
> +				   mdname(conf->mddev),
> +				   bdevname(conf->mirrors[mirror].rdev->bdev, b),
> +				   (unsigned long long)r1_bio->sector);
>  		reschedule_retry(r1_bio);
>  	}
>  
> @@ -1574,12 +1576,12 @@ static void raid1d(mddev_t *mddev)
>  						      GFP_NOIO, mddev);
>  				r1_bio->bios[r1_bio->read_disk] = bio;
>  				rdev = conf->mirrors[disk].rdev;
> -				if (printk_ratelimit())
> -					printk(KERN_ERR "md/raid1:%s: redirecting sector %llu to"
> -					       " other mirror: %s\n",
> -					       mdname(mddev),
> -					       (unsigned long long)r1_bio->sector,
> -					       bdevname(rdev->bdev,b));
> +				printk_ratelimited(KERN_ERR
> +						   "md/raid1:%s: redirecting sector %llu to"
> +						   " other mirror: %s\n",
> +						   mdname(mddev),
> +						   (unsigned long long)r1_bio->sector,
> +						   bdevname(rdev->bdev, b));
>  				bio->bi_sector = r1_bio->sector + rdev->data_offset;
>  				bio->bi_bdev = rdev->bdev;
>  				bio->bi_end_io = raid1_end_read_request;
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 6e84668..e80475a 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -22,6 +22,7 @@
>  #include <linux/delay.h>
>  #include <linux/blkdev.h>
>  #include <linux/seq_file.h>
> +#include <linux/ratelimit.h>
>  #include "md.h"
>  #include "raid10.h"
>  #include "raid0.h"
> @@ -277,10 +278,11 @@ static void raid10_end_read_request(struct bio *bio, int error)
>  		 * oops, read error - keep the refcount on the rdev
>  		 */
>  		char b[BDEVNAME_SIZE];
> -		if (printk_ratelimit())
> -			printk(KERN_ERR "md/raid10:%s: %s: rescheduling sector %llu\n",
> -			       mdname(conf->mddev),
> -			       bdevname(conf->mirrors[dev].rdev->bdev,b), (unsigned long long)r10_bio->sector);
> +		printk_ratelimited(KERN_ERR
> +				   "md/raid10:%s: %s: rescheduling sector %llu\n",
> +				   mdname(conf->mddev),
> +				   bdevname(conf->mirrors[dev].rdev->bdev, b),
> +				   (unsigned long long)r10_bio->sector);
>  		reschedule_retry(r10_bio);
>  	}
>  }
> @@ -1667,12 +1669,12 @@ static void raid10d(mddev_t *mddev)
>  				bio_put(bio);
>  				slot = r10_bio->read_slot;
>  				rdev = conf->mirrors[mirror].rdev;
> -				if (printk_ratelimit())
> -					printk(KERN_ERR "md/raid10:%s: %s: redirecting sector %llu to"
> -					       " another mirror\n",
> -					       mdname(mddev),
> -					       bdevname(rdev->bdev,b),
> -					       (unsigned long long)r10_bio->sector);
> +				printk_ratelimited(KERN_ERR
> +						   "md/raid10:%s: %s: redirecting"
> +						   "sector %llu to another mirror\n",
> +						   mdname(mddev),
> +						   bdevname(rdev->bdev, b),
> +						   (unsigned long long)r10_bio->sector);
>  				bio = bio_clone_mddev(r10_bio->master_bio,
>  						      GFP_NOIO, mddev);
>  				r10_bio->devs[slot].bio = bio;
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 346e69b..8927c26 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -51,6 +51,7 @@
>  #include <linux/seq_file.h>
>  #include <linux/cpu.h>
>  #include <linux/slab.h>
> +#include <linux/ratelimit.h>
>  #include "md.h"
>  #include "raid5.h"
>  #include "raid0.h"
> @@ -96,8 +97,6 @@
>  #define __inline__
>  #endif
>  
> -#define printk_rl(args...) ((void) (printk_ratelimit() && printk(args)))
> -
>  /*
>   * We maintain a biased count of active stripes in the bottom 16 bits of
>   * bi_phys_segments, and a count of processed stripes in the upper 16 bits
> @@ -1587,12 +1586,12 @@ static void raid5_end_read_request(struct bio * bi, int error)
>  		set_bit(R5_UPTODATE, &sh->dev[i].flags);
>  		if (test_bit(R5_ReadError, &sh->dev[i].flags)) {
>  			rdev = conf->disks[i].rdev;
> -			printk_rl(KERN_INFO "md/raid:%s: read error corrected"
> -				  " (%lu sectors at %llu on %s)\n",
> -				  mdname(conf->mddev), STRIPE_SECTORS,
> -				  (unsigned long long)(sh->sector
> -						       + rdev->data_offset),
> -				  bdevname(rdev->bdev, b));
> +			printk_ratelimited(KERN_INFO "md/raid:%s: read error corrected"
> +					   " (%lu sectors at %llu on %s)\n",
> +					   mdname(conf->mddev), STRIPE_SECTORS,
> +					   (unsigned long long)(sh->sector
> +								+ rdev->data_offset),
> +					   bdevname(rdev->bdev, b));
>  			clear_bit(R5_ReadError, &sh->dev[i].flags);
>  			clear_bit(R5_ReWrite, &sh->dev[i].flags);
>  		}
> @@ -1606,21 +1605,21 @@ static void raid5_end_read_request(struct bio * bi, int error)
>  		clear_bit(R5_UPTODATE, &sh->dev[i].flags);
>  		atomic_inc(&rdev->read_errors);
>  		if (conf->mddev->degraded >= conf->max_degraded)
> -			printk_rl(KERN_WARNING
> -				  "md/raid:%s: read error not correctable "
> -				  "(sector %llu on %s).\n",
> -				  mdname(conf->mddev),
> -				  (unsigned long long)(sh->sector
> -						       + rdev->data_offset),
> +			printk_ratelimited(KERN_WARNING
> +					   "md/raid:%s: read error not correctable "
> +					   "(sector %llu on %s).\n",
> +					   mdname(conf->mddev),
> +					   (unsigned long long)(sh->sector
> +								+ rdev->data_offset),
>  				  bdn);
>  		else if (test_bit(R5_ReWrite, &sh->dev[i].flags))
>  			/* Oh, no!!! */
> -			printk_rl(KERN_WARNING
> -				  "md/raid:%s: read error NOT corrected!! "
> -				  "(sector %llu on %s).\n",
> -				  mdname(conf->mddev),
> -				  (unsigned long long)(sh->sector
> -						       + rdev->data_offset),
> +			printk_ratelimited(KERN_WARNING
> +					   "md/raid:%s: read error NOT corrected!! "
> +					   "(sector %llu on %s).\n",
> +					   mdname(conf->mddev),
> +					   (unsigned long long)(sh->sector
> +								+ rdev->data_offset),
>  				  bdn);
>  		else if (atomic_read(&rdev->read_errors)
>  			 > conf->max_nr_stripes)

