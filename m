Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E2823BD17;
	Thu,  2 Apr 2026 02:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775098425; cv=none; b=bXfvs5C92bBO2NqDLtySn9eijZZE73Irh6/9eMHJFSxPZnF/iTl2w78JU9QuBGdJ9F/l7M8AwMC31BpHP0OgdsES06Ox8KvsF2ZP4w9W7UHBR2hursiZNLlNpW6ovQ9l6JYq1Sxg1I4W0UD7bFtdPfj0QqWTA2aH8tdD0ee25nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775098425; c=relaxed/simple;
	bh=ZwVuMpBa9nlbgj0vWW3+YlmG1lSCMQOxHL1jn0WEOdw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qmIsgVr8cj0bxReREWosca691H5HWuBT/LssDKPIs2nYxKi2+CbPT+lqERLhI2aVQObSvQ9S5Lz2DOFi9P7tNit4JrUI4WO2HXWBwmNLGRKt0zT/t4OYfdNhWhLLRf0BX54qhS3eqF+gKOaVDT0lzxnp0Yzw1I2qVYrlXqCaRNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fmRHW1YsSzYQtHJ;
	Thu,  2 Apr 2026 10:53:11 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 74BB340561;
	Thu,  2 Apr 2026 10:53:34 +0800 (CST)
Received: from [10.174.178.255] (unknown [10.174.178.255])
	by APP1 (Coremail) with SMTP id cCh0CgC3Btcs2s1pj4dJDA--.48527S3;
	Thu, 02 Apr 2026 10:53:34 +0800 (CST)
Message-ID: <3f930776-20e7-f74b-067b-bfb348291a50@huaweicloud.com>
Date: Thu, 2 Apr 2026 10:53:32 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] md: wake raid456 reshape waiters before suspend
To: Yu Kuai <yukuai@fnnas.com>, song@kernel.org, linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "yangerkun@huawei.com"
 <yangerkun@huawei.com>
References: <20260327140729.2030564-1-yukuai@fnnas.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20260327140729.2030564-1-yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgC3Btcs2s1pj4dJDA--.48527S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Zr1DKF4kJrW5ur18tF4fXwb_yoW8ZF1Dp3
	y0gFZIqr1UJrnI9w4UJwn29F1Ygws3KFWakr9rJw4xZw1aq3WrJF43WFn8Xrn8CrZ7Jw4D
	Xw1rG3yruF18KaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Yb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487
	Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aV
	AFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xF
	o4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
	nIWIevJa73UjIFyTuYvjxU7ksqDUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2026/3/27 22:07, Yu Kuai 写道:
> During raid456 reshape, direct IO across the reshape position can sleep
> in raid5_make_request() waiting for reshape progress while still
> holding an active_io reference. If userspace then freezes reshape and
> writes md/suspend_lo or md/suspend_hi, mddev_suspend() kills active_io
> and waits for all in-flight IO to drain.
> 
> This can deadlock: the IO needs reshape progress to continue, but the
> reshape thread is already frozen, so the active_io reference is never
> dropped and suspend never completes.
> 
> raid5_prepare_suspend() already wakes wait_for_reshape for dm-raid. Do
> the same for normal md suspend when reshape is already interrupted, so
> waiting raid456 IO can abort, drop its reference, and let suspend
> finish.
> 
> The mdadm test tests/25raid456-reshape-deadlock reproduces the hang.
> 
> Fixes: 714d20150ed8 ("md: add new helpers to suspend/resume array")
> Signed-off-by: Yu Kuai <yukuai@fnnas.com>
> ---
>   drivers/md/md.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 65c85973092a..3ae5f36b5baf 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -489,6 +489,17 @@ int mddev_suspend(struct mddev *mddev, bool interruptible)
>   	}
>   
>   	percpu_ref_kill(&mddev->active_io);
> +
> +	/*
> +	 * RAID456 IO can sleep in wait_for_reshape while still holding an
> +	 * active_io reference. If reshape is already interrupted or frozen,
> +	 * wake those waiters so they can abort and drop the reference instead
> +	 * of deadlocking suspend.
> +	 */
> +	if (mddev->pers && mddev->pers->prepare_suspend &&
> +	    reshape_interrupted(mddev))
> +		mddev->pers->prepare_suspend(mddev);
> +
>   	if (interruptible)
>   		err = wait_event_interruptible(mddev->sb_wait,
>   				percpu_ref_is_zero(&mddev->active_io));

If I only freeze raid5 without suspend, the IO still hangs and cannot
complete. Should we fix this scenario?

-- 
Thanks,
Nan

