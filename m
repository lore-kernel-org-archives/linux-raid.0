Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A979208D0;
	Sat, 18 Oct 2025 07:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760772018; cv=none; b=p+qA+CRSzJCZaCYOJezeUjd4zIysGk+8+dd8ZaGkUetS8fKHsRtnCMy/095nm3zcmKOPRKr/YT9gw2Zroy10CmUfxhnhS8+TxD7iWhnkXnHhet5mECuKnr5fF6AlfnqSfXzyHY+XrwDGPorAeFtswglOADlSRbi8klUfqTTeGrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760772018; c=relaxed/simple;
	bh=jT7MAgnATCR2tBW5ZgFI6xY90WkJAcxAqAtP+7gvzFo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gj9kL9VueBf7Qe//rRwrrtCOHn39PGN3FMTtUKQ5wfBzugIqonzrO2AM5sJbPS2f0zsEEYVpyua98GubVvI5RD6pQsWvZ76uNUMXdASIiNFIePAQ7WQcX/GPFZGm9GXhcbOtLQbvRht4exmqOtkDcg7GN5L0Wx+PMC/+jzQju0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cpY3H1qPvzKHLsq;
	Sat, 18 Oct 2025 15:19:23 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id F12081A06DC;
	Sat, 18 Oct 2025 15:20:04 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP2 (Coremail) with SMTP id Syh0CgCn_UWkP_NopnUOAw--.21050S3;
	Sat, 18 Oct 2025 15:20:04 +0800 (CST)
Message-ID: <02e14a95-a421-04c5-0a26-2b108bf19117@huaweicloud.com>
Date: Sat, 18 Oct 2025 15:20:04 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] [v2] md: fix rcu protection in md_wakeup_thread
To: Yun Zhou <yun.zhou@windriver.com>, song@kernel.org, yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251015083227.1079009-1-yun.zhou@windriver.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20251015083227.1079009-1-yun.zhou@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgCn_UWkP_NopnUOAw--.21050S3
X-Coremail-Antispam: 1UD129KBjvJXoWxGF18Jryrtw17AFy8uFWxWFg_yoWrJF1kp3
	yktFy7Gr4YvrWUZw1UAa4DCa4Fvw10qF42krWxCw4rAw13Gws8tFy7KFyUX3s8CFyrGrsx
	Z3W5KFn5Zan7tF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBab4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l
	5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6xkF7I0En7
	xvr7AKxVWUJVW8JwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82
	IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC2
	0s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMI
	IF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF
	0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87
	Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07jbL0nUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/10/15 16:32, Yun Zhou 写道:
> We attempted to use RCU to protect the pointer 'thread', but directly
> passed the value when calling md_wakeup_thread(). This means that the
> RCU pointer has been acquired before rcu_read_lock(), which renders
> rcu_read_lock() ineffective and could lead to a use-after-free.
> 
> Fixes: 446931543982 ("md: protect md_thread with rcu")
> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
> ---
>   drivers/md/md.c | 14 ++++++--------
>   drivers/md/md.h |  8 +++++++-
>   2 files changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 4e033c26fdd4..7df3c47ee709 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -100,7 +100,7 @@ static int remove_and_add_spares(struct mddev *mddev,
>   				 struct md_rdev *this);
>   static void mddev_detach(struct mddev *mddev);
>   static void export_rdev(struct md_rdev *rdev, struct mddev *mddev);
> -static void md_wakeup_thread_directly(struct md_thread __rcu *thread);
> +static void md_wakeup_thread_directly(struct md_thread __rcu **thread);
>   
>   /*
>    * Default number of read corrections we'll attempt on an rdev
> @@ -4982,7 +4982,7 @@ static void stop_sync_thread(struct mddev *mddev, bool locked)
>   	 * Thread might be blocked waiting for metadata update which will now
>   	 * never happen
>   	 */
> -	md_wakeup_thread_directly(mddev->sync_thread);
> +	md_wakeup_thread_directly(&mddev->sync_thread);
>   	if (work_pending(&mddev->sync_work))
>   		flush_work(&mddev->sync_work);
>   
> @@ -8194,22 +8194,21 @@ static int md_thread(void *arg)
>   	return 0;
>   }
>   
> -static void md_wakeup_thread_directly(struct md_thread __rcu *thread)
> +static void md_wakeup_thread_directly(struct md_thread __rcu **thread)
>   {
>   	struct md_thread *t;
>   
>   	rcu_read_lock();
> -	t = rcu_dereference(thread);
> +	t = rcu_dereference(*thread);
>   	if (t)
>   		wake_up_process(t->tsk);
>   	rcu_read_unlock();
>   }
>   
> -void md_wakeup_thread(struct md_thread __rcu *thread)
> +void __md_wakeup_thread(struct md_thread __rcu *thread)
>   {
>   	struct md_thread *t;
>   
> -	rcu_read_lock();
>   	t = rcu_dereference(thread);
>   	if (t) {
>   		pr_debug("md: waking up MD thread %s.\n", t->tsk->comm);
> @@ -8217,9 +8216,8 @@ void md_wakeup_thread(struct md_thread __rcu *thread)
>   		if (wq_has_sleeper(&t->wqueue))
>   			wake_up(&t->wqueue);
>   	}
> -	rcu_read_unlock();
>   }
> -EXPORT_SYMBOL(md_wakeup_thread);
> +EXPORT_SYMBOL(__md_wakeup_thread);
>   
>   struct md_thread *md_register_thread(void (*run) (struct md_thread *),
>   		struct mddev *mddev, const char *name)
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 51af29a03079..c989cc9f6216 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -878,6 +878,12 @@ struct md_io_clone {
>   
>   #define THREAD_WAKEUP  0
>   
> +#define md_wakeup_thread(thread) do {   \
> +	rcu_read_lock();                    \
> +	__md_wakeup_thread(thread);         \
> +	rcu_read_unlock();                  \
> +} while (0)
> +
>   static inline void safe_put_page(struct page *p)
>   {
>   	if (p) put_page(p);
> @@ -891,7 +897,7 @@ extern struct md_thread *md_register_thread(
>   	struct mddev *mddev,
>   	const char *name);
>   extern void md_unregister_thread(struct mddev *mddev, struct md_thread __rcu **threadp);
> -extern void md_wakeup_thread(struct md_thread __rcu *thread);
> +extern void __md_wakeup_thread(struct md_thread __rcu *thread);
>   extern void md_check_recovery(struct mddev *mddev);
>   extern void md_reap_sync_thread(struct mddev *mddev);
>   extern enum sync_action md_sync_action(struct mddev *mddev);

LGTM

Reviewed-by: Li Nan <linan122@huawei.com>

-- 
Thanks,
Nan

