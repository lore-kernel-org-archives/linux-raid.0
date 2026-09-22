Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E611937475B;
	Tue, 22 Sep 2026 03:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790047543; cv=none; b=ACoMkzi2wbWfxEMYxaNddh/EPP5Mf3uT/KJxSotL/hdZ80Q61i5ci4/9nhTIP/bnYCL/XDMbSD2iNG63PA0nF/nIXAooJNFcVjiFpPbQtElqGg3hyhw/eOpiY71HcmlujQ836q6x/RRfdZvJiPJnpliOlDaCEZ0NE4E6FfO74g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790047543; c=relaxed/simple;
	bh=Z8sUfskjaLRyDMxZaKAvd99uf6A+5BV+U4CrPC6ZKNE=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=s06UH0ec84AZIh9iybhSg9Y46Lhd5qDtrzxkWEpQxyLEdfxo1fDnLOjwY/mJcRQAxMVwlE8O83I3pVDgcKmyoSuBh5xRtsBWhE+GrJSiRdVPPouOEDAbmpWeqA2OyKwqrS5iwu5GpmzZNok8h13HRVh/n9oawWSbElYywQeqyQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=Se4+BJpu; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="Se4+BJpu"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=EnVbmPNTtxqJpCb+m0jfFdhbF/lPOyAIIZbmLAocF1E=;
	b=Se4+BJpuoMe9BLJZKGpcWBb47Qm5+wOgV+2fgLSexH0PfkK6GxgFmk0LkjxhBcvXpLTAOECm7
	oNE3mY7zlvd1qdeOm5fg3DtepS6UA43CqTaIIpOWHPhk2H1foDRh7mSXZXLm2a5XY6gWBmOO+2d
	nZlowvOASo877U9OArQgSEU=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4hplZ930YCz12LHh;
	Tue, 22 Sep 2026 11:14:25 +0800 (CST)
