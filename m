From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Subject:[PATCH 001:013]: md: Raid0 reshape
Date: Tue, 16 Jun 2009 19:24:03 -0400
Message-ID: <4A382993.1070702@tmr.com>
References: <1245189112.3478.94.camel@raz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1245189112.3478.94.camel@raz>
Sender: linux-raid-owner@vger.kernel.org
To: raz ben yehuda <raziebe@gmail.com>
Cc: linux raid <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

raz ben yehuda wrote:
> md assumes that personality has all its membes of the same
> size,A fact that is incorrect for raid0.
>
>  md.c |   11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
> Signed-off-by: razb <raziebe@gmail.com>
> ---
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 0f11fd1..e14fb90 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5683,7 +5683,8 @@ static void status_resync(struct seq_file *seq, mddev_t * mddev)
>  		max_sectors = mddev->resync_max_sectors;
>  	else
>  		max_sectors = mddev->dev_sectors;
> -
> +	if (mddev->level == 0)
> +		max_sectors = mddev->resync_max_sectors;
>  	/*
>  	 * Should not happen.
>  	 */
> @@ -6280,7 +6281,13 @@ void md_do_sync(mddev_t *mddev)
>  			    rdev->recovery_offset < j)
>  				j = rdev->recovery_offset;
>  	}
> -
> +	/*
> +	* raid0 members may not be of the same size,use array_size.
> +	*/
> +	if (mddev->level == 0) {
> +		max_sectors = mddev->array_sectors;
> +		j = mddev->recovery_cp;
> +	}
>  	printk(KERN_INFO "md: %s of RAID array %s\n", desc, mdname(mddev));
>  	printk(KERN_INFO "md: minimum _guaranteed_  speed:"
>  		" %d KB/sec/disk.\n", speed_min(mddev));
>   

If I admit I only spent about 20 minutes looking at this code will you 
explain why you use different fields of the struct to set max_sectors? I 
guess my real confusion is why resync_max_sectors would be valid, given 
that raid0 has no redundancy. Or are you using it in some obscure way 
for reshape values?  The values stored in the field don't really to be 
what you want... Yes, the reshape is new to me.

-- 
Bill Davidsen <davidsen@tmr.com>
  Obscure bug of 2004: BASH BUFFER OVERFLOW - if bash is being run by a
normal user and is setuid root, with the "vi" line edit mode selected,
and the character set is "big5," an off-by-one error occurs during
wildcard (glob) expansion.

