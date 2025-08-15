Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF73F72613;
	Fri, 15 Aug 2025 01:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755221183; cv=none; b=Qm6cDWsl+RBCTHz18AO4TOA+IdKvCrUX397hORlYF9NiJ17v0biL8OX6hIwuRvgXe71GGerz3DzcwBT42NvBTm8I2Zj4p5bhKYxjJ9wxYVMPa9C+jeUOU5qgAt+ZKhfD8gbbQmtUJATpoMC9Pnsipd/rYylzVI2tG0ma5KL9ZDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755221183; c=relaxed/simple;
	bh=J64F+uSo5sGAIYQ01V6WVxWgLrdBT6BjOHJ8UJG/Sqg=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=tH6HTEdeA1MCDZH6LEt6xjp8OrmcPsk8DoIRQBnfyg1Skzi0RNksXqbrIgphAcCI1LW3LVXuTOeGM+Vioxcb/G8ldGVJ1oXzdWCdR9PLoSMMHXpQXdwf2a89MFtKv4CZSEZD043Mzv+uk2QIBUaq9Zdna8gmnFFx+WKGmpM/YQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4c34FS456NzYQtwq;
	Fri, 15 Aug 2025 09:26:20 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 2DAA71A0359;
	Fri, 15 Aug 2025 09:26:19 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgD3chO6jJ5o7PfeDg--.25147S3;
	Fri, 15 Aug 2025 09:26:19 +0800 (CST)
Subject: Re: [PATCH] md/raid1,raid10: don't broken array on failfast metadata
 write fails
To: Kenta Akagi <k@mgml.me>, Yu Kuai <yukuai1@huaweicloud.com>,
 Song Liu <song@kernel.org>, Mariusz Tkaczyk <mtkaczyk@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250812090119.153697-1-k@mgml.me>
 <36f78ba0-ac3b-5d97-89f3-2b09d49d1701@huaweicloud.com>
 <c4980d23-7a76-4c28-b9a8-5989524c1f93@mgml.me>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <f9a22cef-0596-485c-b573-90d27bd3af36@huaweicloud.com>
Date: Fri, 15 Aug 2025 09:26:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <c4980d23-7a76-4c28-b9a8-5989524c1f93@mgml.me>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3chO6jJ5o7PfeDg--.25147S3
X-Coremail-Antispam: 1UD129KBjvJXoWxZFyrZr13CF4rJr43ZF1UJrb_yoWrKr15pF
	WktFWYkr98tr1ktw17XFy8Wa45Gw1Ut3yUGr15Ja4xZr15Jr10gF4jgryqgryDur4rGw1D
	Xr1UXFy7ZFyjy3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
	VjvjDU0xZFpf9x0JUG0PhUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/08/14 23:54, Kenta Akagi 写道:
> On 2025/08/13 9:59, Yu Kuai wrote:
>> Hi,
>>
>> 在 2025/08/12 17:01, Kenta Akagi 写道:
>>> It is not intended for the array to fail when a metadata write with
>>> MD_FAILFAST fails.
>>> After commit 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10"),
>>> when md_error is called on the last device in RAID1/10,
>>> the MD_BROKEN flag is set on the array.
>>> Because of this, a failfast metadata write failure will
>>> make the array "broken" state.
>>>
>>> If rdev is not Faulty even after calling md_error,
>>> the rdev is the last device, and there is nothing except
>>> MD_BROKEN that prevents writes to the array.
>>> Therefore, by clearing MD_BROKEN, the array will not become
>>> "broken" after a failfast metadata write failure.
>>
>> I don't understand here, I think MD_BROKEN is expected, the last
>> rdev has IO error while updating metadata, the array is now broken
>> and you can only read it afterwards. Allow using this broken array
>> read-write might causing more severe problem like data loss.
>>
> Thank you for reviewing.
> 
> I think that only when the bio has the MD_FAILFAST flag,
> a metadata write failure to the last rdev should not make it
> broken array at that point.
> 
> This is because a metadata write with MD_FAILFAST is retried after
> failure as follows:
> 
> 1. In super_written, MD_SB_NEED_REWRITE is set in sb_flags.
> 
> 2. In md_super_wait, which is called by the function that
> executed md_super_write and waits for completion,
> -EAGAIN is returned because MD_SB_NEED_REWRITE is set.
> 
> 3. The caller of md_super_wait (such as md_update_sb)
> receives a negative return value and then retries md_super_write.
> 
> 4. The md_super_write function, which is called to perform
> the same metadata write, issues a write bio
> without MD_FAILFAST this time, because the rdev has LastDev flag.
> 
> When a bio from super_written without MD_FAILFAST fails,
> the array is truly broken, and MD_BROKEN should be set.
> 
> A failfast bio, for example in the case of nvme-tcp ,
> will fail immediately if the connection to the target is
> lost for a few seconds and the device enters a reconnecting
> state - even though it would recover if given a few seconds.
> This behavior is exactly as intended by the design of failfast.
> 
> However, md treats super_write operations fails with failfast as fatal.
> For example, if an initiator - that is, a machine loading the md module -
> loses all connections for a few seconds, the array becomes
> broken and subsequent write is no longer possible.
> This is the issue I am currently facing, and which this patch aims to fix.
> 
> Should I add more context to the commit message? Please advise.

Yes, please explain in detail in commit message.
> 
> Thanks,
> AKAGI
> 
>> Thanks,
>> Kuai
>>
>>>
>>> Fixes: 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10")
>>> Signed-off-by: Kenta Akagi <k@mgml.me>
>>> ---
>>>    drivers/md/md.c | 1 +
>>>    drivers/md/md.h | 2 +-
>>>    2 files changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>> index ac85ec73a409..3ec4abf02fa0 100644
>>> --- a/drivers/md/md.c
>>> +++ b/drivers/md/md.c
>>> @@ -1002,6 +1002,7 @@ static void super_written(struct bio *bio)
>>>            md_error(mddev, rdev);
>>>            if (!test_bit(Faulty, &rdev->flags)
>>>                && (bio->bi_opf & MD_FAILFAST)) {
>>> +            clear_bit(MD_BROKEN, &mddev->flags);

And I feel a beeter way is to set MD_BROKEN only if the last rdev
failed, set it in middle and clear it is werid.

Thanks,
Kuai

>>>                set_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags);
>>>                set_bit(LastDev, &rdev->flags);
>>>            }
>>> diff --git a/drivers/md/md.h b/drivers/md/md.h
>>> index 51af29a03079..2f87bcc5d834 100644
>>> --- a/drivers/md/md.h
>>> +++ b/drivers/md/md.h
>>> @@ -332,7 +332,7 @@ struct md_cluster_operations;
>>>     *                   resync lock, need to release the lock.
>>>     * @MD_FAILFAST_SUPPORTED: Using MD_FAILFAST on metadata writes is supported as
>>>     *                calls to md_error() will never cause the array to
>>> - *                become failed.
>>> + *                become failed while fail_last_dev is not set.
>>>     * @MD_HAS_PPL:  The raid array has PPL feature set.
>>>     * @MD_HAS_MULTIPLE_PPLS: The raid array has multiple PPLs feature set.
>>>     * @MD_NOT_READY: do_md_run() is active, so 'array_state', ust not report that
>>>
>>
>>
> .
> 