Received: from whupemo200011.china.huawei.com (unknown [7.152.185.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 442E040561;
	Tue, 22 Sep 2026 11:25:30 +0800 (CST)
Received: from [10.174.178.46] (10.174.178.46) by
 whupemo200011.china.huawei.com (7.152.185.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 22 Sep 2026 11:25:28 +0800
Subject: Re: [PATCH v5] md: Fix the null-ptr-deref of 'mddev->private' while
 submitting IO
To: <song@kernel.org>, <yukuai@fygo.io>, <magiclinan@didiglobal.com>,
	<xiao@kernel.org>, <eadavis@sina.com>, <abd.masalkhi@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <yangerkun@huawei.com>,
	<yi.zhang@huawei.com>, <linux-raid@vger.kernel.org>
References: <20260922030538.1634904-1-chengzhihao1@huawei.com>
From: Zhihao Cheng <chengzhihao1@huawei.com>
Message-ID: <64d7d286-4c2d-ebd1-7faa-4abb5eec997c@huawei.com>
Date: Tue, 22 Sep 2026 11:25:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260922030538.1634904-1-chengzhihao1@huawei.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 whupemo200011.china.huawei.com (7.152.185.179)

ÔÚ 2026/9/22 11:05, Zhihao Cheng Ð´µÀ:
Cc linux-raid@vger.kernel.org
> Concurrent processes md_stop and IO submitting could trigger a
> null-ptr-deref of 'mddev->private':
> 
>   BUG: kernel NULL pointer dereference, address: 0000000000000070
>   RIP: 0010:_wait_barrier+0x2f/0x250
>   Call Trace:
>    raid1_make_request+0x150/0xf50
>    md_handle_request+0x104/0x530
>    md_submit_bio+0x76/0x130
>    submit_bio+0xdd/0x250
>    submit_bio_wait+0x1f/0x40
>    __blkdev_direct_IO_simple+0x1f6/0x370
>    blkdev_write_iter+0x3b2/0x520
>    ksys_write+0x7d/0x190
> 
>                P1
>    fd = open(/dev/md0, O_RDWR)
> 	                      P2 (forked from P1, fd' <= fd)
>    write(fd)
>     submit_bio
>      md_handle_request
>       raid1_make_request
>        raid1_write_request
>                                    ioctl(fd, STOP_ARRAY)
> 		                   mddev_set_closing_and_sync_blockdev
> 				   // check passed, mddev->openers = 1,
> 				   // because md_open() is only called
> 				   // once in P1->open
> 				   do_md_stop
> 				    __md_stop
> 				     mddev->private = NULL
> 
>         conf = mddev->private // NULL
>          wait_barrier(conf, sector) // null-ptr-deref !
> 
> It is a common problem for raid0/1/10/5, and __md_stop could be triggered
> by several paths(eg. ioctl, sysfs, ->dtr). Fix it by replacing
> mddev_lock() with mddev_suspend_and_lock() for all __md_stop() callers.
> The caller array_state_store() is guaranteed by the check
> mddev_set_closing_and_sync_blockdev(mddev, 0), we just need to remove
> the check '!md_is_rdwr'. For example, someone open /dev/mdx, write
> something and close /dev/mdx, it won't trigger the problem, all dirty
> pages can be flushed before mddev->openers decrement.
> The caller dm_table_destroy() is guaranteed being invoked with device
> suspended, so raid_dtr() could keep using mddev_lock_nointr().
> Besides, fail the submitting IO in md_handle_request() if the
> 'mddev->pers' becomes NULL.
> 
> Fetch a reproducer in https://bugzilla.kernel.org/show_bug.cgi?id=222020
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: syzbot+3fe892ea5fc292e1353f@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3fe892ea5fc292e1353f
> Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
> ---
>   v1->v2:
>    1. Add 'mddev->pers != NULL' check before make_request
>    2. Delete dm-raid caller(->dtr) modifications
>    3. Move memalloc_noio_restore after mddev_unlock_and_resume
>   v2->v3:
>    1. Remove modifications in array_state_store()
>    2. update commit msg
>   v3->v4:
>    1. Remove '!md_is_rdwr' check from array_state_store()
>    2. update commit msg
>   v4->v5:
>    1. Skip checking '!md_is_rdwr' only for inactive case
>   drivers/md/md.c | 17 ++++++++++++++++-
>   1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 680b34a63cb3..02798f2dbf0e 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -414,6 +414,20 @@ bool md_handle_request(struct mddev *mddev, struct bio *bio)
>   		if (!percpu_ref_tryget_live(&mddev->active_io))
>   			goto check_suspended;
>   	}
> +	if (!mddev->pers) {
> +		/*
> +		 * The __md_stop() sets 'mddev->private' to NULL during
> +		 * the IO submitting, check 'mddev->pers' before the IO
> +		 * being processed by specific driver to avoid the
> +		 * null-ptr-deref of 'mddev-><member>'. The check is
> +		 * safe because the IO has got the 'mddev->active_io'
> +		 * reference, and all __md_stop() callers will wait for
> +		 * the reference to be zero.
> +		 */
> +		bio_io_error(bio);
> +		percpu_ref_put(&mddev->active_io);
> +		return true;
> +	}
>   	if (!mddev->pers->make_request(mddev, bio)) {
>   		percpu_ref_put(&mddev->active_io);
>   		if (mddev_is_dm(mddev) && mddev->pers->prepare_suspend)
> @@ -4670,7 +4684,7 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
>   	case readonly:
>   	case inactive:
>   	case read_auto:
> -		if (!mddev->pers || !md_is_rdwr(mddev))
> +		if (!mddev->pers || (st != inactive && !md_is_rdwr(mddev)))
>   			break;
>   		/* write sysfs will not open mddev and opener should be 0 */
>   		err = mddev_set_closing_and_sync_blockdev(mddev, 0);
> @@ -8299,6 +8313,7 @@ static bool md_ioctl_need_suspend(unsigned int cmd)
>   	case HOT_REMOVE_DISK:
>   	case SET_BITMAP_FILE:
>   	case SET_ARRAY_INFO:
> +	case STOP_ARRAY:
>   		return true;
>   	default:
>   		return false;
> 

