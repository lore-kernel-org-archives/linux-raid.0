Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5596635947;
	Thu, 18 Sep 2025 06:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758178723; cv=none; b=OBSf345T5HRYyIcxpfBZSql08zY3K96vyMCpnRfkWatp5/dY6Y438+DiAfzdAXTGGbE6BvDsWMxF66eqEadaYindDmswNBAXa9gb1C3Y5+Pc1Cc0HScsnkHSKIOCdXSkyKl+8O3bMFWFNJ0iGYsQfc8NAd+VFl0BG7CwZSUOxBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758178723; c=relaxed/simple;
	bh=bUOj4JGsqR5gFpMwiWyHhBUu4H2nWTddbgUqKDaPS3s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X1O71N+mgYk+o1EI61bKSb/NF+aC19TIsDyvTNiC0ojlD1fOXsOCNwjy6LeiWOj/iKzUNwVQ39gZOkPoXDmrRauhNwiYLpc7iqvppMBbMPvjIIXlW5wJtpAXJrGn3nZVPSR9KjymeVm+3Tw8TGNDZRM60pPoGQxrt6TO6lDI5Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cS61C0W12zYQvTY;
	Thu, 18 Sep 2025 14:58:39 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id AB1711A1851;
	Thu, 18 Sep 2025 14:58:37 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP4 (Coremail) with SMTP id gCh0CgAncY2brctoUomaCw--.5837S3;
	Thu, 18 Sep 2025 14:58:37 +0800 (CST)
Message-ID: <5da5e4c7-47d7-be71-0724-7b03af33324a@huaweicloud.com>
Date: Thu, 18 Sep 2025 14:58:35 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v4 6/9] md/raid1,raid10: Fix missing retries Failfast
 write bios on no-bbl rdevs
To: Kenta Akagi <k@mgml.me>, linan666@huaweicloud.com, song@kernel.org,
 yukuai3@huawei.com, mtkaczyk@kernel.org, shli@fb.com, jgq516@gmail.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
References: <0106019957e1b14a-9a2f2aec-fca2-40f9-9c65-bcdabac6299b-000000@ap-northeast-1.amazonses.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <0106019957e1b14a-9a2f2aec-fca2-40f9-9c65-bcdabac6299b-000000@ap-northeast-1.amazonses.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAncY2brctoUomaCw--.5837S3
X-Coremail-Antispam: 1UD129KBjvJXoWxZry3WF17uw43ur4kKFW8tFb_yoW5CF1kpa
	s7GFyftrWjq34Iq3Wav34rXF1Fy3yxGFW7Jr1fGw18u3s8Cr1xJF48XryFgFyqqr93KwnF
	qF4UCrZxuFyUG37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBj14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
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
	AFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUQvtAUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/9/17 21:33, Kenta Akagi 写道:
> 
> 
> On 2025/09/17 19:06, Li Nan wrote:
>>
>>
>> 在 2025/9/15 11:42, Kenta Akagi 写道:
>>> In the current implementation, write failures are not retried on rdevs
>>> with badblocks disabled. This is because narrow_write_error, which issues
>>> retry bios, immediately returns when badblocks are disabled. As a result,
>>> a single write failure on such an rdev will immediately mark it as Faulty.
>>>
>>
>> IMO, there's no need to add extra logic for scenarios where badblocks
>> is not enabled. Do you have real-world scenarios where badblocks is
>> disabled?
> 
> No, badblocks are enabled in my environment.
> I'm fine if it's not added, but I still think it's worth adding WARN_ON like:
> 
> @@ -2553,13 +2554,17 @@ static bool narrow_write_error(struct r1bio *r1_bio, int i)
>    fail = true;
> + WARN_ON( (bio->bi_opf & MD_FAILFAST) && (rdev->badblocks.shift < 0) );
>    if (!narrow_write_error(r1_bio, m))
> 
> What do you think?
> 

How about this?

--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2522,10 +2522,11 @@ static bool narrow_write_error(struct r1bio 
*r1_bio, int i)
         bool ok = true;

         if (rdev->badblocks.shift < 0)
-               return false;
+               block_sectors = bdev_logical_block_size(rdev->bdev) >> 9;
+       else
+               block_sectors = roundup(1 << rdev->badblocks.shift,
+                                       bdev_logical_block_size(rdev->bdev) 
 >> 9);

-       block_sectors = roundup(1 << rdev->badblocks.shift,
-                               bdev_logical_block_size(rdev->bdev) >> 9);
         sector = r1_bio->sector;
         sectors = ((sector + block_sectors)
                    & ~(sector_t)(block_sectors - 1))

rdev_set_badblocks() checks shift, too. rdev is marked to Faulty if setting
badblocks fails.


> 
> Thanks,
> Akagi
> 
>>> The retry mechanism appears to have been implemented under the assumption
>>> that a bad block is involved in the failure. However, the retry after
>>> MD_FAILFAST write failure depend on this code, and a Failfast write request
>>> may fail for reasons unrelated to bad blocks.
>>>
>>> Consequently, if failfast is enabled and badblocks are disabled on all
>>> rdevs, and all rdevs encounter a failfast write bio failure at the same
>>> time, no retries will occur and the entire array can be lost.
>>>
>>> This commit adds a path in narrow_write_error to retry writes even on rdevs
>>> where bad blocks are disabled, and failed bios marked with MD_FAILFAST will
>>> use this path. For non-failfast cases, the behavior remains unchanged: no
>>> retry writes are attempted to rdevs with bad blocks disabled.
>>>
>>> Fixes: 1919cbb23bf1 ("md/raid10: add failfast handling for writes.")
>>> Fixes: 212e7eb7a340 ("md/raid1: add failfast handling for writes.")
>>> Signed-off-by: Kenta Akagi <k@mgml.me>
>>> ---
>>>    drivers/md/raid1.c  | 44 +++++++++++++++++++++++++++++---------------
>>>    drivers/md/raid10.c | 37 ++++++++++++++++++++++++-------------
>>>    2 files changed, 53 insertions(+), 28 deletions(-)
>>>                   !test_bit(Faulty, &rdev->flags) &&
>>
>> -- 
>> Thanks,
>> Nan
>>
>>
> 
> 
> 
> .

-- 
Thanks,
Nan

