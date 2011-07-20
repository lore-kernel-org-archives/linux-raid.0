From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] MD: raid1
 s/sysfs_notify_dirent/sysfs_notify_dirent_safe
Date: Wed, 20 Jul 2011 11:47:37 +1000
Message-ID: <20110720114737.7dbdf2c4@notabene.brown>
References: <1310676829.2246.7.camel@f14.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1310676829.2246.7.camel@f14.redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 14 Jul 2011 15:53:49 -0500 Jonathan Brassow <jbrassow@redhat.com>
wrote:

> If device-mapper creates a RAID1 array that includes devices to
> be rebuilt, it will deref a NULL pointer when finished because
> sysfs is not used by device-mapper instantiated RAID devices.
> 
> Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
> 
> Index: linux-2.6/drivers/md/raid1.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/raid1.c
> +++ linux-2.6/drivers/md/raid1.c
> @@ -1027,7 +1027,7 @@ static int raid1_spare_active(mddev_t *m
>  		    && !test_bit(Faulty, &rdev->flags)
>  		    && !test_and_set_bit(In_sync, &rdev->flags)) {
>  			count++;
> -			sysfs_notify_dirent(rdev->sysfs_state);
> +			sysfs_notify_dirent_safe(rdev->sysfs_state);
>  		}
>  	}
>  	spin_lock_irqsave(&conf->device_lock, flags);
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



Applied, thanks.

NeilBrown

