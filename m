From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: [RFC 1/5] add bio_split_mddev
Date: Tue, 31 May 2016 05:13:19 -0400
Message-ID: <574D55AF.1030005@suse.com>
References: <1464326983-3798454-1-git-send-email-songliubraving@fb.com>
 <1464326983-3798454-2-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1464326983-3798454-2-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>, linux-raid@vger.kernel.org
Cc: shli@fb.com, nfbrown@novell.com, dan.j.williams@intel.com, hch@infradead.org, kernel-team@fb.com
List-Id: linux-raid.ids



On 05/27/2016 01:29 AM, Song Liu wrote:
> similar to bio_clone_mddev, bio_alloc_mddev, this patch added
> bio_split_mddev, which uses a local bio set.
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>   drivers/md/md.c    | 14 +++++++++++---
>   drivers/md/md.h    |  2 ++
>   drivers/md/raid5.c |  2 +-
>   3 files changed, 14 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 866825f..f42f8d0 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -158,10 +158,9 @@ static const struct block_device_operations md_fops;
>   
>   static int start_readonly;
>   
> -/* bio_clone_mddev
> - * like bio_clone, but with a local bio set
> +/* bio_alloc_mddev, bio_clone_mddev, bio_split_mddev
> + * like bio_alloc, bio_clone, bio_split, but with a local bio set
>    */
> -
>   struct bio *bio_alloc_mddev(gfp_t gfp_mask, int nr_iovecs,
>   			    struct mddev *mddev)
>   {
> @@ -187,6 +186,15 @@ struct bio *bio_clone_mddev(struct bio *bio, gfp_t gfp_mask,
>   }
>   EXPORT_SYMBOL_GPL(bio_clone_mddev);
>   
> +struct bio *bio_split_mddev(struct bio *bio, int sectors,
> +			    gfp_t gfp, struct mddev *mddev)
> +{
> +	if (!mddev || !mddev->bio_set)
> +		return bio_split(bio, sectors, gfp, NULL);
> +	return bio_split(bio, sectors, gfp, mddev->bio_set);
> +}
> +EXPORT_SYMBOL_GPL(bio_split_mddev);
> +

Compared with bio_alloc_mddev and bio_clone_mddev, there is no 
bio_split_bioset
func, I think use bio_split directly is enough. Also why the last 
parameter of the
first bio_split is NULL instead of fs_bio_set?

>   /*
>    * We have a system wide 'event count' that is incremented
>    * on any 'interesting' event, and readers of /proc/mdstat
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index b5c4be7..9e1d4bf 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -642,6 +642,8 @@ extern struct bio *bio_clone_mddev(struct bio *bio, gfp_t gfp_mask,
>   				   struct mddev *mddev);
>   extern struct bio *bio_alloc_mddev(gfp_t gfp_mask, int nr_iovecs,
>   				   struct mddev *mddev);
> +extern struct bio *bio_split_mddev(struct bio *bio, int sectors,
> +				   gfp_t gfp, struct mddev *mddev);
>   
>   extern void md_unplug(struct blk_plug_cb *cb, bool from_schedule);
>   extern void md_reload_sb(struct mddev *mddev, int raid_disk);
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index ad9e15a..8e25e67 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -4871,7 +4871,7 @@ static struct bio *chunk_aligned_read(struct mddev *mddev, struct bio *raid_bio)
>   		unsigned sectors = chunk_sects - (sector & (chunk_sects-1));
>   
>   		if (sectors < bio_sectors(raid_bio)) {
> -			split = bio_split(raid_bio, sectors, GFP_NOIO, fs_bio_set);

The original place use fs_bio_set here.

> +			split = bio_split_mddev(raid_bio, sectors, GFP_NOIO, mddev);
>   			bio_chain(split, raid_bio);
>   		} else
>   			split = raid_bio;

Thanks,
Guoqing
