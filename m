From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: [PATCH] drivers/md/md.c: ignore recovery_offset if bitmap exists
Date: Wed, 29 Jul 2015 16:46:21 -0400
Message-ID: <55B93B9D.5000103@stratus.com>
References: <1438111733-17778-1-git-send-email-nate.dailey@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1438111733-17778-1-git-send-email-nate.dailey@stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Ben Hutchings <ben@decadent.org.uk>, Cyril Vechera <cv@io.ru>
List-Id: linux-raid.ids

On 07/28/2015 03:28 PM, Nate Dailey wrote:
> If a bitmap recovery is interrupted and later restarted, then
> sectors below the recovery offset, written between interruption
> and resumption, will not be copied. This results in corruption.
> 
> See https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=777511
> for a script that can be used to repro this.
> 
> Seems like ignoring the recovery_offset if a bitmap exists is
> the way to go.
> 
> Signed-off-by: Nate Dailey <nate.dailey@stratus.com>
> ---
>  drivers/md/md.c | 24 +++++++++++++-----------
>  1 file changed, 13 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 0c2a4e8..79c6285 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7738,16 +7738,18 @@ void md_do_sync(struct md_thread *thread)
>  	else {
>  		/* recovery follows the physical size of devices */
>  		max_sectors = mddev->dev_sectors;
> -		j = MaxSector;
> -		rcu_read_lock();
> -		rdev_for_each_rcu(rdev, mddev)
> -			if (rdev->raid_disk >= 0 &&
> -			    !test_bit(Faulty, &rdev->flags) &&
> -			    !test_bit(In_sync, &rdev->flags) &&
> -			    rdev->recovery_offset < j)
> -				j = rdev->recovery_offset;
> -		rcu_read_unlock();
> -
> +		/* we don't use the offset if there's a bitmap */
> +		if (!mddev->bitmap) {
> +			j = MaxSector;
> +			rcu_read_lock();
> +			rdev_for_each_rcu(rdev, mddev)
> +				if (rdev->raid_disk >= 0 &&
> +				    !test_bit(Faulty, &rdev->flags) &&
> +				    !test_bit(In_sync, &rdev->flags) &&
> +				    rdev->recovery_offset < j)
> +					j = rdev->recovery_offset;
> +			rcu_read_unlock();
> +		}
>  		/* If there is a bitmap, we need to make sure all
>  		 * writes that started before we added a spare
>  		 * complete before we start doing a recovery.
> @@ -7756,7 +7758,7 @@ void md_do_sync(struct md_thread *thread)
>  		 * recovery has checked that bit and skipped that
>  		 * region.
>  		 */
> -		if (mddev->bitmap) {
> +		else {
>  			mddev->pers->quiesce(mddev, 1);
>  			mddev->pers->quiesce(mddev, 0);
>  		}
> 

[+cc Ben & Cyril from the Debian bug report]

-- Joe

