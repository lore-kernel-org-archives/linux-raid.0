Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D322840DFDA;
	Fri, 17 Apr 2026 01:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776389401; cv=none; b=KeotKhtolq4c1ALz8wBSFllHCaSZlc6adpDmCNzD9by4isSxzriEj51THXz0pFoFXflEPvYoTZZM8z1tBEK74VYEo4StfGQMJKUH/Q78hPr2pZyJpIqF0gxeC5QSCAfKKRmXM0t1hlLIQ81MhrfCiG65z73WXtpw3cn4t2kZG54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776389401; c=relaxed/simple;
	bh=7DDnK40lsVYp0zZcUJqYdUlRWqM/j5OColKckGP7JJ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C7RZpsmKiN+XVA8WicvjW7fgEuhQ/YST1z7Fo7lcNGVrsE5xGe+VNwvJk7iI/qGKYUrx6Dzc69b5dfB2oCGUpmXa+C2sfylBw9gTc9zRqEMxeTHKj1BIKcZ8fOijXqSr10ZrfCI2pSkmvVdCgF8VeQ7sfXvnbIfn/XuLdOADVKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fxckG2CVnzKHMKZ;
	Fri, 17 Apr 2026 09:29:42 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 67B374058D;
	Fri, 17 Apr 2026 09:29:54 +0800 (CST)
Received: from [10.174.178.255] (unknown [10.174.178.255])
	by APP3 (Coremail) with SMTP id _Ch0CgBXUbsOjeFp5rC2Ag--.599S3;
	Fri, 17 Apr 2026 09:29:52 +0800 (CST)
Message-ID: <09197b23-6bd4-3e1f-4196-d1afacf46a56@huaweicloud.com>
Date: Fri, 17 Apr 2026 09:29:50 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2] md: use md_free_cloned_bio() in md_end_clone_io()
To: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
 Li Nan <linan666@huaweicloud.com>, song@kernel.org, yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260415081941.352389-1-abd.masalkhi@gmail.com>
 <7f82e3ae-bb2b-96fc-af9c-632fa6ae07af@huaweicloud.com>
 <m27bq72w2q.fsf@gmail.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <m27bq72w2q.fsf@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgBXUbsOjeFp5rC2Ag--.599S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJF4kGr47Zr1UXr43Jw47urg_yoW5Xw1kpa
	97GFWYkrs5XF18Cay2q3Wj9F1Fvw4DtFW29Fy8J345ZFyqyr9YyF4xW3ZYqF15urW7GryI
	q3W8WF17WF1jqFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9E14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r
	4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v
	4I1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwI
	xGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
	Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7
	IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k2
	6cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxV
	AFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUbsYFJUUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2026/4/16 15:39, Abd-Alrhman Masalkhi 写道:
> Hi Nan,
> 
> thank you for the feedback.
> 
> On Thu, Apr 16, 2026 at 14:47 +0800, Li Nan wrote:
>> 在 2026/4/15 16:19, Abd-Alrhman Masalkhi 写道:
>>> md_end_clone_io() and md_free_cloned_bio() share identical teardown
>>> logic. Use md_free_cloned_bio() in md_end_clone_io() for cleanup and
>>> call bio_endio() afterwards.
>>>
>>> Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
>>> ---
>>> Changes in v2:
>>>    - Reuse md_free_cloned_bio() instead of introducing a new helper
>>>    - Link to v1: https://lore.kernel.org/linux-raid/20260414103813.307601-1-abd.masalkhi@gmail.com
>>> ---
>>>    drivers/md/md.c | 13 +------------
>>>    1 file changed, 1 insertion(+), 12 deletions(-)
>>>
>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>> index ac71640ff3a8..8565566a447b 100644
>>> --- a/drivers/md/md.c
>>> +++ b/drivers/md/md.c
>>> @@ -9212,20 +9212,9 @@ static void md_end_clone_io(struct bio *bio)
>>>    {
>>>    	struct md_io_clone *md_io_clone = bio->bi_private;
>>>    	struct bio *orig_bio = md_io_clone->orig_bio;
>>> -	struct mddev *mddev = md_io_clone->mddev;
>>> -
>>> -	if (bio_data_dir(orig_bio) == WRITE && md_bitmap_enabled(mddev, false))
>>> -		md_bitmap_end(mddev, md_io_clone);
>>> -
>>> -	if (bio->bi_status && !orig_bio->bi_status)
>>> -		orig_bio->bi_status = bio->bi_status;
>>> -
>>> -	if (md_io_clone->start_time)
>>> -		bio_end_io_acct(orig_bio, md_io_clone->start_time);
>>>    
>>> -	bio_put(bio);
>>> +	md_free_cloned_bio(bio);
>>>    	bio_endio(orig_bio);
>>
>> Is it safe to end orig_bio after putting active_io?
> 
> As I understand it, active_io is primarily used to account for
> in-flight bios, allowing the array to be safely suspended once no
> bios are outstanding.
> 
> I have made a diagram, while i am reviewing the md driver:
> 
> mddev->active_io
> 
> md driver:
> md_handle_request()
>      mddev->active_io +1
> 	    pers->make_request()
>              md_account_bio() +1
> 			    if (err)
> 				    md_free_cloned_bio -1
>      mddev->active_io -1
> 
> lower driver:
> bio_endio()
>      md_end_clone_io -1
> 
> As shown, it incremented in two places, the first is before passing
> orig_bio to pers->make_request(), and decremented after it returns
> (regardless of what make_request() does with it). and the second
> is when cloning the original bio, and it should be decremented after
> the cloned bio is released.
> 
> In this context, it should not matter whether bio_endio(orig_bio) is
> called before or after decrementing active_io, as long as the cloned
> bio teardown is completed correctly.
> 
> Am I missing anything that would make this unsafe?
> 

Thanks for your reply, LGTM.

Reviewed-by: Li Nan <linan122@huawei.com>

-- 
Thanks,
Nan

