Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C54D25E808;
	Tue, 10 Jun 2025 02:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749523963; cv=none; b=FJWlDMSp+YBKRnnfqjlEQO8QooegMyKZF32XMNyiTfHnGfOK/d4KSZyfu1MygCXVbJOYRTq0k7Oyq7jAa3WUPr7j8QrZKQhiMxTMZeSeY371DDLIjmvvdTtiG8UT0fqPMzSEQB4/pm2/B2PC5TMPUU9MMsYq+vp1XGFRnO0LgD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749523963; c=relaxed/simple;
	bh=Z4mmxF/jE4VO/furS3Me5Wwx4ibSFXukv8/TCT8hbcU=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=OUprlOMPxbyCUjLcFdTMPWiwH0z3D00rE+YFqKW+nLG+/Xf6k//qChKPwEL5bNygbEORR7boELoUn69dldiZrkLS7Id+nrZzzp0Hu3CiHLuiwHDFmcWl45ZMAOLEoTX7PoXmxeqx83j00tKpwCpzI1kRiA1BnXY8KncF8y5PLI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bGYHQ0RgdzKHMlP;
	Tue, 10 Jun 2025 10:52:34 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 6997C1A1545;
	Tue, 10 Jun 2025 10:52:32 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgCnCl_unUdo55oyPA--.42301S3;
	Tue, 10 Jun 2025 10:52:32 +0800 (CST)
Subject: Re: [PATCH] md/raid1: Fix use-after-free in reshape pool wait queue
To: Wang Jinchao <wangjinchao600@gmail.com>, Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250609120155.204802-1-wangjinchao600@gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <698d1e9a-2fc0-fa6b-2f4c-55c5129cdf28@huaweicloud.com>
Date: Tue, 10 Jun 2025 10:52:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250609120155.204802-1-wangjinchao600@gmail.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnCl_unUdo55oyPA--.42301S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Cr4rAF4rZr4fWF1ftFyrJFb_yoW8Xry3pw
	4aqas8CF4UZaySqryUArW7WFy5uwn8WFWUKrZ7Kw12qF9agFyxXrW0yFy5GryvyFsxCa48
	X3Z5JrZxCF1DtFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AF
	wI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1D
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU7I
	JmUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/06/09 20:01, Wang Jinchao Ð´µÀ:
> During raid1 reshape operations, a use-after-free can occur in the mempool
> wait queue when r1bio_pool->curr_nr drops below min_nr. This happens
> because:

Can you attach have the uaf log?
> 
> 1. mempool_init() initializes wait queue head on stack
> 2. The stack-allocated wait queue is copied to conf->r1bio_pool through
>     structure assignment
> 3. wake_up() on this invalid wait queue causes panic when accessing the
>     stack memory that no longer exists

The list_head inside wait_queue_head?

> 
> Fix this by properly reinitializing the mempool's wait queue using
> init_waitqueue_head(), ensuring the wait queue structure remains valid
> throughout the reshape operation.
> 
> Signed-off-by: Wang Jinchao <wangjinchao600@gmail.com>
> ---
>   drivers/md/raid1.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 19c5a0ce5a40..fd4ce2a4136f 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -3428,6 +3428,7 @@ static int raid1_reshape(struct mddev *mddev)
>   	/* ok, everything is stopped */
>   	oldpool = conf->r1bio_pool;
>   	conf->r1bio_pool = newpool;
> +	init_waitqueue_head(&conf->r1bio_pool.wait);

I think the real problem here is the above assignment,it's better to
fix that instead of reinitializing the list.

Thanks,
Kuai

>   
>   	for (d = d2 = 0; d < conf->raid_disks; d++) {
>   		struct md_rdev *rdev = conf->mirrors[d].rdev;
> 

