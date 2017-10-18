From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md: create new workqueue for object destruction
Date: Tue, 17 Oct 2017 23:21:37 -0700
Message-ID: <20171018062137.ssdhwkeoy6fdp7yq@kernel.org>
References: <87mv4qjrez.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87mv4qjrez.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Oct 17, 2017 at 04:04:52PM +1100, Neil Brown wrote:
> 
> lockdep currently complains about a potential deadlock
> with sysfs access taking reconfig_mutex, and that
> waiting for a work queue to complete.
> 
> The cause is inappropriate overloading of work-items
> on work-queues.
> 
> We currently have two work-queues: md_wq and md_misc_wq.
> They service 5 different tasks:
> 
>   mddev->flush_work                       md_wq
>   mddev->event_work (for dm-raid)         md_misc_wq
>   mddev->del_work (mddev_delayed_delete)  md_misc_wq
>   mddev->del_work (md_start_sync)         md_misc_wq
>   rdev->del_work                          md_misc_wq
> 
> We need to call flush_workqueue() for md_start_sync and ->event_work
> while holding reconfig_mutex, but mustn't hold it when
> flushing mddev_delayed_delete or rdev->del_work.
> 
> md_wq is a bit special as it has WQ_MEM_RECLAIM so it is
> best to leave that alone.
> 
> So create a new workqueue, md_del_wq, and a new work_struct,
> mddev->sync_work, so we can keep two classes of work separate.
> 
> md_del_wq and ->del_work are used only for destroying rdev
> and mddev.
> md_misc_wq is used for event_work and sync_work.
> 
> Also document the purpose of each flush_workqueue() call.
> 
> This removes the lockdep warning.

I had the exactly same patch queued internally, but the mdadm test suite still
shows lockdep warnning. I haven't time to check further.

