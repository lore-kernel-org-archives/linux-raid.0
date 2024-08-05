Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7FE81537D9;
	Mon,  5 Aug 2024 11:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722856108; cv=none; b=s/R2zYZVBz8EH+WBEf6nL6IrexYj/QS4Mwpp/ty4JCj7NVkAtJo5Ret8Onu75ZM4YEo4wg8FI6VMFXAYuh7bWvGpgUr+q5rRYqrfk8FfHJvJJqb2B9eoJP+F8+3zBrQlrzmGfCjbOrBvI3kHokDsEYAieXix6/BD+tkAL8kfs9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722856108; c=relaxed/simple;
	bh=rsaEinWivQAT49cPwyAR5/n900X1FxB5wL+t/2fsaI8=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=H0E4XPKu3CqPR0PSaWfHmLuKd46OFpbgv6Gt+kvINoEypSoEWqwuzPnZT5pPpj+7rIB7y0dL8gJFvaggwVDIrlVNn5hJbzXZb4Jbok6xA/uoU14XIgoDRrms10HNcEezWTRK4woFRdo0bLCvTRJ9r5AlBLmN6ka4PsxHVJj4Nt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Wctvq040kz4f3m7G;
	Mon,  5 Aug 2024 19:08:07 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 3B6D81A058E;
	Mon,  5 Aug 2024 19:08:21 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgBXzIKjsrBmFRRXAw--.40356S3;
	Mon, 05 Aug 2024 19:08:21 +0800 (CST)
Subject: Re: [PATCH -next] md: wake up mdmon after setting badblocks
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
 Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240801125148.251986-1-yukuai1@huaweicloud.com>
 <20240805114024.00007877@linux.intel.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <5f306d9e-56f7-5e3b-625e-e740f528e130@huaweicloud.com>
Date: Mon, 5 Aug 2024 19:08:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240805114024.00007877@linux.intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXzIKjsrBmFRRXAw--.40356S3
X-Coremail-Antispam: 1UD129KBjvJXoWxWw47Aw4DWr4UXF4UXFyDGFg_yoW5Jw1Up3
	95ua4Ygr1qkrn7Ww17XF15ur1Fgw1fKr4DKrWSgF18t3ZrKr1agr4vgFWDJrWkCrZxCFs2
	gw4UJ3y5ua40gFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
	Y487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
	1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
	b7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
	vE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
	cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa
	73UjIFyTuYvjfUYCJmUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/08/05 17:40, Mariusz Tkaczyk Ð´µÀ:
> On Thu,  1 Aug 2024 20:51:48 +0800
> Yu Kuai <yukuai1@huaweicloud.com> wrote:
> 
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> For external super_block, mdmon rely on "mddev->sysfs_state" to update
>> super_block. However, rdev_set_badblocks() will set sb_flags without
>> waking up mdmon, which might cauing IO hang due to suepr_block can't be
>> updated.
>>
>> This problem is found by code review.
>>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>> ---
>>   drivers/md/md.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 23cc77d51676..06d6ee8cd543 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -9831,10 +9831,12 @@ int rdev_set_badblocks(struct md_rdev *rdev, sector_t
>> s, int sectors, /* Make sure they get written out promptly */
>>   		if (test_bit(ExternalBbl, &rdev->flags))
>>   			sysfs_notify_dirent_safe(rdev->sysfs_unack_badblocks);
>> -		sysfs_notify_dirent_safe(rdev->sysfs_state);
>>   		set_mask_bits(&mddev->sb_flags, 0,
>>   			      BIT(MD_SB_CHANGE_CLEAN) |
>> BIT(MD_SB_CHANGE_PENDING)); md_wakeup_thread(rdev->mddev->thread);
>> +
>> +		sysfs_notify_dirent_safe(rdev->sysfs_state);
>> +		sysfs_notify_dirent_safe(mddev->sysfs_state);
>>   		return 1;
>>   	} else
>>   		return 0;
> 
> 
> Hey Kuai,
> Later, I realized that mdmon is attached to various fds:
> 
> Here a mdmon code:
> 
> add_fd(&rfds, &maxfd, a->info.state_fd);	#mddev->sysfs_state
> add_fd(&rfds, &maxfd, a->action_fd);		#mddev->sysfs_action
> add_fd(&rfds, &maxfd, a->sync_completed_fd);	#mddev->resync_position
> 
> 
> for (mdi = a->info.devs ; mdi ; mdi = mdi->next) { #for each rdev
> 	add_fd(&rfds, &maxfd, mdi->state_fd);		#rdev->sysfs_state
> 	add_fd(&rfds, &maxfd, mdi->bb_fd);		#rdev->sysfs_badblocks
> 	add_fd(&rfds, &maxfd, mdi->ubb_fd);
> #rdev->sysfs_unack_badblocks }

Ok, so I was wrong that mdmon rely on "mddev->sysfs_state".
> 
> Notification in rdev->sysfs_state is fine. The problem was somewhere else
> (mdmon blocked on "rdev remove"). And It will be fixed by moving rdev remove to
> managemon because it is blocking action now.
> 
> https://github.com/md-raid-utilities/mdadm/pull/66
> 
> I think it is fine to move this down after set_mask_bits, but we don't
> have to repeat notification to mddev->state.

Yes, I'll send a v2 patch to move down "rdev->sysfs_state".

Thanks,
Kuai

> 
> Thanks,
> Mariusz
> 
> .
> 

