Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33DE230D35
	for <linux-raid@vger.kernel.org>; Fri,  5 Sep 2025 08:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757062463; cv=none; b=TM7S4yAImGZhGBb5EeY+tMmlezAmNycPQV8T46WlzZvnY1L2Hlw0iKcmPhk+Y6Ubk2lC3+Z3F9a7CrWGmUtZfkYgtIFfL3RzBxcysAKUZBD8cCyiDNhDy3XzbkJ85Eak7P7LttMrejzvZXIKu7adFlqsn2INaiKRUD344MkTDvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757062463; c=relaxed/simple;
	bh=0gsWYznLUFkzNfw5yvL6UvCiK4ABRKO+6Q6TPi40HIQ=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=NvgD6skdFM3p3joQV136+lVTxuFIKO5ZcTwQs2aYnEEdL8bqpqPqBJ+H/LC3r9Ch1bh3QzGxeVvR90MMriuBCdTebbfSFuhwq/hm4AfhBA83ofSAzEd1leFo2V5Y1dFRkdzBmL6TzrlQvf6/AsVHGkKrNjccFv9eupT438ksqEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cJ9Bf69xCzYQvbQ
	for <linux-raid@vger.kernel.org>; Fri,  5 Sep 2025 16:54:18 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 5BDAA1A0F2A
	for <linux-raid@vger.kernel.org>; Fri,  5 Sep 2025 16:54:17 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgAncIw3pbpovUjYBQ--.25140S3;
	Fri, 05 Sep 2025 16:54:17 +0800 (CST)
Subject: Re: [PATCH] md: cleanup md_check_recovery()
To: Wu Guanghao <wuguanghao3@huawei.com>, song@kernel.org
Cc: linux-raid@vger.kernel.org, yangyun50@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <b6af99f8-dc0c-89c7-cd97-688a5cec1560@huawei.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <1cddf736-55ed-2bf0-6361-26a9648caeba@huaweicloud.com>
Date: Fri, 5 Sep 2025 16:54:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <b6af99f8-dc0c-89c7-cd97-688a5cec1560@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAncIw3pbpovUjYBQ--.25140S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Aw13GF4xtF1kKF45XrWxCrg_yoW8uFyDp3
	93tFnxCr18JFy3XF4fJ3WDua45Zr18trZFvFy3u34xJF9Yqr17G34rWr1UAFykt3929a1F
	qw1DJF4UCr1xWaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AF
	wI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1D
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8
	JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7IU8
	0fO7UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/09/04 19:13, Wu Guanghao 写道:
> In md_check_recovery(), use new helpers to make code cleaner.
> 
> Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
> ---
>   drivers/md/md.c | 41 +++++++++++++++++++++++++++++------------
>   1 file changed, 29 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 1baaf52c603c..cbbb9ac14cf6 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9741,6 +9741,34 @@ static void unregister_sync_thread(struct mddev *mddev)
>   	md_reap_sync_thread(mddev);
>   }
> 
> +
> +
> +static bool md_should_do_recovery(struct mddev *mddev)
> +{
> +	/*
> +	 * As long as one of the following flags is set,
> +	 * recovery needs to do.
> +	 */
> +	if (test_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
> +	    test_bit(MD_RECOVERY_DONE, &mddev->recovery))
> +		return true;
> +
> +	/*
> +	 * If no flags are set and it is in read-only status,
> +	 * there is nothing to do.
> +	 */
> +	if (!md_is_rdwr(mddev))
> +		return false;
> +
> +	if ((mddev->sb_flags & ~ (1<<MD_SB_CHANGE_PENDING)) ||
> +	     (mddev->external == 0 && mddev->safemode == 1) ||
> +	     (mddev->safemode == 2 && !mddev->in_sync &&
> +	      mddev->resync_offset == MaxSector))
> +		return true;

Plese also split abouve conditions and add comments.

Thanks,
Kuai

> +
> +	return false;
> +}
> +
>   /*
>    * This routine is regularly called by all per-raid-array threads to
>    * deal with generic issues like resync and super-block update.
> @@ -9777,18 +9805,7 @@ void md_check_recovery(struct mddev *mddev)
>   		flush_signals(current);
>   	}
> 
> -	if (!md_is_rdwr(mddev) &&
> -	    !test_bit(MD_RECOVERY_NEEDED, &mddev->recovery) &&
> -	    !test_bit(MD_RECOVERY_DONE, &mddev->recovery))
> -		return;
> -	if ( ! (
> -		(mddev->sb_flags & ~ (1<<MD_SB_CHANGE_PENDING)) ||
> -		test_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
> -		test_bit(MD_RECOVERY_DONE, &mddev->recovery) ||
> -		(mddev->external == 0 && mddev->safemode == 1) ||
> -		(mddev->safemode == 2
> -		 && !mddev->in_sync && mddev->resync_offset == MaxSector)
> -		))
> +	if (!md_should_do_recovery(mddev))
>   		return;
> 
>   	if (mddev_trylock(mddev)) {
> 

