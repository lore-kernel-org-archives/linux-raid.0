Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DFA61F948;
	Mon,  1 Sep 2025 01:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756690017; cv=none; b=Bu5XIvnXK8lTkKaaf671MhzutPB/RQPm381k05ljZFC845FYwrUzpFiCVdOUhsd4zazTie5tozZMyy9Zh33Q0GliDOZc0hgzpoJ/A9sXVHtLM1eZO3hg4k/IhqYNsZ6iQ68lG6Zr4efkuAbHnGAbWRf9M/zs68UAd3NKZEdzoX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756690017; c=relaxed/simple;
	bh=tl1vAbw5X6OPmjaq0O548MOD/EZm8fWJ9iTxsp2Vtfk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YOFPrSkXLKWhq74Sgoxtec3ZtUEWhN8tT3/sgsgiI3mMOcv3A+/f9TuTDYbZnob+bhzCCQNyZXQ/NgQcsRyOkVjXIl6UkYrYNDSGWQAn2/vhKD1MNXM9k027rFjNGB8VeRlardUMh98Geoy+dCb/Sc3+ea0VxmiFpGX7nyUKZzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cFWS55DtpzKHMXM;
	Mon,  1 Sep 2025 09:26:45 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 88F171A0D5D;
	Mon,  1 Sep 2025 09:26:45 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP4 (Coremail) with SMTP id gCh0CgAXYIxT9rRopczqAw--.36104S3;
	Mon, 01 Sep 2025 09:26:45 +0800 (CST)
Message-ID: <40fa8f33-22d8-b0f1-7d78-8961bee5b1f3@huaweicloud.com>
Date: Mon, 1 Sep 2025 09:26:43 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] md: prevent incoreect update of resync/recovery offset
To: Yu Kuai <hailan@yukuai.org.cn>, Paul Menzel <pmenzel@molgen.mpg.de>,
 Li Nan <linan666@huaweicloud.com>
Cc: song@kernel.org, yukuai3@huawei.com, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yangerkun@huawei.com, yi.zhang@huawei.com
References: <20250830090242.4067003-1-linan666@huaweicloud.com>
 <2eadd8d3-7705-4000-982e-cafd222977c1@molgen.mpg.de>
 <969460f8-9ed2-4535-8336-4a7c359f5708@yukuai.org.cn>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <969460f8-9ed2-4535-8336-4a7c359f5708@yukuai.org.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXYIxT9rRopczqAw--.36104S3
X-Coremail-Antispam: 1UD129KBjvJXoW7uFW3ZrW7XryrJr13Wr1xXwb_yoW8ur4fpF
	WkCF1YkrW5Wr4fAw42vw1UAFyFy34xt34DWr1UGa4DZwnFk3sFqFW2qFnY9FykXr4rGF1j
	q3s8tFZ3Za1rZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9E14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r
	4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v
	4I1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwI
	xGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
	Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7
	IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k2
	6cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxV
	AFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUbQVy7UUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/8/30 19:04, Yu Kuai 写道:
> Hi,
> 
> 在 2025/8/30 17:41, Paul Menzel 写道:
>> Dear Nan,
>>
>>
>> Thank you for your patch. I have some formal comments. In the 
>> summary/title: incor*r*ect.
>>
>> Am 30.08.25 um 11:02 schrieb linan666@huaweicloud.com:
>>> From: Li Nan <linan122@huawei.com>
>>>
>>> In md_do_sync(), when md_sync_action returns ACTION_FROZEN, subsequent
>>> call to md_sync_position() will return MaxSector. This causes
>>> 'curr_resync' (and later 'recovery_offset') to be set to MaxSector too,
>>> which incorrectly signals that recovery/resync has completed even though
>>> disk data has not actually been updated.
>>>
>>> To fix this issue, skip updating any offset values when the sync acion
>>
>> ac*t*ion
>>
>>> is either FROZEN or IDLE.
>>
>> Maybe state that the same holds true for IDLE?
>>
>> Should these two cases be handled differently in `md_sync_position()`. 
>> Does it semantically make sense, that the default of MaxSector is returned?
>>
> Max sectors will return, however, following procedures will update
> resync_offset to MaxSector, while recovery can be interuppted by the
> concurrent frozen, can this will cause data lost.
> 
>>> Fixes: 7d9f107a4e94 ("md: use new helpers in md_do_sync()")
>>> Signed-off-by: Li Nan <linan122@huawei.com>
>>> ---
>>>   drivers/md/md.c | 3 +++
>>>   1 file changed, 3 insertions(+)
>>>
>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>> index e78f80d39271..6828a569e819 100644
>>> --- a/drivers/md/md.c
>>> +++ b/drivers/md/md.c
>>> @@ -9397,6 +9397,9 @@ void md_do_sync(struct md_thread *thread)
>>>       }
>>>         action = md_sync_action(mddev);
>>> +    if (action == ACTION_FROZEN || action == ACTION_IDLE)
>>> +        goto skip;
>>> +
>>>       desc = md_sync_action_name(action);
>>>       mddev->last_sync_action = action;
>>
> Please send a new verison with the typo fixed.
> 
> Thanks,
> Kuai
> 

Sorry for my carelessness. I will send v2 later.

-- 
Thanks,
Nan

>>
>> Kind regards,
>>
>> Paul
>>
> 
> .

