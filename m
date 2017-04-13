From: Shaohua Li <shli@kernel.org>
Subject: Re: [md PATCH] md: handle read-only member devices better.
Date: Wed, 12 Apr 2017 22:47:23 -0700
Message-ID: <20170413054723.2spvhtze6bljkaop@kernel.org>
References: <87a87lutj7.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87a87lutj7.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>, Nanda Kishore Chinnaram <Nanda_Kishore_Chinna@dell.com>
List-Id: linux-raid.ids

On Thu, Apr 13, 2017 at 08:53:48AM +1000, Neil Brown wrote:
> 
> 1/ If an array has any read-only devices when it is started,
>    the array itself must be read-only
> 2/ A read-only device cannot be added to an array after it is
>    started.
> 3/ Setting an array to read-write should not succeed
>    if any member devices are read-only

Didn't get these. We call md_import_device() first to open under layer disk. We
always use FMOD_READ|FMOD_WRITE to open the disk. So if the disk is ro,
md_import_device should fail, we don't add the disk to the array. Why would we
have such issues?

Thanks,
Shaohua
 
> Reported-and-Tested-by: Nanda Kishore Chinnaram <Nanda_Kishore_Chinna@dell.com>
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
>  drivers/md/md.c | 41 ++++++++++++++++++++++++++---------------
>  1 file changed, 26 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 22894303d335..9fe930109012 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2093,6 +2093,10 @@ static int bind_rdev_to_array(struct md_rdev *rdev, struct mddev *mddev)
>  	if (find_rdev(mddev, rdev->bdev->bd_dev))
>  		return -EEXIST;
>  
> +	if ((bdev_read_only(rdev->bdev) || bdev_read_only(rdev->meta_bdev)) &&
> +	    mddev->pers)
> +		return -EROFS;
> +
>  	/* make sure rdev->sectors exceeds mddev->dev_sectors */
>  	if (!test_bit(Journal, &rdev->flags) &&
>  	    rdev->sectors &&
> @@ -5345,6 +5349,13 @@ int md_run(struct mddev *mddev)
>  			continue;
>  		sync_blockdev(rdev->bdev);
>  		invalidate_bdev(rdev->bdev);
> +		if (mddev->ro != 1 &&
> +		    (bdev_read_only(rdev->bdev) ||
> +		     bdev_read_only(rdev->meta_bdev))) {
> +			mddev->ro = 1;
> +			if (mddev->gendisk)
> +				set_disk_ro(mddev->gendisk, 1);
> +		}
>  
>  		/* perform some consistency tests on the device.
>  		 * We don't want the data to overlap the metadata,
> @@ -5569,6 +5580,9 @@ static int do_md_run(struct mddev *mddev)
>  static int restart_array(struct mddev *mddev)
>  {
>  	struct gendisk *disk = mddev->gendisk;
> +	struct md_rdev *rdev;
> +	bool has_journal = false;
> +	bool has_readonly = false;
>  
>  	/* Complain if it has no devices */
>  	if (list_empty(&mddev->disks))
> @@ -5577,24 +5591,21 @@ static int restart_array(struct mddev *mddev)
>  		return -EINVAL;
>  	if (!mddev->ro)
>  		return -EBUSY;
> -	if (test_bit(MD_HAS_JOURNAL, &mddev->flags)) {
> -		struct md_rdev *rdev;
> -		bool has_journal = false;
> -
> -		rcu_read_lock();
> -		rdev_for_each_rcu(rdev, mddev) {
> -			if (test_bit(Journal, &rdev->flags) &&
> -			    !test_bit(Faulty, &rdev->flags)) {
> -				has_journal = true;
> -				break;
> -			}
> -		}
> -		rcu_read_unlock();
>  
> +	rcu_read_lock();
> +	rdev_for_each_rcu(rdev, mddev) {
> +		if (test_bit(Journal, &rdev->flags) &&
> +		    !test_bit(Faulty, &rdev->flags))
> +			has_journal = true;
> +		if (bdev_read_only(rdev->bdev))
> +			has_readonly = true;
> +	}
> +	rcu_read_unlock();
> +	if (test_bit(MD_HAS_JOURNAL, &mddev->flags) && !has_journal)
>  		/* Don't restart rw with journal missing/faulty */
> -		if (!has_journal)
>  			return -EINVAL;
> -	}
> +	if (has_readonly)
> +		return -EROFS;
>  
>  	mddev->safemode = 0;
>  	mddev->ro = 0;
> -- 
> 2.12.2
> 


