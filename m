From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH/RFC] md/raid10: optimize read_balance() for 'far copies'
 arrays
Date: Wed, 8 Jun 2011 17:21:57 +1000
Message-ID: <20110608172157.4d6ac2a8@notabene.brown>
References: <1307516445-3208-1-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1307516445-3208-1-git-send-email-namhyung@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed,  8 Jun 2011 16:00:45 +0900 Namhyung Kim <namhyung@gmail.com> wrote:

> If @conf->far_offset > 0, there is only 1 stripe so that we can treat
> the array same as 'near' arrays. Furthermore we could calculate new
> distance from the previous position even for the real 'far' array
> cases if the position of given disk is already in the lowest stripe.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  drivers/md/raid10.c |   14 +++++++++++---
>  1 files changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 6e846688962f..9ec4c5f8cd48 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -531,11 +531,19 @@ retry:
>  			break;
>  
>  		/* for far > 1 always use the lowest address */
> -		if (conf->far_copies > 1)
> -			new_distance = r10_bio->devs[slot].addr;
> -		else
> +		if (conf->far_copies > 1 && conf->far_offset == 0) {
> +			if (conf->mirrors[disk].head_position < conf->stride &&
> +			    r10_bio->devs[slot].addr < conf->stride)
> +				/* already in the lowest stripe */
> +				new_distance = abs(r10_bio->devs[slot].addr -
> +						   conf->mirrors[disk].head_position);
> +			else
> +				new_distance = r10_bio->devs[slot].addr;
> +		} else {
>  			new_distance = abs(r10_bio->devs[slot].addr -
>  					   conf->mirrors[disk].head_position);
> +		}
> +
>  		if (new_distance < best_dist) {
>  			best_dist = new_distance;
>  			best_slot = slot;


I agree that it still make sense to to balancing if far_offset != 0.
However  there is absolutely no point in your change to the calculation of
new_distance.
You only wont new_distance to contain a distance from head position if we
want to choose the device with the 'closest' head.  But we don't.  We want to
choose the device were the data is closest to the start of the device.  So
the current value for new_distance is correct.

If you would like to resubmit with just the first change I'll happily apply
the patch.

If you have performed some tests and can demonstrate some cases where this
makes something faster, and can show us the results of those tests, I would
be even more happy!!!

Thanks,
NeilBrown
