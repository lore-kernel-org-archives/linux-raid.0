From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md_make_request: don't touch the bio after calling
 make_request
Date: Tue, 8 Feb 2011 09:54:24 +1100
Message-ID: <20110208095424.1b886746@notabene.brown>
References: <1297106377-sup-9409@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1297106377-sup-9409@think>
Sender: linux-kernel-owner@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, axboe@kernel.dk
List-Id: linux-raid.ids

On Mon, 07 Feb 2011 14:21:48 -0500 Chris Mason <chris.mason@oracle.com> wrote:

> md_make_request was calling bio_sectors() for part_stat_add
> after it was calling the make_request function.  This is
> bad because the make_request function can free the bio and
> because the bi_size field can change around.
> 
> The fix here was suggested by Jens Axboe.  It saves the
> sector count before the make_request call.  I hit this
> with CONFIG_DEBUG_PAGEALLOC turned on while trying to break
> his pretty fusionio card.

Thanks Chris!!

I've added it to my queue of md fixes (which I really must send of soon) and
tagged it for -stable.

NeilBrown


> 
> Signed-off-by: Chris Mason <chris.mason@oracle.com>
> ---
>  drivers/md/md.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index b76cfc8..a7d3c3c 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -287,6 +287,7 @@ static int md_make_request(struct request_queue *q, struct bio *bio)
>  	mddev_t *mddev = q->queuedata;
>  	int rv;
>  	int cpu;
> +	unsigned int sectors;
>  
>  	if (mddev == NULL || mddev->pers == NULL
>  	    || !mddev->ready) {
> @@ -311,12 +312,16 @@ static int md_make_request(struct request_queue *q, struct bio *bio)
>  	atomic_inc(&mddev->active_io);
>  	rcu_read_unlock();
>  
> +	/*
> +	 * save the sectors now since our bio can
> +	 * go away inside make_request
> +	 */
> +	sectors = bio_sectors(bio);
>  	rv = mddev->pers->make_request(mddev, bio);
>  
>  	cpu = part_stat_lock();
>  	part_stat_inc(cpu, &mddev->gendisk->part0, ios[rw]);
> -	part_stat_add(cpu, &mddev->gendisk->part0, sectors[rw],
> -		      bio_sectors(bio));
> +	part_stat_add(cpu, &mddev->gendisk->part0, sectors[rw], sectors);
>  	part_stat_unlock();
>  
>  	if (atomic_dec_and_test(&mddev->active_io) && mddev->suspended)
