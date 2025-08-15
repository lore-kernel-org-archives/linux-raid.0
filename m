Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED4123D7FD;
	Fri, 15 Aug 2025 19:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755285165; cv=none; b=HGhlC+phwBdeuujdavkA/VAc0R5xJjwODw/zXqYdrtFWqSk3D25Z3b7+rsOD4dssH1o9ZHCZNlQ1YtuFvRbaN/mD+55NabRY3aREqou7Pg1p7IcGCjuwNBf5J1BffBFlY98epCVCSeVOZf/+RX0ZD7nXmXnskYLCs1ZibrSpG80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755285165; c=relaxed/simple;
	bh=1MpLVBaTkftRx0ZL9VAsxbgwHK4XcOhCZ+AdhWvhioU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EwWMY3Q/XCdYSbILJgo06fwpL4i7UrCB2EAHm1rZeuftguFHm3VmHv2d0eBjpia4uKQvVnOhyjKpJaneozeDDtVs9uY4yuvWv+EtowuZggvfqmrz1ycavE1L7BM0NfGVkgod4JY+50GPHn5She6olh6vfJJ1IB7YpZpa4HTnBgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=mgml.me; dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b=WVqOXF1s; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b="WVqOXF1s"
Received: from NEET (p3174069-ipxg00b01tokaisakaetozai.aichi.ocn.ne.jp [122.23.47.69])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 57FJC7DY034459
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Sat, 16 Aug 2025 04:12:08 +0900 (JST)
	(envelope-from k@mgml.me)
DKIM-Signature: a=rsa-sha256; bh=ifVha0y779zflZcpYQGkq627LDgI0cZsMNfU0i0tvwo=;
        c=relaxed/relaxed; d=mgml.me;
        h=Message-ID:Date:Subject:To:From;
        s=rs20250315; t=1755285128; v=1;
        b=WVqOXF1stIEGuDfk/vqa6cIlPzuDI6vEhc0FEyy4o2QBYkCTdB7wXpzmtkk71YuA
         TdhZmLetAVvdvtQYFE7bM866tDzTvkdsXT0caE3vqDthlYXz0xKzLlhJ4tS5e3Z5
         VLO7hufjke3ggEFY+tQoaDq5/oTv8GxXPVTtA1LgaPljDGcoHHvNJxZRiNPUkZ2M
         l73M+PrDEhYtMGsBB3XvaX13zAQEB2duH6jbSjy9I1wBkWX8jF23qRDzfj9uQ7yB
         CuZlcoDjmh4cs4OukR0lTN+9nJcojVKlyCfXZEJtNpxuJPL5PlHpKdjIxzxc1KOp
         2egS5o+0x9/dsp/8yMa7Yw==
Message-ID: <86de9cd3-c80a-4183-92f0-63335ac9c274@mgml.me>
Date: Sat, 16 Aug 2025 04:12:07 +0900
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md/raid1,raid10: don't broken array on failfast metadata
 write fails
To: Yu Kuai <yukuai1@huaweicloud.com>, Song Liu <song@kernel.org>,
        Mariusz Tkaczyk <mtkaczyk@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20250812090119.153697-1-k@mgml.me>
 <36f78ba0-ac3b-5d97-89f3-2b09d49d1701@huaweicloud.com>
 <c4980d23-7a76-4c28-b9a8-5989524c1f93@mgml.me>
 <f9a22cef-0596-485c-b573-90d27bd3af36@huaweicloud.com>
