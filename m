Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7413E45C0B;
	Mon,  1 Sep 2025 01:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756691833; cv=none; b=LgI+TqGgqEqmBfish4uKGeHVyeDY6CTN6OHk3vbD6zvukBQk9CHsjcxoyFl7b9DGt3Alc0CXwoNgh1CC5CwiYxGxFyUBvnj6M3+ekvuB6L3nEQK1rk+Mo89HrYnLt82mRrDfUUGDxjdgHO31Oti0OamrBwawdc8pzRPCrkk4o+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756691833; c=relaxed/simple;
	bh=Y8X6jHFzG6UhbanWGXTOgiUAkuoHfNZviYrea/HQCec=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CO+qcOXyNzaQkSzx/vXefibe9dedFA8EAjIcw3Ez8sTbSOAlFUtzI5DZ1cwMIbcOYL3Eh1ZE64ca3KUrrd99aB3cCr4Or/IqpyjEJqwdMgp1C1jpajooS/AH9S3fGGwOM/ckXqv6pn1HJgzQRgdNOIjKojlePsjYMCT4Keakph0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cFX780FrdzYQttW;
	Mon,  1 Sep 2025 09:57:08 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 891C11A12D9;
	Mon,  1 Sep 2025 09:57:06 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP4 (Coremail) with SMTP id gCh0CgCX4o5w_bRoAjztAw--.53901S3;
	Mon, 01 Sep 2025 09:57:06 +0800 (CST)
Message-ID: <0c6d1500-9ffd-5ce2-50f6-d8a908d7b21a@huaweicloud.com>
Date: Mon, 1 Sep 2025 09:57:04 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] md: prevent incoreect update of resync/recovery offset
To: Paul Menzel <pmenzel@molgen.mpg.de>, Li Nan <linan666@huaweicloud.com>
Cc: song@kernel.org, yukuai3@huawei.com, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yangerkun@huawei.com, yi.zhang@huawei.com
References: <20250830090242.4067003-1-linan666@huaweicloud.com>
 <2eadd8d3-7705-4000-982e-cafd222977c1@molgen.mpg.de>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <2eadd8d3-7705-4000-982e-cafd222977c1@molgen.mpg.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCX4o5w_bRoAjztAw--.53901S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Aw1DGw1DWw18ArWDXrWrZrb_yoW8CFy5pF
	WkJFyYyrWY9rWxAw17Zw4UZFyrZa4xt34DGryUGa4DZ3ZFkwnIqFW2qFsYgFyqgr4Fkryj
	q3s8JF95Za1rZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBj14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r
	4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v
	4I1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwI
	xGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
	Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7
	IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k2
	6cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxV
	AFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUvg4fUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/8/30 17:41, Paul Menzel 写道:
> Dear Nan,
> 
> 
> Thank you for your patch. I have some formal comments. In the 
> summary/title: incor*r*ect.
> 
Thanks for your review, I will fix typo in v2.

> Am 30.08.25 um 11:02 schrieb linan666@huaweicloud.com:
>> From: Li Nan <linan122@huawei.com>
>>
>> In md_do_sync(), when md_sync_action returns ACTION_FROZEN, subsequent
>> call to md_sync_position() will return MaxSector. This causes
>> 'curr_resync' (and later 'recovery_offset') to be set to MaxSector too,
>> which incorrectly signals that recovery/resync has completed even though
>> disk data has not actually been updated.
>>
>> To fix this issue, skip updating any offset values when the sync acion
> 
> ac*t*ion
> 
>> is either FROZEN or IDLE.
> 
> Maybe state that the same holds true for IDLE?
> 
> Should these two cases be handled differently in `md_sync_position()`. Does 
> it semantically make sense, that the default of MaxSector is returned?
> 

md_sync_position() return value decides whether sync_request is needed. The
loop uses 'while (j < max_sectors)', when J is MaxSector there’s nothing
to do. This seems reasonable.

>> Fixes: 7d9f107a4e94 ("md: use new helpers in md_do_sync()")
>> Signed-off-by: Li Nan <linan122@huawei.com>
>> ---
>>   drivers/md/md.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index e78f80d39271..6828a569e819 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -9397,6 +9397,9 @@ void md_do_sync(struct md_thread *thread)
>>       }
>>       action = md_sync_action(mddev);
>> +    if (action == ACTION_FROZEN || action == ACTION_IDLE)
>> +        goto skip;
>> +
>>       desc = md_sync_action_name(action);
>>       mddev->last_sync_action = action;
> 
> 
> Kind regards,
> 
> Paul
> 
> .

-- 
Thanks,
Nan

