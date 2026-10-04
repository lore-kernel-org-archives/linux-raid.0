Received: from va-2-55.ptr.blmpb.com (va-2-55.ptr.blmpb.com [209.127.231.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA933C1983
	for <linux-raid@vger.kernel.org>; Sun,  4 Oct 2026 15:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791129103; cv=none; b=r7l2Xi96if0YFd9w0WbskN2O4rHljmq3LXktcaal9TL11w7vdY7CBkAtQvnsCdKYXlMwLH3vfaXEJfFjPVJzzkLM7RU20BIJ6XFJnyYVIwBq15+6bRaEWNZwnqjRqcxp9MCVN9IOwgrnddd2L0/6Sx8tvvRUvo5fVj13AM1fWdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791129103; c=relaxed/simple;
	bh=JYfSDbevSyklrFpxJ/wTrpgYy/neyqm9a6uWSluHa+U=;
	h=Content-Type:Subject:To:Cc:From:Mime-Version:References:Date:
	 Message-Id:In-Reply-To; b=F6m8C5QFwOh9ohImW7hx8PT4FyKBjZEWJW6uumsEj3RZbRyqxsTL6eHyGOjrA5sqToGN1OEurdtpoR2aVfLxt2LtMQjCibU1y72DfnmV+UnXs+LxAiM3nUWP/MiogZkEPVqf8ZWcfoB0Ah/skqPAAZ/BUrLQGu7HJpG80+NMTsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=L3Ao1wLJ; arc=none smtp.client-ip=209.127.231.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="L3Ao1wLJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1791129083;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=N0IBTDh9NOUscIgRtt+2unFn8HLJ72nJ0CB0mU61Q9Q=;
 b=L3Ao1wLJioIMwWdagYezGOv0RneyqwjZ6HcbRdW7BH26SPOTD8YYQmD2iC9Te2Fm7ZZtOt
 EQCtIz6Nt0drrbBZ7bCSD3Z+y1R4se8Hb6B7HPdYZuX5z5TythzmgYVZO6+QGyn0lbuMQ9
 fRJ9MWqYeqg+UUZN1WzzvwhuDJw2IEs0xxWU/HLJfp5rh2vJQ8fM4muwO5ZlEY0VToSwaj
 SBfSWVOv9OYRGUmMM+oeIyrtY0C1ATPga3LOVKfmpC2K7ywj7GuH2o1fYIqY/uHr9gW/uR
 v4g5lbCMfo/mQsaujV8lupc/wRsuhrCQPcrYT2Zs2GTUQhZbWbqj8pUIVVCeFA==
Content-Type: text/plain; charset=UTF-8
Subject: Re: [PATCH v5] md: Fix the null-ptr-deref of 'mddev->private' while submitting IO
Content-Transfer-Encoding: quoted-printable
User-Agent: Mozilla Thunderbird
To: "Zhihao Cheng" <chengzhihao1@huawei.com>, <song@kernel.org>, 
	<magiclinan@didiglobal.com>, <xiao@kernel.org>, <eadavis@sina.com>, 
	<abd.masalkhi@gmail.com>, "yu kuai" <yukuai@fygo.io>
Cc: <linux-kernel@vger.kernel.org>, <yangerkun@huawei.com>, 
	<yi.zhang@huawei.com>, 
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
From: "yu kuai" <yukuai@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260922030538.1634904-1-chengzhihao1@huawei.com>
Received: from [192.168.1.104] ([39.182.0.177]) by smtp.larksuite.com with ESMTPS; Sun, 04 Oct 2026 15:51:22 +0000
Reply-To: yukuai@fygo.io
Date: Sun, 4 Oct 2026 23:51:18 +0800
Message-Id: <f02cbef7-4a8b-440b-894d-af91df7bdf76@fygo.io>
In-Reply-To: <20260922030538.1634904-1-chengzhihao1@huawei.com>
X-Lms-Return-Path: <lba+26ac275fa+7e1b2c+vger.kernel.org+yukuai@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>

Hi,

=E5=9C=A8 2026/9/22 11:05, Zhihao Cheng =E5=86=99=E9=81=93:
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
>    fd =3D open(/dev/md0, O_RDWR)
> 	                      P2 (forked from P1, fd' <=3D fd)
>    write(fd)
>     submit_bio
>      md_handle_request
>       raid1_make_request
>        raid1_write_request
>                                    ioctl(fd, STOP_ARRAY)
> 		                   mddev_set_closing_and_sync_blockdev
> 				   // check passed, mddev->openers =3D 1,
> 				   // because md_open() is only called
> 				   // once in P1->open
> 				   do_md_stop
> 				    __md_stop
> 				     mddev->private =3D NULL
>
>         conf =3D mddev->private // NULL
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
> Fetch a reproducer in https://bugzilla.kernel.org/show_bug.cgi?id=3D22202=
0
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: syzbot+3fe892ea5fc292e1353f@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D3fe892ea5fc292e1353f
> Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
> ---
>   v1->v2:
>    1. Add 'mddev->pers !=3D NULL' check before make_request
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

This patch is missed because it's not in patchwork. :(

Applied to md-7.4

>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 680b34a63cb3..02798f2dbf0e 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -414,6 +414,20 @@ bool md_handle_request(struct mddev *mddev, struct b=
io *bio)
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
> @@ -4670,7 +4684,7 @@ array_state_store(struct mddev *mddev, const char *=
buf, size_t len)
>   	case readonly:
>   	case inactive:
>   	case read_auto:
> -		if (!mddev->pers || !md_is_rdwr(mddev))
> +		if (!mddev->pers || (st !=3D inactive && !md_is_rdwr(mddev)))
>   			break;
>   		/* write sysfs will not open mddev and opener should be 0 */
>   		err =3D mddev_set_closing_and_sync_blockdev(mddev, 0);
> @@ -8299,6 +8313,7 @@ static bool md_ioctl_need_suspend(unsigned int cmd)
>   	case HOT_REMOVE_DISK:
>   	case SET_BITMAP_FILE:
>   	case SET_ARRAY_INFO:
> +	case STOP_ARRAY:
>   		return true;
>   	default:
>   		return false;

--=20
Thanks,
Kuai
