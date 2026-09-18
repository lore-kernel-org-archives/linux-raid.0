Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196734A68BE;
	Fri, 18 Sep 2026 07:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789717153; cv=none; b=u5Nbns3NU0/TvHD4ar+jqx+g4+dLsJGlsebC9HtOtqhvOPZdqAcwPX5R7xjrLYLY5N2crrupzKHrMWp/VGHjGJgmzEdW2rG5kuBTfFQ2slX2hS/tJA+anc/XaHmx+E2aOqKYUZt3o0+ptJKKVjayUYS07HR+XDQNQCwmizRaC78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789717153; c=relaxed/simple;
	bh=wMPneGXOul6xoZ4l3T0Z5gh//T69JqOrik39lv3iZXQ=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=ZKBtWlz7098OD8bIw17C8nQAQ0lN2ZOeBl8NyisliYhcJVZLNlyZA+gxA0jMZcezfK2trYk3BhsBWpGHt7530RavKbguMbTFVbGdkSm923NOHcPa17zzm4WRsARBIVJntWC5KQru2FGo1kBy0GioyXkv1ElwIbXbk4mJhaXrMHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=iytQqvaN; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="iytQqvaN"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=fSyDGglXq16ALJMyy68SuHSXMGVQu08Z+26mcysiUMw=;
	b=iytQqvaNmEwikQ2y/ixGJJbaZDE0OsG677QJUbQdnS/iw1z/PAZEwGGwI/gF+eQ6d6pXA0uaZ
	qwakjFgJiZZ/mdTgywe7ajzSAJ3LkEcfHfk9QIxsteR4YqaWWYFY6E7H0zI9Tvq/NmfFbnrODmz
	RvbRmgsSVUZPjqo0jJD7nNA=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4hmPNG2gHPz1K9B2;
	Fri, 18 Sep 2026 15:27:42 +0800 (CST)
