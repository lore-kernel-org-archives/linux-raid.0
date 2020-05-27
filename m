From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: Re: [PATCH v3 01/11] md/raid5: add CONFIG_MD_RAID456_STRIPE_SHIFT to
 set STRIPE_SIZE
Date: Wed, 27 May 2020 15:54:57 +0200
Message-ID: <5fe381f9-e3ce-c2f7-dfac-9f852316b38f@cloud.ionos.com>
References: <20200527131933.34400-1-yuyufen@huawei.com>
 <20200527131933.34400-2-yuyufen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200527131933.34400-2-yuyufen@huawei.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Yufen Yu <yuyufen@huawei.com>, song@kernel.org
Cc: linux-raid@vger.kernel.org, neilb@suse.com, colyli@suse.de, xni@redhat.com, houtao1@huawei.com
List-Id: linux-raid.ids

Hi,

On 5/27/20 3:19 PM, Yufen Yu wrote:
>   +config MD_RAID456_STRIPE_SHIFT
> +	int "RAID4/RAID5/RAID6 stripe size shift"
> +	default "1"
> +	depends on MD_RAID456
> +	help
> +	  When set the value as 'N', stripe size will be set as 'N << 9',
> +	  which is a multiple of 4KB.

If 'N  << 9', then seems you are convert it to sector, do you actually 
mean 'N << 12'?

> +
> +	  The default value is 1, that means the default stripe size is
> +	  4096(1 << 9). Just setting as a bigger value when PAGE_SIZE is
> +	  bigger than 4096. In that case, you can set it as 2(8KB),
> +	  4(16K), 16(64K).

So with the above description, the algorithm should be 2 << 12 = 8KB and 
so on.

> +
> +	  When you try to set a big value, likely 16 on arm64 with 64KB
> +	  PAGE_SIZE, that means, you know size of each io that issued to
> +	  raid device is more than 4096. Otherwise just use default value.
> +
> +	  Normally, using default value can get better performance.
> +	  Only change this value if you know what you are doing.
> +
> +
>   config MD_MULTIPATH
>   	tristate "Multipath I/O support"
>   	depends on BLK_DEV_MD
> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index f90e0704bed9..b25f107dafc7 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -472,7 +472,9 @@ struct disk_info {
>    */
>   
>   #define NR_STRIPES		256
> -#define STRIPE_SIZE		PAGE_SIZE
> +#define CONFIG_STRIPE_SIZE	(CONFIG_MD_RAID456_STRIPE_SHIFT << 9)
> +#define STRIPE_SIZE		\
> +	(CONFIG_STRIPE_SIZE > PAGE_SIZE ? PAGE_SIZE : CONFIG_STRIPE_SIZE)

If I am not misunderstand, you need to s/9/12/ above.

Thanks,
Guoqing
