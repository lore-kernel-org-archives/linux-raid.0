Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD5E33D5
	for <linux-raid@vger.kernel.org>; Thu, 18 Jan 2024 01:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705542684; cv=none; b=E0MY7pwWBD/JA4Nz4UtuCidj9wQgGfL6U/mRNctLgsulNqW6jTZV+l5Ix+d0l/2QiI40N5KKCsQnBI9BIMHsX6tIiX775TmnhZTNFjOEGPP3oRz2VS34EzhaN8/SiAycwhGBECbuwpXsIwttRjTTiOFAfAk8GTUkWkQTwj4vFE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705542684; c=relaxed/simple;
	bh=qbj1SFJqRNgEbj+zKrEavXJrGKFgd4Lau9kD0laQI5o=;
	h=Received:Received:Received:Subject:To:Cc:References:From:
	 Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo; b=Fa/FYNbiaALjZ0drASKilD6rAQu15n23eULNeVT2Cc0MFxumgcykaAcHgUbf6ciajkUB1e6yuN9UA+lkrpOGd6sJCZ7KijbzHkIVTWzZ3QfSMu04k9oKl7PNIR2xQZ8unhFbsYYDU/IdhSAvhQUP1xLUmufO/Er90yCyD97Kp1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4TFm1c3NBbz4f3jZR
	for <linux-raid@vger.kernel.org>; Thu, 18 Jan 2024 09:51:16 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id A1C541A08D9
	for <linux-raid@vger.kernel.org>; Thu, 18 Jan 2024 09:51:18 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgBnOBEUhKhlXIytBA--.8140S3;
	Thu, 18 Jan 2024 09:51:18 +0800 (CST)
Subject: Re: [PATCH 5/7] md: fix deadlock in
 shell/lvconvert-raid-reshape-linear_to_raid6-single-type.sh
To: Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
 David Jeffery <djeffery@redhat.com>, Li Nan <linan122@huawei.com>
Cc: dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
 Mike Snitzer <msnitzer@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>, "yukuai (C)" <yukuai3@huawei.com>
References: <e5e8afe2-e9a8-49a2-5ab0-958d4065c55e@redhat.com>
 <ece2b06f-d647-6613-a534-ff4c9bec1142@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <9ad9afa1-3fb1-b9f8-524b-15bec744b787@huaweicloud.com>
Date: Thu, 18 Jan 2024 09:51:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <ece2b06f-d647-6613-a534-ff4c9bec1142@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBnOBEUhKhlXIytBA--.8140S3
X-Coremail-Antispam: 1UD129KBjvJXoWxXF1kAF1fJr4DAFyfuF1ftFb_yoW5Zw4Dpa
	ykCF9ayr4rAry7ZrZFka4UXry5Cr40q39xCrZ3G348A3Z8K3W5AFyjkFyUGF1DC34vva10
	q3Z8XFsxZw4UK3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvab4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7Mxk0xIA0c2IE
	e2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxV
	Aqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q
	6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6x
	kF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv
	67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyT
	uYvjxUOyCJDUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/01/18 2:21, Mikulas Patocka Ð´µÀ:
> This commit fixes a deadlock in the LVM2 test
> shell/lvconvert-raid-reshape-linear_to_raid6-single-type.sh
> 
> When MD_RECOVERY_WAIT is set or when md_is_rdwr(mddev) is true, the
> function md_do_sync would not set MD_RECOVERY_DONE. Thus, stop_sync_thread
> would wait for the flag MD_RECOVERY_DONE indefinitely.
> 
> Also, md_wakeup_thread_directly does nothing if the thread is waiting in
> md_thread on thread->wqueue (it wakes the thread up, the thread would
> check THREAD_WAKEUP and go to sleep again without doing anything). So,
> this commit introduces a call to md_wakeup_thread from
> md_wakeup_thread_directly.
> 
> task:lvm             state:D stack:0     pid:46322 tgid:46322 ppid:46079  flags:0x00004002
> Call Trace:
>   <TASK>
>   __schedule+0x228/0x570
>   schedule+0x29/0xa0
>   schedule_timeout+0x6a/0xd0
>   ? timer_shutdown_sync+0x10/0x10
>   stop_sync_thread+0x197/0x1c0 [md_mod]
>   ? housekeeping_test_cpu+0x30/0x30
>   ? table_deps+0x1b0/0x1b0 [dm_mod]
>   __md_stop_writes+0x10/0xd0 [md_mod]
>   md_stop_writes+0x18/0x30 [md_mod]
>   raid_postsuspend+0x32/0x40 [dm_raid]
>   dm_table_postsuspend_targets+0x34/0x50 [dm_mod]
>   dm_suspend+0xc4/0xd0 [dm_mod]
>   dev_suspend+0x186/0x2d0 [dm_mod]
>   ? table_deps+0x1b0/0x1b0 [dm_mod]
>   ctl_ioctl+0x2e1/0x570 [dm_mod]
>   dm_ctl_ioctl+0x5/0x10 [dm_mod]
>   __x64_sys_ioctl+0x85/0xa0
>   do_syscall_64+0x5d/0x1a0
>   entry_SYSCALL_64_after_hwframe+0x46/0x4e
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Fixes: f52f5c71f3d4 ("md: fix stopping sync thread")
> Cc: stable@vger.kernel.org	# v6.7
> 
> ---
>   drivers/md/md.c    |    8 +++++++-
>   drivers/md/raid5.c |    4 ++++
>   2 files changed, 11 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/drivers/md/md.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/md.c
> +++ linux-2.6/drivers/md/md.c
> @@ -8029,6 +8029,8 @@ static void md_wakeup_thread_directly(st
>   	if (t)
>   		wake_up_process(t->tsk);
>   	rcu_read_unlock();
> +
> +	md_wakeup_thread(thread);

This is not correct. I already explained(already in comments) what
md_wakeup_thread_directly() is supposed to do.
>   }
>   
>   void md_wakeup_thread(struct md_thread __rcu *thread)
> @@ -8777,10 +8779,14 @@ void md_do_sync(struct md_thread *thread
>   
>   	/* just incase thread restarts... */
>   	if (test_bit(MD_RECOVERY_DONE, &mddev->recovery) ||
> -	    test_bit(MD_RECOVERY_WAIT, &mddev->recovery))
> +	    test_bit(MD_RECOVERY_WAIT, &mddev->recovery)) {
> +		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
> +			set_bit(MD_RECOVERY_DONE, &mddev->recovery);

If you set MD_RECOVERY_DONE here, sync_thread will be unregistered, I
don't think this is the expected behaviour. Only dm-raid is using this
flag, and rs_start_reshape() already explains that it wants
sync_thread to work later until the table gets reloaded.

>   		return;
> +	}
>   	if (!md_is_rdwr(mddev)) {/* never try to sync a read-only array */
>   		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> +		set_bit(MD_RECOVERY_DONE, &mddev->recovery);

This change looks reasonable.

Thanks,
Kuai

>   		return;
>   	}
>   
> 
> .
> 

