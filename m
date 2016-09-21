From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] raid5: fix to detect failure of register_shrinker
Date: Wed, 21 Sep 2016 09:01:10 -0700
Message-ID: <20160921160110.GA30281@kernel.org>
References: <20160920023357.872-1-yuchao0@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160920023357.872-1-yuchao0@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chao Yu <yuchao0@huawei.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, chao@kernel.org
List-Id: linux-raid.ids

On Tue, Sep 20, 2016 at 10:33:57AM +0800, Chao Yu wrote:
> register_shrinker can fail after commit 1d3d4437eae1 ("vmscan: per-node
> deferred work"), we should detect the failure of it, otherwise we may
> fail to register shrinker after raid5 configuration was setup successfully.
> 
> Signed-off-by: Chao Yu <yuchao0@huawei.com>
> ---
>  drivers/md/raid5.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 766c3b7..b819a9a 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -6632,7 +6632,12 @@ static struct r5conf *setup_conf(struct mddev *mddev)
>  	conf->shrinker.count_objects = raid5_cache_count;
>  	conf->shrinker.batch = 128;
>  	conf->shrinker.flags = 0;
> -	register_shrinker(&conf->shrinker);
> +	if (register_shrinker(&conf->shrinker)) {
> +		printk(KERN_ERR
> +		       "md/raid:%s: couldn't register shrinker.\n",
> +		       mdname(mddev));
> +		goto abort;
> +	}
>  
>  	sprintf(pers_name, "raid%d", mddev->new_level);
>  	conf->thread = md_register_thread(raid5d, mddev, pers_name);

shrinker isn't fatal for raid5. Idealy we can ignore the error and stop
automatically stripe cache increase, but probable it's not worthy the effort.
Applied the patch.

Also the free_conf need better way to check if shrinker register successes. I
add another patch to fix it.

Thanks,
Shaohua
