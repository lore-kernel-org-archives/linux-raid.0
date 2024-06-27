Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA2715358A
	for <linux-raid@vger.kernel.org>; Thu, 27 Jun 2024 12:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719490684; cv=none; b=kH896XA+47/M1R/Wv/GtIYOwmRlyxO0MxU7vxFinAYdB+KorQddg04o20n8uGVz7P+A30hzcpluWwZj90VinYwN+OXWWEzxEdc72RQdWIR13Swgbzx1ZngFDOl1XwFMVkGOVQ6Bqsz4T/TefRh2K2m9ZvPPh1dYNK7X3pO7aw5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719490684; c=relaxed/simple;
	bh=nqgDYqmZRID5jAI4wgWcnmHWVjreBuiIWRYogzauMmU=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=E/5j9uFnfQZhCzl6kCgr0cd1X+Km5Q6jBfImUjZiqUqCLCjUq8G3KCPCKX1tWUiuqyphY7lL0/vg371NHwMwOYLN5roOR/IEBjv6iiV2jl2zs0tjsHrysWywThnT/YadaDbfxjc7Gyk5UmfBdOVBXGey5LnFbwkBW8yWo5lYq+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4W8yJ56pjFz4f3jHv
	for <linux-raid@vger.kernel.org>; Thu, 27 Jun 2024 20:17:41 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id D02A81A058E
	for <linux-raid@vger.kernel.org>; Thu, 27 Jun 2024 20:17:52 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP2 (Coremail) with SMTP id Syh0CgBn0YZvWH1mRor3AQ--.22887S3;
	Thu, 27 Jun 2024 20:17:52 +0800 (CST)
Subject: Re: [PATCH] md/raid5: recheck if reshape has finished with
 device_lock held
To: Benjamin Marzinski <bmarzins@redhat.com>, Song Liu <song@kernel.org>
Cc: Heinz Mauelshagen <heinzm@redhat.com>, Xiao Ni <xni@redhat.com>,
 linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20240627053758.1438644-1-bmarzins@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <60e07bf5-dd1d-5eeb-d9a8-1488ab729798@huaweicloud.com>
Date: Thu, 27 Jun 2024 20:17:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240627053758.1438644-1-bmarzins@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBn0YZvWH1mRor3AQ--.22887S3
X-Coremail-Antispam: 1UD129KBjvJXoW7KrWfJF4DXr1kJr4UWr47XFb_yoW8Kw1Dpa
	y3tasxZr4kZr9xKrsrXr4qgFWru3ykK3yY9r4kXw1UC3Z8X3s3XrWUGr98XF4jqwnrJrZ0
	qFyYyr98Cryq9a7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUk0b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv
	6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUrR6zUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/06/27 13:37, Benjamin Marzinski Ð´µÀ:
> When handling an IO request, MD checks if a reshape is currently
> happening, and if so, where the IO sector is in relation to the reshape
> progress. MD uses conf->reshape_progress for both of these tasks.  When
> the reshape finishes, conf->reshape_progress is set to MaxSector.  If
> this occurs after MD checks if the reshape is currently happening but
> before it calls ahead_of_reshape(), then ahead_of_reshape() will end up
> comparing the IO sector against MaxSector. During a backwards reshape,
> this will make MD think the IO sector is in the area not yet reshaped,
> causing it to use the previous configuration, and map the IO to the
> sector where that data was before the reshape.
> 
> This bug can be triggered by running the lvm2
> lvconvert-raid-reshape-linear_to_raid6-single-type.sh test in a loop,
> although it's very hard to reproduce.
> 
> Fix this by rechecking if the reshape has finished after grabbing the
> device_lock.
> 
> Fixes: fef9c61fdfabf ("md/raid5: change reshape-progress measurement to cope with reshaping backwards.")
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>   drivers/md/raid5.c | 18 ++++++++++--------
>   1 file changed, 10 insertions(+), 8 deletions(-)
> 

Thanks for the patch, it looks correct. However, can you factor out a
helper and make the code more readable? The code is already quite
complicated.

Thanks,
Kuai

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 547fd15115cd..65d9b1ca815c 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -5923,15 +5923,17 @@ static enum stripe_result make_stripe_request(struct mddev *mddev,
>   		 * to check again.
>   		 */
>   		spin_lock_irq(&conf->device_lock);
> -		if (ahead_of_reshape(mddev, logical_sector,
> -				     conf->reshape_progress)) {
> -			previous = 1;
> -		} else {
> +		if (conf->reshape_progress != MaxSector) {
>   			if (ahead_of_reshape(mddev, logical_sector,
> -					     conf->reshape_safe)) {
> -				spin_unlock_irq(&conf->device_lock);
> -				ret = STRIPE_SCHEDULE_AND_RETRY;
> -				goto out;
> +					     conf->reshape_progress)) {
> +				previous = 1;
> +			} else {
> +				if (ahead_of_reshape(mddev, logical_sector,
> +						     conf->reshape_safe)) {
> +					spin_unlock_irq(&conf->device_lock);
> +					ret = STRIPE_SCHEDULE_AND_RETRY;
> +					goto out;
> +				}
>   			}
>   		}
>   		spin_unlock_irq(&conf->device_lock);
> 

