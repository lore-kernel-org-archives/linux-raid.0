From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH/RFC] md/multipath: implement I/O balancing
Date: Tue, 14 Jun 2011 13:59:02 +1000
Message-ID: <20110614135902.0150f857@notabene.brown>
References: <1307705531-26384-1-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1307705531-26384-1-git-send-email-namhyung@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 10 Jun 2011 20:32:11 +0900 Namhyung Kim <namhyung@gmail.com> wrote:

> Implement basic I/O balancing code (for read/write) for multipath
> personality. The code is based on RAID1 implementation.

Thanks, but no thanks.

As far as I am concerned, the md/multipath implementation is deprecated.  The
dm-multipath implementation is much more mature and is more widely used and
actually has a sensible design - unlike md/multipath which has always had a
bad design.

I would rip it out and throw it away if I could, but I believe there are
people who use it so doing that is too difficult.

But I will not be adding feature to it at all.

Thanks,
NeilBrown

> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  drivers/md/multipath.c |   70 ++++++++++++++++++++++++++++++++++++++---------
>  drivers/md/multipath.h |    1 +
>  2 files changed, 57 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
> index 3535c23af288..83c4f5105705 100644
> --- a/drivers/md/multipath.c
> +++ b/drivers/md/multipath.c
> @@ -30,29 +30,58 @@
>  
>  #define	NR_RESERVED_BUFS	32
>  
> -
> -static int multipath_map (multipath_conf_t *conf)
> +/*
> + * This routine returns the disk from which the requested read should
> + * be done. There is a per-array 'next expected sequential IO' sector
> + * number - if this matches on the next IO then we use the last disk.
> + * There is also a per-disk 'last know head position' sector that is
> + * maintained from IRQ contexts, IO completion handlers update this
> + * position correctly. We pick the disk whose head is closest.
> + *
> + * Note that 'sector' argument is for original bio whereas 'head_position'
> + * is maintained for each rdev so we should take it into account when
> + * calculating the distance.
> + */
> +static int multipath_map(multipath_conf_t *conf, sector_t sector)
>  {
>  	int i, disks = conf->raid_disks;
> -
> -	/*
> -	 * Later we do read balancing on the read side 
> -	 * now we use the first available disk.
> -	 */
> +	int best_disk;
> +	sector_t best_dist;
>  
>  	rcu_read_lock();
> +retry:
> +	best_disk = -1;
> +	best_dist = MaxSector;
> +
>  	for (i = 0; i < disks; i++) {
> +		int dist;
>  		mdk_rdev_t *rdev = rcu_dereference(conf->multipaths[i].rdev);
> +		sector_t this_sector = sector;
> +
>  		if (rdev && test_bit(In_sync, &rdev->flags)) {
> -			atomic_inc(&rdev->nr_pending);
> -			rcu_read_unlock();
> -			return i;
> +			this_sector += rdev->data_offset;
> +			dist = abs(this_sector - conf->multipaths[i].head_position);
> +			if (dist < best_dist) {
> +				best_dist = dist;
> +				best_disk = i;
> +			}
>  		}
>  	}
> +
> +	if (best_disk == -1) {
> +		printk(KERN_ERR "multipath_map(): no more operational IO paths?\n");
> +	} else {
> +		mdk_rdev_t *rdev;
> +
> +		rdev = rcu_dereference(conf->multipaths[best_disk].rdev);
> +		if (!rdev || !test_bit(In_sync, &rdev->flags))
> +			goto retry;
> +
> +		atomic_inc(&rdev->nr_pending);
> +	}
>  	rcu_read_unlock();
>  
> -	printk(KERN_ERR "multipath_map(): no more operational IO paths?\n");
> -	return (-1);
> +	return best_disk;
>  }
>  
>  static void multipath_reschedule_retry (struct multipath_bh *mp_bh)
> @@ -82,6 +111,17 @@ static void multipath_end_bh_io (struct multipath_bh *mp_bh, int err)
>  	mempool_free(mp_bh, conf->pool);
>  }
>  
> +/*
> + * Update disk head position estimator based on IRQ completion info.
> + */
> +static inline void update_head_pos(int disk, struct multipath_bh *mp_bh)
> +{
> +	multipath_conf_t *conf = mp_bh->mddev->private;
> +
> +	conf->multipaths[disk].head_position =
> +		mp_bh->bio.bi_sector + (mp_bh->bio.bi_size >> 9);
> +}
> +
>  static void multipath_end_request(struct bio *bio, int error)
>  {
>  	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
> @@ -89,6 +129,8 @@ static void multipath_end_request(struct bio *bio, int error)
>  	multipath_conf_t *conf = mp_bh->mddev->private;
>  	mdk_rdev_t *rdev = conf->multipaths[mp_bh->path].rdev;
>  
> +	update_head_pos(mp_bh->path, mp_bh);
> +
>  	if (uptodate)
>  		multipath_end_bh_io(mp_bh, 0);
>  	else if (!(bio->bi_rw & REQ_RAHEAD)) {
> @@ -122,7 +164,7 @@ static int multipath_make_request(mddev_t *mddev, struct bio * bio)
>  	mp_bh->master_bio = bio;
>  	mp_bh->mddev = mddev;
>  
> -	mp_bh->path = multipath_map(conf);
> +	mp_bh->path = multipath_map(conf, bio->bi_sector);
>  	if (mp_bh->path < 0) {
>  		bio_endio(bio, -EIO);
>  		mempool_free(mp_bh, conf->pool);
> @@ -356,7 +398,7 @@ static void multipathd (mddev_t *mddev)
>  		bio = &mp_bh->bio;
>  		bio->bi_sector = mp_bh->master_bio->bi_sector;
>  		
> -		if ((mp_bh->path = multipath_map (conf))<0) {
> +		if ((mp_bh->path = multipath_map(conf, bio->bi_sector)) < 0) {
>  			printk(KERN_ALERT "multipath: %s: unrecoverable IO read"
>  				" error for block %llu\n",
>  				bdevname(bio->bi_bdev,b),
> diff --git a/drivers/md/multipath.h b/drivers/md/multipath.h
> index 3c5a45eb5f8a..060fe2aabd97 100644
> --- a/drivers/md/multipath.h
> +++ b/drivers/md/multipath.h
> @@ -3,6 +3,7 @@
>  
>  struct multipath_info {
>  	mdk_rdev_t	*rdev;
> +	sector_t	head_position;
>  };
>  
>  struct multipath_private_data {

