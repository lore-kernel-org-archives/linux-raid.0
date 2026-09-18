Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792A83AA1BB;
	Fri, 18 Sep 2026 06:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789712429; cv=none; b=Jxb5C7+/YwlQzSJntky21Firi5D26JVcQZEgIVJG7PYaDiqtIR41ZUxSuwxgOkW9JrsF9bCKldv7U9Todbk3mzpIUfL2kTSkOnKqEqAr43fM9iGUzRVN9SdNh83CCxWAs+e6uQpZezaYA5QqJ7oVgTSaz5VHBj7XGmxkEQQTaiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789712429; c=relaxed/simple;
	bh=y7qYGOqBHTkXcv+UGyVR3fatY+b21N34bZspwFXzlI8=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=BYJZSnukFirPx+lcXPYKGtHU3m/xe1pgbCDdYzOeT2bWaH7QAgUB7NBIZwkb/+5Ae9uy8Elg+D3AheiR4fCqk6yj1FG8G8zQBp8puTfiokgcViwIXtoiulLMqUgPvmUM11Ti1rv4rCN0fZsjHKIPnwEegjRtKEwRIn3NH86ZAww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=YwuI63Jz; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="YwuI63Jz"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=/EmTRV68EuwkaVOnj6HPetBktycK3QdXzrHOdjiyXcM=;
	b=YwuI63Jz9js7cJjl844wtkdaA1pbgtEwRz4yxIlQropQr9MLOo2hrouTxjT1OsT2uE6For5T7
	BK4gjYGejgTgD4VJeWyFRvjnGyvYpSVFqR0tns764NOEYTiwh9zSLCyBjg6JIR9nz/y1NsCrPPO
	AJGilsbaSsCt9fhC0YNaSBU=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hmMdM74mZz1prLc;
	Fri, 18 Sep 2026 14:08:55 +0800 (CST)
