Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 111EC28AAE4
	for <linux-raid@vger.kernel.org>; Tue,  6 May 2025 01:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746496253; cv=none; b=aawrZD4yfD9sYtAD3jgAvR9ETtDx23gZNRNs9A8xqavmR62KapF8pbQYQHn0DqVfDWVCzMdR7OthytecIWqKNQ0NNrkBNQZvcsdoiGU6DF1F6D09qIwuG0MVp48CzIp4P9z70RYiZ7+uIyitFXfj3xLEbUQtJpwcWDrqahNlT7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746496253; c=relaxed/simple;
	bh=rdaRJTt4wTcrvzH8diKpzXwj+7gDUFqSLt5cJRZJmQY=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=O+L7NhO9Gu/JgDb59UhnnG3eVcXamWXqr0gO5S5MIjHjHbH6vRUsikYL9Pw0cMynuti6l8DMjeiAnok9MNze1vKgvBaDZwhRK+LI2bLWunnqPgH5oVYRWCA+wzALXGd+c/ErEZZmS2aX/AUCj1AJe+Rsg0Iaavbkeu32aV4bvzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4Zs1ZJ3NzfzYQtnt
	for <linux-raid@vger.kernel.org>; Tue,  6 May 2025 09:50:48 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D5C971A13EE
	for <linux-raid@vger.kernel.org>; Tue,  6 May 2025 09:50:47 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgB321_2ahloV2RBLg--.43438S3;
	Tue, 06 May 2025 09:50:47 +0800 (CST)
Subject: Re: [RFC PATCH] fix a reshape checking logic inside
 make_stripe_request()
To: Coly Li <colyli@kernel.org>, linux-raid@vger.kernel.org
Cc: Logan Gunthorpe <logang@deltatee.com>, Xiao Ni <xni@redhat.com>,
 Song Liu <song@kernel.org>, "yukuai (C)" <yukuai3@huawei.com>
References: <20250505152831.5418-1-colyli@kernel.org>
 <fgqrzhv5mbmrusocjkeybja6leaeeoi2r4hwihphi4lni2w3xg@meakhkiyuiab>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <ba1a64b6-db88-077b-2216-3b34d2cc55b3@huaweicloud.com>
Date: Tue, 6 May 2025 09:50:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <fgqrzhv5mbmrusocjkeybja6leaeeoi2r4hwihphi4lni2w3xg@meakhkiyuiab>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB321_2ahloV2RBLg--.43438S3
X-Coremail-Antispam: 1UD129KBjvJXoWxWF47Gr1ftFy3ZrW7Zr4ruFg_yoWrJF47pF
	WrtasFkFyDurn3Kw4qvF4jqFySkay5XrW3Jan8t34avrs0grs3JFW7Kry5ur1DJrWrK3yF
	q3WUZry7ua1j9a7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AF
	wI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1D
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUwx
	hLUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/05/05 23:47, Coly Li 写道:
> On Mon, May 05, 2025 at 11:28:31PM +0800, colyli@kernel.org wrote:
>> From: Coly Li <colyli@kernel.org>
>>
>> Commit f4aec6a09738 ("md/raid5: Factor out helper from
>> raid5_make_request() loop") added the following code block to check
> 
> After read historical commits, I realize the change was from
> commit 486f60558607 ("md/raid5: Check all disks in a stripe_head for
> reshape progress").
> 
>> whether the reshape range passed the stripe head range during thetime to
>> wait for a valid struct stripe_head object,
>>
>> 5971         if (unlikely(previous) &&
>> 5972             stripe_ahead_of_reshape(mddev, conf, sh)) {
>> 5973                 /*
>> 5974                  * Expansion moved on while waiting for a stripe.
>> 5975                  * Expansion could still move past after this
>> 5976                  * test, but as we are holding a reference to
>> 5977                  * 'sh', we know that if that happens,
>> 5978                  *  STRIPE_EXPANDING will get set and the expansion
>> 5979                  * won't proceed until we finish with the stripe.
>> 5980                  */
>> 5981                 ret = STRIPE_SCHEDULE_AND_RETRY;
>> 5982                 goto out_release;
>> 5983         }
>>
>> But from the code comments and context, the if statement should check
>> whether stripe_ahead_of_reshape() returns false, then the code logic can
>> match the context that reshape range went accross the sh range during
>> raid5_get_active_stripe().
> 
> And the code logic might be correct, because inside
> stripe_ahead_of_reshape(),
> 5788         if (!range_ahead_of_reshape(mddev, min_sector, max_sector,
> 5789                                      conf->reshape_progress))
> 5790                 /* mismatch, need to try again */
> 5791                 ret = true;
> 
> true is returned when the sh range is NOT ahead of reshape position.
> 
> Then the logic makes sense, but the function name stripe_ahead_of_reshape()
> is really misleading IMHO. Maybe it should be named something like
> stripe_behind_reshape()?
> 
> Should we change the name? Or I missed something important and still don't
> understand the code correctly?

The logic is correct. What I understand is that the *ahead of* means
reshape is not performed yet in this area, not that the location is
ahead of reshape position. And 'reshape_backwards' can make location
comparison different completely. Noted there is a local variable
'previous' with the same logical.

Instead of 'behind', I'll perfer another name to reflect this.


> 
>>
>> And unlikely(previous) seems useless inside the if statement, and the
>> unlikely() should include all checking statemetns.

And I think the unlikely is fine, this is called from IO path, and the
'previous' is unlikely to set.

Thanks,
Kuai

>>
> 
> This part still valid IMHO.
> 
> Thanks for comments.
> 
>> This patch has both of the above changes, hope it can make the code be
>> more comfortable.
>>
>> Fixes: f4aec6a09738 ("md/raid5: Factor out helper from raid5_make_request() loop")
>> Signed-off-by: Coly Li <colyli@kernel.org>
>> Cc: Logan Gunthorpe <logang@deltatee.com>
>> Cc: Yu Kuai <yukuai3@huawei.com>
>> Cc: Xiao Ni <xni@redhat.com>
>> Cc: Song Liu <song@kernel.org>
>> ---
>>   drivers/md/raid5.c | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index 39e7596e78c0..030e4672ab18 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -5969,8 +5969,7 @@ static enum stripe_result make_stripe_request(struct mddev *mddev,
>>   		return STRIPE_FAIL;
>>   	}
>>   
>> -	if (unlikely(previous) &&
>> -	    stripe_ahead_of_reshape(mddev, conf, sh)) {
>> +	if (unlikely(previous && !stripe_ahead_of_reshape(mddev, conf, sh))) {
>>   		/*
>>   		 * Expansion moved on while waiting for a stripe.
>>   		 * Expansion could still move past after this
>> -- 
>> 2.39.5
>>
> 

