From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v2 1/2] md/raid5: Add change_consistency_policy to raid4
 and raid6
Date: Fri, 24 Mar 2017 07:45:35 -0700
Message-ID: <20170324144535.chk4jgktism4mvlu@kernel.org>
References: <20170316221409.3283344-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170316221409.3283344-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, jes.sorensen@gmail.com
List-Id: linux-raid.ids

On Thu, Mar 16, 2017 at 03:14:08PM -0700, Song Liu wrote:
> Add change_consistency_policy to raid6_personality and
> raid4_personality.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  drivers/md/raid5.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 88cc898..7a6e7ea 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -8408,6 +8408,7 @@ static struct md_personality raid6_personality =
>  	.quiesce	= raid5_quiesce,
>  	.takeover	= raid6_takeover,
>  	.congested	= raid5_congested,
> +	.change_consistency_policy = raid5_change_consistency_policy,
>  };
>  static struct md_personality raid5_personality =
>  {
> @@ -8456,6 +8457,7 @@ static struct md_personality raid4_personality =
>  	.quiesce	= raid5_quiesce,
>  	.takeover	= raid4_takeover,
>  	.congested	= raid5_congested,
> +	.change_consistency_policy = raid5_change_consistency_policy,
>  };
sorry for the late reply.

the change_consistency_policy is only for raid5 for a reason, ppl is only for
raid5. I think you need to filter out raid 4/6 in
raid5_change_consistency_policy for ppl.

Thanks,
Shaohua
>  
>  static int __init raid5_init(void)
> -- 
> 2.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
