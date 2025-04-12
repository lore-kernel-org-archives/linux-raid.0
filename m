Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2685D1AAC9
	for <linux-raid@vger.kernel.org>; Sat, 12 Apr 2025 01:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744421319; cv=none; b=gpgD5VS3XO+e8+PwQhbyWudmDqBmFf8mnQEFY9UvmR7uYAmPwbTVLqRaTPYx5yNylMaanlbQUXWbLoPsRD/EFn+FIQ0op+aLKgIBW/t3Cv2DX5ztAhYGf9mUHfBFSAG02oR+XEZkqlScrJ7ZtkyNdeQalZKGVfju7j5PRcPU9eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744421319; c=relaxed/simple;
	bh=fDXpmCZbDe7tinBPZ64g/6vpqYJiiD8H3dPaAWdU/ko=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=PUfk6La4utlFJBwdzVEJ8p882tmbHMdRiaWyEK+iTHkV2BduqMM/4q/WWIQ4nLlCOyo/rFGCz3rPD/d2qssJslDr5uNY/srcQoddn7tNg1Ud4uGxRMGjgACTmZuB07OMaRUpPKosZXe4yIHNr9vWfzwA45wxRD7DGQS4jbIVa40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4ZZGC72hNrz4f3lx6
	for <linux-raid@vger.kernel.org>; Sat, 12 Apr 2025 09:28:03 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E7E371A1B9B
	for <linux-raid@vger.kernel.org>; Sat, 12 Apr 2025 09:28:26 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgAni1+5wfln0bLgJA--.6711S3;
	Sat, 12 Apr 2025 09:28:26 +0800 (CST)
Subject: Re: [PATCH v2] md/raid1: Add check for missing source disk in
 process_checks()
To: Meir Elisha <meir.elisha@volumez.com>, Yu Kuai <yukuai1@huaweicloud.com>,
 Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20250408143808.1026534-1-meir.elisha@volumez.com>
 <161625c3-8ba5-eb16-7d6d-e5e4cb125d91@huaweicloud.com>
 <0f114488-5233-45c1-a7c2-0bcc6aa6d6ce@volumez.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <fca95888-66ed-1573-ce32-0492e68b4b34@huaweicloud.com>
Date: Sat, 12 Apr 2025 09:28:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <0f114488-5233-45c1-a7c2-0bcc6aa6d6ce@volumez.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAni1+5wfln0bLgJA--.6711S3
X-Coremail-Antispam: 1UD129KBjvJXoWxXw1UKr15WFW5ur13ZFWxXrb_yoWrCryrpF
	1kJFyjvry5Grn5Jr1UtryUXFy8Jr4UJa4DJr18X3WUXr4DJr1jgrWUXryqgr1UJr48Jw1U
	Jr1UJrsrZr13JF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvC14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
	Y487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
	1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
	b7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
	vE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
	cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUjuHq7UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/04/10 16:59, Meir Elisha 写道:
> Hi,
> 
> On 10/04/2025 10:15, Yu Kuai wrote:
>> Hi,
>>
>> 在 2025/04/08 22:38, Meir Elisha 写道:
>>> During recovery/check operations, the process_checks function loops
>>> through available disks to find a 'primary' source with successfully
>>> read data.
>>>
>>> If no suitable source disk is found after checking all possibilities,
>>> the 'primary' index will reach conf->raid_disks * 2. Add an explicit
>>> check for this condition after the loop. If no source disk was found,
>>> print an error message and return early to prevent further processing
>>> without a valid primary source.
>>>
>>> Signed-off-by: Meir Elisha <meir.elisha@volumez.com>
>>> ---
>>
>> Just to be sure, do you tested this version?
>>
>> Thanks,
>> Kuai
> 
> I wasn't able to reproduce the crash when using this patch.

Good.
Suggested-and-reviewed-by: Yu Kuai <yukuai3@huawei.com>
>   
>>> Changes from v1:
>>>      - Don't fix read errors on recovery/check
>>>
>>> This was observed when forcefully disconnecting all iSCSI devices backing
>>> a RAID1 array(using --failfast flag) during a check operation, causing
>>> all reads within process_checks to fail. The resulting kernel oops shows:
>>>
>>>     BUG: kernel NULL pointer dereference, address: 0000000000000040
>>>     RIP: 0010:process_checks+0x25e/0x5e0 [raid1]
>>>     Code: ... <4c> 8b 53 40 ... // mov r10,[rbx+0x40]
>>>     Call Trace:
>>>      process_checks
>>>      sync_request_write
>>>      raid1d
>>>      md_thread
>>>      kthread
>>>      ret_from_fork
>>>
>>>    drivers/md/raid1.c | 26 ++++++++++++++++----------
>>>    1 file changed, 16 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>>> index 0efc03cea24e..de9bccbe7337 100644
>>> --- a/drivers/md/raid1.c
>>> +++ b/drivers/md/raid1.c
>>> @@ -2200,14 +2200,9 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
>>>                    if (!rdev_set_badblocks(rdev, sect, s, 0))
>>>                        abort = 1;
>>>                }
>>> -            if (abort) {
>>> -                conf->recovery_disabled =
>>> -                    mddev->recovery_disabled;
>>> -                set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>>> -                md_done_sync(mddev, r1_bio->sectors, 0);
>>> -                put_buf(r1_bio);
>>> +            if (abort)
>>>                    return 0;
>>> -            }
>>> +
>>>                /* Try next page */
>>>                sectors -= s;
>>>                sect += s;
>>> @@ -2346,10 +2341,21 @@ static void sync_request_write(struct mddev *mddev, struct r1bio *r1_bio)
>>>        int disks = conf->raid_disks * 2;
>>>        struct bio *wbio;
>>>    -    if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
>>> -        /* ouch - failed to read all of that. */
>>> -        if (!fix_sync_read_error(r1_bio))
>>> +    if (!test_bit(R1BIO_Uptodate, &r1_bio->state)) {
>>> +        /*
>>> +         * ouch - failed to read all of that.
>>> +         * No need to fix read error for check/repair
>>> +         * because all member disks are read.
>>> +         */
>>> +        if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) ||
>>> +            !fix_sync_read_error(r1_bio)) {
>>> +            conf->recovery_disabled = mddev->recovery_disabled;
>>> +            set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>>> +            md_done_sync(mddev, r1_bio->sectors, 0);
>>> +            put_buf(r1_bio);
>>>                return;
>>> +        }
>>> +    }
>>>          if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
>>>            process_checks(r1_bio);
>>>
>>
> .
> 

