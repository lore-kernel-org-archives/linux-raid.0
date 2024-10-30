Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5746584A3E;
	Wed, 30 Oct 2024 01:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730251374; cv=none; b=ljevnGEUZA13dPthZSXeMw6FiVS9go+S7MZB/K3zJd3MG7XD4+pcVY4Y6u6RDAcL8JNZKK0k8Spdnj9hi22//8FGhJLvqtml70i5VzjNeCL7XSrp1OUaUxZmWVdIjGglKkdbWP6j4h1MhMwzxDyuOP4B1OwJ/m4FZZHg8hZ+QDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730251374; c=relaxed/simple;
	bh=97+S575orT/2QSEHr98c/w/6t/tQtnbAN57KRjPZzsA=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=iVugFzuD4pg7urPhLA3FD+zqZfmeNd06OhhNCA4+jdTEGbsirZEjrIT8BlqTcYHw+hERXsq2+2rUSNkVA3L+qWnaUjhWF1mioNEfsMfBWl9qSxZ7sX3t5UCZ7orBkJlC+5ypSXap3jAajL6QtikWf9UbQ1kB3Tdb0EEG2NFzO48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4XdTrX0qYwz4f3jqC;
	Wed, 30 Oct 2024 09:22:36 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id ABEE21A0196;
	Wed, 30 Oct 2024 09:22:48 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgCngYVmiiFnyxhOAQ--.6526S3;
	Wed, 30 Oct 2024 09:22:48 +0800 (CST)
Subject: Re: [PATCH v2 2/7] md: don't wait faulty rdev in
 md_wait_for_blocked_rdev()
To: Yu Kuai <yukuai1@huaweicloud.com>, song@kernel.org,
 mariusz.tkaczyk@intel.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20241011011630.2002803-1-yukuai1@huaweicloud.com>
 <20241011011630.2002803-3-yukuai1@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <7e069314-4f6d-d291-8650-a37e95268d9b@huaweicloud.com>
Date: Wed, 30 Oct 2024 09:22:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241011011630.2002803-3-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCngYVmiiFnyxhOAQ--.6526S3
X-Coremail-Antispam: 1UD129KBjvJXoW7KF48GFWxtFWrXrWUuw4kWFg_yoW8GFyDpa
	9Y9Fy5Gr48Cr1jg3W7XF12kFyFgw4UKrWxCry3A34UZa98Xr93KFsYy3s8Wr18CrZI9r45
	Xa15Ga9xZa45uF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
	Y487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
	1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
	b7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
	vE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
	cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa
	73UjIFyTuYvjfUYCJmUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/10/11 9:16, Yu Kuai Ð´µÀ:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> md_wait_for_blocked_rdev() is called for write IO while rdev is
> blocked, howerver, rdev can be faulty after choosing this rdev to write,
> and faulty rdev should never be accessed anymore, hence there is no point
> to wait for faulty rdev to be unblocked.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   drivers/md/md.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 179ee4afe937..37d1469bfc82 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9762,9 +9762,7 @@ EXPORT_SYMBOL(md_reap_sync_thread);
>   void md_wait_for_blocked_rdev(struct md_rdev *rdev, struct mddev *mddev)
>   {
>   	sysfs_notify_dirent_safe(rdev->sysfs_state);
> -	wait_event_timeout(rdev->blocked_wait,
> -			   !test_bit(Blocked, &rdev->flags) &&
> -			   !test_bit(BlockedBadBlocks, &rdev->flags),
> +	wait_event_timeout(rdev->blocked_wait, rdev_blocked(rdev),

Just found that there is a stupid mistake that I should use:

!rdev_blocked(rdev)

Tests can't find this mistake because wait_event_timeout() is used,
and caller will break out if rdev is unblocked.

Song, since this is still is md-6.13. Do you want to to send a fix, or
update this version?

Thanks,
Kuai

>   			   msecs_to_jiffies(5000));
>   	rdev_dec_pending(rdev, mddev);
>   }
> 

