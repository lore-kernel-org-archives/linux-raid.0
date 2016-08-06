From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH][RESEND] md: Prevent IO hold during accessing to faulty
 raid5 array
Date: Fri, 5 Aug 2016 22:01:01 -0700
Message-ID: <20160806050101.GA53971@kernel.org>
References: <1470211376-25201-1-git-send-email-aleksey.obitotskiy@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1470211376-25201-1-git-send-email-aleksey.obitotskiy@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexey Obitotskiy <aleksey.obitotskiy@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Aug 03, 2016 at 10:02:56AM +0200, Alexey Obitotskiy wrote:
> After array enters in faulty state (e.g. number of failed drives
> becomes more then accepted for raid5 level) it sets error flags
> (one of this flags is MD_CHANGE_PENDING). For internal metadata
> arrays MD_CHANGE_PENDING cleared into md_update_sb, but not for
> external metadata arrays. MD_CHANGE_PENDING flag set prevents to
> finish all new or non-finished IOs to array and hold them in
> pending state. In some cases this can leads to deadlock situation.
> 
> For example, we have faulty array (2 of 4 drives failed) and
> udev handle array state changes and blkid started (or other 
> userspace application that used array to read/write) but unable 
> to finish reads due to IO hold. At the same time we unable to get 
> exclusive access to array (to stop array in our case) because 
> another external application still use this array.
> 
> Fix makes possible to return IO with errors immediately.
> So external application can finish working with array and
> give exclusive access to other applications to perform
> required management actions with array.
> 
> Signed-off-by: Alexey Obitotskiy <aleksey.obitotskiy@intel.com>
> ---
>  drivers/md/raid5.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 6c1149d..99471b6 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -4692,7 +4692,9 @@ finish:
>  	}
>  
>  	if (!bio_list_empty(&s.return_bi)) {
> -		if (test_bit(MD_CHANGE_PENDING, &conf->mddev->flags)) {
> +		if (test_bit(MD_CHANGE_PENDING, &conf->mddev->flags) &&
> +				(s.failed <= conf->max_degraded ||
> +					conf->mddev->external == 0)) {
>  			spin_lock_irq(&conf->device_lock);
>  			bio_list_merge(&conf->return_bi, &s.return_bi);
>  			spin_unlock_irq(&conf->device_lock);

So the external metadata array will have the potential race Neil's patch
(c3cce6cda162eb) tried to fix. But we probably can't do too much for it.
Applied this one.

Thanks,
Shaohua
