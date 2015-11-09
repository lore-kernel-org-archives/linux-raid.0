From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [PATCH 5/8] zram: handle add_disk() & blk_register_region()
 return value
Date: Mon, 9 Nov 2015 10:07:05 +0900
Message-ID: <20151109010705.GC471@swordfish>
References: <437969438-9181-1-git-send-email-vishnu.ps@samsung.com>
 <1446812535-10567-1-git-send-email-vishnu.ps@samsung.com>
 <1446812535-10567-5-git-send-email-vishnu.ps@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1446812535-10567-5-git-send-email-vishnu.ps@samsung.com>
Sender: linux-ide-owner@vger.kernel.org
To: Vishnu Pratap Singh <vishnu.ps@samsung.com>
Cc: axboe@kernel.dk, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, jmoyer@redhat.com, minchan@kernel.org, ngupta@vflare.org, sergey.senozhatsky.work@gmail.com, davem@davemloft.net, neilb@suse.com, ulf.hansson@linaro.org, tiwai@suse.de, hare@suse.de, ming.lei@canonical.com, jarod@redhat.com, viro@zeniv.linux.org.uk, tj@kernel.org, adrian.hunter@intel.com, jonathanh@nvidia.com, grundler@chromium.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, cpgs@samsung.com, vishu13285@gmail.com, pintu.k@samsung.com, rohit.kr@samsung.com
List-Id: linux-raid.ids

On (11/06/15 17:52), Vishnu Pratap Singh wrote:
> This patch adds error handling for blk_register_region(),
> register_disk(), add_disk(), disk_alloc_events() & disk_add_events().
> add_disk() & register_disk() functions  error handling is very much
> needed as this is used mainly by many modules like mmc, zram, mtd, scsi etc.
> But there is no error handling and it may cause stability issues also.

hm... I came across "FIXME: error handling" comment in add_disk() some
time ago and after a quick google search I found this:
https://lkml.org/lkml/2007/7/24/207

>> The attached patch fixes the problem by changing the prototype of
>> add_disk() and register_disk() to return errors.

Al Viro wrote:

> This is bogus.  Just what would callers do with these error values?
> Ignore them silently?  Bail out?  Can't do - at that point disk just
> might have been opened already.  add_disk() is the point of no return;
> we are already past the last point where we could bail out.




>  drivers/block/z2ram.c         | 12 ++++++++++--
>  drivers/block/zram/zram_drv.c |  9 ++++++---

those are different drivers, split the patches (well, if add_disk()
change actually makes sense).


>  2 files changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/block/z2ram.c b/drivers/block/z2ram.c
> index 968f9e5..85e841f 100644
> --- a/drivers/block/z2ram.c
> +++ b/drivers/block/z2ram.c
> @@ -364,12 +364,20 @@ z2_init(void)
>      sprintf(z2ram_gendisk->disk_name, "z2ram");
>  
>      z2ram_gendisk->queue = z2_queue;
> -    add_disk(z2ram_gendisk);
> -    blk_register_region(MKDEV(Z2RAM_MAJOR, 0), Z2MINOR_COUNT, THIS_MODULE,
> +    ret = add_disk(z2ram_gendisk);
> +    if (ret)
> +	goto out_add_disk;
> +
> +    ret = blk_register_region(MKDEV(Z2RAM_MAJOR, 0), Z2MINOR_COUNT, THIS_MODULE,
>  				z2_find, NULL, NULL);
> +    if (ret)
> +	goto out_blk_reg;

A separate nitpick. z2_init() coding styles need to be 'fixed'. So the
patch will not violate the kernel coding styles.

 ./scripts/checkpatch.pl
 WARNING: please, no spaces at the start of a line
 #113: FILE: drivers/block/z2ram.c:367:
 +    ret = add_disk(z2ram_gendisk);$

 WARNING: please, no spaces at the start of a line
 #114: FILE: drivers/block/z2ram.c:368:
 +    if (ret)$

 WARNING: please, no spaces at the start of a line
 #117: FILE: drivers/block/z2ram.c:371:
 +    ret = blk_register_region(MKDEV(Z2RAM_MAJOR, 0), Z2MINOR_COUNT,
 THIS_MODULE,$

 WARNING: please, no spaces at the start of a line
 #119: FILE: drivers/block/z2ram.c:373:
 +    if (ret)$

 total: 0 errors, 4 warnings, 50 lines checked


>  
>      return 0;
>  
> +out_blk_reg:
> +	del_gendisk(z2ram_gendisk);
> +out_add_disk:
>  out_queue:

Hm... a fall-through empty `out_add_disk' label?


	-ss

>      put_disk(z2ram_gendisk);
>  out_disk:
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index 81a557c..f3d7a49 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -1261,14 +1261,16 @@ static int zram_add(void)
>  		zram->disk->queue->limits.discard_zeroes_data = 0;
>  	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, zram->disk->queue);
>  
> -	add_disk(zram->disk);
> +	ret = add_disk(zram->disk);
> +	if (ret)
> +		goto out_free_disk;
>  
>  	ret = sysfs_create_group(&disk_to_dev(zram->disk)->kobj,
>  				&zram_disk_attr_group);
>  	if (ret < 0) {
>  		pr_err("Error creating sysfs group for device %d\n",
>  				device_id);
> -		goto out_free_disk;
> +		goto out_del_disk;
>  	}
>  	strlcpy(zram->compressor, default_compressor, sizeof(zram->compressor));
>  	zram->meta = NULL;
> @@ -1277,8 +1279,9 @@ static int zram_add(void)
>  	pr_info("Added device: %s\n", zram->disk->disk_name);
>  	return device_id;
>  
> -out_free_disk:
> +out_del_disk:
>  	del_gendisk(zram->disk);
> +out_free_disk:
>  	put_disk(zram->disk);

>  out_free_queue:
>  	blk_cleanup_queue(queue);
> -- 
> 1.9.1
> 
