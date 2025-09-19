Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CB134BA29;
	Fri, 19 Sep 2025 01:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758245846; cv=none; b=XUeCblrUo8eJsAZQhoz77gUW7V7C3JK4b7mhN6et8488v1+9o8pMAiQR2GTJZ4a5bq0/vu/IuJF3q4x1TWyZbcx0wsvh7GRuKJzLcpHHH/d6nsfc7fbK+Fgq6uthyQ2RJtNHyLdLUi72QZA2w33Hla3nI8m5dVRSYN9mjX1bdj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758245846; c=relaxed/simple;
	bh=1vv7Rpartk9pOnMFVMB3X4LlMfckIVtDz67kL/p/YfI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TGHyCItrVtSvbA22MipJVRi1P5DsOl1+tPQSXBrOavVAvsVqa5jwPAbel44JtHn5opp99zauWzF8Hux9eXd5FKpk57ziw5TFy9V22VKedPpN9FpMEweSmS3L8QGu3T4OmUrcL14UVbJ1ryGxO6AU0xQTpT/RHHQQCWza05MK/Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cSZr233MVzYQv2h;
	Fri, 19 Sep 2025 09:37:22 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 11CC71A16AE;
	Fri, 19 Sep 2025 09:37:21 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP4 (Coremail) with SMTP id gCh0CgDHi2POs8xoqghBAA--.17588S3;
	Fri, 19 Sep 2025 09:37:20 +0800 (CST)
Message-ID: <6f0f9730-4bbe-7f3c-1b50-690bb77d5d90@huaweicloud.com>
Date: Fri, 19 Sep 2025 09:37:18 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v4 5/9] md/raid1,raid10: Set R{1,10}BIO_Uptodate when
 successful retry of a failed bio
To: Kenta Akagi <k@mgml.me>, linan666@huaweicloud.com, song@kernel.org,
 yukuai3@huawei.com, mtkaczyk@kernel.org, shli@fb.com, jgq516@gmail.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
References: <010601995d7867c6-b8e08c65-5db3-4616-abd3-ec03a92ec8bc-000000@ap-northeast-1.amazonses.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <010601995d7867c6-b8e08c65-5db3-4616-abd3-ec03a92ec8bc-000000@ap-northeast-1.amazonses.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHi2POs8xoqghBAA--.17588S3
X-Coremail-Antispam: 1UD129KBjvJXoWxuF4rWF4xXr1fXFy3tF13urg_yoWrAF1fpr
	1kJF1UJryUJr18Jr1Utr1UJryUtr1UJ3WUJr18JF1UJr1Utr1jqr1UXr1jgr1UJr48Jr1U
	Jr1UJr17Zr1UJrUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBj14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r
	4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v
	4I1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwI
	xGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
	Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7
	IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k2
	6cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxV
	AFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUAxhLUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/9/18 23:36, Kenta Akagi 写道:
> 
> 
> On 2025/09/18 15:39, Li Nan wrote:
>>
>>
>> 在 2025/9/17 21:20, Kenta Akagi 写道:
>>
>>>>>                 if (!narrow_write_error(r1_bio, m))
>>>>> -                md_error(conf->mddev,
>>>>> -                     conf->mirrors[m].rdev);
>>>>> +                md_error(conf->mddev, rdev);
>>>>>                     /* an I/O failed, we can't clear the bitmap */
>>>>> -            rdev_dec_pending(conf->mirrors[m].rdev,
>>>>> -                     conf->mddev);
>>>>> +            else if (test_bit(In_sync, &rdev->flags) &&
>>>>> +                 !test_bit(Faulty, &rdev->flags) &&
>>>>> +                 rdev_has_badblock(rdev,
>>>>> +                           r1_bio->sector,
>>>>> +                           r1_bio->sectors) == 0)
>>>>
>>>> Clear badblock and set R10BIO_Uptodate if rdev has badblock.
>>>
>>> narrow_write_error returns true when the write succeeds, or when the write
>>> fails but rdev_set_badblocks succeeds. Here, it determines that the re-write
>>> succeeded if there is no badblock in the sector to be written by r1_bio.
>>> So we should not call rdev_clear_badblocks here.
>>>
>>
>> I am trying to cleanup narrow_write_error():
>>
>> https://lore.kernel.org/linux-raid/20250917093508.456790-3-linan666@huaweicloud.com/T/#u
>>
>> It may be clearer if narrow_write_error() returns true when all fix IO
>> succeeds.
>>
>> ```
>> @@ -2553,11 +2551,17 @@ static bool narrow_write_error(struct r1bio *r1_bio, int i)
>>                  bio_trim(wbio, sector - r1_bio->sector, sectors);
>>                  wbio->bi_iter.bi_sector += rdev->data_offset;
>>
>> -               if (submit_bio_wait(wbio) < 0)
>> -                       /* failure! */
>> -                       ok = rdev_set_badblocks(rdev, sector,
>> -                                               sectors, 0)
>> -                               && ok;
>> +               if (submit_bio_wait(wbio) < 0) {
>> +                       ok = false;
>> +                       if (rdev_set_badblocks(rdev, sector, sectors, 0)) {
>> +                               /*
>> +                                * Badblocks set failed, disk marked Faulty.
>> +                                * No further operations needed.
>> +                                */
>> +                               bio_put(wbio);
>> +                               break;
>> +                       }
>> +               }
>>
>>                  bio_put(wbio);
>>                  sect_to_write -= sectors;
>> ```
>>
>> We can clear badblocks and set R10BIO_Uptodate after it. What do you think?
> 
> Thanks for the detailed explanation.
> narrow_write_error now returns whether the retry write succeeded.
> If rdev_set_badblock fails, narrow_write_error calls md_error. This looks good to me.
> And after narrow_write_error cleanup, rdev_clear_badblock should be called.
> 
> BTW, I'm not familiar with the patch workflow. Should I submit my
> handle_write_finished patch separately after your cleanup patch merged?
> 

Sure, please send it separately after my cleanup patch. Thanks.

> Thanks,
> Akagi
> 
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

