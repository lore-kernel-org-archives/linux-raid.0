From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1 of 9] MD:  possible typo
Date: Wed, 25 May 2011 08:18:08 +1000
Message-ID: <20110525081808.32264b34@notabene.brown>
References: <201105240305.p4O35wmb029220@f14.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201105240305.p4O35wmb029220@f14.redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@f14.redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 23 May 2011 22:05:58 -0500 Jonathan Brassow <jbrassow@f14.redhat.com>
wrote:

> Patch name: md-possible-typo.patch
> 
> Fix a value printed in kiB but labeled as 'blocks'.
> 
> Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
> 
> Index: linux-2.6/drivers/md/md.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/md.c
> +++ linux-2.6/drivers/md/md.c
> @@ -6867,7 +6867,7 @@ void md_do_sync(mddev_t *mddev)
>  	 */
>  	window = 32*(PAGE_SIZE/512);
>  	printk(KERN_INFO "md: using %dk window, over a total of %llu blocks.\n",
> -		window/2,(unsigned long long) max_sectors/2);
> +		window/2, (unsigned long long) max_sectors);
>  
>  	atomic_set(&mddev->recovery_active, 0);
>  	last_check = 0;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


"blocks" has traditionally meant "kibibytes" in md nomenclature, so this was
"correct".

I'd be quite happy to change the word "blocks" to "KB" (or even "KiB") though.

NeilBrown
