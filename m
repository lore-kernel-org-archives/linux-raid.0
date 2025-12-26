Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A5117A2E8;
	Fri, 26 Dec 2025 07:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766733052; cv=none; b=Byva604ANADzbNag9jwdVXIpjZbbvaoc3I9PJsX1vBx6aht5Hi6rLIHz4zM5v6kqYmDF5lzLgIqZcf6InGyQ724eH+xnZJ5IPXUzHLwzwByJ+15Q2KgkPQv+fdqlS/+S5YUbpth2XHLbK8UpJLT+xPvDOyDp0flv8FfWIZoEiA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766733052; c=relaxed/simple;
	bh=C4ohPF44z3DJaeVIeGjjo+lA3B322Tks0RWfvKUTfwA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jEpzoyasg2ZU8k0Nrb763ov+9yU3I13kkxLDzCJ5P2c+j4Faa8vjbfERuBd4rWAr3K+OHKI0iyBsuMBmfBZFHwNpBU9TOI8G0sAkdD6WD9goAfnCdFamcYjzviLL8dcYgDXO6kvMsSlTGTo1Ty/Yvvjcx5AIq4MUQvSFLu88Qog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [10.128.41.173] (unknown [103.50.105.82])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 238A761E647BA;
	Fri, 26 Dec 2025 08:10:18 +0100 (CET)
Message-ID: <19395340-acad-4e2f-938f-874c92b209bc@molgen.mpg.de>
Date: Fri, 26 Dec 2025 12:09:57 +0500
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] md/raid5: fix possible null-pointer dereferences in
 raid5_store_group_thread_cnt()
To: Tuo Li <islituo@gmail.com>
Cc: song@kernel.org, yukuai@fnnas.com, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20251225130326.67780-1-islituo@gmail.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20251225130326.67780-1-islituo@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Dear Tuo,


Thank you for your patch.


Am 25.12.25 um 18:03 schrieb Tuo Li:
> The variable mddev->private is first assigned to conf and then checked:
> 
>     conf = mddev->private;
>      if (!conf) ...

Should you resend, please align conf` and `if`.

> If conf is NULL, then mddev->private is also NULL. In this case,
> null-pointer dereferences can occur when calling raid5_quiesce():
> 
>    raid5_quiesce(mddev, true);
>    raid5_quiesce(mddev, false);
> 
> since mddev->private is assigned to conf again in raid5_quiesce(), and conf
> is dereferenced in several places, for example:
> 
>    conf->quiesce = 0;
>    wake_up(&conf->wait_for_quiescent);
> 
> To fix this issue, the function should unlock mddev and return before
> invoking raid5_quiesce() when conf is NULL, following the existing pattern
> in raid5_change_consistency_policy().
> 
> Fixes: fa1944bbe622 ("md/raid5: Wait sync io to finish before changing group cnt")
> Signed-off-by: Tuo Li <islituo@gmail.com>
> ---
> v2:
> * Move the NULL check and early return ahead of the first call to
>    raid5_quiesce().
>    Thanks to Yu Kuai for helpful advice.
> ---
>   drivers/md/raid5.c | 10 ++++++----
>   1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index e57ce3295292..8dc98f545969 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -7187,12 +7187,14 @@ raid5_store_group_thread_cnt(struct mddev *mddev, const char *page, size_t len)
>   	err = mddev_suspend_and_lock(mddev);
>   	if (err)
>   		return err;
> +	conf = mddev->private;
> +	if (!conf) {
> +		mddev_unlock_and_resume(mddev);
> +		return -ENODEV;
> +	}
>   	raid5_quiesce(mddev, true);
>   
> -	conf = mddev->private;
> -	if (!conf)
> -		err = -ENODEV;
> -	else if (new != conf->worker_cnt_per_group) {
> +	if (new != conf->worker_cnt_per_group) {
>   		old_groups = conf->worker_groups;
>   		if (old_groups)
>   			flush_workqueue(raid5_wq);

Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>


Kind regards,

Paul
