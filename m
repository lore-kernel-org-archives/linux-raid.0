From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: [PATCH 06/12] md-cluster: add the error check if failed to get
 dlm lock
Date: Mon, 27 Jul 2015 11:48:13 -0500
Message-ID: <55B660CD.2030600@suse.de>
References: <1436518453-12660-1-git-send-email-gqjiang@suse.com>
 <1436518883-12783-1-git-send-email-gqjiang@suse.com>
 <1436518883-12783-3-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1436518883-12783-3-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>, neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Guoqing,

On 07/10/2015 04:01 AM, Guoqing Jiang wrote:
> In complicated cluster environment, it is possible that the
> dlm lock couldn't be get/convert on purpose, the related err
> info is added for better debug potential issue.
>
> For lockres_free, if the lock is blocking by a lock request or
> conversion request, then dlm_unlock just put it back to grant
> queue, so need to ensure the lock is free finally.


I cannot think of a scenario where a DLM_CANCEL will be returned. Could 
you explain the situation a bit more?

>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>   drivers/md/md-cluster.c | 41 +++++++++++++++++++++++++++++++++++------
>   1 file changed, 35 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index 2a57f19..b80a689 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -166,10 +166,24 @@ out_err:
>
>   static void lockres_free(struct dlm_lock_resource *res)
>   {
> +	int ret;
> +
>   	if (!res)
>   		return;
>
> -	dlm_unlock(res->ls, res->lksb.sb_lkid, 0, &res->lksb, res);
> +	/* cancel a lock request or a conversion request that is blocked */
> +	res->flags |= DLM_LKF_CANCEL;
> +retry:
> +	ret = dlm_unlock(res->ls, res->lksb.sb_lkid, 0, &res->lksb, res);
> +	if (unlikely(ret != 0)) {
> +		pr_info("%s: failed to unlock %s return %d\n", __func__, res->name, ret);
> +
> +		/* if a lock conversion is cancelled, then the lock is put
> +		 * back to grant queue, need to ensure it is unlocked */
> +		if (ret == -DLM_ECANCEL)
> +			goto retry;
> +	}
> +	res->flags &= ~DLM_LKF_CANCEL;
>   	wait_for_completion(&res->completion);
>
>   	kfree(res->name);
> @@ -474,6 +488,7 @@ static void recv_daemon(struct md_thread *thread)
>   	struct dlm_lock_resource *ack_lockres = cinfo->ack_lockres;
>   	struct dlm_lock_resource *message_lockres = cinfo->message_lockres;
>   	struct cluster_msg msg;
> +	int ret;
>
>   	/*get CR on Message*/
>   	if (dlm_lock_sync(message_lockres, DLM_LOCK_CR)) {
> @@ -486,13 +501,21 @@ static void recv_daemon(struct md_thread *thread)
>   	process_recvd_msg(thread->mddev, &msg);
>
>   	/*release CR on ack_lockres*/
> -	dlm_unlock_sync(ack_lockres);
> +	ret = dlm_unlock_sync(ack_lockres);
> +	if (unlikely(ret != 0))
> +		pr_info("unlock ack failed return %d\n", ret);
>   	/*up-convert to PR on message_lockres*/
> -	dlm_lock_sync(message_lockres, DLM_LOCK_PR);
> +	ret = dlm_lock_sync(message_lockres, DLM_LOCK_PR);
> +	if (unlikely(ret != 0))
> +		pr_info("lock PR on msg failed return %d\n", ret);
>   	/*get CR on ack_lockres again*/
> -	dlm_lock_sync(ack_lockres, DLM_LOCK_CR);
> +	ret = dlm_lock_sync(ack_lockres, DLM_LOCK_CR);
> +	if (unlikely(ret != 0))
> +		pr_info("lock CR on ack failed return %d\n", ret);
>   	/*release CR on message_lockres*/
> -	dlm_unlock_sync(message_lockres);
> +	ret = dlm_unlock_sync(message_lockres);
> +	if (unlikely(ret != 0))
> +		pr_info("unlock msg failed return %d\n", ret);
>   }
>
>   /* lock_comm()
> @@ -567,7 +590,13 @@ static int __sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg)
>   	}
>
>   failed_ack:
> -	dlm_unlock_sync(cinfo->message_lockres);
> +	error = dlm_unlock_sync(cinfo->message_lockres);
> +	if (unlikely(error != 0)) {
> +		pr_err("md-cluster: failed convert to NL on MESSAGE(%d)\n",
> +			error);
> +		/* in case the message can't be released due to some reason */
> +		goto failed_ack;
> +	}
>   failed_message:
>   	return error;
>   }
>

-- 
Goldwyn
