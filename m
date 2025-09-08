Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B041DC985
	for <linux-raid@vger.kernel.org>; Mon,  8 Sep 2025 02:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757297404; cv=none; b=YpNAzCwUab5m4l5LHFL5JAtMZoC7ZNso2/6RvwytjyOUHEyvwNtJPi/kaq5ichx1H1awoyPGPF0s8nBF3YoQ/2xnfytWTBQhZwsvhVFyif2EUdA8FcImErKPObjaCj+QxlmCT9bZPgnFF8FaU7mR7A56OFV4ho+z7WNb1UiI2vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757297404; c=relaxed/simple;
	bh=A8i+3N40ihDRjAB6wu8HMY+rhjHu42mZt0doVhJVaVU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=SdSBzd8p9ZFwZOB+Zy/UyX81bzz/h4pk7tWNw9+NTGdomlFL5VAgziS59MOszIkD+eG91o4Ps2OXPP33Z61ibO0e3fxnzrdcIL3GdCzhiTZRFjxQmfib+H1e+kLJNMRFofcFqJqHngWtGjD4A1sjBR3K+JZI2puVq0JN+UguoE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cKqzG567mzRkCs;
	Mon,  8 Sep 2025 10:05:14 +0800 (CST)
Received: from kwepemj500016.china.huawei.com (unknown [7.202.194.46])
	by mail.maildlp.com (Postfix) with ESMTPS id 8C98214010D;
	Mon,  8 Sep 2025 10:09:51 +0800 (CST)
Received: from [10.174.187.148] (10.174.187.148) by
 kwepemj500016.china.huawei.com (7.202.194.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 8 Sep 2025 10:09:50 +0800
Message-ID: <9552d2ed-9fa3-191b-5121-c9743d844006@huawei.com>
Date: Mon, 8 Sep 2025 10:09:50 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH] md: cleanup md_check_recovery()
To: Paul Menzel <pmenzel@molgen.mpg.de>
CC: <song@kernel.org>, <yukuai3@huawei.com>, <linux-raid@vger.kernel.org>,
	<yangyun50@huawei.com>
References: <b6af99f8-dc0c-89c7-cd97-688a5cec1560@huawei.com>
 <423f39ec-beec-4537-8df6-4c02672a3d27@molgen.mpg.de>
From: Wu Guanghao <wuguanghao3@huawei.com>
In-Reply-To: <423f39ec-beec-4537-8df6-4c02672a3d27@molgen.mpg.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemj500016.china.huawei.com (7.202.194.46)


Thank you for your suggestion, I will modify it in the next version.

在 2025/9/4 20:08, Paul Menzel 写道:
> Dear Guanghao,
> 
> 
> Thank you for your patch. For the summary I suggest:
> 
> Factor out code into md_should_do_recovery()
> 
> Am 04.09.25 um 13:13 schrieb Wu Guanghao:
>> In md_check_recovery(), use new helpers to make code cleaner.
> 
> Singular *helper*?
> 
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
> 
> Why so many blank lines.
> 
>> +static bool md_should_do_recovery(struct mddev *mddev)
>> +{
>> +    /*
>> +     * As long as one of the following flags is set,
>> +     * recovery needs to do.
> 
> … recovery needs to be do*ne*?
> 
>> +     */
>> +    if (test_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
>> +        test_bit(MD_RECOVERY_DONE, &mddev->recovery))
>> +        return true;
>> +
>> +    /*
>> +     * If no flags are set and it is in read-only status,
>> +     * there is nothing to do.
> 
> Ditto.
> 
>> +     */
>> +    if (!md_is_rdwr(mddev))
>> +        return false;
>> +
>> +    if ((mddev->sb_flags & ~ (1<<MD_SB_CHANGE_PENDING)) ||
>> +         (mddev->external == 0 && mddev->safemode == 1) ||
>> +         (mddev->safemode == 2 && !mddev->in_sync &&
>> +          mddev->resync_offset == MaxSector))
>> +        return true;
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
> 
> The code diff looks good.
> 
> 
> Kind regards,
> 
> Paul
> .
