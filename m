Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E2DE323E;
	Mon,  1 Sep 2025 02:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756693004; cv=none; b=dUwhaRkwTcmn2ItTsxrqKGTmKHKGWUlWRduB1sD6O2KMPOAxZ1WpUbCu0n3zE0GZXOqRy6HZCYFDSNgIGsdx5VozpTrxtv+HhqWQYTFaITrPRA6OIHnCnhCU9+PZ7eJn9mOY3gOxn3I87hfjWzaYbahObKFtb9IfSK2KASG4FN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756693004; c=relaxed/simple;
	bh=+TGNxwaO5zQP9ZEJNNNEAVGmDWVIafQuuxO1mhqHsiQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZSVcCNqmkcfQX561G1WXcewY4cyp22xRSpKQ7h2IpzHp2lIIrRVm7y1zzGFol3wwvccIoH+Rs/MSiYETv7fUHYFtNWoe6V9kgLZgkieMlb4DxlEnCRvMKLkzEVJmXil02iG3gpY24vEdLxzwJtFt6840FjSc5hK1vjJIS16WFoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cFXYf4snDzKHM0N;
	Mon,  1 Sep 2025 10:16:38 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 7959A1A0EAA;
	Mon,  1 Sep 2025 10:16:38 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP4 (Coremail) with SMTP id gCh0CgDXIY4EArVoScHuAw--.54720S3;
	Mon, 01 Sep 2025 10:16:38 +0800 (CST)
Message-ID: <3624f83b-cfb3-9b1a-8cc8-8caffba7a786@huaweicloud.com>
Date: Mon, 1 Sep 2025 10:16:36 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] md: ensure consistent action state in md_do_sync
To: Paul Menzel <pmenzel@molgen.mpg.de>, Li Nan <linan666@huaweicloud.com>
Cc: song@kernel.org, yukuai3@huawei.com, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yangerkun@huawei.com, yi.zhang@huawei.com
References: <20250830090532.4071221-1-linan666@huaweicloud.com>
 <8d355b81-9a32-4bb6-9951-0905c05434a4@molgen.mpg.de>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <8d355b81-9a32-4bb6-9951-0905c05434a4@molgen.mpg.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDXIY4EArVoScHuAw--.54720S3
X-Coremail-Antispam: 1UD129KBjvJXoW3GFWUur48AryUGF48GF4UJwb_yoWxtF4xpa
	ykJFn8GrWUAryrJrWUtr1DJFyUZr1UJa4DJF47Wa4UJr15tr1jqFyUWr1jgryDJw4kJr4U
	X34UJr47ZF17Gw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBj14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r
	4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v
	4I1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwI
	xGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
	Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7
	IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k2
	6cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxV
	AFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUvg4fUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/8/30 17:51, Paul Menzel 写道:
> Dear Nan,
> 
> 
> Thank you for your patch.
> 
> Am 30.08.25 um 11:05 schrieb linan666@huaweicloud.com:
>> From: Li Nan <linan122@huawei.com>
>>
>> The 'mddev->recovery' flags can change during md_do_sync(), leading to
>> inconsistencies. For example, starting with MD_RECOVERY_RECOVER and
>> ending with MD_RECOVERY_SYNC can cause incorrect offset updates.
> 
> Can you give a concrete example?
> 

T1					T2
md_do_sync
  action = ACTION_RECOVER
					(write sysfs)
					action_store
					 set MD_RECOVERY_SYNC
  [ do recovery ]
  update resync_offset

The corresponding code is:
```
         if (!test_bit(MD_RECOVERY_CHECK, &mddev->recovery) &&
             mddev->curr_resync > MD_RESYNC_ACTIVE) {
                 if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {	->SYNC 
is set, But what we do is recovery
                         if (test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
                                 if (mddev->curr_resync >= 
mddev->resync_offset) {
                                         pr_debug("md: checkpointing %s of 
%s.\n",
                                                  desc, mdname(mddev));
                                         if (test_bit(MD_RECOVERY_ERROR,
                                                 &mddev->recovery))
                                                 mddev->resync_offset =
 
mddev->curr_resync_completed;
                                         else
                                                 mddev->resync_offset =
                                                         mddev->curr_resync;
                                 }
```

>> To avoid this, use the 'action' determined at the beginning of the
>> function instead of repeatedly checking 'mddev->recovery'.
> 
> Do you have a reproducer?
> 

I don't have a reproducer because reproducing it requires modifying the
kernel. The approximate steps are:

