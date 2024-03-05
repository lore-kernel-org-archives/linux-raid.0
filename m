Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A94B59B6D
	for <linux-raid@vger.kernel.org>; Tue,  5 Mar 2024 12:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709640079; cv=none; b=WXDFa2h1hAw5FaQdg1NyBe97NEGa5Bzk58FaoiXwwRDOsHMxH4rithZCQzkRITxExOv9vOhaLmb3WyQKD0EGrh5LT/lwFlux/ZQjVEVtTLSorYsNBzCz9jr9oQ5efP2e5i5phveS3Zej94fJEzWAE3RfpHWuNijl51+ghtoFzd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709640079; c=relaxed/simple;
	bh=E1M5msZTEYrim0s8lrUiX3yKO1tz1qu38x6UvZVJscQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bIYoCepBhuLcOicN/w8DqyGyHUyo5NQ7kUGxSCo1AuTxMQ2lNi5x/dTea9clhgjS9oXjiibjntwDlxV8XMHpSHzlMBugSqUIp1WluRemxJyVUE2QPa8zI2BtE4ifQRjC0rQ0XI/OKQ3vDVWn/OFL0I7cv9FYUywomXYhfF+q6QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [141.14.220.34] (g34.guest.molgen.mpg.de [141.14.220.34])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id A84AC61E5FE38;
	Tue,  5 Mar 2024 13:00:50 +0100 (CET)
Message-ID: <9874f0e8-32d4-4c29-a332-718fb95a365a@molgen.mpg.de>
Date: Tue, 5 Mar 2024 13:00:50 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2] md: Replace md_thread's wait queue with the swait
 variant
Content-Language: en-US
To: Jack Wang <jinpu.wang@ionos.com>
Cc: Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>, song@kernel.org,
 yukuai3@huawei.com, linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
References: <20240305105419.21077-1-jinpu.wang@ionos.com>
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20240305105419.21077-1-jinpu.wang@ionos.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Jack, dear Florian-Ewald,


Thank you for your patch.

Am 05.03.24 um 11:54 schrieb Jack Wang:
> From: Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>
> 
> Replace md_thread's wait_event()/wake_up() related calls with their
> simple swait~ variants to improve performance as well as memory and
> stack footprint.
> 
> Use the IDLE state for the worker thread put to sleep instead of
> misusing the INTERRUPTIBLE state combined with flushing signals
> just for not contributing to system's cpu load-average stats.
> 
> Also check for sleeping thread before attempting its wake_up in
> md_wakeup_thread() for avoiding unnecessary spinlock contention.
> 
> With this patch (backported) on a kernel 6.1, the IOPS improved
> by around 4% with raid1 and/or raid5, in high IO load scenarios.

It’d be great if you elaborated on your test setup.

Should this have?

Fixes: 93588e2284b6 ("[PATCH] md: make md threads interruptible again")

I ask, because the simple waitqueue (swait) implementation was only 
introduced in 2016, so 11 years later than the mentioned commit.

> Signed-off-by: Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>
> Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
> ---
> v2: fix a type error for thread
>   drivers/md/md.c | 23 +++++++----------------
>   drivers/md/md.h |  2 +-
>   2 files changed, 8 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 48ae2b1cb57a..14d12ee4b06b 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7970,22 +7970,12 @@ static int md_thread(void *arg)
>   	 * many dirty RAID5 blocks.
>   	 */
>   
> -	allow_signal(SIGKILL);
>   	while (!kthread_should_stop()) {
>   
> -		/* We need to wait INTERRUPTIBLE so that
> -		 * we don't add to the load-average.
> -		 * That means we need to be sure no signals are
> -		 * pending
> -		 */
> -		if (signal_pending(current))
> -			flush_signals(current);
> -
> -		wait_event_interruptible_timeout
> -			(thread->wqueue,
> -			 test_bit(THREAD_WAKEUP, &thread->flags)
> -			 || kthread_should_stop() || kthread_should_park(),
> -			 thread->timeout);
> +		swait_event_idle_timeout_exclusive(thread->wqueue,
> +			test_bit(THREAD_WAKEUP, &thread->flags) ||
> +			kthread_should_stop() || kthread_should_park(),
> +			thread->timeout);
>   
>   		clear_bit(THREAD_WAKEUP, &thread->flags);
>   		if (kthread_should_park())
> @@ -8017,7 +8007,8 @@ void md_wakeup_thread(struct md_thread __rcu *thread)
>   	if (t) {
>   		pr_debug("md: waking up MD thread %s.\n", t->tsk->comm);
>   		set_bit(THREAD_WAKEUP, &t->flags);
> -		wake_up(&t->wqueue);
> +		if (swq_has_sleeper(&t->wqueue))
> +			swake_up_one(&t->wqueue);
>   	}
>   	rcu_read_unlock();
>   }
> @@ -8032,7 +8023,7 @@ struct md_thread *md_register_thread(void (*run) (struct md_thread *),
>   	if (!thread)
>   		return NULL;
>   
> -	init_waitqueue_head(&thread->wqueue);
> +	init_swait_queue_head(&thread->wqueue);
>   
>   	thread->run = run;
>   	thread->mddev = mddev;
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index b2076a165c10..1dc01bc5c038 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -716,7 +716,7 @@ static inline void sysfs_unlink_rdev(struct mddev *mddev, struct md_rdev *rdev)
>   struct md_thread {
>   	void			(*run) (struct md_thread *thread);
>   	struct mddev		*mddev;
> -	wait_queue_head_t	wqueue;
> +	struct swait_queue_head	wqueue;
>   	unsigned long		flags;
>   	struct task_struct	*tsk;
>   	unsigned long		timeout;

Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>


Kind regards,

Paul
