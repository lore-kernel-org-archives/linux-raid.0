From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] mdadm: add checking the clustered bitmap in assemble mode
Date: Wed, 1 Mar 2017 20:03:28 +0800
Message-ID: <66e3dbf7-5851-0895-7de8-baf48375fead@suse.de>
References: <1488354469-19137-1-git-send-email-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1488354469-19137-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>, Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2017/3/1 下午3:47, Zhilong Liu wrote:
> 1. both clustered and internal array don't need to specify
> --bitmap when assembling array.
> 2. clustered array doesn't support external bitmap mode.
> 
> Signed-off-by: Zhilong Liu <zlliu@suse.com>
> 
> diff --git a/mdadm.c b/mdadm.c
> index b5d89e4..b08cace 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -1095,8 +1095,14 @@ int main(int argc, char *argv[])
>  				pr_err("bitmap file needed with -b in --assemble mode\n");
>  				exit(2);
>  			}
> -			if (strcmp(optarg, "internal") == 0) {
> -				pr_err("there is no need to specify --bitmap when assembling arrays with internal bitmaps\n");
> +			if (strcmp(optarg, "internal") == 0 ||
> +			    strcmp(optarg, "clustered") == 0) {
> +				pr_err("no need to specify --bitmap when assembling arrays with internal or clustered bitmaps\n");

Is it important for 80 characters width limitation ?

> +				continue;

Here if optarg is "clustered", it will continue and won't check the
following strcmp.

> +			}
> +			if (strcmp(optarg, "clustered") == 0 &&
> +			    strchr(optarg, '/') != NULL) {

I guess this check won't happen at all. Correct me if I am wrong.

> +				pr_err("clustered array doesn't support external bitmap\n");
>  				continue;
>  			}
>  			bitmap_fd = open(optarg, O_RDWR);
> 

Thanks.

Coly