- Modify the kernel to add a delay before the above check.
- Trigger recovery by removing and adding disks.
- After recovery completes, write to the sysfs interface at the delay point
to set the sync flag.

> Add a Fixes: tag?
> 

I will add it in v2.

>> Signed-off-by: Li Nan <linan122@huawei.com>
>> ---
>>   drivers/md/md.c | 21 +++++++++------------
>>   1 file changed, 9 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 6828a569e819..67cda9b64c87 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -9516,7 +9516,7 @@ void md_do_sync(struct md_thread *thread)
>>           skipped = 0;
>> -        if (!test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
>> +        if (action != ACTION_RESHAPE &&
>>               ((mddev->curr_resync > mddev->curr_resync_completed &&
>>                 (mddev->curr_resync - mddev->curr_resync_completed)
>>                 > (max_sectors >> 4)) ||
>> @@ -9529,8 +9529,7 @@ void md_do_sync(struct md_thread *thread)
>>               wait_event(mddev->recovery_wait,
>>                      atomic_read(&mddev->recovery_active) == 0);
>>               mddev->curr_resync_completed = j;
>> -            if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) &&
>> -                j > mddev->resync_offset)
>> +            if (action == ACTION_RESYNC && j > mddev->resync_offset)
>>                   mddev->resync_offset = j;
>>               update_time = jiffies;
>>               set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
>> @@ -9646,7 +9645,7 @@ void md_do_sync(struct md_thread *thread)
>>       blk_finish_plug(&plug);
>>       wait_event(mddev->recovery_wait, 
>> !atomic_read(&mddev->recovery_active));
>> -    if (!test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
>> +    if (action != ACTION_RESHAPE &&
>>           !test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
>>           mddev->curr_resync >= MD_RESYNC_ACTIVE) {
>>           mddev->curr_resync_completed = mddev->curr_resync;
>> @@ -9654,9 +9653,8 @@ void md_do_sync(struct md_thread *thread)
>>       }
>>       mddev->pers->sync_request(mddev, max_sectors, max_sectors, &skipped);
>> -    if (!test_bit(MD_RECOVERY_CHECK, &mddev->recovery) &&
>> -        mddev->curr_resync > MD_RESYNC_ACTIVE) {
>> -        if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
>> +    if (action != ACTION_CHECK && mddev->curr_resync > MD_RESYNC_ACTIVE) {
>> +        if (action == ACTION_RESYNC) {
>>               if (test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
>>                   if (mddev->curr_resync >= mddev->resync_offset) {
>>                       pr_debug("md: checkpointing %s of %s.\n",
>> @@ -9674,8 +9672,7 @@ void md_do_sync(struct md_thread *thread)
>>           } else {
>>               if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery))
>>                   mddev->curr_resync = MaxSector;
>> -            if (!test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
>> -                test_bit(MD_RECOVERY_RECOVER, &mddev->recovery)) {
>> +            if (action == ACTION_RECOVER) {
> 
> What about `MD_RECOVERY_RESHAPE`?
> 
>>                   rcu_read_lock();
>>                   rdev_for_each_rcu(rdev, mddev)
>>                       if (mddev->delta_disks >= 0 &&
>> @@ -9692,7 +9689,7 @@ void md_do_sync(struct md_thread *thread)
>>       set_mask_bits(&mddev->sb_flags, 0,
>>                 BIT(MD_SB_CHANGE_PENDING) | BIT(MD_SB_CHANGE_DEVS));
>> -    if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
>> +    if (action == ACTION_RESHAPE &&
>>               !test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
>>               mddev->delta_disks > 0 &&
>>               mddev->pers->finish_reshape &&
>> @@ -9709,10 +9706,10 @@ void md_do_sync(struct md_thread *thread)
>>       spin_lock(&mddev->lock);
>>       if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
>>           /* We completed so min/max setting can be forgotten if used. */
>> -        if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
>> +        if (action == ACTION_REPAIR)
>>               mddev->resync_min = 0;
>>           mddev->resync_max = MaxSector;
>> -    } else if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
>> +    } else if (action == ACTION_REPAIR)
>>           mddev->resync_min = mddev->curr_resync_completed;
>>       set_bit(MD_RECOVERY_DONE, &mddev->recovery);
>>       mddev->curr_resync = MD_RESYNC_NONE;
> 
> I have not fully grogged yet, what the consequence of a mismatch between 
> `action`, set at the beginning, and changed flags in `&mddev->recovery` are.
> 
> 
> Kind regards,
> 
> Paul
> 
> .

-- 
Thanks,
Nan

