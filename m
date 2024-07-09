Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A481155303
	for <linux-raid@vger.kernel.org>; Tue,  9 Jul 2024 11:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523189; cv=none; b=ttAejxemkbZkGD4ucW0RHrVMm0C9Nb3tupRIrsffztx+hMz61AECuV+51IP2bHMj75NWP/ZNOasec6p7DChPrAwFeBHye09hyavM1kOmlgGa29cqUkZ7/ToyITJ0GRbqmT6dIgG89/liCv+HfwCp73s2lhc3OAbp0ZWWljUFN1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523189; c=relaxed/simple;
	bh=+6lizHPV30rmr/TO4pHb+nI6H87s4pEncKROEQ42zcw=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=H3voaZgcAqRoGBnJdLj22S91pTSB1IeFDxNQA++1A3xrb95hYCp7bJBaECf7LbCa5FwVO2CMZZsSJ26PKhOKQ1GkUv+sMMCWAvVW05SbPGahvk1ewNWONXQdlHOMV2Xfj2xIkrMn36E8K2ynFHxpfDUID0zNGikgbzo7DiHtbJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4WJJ830Z01z4f3jdb
	for <linux-raid@vger.kernel.org>; Tue,  9 Jul 2024 19:06:11 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id A27881A0189
	for <linux-raid@vger.kernel.org>; Tue,  9 Jul 2024 19:06:22 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP2 (Coremail) with SMTP id Syh0CgCXAYesGY1m1Dx0Bg--.48235S3;
	Tue, 09 Jul 2024 19:06:22 +0800 (CST)
Subject: Re: [PATCH v2 1/2] md-cluster: fix hanging issue while a new disk
 adding
To: Heming Zhao <heming.zhao@suse.com>, song@kernel.org,
 yukuai1@huaweicloud.com, xni@redhat.com
Cc: glass.su@suse.com, linux-raid@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240709104120.22243-1-heming.zhao@suse.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <dedf52bc-5a64-1dd0-9f38-2843ad73a696@huaweicloud.com>
Date: Tue, 9 Jul 2024 19:06:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240709104120.22243-1-heming.zhao@suse.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgCXAYesGY1m1Dx0Bg--.48235S3
X-Coremail-Antispam: 1UD129KBjvJXoWxZr1fXryftF47tr43Jw1fJFb_yoWrGF48pF
	429398tr4YqrZ7WFsakrWqvFWrCw18K34xG347Ka1fZF1DtF10gF4DGr9I9Fyagry7Ja9F
	qF4DGFZ8u3s8Z3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
	Y487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUoOJ5UU
	UUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

ÔÚ 2024/07/09 18:41, Heming Zhao Ð´µÀ:
> The commit 1bbe254e4336 ("md-cluster: check for timeout while a
> new disk adding") is correct in terms of code syntax but not
> suite real clustered code logic.
> 
> When a timeout occurs while adding a new disk, if recv_daemon()
> bypasses the unlock for ack_lockres:CR, another node will be waiting
> to grab EX lock. This will cause the cluster to hang indefinitely.
> 
> How to fix:
> 
> 1. In dlm_lock_sync(), change the wait behaviour from forever to a
>     timeout, This could avoid the hanging issue when another node
>     fails to handle cluster msg. Another result of this change is
>     that if another node receives an unknown msg (e.g. a new msg_type),
>     the old code will hang, whereas the new code will timeout and fail.
>     This could help cluster_md handle new msg_type from different
>     nodes with different kernel/module versions (e.g. The user only
>     updates one leg's kernel and monitors the stability of the new
>     kernel).
> 2. The old code for __sendmsg() always returns 0 (success) under the
>     design (must successfully unlock ->message_lockres). This commit
>     makes this function return an error number when an error occurs.
> 
> Fixes: 1bbe254e4336 ("md-cluster: check for timeout while a new disk adding")
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> Reviewed-by: Su Yue <glass.su@suse.com>

Thanks for the patch.

Acked-by: Yu Kuai <yukuai3@huawei.com>
> ---
> v1 -> v2:
> - use define WAIT_DLM_LOCK_TIMEOUT instead of hard code
> - change timeout value from 60s to 30s
> - follow Kuai's suggestion to use while loop to unlock message_lockres
> ---
>   drivers/md/md-cluster.c | 22 ++++++++++++----------
>   1 file changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index 8e36a0feec09..b5a802ae17bb 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -15,6 +15,7 @@
>   
>   #define LVB_SIZE	64
>   #define NEW_DEV_TIMEOUT 5000
> +#define WAIT_DLM_LOCK_TIMEOUT (30 * HZ)
>   
>   struct dlm_lock_resource {
>   	dlm_lockspace_t *ls;
> @@ -130,8 +131,13 @@ static int dlm_lock_sync(struct dlm_lock_resource *res, int mode)
>   			0, sync_ast, res, res->bast);
>   	if (ret)
>   		return ret;
> -	wait_event(res->sync_locking, res->sync_locking_done);
> +	ret = wait_event_timeout(res->sync_locking, res->sync_locking_done,
> +				WAIT_DLM_LOCK_TIMEOUT);
>   	res->sync_locking_done = false;
> +	if (!ret) {
> +		pr_err("locking DLM '%s' timeout!\n", res->name);
> +		return -EBUSY;
> +	}
>   	if (res->lksb.sb_status == 0)
>   		res->mode = mode;
>   	return res->lksb.sb_status;
> @@ -743,7 +749,7 @@ static void unlock_comm(struct md_cluster_info *cinfo)
>    */
>   static int __sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg)
>   {
> -	int error;
> +	int error, unlock_error;
>   	int slot = cinfo->slot_number - 1;
>   
>   	cmsg->slot = cpu_to_le32(slot);
> @@ -751,7 +757,7 @@ static int __sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg)
>   	error = dlm_lock_sync(cinfo->message_lockres, DLM_LOCK_EX);
>   	if (error) {
>   		pr_err("md-cluster: failed to get EX on MESSAGE (%d)\n", error);
> -		goto failed_message;
> +		return error;
>   	}
>   
>   	memcpy(cinfo->message_lockres->lksb.sb_lvbptr, (void *)cmsg,
> @@ -781,14 +787,10 @@ static int __sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg)
>   	}
>   
>   failed_ack:
> -	error = dlm_unlock_sync(cinfo->message_lockres);
> -	if (unlikely(error != 0)) {
> +	while ((unlock_error = dlm_unlock_sync(cinfo->message_lockres)))
>   		pr_err("md-cluster: failed convert to NL on MESSAGE(%d)\n",
> -			error);
> -		/* in case the message can't be released due to some reason */
> -		goto failed_ack;
> -	}
> -failed_message:
> +			unlock_error);
> +
>   	return error;
>   }
>   
> 

