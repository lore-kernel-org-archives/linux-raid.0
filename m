From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] md: move revalidate_disk() back outside open_mutex
Date: Mon, 9 Aug 2010 09:56:07 +1000
Message-ID: <20100809095607.25ccb3e9@notabene>
References: <20100807010159.2745.75952.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100807010159.2745.75952.stgit@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, stable@kernel.org, Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

On Fri, 06 Aug 2010 18:01:59 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> Commit b821eaa5 "md: remove ->changed and related code" moved
> revalidate_disk() under open_mutex, and lockdep noticed.
> 
> [ INFO: possible circular locking dependency detected ]
> 2.6.32-mdadm-locking #1
> -------------------------------------------------------
> mdadm/3640 is trying to acquire lock:
>  (&bdev->bd_mutex){+.+.+.}, at: [<ffffffff811acecb>] revalidate_disk+0x5b/0x90
> 
> but task is already holding lock:
>  (&mddev->open_mutex){+.+...}, at: [<ffffffffa055e07a>] do_md_stop+0x4a/0x4d0 [md_mod]
> 
> which lock already depends on the new lock.

Thanks!  applied and sent to Linus - as you might have noticed.

I didn't really like the 'revalidate' variable, and realised that the 'err'
variable wasn't really needed either so added a patch to restructure the
function a little bit.

Thanks,
NeilBrown


> 
> Cc: <stable@kernel.org>
> Reported-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/md/md.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index cb20d0b..9743554 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -4711,7 +4711,7 @@ out:
>   */
>  static int do_md_stop(mddev_t * mddev, int mode, int is_open)
>  {
> -	int err = 0;
> +	int err = 0, revalidate = 0;
>  	struct gendisk *disk = mddev->gendisk;
>  	mdk_rdev_t *rdev;
>  
> @@ -4740,7 +4740,7 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
>  			}
>  
>  		set_capacity(disk, 0);
> -		revalidate_disk(disk);
> +		revalidate = 1;
>  
>  		if (mddev->ro)
>  			mddev->ro = 0;
> @@ -4748,6 +4748,8 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
>  		err = 0;
>  	}
>  	mutex_unlock(&mddev->open_mutex);
> +	if (revalidate)
> +		revalidate_disk(disk);
>  	if (err)
>  		return err;
>  	/*
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

