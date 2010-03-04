From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [md PATCH 1/8] Enable OLCE for external IMSM metadata
Date: Thu, 4 Mar 2010 08:22:25 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D10180F536@irsmsx503.ger.corp.intel.com>
References: <905EDD02F158D948B186911EB64DB3D1016F65B8@irsmsx503.ger.corp.intel.com>
 <20100304165832.6f1c02fb@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100304165832.6f1c02fb@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

Hi,
I've made sync_completed sysfs entry writeable to let md know that configuration prepared by mdmon is ready.
Other thing that this is used for, is that after write by mdmon 0 to sync_completed, mdadm has to be able read this information to proceed with reshape limits.
To achieve this, flag MD_SYNC_COMPLETED_SHOW_0 is used, so after 0 is put to sysfs it is exposed to user space until it is read by mdadm.

Algorithm is as follow:
1. mdadm puts "reshape" to action => clear MD_SYNC_COMPLETED_SHOW_0 (0 is not exposed)
2. kernel starts reshape and waits in wait_reshape() for reconfiguration by mdmon
3. mdmon adds devices and "0" is put to sync_completed => MD_SYNC_COMPLETED_SHOW_0 is set
4. md goes with reshape (it probably stops due to max_sync is not set by mdadm yet)
5. mdadm read from sync completed gives "0"
6. mdadm stores sync_max (so md knows it can go forward) => MD_SYNC_COMPLETED_SHOW_0 is cleared during sync_max store

Considering above comment can be "add possibility to use "0" value in sync complete during reshape start handshake/synchronization"

If we decide to remove wait_reshape() this synchronization will be not necessary.

Adam

-----Original Message-----
From: Neil Brown [mailto:neilb@suse.de] 
Sent: Thursday, March 04, 2010 6:59 AM
To: Kwolek, Adam
Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed
Subject: Re: [md PATCH 1/8] Enable OLCE for external IMSM metadata

On Wed, 24 Feb 2010 07:42:48 +0000
"Kwolek, Adam" <adam.kwolek@intel.com> wrote:

> >From 464c542abb3f107771a4d97611ef5035e40755e9 Mon Sep 17 00:00:00 2001
> From: Adam Kwolek <adam.kwolek@intel.com>
> Date: Thu, 18 Feb 2010 11:24:19 +0100
> Subject: [PATCH] OLCE: add sync_completed handler
> 
> Changes to be committed:
> 	modified:   md.c
> 	modified:   md.h
> 
> Add possibility to send notification to md via sync_completed

I'm sorry, but this patch doesn't make much sense to me.
The comment above doesn't seem to match the code below.

Can I have a more complete explanation please.

NeilBrown

> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
>  drivers/md/md.c |   53 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  drivers/md/md.h |    2 ++
>  2 files changed, 54 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index f836926..d7e1053 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -3461,6 +3461,10 @@ action_store(mddev_t *mddev, const char *page, size_t len)
>  		int err;
>  		if (mddev->pers->start_reshape == NULL)
>  			return -EINVAL;
> +
> +		/* OLCE: correct value saved, cannot show zero */
> +		clear_bit(MD_SYNC_COMPLETED_SHOW_0, &mddev->flags);
> +
>  		err = mddev->pers->start_reshape(mddev);
>  		if (err)
>  			return err;
> @@ -3601,6 +3605,14 @@ sync_completed_show(mddev_t *mddev, char *page)
>  {
>  	unsigned long max_sectors, resync;
>  
> +	/* bit is cleared by saving to sysfs:
> +	 * action: reshape
> +	 * setting valid sync_max
> +	 * seting other value than 0 to sync_compl
> +	 */
> +	if (test_bit(MD_SYNC_COMPLETED_SHOW_0, &mddev->flags))
> +		return sprintf(page, "0\n");
> +
>  	if (!test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
>  		return sprintf(page, "none\n");
>  
> @@ -3613,7 +3625,40 @@ sync_completed_show(mddev_t *mddev, char *page)
>  	return sprintf(page, "%lu / %lu\n", resync, max_sectors);
>  }
>  
> -static struct md_sysfs_entry md_sync_completed = __ATTR_RO(sync_completed);
> +static ssize_t
> +sync_completed_store(mddev_t *mddev, const char *buf, size_t len)
> +{
> +	/* accept set to 0 only as signal */
> +	unsigned long long passedValue;
> +
> +	/*  store for external meta only */
> +	if (!mddev->external)
> +		return -EINVAL;
> +
> +	/* check if numeric */
> +	if (strict_strtoull(buf, 10, &passedValue))
> +		return -EINVAL;
> +
> +	/* use 0 only */
> +	if (passedValue)
> +		return -EINVAL;
> +
> +	if ((mddev->reshape_position == 0) && (*buf == '0') && (len == 1)) {
> +		/* not started yet - display passed '0' to signal user space*/
> +		set_bit(MD_SYNC_COMPLETED_SHOW_0, &mddev->flags);
> +	} else {
> +		if ((*buf != '0') || (len != 1))
> +			clear_bit(MD_SYNC_COMPLETED_SHOW_0, &mddev->flags);
> +	}
> +
> +	return len;
> +}
> +
> +static struct md_sysfs_entry md_sync_completed =
> +__ATTR(sync_completed, S_IRUGO|S_IWUSR,
> +	sync_completed_show,
> +	sync_completed_store);
> +
>  
>  static ssize_t
>  min_sync_show(mddev_t *mddev, char *page)
> @@ -3679,6 +3724,12 @@ max_sync_store(mddev_t *mddev, const char *buf, size_t len)
>  		}
>  		mddev->resync_max = max;
>  	}
> +	/* OLCE: correct value saved, cannot show zero */
> +	if (test_bit(MD_SYNC_COMPLETED_SHOW_0, &mddev->flags)) {
> +		/* on begin some check points can be skipped */
> +		clear_bit(MD_SYNC_COMPLETED_SHOW_0, &mddev->flags);
> +	}
> +
>  	wake_up(&mddev->recovery_wait);
>  	return len;
>  }
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index f184b69..070e7c6 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -119,6 +119,8 @@ struct mddev_s
>  #define MD_CHANGE_CLEAN 1	/* transition to or from 'clean' */
>  #define MD_CHANGE_PENDING 2	/* superblock update in progress */
>  
> +#define MD_SYNC_COMPLETED_SHOW_0 3  /* force to show in sync complete 0 */
> +				    /*  when it is set from user space  */
>  	int				suspended;
>  	atomic_t			active_io;
>  	int				ro;

