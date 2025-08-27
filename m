Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D2C1E51EF
	for <linux-raid@vger.kernel.org>; Wed, 27 Aug 2025 17:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756316236; cv=none; b=PgRCRHjnTjGjlLhCqbhbnZ4r8yI0ANtepSN2roNRgoVzKwCF2eotFT0UZs5yGHoFt3cieFM1ep1EExmTuO5ZWVxKUZhiQOkQw7NQhYdU7qTkrtAX7GaM04mZZoUnpOFXIP1FkBosZJX+5P0oEwhWxL80l8YwPoWHcaNW3NasLVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756316236; c=relaxed/simple;
	bh=Yu0b2ioIhJNlFKOfwSCvH6iHtswZKayF/t92VtWSv/c=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=gBsZLTBfT6e05x2yJdb9GYpzfZg/AYrjYojHEasztOvifEJbwja2+cEFc/40oZDhxE6+6dRiaJgT4GkYEME5GKfBt3EEhg8oct2NJVArHYmiOzmVIqbWyAMvBYfdLdnoYFoZOwN5bn2ERFHc7DezaV1K/mYXA9TXop9u1dq01kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=mgml.me; dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b=QYHrM9qM; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b="QYHrM9qM"
Received: from NEET (p4219063-ipxg00p01tokaisakaetozai.aichi.ocn.ne.jp [118.15.52.63])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 57RHVWOS015699
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Thu, 28 Aug 2025 02:31:33 +0900 (JST)
	(envelope-from k@mgml.me)
DKIM-Signature: a=rsa-sha256; bh=aXjQSaRY512ZtJAnWWhKa1Tjp7Chw7Itug6zcIc4KWs=;
        c=relaxed/relaxed; d=mgml.me;
        h=Message-ID:Date:Subject:To:From;
        s=rs20250315; t=1756315893; v=1;
        b=QYHrM9qMQXTBvPYTqp+V5UP24O0XuLIuel7Um8k5+iArWfg2pvNbcNFZzCGS7G7T
         0+K7h9l0Uqgg7KjLQS2L+55k85cs2R00NbNmg7aij4S4OB7rstgCHb3C10Xtzwja
         wFxG1FTIXraK59MyX4b3UVejPyTY+ejiY2wNg0qW8/AUUHdmLh32PMrARKpde+dZ
         JNZAueOlmPkc4CUMLwy8+p0CFdGDbOcy4bcGsioWWgf5PAEq6LpothqjucHVTj5N
         xeD4/2mxO85GEv6gzv8nnst5XFi/xU+FfQPxkOsRmm5UjH02TVD/vCL8lyW42tkM
         5txUlLAlt0aTbpbUKSNoMA==
Message-ID: <66c06ec5-fa22-4020-b5f3-0545c0aaa69a@mgml.me>
Date: Thu, 28 Aug 2025 02:31:32 +0900
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kenta Akagi <k@mgml.me>
Subject: Re: [PATCH v2 1/3] md/raid1,raid10: don't broken array on failfast
 metadata write fails
To: Li Nan <linan666@huaweicloud.com>, Song Liu <song@kernel.org>,
        Yu Kuai <yukuai3@huawei.com>, Mariusz Tkaczyk <mtkaczyk@kernel.org>,
        Guoqing Jiang <jgq516@gmail.com>
References: <20250817172710.4892-1-k@mgml.me>
 <20250817172710.4892-2-k@mgml.me>
 <725043ad-2d50-be78-7cc3-8c565ab364e0@huaweicloud.com>
Content-Language: en-US
From: Kenta Akagi <k@mgml.me>
In-Reply-To: <725043ad-2d50-be78-7cc3-8c565ab364e0@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2025/08/23 10:54, Li Nan wrote:
> 
> 
> 在 2025/8/18 1:27, Kenta Akagi 写道:
>> A super_write IO failure with MD_FAILFAST must not cause the array
>> to fail.
>>
>> Because a failfast bio may fail even when the rdev is not broken,
>> so IO must be retried rather than failing the array when a metadata
>> write with MD_FAILFAST fails on the last rdev.
>>
>> A metadata write with MD_FAILFAST is retried after failure as
>> follows:
>>
>> 1. In super_written, MD_SB_NEED_REWRITE is set in sb_flags.
>>
>> 2. In md_super_wait, which is called by the function that
>> executed md_super_write and waits for completion,
>> -EAGAIN is returned because MD_SB_NEED_REWRITE is set.
>>
>> 3. The caller of md_super_wait (such as md_update_sb)
>> receives a negative return value and then retries md_super_write.
>>
>> 4. The md_super_write function, which is called to perform
>> the same metadata write, issues a write bio without MD_FAILFAST
>> this time.
>>
>> When a write from super_written without MD_FAILFAST fails,
>> the array may broken, and MD_BROKEN should be set.
>>
>> After commit 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10"),
>> calling md_error on the last rdev in RAID1/10 always sets
>> the MD_BROKEN flag on the array.
>> As a result, when failfast IO fails on the last rdev, the array
>> immediately becomes failed.
>>
>> This commit prevents MD_BROKEN from being set when a super_write with
>> MD_FAILFAST fails on the last rdev, ensuring that the array does
>> not become failed due to failfast IO failures.
>>
>> Failfast IO failures on any rdev except the last one are not retried
>> and are marked as Faulty immediately. This minimizes array IO latency
>> when an rdev fails.
>>
>> Fixes: 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10")
>> Signed-off-by: Kenta Akagi <k@mgml.me>
> 
> 
> [...]
> 
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -1746,8 +1746,12 @@ static void raid1_status(struct seq_file *seq, struct mddev *mddev)
>>    *    - recovery is interrupted.
>>    *    - &mddev->degraded is bumped.
>>    *
>> - * @rdev is marked as &Faulty excluding case when array is failed and
>> - * &mddev->fail_last_dev is off.
>> + * If @rdev is marked with &FailfastIOFailure, it means that super_write
>> + * failed in failfast and will be retried, so the @mddev did not fail.
>> + *
>> + * @rdev is marked as &Faulty excluding any cases:
>> + *    - when @mddev is failed and &mddev->fail_last_dev is off
>> + *    - when @rdev is last device and &FailfastIOFailure flag is set
>>    */
>>   static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
>>   {
>> @@ -1758,6 +1762,10 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
>>         if (test_bit(In_sync, &rdev->flags) &&
>>           (conf->raid_disks - mddev->degraded) == 1) {
>> +        if (test_bit(FailfastIOFailure, &rdev->flags)) {
>> +            spin_unlock_irqrestore(&conf->device_lock, flags);
>> +            return;
>> +        }
>>           set_bit(MD_BROKEN, &mddev->flags);
>>             if (!mddev->fail_last_dev) {
> 
> At this point, users who try to fail this rdev will get a successful return
> without Faulty flag. Should we consider it?
Hi,
Sorry for the late reply.

I will submit a v3 patch that sets the flag just before md_error and 
modifies raid{1,10}_error to use test_and_clear_bit.
Therefore, echo "faulty" to dev-*/state should always correctly 
mark the device as faulty.

Thanks,
Akagi

> 

