From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: Re: [PATCH] Detail: show correct bitmap info for cluster raid device
Date: Fri, 13 Mar 2020 16:07:28 +0100
Message-ID: <80a59a8e-c23e-4343-d930-4ac71399a50c@cloud.ionos.com>
References: <20200313090504.13058-1-lidong.zhong@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200313090504.13058-1-lidong.zhong@suse.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Lidong Zhong <lidong.zhong@suse.com>, jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Lidong,

On 3/13/20 10:05 AM, Lidong Zhong wrote:
> Signed-off-by: Lidong Zhong <lidong.zhong@suse.com>
> ---
>   Detail.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/Detail.c b/Detail.c
> index 832485f..39fce29 100644
> --- a/Detail.c
> +++ b/Detail.c
> @@ -468,7 +468,9 @@ int Detail(char *dev, struct context *c)
>   		if (ioctl(fd, GET_BITMAP_FILE, &bmf) == 0 && bmf.pathname[0]) {
>   			printf("     Intent Bitmap : %s\n", bmf.pathname);
>   			printf("\n");
> -		} else if (array.state & (1<<MD_SB_BITMAP_PRESENT))
> +		} else if (array.state & (1<<MD_SB_CLUSTERED))
> +			printf("     Intent Bitmap : Clustered\n\n");

Better to use "Internal (Clustered)" since it is a special internal bitmap.
Anyway, Acked-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>

Cheers,
Guoqing
