Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205D11E47AE;
	Wed, 30 Jul 2025 07:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753861664; cv=none; b=PfEzxncFIBnnKR/VFopWqCtXXE0Wgak74yH2XuPFO5G5yGZHKz2ccBCEVBUy3pcvvjVh6V96OlHBjc/GngmPT7z/tGt+F59RGzQvByfpYymSHjHBQaQJSUQ4nGMzqmTmHT0bqE2B9nYvLsq4K+umsrUqALxijmPJRHAfGvLkzPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753861664; c=relaxed/simple;
	bh=RdnRTWz6q5dc7ZEVCfnQbL14nbOEVcUJ8cYBq7rRizk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bTMbciOvpgj8tIIbDGi+piFa5KZyF3bzWoDn33pb0/uNjcEwHmngtMBcAH0Jehq5N3cscOr2PbBZQizkSMD51ex1L5DPFS4b5LD9l/sBABYoSVJNyEXDfGRecF1ZdZrzg1zSZCpdpkMSW76lTDZrzO/g63Rws1325H1nenGp+v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.0.5] (ip5f5af7d2.dynamic.kabel-deutschland.de [95.90.247.210])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 9989661E647BA;
	Wed, 30 Jul 2025 09:46:43 +0200 (CEST)
Message-ID: <51d8593c-150e-4c81-8b0a-37720062a5d8@molgen.mpg.de>
Date: Wed, 30 Jul 2025 09:46:42 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md: fix create on open mddev lifetime regression
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: contact@arnaud-lcm.com, hdanton@sina.com, song@kernel.org,
 yukuai3@huawei.com, xni@redhat.com, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com
References: <20250730073321.2583158-1-yukuai1@huaweicloud.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20250730073321.2583158-1-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Dear Kuai,


Thank you for your patch and tracking this down.

Am 30.07.25 um 09:33 schrieb Yu Kuai:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> Commit 9e59d609763f ("md: call del_gendisk in control path") move

move*s*

> setting MD_DELETED from __mddev_put() to do_md_stop(), however, for the
> case create on open, mddev can be freed without do_md_stop():
> 
> 1) open
> 
> md_probe
>   md_alloc_and_put
>    md_alloc
>     mddev_alloc
>     atomic_set(&mddev->active, 1);
>     mddev->hold_active = UNTIL_IOCTL
>    mddev_put
>     atomic_dec_and_test(&mddev->active)
>      if (mddev->hold_active)
>      -> active is 0, hold_active is set
> md_open
>   mddev_get
>    atomic_inc(&mddev->active);
> 
> 2) ioctl that is not STOP_ARRAY, for example, GET_ARRAY_INFO:
> 
> md_ioctl
>   mddev->hold_active = 0
> 
> 3) close
> 
> md_release
>   mddev_put(mddev);
>    atomic_dec_and_lock(&mddev->active, &all_mddevs_lock)
>    __mddev_put
>    -> hold_active is cleared, mddev will be freed
>    queue_work(md_misc_wq, &mddev->del_work)
> 
> Now that MD_DELETED is not set, before mddev is freed by
> mddev_delayed_delete(), md_open can still succeed and break mddev
> lifetime, causing mddev->kobj refcount underflow or mddev uaf
> problem.
> 
> Fix this problem by setting MD_DELETED before queuing del_work.
> 
> Reported-by: syzbot+9921e319bd6168140b40@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/68894408.a00a0220.26d0e1.0012.GAE@google.com/
> Reported-by: syzbot+fa3a12519f0d3fd4ec16@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/68894408.a00a0220.26d0e1.0013.GAE@google.com/
> Fixes: 9e59d609763f ("md: call del_gendisk in control path")
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   drivers/md/md.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 046fe85c76fe..5289dcc3a6af 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -636,6 +636,12 @@ static void __mddev_put(struct mddev *mddev)
>   	    mddev->ctime || mddev->hold_active)
>   		return;
>   
> +	/*
> +	 * If array is freed by stopping array, MD_DELETED is set by
> +	 * do_md_stop(), MD_DELETED is still set here in cause mddev is freed

in case

> +	 * directly by closing a mddev that is created by create_on_open.
> +	 */
> +	set_bit(MD_DELETED, &mddev->flags);
>   	/*
>   	 * Call queue_work inside the spinlock so that flush_workqueue() after
>   	 * mddev_find will succeed in waiting for the work to be done.

With the changes above:

Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>


Kind regards,

Paul
