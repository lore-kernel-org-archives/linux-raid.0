From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] raid5: use kmalloc_array() for GFP_NOIO flag
Date: Tue, 31 Mar 2020 19:05:14 +0800
Message-ID: <191a9178-cd26-9de5-f0d3-64db9436d533@suse.de>
References: <20200330154010.113469-1-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200330154010.113469-1-colyli@suse.de>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: songliubraving@fb.com
Cc: linux-raid@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>, Michal Hocko <mhocko@suse.com>
List-Id: linux-raid.ids

On 2020/3/30 11:40 下午, Coly Li wrote:
> Commit b330e6a49dc3 ("md: convert to kvmalloc") uses kvmalloc_array()
> to allocate memory with GFP_NOIO flag in resize_chunks() via function
> scribble_alloc(),
> 2269	err = scribble_alloc(percpu, new_disks,
> 2270			     new_sectors / STRIPE_SECTORS,
> 2271			     GFP_NOIO);
> 
> Indeed kvmalloc() inside kvmalloc_array() does not accept non GFP_KERNEL
> compatible flags, it means GFP_NOIO will make kvmalloc_node() call
> kmalloc_node() instead, which is not the above listed code wants.
> 
> For md raid1 and raid10 code, such allocation just simply calls
> kmalloc_array(), which is enough and works fine. This patch removes
> the misleading kvmalloc_array() and simply uses kmalloc_array() as
> md raid1 and raid10 code do.
> 
> Fixes: b330e6a49dc3 ("md: convert to kvmalloc")
> Signed-off-by: Coly Li <colyli@suse.de>
> Cc: Kent Overstreet <kent.overstreet@gmail.com>
> Cc: Michal Hocko <mhocko@suse.com>
> ---
>  drivers/md/raid5.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index ba00e9877f02..dda2701290bf 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -2235,7 +2235,7 @@ static int scribble_alloc(struct raid5_percpu *percpu,
>  		sizeof(addr_conv_t) * (num+2);
>  	void *scribble;
>  
> -	scribble = kvmalloc_array(cnt, obj_size, flags);
> +	scribble = kmalloc_array(cnt, obj_size, flags);
>  	if (!scribble)
>  		return -ENOMEM;
>  
> 

I will post another version to use memalloc_noio_save()/restore() scope
APIs. Please ignore this patch.

Thanks.
-- 

Coly Li
