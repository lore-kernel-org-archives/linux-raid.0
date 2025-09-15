Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E99A125A0
	for <linux-raid@vger.kernel.org>; Mon, 15 Sep 2025 01:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757898084; cv=none; b=K7k1l3xx/pzlt/THJgwDnndNJrRMSY88eSx384o7Maqc3qqPZ9f7Jc0pfsTwW2ig9MTb1UqBItcEoiZsgXTxIl6dO7Qy25m8mOW4sSE3uditm7eH1Fo8odfbJm2yrBNj+fP77Ri+sOOvv/gCR0/Dm+CCqMiTTfxBiHGY+lBL1M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757898084; c=relaxed/simple;
	bh=dfF5FwXkS1oxr8BsKIdCvJwINplC8x5k44eAfLRy9fQ=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=I0y/qnECD5VBi365ifnB4aBhF5ya/NsY1pi12CkFUDBXvYDDEHRuKZ+Es/KJM+0BDHqx0ygP54glIvb4lTUUD+OwuqE2HNALJaVJ8kGoCoyIjaOSdLdxoo5nrhCOARz3cWpsS7T4v2SFOpjPF4GwzV+aG5F5hjlSvfSHEKyeP+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cQ6D841y6zKHMX5
	for <linux-raid@vger.kernel.org>; Mon, 15 Sep 2025 09:01:12 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 21A921A0F0F
	for <linux-raid@vger.kernel.org>; Mon, 15 Sep 2025 09:01:13 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgDnMY5XZcdo6HYoCg--.52341S3;
	Mon, 15 Sep 2025 09:01:12 +0800 (CST)
Subject: Re: [PATCH] md: Fix recovery hang when sync_action is set to frozen
To: Meir Elisha <meir.elisha@volumez.com>, Yu Kuai <yukuai1@huaweicloud.com>,
 Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20250908140806.153159-1-meir.elisha@volumez.com>
 <59772acf-a9e5-7aa0-80fe-62f0476f22b5@huaweicloud.com>
 <b77b3cc8-f068-420e-9c97-399d756d6aee@volumez.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <61f59f19-6b16-8398-6837-12bb5093f7d5@huaweicloud.com>
Date: Mon, 15 Sep 2025 09:01:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <b77b3cc8-f068-420e-9c97-399d756d6aee@volumez.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDnMY5XZcdo6HYoCg--.52341S3
X-Coremail-Antispam: 1UD129KBjvJXoWxKw1rKw45JrW3AF15uryrtFb_yoW7ZrWUpr
	97JF98Jry8Wryrtr4UtryjqFyUGr4jy3ZrGr48XF48JF15tr12qayjgF1jgryDJa10qw48
	Jr1UJrZxZr18Gw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvC14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUjuHq7UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/09/11 20:22, Meir Elisha 写道:
