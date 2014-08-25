From: Xiao Ni <xni@redhat.com>
Subject: Re: [PATCH] Memory leak once alloc superblock page failed
Date: Mon, 25 Aug 2014 03:45:57 -0400 (EDT)
Message-ID: <905376206.27916256.1408952757621.JavaMail.zimbra@redhat.com>
References: <1408500480-15200-1-git-send-email-xni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1408500480-15200-1-git-send-email-xni@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jes sorensen <jes.sorensen@redhat.com>
List-Id: linux-raid.ids


Sorry for this patch. I find the memory will be released in the function bitmap_free
which is called in error path of bitmap_create.

The patch is wrong.

Best Regards
Xiao

----- Original Message -----
> From: "Xiao Ni" <xni@redhat.com>
> To: linux-raid@vger.kernel.org
> Cc: "jes sorensen" <jes.sorensen@redhat.com>, "Xiao Ni" <xni@redhat.com>
> Sent: Wednesday, August 20, 2014 10:08:00 AM
> Subject: [PATCH] Memory leak once alloc superblock page failed
> 
> [PATCH] Fix memory leak if alloc superblock page fails
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  drivers/md/bitmap.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index 67f8b31..5997c34 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -698,8 +698,11 @@ static int bitmap_storage_alloc(struct bitmap_storage
> *store,
>  
>  	if (with_super && !store->sb_page) {
>  		store->sb_page = alloc_page(GFP_KERNEL|__GFP_ZERO);
> -		if (store->sb_page == NULL)
> +		if (store->sb_page == NULL) {
> +			kfree(store->filemap);
> +			store->filemap = NULL;
>  			return -ENOMEM;
> +		}
>  		store->sb_page->index = 0;
>  	}
>  	pnum = 0;
> --
> 1.7.1
> 
> 