Received: from whupemo200011.china.huawei.com (unknown [7.152.185.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 6107640586;
	Fri, 18 Sep 2026 15:38:42 +0800 (CST)
Received: from [10.174.178.46] (10.174.178.46) by
 whupemo200011.china.huawei.com (7.152.185.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 18 Sep 2026 15:38:41 +0800
Subject: Re: [PATCH v3] md: Fix the null-ptr-deref of 'mddev->private' while
 submitting IO
To: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>, <song@kernel.org>,
	<yukuai@fygo.io>, <xiao@kernel.org>, <magiclinan@didiglobal.com>,
	<eadavis@sina.com>
CC: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<yangerkun@huawei.com>, <yi.zhang@huawei.com>
References: <20260918070900.1945351-1-chengzhihao1@huawei.com>
 <m233v7586k.fsf@gmail.com>
From: Zhihao Cheng <chengzhihao1@huawei.com>
Message-ID: <249f987d-9d2d-8f5c-91dd-3af6baefe587@huawei.com>
Date: Fri, 18 Sep 2026 15:38:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <m233v7586k.fsf@gmail.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 whupemo200011.china.huawei.com (7.152.185.179)

ÔÚ 2026/9/18 15:29, Abd-Alrhman Masalkhi Ð´µÀ:
> 
> Hi Zhihao,
> 
> On Fri, Sep 18, 2026 at 15:09 +0800, Zhihao Cheng wrote:
>> Concurrent processes md_stop and IO submitting could trigger a
>> null-ptr-deref of 'mddev->private':
>>
>>   BUG: kernel NULL pointer dereference, address: 0000000000000070
>>   RIP: 0010:_wait_barrier+0x2f/0x250
>>   Call Trace:
>>    raid1_make_request+0x150/0xf50
>>    md_handle_request+0x104/0x530
>>    md_submit_bio+0x76/0x130
>>    submit_bio+0xdd/0x250
>>    submit_bio_wait+0x1f/0x40
>>    __blkdev_direct_IO_simple+0x1f6/0x370
>>    blkdev_write_iter+0x3b2/0x520
>>    ksys_write+0x7d/0x190
>>
>>                P1
>>    fd = open(/dev/md0, O_RDWR)
>> 	                      P2 (forked from P1, fd' <= fd)
>>    write(fd)
>>     submit_bio
>>      md_handle_request
>>       raid1_make_request
>>        raid1_write_request
>>                                    ioctl(fd, STOP_ARRAY)
>> 		                   mddev_set_closing_and_sync_blockdev
>> 				   // check passed, mddev->openers = 1,
>> 				   // because md_open() is only called
>> 				   // once in P1->open
>> 				   do_md_stop
>> 				    __md_stop
>> 				     mddev->private = NULL
>>
>>         conf = mddev->private // NULL
>>          wait_barrier(conf, sector) // null-ptr-deref !
>>
>> It is a common problem for raid0/1/10/5, and __md_stop could be triggered
>> by several paths(eg. ioctl, sysfs, ->dtr). Fix it by replacing
>> mddev_lock() with mddev_suspend_and_lock() for all __md_stop() callers.
>> The caller dm_table_destroy() is guaranteed being invoked with device
>> suspended, so raid_dtr() could keep using mddev_lock_nointr().
>> The caller array_state_store() is guaranteed by the check
>> mddev_set_closing_and_sync_blockdev(mddev, 0). For example, someone open
>> /dev/mdx, write something and close /dev/mdx, it won't trigger the
>> problem, all dirty pages can be flushed before mddev->openers decrement.
>> Besides, fail the submitting IO in md_handle_request() if the
>> 'mddev->pers' becomes NULL.
>>
>> Fetch a reproducer in https://bugzilla.kernel.org/show_bug.cgi?id=222020
>>
>> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>> Reported-by: syzbot+3fe892ea5fc292e1353f@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?extid=3fe892ea5fc292e1353f
>> Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
>> ---
>>   v1->v2:
>>    1. Add 'mddev->pers != NULL' check before make_request
>>    2. Delete dm-raid caller(->dtr) modifications
>>    3. Move memalloc_noio_restore after mddev_unlock_and_resume
>>   v2->v3:
>>    1. Remove modifications in array_state_store()
>>    2. update commit msg
>>   drivers/md/md.c | 15 +++++++++++++++
>>   1 file changed, 15 insertions(+)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 680b34a63cb3..e73338c26d53 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -414,6 +414,20 @@ bool md_handle_request(struct mddev *mddev, struct bio *bio)
>>   		if (!percpu_ref_tryget_live(&mddev->active_io))
>>   			goto check_suspended;
>>   	}
>> +	if (!mddev->pers) {
> Isn't this case already handled by md_submit_bio(). take a look in
> md_submit_bio()
Hi,Abd-Alrhman
I understand that 'mddev == NULL || mddev->pers == NULL' in 
md_submit_bio() is a qiuck check, there still exists a small race window:
      P1                     P2
md_submit_bio
  if (mddev == NULL || mddev->pers == NULL)
                         md_ioctl
                          mddev_suspend_and_lock
                          do_md_stop->__md_stop
                          // set mddev->pers/private as NULL
                          mddev_unlock_and_resume
  md_handle_request
   if (is_suspended(mddev, bio))
   percpu_ref_tryget_live(&mddev->active_io)
   mddev->pers // null-ptr-deref
> 
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
>>   	if (!mddev->pers->make_request(mddev, bio)) {
>>   		percpu_ref_put(&mddev->active_io);
>>   		if (mddev_is_dm(mddev) && mddev->pers->prepare_suspend)
>> @@ -8299,6 +8313,7 @@ static bool md_ioctl_need_suspend(unsigned int cmd)
>>   	case HOT_REMOVE_DISK:
>>   	case SET_BITMAP_FILE:
>>   	case SET_ARRAY_INFO:
>> +	case STOP_ARRAY:
>>   		return true;
>>   	default:
>>   		return false;
>> -- 
>> 2.52.0
>>
> 

