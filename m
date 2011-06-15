From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 5/5] md/raid10: spread read for subordinate r10bios
 during recovery
Date: Wed, 15 Jun 2011 13:09:03 +1000
Message-ID: <20110615130903.0445394e@notabene.brown>
References: <1308103324-2375-1-git-send-email-namhyung@gmail.com>
	<1308103324-2375-6-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1308103324-2375-6-git-send-email-namhyung@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 15 Jun 2011 11:02:04 +0900 Namhyung Kim <namhyung@gmail.com> wrote:

> In the current scheme, multiple read request could be directed to
> the first active disk during recovery if there are several disk
> failure at the same time. Spreading those requests on other in-sync
> disks might be helpful.

I don't find this convincing either.  Spreading requests over disks in a
haphazard way is not certain to improve anything and could easily cause
regressions.

For example if I have an 'n3' array on 3 devices, this will read alternately
from the first 2 devices while rebuilding the last.  This is simply a waste.
One disk would be enough keep the rebuilding disk busy - the other should be
left of regular reads.

Again: if you can demonstrate a speed up in some configuration I'll be happy
to reconsider the patch.

Thanks,
NeilBrown


> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  drivers/md/raid10.c |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index dea73bdb99b8..d0188e49f881 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1832,6 +1832,7 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr,
>  	if (!test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
>  		/* recovery... the complicated one */
>  		int j, k;
> +		int last_read = -1;
>  		r10_bio = NULL;
>  
>  		for (i=0 ; i<conf->raid_disks; i++) {
> @@ -1891,7 +1892,9 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr,
>  						      &sync_blocks, still_degraded);
>  
>  			for (j=0; j<conf->copies;j++) {
> -				int d = r10_bio->devs[j].devnum;
> +				int c = (last_read + j + 1) % conf->copies;
> +				int d = r10_bio->devs[c].devnum;
> +
>  				if (!conf->mirrors[d].rdev ||
>  				    !test_bit(In_sync, &conf->mirrors[d].rdev->flags))
>  					continue;
> @@ -1902,13 +1905,14 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr,
>  				bio->bi_private = r10_bio;
>  				bio->bi_end_io = end_sync_read;
>  				bio->bi_rw = READ;
> -				bio->bi_sector = r10_bio->devs[j].addr +
> +				bio->bi_sector = r10_bio->devs[c].addr +
>  					conf->mirrors[d].rdev->data_offset;
>  				bio->bi_bdev = conf->mirrors[d].rdev->bdev;
>  				atomic_inc(&conf->mirrors[d].rdev->nr_pending);
>  				atomic_inc(&r10_bio->remaining);
> -				/* and we write to 'i' */
> +				last_read = c;
>  
> +				/* and we write to 'i' */
>  				for (k=0; k<conf->copies; k++)
>  					if (r10_bio->devs[k].devnum == i)
>  						break;