Content-Language: en-US
From: Kenta Akagi <k@mgml.me>
In-Reply-To: <f9a22cef-0596-485c-b573-90d27bd3af36@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 2025/08/15 10:26, Yu Kuai wrote:
> Hi,
> 
> 在 2025/08/14 23:54, Kenta Akagi 写道:
>> On 2025/08/13 9:59, Yu Kuai wrote:
>>> Hi,
>>>
>>> 在 2025/08/12 17:01, Kenta Akagi 写道:
>>>> It is not intended for the array to fail when a metadata write with
>>>> MD_FAILFAST fails.
>>>> After commit 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10"),
>>>> when md_error is called on the last device in RAID1/10,
>>>> the MD_BROKEN flag is set on the array.
>>>> Because of this, a failfast metadata write failure will
>>>> make the array "broken" state.
>>>>
>>>> If rdev is not Faulty even after calling md_error,
>>>> the rdev is the last device, and there is nothing except
>>>> MD_BROKEN that prevents writes to the array.
>>>> Therefore, by clearing MD_BROKEN, the array will not become
>>>> "broken" after a failfast metadata write failure.
>>>
>>> I don't understand here, I think MD_BROKEN is expected, the last
>>> rdev has IO error while updating metadata, the array is now broken
>>> and you can only read it afterwards. Allow using this broken array
>>> read-write might causing more severe problem like data loss.
>>>
>> Thank you for reviewing.
>>
>> I think that only when the bio has the MD_FAILFAST flag,
>> a metadata write failure to the last rdev should not make it
>> broken array at that point.
>>
>> This is because a metadata write with MD_FAILFAST is retried after
>> failure as follows:
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
>> the same metadata write, issues a write bio
>> without MD_FAILFAST this time, because the rdev has LastDev flag.
>>
>> When a bio from super_written without MD_FAILFAST fails,
>> the array is truly broken, and MD_BROKEN should be set.
>>
>> A failfast bio, for example in the case of nvme-tcp ,
>> will fail immediately if the connection to the target is
>> lost for a few seconds and the device enters a reconnecting
>> state - even though it would recover if given a few seconds.
>> This behavior is exactly as intended by the design of failfast.
>>
>> However, md treats super_write operations fails with failfast as fatal.
>> For example, if an initiator - that is, a machine loading the md module -
>> loses all connections for a few seconds, the array becomes
>> broken and subsequent write is no longer possible.
>> This is the issue I am currently facing, and which this patch aims to fix.
>>
>> Should I add more context to the commit message? Please advise.
> 
> Yes, please explain in detail in commit message.
>>
>> Thanks,
>> AKAGI
>>
>>> Thanks,
>>> Kuai
>>>
>>>>
>>>> Fixes: 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10")
>>>> Signed-off-by: Kenta Akagi <k@mgml.me>
>>>> ---
>>>>    drivers/md/md.c | 1 +
>>>>    drivers/md/md.h | 2 +-
>>>>    2 files changed, 2 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>>> index ac85ec73a409..3ec4abf02fa0 100644
>>>> --- a/drivers/md/md.c
>>>> +++ b/drivers/md/md.c
>>>> @@ -1002,6 +1002,7 @@ static void super_written(struct bio *bio)
>>>>            md_error(mddev, rdev);
>>>>            if (!test_bit(Faulty, &rdev->flags)
>>>>                && (bio->bi_opf & MD_FAILFAST)) {
>>>> +            clear_bit(MD_BROKEN, &mddev->flags);
> 
> And I feel a beeter way is to set MD_BROKEN only if the last rdev
> failed, set it in middle and clear it is werid.

Copy.
I'll modify logic and commit message, then send it out as v2.

Thanks, 
Akagi

> Thanks,
> Kuai
> 
>>>>                set_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags);
>>>>                set_bit(LastDev, &rdev->flags);
>>>>            }
>>>> diff --git a/drivers/md/md.h b/drivers/md/md.h
>>>> index 51af29a03079..2f87bcc5d834 100644
>>>> --- a/drivers/md/md.h
>>>> +++ b/drivers/md/md.h
>>>> @@ -332,7 +332,7 @@ struct md_cluster_operations;
>>>>     *                   resync lock, need to release the lock.
>>>>     * @MD_FAILFAST_SUPPORTED: Using MD_FAILFAST on metadata writes is supported as
>>>>     *                calls to md_error() will never cause the array to
>>>> - *                become failed.
>>>> + *                become failed while fail_last_dev is not set.
>>>>     * @MD_HAS_PPL:  The raid array has PPL feature set.
>>>>     * @MD_HAS_MULTIPLE_PPLS: The raid array has multiple PPLs feature set.
>>>>     * @MD_NOT_READY: do_md_run() is active, so 'array_state', ust not report that
>>>>
>>>
>>>
>> .
>>
> 
> 

