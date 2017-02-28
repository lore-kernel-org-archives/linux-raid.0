From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v4 6/7] raid5-ppl: support disk hot add/remove with PPL
Date: Mon, 27 Feb 2017 17:22:26 -0800
Message-ID: <20170228012226.xo76v3cdgqfddx4k@kernel.org>
References: <20170221194401.18733-1-artur.paszkiewicz@intel.com>
 <20170221194401.18733-7-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170221194401.18733-7-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: shli@fb.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Feb 21, 2017 at 08:44:00PM +0100, Artur Paszkiewicz wrote:
> Add a function to modify the log by removing an rdev when a drive fails
> or adding when a spare/replacement is activated as a raid member.
> 
> Removing a disk just clears the child log rdev pointer. No new stripes
> will be accepted for this child log in ppl_write_stripe() and running io
> units will be processed without writing PPL to the device.
> 
> Adding a disk sets the child log rdev pointer and writes an empty PPL
> header.
> 
> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> ---
>  drivers/md/raid5-ppl.c | 47 +++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/md/raid5.c     | 15 +++++++++++++++
>  drivers/md/raid5.h     |  8 ++++++++
>  3 files changed, 70 insertions(+)
> 
> diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
> index a7693353243a..c2070d124849 100644
> --- a/drivers/md/raid5-ppl.c
> +++ b/drivers/md/raid5-ppl.c
> @@ -319,6 +319,12 @@ static void ppl_submit_iounit(struct ppl_io_unit *io)
>  
>  	bio = bio_alloc_bioset(GFP_NOIO, BIO_MAX_PAGES, ppl_conf->bs);
>  	bio->bi_private = io;
> +
> +	if (!log->rdev || test_bit(Faulty, &log->rdev->flags)) {
> +		ppl_log_endio(bio);
> +		return;
> +	}
> +
>  	bio->bi_end_io = ppl_log_endio;
>  	bio->bi_opf = REQ_OP_WRITE | REQ_FUA;
>  	bio->bi_bdev = log->rdev->bdev;
> @@ -1098,3 +1104,44 @@ int ppl_init_log(struct r5conf *conf)
>  	ppl_exit_log(ppl_conf);
>  	return ret;
>  }
> +
> +int ppl_modify_log(struct ppl_conf *ppl_conf, struct md_rdev *rdev,
> +		   enum ppl_modify_log_operation operation)
> +{
> +	struct ppl_log *log;
> +	int ret = 0;
> +	char b[BDEVNAME_SIZE];
> +
> +	if (!rdev)
> +		return -EINVAL;
> +
> +	pr_debug("%s: disk: %d operation: %s dev: %s\n",
> +		 __func__, rdev->raid_disk,
> +		 operation == PPL_MODIFY_LOG_DISK_REMOVE ? "remove" :
> +		 (operation == PPL_MODIFY_LOG_DISK_ADD ? "add" : "?"),
> +		 bdevname(rdev->bdev, b));
> +
> +	if (rdev->raid_disk < 0)
> +		return 0;
> +
> +	if (rdev->raid_disk >= ppl_conf->count)
> +		return -ENODEV;
> +
> +	log = &ppl_conf->child_logs[rdev->raid_disk];
> +
> +	mutex_lock(&log->io_mutex);
> +	if (operation == PPL_MODIFY_LOG_DISK_REMOVE) {
> +		log->rdev = NULL;
> +	} else if (operation == PPL_MODIFY_LOG_DISK_ADD) {
> +		ret = ppl_validate_rdev(rdev);
> +		if (!ret) {
> +			log->rdev = rdev;
> +			ret = ppl_write_empty_header(log);
> +		}
> +	} else {
> +		ret = -EINVAL;
> +	}
> +	mutex_unlock(&log->io_mutex);
> +
> +	return ret;
> +}
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 8b52392457d8..b17e90f06f19 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -7623,6 +7623,12 @@ static int raid5_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
>  			*rdevp = rdev;
>  		}
>  	}
> +	if (conf->ppl) {
> +		err = ppl_modify_log(conf->ppl, rdev,
> +				     PPL_MODIFY_LOG_DISK_REMOVE);
> +		if (err)
> +			goto abort;
> +	}
>  	if (p->replacement) {
>  		/* We must have just cleared 'rdev' */
>  		p->rdev = p->replacement;
> @@ -7632,6 +7638,10 @@ static int raid5_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
>  			   */
>  		p->replacement = NULL;
>  		clear_bit(WantReplacement, &rdev->flags);
> +
> +		if (conf->ppl)
> +			err = ppl_modify_log(conf->ppl, p->rdev,
> +					     PPL_MODIFY_LOG_DISK_ADD);
>  	} else
>  		/* We might have just removed the Replacement as faulty-
>  		 * clear the bit just in case
> @@ -7695,6 +7705,11 @@ static int raid5_add_disk(struct mddev *mddev, struct md_rdev *rdev)
>  			if (rdev->saved_raid_disk != disk)
>  				conf->fullsync = 1;
>  			rcu_assign_pointer(p->rdev, rdev);
> +
> +			if (conf->ppl)
> +				err = ppl_modify_log(conf->ppl, rdev,
> +						     PPL_MODIFY_LOG_DISK_ADD);
> +
>  			goto out;
>  		}
>  	}
> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index f915a7a0e752..43cfa5fa71b3 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -806,4 +806,12 @@ extern void ppl_exit_log(struct ppl_conf *log);
>  extern int ppl_write_stripe(struct ppl_conf *log, struct stripe_head *sh);
>  extern void ppl_write_stripe_run(struct ppl_conf *log);
>  extern void ppl_stripe_write_finished(struct stripe_head *sh);
> +
> +enum ppl_modify_log_operation {
> +	PPL_MODIFY_LOG_DISK_REMOVE,
> +	PPL_MODIFY_LOG_DISK_ADD,
> +};

a bool for this parameter is better

> +extern int ppl_modify_log(struct ppl_conf *log, struct md_rdev *rdev,
> +			  enum ppl_modify_log_operation operation);

So this should be put into raid5-log.h and rename to log_modify_log(conf, xxx)
or other sensible name.

Thanks,
Shaohua
