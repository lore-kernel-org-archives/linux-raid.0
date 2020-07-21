From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: Re: [PATCH v5 1/2] md-cluster: fix safemode_delay value when
 converting to clustered bitmap
Date: Tue, 21 Jul 2020 10:35:11 +0200
Message-ID: <8f122dea-2a4a-4523-653f-fe6fc2842653@cloud.ionos.com>
References: <1595268533-7040-1-git-send-email-heming.zhao@suse.com>
 <1595268533-7040-2-git-send-email-heming.zhao@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1595268533-7040-2-git-send-email-heming.zhao@suse.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Zhao Heming <heming.zhao@suse.com>, linux-raid@vger.kernel.org
Cc: neilb@suse.com, song@kernel.org
List-Id: linux-raid.ids



On 7/20/20 8:08 PM, Zhao Heming wrote:
> When array convert to clustered bitmap, the safe_mode_delay doesn't
> clean and vice versa. the /sys/block/mdX/md/safe_mode_delay keep original
> value after changing bitmap type. In safe_delay_store(), the code forbids
> setting mddev->safemode_delay when array is clustered. So in cluster-md
> env, the expected safemode_delay value should be 0.
>
> Reproducible steps:
> ```
> node1 # mdadm --zero-superblock /dev/sd{b,c,d}
> node1 # mdadm -C /dev/md0 -b internal -e 1.2 -n 2 -l mirror /dev/sdb /dev/sdc
> node1 # cat /sys/block/md0/md/safe_mode_delay
> 0.204
> node1 # mdadm -G /dev/md0 -b none
> node1 # mdadm --grow /dev/md0 --bitmap=clustered
> node1 # cat /sys/block/md0/md/safe_mode_delay
> 0.204  <== doesn't change, should ZERO for cluster-md
>
> node1 # mdadm --zero-superblock /dev/sd{b,c,d}
> node1 # mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sdb /dev/sdc
> node1 # cat /sys/block/md0/md/safe_mode_delay
> 0.000
> node1 # mdadm -G /dev/md0 -b none
> node1 # cat /sys/block/md0/md/safe_mode_delay
> 0.000  <== doesn't change, should default value
> ```
>
> Signed-off-by: Zhao Heming <heming.zhao@suse.com>
> ---
>   drivers/md/md.c | 11 +++++++++--
>   1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index f567f536b529..1bde3df3fa18 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -101,6 +101,8 @@ static void mddev_detach(struct mddev *mddev);
>    * count by 2 for every hour elapsed between read errors.
>    */
>   #define MD_DEFAULT_MAX_CORRECTED_READ_ERRORS 20
> +/* Default safemode delay: 200 msec */
> +#define DEFAULT_SAFEMODE_DELAY ((200 * HZ)/1000 +1)
>   /*
>    * Current RAID-1,4,5 parallel reconstruction 'guaranteed speed limit'
>    * is 1000 KB/sec, so the extra system load does not show up that much.
> @@ -5982,7 +5984,7 @@ int md_run(struct mddev *mddev)
>   	if (mddev_is_clustered(mddev))
>   		mddev->safemode_delay = 0;
>   	else
> -		mddev->safemode_delay = (200 * HZ)/1000 +1; /* 200 msec delay */
> +		mddev->safemode_delay = DEFAULT_SAFEMODE_DELAY;
>   	mddev->in_sync = 1;
>   	smp_wmb();
>   	spin_lock(&mddev->lock);
> @@ -7361,6 +7363,7 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
>   
>   				mddev->bitmap_info.nodes = 0;
>   				md_cluster_ops->leave(mddev);
> +				mddev->safemode_delay = DEFAULT_SAFEMODE_DELAY;
>   			}

Not about the patch itself, just confuse about the meaning of 
safemode_delay.
As safemode_delay represents 200 ms delay, but md_write_end has this.

                 /* The roundup() ensures this only performs locking once
                  * every ->safemode_delay *jiffies*
                  */
                 mod_timer(&mddev->safemode_timer,
                           roundup(jiffies, mddev->safemode_delay) +
                           mddev->safemode_delay);

And the second argument in mod_timer() means "new timeout in jiffies",
does the above need to convert from ms to jiffies? Am I miss something?

Thanks,
Guoqing
