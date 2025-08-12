Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B401F4CAC;
	Tue, 12 Aug 2025 11:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754996596; cv=none; b=cEcQhqD73FgG/8XlFfG5aBbDU5qmZO8wW9gatAVDCw95o6SQ2BSP4Is/kZqr+wSgGuUrHnJ8vmYhY4IZy4f+qCvzqdcmW84Sbo5xI2+VcVVbcoQ6lReq1y+nGvcrnjF94b+OEPJzIUvoRI5I+qrNv71O/S8t/BQOTHwzIIuBTUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754996596; c=relaxed/simple;
	bh=qLF+I7WPqhUrb+VNmpL20/SfL6ZE9h40NuAjJxQ1snU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p3wcBQqwFJOnzcZdKWslNt5+1AlR6BPbSqJhWxcwUC0baVckbhTSVSMQaICsPwlIvLx0smguOkcbKe0FHVvV6rwd9HhLlXbDNYtTTRVM36f0WH8Xh5rqBMGc5Y3IaI/Y962qaJ5V2oeFpWArvC9vPZi+wZg03qRHX3B/AQncV6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4c1TBQ6dXyzYQtr5;
	Tue, 12 Aug 2025 19:03:10 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 879A41A09D8;
	Tue, 12 Aug 2025 19:03:09 +0800 (CST)
Received: from [10.174.178.72] (unknown [10.174.178.72])
	by APP4 (Coremail) with SMTP id gCh0CgAXkxNrH5toyg63DQ--.43961S3;
	Tue, 12 Aug 2025 19:03:09 +0800 (CST)
Message-ID: <027a1ab7-1ff4-493c-b202-c0597a222403@huaweicloud.com>
Date: Tue, 12 Aug 2025 19:03:07 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] md: fix sync_action incorrect display during
 resync
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: song@kernel.org, yukuai3@huawei.com, linan122@huawei.com,
 linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, houtao1@huawei.com,
 zhengqixing@huawei.com
References: <20250812021738.3722569-1-zhengqixing@huaweicloud.com>
 <20250812021738.3722569-3-zhengqixing@huaweicloud.com>
 <1775d473-a77f-4ac8-8195-8547dd48d754@molgen.mpg.de>
From: Zheng Qixing <zhengqixing@huaweicloud.com>
In-Reply-To: <1775d473-a77f-4ac8-8195-8547dd48d754@molgen.mpg.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXkxNrH5toyg63DQ--.43961S3
X-Coremail-Antispam: 1UD129KBjvJXoWxZrWxXw4UtryfZr48KFyDJrb_yoWrXr13pF
	4ktFWUGry7Crn3JrW3J34DJFy5uw18JayDJr1xWa4UArsxKr1jqF1UWrnFgF1UJr40qr4j
	qr1UXrZxuF17CFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8
	ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1
	7KsUUUUUU==
X-CM-SenderInfo: x2kh0wptl0x03j6k3tpzhluzxrxghudrp/

Hi,


在 2025/8/12 17:22, Paul Menzel 写道:
> Dear Zheng,
>
>
> Thank you for your patch.
>
> Am 12.08.25 um 04:17 schrieb Zheng Qixing:
>> From: Zheng Qixing <zhengqixing@huawei.com>
>>
>> During raid resync, if a disk becomes faulty, the operation is
>> briefly interrupted. The MD_RECOVERY_RECOVER flag triggered by
>> the disk failure causes sync_action to incorrectly show "recover"
>> instead of "resync". The same issue affects reshape operations.
>>
>> Reproduction steps:
>>    mdadm -Cv /dev/md1 -l1 -n4 -e1.2 /dev/sd{a..d} // -> resync happended
>>    mdadm -f /dev/md1 /dev/sda                     // -> resync 
>> interrupted
>>    cat sync_action
>>    -> recover
>>
>> Add progress checks in md_sync_action() for resync/recover/reshape
>> to ensure the interface correctly reports the actual operation type.
>>
>> Fixes: 4b10a3bc67c1 ("md: ensure resync is prioritized over recovery")
>> Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
>> ---
>>   drivers/md/md.c | 38 ++++++++++++++++++++++++++++++++++++--
>>   1 file changed, 36 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 4ea956a80343..798428d0870b 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -4845,9 +4845,34 @@ static bool rdev_needs_recovery(struct md_rdev 
>> *rdev, sector_t sectors)
>>       return false;
>>   }
>>   +static enum sync_action md_get_active_sync_action(struct mddev 
>> *mddev)
>> +{
>> +    struct md_rdev *rdev;
>> +    bool is_recover = false;
>
> `is_recover` sounds strange to me, but I am not an expert with the 
> code. Maybe `needs_recovery`?


is_recover is used here to distinguish whether the current sync_action 
is a recover, rather than a resync or reshape.

But it's not a big deal, no need to focus on it :)


>
>> +
>> +    if (mddev->resync_offset < MaxSector)
>> +        return ACTION_RESYNC;
>> +
>> +    if (mddev->reshape_position != MaxSector)
>> +        return ACTION_RESHAPE;
>> +
>> +    rcu_read_lock();
>> +    rdev_for_each_rcu(rdev, mddev) {
>> +        if (rdev->raid_disk >= 0 &&
>> +            rdev_needs_recovery(rdev, MaxSector)) {
>> +            is_recover = true;
>> +            break;
>> +        }
>> +    }
>> +    rcu_read_unlock();
>> +
>> +    return is_recover ? ACTION_RECOVER : ACTION_IDLE;
>> +}
>> +
>>   enum sync_action md_sync_action(struct mddev *mddev)
>>   {
>>       unsigned long recovery = mddev->recovery;
>> +    enum sync_action active_action;
>>         /*
>>        * frozen has the highest priority, means running sync_thread 
>> will be
>> @@ -4871,8 +4896,17 @@ enum sync_action md_sync_action(struct mddev 
>> *mddev)
>>           !test_bit(MD_RECOVERY_NEEDED, &recovery))
>>           return ACTION_IDLE;
>>   -    if (test_bit(MD_RECOVERY_RESHAPE, &recovery) ||
>> -        mddev->reshape_position != MaxSector)
>> +    /*
>> +     * Check if any sync operation (resync/recover/reshape) is
>> +     * currently active. This ensures that only one sync operation
>> +     * can run at a time. Returns the type of active operation, or
>> +     * ACTION_IDLE if none are active.
>> +     */
>> +    active_action = md_get_active_sync_action(mddev);
>> +    if (active_action != ACTION_IDLE)
>> +        return active_action;
>> +
>> +    if (test_bit(MD_RECOVERY_RESHAPE, &recovery))
>>           return ACTION_RESHAPE;
>>         if (test_bit(MD_RECOVERY_RECOVER, &recovery))
>
> Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
>
>
> Kind regards,
>
> Paul


Thanks,

Qixing


