Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B35419D8A8
	for <linux-raid@vger.kernel.org>; Mon,  8 Sep 2025 02:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757297544; cv=none; b=Qz9rRLcTYydnpqrOWV+zAyomvJ/DkY+9NWP2sCSPwQqbUMcNznpILhMWNdG+a2swnH50sCsTnHFhhNeSmpuUWHxo+njIj3gfyz+kqZsmgMppmPkv72FJ9B0/D6yOmwnkDHscmTah2StdGUqWBSYBQ4b1uYhleL5uIJeNqRWH45U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757297544; c=relaxed/simple;
	bh=XJtx+JzExxiwQNCzxJouFFcWyuO4t+pbJnedw/sB5sQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=d0PNZ/vIB8f5n1zZKCTBQ7puPXTIoMFfTAfUOLlomYeZ8sMPoGMm76tl7hph2AnCQ1+7OYYtZHs6PJrhZmBp0g++aKKjlGtBLorSL89LyTXOHpw5uajwkdIRaMrLOVvNPNM1pt7S8E5Ak9q+ZqYxuVRIsRzvUq1cNVahvAWG3nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4cKr3w6F4jz1R9Fq;
	Mon,  8 Sep 2025 10:09:16 +0800 (CST)
Received: from kwepemj500016.china.huawei.com (unknown [7.202.194.46])
	by mail.maildlp.com (Postfix) with ESMTPS id 5FB461401F4;
	Mon,  8 Sep 2025 10:12:18 +0800 (CST)
Received: from [10.174.187.148] (10.174.187.148) by
 kwepemj500016.china.huawei.com (7.202.194.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 8 Sep 2025 10:12:17 +0800
Message-ID: <ac880840-0b3c-141d-0f8e-8046e1bb29eb@huawei.com>
Date: Mon, 8 Sep 2025 10:12:17 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH] md: cleanup md_check_recovery()
To: Yu Kuai <yukuai1@huaweicloud.com>, <song@kernel.org>
CC: <linux-raid@vger.kernel.org>, <yangyun50@huawei.com>, "yukuai (C)"
	<yukuai3@huawei.com>
References: <b6af99f8-dc0c-89c7-cd97-688a5cec1560@huawei.com>
 <1cddf736-55ed-2bf0-6361-26a9648caeba@huaweicloud.com>
From: Wu Guanghao <wuguanghao3@huawei.com>
In-Reply-To: <1cddf736-55ed-2bf0-6361-26a9648caeba@huaweicloud.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemj500016.china.huawei.com (7.202.194.46)



在 2025/9/5 16:54, Yu Kuai 写道:
> Hi,
> 
> 在 2025/09/04 19:13, Wu Guanghao 写道:
>> In md_check_recovery(), use new helpers to make code cleaner.
>>
>> Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
>> ---
>>   drivers/md/md.c | 41 +++++++++++++++++++++++++++++------------
>>   1 file changed, 29 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 1baaf52c603c..cbbb9ac14cf6 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -9741,6 +9741,34 @@ static void unregister_sync_thread(struct mddev *mddev)
>>       md_reap_sync_thread(mddev);
>>   }
>>
>> +
>> +
>> +static bool md_should_do_recovery(struct mddev *mddev)
>> +{
>> +    /*
>> +     * As long as one of the following flags is set,
>> +     * recovery needs to do.
>> +     */
>> +    if (test_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
>> +        test_bit(MD_RECOVERY_DONE, &mddev->recovery))
>> +        return true;
>> +
>> +    /*
>> +     * If no flags are set and it is in read-only status,
>> +     * there is nothing to do.
>> +     */
>> +    if (!md_is_rdwr(mddev))
>> +        return false;
>> +
>> +    if ((mddev->sb_flags & ~ (1<<MD_SB_CHANGE_PENDING)) ||
>> +         (mddev->external == 0 && mddev->safemode == 1) ||
>> +         (mddev->safemode == 2 && !mddev->in_sync &&
>> +          mddev->resync_offset == MaxSector))
>> +        return true;
> 
> Plese also split abouve conditions and add comments.
> 
> Thanks,
> Kuai
> 

OK，I will make the changes in the next version.

Thanks,
Guanghao

>> +
>> +    return false;
>> +}
>> +
>>   /*
>>    * This routine is regularly called by all per-raid-array threads to
>>    * deal with generic issues like resync and super-block update.
>> @@ -9777,18 +9805,7 @@ void md_check_recovery(struct mddev *mddev)
>>           flush_signals(current);
>>       }
>>
>> -    if (!md_is_rdwr(mddev) &&
>> -        !test_bit(MD_RECOVERY_NEEDED, &mddev->recovery) &&
>> -        !test_bit(MD_RECOVERY_DONE, &mddev->recovery))
>> -        return;
>> -    if ( ! (
>> -        (mddev->sb_flags & ~ (1<<MD_SB_CHANGE_PENDING)) ||
>> -        test_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
>> -        test_bit(MD_RECOVERY_DONE, &mddev->recovery) ||
>> -        (mddev->external == 0 && mddev->safemode == 1) ||
>> -        (mddev->safemode == 2
>> -         && !mddev->in_sync && mddev->resync_offset == MaxSector)
>> -        ))
>> +    if (!md_should_do_recovery(mddev))
>>           return;
>>
>>       if (mddev_trylock(mddev)) {
>>
> 
> .
