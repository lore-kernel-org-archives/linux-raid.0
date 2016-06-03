From: Shaohua Li <shli@kernel.org>
Subject: Re: [md PATCH 05/18] md/raid10: add rcu protection to rdev access in
 raid10_sync_request.
Date: Fri, 3 Jun 2016 15:33:15 -0700
Message-ID: <20160603223315.GC1898@kernel.org>
References: <20160602061319.2939.72280.stgit@noble>
 <20160602061952.2939.98809.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160602061952.2939.98809.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jun 02, 2016 at 04:19:52PM +1000, Neil Brown wrote:
> mirrors[].rdev can become NULL at any point unless:
>   - a counted reference is held
>   - ->reconfig_mutex is held, or
>   - rcu_read_lock() is held
> 
> Previously they could not become NULL during a resync/recovery/reshape either.
> However when remove_and_add_spares() was added to hot_remove_disk(), that
> changed.
> 
> So raid10_sync_request didn't previously need to protect rdev access,
> but now it does.
> 
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
>  drivers/md/raid10.c |  120 +++++++++++++++++++++++++++++++--------------------
>  1 file changed, 72 insertions(+), 48 deletions(-)
> 
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index e6f3a11f8f70..f6f21a253926 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -2871,11 +2871,14 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
>  				/* Completed a full sync so the replacements
>  				 * are now fully recovered.
>  				 */
> -				for (i = 0; i < conf->geo.raid_disks; i++)
> -					if (conf->mirrors[i].replacement)
> -						conf->mirrors[i].replacement
> -							->recovery_offset
> -							= MaxSector;
> +				rcu_read_lock();
> +				for (i = 0; i < conf->geo.raid_disks; i++) {
> +					struct md_rdev *rdev =
> +						rcu_dereference(conf->mirrors[i].replacement);
> +					if (rdev)
> +						rdev->recovery_offset = MaxSector;
> +				}
> +				rcu_read_unlock();
>  			}
>  			conf->fullsync = 0;
>  		}
> @@ -2934,14 +2937,17 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
>  			int must_sync;
>  			int any_working;
>  			struct raid10_info *mirror = &conf->mirrors[i];
> +			struct md_rdev *mrdev, *mreplace;
>  
> -			if ((mirror->rdev == NULL ||
> -			     test_bit(In_sync, &mirror->rdev->flags))
> -			    &&
> -			    (mirror->replacement == NULL ||
> -			     test_bit(Faulty,
> -				      &mirror->replacement->flags)))
> +			rcu_read_lock();
> +			mrdev = rcu_dereference(mirror->rdev);
> +			mreplace = rcu_dereference(mirror->replacement);
> +
> +			if ((mrdev == NULL ||
> +			     test_bit(In_sync, &mrdev->flags))) {
> +				rcu_read_unlock();
>  				continue;
> +			}

We don't check mreplace here.

Thanks,
Shaohua
