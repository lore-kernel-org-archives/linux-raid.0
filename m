Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B44189;
	Fri, 19 Sep 2025 01:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758244826; cv=none; b=Bg6l+siNiavvSG4qCQ8em3muze8sQPuG0qmRHxZmR9SY8O/KiUi1D5Q2NPa0n22ob26tBxSLksMJJeyikn2glnVYvCfF5iX0vZNhkt3lPtiBfZeJOqIxUmjZHLKPsmKWJdbg2N7EQD2nxZa8nt6yO3nYK+OkNb2o/1ODLl9f4OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758244826; c=relaxed/simple;
	bh=xXyIzunXd5NjpgjdxNdhn7TYRafAn4h2vFE5ACY9XfE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kZOKAEy/BWqrNyFVfMH7VlZhP9kyzqjiRxFHyVTYM7j32wJeCtViGinGrLQGfFgBuRhhtpKcmXsdwqMDXGiswa2o2zdoNj9NHyT3fZM1gBi1B5kaqdTXvS5Uk56F8HNIZlKkVHjvE41m6RLVn25aiS/ewVhNWfYlREsBNkuk5tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cSZSL10rRzKHMf6;
	Fri, 19 Sep 2025 09:20:18 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id F1A711A0BD3;
	Fri, 19 Sep 2025 09:20:18 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP4 (Coremail) with SMTP id gCh0CgAn6mHQr8xovq4_AA--.17348S3;
	Fri, 19 Sep 2025 09:20:18 +0800 (CST)
Message-ID: <c0bf86fe-7cd5-8ea5-b177-b8662bdb34ab@huaweicloud.com>
Date: Fri, 19 Sep 2025 09:20:17 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v4 7/9] md/raid10: fix failfast read error not rescheduled
To: Kenta Akagi <k@mgml.me>, linan666@huaweicloud.com, song@kernel.org,
 yukuai3@huawei.com, mtkaczyk@kernel.org, shli@fb.com, jgq516@gmail.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
References: <010601995d99b3dc-e860902f-c7c4-4d04-8adb-c49a551a616a-000000@ap-northeast-1.amazonses.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <010601995d99b3dc-e860902f-c7c4-4d04-8adb-c49a551a616a-000000@ap-northeast-1.amazonses.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAn6mHQr8xovq4_AA--.17348S3
X-Coremail-Antispam: 1UD129KBjvJXoWxWrWUZr15Ar4kur4DCr4fuFg_yoW5CFWkp3
	s3JFyakryUJ348Aw12gry7ZFyrtr4Ut3WUXr18GFy8XasIvFnIgFWUXry0gryDXrW8Zw17
	Zr1UJrsrZF1UtFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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



在 2025/9/19 0:12, Kenta Akagi 写道:
> 
> 
> On 2025/09/18 16:38, Li Nan wrote:
>>
>>
>> 在 2025/9/15 11:42, Kenta Akagi 写道:
>>> raid10_end_read_request lacks a path to retry when a FailFast IO fails.
>>> As a result, when Failfast Read IOs fail on all rdevs, the upper layer
>>> receives EIO, without read rescheduled.
>>>
>>> Looking at the two commits below, it seems only raid10_end_read_request
>>> lacks the failfast read retry handling, while raid1_end_read_request has
>>> it. In RAID1, the retry works as expected.
>>> * commit 8d3ca83dcf9c ("md/raid10: add failfast handling for reads.")
>>> * commit 2e52d449bcec ("md/raid1: add failfast handling for reads.")
>>>
>>> I don't know why raid10_end_read_request lacks this, but it is probably
>>> just a simple oversight.
>>
>> Agreed, these two lines can be removed.
> 
> I will revise the commit message.
> 
>>
>> Other than that, LGTM.
>>
>> Reviewed-by: Li Nan <linan122@huawei.com>
> 
> Thank you. However, there is a WARNING due to the comment format that needs to be fixed.
> I also received a failure email from the RAID CI system.
> 
> ------------------------------------------------------------------------
> patch-v4/v4-0007-md-raid10-fix-failfast-read-error-not-rescheduled.patch
> ------------------------------------------------------------------------
> WARNING: Block comments use a trailing */ on a separate line
> #39: FILE: drivers/md/raid10.c:405:
> +                * want to retry */
> 
> total: 0 errors, 1 warnings, 11 lines checked
> 
> 
> I will apply the corrections below and resubmit as v5.
> Is it okay to add a Reviewed-by tag in this case?
> Sorry to bother you.

Yes, please feel free to add it.

> 
> +       } else if (test_bit(FailFast, &rdev->flags) &&
> +                test_bit(R10BIO_FailFast, &r10_bio->state)) {
> +               /* This was a fail-fast read so we definitely


/*
  * This was ...
  */

This way is better.

> +                * want to retry
> +                */
> +               ;
> 
> Thanks,
> Akagi
> 
>>
>>>
>>> This commit will make the failfast read bio for the last rdev in raid10
>>> retry if it fails.
>>>
>>> Fixes: 8d3ca83dcf9c ("md/raid10: add failfast handling for reads.")
>>> Signed-off-by: Kenta Akagi <k@mgml.me>
>>> ---
>>>    drivers/md/raid10.c | 5 +++++
>>>    1 file changed, 5 insertions(+)
>>>
>>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>>> index 92cf3047dce6..86c0eacd37cb 100644
>>> --- a/drivers/md/raid10.c
>>> +++ b/drivers/md/raid10.c
>>> @@ -399,6 +399,11 @@ static void raid10_end_read_request(struct bio *bio)
>>>             * wait for the 'master' bio.
>>>             */
>>>            set_bit(R10BIO_Uptodate, &r10_bio->state);
>>> +    } else if (test_bit(FailFast, &rdev->flags) &&
>>> +         test_bit(R10BIO_FailFast, &r10_bio->state)) {
>>> +        /* This was a fail-fast read so we definitely
>>> +         * want to retry */
>>> +        ;
>>>        } else if (!raid1_should_handle_error(bio)) {
>>>            uptodate = 1;
>>>        } else {
>>
>> -- 
>> Thanks,
>> Nan
>>
>>
> 
> 
> .

-- 
Thanks,
Nan

