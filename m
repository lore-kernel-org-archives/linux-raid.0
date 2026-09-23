Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4334C33D7
	for <linux-raid@vger.kernel.org>; Wed, 23 Sep 2026 11:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790164122; cv=none; b=XJXDXnZ6+FAC8u8hkD95KOMq309cNpEx0j3oXwnAt8NAeMMiP6YzeAe4HL/Ot/Pbx3Xf6PTGAnJEoB3RZWnQBnjrlGP51CtYC+zlfI4hiZTz8SfrMbgFQ2XYmo2yEgHV2/9LNzEkfxm2rYH9TmubEeAC1zrClMuoFTp9h5vrx5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790164122; c=relaxed/simple;
	bh=KSfiOnajdT0TCJuQ3E/w5aHiveEM4BqoGuxib+bgF38=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=dzBnZwOLd//lGyCUk5A68TYcITVj/Sw0y5e9FCeW36h4BaU5YeoGYvcjtYdgi2J3Euj2rrBGUflJYacUgr4B5OcHMKKknXtWFKCiPQlJ+apN4ySJ+pay9S1w90cdaVYlaH8Egg+0unRKGdWnJVyxhJxtGLYl9HP0R5fbg5W3AHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=06B3n92B; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="06B3n92B"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=em08yh31x8n4q97wHB76tq1Ci3byPr7e6rhH+St0tCw=;
	b=06B3n92BKyaT8fvCOjKZCZKadr+wC+26D1QAzgWCTJTUXCo+OQhRQxaz3kF/Qs+30IyLfvQkT
	xzv4XL6nJ9Ht3ChV//34/vI/DpNCqsQsUesgWqh5gcCMmxNCWCJa+Dkm0+qBM770ne1F/2HbXGT
	uVbkRRLJ6jOL2M4E9CB/eBw=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4hqZgn0hCKz12LF9;
	Wed, 23 Sep 2026 19:37:09 +0800 (CST)
Received: from whupemo200011.china.huawei.com (unknown [7.152.185.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 2FC644056D;
	Wed, 23 Sep 2026 19:48:13 +0800 (CST)
Received: from [10.174.178.46] (10.174.178.46) by
 whupemo200011.china.huawei.com (7.152.185.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 23 Sep 2026 19:48:12 +0800
Subject: Re: [PATCH v3 2/4] md: Handle pers->run failure in level_store
To: <sashiko-reviews@lists.linux.dev>
CC: <yukuai@fygo.io>, <linux-raid@vger.kernel.org>
References: <20260923112159.94175-1-chengzhihao1@huawei.com>
 <20260923112159.94175-3-chengzhihao1@huawei.com>
 <20260923114627.3CC921F000FF@smtp.kernel.org>
From: Zhihao Cheng <chengzhihao1@huawei.com>
Message-ID: <b21c45c9-cfd6-090a-349a-69a95a869222@huawei.com>
Date: Wed, 23 Sep 2026 19:48:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260923114627.3CC921F000FF@smtp.kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 whupemo200011.china.huawei.com (7.152.185.179)

在 2026/9/23 19:46, sashiko-bot@kernel.org 写道:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] md: NULL pointer dereference in md_handle_request() after pers->run() fails
> --
> 
> commit 3549464235e3de415ce8ceb834293e195eafad7d
> Author: Zhihao Cheng <chengzhihao1@huawei.com>
> 
> md: Handle pers->run failure in level_store
>      
> This commit adds error handling for the pers->run(mddev) call in
> level_store(). When pers->run() fails, it stops the array via __md_stop()
> and unlinks sysfs nodes before unlocking and returning.
> 
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 680b34a63cb3d..0a3252098780b 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
> 
> [ ... ]
> 
>> @@ -4229,7 +4230,33 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
>>   		mddev->in_sync = 1;
>>   		timer_delete_sync(&mddev->safemode_timer);
>>   	}
>> -	pers->run(mddev);
>> +	rv = pers->run(mddev);
>> +	if (rv) {
>> +		/*
>> +		 * ->run() has released the private data of the new personality,
>> +		 * while the old one has already been released as well. There is
>> +		 * nothing to fall back to, so stop the array to avoid leaving
>> +		 * 'mddev->pers' pointing to a personality which has no private
>> +		 * data, and reminds user to try to active the mddev again.
>> +		 */
>> +		pr_warn("md: %s: failed to run %s after takeover, please try to active\n",
>> +			mdname(mddev), pers->head.name);
>> +		if (mddev->pers->sync_request && mddev->to_remove == NULL)
>> +			mddev->to_remove = &md_redundancy_group;
>> +		if (md_bitmap_enabled(mddev, true))
>> +			mddev->bitmap_ops->flush(mddev);
>> +		clear_bit(MD_SERIALIZE_POLICY, &mddev->flags);
>> +		mddev_destroy_serial_pool(mddev, NULL);
>> +		__md_stop(mddev);
>> +		rdev_for_each(rdev, mddev)
>> +			if (rdev->raid_disk >= 0)
>> +				sysfs_unlink_rdev(mddev, rdev);
>> +		set_capacity_and_notify(mddev->gendisk, 0);
>> +		mddev->changed = 1;
>> +		md_new_event();
>> +		sysfs_notify_dirent_safe(mddev->sysfs_state);
>> +		goto out_unlock;
> 
> [Severity: High]
> Can this trigger a NULL pointer dereference in md_handle_request() for
> concurrent bios?
> 
> If pers->run() fails, __md_stop() sets mddev->pers to NULL. The error path
> then jumps to out_unlock, which subsequently calls mddev_unlock_and_resume().
> 
> When the array is resumed, mddev_unlock_and_resume() resurrects active_io
> and wakes up mddev->sb_wait. If there are concurrent bios submitted to the
> array, they may be blocked in md_handle_request() waiting on sb_wait:
> 
> drivers/md/md.c:md_handle_request() {
> 	...
> 		if (is_suspended(mddev, bio)) {
> 			/* Bail out if REQ_NOWAIT is set for the bio */
> 			if (bio->bi_opf & REQ_NOWAIT) {
> 				bio_wouldblock_error(bio);
> 				return true;
> 			}
> 			wait_event(mddev->sb_wait, !is_suspended(mddev, bio));
> 		}
> 		if (!percpu_ref_tryget_live(&mddev->active_io))
> 			goto check_suspended;
> 	}
> 	if (!mddev->pers->make_request(mddev, bio)) {
> 	...
> }
> 
> Once woken up, they will re-acquire active_io and unconditionally dereference
> mddev->pers->make_request. Since mddev->pers was set to NULL by __md_stop(),
> will this result in a kernel panic?

The problem won't happen after [1] applied.
[1] 
https://lore.kernel.org/lkml/20260922030538.1634904-1-chengzhihao1@huawei.com/
> 
>> +	}
>>   	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
>>   	if (!mddev->thread)
>>   		md_update_sb(mddev, 1);
> 

