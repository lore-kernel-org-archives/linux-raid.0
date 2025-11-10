Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97CA532C8B;
	Mon, 10 Nov 2025 12:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762777085; cv=none; b=BDLwXpnAU8UhaqFmAmQA1w6JoMqFC2AvFGhn3yRRpsTSQVUAxooI/BrQ4TR0HHjWo+dqRYLYui3KET6GhSFhh8TH0HUhICK67TzF/3j5LgBiTvsIFBCatsLRz9ENAePYqHI/5mW5iOUbWDoorsXp4mgFMRYWAIa2qRYYR2g4jKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762777085; c=relaxed/simple;
	bh=vQ2imhANIaU4yo8jevcuim8g3FpWfIyAU1N2/r8YaeU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bXsqBhIkltdRV2afmn7OZpAbfNB0r9zg/hzrwFhZGXaznmCotsK6YeoXaNyrhWqPlQfhmCcJXd4pT7vPZcWaGbFNayfj/rwZIDtxb3dL7rdWblmisX6m0E6Yv7YQq/UL/1pStJF2sUEB2NnjS/d6WltW2v/3GOxeD/OgY/TSAdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4d4pZk2dqCzYQtvF;
	Mon, 10 Nov 2025 20:17:34 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 6314E1A08FD;
	Mon, 10 Nov 2025 20:17:59 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP2 (Coremail) with SMTP id Syh0CgCH5Xv11xFp6wgNAQ--.12300S3;
	Mon, 10 Nov 2025 20:17:59 +0800 (CST)
Message-ID: <f2822f91-d48f-a99e-02dc-36c0b4c4b633@huaweicloud.com>
Date: Mon, 10 Nov 2025 20:17:57 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 06/11] md: remove MD_RECOVERY_ERROR handling and
 simplify resync_offset update
To: yukuai@fnnas.com, linan666@huaweicloud.com, song@kernel.org,
 neil@brown.name, namhyung@gmail.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, xni@redhat.com,
 k@mgml.me, yangerkun@huawei.com, yi.zhang@huawei.com
References: <20251106115935.2148714-1-linan666@huaweicloud.com>
 <20251106115935.2148714-7-linan666@huaweicloud.com>
 <c4b15e44-bb02-415e-8f7f-75db2ae2edca@fnnas.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <c4b15e44-bb02-415e-8f7f-75db2ae2edca@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgCH5Xv11xFp6wgNAQ--.12300S3
X-Coremail-Antispam: 1UD129KBjvJXoWxur1fZr43GF17AF18CFWkCrg_yoW5AFW5pF
	Z7JasIkrW8JFW2qayqq348ZayrZw4IyFWUCF43Ww4kZFykAwn7GF1jg3WUWFWDur9ava12
	qa45GF13ZF10kw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUP214x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr
	1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIF
	xwACI402YVCY1x02628vn2kIc2xKxwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14
	v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8C
	rVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8Zw
	CIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x02
	67AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr
	0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbQV
	y7UUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/11/8 18:22, Yu Kuai 写道:
> Hi,
> 
> 在 2025/11/6 19:59, linan666@huaweicloud.com 写道:
>> From: Li Nan <linan122@huawei.com>
>>
>> When sync IO failed and setting badblock also failed, unsynced disk
>> might be kicked via setting 'recovery_disable' without Faulty flag.
>> MD_RECOVERY_ERROR was set in md_sync_error() to prevent updating
>> 'resync_offset', avoiding reading the failed sync sectors.
>>
>> Previous patch ensures disk is marked Faulty when badblock setting fails.
>> Remove MD_RECOVERY_ERROR handling as it's no longer needed - failed sync
>> sectors are unreadable either via badblock or Faulty disk.
>>
>> Simplify resync_offset update logic.
>>
>> Signed-off-by: Li Nan <linan122@huawei.com>
>> ---
>>    drivers/md/md.h |  2 --
>>    drivers/md/md.c | 23 +++++------------------
>>    2 files changed, 5 insertions(+), 20 deletions(-)
>>
>> diff --git a/drivers/md/md.h b/drivers/md/md.h
>> index 18621dba09a9..c5b5377e9049 100644
>> --- a/drivers/md/md.h
>> +++ b/drivers/md/md.h
>> @@ -644,8 +644,6 @@ enum recovery_flags {
>>    	MD_RECOVERY_FROZEN,
>>    	/* waiting for pers->start() to finish */
>>    	MD_RECOVERY_WAIT,
>> -	/* interrupted because io-error */
>> -	MD_RECOVERY_ERROR,
>>    
>>    	/* flags determines sync action, see details in enum sync_action */
>>    
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 2bdbb5b0e9e1..71988d8f5154 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -8949,7 +8949,6 @@ void md_sync_error(struct mddev *mddev)
>>    {
>>    	// stop recovery, signal do_sync ....
>>    	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>> -	set_bit(MD_RECOVERY_ERROR, &mddev->recovery);
>>    	md_wakeup_thread(mddev->thread);
>>    }
>>    EXPORT_SYMBOL(md_sync_error);
>> @@ -9603,8 +9602,8 @@ void md_do_sync(struct md_thread *thread)
>>    	wait_event(mddev->recovery_wait, !atomic_read(&mddev->recovery_active));
>>    
>>    	if (!test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
>> -	    !test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
> 
> Why the above checking is removed?
> 
> Thanks,
> Kuai
> 

Before patch 05, a error sync IO might end and decrement recovery_active,
but its error handling is not completed. It sets recovery_disabled and
MD_RECOVERY_INTR, then remove the error disk later. If
'curr_resync_completed' is updated before the disk is removed, it may cause
reading from the sync-failed regions.

After patch 05, the error IO will definitely be handled. After waiting for
'recovery_active' to become 0 in the previous line, all sync IO has
completed regardless of whether MD_RECOVERY_INTR is set. Thus, this check
can be removed.

So I added the following comment:

>>    	    mddev->curr_resync >= MD_RESYNC_ACTIVE) {
>> +		/* All sync IO completes after recovery_active becomes 0 */
>>    		mddev->curr_resync_completed = mddev->curr_resync;

Since the logic behind this change is complex, should I separate it into a
new commit?

-- 
Thanks,
Nan

