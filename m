Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C67A4409
	for <linux-raid@vger.kernel.org>; Mon, 24 Jun 2024 01:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719194160; cv=none; b=X8bvstQj3zjBZ5fMcWFgrhoBm+mN1DyAv+JQ+9tFMgUKGIcJ/yo94rl0bEjeCdzsJZLRvgxL9sLmxTZvZokLRJd0501ECpV3JXvQHN+hU39IbpfApmOsiOw4Qbl8ipaBbvGjlrA+uJVEm/EyFA6+4+TLBJCfU+oflP/OhgyxUZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719194160; c=relaxed/simple;
	bh=tp+s16KfMXo4vybs1klwkFHyIim6DcV8/xKMKQd7jWw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MmIAk+YSVyb540kvfit//ELmToXosg+4uZbhqccEXz5rdxqhKVEA6AuMCUlsbb1lhcCKWMnOX+HezecQfGv+Y5LTov00m7jsmd4r3ZAgS9Gt5F8alCuPEyP7k+0zjMgOQJYvvPJAZfu52nk5nZwIYye1Pg1DTL9j019bym0qYew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Fg21cHBv; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Fg21cHBv"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-36532d177a0so2302298f8f.2
        for <linux-raid@vger.kernel.org>; Sun, 23 Jun 2024 18:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1719194154; x=1719798954; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bIfcy2V78RIWV6X/I2VM1vJU1O7vpSniRqLsoBQHWm4=;
        b=Fg21cHBvPGB7piCKqbOQ4ifpXRVWVd0iSoAFIjVIs8xhOzEBorhnnk2gwHHTYzpgwi
         ClAGq7HyCkTMucTFnWxZAwnsEmOzsloP67kU+m7RH65WOe6/btUGauVKVI9e6SNwU0bb
         nNSm0Y/Y2/5AK65KkcMkX7Qrg4/zzAgLzHuNAWfhfwT/1nX+zvn9ecK4PZnSNwXQuEVB
         o4U45rTaml6Z+9zAudumoGVIIU8q1nA+7tXZ5PRRDUTuVREG4i61RJt+2RatvEiZaHp1
         V2WQ9VB9OBfWC8//6qxyo0H1QrP4zM0gREq5E9yr0TkHv+Xag+TDp9kwpALdtNwttFq9
         4uEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719194154; x=1719798954;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bIfcy2V78RIWV6X/I2VM1vJU1O7vpSniRqLsoBQHWm4=;
        b=rHsiOBXRLswevDxwbiAUtvOu/gM2AiHbUaaNECq3M32P6pZgEYf2RP7p9CVhw419Um
         6jaarGbjeeqyKjudrZ2l8T3SDN6/xACnPyVWZEwmBgpXz911z1M6LhrQ5pWxb1+FHnHp
         k2E6FFtbgi0YrvOWM5N93QcAK0+Mi8m+Twp1ROMPGe6iIT56YIc9zn+2vZSOJR4sb8bz
         KG3jxcVsb1ZtXEG8CcJo3Aek73YmLPPA1xlXL/v3KeGVD9p3gV3Sp7YbC4lCddNdfVtn
         HMv2Ga9dJInfgKtkVcaCNliXdbDakd41ZCkFiluqOBvG8Tz9ct+qf6R/lMlc2D5Jtfg6
         AG5w==
X-Forwarded-Encrypted: i=1; AJvYcCXNeVi0w0P9JL++EtSO8aU7QVj42N+VIuSprva5UnCIwc8sJuKX0L5Vwwjt37RiSglm+861iGOpwTDYQFUAtIKt+nXPVY26vXiLQA==
X-Gm-Message-State: AOJu0YwwXSuC32Wf7ACFmd5Wli+KylG1slw/hn6ZYPy/geUubkIynImm
	R93XY4u9C3lXFb8fj8MhjCILm/LghYhscA5CGZ+SMBEF7G8B8OZFsyj3aVE4+og=
X-Google-Smtp-Source: AGHT+IFjOOIjjTbiVjXb4YpWRhrjF10pB3vlRTFOxEThZNa7wI4n3bETI4POIhr8HnZMy/vuZGUwmQ==
X-Received: by 2002:a5d:4b4c:0:b0:360:9c4f:1f8 with SMTP id ffacd0b85a97d-366e4eddcd8mr2855131f8f.34.1719194154612;
        Sun, 23 Jun 2024 18:55:54 -0700 (PDT)
