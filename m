From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] MD: generate an event when array sync is complete
Date: Wed, 20 Jul 2011 11:50:19 +1000
Message-ID: <20110720115019.4aa9a013@notabene.brown>
References: <1310677165.2246.12.camel@f14.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1310677165.2246.12.camel@f14.redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 14 Jul 2011 15:59:25 -0500 Jonathan Brassow <jbrassow@redhat.com>
wrote:

> Neil,
> 
> I'm not sure this is the best place in the code to put this (even though
> I've tested that it works well).  I welcome your corrections.
> 
>  brassow
> 
> This patch causes MD to generate an event (for device-mapper) once array
> synchronization is complete.  This is expected behavior for device-mapper.
> 
> RFC-by: Jonathan Brassow <jbrassow@redhat.com>
> 
> Index: linux-2.6/drivers/md/md.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/md.c
> +++ linux-2.6/drivers/md/md.c
> @@ -7328,6 +7328,9 @@ void md_check_recovery(mddev_t *mddev)
>  	unlock:
>  		if (!mddev->sync_thread) {
>  			clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
> +			if (mddev->event_work.func && !mddev->recovery &&
> +			    (mddev->recovery_cp == MaxSector))
> +				queue_work(md_misc_wq, &mddev->event_work);
>  			if (test_and_clear_bit(MD_RECOVERY_RECOVER,
>  					       &mddev->recovery))
>  				if (mddev->sysfs_action)
> 
> 

Hi Jon,
 I think reap_sync_thread would be a better place to put this.
Do you really need all the extra tests though?  Would it not be OK to just
notify dmeventd if the resync has stopped, and it can figure out what
actually happened and whether anything needs to be done about it?

I'm happy either way - just thought I would mention it.
So resend with the code in reap_sync_thread and I'll apply.

Thanks,
NeilBrown

