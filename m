From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH v2 4/4] md: remove redundant memalloc scope API usage
Date: Thu, 9 Apr 2020 19:55:31 +0800
Message-ID: <74a9c926-abe4-ff05-4deb-bce7b42f4861@suse.de>
References: <20200409115258.19330-1-colyli@suse.de>
 <20200409115258.19330-5-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200409115258.19330-5-colyli@suse.de>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: songliubraving@fb.com, linux-raid@vger.kernel.org
Cc: mhocko@suse.com, kent.overstreet@gmail.com, guoqing.jiang@cloud.ionos.com
List-Id: linux-raid.ids

On 2020/4/9 7:52 下午, colyli@suse.de wrote:
> From: Coly Li <colyli@suse.de>
> 
> In mddev_create_serial_pool(), memalloc scope APIs memalloc_noio_save()
> and memalloc_noio_restore() are used when allocating memory by calling
> mempool_create_kmalloc_pool(). After adding the memalloc scope APIs in
> raid array suspend context, it is unncessary to explicitly call them
> around mempool_create_kmalloc_pool() any longer.
> 
> This patch removes the redundant memalloc scope APIs in
> mddev_create_serial_pool().
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> Cc: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
> ---
>  drivers/md/md.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 1a8e1bb3a7f4..ef29f49a0f51 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -229,11 +229,9 @@ void mddev_create_serial_pool(struct mddev *mddev, struct md_rdev *rdev,
>  	if (mddev->serial_info_pool == NULL) {
>  		unsigned int noio_flag;
		^^^^^^^^^^^^^^^^^^^^^^^ I will remove this one in v3 series.


Coly Li


>  
> -		noio_flag = memalloc_noio_save();
>  		mddev->serial_info_pool =
>  			mempool_create_kmalloc_pool(NR_SERIAL_INFOS,
>  						sizeof(struct serial_info));
> -		memalloc_noio_restore(noio_flag);
>  		if (!mddev->serial_info_pool) {
>  			rdevs_uninit_serial(mddev);
>  			pr_err("can't alloc memory pool for serialization\n");
> 