Received: from [127.0.0.1] ([163.5.65.5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-366389b85a2sm8588217f8f.42.2024.06.23.18.55.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Jun 2024 18:55:54 -0700 (PDT)
Message-ID: <683d0326-c67b-4273-b19c-8cb39b28e736@suse.com>
Date: Mon, 24 Jun 2024 09:55:47 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] md-cluster: fix hanging issue while a new disk adding
To: song@kernel.org, yukuai1@huaweicloud.com, xni@redhat.com
Cc: glass.su@suse.com, linux-raid@vger.kernel.org, colyli@suse.de
References: <20240612021911.11043-1-heming.zhao@suse.com>
Content-Language: en-US
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <20240612021911.11043-1-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello Song & Kuai,

Xiao ni told me that he has been quite busy recently and cannot review
the code. Do you have time to review my code?

btw,
The patches has been passed the 60 loops of clustermd_tests [1]. because
the kernel md layer code changes, the clustermd_tests scripts also need
to be updated. I will send the clustermd_tests patch when the kernel
layer code passes review.

[1]: https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/tree/clustermd_tests

Thanks,
Heming

On 6/12/24 10:19, Heming Zhao wrote:
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
> ---
>   drivers/md/md-cluster.c | 14 ++++++++++++--
>   1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index 8e36a0feec09..27eaaf9fef94 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -130,8 +130,13 @@ static int dlm_lock_sync(struct dlm_lock_resource *res, int mode)
>   			0, sync_ast, res, res->bast);
>   	if (ret)
>   		return ret;
> -	wait_event(res->sync_locking, res->sync_locking_done);
> +	ret = wait_event_timeout(res->sync_locking, res->sync_locking_done,
> +				60 * HZ);
>   	res->sync_locking_done = false;
> +	if (!ret) {
> +		pr_err("locking DLM '%s' timeout!\n", res->name);
> +		return -EBUSY;
> +	}
>   	if (res->lksb.sb_status == 0)
>   		res->mode = mode;
>   	return res->lksb.sb_status;
> @@ -744,12 +749,14 @@ static void unlock_comm(struct md_cluster_info *cinfo)
>   static int __sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg)
>   {
>   	int error;
> +	int ret = 0;
>   	int slot = cinfo->slot_number - 1;
>   
>   	cmsg->slot = cpu_to_le32(slot);
>   	/*get EX on Message*/
>   	error = dlm_lock_sync(cinfo->message_lockres, DLM_LOCK_EX);
>   	if (error) {
> +		ret = error;
>   		pr_err("md-cluster: failed to get EX on MESSAGE (%d)\n", error);
>   		goto failed_message;
>   	}
> @@ -759,6 +766,7 @@ static int __sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg)
>   	/*down-convert EX to CW on Message*/
>   	error = dlm_lock_sync(cinfo->message_lockres, DLM_LOCK_CW);
>   	if (error) {
> +		ret = error;
>   		pr_err("md-cluster: failed to convert EX to CW on MESSAGE(%d)\n",
>   				error);
>   		goto failed_ack;
> @@ -767,6 +775,7 @@ static int __sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg)
>   	/*up-convert CR to EX on Ack*/
>   	error = dlm_lock_sync(cinfo->ack_lockres, DLM_LOCK_EX);
>   	if (error) {
> +		ret = error;
>   		pr_err("md-cluster: failed to convert CR to EX on ACK(%d)\n",
>   				error);
>   		goto failed_ack;
> @@ -775,6 +784,7 @@ static int __sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg)
>   	/*down-convert EX to CR on Ack*/
>   	error = dlm_lock_sync(cinfo->ack_lockres, DLM_LOCK_CR);
>   	if (error) {
> +		ret = error;
>   		pr_err("md-cluster: failed to convert EX to CR on ACK(%d)\n",
>   				error);
>   		goto failed_ack;
> @@ -789,7 +799,7 @@ static int __sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg)
>   		goto failed_ack;
>   	}
>   failed_message:
> -	return error;
> +	return ret;
>   }
>   
>   static int sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg,

