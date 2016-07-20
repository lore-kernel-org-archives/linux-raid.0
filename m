From: "Obitotskiy, Aleksey" <aleksey.obitotskiy@intel.com>
Subject: RE: [PATCH] md: Prevent IO hold during accessing to failed raid5
 array
Date: Wed, 20 Jul 2016 06:25:25 +0000
Message-ID: <1711F56538688D48B9D557E3AD42AEA6307FBA@IRSMSX101.ger.corp.intel.com>
References: <1468589067-1966-1-git-send-email-aleksey.obitotskiy@intel.com>
 <20160719224603.GB79792@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160719224603.GB79792@kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

md_update_sb does not clean MD_CHANGE_PENDING flag for imsm arrays (i.e. external == 1).
And until MD_CHANGE_PENDING is set all remaining or new IO will not be finished
but will stay in return_bi list.

Regards,
Aleskey

-----Original Message-----
From: Shaohua Li [mailto:shli@kernel.org] 
Sent: Wednesday, 20 July, 2016 00:46
To: Obitotskiy, Aleksey <aleksey.obitotskiy@intel.com>
Cc: linux-raid@vger.kernel.org
Subject: Re: [PATCH] md: Prevent IO hold during accessing to failed raid5 array

On Fri, Jul 15, 2016 at 03:24:27PM +0200, Alexey Obitotskiy wrote:
> After array enters in failed state (e.g. number of failed drives 
> becomes more then accepted for raid5 level) it sets error flags (one 
> of this flags is MD_CHANGE_PENDING). This flag prevents to finish all 
> new or non-finished IOs to array and hold them in pending state. In 
> some cases this can leads to deadlock situation.
> 
> For example udev handle array state changes (drives becomes faulty) 
> and blkid started but unable to finish reads due to IO hold.
> At the same time we unable to get exclusive access to array (to stop 
> array in our case) because another external application still use this 
> array (blkid in our case).
> 
> Fix makes possible to return IO with errors immediately.
> So external application can finish working with array and give 
> exclusive access to other applications.
> 
> Signed-off-by: Alexey Obitotskiy <aleksey.obitotskiy@intel.com>
> ---
>  drivers/md/raid5.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c index 
> 6c1149d..99471b6 100644
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
> --
> 2.7.4

Hi Alexey,

I'm not clear about the race. When we set the MD_CHANGE_PENDING, we will schedule superblock write, which will eventually finish (either success or timedout). Why will the IO be hold forever?

Thanks,
Shaohua