Thanks,
Shaohua 
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
>  drivers/md/md.c | 51 ++++++++++++++++++++++++++++-----------------------
>  drivers/md/md.h |  1 +
>  2 files changed, 29 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index bf06ff017eda..a9f1352b3849 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -91,6 +91,7 @@ EXPORT_SYMBOL(md_cluster_mod);
>  
>  static DECLARE_WAIT_QUEUE_HEAD(resync_wait);
>  static struct workqueue_struct *md_wq;
> +static struct workqueue_struct *md_del_wq;
>  static struct workqueue_struct *md_misc_wq;
>  
>  static int remove_and_add_spares(struct mddev *mddev,
> @@ -529,7 +530,7 @@ static void mddev_put(struct mddev *mddev)
>  			 * succeed in waiting for the work to be done.
>  			 */
>  			INIT_WORK(&mddev->del_work, mddev_delayed_delete);
> -			queue_work(md_misc_wq, &mddev->del_work);
> +			queue_work(md_del_wq, &mddev->del_work);
>  		} else
>  			kfree(mddev);
>  	}
> @@ -2264,7 +2265,7 @@ static void unbind_rdev_from_array(struct md_rdev *rdev)
>  	synchronize_rcu();
>  	INIT_WORK(&rdev->del_work, md_delayed_delete);
>  	kobject_get(&rdev->kobj);
> -	queue_work(md_misc_wq, &rdev->del_work);
> +	queue_work(md_del_wq, &rdev->del_work);
>  }
>  
>  /*
> @@ -4298,7 +4299,8 @@ new_dev_store(struct mddev *mddev, const char *buf, size_t len)
>  	    minor != MINOR(dev))
>  		return -EOVERFLOW;
>  
> -	flush_workqueue(md_misc_wq);
> +	/* Ensure old devices are fully deleted (rdev->del_work) */
> +	flush_workqueue(md_del_wq);
>  
>  	err = mddev_lock(mddev);
>  	if (err)
> @@ -4537,6 +4539,7 @@ action_store(struct mddev *mddev, const char *page, size_t len)
>  			clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
>  		if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) &&
>  		    mddev_lock(mddev) == 0) {
> +			/* Ensure sync/recovery has fully started (mddev->sync_work) */
>  			flush_workqueue(md_misc_wq);
>  			if (mddev->sync_thread) {
>  				set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> @@ -5280,9 +5283,9 @@ static int md_alloc(dev_t dev, char *name)
>  	unit = MINOR(mddev->unit) >> shift;
>  
>  	/* wait for any previous instance of this device to be
> -	 * completely removed (mddev_delayed_delete).
> +	 * completely removed (mddev_delayed_delete, mddev->del_work).
>  	 */
> -	flush_workqueue(md_misc_wq);
> +	flush_workqueue(md_del_wq);
>  
>  	mutex_lock(&disks_mutex);
>  	error = -EEXIST;
> @@ -5788,6 +5791,7 @@ static void md_clean(struct mddev *mddev)
>  static void __md_stop_writes(struct mddev *mddev)
>  {
>  	set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> +	/* Ensure any sync/recovery has fully started (mddev->sync_work) */
>  	flush_workqueue(md_misc_wq);
>  	if (mddev->sync_thread) {
>  		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> @@ -7128,8 +7132,8 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
>  	}
>  
>  	if (cmd == ADD_NEW_DISK)
> -		/* need to ensure md_delayed_delete() has completed */
> -		flush_workqueue(md_misc_wq);
> +		/* need to ensure md_delayed_delete() has completed (rdev->del_work) */
> +		flush_workqueue(md_del_wq);
>  
>  	if (cmd == HOT_REMOVE_DISK)
>  		/* need to ensure recovery thread has run */
> @@ -7383,8 +7387,8 @@ static int md_open(struct block_device *bdev, fmode_t mode)
>  		 * bd_disk.
>  		 */
>  		mddev_put(mddev);
> -		/* Wait until bdev->bd_disk is definitely gone */
> -		flush_workqueue(md_misc_wq);
> +		/* Wait until bdev->bd_disk is definitely gone (mddev->del_work) */
> +		flush_workqueue(md_del_wq);
>  		/* Then retry the open from the top */
>  		return -ERESTARTSYS;
>  	}
> @@ -8631,7 +8635,7 @@ static int remove_and_add_spares(struct mddev *mddev,
>  
>  static void md_start_sync(struct work_struct *ws)
>  {
> -	struct mddev *mddev = container_of(ws, struct mddev, del_work);
> +	struct mddev *mddev = container_of(ws, struct mddev, sync_work);
>  
>  	mddev->sync_thread = md_register_thread(md_do_sync,
>  						mddev,
> @@ -8823,8 +8827,8 @@ void md_check_recovery(struct mddev *mddev)
>  				 */
>  				bitmap_write_all(mddev->bitmap);
>  			}
> -			INIT_WORK(&mddev->del_work, md_start_sync);
> -			queue_work(md_misc_wq, &mddev->del_work);
> +			INIT_WORK(&mddev->sync_work, md_start_sync);
> +			queue_work(md_misc_wq, &mddev->sync_work);
>  			goto unlock;
>  		}
>  	not_running:
> @@ -9018,15 +9022,13 @@ static int __init md_init(void)
>  	int ret = -ENOMEM;
>  
>  	md_wq = alloc_workqueue("md", WQ_MEM_RECLAIM, 0);
> -	if (!md_wq)
> -		goto err_wq;
> -
> +	md_del_wq = alloc_workqueue("md_del", 0, 0);
>  	md_misc_wq = alloc_workqueue("md_misc", 0, 0);
> -	if (!md_misc_wq)
> -		goto err_misc_wq;
> +	if (!md_wq || !md_del_wq || !md_misc_wq)
> +		goto err;
>  
>  	if ((ret = register_blkdev(MD_MAJOR, "md")) < 0)
> -		goto err_md;
> +		goto err;
>  
>  	if ((ret = register_blkdev(0, "mdp")) < 0)
>  		goto err_mdp;
> @@ -9045,11 +9047,13 @@ static int __init md_init(void)
>  
>  err_mdp:
>  	unregister_blkdev(MD_MAJOR, "md");
> -err_md:
> -	destroy_workqueue(md_misc_wq);
> -err_misc_wq:
> -	destroy_workqueue(md_wq);
> -err_wq:
> +err:
> +	if (md_wq)
> +		destroy_workqueue(md_wq);
> +	if (md_del_wq)
> +		destroy_workqueue(md_del_wq);
> +	if (md_misc_wq)
> +		destroy_workqueue(md_misc_wq);
>  	return ret;
>  }
>  
> @@ -9304,6 +9308,7 @@ static __exit void md_exit(void)
>  		 */
>  	}
>  	destroy_workqueue(md_misc_wq);
> +	destroy_workqueue(md_del_wq);
>  	destroy_workqueue(md_wq);
>  }
>  
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 03fc641e5da1..8c2158f3bd59 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -397,6 +397,7 @@ struct mddev {
>  	struct kernfs_node		*sysfs_action;  /* handle for 'sync_action' */
>  
>  	struct work_struct del_work;	/* used for delayed sysfs removal */
> +	struct work_struct sync_work;	/* used for async starting of md_do_sync */
>  
>  	/* "lock" protects:
>  	 *   flush_bio transition from NULL to !NULL
> -- 
> 2.14.0.rc0.dirty
> 


