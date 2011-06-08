From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 8 of 8] MD:  raid5 do not set fullsync
Date: Wed, 8 Jun 2011 15:20:00 +1000
Message-ID: <20110608152000.564d2bcc@notabene.brown>
References: <1307487163.31279.18.camel@f14.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1307487163.31279.18.camel@f14.redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 07 Jun 2011 17:52:43 -0500 Jonathan Brassow <jbrassow@redhat.com>
wrote:

> Add new flag for struct mdk_rdev_s to indicate when recovery can use bitmap
> 
> Device-mapper can tell if a device is in-sync, in need of partial (bitmap aided)
> recovery, or in need of complete recovery.  The raid5 code assumes that if a
> device is not in-sync, then it must undergo complete recovery - it does not
> honor the bitmap.  The flag 'RecoverByBitmap' has been introduced to force raid5
> not to set 'conf->fullsync' if the superblock routines have already determined
> that only a partial recovery is necessary.
> 
> RFC-by: Jonathan Brassow <jbrassow@redhat.com>
> 
> Index: linux-2.6/drivers/md/raid5.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/raid5.c
> +++ linux-2.6/drivers/md/raid5.c
> @@ -4858,7 +4858,7 @@ static raid5_conf_t *setup_conf(mddev_t 
>  			printk(KERN_INFO "md/raid:%s: device %s operational as raid"
>  			       " disk %d\n",
>  			       mdname(mddev), bdevname(rdev->bdev, b), raid_disk);
> -		} else
> +		} else if (!test_bit(RecoverByBitmap, &rdev->flags))
>  			/* Cannot rely on bitmap to complete recovery */
>  			conf->fullsync = 1;

I think we can just do
                } else if (rdev->saved_raid_disk != raid_disk)

and not add an extra flag.
This is more in keeping with e.g. raid5_add_disk.

Thanks,

NeilBrown


>  	}
> Index: linux-2.6/drivers/md/md.h
> ===================================================================
> --- linux-2.6.orig/drivers/md/md.h
> +++ linux-2.6/drivers/md/md.h
> @@ -77,6 +77,8 @@ struct mdk_rdev_s
>  #define Blocked		8		/* An error occurred on an externally
>  					 * managed array, don't allow writes
>  					 * until it is cleared */
> +#define RecoverByBitmap 9               /* Used by device-mapper to ensure this
> +					 * device is recovered by the bitmap. */
>  	wait_queue_head_t blocked_wait;
>  
>  	int desc_nr;			/* descriptor index in the superblock */
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

