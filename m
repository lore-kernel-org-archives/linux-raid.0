From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: Re: [PATCH] md: optimize barrier usage for Rmw atomic bitops
Date: Fri, 31 Jan 2020 17:43:34 +0100
Message-ID: <a7358719-55af-6510-952e-df8f202f1ab9@cloud.ionos.com>
References: <20200129181437.25155-1-dave@stgolabs.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200129181437.25155-1-dave@stgolabs.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Davidlohr Bueso <dave@stgolabs.net>, song@kernel.org
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-raid.ids



On 1/29/20 7:14 PM, Davidlohr Bueso wrote:
> For both set and clear_bit, we can avoid the unnecessary barrier
> on non LL/SC architectures, such as x86. Instead, use the
> smp_mb__{before,after}_atomic() calls.
> 
> Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
> ---
>   drivers/md/md.c     | 2 +-
>   drivers/md/raid10.c | 7 ++++---
>   drivers/md/raid5.c  | 9 +++++----
>   3 files changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 4824d50526fa..4ed2eb6933f7 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2561,7 +2561,7 @@ static bool set_in_sync(struct mddev *mddev)
>   			 * Ensure ->in_sync is visible before we clear
>   			 * ->sync_checkers.
>   			 */
> -			smp_mb();
> +			smp_mb__before_atomic();
>   			set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
>   			sysfs_notify_dirent_safe(mddev->sysfs_state);
>   		}
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index ec136e44aef7..1993a1958c75 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1865,9 +1865,10 @@ static int raid10_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
>   		/* We must have just cleared 'rdev' */
>   		p->rdev = p->replacement;
>   		clear_bit(Replacement, &p->replacement->flags);
> -		smp_mb(); /* Make sure other CPUs may see both as identical
> -			   * but will never see neither -- if they are careful.
> -			   */
> +		/* Make sure other CPUs may see both as identical
> +		 * but will never see neither -- if they are careful.
> +		 */

Since we are here, it is better to change the comment style to

/*
  * ...
  */

> +		smp_mb__after_atomic();
>   		p->replacement = NULL;
>   	}
>   
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index ba00e9877f02..3ad6209287cf 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -364,7 +364,7 @@ static int release_stripe_list(struct r5conf *conf,
>   		int hash;
>   
>   		/* sh could be readded after STRIPE_ON_RELEASE_LIST is cleard */
> -		smp_mb();
> +		smp_mb__before_atomic();
>   		clear_bit(STRIPE_ON_RELEASE_LIST, &sh->state);
>   		/*
>   		 * Don't worry the bit is set here, because if the bit is set
> @@ -7654,9 +7654,10 @@ static int raid5_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
>   		/* We must have just cleared 'rdev' */
>   		p->rdev = p->replacement;
>   		clear_bit(Replacement, &p->replacement->flags);
> -		smp_mb(); /* Make sure other CPUs may see both as identical
> -			   * but will never see neither - if they are careful
> -			   */

Ditto.

Acked-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>

Thanks,
Guoqing
