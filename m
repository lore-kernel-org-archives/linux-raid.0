Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D54D1B7F4
	for <linux-raid@vger.kernel.org>; Tue,  4 Nov 2025 06:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762238179; cv=none; b=CtzJtjS+THkhjg/lpKhzoSF75WkWROOO5fLPV1J2Jhhkvi6L3Z13BbJf+NYbnWaLz0i0eptaXqTtqBDqo6Dd9E/ypUT8tgYpp1m8DZoiKL4Scl5bW6hXeLoi+yk2xi3EwgYpWTvJvqsoSN9i+2JoRCSpLYg59KxeglZh4sL800g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762238179; c=relaxed/simple;
	bh=AgCBNUOvklcduzNxQwnGHyKR1ky9WsqrRpXQFImbqvo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hkhNfPvZVOs3U9EJUDZurIyzErHWwmsGkeQ6QNRr0pEN7UzF1qeavRrCaqD43ZfGxrGGTBR3BZqkMaNrm6XZkkYSk5Ycv1WodGiyidRJndrejCBSJMoHRfef+rb19h58jahLpU/PujliqxLQeQQ3pekHey49llCiO1OvJnCF+WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4d0zHN6ZwczKHMbN
	for <linux-raid@vger.kernel.org>; Tue,  4 Nov 2025 14:36:00 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 574D11A1A6F
	for <linux-raid@vger.kernel.org>; Tue,  4 Nov 2025 14:36:06 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP2 (Coremail) with SMTP id Syh0CgBXrUXUnglpc+KeCg--.54799S3;
	Tue, 04 Nov 2025 14:36:06 +0800 (CST)
Message-ID: <7808c1c0-d7a3-8d5f-43f8-42b0147e6a32@huaweicloud.com>
Date: Tue, 4 Nov 2025 14:36:04 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH V2 1/1] md: avoid repeated calls to del_gendisk
To: Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org
Cc: yukuai@fnnas.com, song@kernel.org
References: <20251029063419.21700-1-xni@redhat.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20251029063419.21700-1-xni@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBXrUXUnglpc+KeCg--.54799S3
X-Coremail-Antispam: 1UD129KBjvJXoW7KrW3uryxKr4xKr1DGw4Uurg_yoW8tr13pr
	WfGFyYkr47Ja4UZFsrtw18uFy5Zwn2kFW0kFy3C3s5u3WFqr17WFy2ka9FqryDWry3ZF4I
	qF1Fvw48Xa48taUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487
	Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aV
	AFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xF
	o4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1D
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUzW
	lkUUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/10/29 14:34, Xiao Ni 写道:
> There is a uaf problem which is found by case 23rdev-lifetime:
> 
> Oops: general protection fault, probably for non-canonical address 0xdead000000000122
> RIP: 0010:bdi_unregister+0x4b/0x170
> Call Trace:
>   <TASK>
>   __del_gendisk+0x356/0x3e0
>   mddev_unlock+0x351/0x360
>   rdev_attr_store+0x217/0x280
>   kernfs_fop_write_iter+0x14a/0x210
>   vfs_write+0x29e/0x550
>   ksys_write+0x74/0xf0
>   do_syscall_64+0xbb/0x380
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7ff5250a177e
> 
> The sequence is:
> 1. rdev remove path gets reconfig_mutex
> 2. rdev remove path release reconfig_mutex in mddev_unlock
> 3. md stop calls do_md_stop and sets MD_DELETED
> 4. rdev remove path calls del_gendisk because MD_DELETED is set
> 5. md stop path release reconfig_mutex and calls del_gendisk again
> 
> So there is a race condition we should resolve. This patch adds a
> flag MD_DO_DELETE to avoid the race condition.
> 
> Fixes: 9e59d609763f ("md: call del_gendisk in control path")
> Signed-off-by: Xiao Ni <xni@redhat.com>
> Suggested-by: Yu Kuai <yukuai@fnnas.com>
> ---
> v2: fix building error found by lkp@interl.com
>   drivers/md/md.c | 3 ++-
>   drivers/md/md.h | 1 +
>   2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 41c476b40c7a..8e0554ab757c 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -941,7 +941,8 @@ void mddev_unlock(struct mddev *mddev)
>   		 * do_md_stop. dm raid only uses md_stop to stop. So dm raid
>   		 * doesn't need to check MD_DELETED when getting reconfig lock
>   		 */
> -		if (test_bit(MD_DELETED, &mddev->flags))
> +		if (test_bit(MD_DELETED, &mddev->flags) &&
> +			!test_and_set_bit(MD_DO_DELETE, &mddev->flags))
>   			del_gendisk(mddev->gendisk);
>   	}
>   }
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 1979c2d4fe89..7f2875bf974b 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -354,6 +354,7 @@ enum mddev_flags {
>   	MD_HAS_MULTIPLE_PPLS,
>   	MD_NOT_READY,
>   	MD_BROKEN,
> +	MD_DO_DELETE,
>   	MD_DELETED,
>   };
>   

LGTM

Reviewed-by: Li Nan <linan122@huawei.com>
-- 
Thanks,
Nan

