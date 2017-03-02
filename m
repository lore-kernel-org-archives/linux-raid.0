From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH v1] mdadm: add checking clustered bitmap in assemble mode
Date: Thu, 2 Mar 2017 12:25:45 +0800
Message-ID: <828bef44-dd75-9a65-3b58-9906b36bcab1@suse.de>
References: <1488425157-24582-1-git-send-email-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1488425157-24582-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>, Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2017/3/2 上午11:25, Zhilong Liu wrote:
> Both clustered and internal array don't need to specify
> --bitmap when assembling array.
> 
> Signed-off-by: Zhilong Liu <zlliu@suse.com>

Acked-by: Coly Li <colyli@suse.de>

> 
> diff --git a/mdadm.c b/mdadm.c
> index b5d89e4..4087f77 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -1095,8 +1095,10 @@ int main(int argc, char *argv[])
>  				pr_err("bitmap file needed with -b in --assemble mode\n");
>  				exit(2);
>  			}
> -			if (strcmp(optarg, "internal") == 0) {
> -				pr_err("there is no need to specify --bitmap when assembling arrays with internal bitmaps\n");
> +			if (strcmp(optarg, "internal") == 0 ||
> +			    strcmp(optarg, "clustered") == 0) {
> +				pr_err("no need to specify --bitmap when assembling
> +					arrays with internal or clustered bitmap\n");
>  				continue;
>  			}
>  			bitmap_fd = open(optarg, O_RDWR);
> 

