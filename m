From: Bob Liu <bob.liu@oracle.com>
Subject: Re: [PATCH] block: keep bdi->io_pages in sync with max_sectors_kb for
 stacked devices
Date: Mon, 2 Mar 2020 20:16:53 +0800
Message-ID: <7133c4fb-38d5-cf1f-e259-e12b50efcb32@oracle.com>
References: <158290150891.4423.13566449569964563258.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <158290150891.4423.13566449569964563258.stgit@buzz>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, Song Liu <song@kernel.org>, Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
List-Id: linux-raid.ids

On 2/28/20 10:51 PM, Konstantin Khlebnikov wrote:
> Field bdi->io_pages added in commit 9491ae4aade6 ("mm: don't cap request
> size based on read-ahead setting") removes unneeded split of read requests.
> 
> Stacked drivers do not call blk_queue_max_hw_sectors(). Instead they setup
> limits of their devices by blk_set_stacking_limits() + disk_stack_limits().
> Field bio->io_pages stays zero until user set max_sectors_kb via sysfs.
> 
> This patch updates io_pages after merging limits in disk_stack_limits().
> 
> Commit c6d6e9b0f6b4 ("dm: do not allow readahead to limit IO size") fixed
> the same problem for device-mapper devices, this one fixes MD RAIDs.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> ---
>  block/blk-settings.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index c8eda2e7b91e..66c45fd79545 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -664,6 +664,8 @@ void disk_stack_limits(struct gendisk *disk, struct block_device *bdev,
>  		printk(KERN_NOTICE "%s: Warning: Device %s is misaligned\n",
>  		       top, bottom);
>  	}
> +
> +	t->backing_dev_info->io_pages = t->limits.max_sectors >> (PAGE_SHIFT-9);
>  }
>  EXPORT_SYMBOL(disk_stack_limits);
>  
> 

Nitpick.. (PAGE_SHIFT - 9)
Reviewed-by: Bob Liu <bob.liu@oracle.com>
