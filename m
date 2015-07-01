From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] Fix read-balancing during node failure
Date: Wed, 1 Jul 2015 12:24:12 +1000
Message-ID: <20150701122412.61696113@noble>
References: <1435156232-8711-1-git-send-email-rgoldwyn@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1435156232-8711-1-git-send-email-rgoldwyn@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: teigland@redhat.com, gqJiang@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 24 Jun 2015 09:30:32 -0500 Goldwyn Rodrigues
<rgoldwyn@suse.com> wrote:

> During a node failure, We need to suspend read balancing so that the
> reads are directed to the first device and stale data is not read.
> Suspending writes is not required because these would be recorded and
> synced eventually.
> 
> A new flag MD_CLUSTER_SUSPEND_READ_BALANCING is set in recover_prep().
> area_resyncing() will respond true for the entire devices if this
> flag is set and the request type is READ. The flag is cleared
> in recover_done().
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> Reported-By: David Teigland <teigland@redhat.com>
> ---
>  drivers/md/md-cluster.c | 12 +++++++++++-
>  drivers/md/md-cluster.h |  2 +-
>  drivers/md/raid1.c      |  7 ++++---
>  3 files changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index fcfc4b9..0072190 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -44,6 +44,7 @@ struct resync_info {
>  
>  /* md_cluster_info flags */
>  #define		MD_CLUSTER_WAITING_FOR_NEWDISK		1
> +#define		MD_CLUSTER_SUSPEND_READ_BALANCING	2
>  
>  
>  struct md_cluster_info {
> @@ -275,6 +276,9 @@ clear_bit:
>  
>  static void recover_prep(void *arg)
>  {
> +	struct mddev *mddev = arg;
> +	struct md_cluster_info *cinfo = mddev->cluster_info;
> +	set_bit(MD_CLUSTER_SUSPEND_READ_BALANCING, &cinfo->state);
>  }
>  
>  static void recover_slot(void *arg, struct dlm_slot *slot)
> @@ -307,6 +311,7 @@ static void recover_done(void *arg, struct dlm_slot *slots,
>  
>  	cinfo->slot_number = our_slot;
>  	complete(&cinfo->completion);
> +	clear_bit(MD_CLUSTER_SUSPEND_READ_BALANCING, &cinfo->state);
>  }
>  
>  static const struct dlm_lockspace_ops md_ls_ops = {
> @@ -816,12 +821,17 @@ static void resync_finish(struct mddev *mddev)
>  	resync_send(mddev, RESYNCING, 0, 0);
>  }
>  
> -static int area_resyncing(struct mddev *mddev, sector_t lo, sector_t hi)
> +static int area_resyncing(struct mddev *mddev, int direction,
> +		sector_t lo, sector_t hi)
>  {
>  	struct md_cluster_info *cinfo = mddev->cluster_info;
>  	int ret = 0;
>  	struct suspend_info *s;
>  
> +	if ((direction == READ) &&
> +		test_bit(MD_CLUSTER_SUSPEND_READ_BALANCING, &cinfo->state))
> +		return 1;
> +
>  	spin_lock_irq(&cinfo->suspend_lock);
>  	if (list_empty(&cinfo->suspend_list))
>  		goto out;
> diff --git a/drivers/md/md-cluster.h b/drivers/md/md-cluster.h
> index 6817ee0..00defe2 100644
> --- a/drivers/md/md-cluster.h
> +++ b/drivers/md/md-cluster.h
> @@ -18,7 +18,7 @@ struct md_cluster_operations {
>  	int (*metadata_update_start)(struct mddev *mddev);
>  	int (*metadata_update_finish)(struct mddev *mddev);
>  	int (*metadata_update_cancel)(struct mddev *mddev);
> -	int (*area_resyncing)(struct mddev *mddev, sector_t lo, sector_t hi);
> +	int (*area_resyncing)(struct mddev *mddev, int direction, sector_t lo, sector_t hi);
>  	int (*add_new_disk_start)(struct mddev *mddev, struct md_rdev *rdev);
>  	int (*add_new_disk_finish)(struct mddev *mddev);
>  	int (*new_disk_ack)(struct mddev *mddev, bool ack);
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 9157a29..b5626d2 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -541,7 +541,7 @@ static int read_balance(struct r1conf *conf, struct r1bio *r1_bio, int *max_sect
>  
>  	if ((conf->mddev->recovery_cp < this_sector + sectors) ||
>  	    (mddev_is_clustered(conf->mddev) &&
> -	    md_cluster_ops->area_resyncing(conf->mddev, this_sector,
> +	    md_cluster_ops->area_resyncing(conf->mddev, READ, this_sector,
>  		    this_sector + sectors)))
>  		choose_first = 1;
>  	else
> @@ -1111,7 +1111,8 @@ static void make_request(struct mddev *mddev, struct bio * bio)
>  	    ((bio_end_sector(bio) > mddev->suspend_lo &&
>  	    bio->bi_iter.bi_sector < mddev->suspend_hi) ||
>  	    (mddev_is_clustered(mddev) &&
> -	     md_cluster_ops->area_resyncing(mddev, bio->bi_iter.bi_sector, bio_end_sector(bio))))) {
> +	     md_cluster_ops->area_resyncing(mddev, WRITE,
> +		     bio->bi_iter.bi_sector, bio_end_sector(bio))))) {
>  		/* As the suspend_* range is controlled by
>  		 * userspace, we want an interruptible
>  		 * wait.
> @@ -1124,7 +1125,7 @@ static void make_request(struct mddev *mddev, struct bio * bio)
>  			if (bio_end_sector(bio) <= mddev->suspend_lo ||
>  			    bio->bi_iter.bi_sector >= mddev->suspend_hi ||
>  			    (mddev_is_clustered(mddev) &&
> -			     !md_cluster_ops->area_resyncing(mddev,
> +			     !md_cluster_ops->area_resyncing(mddev, WRITE,
>  				     bio->bi_iter.bi_sector, bio_end_sector(bio))))
>  				break;
>  			schedule();


Applied, thanks.

NeilBrown