> 
> 
> On 09/09/2025 4:00, Yu Kuai wrote:
>> Hi,
>>
>> 在 2025/09/08 22:08, Meir Elisha 写道:
>>> When a RAID array is recovering and sync_action is set to "frozen",
>>> the recovery process hangs indefinitely. This occurs because
>>> wait_event() calls in md_do_sync() were missing the MD_RECOVERY_INTR
>>> check.
>>>
>>> Signed-off-by: Meir Elisha <meir.elisha@volumez.com>
>>> ---
>>>    drivers/md/md.c | 9 ++++++---
>>>    1 file changed, 6 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>> index 1de550108756..1b14beef87fc 100644
>>> --- a/drivers/md/md.c
>>> +++ b/drivers/md/md.c
>>> @@ -9475,7 +9475,8 @@ void md_do_sync(struct md_thread *thread)
>>>                    )) {
>>>                /* time to update curr_resync_completed */
>>>                wait_event(mddev->recovery_wait,
>>> -                   atomic_read(&mddev->recovery_active) == 0);
>>> +                   atomic_read(&mddev->recovery_active) == 0 ||
>>> +                   test_bit(MD_RECOVERY_INTR, &mddev->recovery));
>>>                mddev->curr_resync_completed = j;
>>>                if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) &&
>>>                    j > mddev->resync_offset)
>>> @@ -9581,7 +9582,8 @@ void md_do_sync(struct md_thread *thread)
>>>                     * The faster the devices, the less we wait.
>>>                     */
>>>                    wait_event(mddev->recovery_wait,
>>> -                       !atomic_read(&mddev->recovery_active));
>>> +                       !atomic_read(&mddev->recovery_active) ||
>>> +                       test_bit(MD_RECOVERY_INTR, &mddev->recovery));
>>>                }
>>>            }
>>>        }
>>> @@ -9592,7 +9594,8 @@ void md_do_sync(struct md_thread *thread)
>>>         * this also signals 'finished resyncing' to md_stop
>>>         */
>>>        blk_finish_plug(&plug);
>>> -    wait_event(mddev->recovery_wait, !atomic_read(&mddev->recovery_active));
>>> +    wait_event(mddev->recovery_wait, !atomic_read(&mddev->recovery_active) ||
>>> +           test_bit(MD_RECOVERY_INTR, &mddev->recovery));
>>>          if (!test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
>>>            !test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
>>>
>>
>> This patch doesn't make sense, recovery_active should be zero when all
>> resync IO are done. MD_RECOVERY_INTR just tell sycn_thread to stop
>> issuing new sync IO.
>>
>> Thanks,
>> Kuai
>>
> Hi Kuai
> 
> Reproduced this issue:
> 
> 30511.653859] INFO: task md_vol0000001_6:9483 blocked for more than 622 seconds.
> [30511.654079]       Not tainted 5.14.0-503.31.1.el9_5.x86_64 #1
> [30511.654321] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [30511.654550] task:md_vol0000001_6 state:D stack:0     pid:9483  tgid:9483  ppid:2      flags:0x00004000
> [30511.654864] Call Trace:
> [30511.655015]  <TASK>
> [30511.655165]  __schedule+0x229/0x550
> [30511.655339]  ? srso_alias_return_thunk+0x5/0xfbef5
> [30511.655514]  schedule+0x2e/0xd0
> [30511.655667]  md_do_sync.cold+0x98d/0x98f
> [30511.655820]  ? __pfx_autoremove_wake_function+0x10/0x10
> [30511.655976]  ? __pfx_md_thread+0x10/0x10
> [30511.656125]  md_thread+0xab/0x160
> [30511.656291]  ? __pfx_md_thread+0x10/0x10
> [30511.656432]  kthread+0xe0/0x100
> [30511.656577]  ? __pfx_kthread+0x10/0x10
> [30511.656718]  ret_from_fork+0x2c/0x50
> [30511.656862]  </TASK>
> [30511.657003] INFO: task bash:9559 blocked for more than 622 seconds.
> [30511.657150]       Not tainted 5.14.0-503.31.1.el9_5.x86_64 #1
> [30511.657312] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [30511.657475] task:bash            state:D stack:0     pid:9559  tgid:9559  ppid:6631   flags:0x00004006
> [30511.657759] Call Trace:
> [30511.657895]  <TASK>
> [30511.658026]  __schedule+0x229/0x550
> [30511.658160]  schedule+0x2e/0xd0
> [30511.658320]  stop_sync_thread+0xf2/0x190
> [30511.658466]  ? __pfx_autoremove_wake_function+0x10/0x10
> [30511.658606]  action_store+0x103/0x2f0
> [30511.658743]  md_attr_store+0x83/0x100
> [30511.658883]  kernfs_fop_write_iter+0x12b/0x1c0
> [30511.659026]  vfs_write+0x2ce/0x410
> [30511.659169]  ksys_write+0x5f/0xe0
> [30511.659332]  do_syscall_64+0x5f/0xf0
> 
> Debugging showed we hanged in the wait_event() call in md_do_sync().
> If adding MD_RECOVERY_INTR to the wait condition is a bad idea,
> Do you see can we prevent this hang?
> Thanks for your feedback!
> 

The first step is to figure out why recovery_active is not zero, usually
it'll be zero when all the rescyn IO are done, so you need to find if
they stuck somewhere, or there is no resync IO inflight and the counter
is leaked.

And you  should probably try latest kernel first.

Thanks,
Kuai

> .
> 

