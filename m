From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 2/3] md: ping userspace on 'stop' events
Date: Thu, 1 May 2008 14:50:16 +1000
Message-ID: <18457.19464.642878.564130@notabene.brown>
References: <20080430011826.20468.93265.stgit@dwillia2-linux.ch.intel.com>
	<20080430011938.20468.26068.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Tuesday April 29
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday April 29, dan.j.williams@intel.com wrote:
> This additional notification to 'array_state' is needed to allow the monitor
> application to learn about stop events via sysfs.  The
> sysfs_notify("sync_action") call that comes at the end of do_md_stop() (via
> md_new_event) is insufficient since the 'sync_action' attribute has been
> removed by this point.
> 
> (Seems like a sysfs-notify-on-removal patch is a better fix.  Currently removal
>  updates the event count but does not wake up waiters)
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

Thanks.

Again, drop the "if (mddev->external)".  It isn't needed (I have made
this change).

NeilBrown

> 
>  drivers/md/md.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index ad53035..606c8ee 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -3693,6 +3693,9 @@ static int do_md_stop(mddev_t * mddev, int mode)
>  
>  			module_put(mddev->pers->owner);
>  			mddev->pers = NULL;
> +			/* tell userspace to handle 'inactive' */
> +			if (mddev->external)
> +				sysfs_notify(&mddev->kobj, NULL, "array_state");
>  
>  			set_capacity(disk, 0);
>  			mddev->changed = 1;
