From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md: notify about new spare disk in the container
Date: Fri, 21 Jul 2017 13:24:46 -0700
Message-ID: <20170721202446.lpy7noq6bbn7g7qt@kernel.org>
References: <1500632344-22339-1-git-send-email-aleksey.obitotskiy@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1500632344-22339-1-git-send-email-aleksey.obitotskiy@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexey Obitotskiy <aleksey.obitotskiy@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jul 21, 2017 at 12:19:04PM +0200, Alexey Obitotskiy wrote:
> In case of external metadata arrays spare disks are added to containers
> first. mdadm keeps monitoring /proc/mdstat output and when spare disk is
> available, it moves it from the container to the array. The problem is
> there is no notification of new spare disk in the container and mdadm
> waits a long time (until timeout) before it takes the action.

Hopefully we don't need this in the future after mdadm uses sysfs.

> Signed-off-by: Alexey Obitotskiy <aleksey.obitotskiy@intel.com>
> ---
>  drivers/md/md.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 66f6b92..02f4c6f 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -4283,6 +4283,7 @@ new_dev_store(struct mddev *mddev, const char *buf, size_t len)
>  	if (err)
>  		export_rdev(rdev);
>  	mddev_unlock(mddev);
> +	md_new_event(mddev);

Probably only do this in success?

>  	return err ? err : len;
>  }
>  
> -- 
> 2.7.4
> 
