Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7272523BD1F;
	Thu, 14 Aug 2025 16:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755187226; cv=none; b=JSs1C/iwL6YFMP8j/DTh7C5tYfDpoIo1qD/V8OHFzWku603URgN9rU6FPA1AT9YeVwfE75etRrY/3ju1uwdJdC2aKdi5UtDxlhHKhLEubJWfoGaiZuFa3ubqhWUjhKtZY99bwNT7/40BqNIUx8UFB92VYipsmMGy36lD+GSjb9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755187226; c=relaxed/simple;
	bh=N/HxePd3bsp/SkNMjTAfFk8WDg+5khUdyzNxzASkK9E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JzmL2GSq4QlCSDNYjzWb9Qk7s59JGPaq2TotWchGOtruf6IG2JCV1+kWXZ4ub5bGqZ8rqNbppFKF5ZkLslmwyIL7hNfGzmjE7w7S/NqtMGjXWLS4CZRv8yTyDdlJp9CHfw3Vj+49g6XYQjOGL0lvBceK4nKXHxBseMceqfGd5FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=mgml.me; dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b=KLEy2dSs; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b="KLEy2dSs"
Received: from NEET (p4453024-ipxg00r01tokaisakaetozai.aichi.ocn.ne.jp [153.230.174.24])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 57EFsS5U072086
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 15 Aug 2025 00:54:28 +0900 (JST)
	(envelope-from k@mgml.me)
DKIM-Signature: a=rsa-sha256; bh=N/HxePd3bsp/SkNMjTAfFk8WDg+5khUdyzNxzASkK9E=;
        c=relaxed/relaxed; d=mgml.me;
        h=Message-ID:Date:Subject:To:From;
        s=rs20250315; t=1755186868; v=1;
        b=KLEy2dSsFbJCWObiL7YZJfdG5CnLD8GXks6HRwFrgZm3iJeGwqNMbvwc2Ck9z+VA
         cOnOrRYu59DWJ0jvk0N0Tdnc/3ojFNWFbRDcTUiTQW5q6zmA2eQctQ5x4aSIAGdr
         HOJcPXBHBs1dN8OEbMjoEfhug2UCV3tqmCGtRhvcu+pqw+jtncepqBjf4IrDYdNT
         9Y9OiLXto6dHpiOupRWFYIy+EJ1jclumK2fWHhV5cJD5LSianlXIwszGXgClZPth
         Cl+WaN3IWjQhOnkv+9PF6e6/MH2S3i9XEMS22WCd0MJofBLFWYov3LwRunoGBfd9
         /JkKOmyIlalMWQ8axfSTKA==
Message-ID: <c4980d23-7a76-4c28-b9a8-5989524c1f93@mgml.me>
Date: Fri, 15 Aug 2025 00:54:28 +0900
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
        "yukuai (C)" <yukuai3@huawei.com>, Kenta Akagi <k@mgml.me>
References: <20250812090119.153697-1-k@mgml.me>
 <36f78ba0-ac3b-5d97-89f3-2b09d49d1701@huaweicloud.com>
Content-Language: en-US
From: Kenta Akagi <k@mgml.me>
In-Reply-To: <36f78ba0-ac3b-5d97-89f3-2b09d49d1701@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2025/08/13 9:59, Yu Kuai wrote:
> Hi,
>
> 在 2025/08/12 17:01, Kenta Akagi 写道:
>> It is not intended for the array to fail when a metadata write with
>> MD_FAILFAST fails.
>> After commit 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10"),
>> when md_error is called on the last device in RAID1/10,
>> the MD_BROKEN flag is set on the array.
>> Because of this, a failfast metadata write failure will
>> make the array "broken" state.
>>
>> If rdev is not Faulty even after calling md_error,
>> the rdev is the last device, and there is nothing except
>> MD_BROKEN that prevents writes to the array.
>> Therefore, by clearing MD_BROKEN, the array will not become
>> "broken" after a failfast metadata write failure.
>
> I don't understand here, I think MD_BROKEN is expected, the last
> rdev has IO error while updating metadata, the array is now broken
> and you can only read it afterwards. Allow using this broken array
> read-write might causing more severe problem like data loss.
>
Thank you for reviewing.

I think that only when the bio has the MD_FAILFAST flag,
a metadata write failure to the last rdev should not make it
broken array at that point.

This is because a metadata write with MD_FAILFAST is retried after
failure as follows:

1. In super_written, MD_SB_NEED_REWRITE is set in sb_flags.

2. In md_super_wait, which is called by the function that
executed md_super_write and waits for completion,
-EAGAIN is returned because MD_SB_NEED_REWRITE is set.

3. The caller of md_super_wait (such as md_update_sb)
receives a negative return value and then retries md_super_write.

4. The md_super_write function, which is called to perform
the same metadata write, issues a write bio
without MD_FAILFAST this time, because the rdev has LastDev flag.

When a bio from super_written without MD_FAILFAST fails,
the array is truly broken, and MD_BROKEN should be set.

A failfast bio, for example in the case of nvme-tcp ,
will fail immediately if the connection to the target is
lost for a few seconds and the device enters a reconnecting
state - even though it would recover if given a few seconds.
This behavior is exactly as intended by the design of failfast.

However, md treats super_write operations fails with failfast as fatal.
For example, if an initiator - that is, a machine loading the md module -
loses all connections for a few seconds, the array becomes
broken and subsequent write is no longer possible.
This is the issue I am currently facing, and which this patch aims to fix.

Should I add more context to the commit message? Please advise.

Thanks,
AKAGI

> Thanks,
> Kuai
>
>>
>> Fixes: 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10")
>> Signed-off-by: Kenta Akagi <k@mgml.me>
>> ---
>>   drivers/md/md.c | 1 +
>>   drivers/md/md.h | 2 +-
>>   2 files changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index ac85ec73a409..3ec4abf02fa0 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -1002,6 +1002,7 @@ static void super_written(struct bio *bio)
>>           md_error(mddev, rdev);
>>           if (!test_bit(Faulty, &rdev->flags)
>>               && (bio->bi_opf & MD_FAILFAST)) {
>> +            clear_bit(MD_BROKEN, &mddev->flags);
>>               set_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags);
>>               set_bit(LastDev, &rdev->flags);
>>           }
>> diff --git a/drivers/md/md.h b/drivers/md/md.h
>> index 51af29a03079..2f87bcc5d834 100644
>> --- a/drivers/md/md.h
>> +++ b/drivers/md/md.h
>> @@ -332,7 +332,7 @@ struct md_cluster_operations;
>>    *                   resync lock, need to release the lock.
>>    * @MD_FAILFAST_SUPPORTED: Using MD_FAILFAST on metadata writes is supported as
>>    *                calls to md_error() will never cause the array to
>> - *                become failed.
>> + *                become failed while fail_last_dev is not set.
>>    * @MD_HAS_PPL:  The raid array has PPL feature set.
>>    * @MD_HAS_MULTIPLE_PPLS: The raid array has multiple PPLs feature set.
>>    * @MD_NOT_READY: do_md_run() is active, so 'array_state', ust not report that
>>
>
>
