From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md: clear WantReplacement once disk is removed
Date: Tue, 25 Apr 2017 09:36:07 -0700
Message-ID: <20170425163607.x2ujyfp4esstm5ol@kernel.org>
References: <20170424075804.19103-1-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170424075804.19103-1-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.com
List-Id: linux-raid.ids

On Mon, Apr 24, 2017 at 03:58:04PM +0800, Guoqing Jiang wrote:
> We can clear 'WantReplacement' flag directly no
> matter it's replacement existed or not since the
> semantic is same as before.
> 
> Also since the disk is removed from array, then
> it is straightforward to remove 'WantReplacement'
> flag and the comments in raid10/5 can be removed
> as well.

applied, thanks! 
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>  drivers/md/raid1.c  | 6 +++---
>  drivers/md/raid10.c | 8 ++------
>  drivers/md/raid5.c  | 9 +++------
>  3 files changed, 8 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 57611f4..e93dd50 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1831,9 +1831,9 @@ static int raid1_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
>  			p->rdev = repl;
>  			conf->mirrors[conf->raid_disks + number].rdev = NULL;
>  			unfreeze_array(conf);
> -			clear_bit(WantReplacement, &rdev->flags);
> -		} else
> -			clear_bit(WantReplacement, &rdev->flags);
> +		}
> +
> +		clear_bit(WantReplacement, &rdev->flags);
>  		err = md_integrity_register(mddev);
>  	}
>  abort:
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index acb3f46..72b2a9c 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1874,13 +1874,9 @@ static int raid10_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
>  			   * but will never see neither -- if they are careful.
>  			   */
>  		p->replacement = NULL;
> -		clear_bit(WantReplacement, &rdev->flags);
> -	} else
> -		/* We might have just remove the Replacement as faulty
> -		 * Clear the flag just in case
> -		 */
> -		clear_bit(WantReplacement, &rdev->flags);
> +	}
>  
> +	clear_bit(WantReplacement, &rdev->flags);
>  	err = md_integrity_register(mddev);
>  
>  abort:
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 356cd9c..3d971e5 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -7603,15 +7603,12 @@ static int raid5_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
>  			   * but will never see neither - if they are careful
>  			   */
>  		p->replacement = NULL;
> -		clear_bit(WantReplacement, &rdev->flags);
>  
>  		if (!err)
>  			err = log_modify(conf, p->rdev, true);
> -	} else
> -		/* We might have just removed the Replacement as faulty-
> -		 * clear the bit just in case
> -		 */
> -		clear_bit(WantReplacement, &rdev->flags);
> +	}
> +
> +	clear_bit(WantReplacement, &rdev->flags);
>  abort:
>  
>  	print_raid5_conf(conf);
> -- 
> 2.10.0
> 
