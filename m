From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: Re: Reason for md raid1 max_sectors_kb limited to 127?
Date: Mon, 07 May 2012 16:14:42 +0200
Message-ID: <4FA7D8D2.8030906@profitbricks.com>
References: <4FA798D7.4070506@profitbricks.com> <20120507211846.789d5808@notabene.brown> <4FA7B337.7040408@profitbricks.com> <4FA7D678.4080106@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FA7D678.4080106@itwm.fraunhofer.de>
Sender: linux-raid-owner@vger.kernel.org
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/05/12 16:04, Bernd Schubert wrote:
> I think you need something like this. I thought there already went 
> something in in recent kernel, will check it later on today.
>
>
>
> Index: 2.6.32.13/drivers/md/raid0.c
> ===================================================================
> --- 2.6.32.13.orig/drivers/md/raid0.c
> +++ 2.6.32.13/drivers/md/raid0.c
> @@ -96,6 +96,7 @@ static int create_strip_zones(mddev_t *m
>  	int cnt;
>  	char b[BDEVNAME_SIZE];
>  	raid0_conf_t *conf = kzalloc(sizeof(*conf), GFP_KERNEL);
> +	unsigned int opt_io_size;
>  
>  	if (!conf)
>  		return -ENOMEM;
> @@ -256,9 +257,16 @@ static int create_strip_zones(mddev_t *m
>  		goto abort;
>  	}
>  
> +	/*
> +	 * To send large IOs to the drives we need sufficient segments
> +	 * for our own queue first.
> +	 */
> +	opt_io_size = (mddev->chunk_sectors << 9) * mddev->raid_disks;
> +	blk_queue_max_phys_segments(mddev->queue, opt_io_size >> PAGE_SHIFT);
> +	blk_queue_max_hw_segments(mddev->queue, opt_io_size >> PAGE_SHIFT);
> +
>  	blk_queue_io_min(mddev->queue, mddev->chunk_sectors << 9);
> -	blk_queue_io_opt(mddev->queue,
> -			 (mddev->chunk_sectors << 9) * mddev->raid_disks);
> +	blk_queue_io_opt(mddev->queue, opt_io_size);
>  
>  	printk(KERN_INFO "raid0: done.\n");
>  	mddev->private = conf;
>
>
> Cheers,
> Bernd
>   
Thanks for your answer, Bernd!

I've tested 3.3 and 3.4-rc1 and there it works. Now, I'll test latest
linux-3.2.y from linux-stable. Perhaps I'll start a "git bisect" later
on if the fix commit isn't that obvious.

Cheers,

Sebastian
