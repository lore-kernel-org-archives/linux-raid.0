From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/2] md/bitmap: use proper accessor macro
Date: Wed, 8 Jun 2011 12:37:51 +1000
Message-ID: <20110608123751.41abc489@notabene.brown>
References: <1307458172-19373-1-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1307458172-19373-1-git-send-email-namhyung@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue,  7 Jun 2011 23:49:31 +0900 Namhyung Kim <namhyung@gmail.com> wrote:

> Use COUNTER()/NEEDED() macro instead of open-coding them.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  drivers/md/bitmap.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index 70bd738b8b99..8b40bd71bb4a 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -1332,7 +1332,7 @@ int bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long sect
>  			return 0;
>  		}
>  
> -		if (unlikely((*bmc & COUNTER_MAX) == COUNTER_MAX)) {
> +		if (unlikely(COUNTER(*bmc) == COUNTER_MAX)) {
>  			DEFINE_WAIT(__wait);
>  			/* note that it is safe to do the prepare_to_wait
>  			 * after the test as long as we do it before dropping
> @@ -1404,10 +1404,10 @@ void bitmap_endwrite(struct bitmap *bitmap, sector_t offset, unsigned long secto
>  			sysfs_notify_dirent_safe(bitmap->sysfs_can_clear);
>  		}
>  
> -		if (!success && ! (*bmc & NEEDED_MASK))
> +		if (!success && !NEEDED(*bmc))
>  			*bmc |= NEEDED_MASK;
>  
> -		if ((*bmc & COUNTER_MAX) == COUNTER_MAX)
> +		if (COUNTER(*bmc) == COUNTER_MAX)
>  			wake_up(&bitmap->overflow_wait);
>  
>  		(*bmc)--;


Thanks....

Personally I loathe such macros - I prefer things to be open codes so I can
see what is happening without having to guess.
But as we have the macros and they are already in use we should be consistent
and use them everywhere.
So I'll apply the patch.

Thanks,
NeilBrown

