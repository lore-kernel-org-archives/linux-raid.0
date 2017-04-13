From: Shaohua Li <shli@kernel.org>
Subject: Re: GET_ARRAY_INFO assumptions?
Date: Thu, 13 Apr 2017 13:37:42 -0700
Message-ID: <20170413203742.wg6mrnzedw7ew5ky@kernel.org>
References: <ab07d303-85fb-e912-e4fa-9ee66a1277cc@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ab07d303-85fb-e912-e4fa-9ee66a1277cc@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Apr 13, 2017 at 01:50:06PM -0400, Jes Sorensen wrote:
> Hi Neil,
> 
> Looking at trying to phase out the ioctl usage, I am trying to introduce a
> helper for the 'is the array valid' situation.
> 
> Now looking at places like Incremental.c (around like 557 in my current
> tree):
> 	/* 7b/ if yes, */
> 	/* - if number of OK devices match expected, or -R and there */
> 	/*             are enough, */
> 	/*   + add any bitmap file  */
> 	/*   + start the array (auto-readonly). */
> 
> 	if (md_get_array_info(mdfd, &ainf) == 0) {
> 		if (c->export) {
> 			printf("MD_STARTED=already\n");
> 		} else if (c->verbose >= 0)
> 			pr_err("%s attached to %s which is already active.\n",
> 			       devname, chosen_name);
> 		rv = 0;
> 		goto out_unlock;
> 	}
> 
> I am wondering if there are any side effects/assumptions about
> GET_ARRAY_INFO that I am not considering? Basically I am making the
> assumption that if /sys/block/md<X>/md exists, the array is valid.

what does 'valid' really mean? md<x>/md exists after a md device is allocated,
the md device might not have any under layer disks bound yet.

> The code in Incremental.c already deals with sysfs higher up in the code, so
> I guess the question is if the above test is even relevant anymore?
> 
> Alternative, do we need export a new state in sysfs 'running'?

I'd assume 'running' means the md device has a personality attached. See
array_state_show(), !running == 'clear' or 'inactive'.


Thanks,
Shaohua
> Thoughts?
> 
> Jes
> 
> diff --git a/util.c b/util.c
> index a695c45..99ed015 100644
> --- a/util.c
> +++ b/util.c
> @@ -200,6 +200,22 @@ out:
>         return ret;
>  }
> 
> +int md_valid_array(int fd)
> +{
> +       struct mdinfo *sra;
> +       struct mdu_array_info_s array;
> +       int ret;
> +
> +       sra = xcalloc(1, sizeof(*sra));
> +       ret = sysfs_init(sra, fd, NULL);
> +       free(sra);
> +
> +       if (ret)
> +               ret = ioctl(fd, GET_ARRAY_INFO, &array);
> +
> +       return !ret;
> +}
> +
>  /*
>   * Get array info from the kernel. Longer term we want to deprecate the
>   * ioctl and get it from sysfs.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
