From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: [PATCH] md-cluster: correct the num for comparison
Date: Fri, 10 Apr 2015 08:35:52 -0500
Message-ID: <5527D1B8.3060308@suse.de>
References: <1428653172-12678-1-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1428653172-12678-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: gqjiang@suse.com, neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 04/10/2015 03:06 AM, gqjiang@suse.com wrote:
> From: Guoqing Jiang <gqjiang@suse.com>
>
> Since the node num of md-cluster is from zero, and
> cinfo->slot_number represents the slot num of dlm,
> here also need to deduct one to keep consistency
> with other codes.


This is a good find. Though I would prefer that the comparison be
(nodes < cinfo->slot_number) to decrease computation and looks better, 
though the compiler may optimize what you have done as well.

>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>   drivers/md/md-cluster.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index ae8bb54..531cc2b 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -612,7 +612,7 @@ static int join(struct mddev *mddev, int nodes)
>   	if (ret)
>   		goto err;
>   	wait_for_completion(&cinfo->completion);
> -	if (nodes <= cinfo->slot_number) {
> +	if (nodes <= cinfo->slot_number - 1) {
>   		pr_err("md-cluster: Slot allotted(%d) greater than available slots(%d)", cinfo->slot_number - 1,
>   			nodes);
>   		ret = -ERANGE;
>

-- 
Goldwyn
