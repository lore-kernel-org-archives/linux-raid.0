From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v2 1/2] EXPORT_SYMBOL radix_tree_lookup_slot
Date: Wed, 11 Jan 2017 09:54:05 -0800
Message-ID: <20170111175405.ixtmcs4runoo7dv2@kernel.org>
References: <20170111014251.3236610-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170111014251.3236610-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuan@kylinos.cn, liuyun01@kylinos.cn, Jes.Sorensen@redhat.com
List-Id: linux-raid.ids

On Tue, Jan 10, 2017 at 05:42:50PM -0800, Song Liu wrote:
> It will be used in drivers/md/raid5-cache.c

title and patch don't match
 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  lib/radix-tree.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/lib/radix-tree.c b/lib/radix-tree.c
> index 6f382e0..1ee7449 100644
> --- a/lib/radix-tree.c
> +++ b/lib/radix-tree.c
> @@ -1099,6 +1099,7 @@ void radix_tree_replace_slot(struct radix_tree_root *root,
>  {
>  	replace_slot(root, NULL, slot, item, true);
>  }
> +EXPORT_SYMBOL(radix_tree_replace_slot);
>  
>  /**
>   * radix_tree_iter_replace - replace item in a slot
> -- 
> 2.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
