Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECAF18C928;
	Wed, 30 Jul 2025 18:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753899659; cv=none; b=o0Zg3iwlJdZ/pyRAJYAceQbsfXx30uCcMZkXGsWhpm76qidXbm6Tw7t65PuP8D9QmP4GGhTOuxdn3dczxR9z5B43IfUeMwwzTaavLRkGbFnPGvida+msAOoBLbJE8q7XRG3t+HnUrfgrDx5tfVP/2Yl+aMa8WnwmmYf5yhZM+Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753899659; c=relaxed/simple;
	bh=0RbVunufVgPWLnHwUtYZPnVYJ31DFa06ijwRa9p6m0M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UQVFKFZFVh3WQ1n+VvJosItSnYqnhkQEhO0E9kwrv7E7I0IV3049kVNTGUCHV/fhRG9XY4EpO2b7k4baQ1FGRJ9qebt43qJPOOO1imjQnFn+czg44yTEmDfnBgHzQ5qY9NqLAonuPPmMojwj+e48jq9tgmSho9Al9Jw4y9JghFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f1WDKnaZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f1WDKnaZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEDAAC4CEE3;
	Wed, 30 Jul 2025 18:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753899658;
	bh=0RbVunufVgPWLnHwUtYZPnVYJ31DFa06ijwRa9p6m0M=;
	h=Date:Reply-To:Subject:To:Cc:References:From:In-Reply-To:From;
	b=f1WDKnaZQcnAyMYqgxgatoTz9j0gmjF2GeGvVO9K1ZaT5lcjK/Jqy5RHrUFvAmDHn
	 JqHA/lTiyJgs96DnJTDw7p+tdxrZ5O70YTzQmGWKROokre87WXcK3UjZ+lMdw/8eeE
	 oVFhL/8pyATrY05jy7N64ke+4Icsm2m59k24tI5wAL7YtFS4uucGRiIYvfXdqpFPuV
	 ExiYgPdGhnyykh91nCfmUzPYNxaLUayB8XyWmULvdAVgA+ttQOSqyxzoJQCfZ4tyTT
	 UH+zu+r525LlRNkseGYDYtBS/8sJkOtEpYCCqmVd/BZ8/JXJa8u9zljI+XCSLX+hP+
	 7HjFj70FLVLFw==
Message-ID: <9361bc9c-d6a5-4252-9c02-bc7b0448eeea@kernel.org>
Date: Thu, 31 Jul 2025 02:20:51 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@kernel.org
Subject: Re: [PATCH] md: fix create on open mddev lifetime regression
To: Yu Kuai <yukuai1@huaweicloud.com>, contact@arnaud-lcm.com,
 hdanton@sina.com, song@kernel.org, yukuai3@huawei.com, xni@redhat.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com
References: <20250730073321.2583158-1-yukuai1@huaweicloud.com>
Content-Language: en-US
From: Yu Kuai <yukuai@kernel.org>
In-Reply-To: <20250730073321.2583158-1-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

在 2025/7/30 15:33, Yu Kuai 写道:
> From: Yu Kuai <yukuai3@huawei.com>
>
> Commit 9e59d609763f ("md: call del_gendisk in control path") move
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
> +	 * directly by closing a mddev that is created by create_on_open.
> +	 */
> +	set_bit(MD_DELETED, &mddev->flags);
>   	/*
>   	 * Call queue_work inside the spinlock so that flush_workqueue() after
>   	 * mddev_find will succeed in waiting for the work to be done.
Applied to md-6.17 with typo fixed.
Thanks

