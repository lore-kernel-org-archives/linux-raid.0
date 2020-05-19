From: Jes Sorensen <jes@trained-monkey.org>
Subject: =?UTF-8?Q?Re=3a_=5bPATCH_V3_2/2=5d_restripe=3a_fix_ignoring_return_?=
 =?UTF-8?B?dmFsdWUgb2Yg4oCYcmVhZOKAmSBhbmQgbHNlZWs=?=
Date: Mon, 18 May 2020 20:26:12 -0400
Message-ID: <7ba82317-5747-8297-bf8f-1883483adfea@trained-monkey.org>
References: <20200518215336.29000-1-guoqing.jiang@cloud.ionos.com>
 <20200518215336.29000-3-guoqing.jiang@cloud.ionos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200518215336.29000-3-guoqing.jiang@cloud.ionos.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/18/20 5:53 PM, Guoqing Jiang wrote:
> Got below error when run "make everything".
> 
> restripe.c: In function ‘test_stripes’:
> restripe.c:870:4: error: ignoring return value of ‘read’, declared with attribute warn_unused_result [-Werror=unused-result]
>     read(source[i], stripes[i], chunk_size);
>     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Fix it by check the return value of ‘read’, and free memory
> in the failure case.
> 
> And check the return value of lseek as well per Jes's comment.
> 
> Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
> ---
>  restripe.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/restripe.c b/restripe.c
> index 31b07e8..86e1d00 100644
> --- a/restripe.c
> +++ b/restripe.c
> @@ -866,8 +866,16 @@ int test_stripes(int *source, unsigned long long *offsets,
>  		int disk;
>  
>  		for (i = 0 ; i < raid_disks ; i++) {
> -			lseek64(source[i], offsets[i]+start, 0);
> -			read(source[i], stripes[i], chunk_size);
> +			if ((lseek64(source[i], offsets[i]+start, 0) < 0) ||
> +			    (read(source[i], stripes[i], chunk_size) !=
> +			     chunk_size)) {
> +				free(q);
> +				free(p);
> +				free(blocks);
> +				free(stripes);
> +				free(stripe_buf);
> +				return -1;
> +			}
>  		}
>  		for (i = 0 ; i < data_disks ; i++) {
>  			int disk = geo_map(i, start/chunk_size, raid_disks,
> 

This is not the prettiest solution, would have been nicer to introduce a
cleanup handler at the end and just jumping to it.

That said, I have applied it since restripe.c is pretty ugly across the
board.

Thanks,
Jes