Received: from whupemo200011.china.huawei.com (unknown [7.152.185.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 2E9F34056D;
	Fri, 18 Sep 2026 14:19:57 +0800 (CST)
Received: from [10.174.178.46] (10.174.178.46) by
 whupemo200011.china.huawei.com (7.152.185.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 18 Sep 2026 14:19:55 +0800
Subject: Re: [PATCH v2] md: Fix the null-ptr-deref of 'mddev->private' while
 submitting IO
To: <yukuai@fygo.io>, <song@kernel.org>, <xiao@kernel.org>,
	<magiclinan@didiglobal.com>, <eadavis@sina.com>, <abd.masalkhi@gmail.com>
CC: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<yangerkun@huawei.com>, <yi.zhang@huawei.com>
References: <20260917024205.2331019-1-chengzhihao1@huawei.com>
 <d896d273-ac1b-484c-9a71-cb60a85d389b@fygo.io>
From: Zhihao Cheng <chengzhihao1@huawei.com>
Message-ID: <a353585b-7cf8-c26c-8f55-84354ce10bd8@huawei.com>
Date: Fri, 18 Sep 2026 14:19:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <d896d273-ac1b-484c-9a71-cb60a85d389b@fygo.io>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 whupemo200011.china.huawei.com (7.152.185.179)

在 2026/9/18 14:06, yu kuai 写道:
> Hi,
> 
> 在 2026/9/17 10:42, Zhihao Cheng 写道:
>> Concurrent processes md_stop and IO submitting could trigger a
>> null-ptr-deref of 'mddev->private':
>>
>>    BUG: kernel NULL pointer dereference, address: 0000000000000070
>>    RIP: 0010:_wait_barrier+0x2f/0x250
>>    Call Trace:
>>     raid1_make_request+0x150/0xf50
>>     md_handle_request+0x104/0x530
>>     md_submit_bio+0x76/0x130
>>     submit_bio+0xdd/0x250
>>     submit_bio_wait+0x1f/0x40
>>     __blkdev_direct_IO_simple+0x1f6/0x370
>>     blkdev_write_iter+0x3b2/0x520
>>     ksys_write+0x7d/0x190
>>
>>                 P1
>>     fd = open(/dev/md0, O_RDWR)
>> 	                      P2 (forked from P1, fd' <= fd)
>>     write(fd)
>>      submit_bio
>>       md_handle_request
>>        raid1_make_request
>>         raid1_write_request
>>                                     ioctl(fd, STOP_ARRAY)
>> 		                   mddev_set_closing_and_sync_blockdev
>> 				   // check passed, mddev->openers = 1,
>> 				   // because md_open() is only called
>> 				   // once in P1->open
>> 				   do_md_stop
>> 				    __md_stop
>> 				     mddev->private = NULL
>>
>>          conf = mddev->private // NULL
>>           wait_barrier(conf, sector) // null-ptr-deref !
>>
>> It is a common problem for raid0/1/10/5, and __md_stop could be
>> triggered by several paths(eg. ioctl, sysfs, ->dtr). Fix it by
>> replacing mddev_lock() with mddev_suspend_and_lock() for all
>> __md_stop() callers. The caller dm_table_destroy() is guaranteed
>> being invoked with device suspended, so raid_dtr() could keep
>> using mddev_lock_nointr(). Besides, fail the submitting IO in
>> md_handle_request() if the 'mddev->pers' becomes NULL.
>>
>> Fetch a reproducer in https://bugzilla.kernel.org/show_bug.cgi?id=222020
>>
>> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>> Reported-by: syzbot+3fe892ea5fc292e1353f@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?extid=3fe892ea5fc292e1353f
>> Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
>> ---
>>    v1->v2:
>>     1. Add 'mddev->pers != NULL' check before make_request
>>     2. Delete dm-raid caller(->dtr) modifications
>>     3. Move memalloc_noio_restore after mddev_unlock_and_resume
>>    drivers/md/md.c | 32 +++++++++++++++++++++++++++++---
>>    1 file changed, 29 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 680b34a63cb3..3dfc34caa2dc 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -414,6 +414,20 @@ bool md_handle_request(struct mddev *mddev, struct bio *bio)
>>    		if (!percpu_ref_tryget_live(&mddev->active_io))
>>    			goto check_suspended;
>>    	}
>> +	if (!mddev->pers) {
>> +		/*
>> +		 * The __md_stop() sets 'mddev->private' to NULL during
>> +		 * the IO submitting, check 'mddev->pers' before the IO
>> +		 * being processed by specific driver to avoid the
>> +		 * null-ptr-deref of 'mddev-><member>'. The check is
>> +		 * safe because the IO has got the 'mddev->active_io'
>> +		 * reference, and all __md_stop() callers will wait for
>> +		 * the reference to be zero.
>> +		 */
>> +		bio_io_error(bio);
>> +		percpu_ref_put(&mddev->active_io);
>> +		return true;
>> +	}
>>    	if (!mddev->pers->make_request(mddev, bio)) {
>>    		percpu_ref_put(&mddev->active_io);
>>    		if (mddev_is_dm(mddev) && mddev->pers->prepare_suspend)
>> @@ -4657,6 +4671,8 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
>>    {
>>    	int err = 0;
>>    	enum array_state st = match_word(buf, array_states);
>> +	unsigned int noio_flags = 0;
>> +	bool suspend = false;
>>    
>>    	/* No lock dependent actions */
>>    	switch (st) {
>> @@ -4666,9 +4682,11 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
>>    	case broken:		/* cannot be set */
>>    	case bad_word:
>>    		return -EINVAL;
>> +	case inactive:
>>    	case clear:
>> +		suspend = true;
>> +		fallthrough;
>>    	case readonly:
>> -	case inactive:
>>    	case read_auto:
>>    		if (!mddev->pers || !md_is_rdwr(mddev))
>>    			break;
>> @@ -4702,9 +4720,11 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
>>    		spin_unlock(&mddev->lock);
>>    		return err ?: len;
>>    	}
>> -	err = mddev_lock(mddev);
>> +	err = suspend ? mddev_suspend_and_lock(mddev) : mddev_lock(mddev);
> 
> Unlike ioctl path, where the checking of opener is just 1, mddev_set_closing_and_sync_blockdev() here
> already check there is no opener, so there can't be any IO inflight.

Hi, yukuai
I thought of a scene. If someone open '/dev/md0, write(buffer) 4K, and 
close the corresponding fd. Then writeback kworker submit IO, 
array_state_store will pass the mddev_set_closing_and_sync_blockdev() 
check, which could lead to the similar problem.
> 
>>    	if (err)
>>    		return err;
>> +	if (suspend)
>> +		noio_flags = memalloc_noio_save();
>>    
>>    	switch (st) {
>>    	case inactive:
>> @@ -4775,7 +4795,12 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
>>    			mddev->hold_active = 0;
>>    		sysfs_notify_dirent_safe(mddev->sysfs_state);
>>    	}
>> -	mddev_unlock(mddev);
>> +	if (suspend) {
>> +		mddev_unlock_and_resume(mddev);
>> +		memalloc_noio_restore(noio_flags);
>> +	} else {
>> +		mddev_unlock(mddev);
>> +	}
>>    
>>    	if (st == readonly || st == read_auto || st == inactive ||
>>    	    (err && st == clear))
>> @@ -8299,6 +8324,7 @@ static bool md_ioctl_need_suspend(unsigned int cmd)
>>    	case HOT_REMOVE_DISK:
>>    	case SET_BITMAP_FILE:
>>    	case SET_ARRAY_INFO:
>> +	case STOP_ARRAY:
>>    		return true;
>>    	default:
>>    		return false;
> 

