From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 008 of 29] md: Close race in md_probe
Date: Sat, 28 Jun 2008 09:38:06 +1000
Message-ID: <18533.31198.932488.652568@notabene.brown>
References: <20080627164503.9671.patches@notabene>
	<1080627065010.10418@suse.de>
	<20080627122153.GE4981@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andre Noll on Friday June 27
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Friday June 27, maan@systemlinux.org wrote:
> On 16:50, NeilBrown wrote:
> > 
> > There is a possible race in md_probe.  If two threads call md_probe
> > for the same device, then one could exit (having checked that
> > ->gendisk exists) before the other has called kobject_init_and_add,
> > thus returning an incomplete kobj which will cause problems when
> > we try to add children to it.
...
> 
> Even with this patch, md_probe() calls mddev_find() without holding
> the disks_mutex. Is this OK? If it isn't, something like the patch
> below might be necessary.

Thanks for looking at this and asking.

No, the below patch is not necessary.

mddev_find gets a reference on the mddev, so it cannot become stale.
md_probe does not return what it gets from mddev_find until getting
the disks_mutex lock and checking the contents, so it is sure to
return a good mddev.

Thanks,
NeilBrown



> 
> Andre
> ---
> 
> From: Andre Noll <maan@systemlinux.org>
> 
> Fix possible race in md_probe().
> 
> The current code calls mddev_find() without any locks held.  It might
> happen that mddev_find() succeeds but the returned mddev pointer
> becomes stale just before the disks_mutex is aquired.
> 
> So close the race by calling mddev_find() with the disks mutex held.
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 647395b..6cb8773 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -3184,17 +3184,20 @@ static int mdp_major;
>  static struct kobject *md_probe(dev_t dev, int *part, void *data)
>  {
>  	static DEFINE_MUTEX(disks_mutex);
> -	mddev_t *mddev = mddev_find(dev);
> +	mddev_t *mddev;
>  	struct gendisk *disk;
>  	int partitioned = (MAJOR(dev) != MD_MAJOR);
>  	int shift = partitioned ? MdpMinorShift : 0;
>  	int unit = MINOR(dev) >> shift;
>  	int error;
>  
> -	if (!mddev)
> -		return NULL;
>  
>  	mutex_lock(&disks_mutex);
> +	mddev = mddev_find(dev);
> +	if (!mddev) {
> +		mutex_unlock(&disks_mutex);
> +		return NULL;
> +	}
>  	if (mddev->gendisk) {
>  		mutex_unlock(&disks_mutex);
>  		mddev_put(mddev);
> 
> -- 
> The only person who always got his work done by Friday was Robinson Crusoe
