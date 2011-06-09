From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] MD:  use is_power_of_2 macro
Date: Thu, 9 Jun 2011 11:44:27 +1000
Message-ID: <20110609114427.625f0c1e@notabene.brown>
References: <1307556070.9555.11.camel@f14.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1307556070.9555.11.camel@f14.redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 08 Jun 2011 13:01:10 -0500 Jonathan Brassow <jbrassow@redhat.com>
wrote:

> Make use of is_power_of_2 macro.
> 
> Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
> 
> Index: linux-2.6/drivers/md/bitmap.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/bitmap.c
> +++ linux-2.6/drivers/md/bitmap.c
> @@ -651,7 +651,7 @@ static int bitmap_read_sb(struct bitmap 
>  		reason = "unrecognized superblock version";
>  	else if (chunksize < 512)
>  		reason = "bitmap chunksize too small";
> -	else if ((1 << ffz(~chunksize)) != chunksize)
> +	else if (!is_power_of_2(chunksize))
>  		reason = "bitmap chunksize not a power of 2";
>  	else if (daemon_sleep < 1 || daemon_sleep > MAX_SCHEDULE_TIMEOUT)
>  		reason = "daemon sleep period out of range";
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hi Jon,
 thanks for this and the others.
I'll push them into my 'for-next' branch today so they should appear in -next
soon.  I expect to send a pull request to Linus on Tuesday - after the long
weekend.

Thanks,
NeilBrown
