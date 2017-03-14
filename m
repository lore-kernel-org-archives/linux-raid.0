From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md/r5cache: fix set_syndrome_sources()
Date: Tue, 14 Mar 2017 09:52:33 -0700
Message-ID: <20170314165233.p7wef5qxyosxe5hm@kernel.org>
References: <20170313204435.1732089-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170313204435.1732089-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org
List-Id: linux-raid.ids

On Mon, Mar 13, 2017 at 01:44:35PM -0700, Song Liu wrote:
> With srctype == SYNDROME_SRC_WRITTEN, we need include both
> dev with non-null ->written and dev with R5_InJournal.

Thanks, applied. I'll add this to stable
 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  drivers/md/raid5.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 1c554a8..88cc898 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -1499,7 +1499,8 @@ static int set_syndrome_sources(struct page **srcs,
>  		     (test_bit(R5_Wantdrain, &dev->flags) ||
>  		      test_bit(R5_InJournal, &dev->flags))) ||
>  		    (srctype == SYNDROME_SRC_WRITTEN &&
> -		     dev->written)) {
> +		     (dev->written ||
> +		      test_bit(R5_InJournal, &dev->flags)))) {
>  			if (test_bit(R5_InJournal, &dev->flags))
>  				srcs[slot] = sh->dev[i].orig_page;
>  			else
> -- 
> 2.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
