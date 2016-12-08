From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 1/3] md/raid5-cache: fix crc in
 rewrite_data_only_stripes()
Date: Thu, 8 Dec 2016 10:28:34 -0800
Message-ID: <20161208182834.xvk5gsdet4x72xbv@kernel.org>
References: <20161207174207.3685260-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161207174207.3685260-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuan@kylinos.cn, liuyun01@kylinos.cn
List-Id: linux-raid.ids

On Wed, Dec 07, 2016 at 09:42:05AM -0800, Song Liu wrote:
> r5l_recovery_create_empty_meta_block() creates crc for the empty
> metablock. After the metablock is updated, we need clear the
> checksum before recalculate it.

applied this one. However, I moved out checksum calculation from
r5l_recovery_create_empty_meta_block. We should calculate checksum after all
fields in meta block is updated.


Thanks,
Shaohua 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  drivers/md/raid5-cache.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index c3b3124..875f963 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -2117,7 +2117,9 @@ r5c_recovery_rewrite_data_only_stripes(struct r5l_log *log,
>  			}
>  		}
>  		mb->meta_size = cpu_to_le32(offset);
> -		mb->checksum = crc32c_le(log->uuid_checksum, mb, PAGE_SIZE);
> +		mb->checksum = 0;
> +		mb->checksum = cpu_to_le32(crc32c_le(log->uuid_checksum,
> +						     mb, PAGE_SIZE));
>  		sync_page_io(log->rdev, ctx->pos, PAGE_SIZE, page,
>  			     REQ_OP_WRITE, WRITE_FUA, false);
>  		sh->log_start = ctx->pos;
> -- 
> 2.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
