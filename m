From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 3/3] Skip cluster setup for dm-raid
Date: Thu, 23 Jul 2015 09:21:40 +1000
Message-ID: <20150723092140.15d88f70@noble>
References: <1437584957-23879-1-git-send-email-rgoldwyn@suse.com>
	<1437584957-23879-3-git-send-email-rgoldwyn@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1437584957-23879-3-git-send-email-rgoldwyn@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 22 Jul 2015 12:09:17 -0500 Goldwyn Rodrigues
<rgoldwyn@suse.com> wrote:

> There is a bug that the bitmap superblock isn't initialised properly for
> dm-raid, so a new field can have garbage in new fields.
> (dm-raid does initialisation in the kernel - md initialised the
>  superblock in mdadm).
> 
> This means that for dm-raid we cannot currently trust the new ->nodes
> field. So:
>  - use __GFP_ZERO to initialise the superblock properly for all new
>     arrays
>  - initialise all field in bitmap_info in bitmap_new_disk_sb
>  - ignore ->nodes for dm arrays (yes, this is a hack)
> 
> References: https://bugzilla.kernel.org/show_bug.cgi?id=100491
> 
> Signed-off-By: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  drivers/md/bitmap.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index f23b8e4..7ff37e0 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -494,7 +494,7 @@ static int bitmap_new_disk_sb(struct bitmap *bitmap)
>  	bitmap_super_t *sb;
>  	unsigned long chunksize, daemon_sleep, write_behind;
>  
> -	bitmap->storage.sb_page = alloc_page(GFP_KERNEL);
> +	bitmap->storage.sb_page = alloc_page(GFP_KERNEL | __GFP_ZERO);
>  	if (bitmap->storage.sb_page == NULL)
>  		return -ENOMEM;
>  	bitmap->storage.sb_page->index = 0;
> @@ -541,6 +541,7 @@ static int bitmap_new_disk_sb(struct bitmap *bitmap)
>  	sb->state = cpu_to_le32(bitmap->flags);
>  	bitmap->events_cleared = bitmap->mddev->events;
>  	sb->events_cleared = cpu_to_le64(bitmap->mddev->events);
> +	bitmap->mddev->bitmap_info.nodes = 0;
>  
>  	kunmap_atomic(sb);
>  
> @@ -611,8 +612,16 @@ re_read:
>  	daemon_sleep = le32_to_cpu(sb->daemon_sleep) * HZ;
>  	write_behind = le32_to_cpu(sb->write_behind);
>  	sectors_reserved = le32_to_cpu(sb->sectors_reserved);
> -	nodes = le32_to_cpu(sb->nodes);
> -	strlcpy(bitmap->mddev->bitmap_info.cluster_name, sb->cluster_name, 64);
> +	/* XXX: This is a hack to ensure that we don't use clustering
> +	 *  in case:
> +	 *	- dm-raid is in use and
> +	 *	- the nodes written in bitmap_sb is erroneous.
> +	 */
> +	if (!bitmap->mddev->sync_super) {
> +		nodes = le32_to_cpu(sb->nodes);
> +		strlcpy(bitmap->mddev->bitmap_info.cluster_name,
> +				sb->cluster_name, 64);
> +	}
>  
>  	/* verify that the bitmap-specific fields are valid */
>  	if (sb->magic != cpu_to_le32(BITMAP_MAGIC))


Thanks for these.
I've applied them all and marked this one for -stable ... it should stop
the cluster code from being touched by mistake.

NeilBrown
