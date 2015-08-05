From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 9/9] raid5: skip resync if cache(log) is enabled
Date: Wed, 5 Aug 2015 14:16:57 +1000
Message-ID: <20150805141657.1f193bc2@noble>
References: <cover.1438215986.git.shli@fb.com>
	<406d69eccd47d2eb57fca57bbafb9871e0858dcf.1438215986.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <406d69eccd47d2eb57fca57bbafb9871e0858dcf.1438215986.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

On Wed, 29 Jul 2015 17:38:49 -0700 Shaohua Li <shli@fb.com> wrote:

> If cache(log) is enabled, the log structure will guarantee data
> consistency, so skip resync for unclean shutdown
> 
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  drivers/md/raid5.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 26ea100..330550a 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -6967,6 +6967,15 @@ static int run(struct mddev *mddev)
>  		}
>  	}
>  
> +	if (conf->log) {
> +		if (mddev->recovery_cp == 0) {
> +			printk(KERN_NOTICE
> +				"md/raid:%s: skip resync with caching enabled\n",
> +				mdname(mddev));
> +			mddev->recovery_cp = MaxSector;
> +		}
> +	}
> +
>  	return 0;
>  abort:
>  	md_unregister_thread(&mddev->thread);

I don't think this is correct.  When a RAID6 is started, recovery_cp
will be zero and we really do want a resync to happen even if there is
a log.

Rather, I think that recovery_cp should not be set to zero when a log
is being used.  So keep the array appearing to be "clean".
If recovery_cp ever does get set to zero (mdadm --assemble
--update=resync can do this), then do the resync.

Thanks,
NeilBrown
