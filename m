From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 6 of 9] MD:  no sync IO while suspended
Date: Wed, 25 May 2011 14:10:23 +1000
Message-ID: <20110525141023.3b3c91bf@notabene.brown>
References: <201105240306.p4O36rFK029586@f14.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201105240306.p4O36rFK029586@f14.redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 23 May 2011 22:06:53 -0500 Jonathan Brassow <jbrassow@f14.redhat.com>
wrote:

> Patch name: md-no-sync-IO-while-suspended.patch
> 
> Disallow resync I/O while the RAID array is suspended.
> 
> Recovery, resync, and metadata I/O should not be allowed while a device is
> suspended.
> 
> Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
> 
> Index: linux-2.6/drivers/md/md.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/md.c
> +++ linux-2.6/drivers/md/md.c
> @@ -7064,7 +7064,6 @@ void md_do_sync(mddev_t *mddev)
>  }
>  EXPORT_SYMBOL_GPL(md_do_sync);
>  
> -
>  static int remove_and_add_spares(mddev_t *mddev)
>  {
>  	mdk_rdev_t *rdev;
> @@ -7176,6 +7175,9 @@ static void reap_sync_thread(mddev_t *md
>   */
>  void md_check_recovery(mddev_t *mddev)
>  {
> +	if (mddev->suspended)
> +		return;
> +
>  	if (mddev->bitmap)
>  		bitmap_daemon_work(mddev);
>  

Yep, applied.

Thanks,
NeilBrown
