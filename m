Received: from va-2-18.ptr.blmpb.com (va-2-18.ptr.blmpb.com [209.127.231.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA63390CB2
	for <linux-raid@vger.kernel.org>; Tue, 22 Sep 2026 02:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790045084; cv=none; b=IORU/fDFRZhM8ZWFaYkvicwd91lfaoZjYdfc43D/Wp5kVYEw+QERXHqZy0Gw7WOoFgfk5apuvYg+6aTW4+tNHAiOc4qm+CrW4O2pSaWQB/mHFyn3JFP+YXqdGtkAYRxkPCyy8o/uvFX0tTeauujpEvJtrDj7vPB7kWkJqK+dY7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790045084; c=relaxed/simple;
	bh=x2em5mNuONHqyIoHmfD48P3TKsKCShR/RlcK0UgL/Kw=;
	h=To:Subject:Date:Mime-Version:Content-Type:In-Reply-To:References:
	 Cc:From:Message-Id; b=EOcvOs2vMZYBPqLDjwHzSIQnaDQdunah5p+z8KQjrH+XDIDe8jPDaypoME9kWrgufYHfE2NOqXp7v2QSejPJ+7nx2LEKYpn2VcY3y2uycJAcoNlx3nnUw50JkqJpvUAJfw+cggpST35nbcQSX+t4Eg6/9vs5mVQ2z61k5PT4Bw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=inRv0XdG; arc=none smtp.client-ip=209.127.231.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="inRv0XdG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1790045073;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=sxewYyLjblbYVJ+I0ze1jJgD6c+hjfa2aLSRIAX5aBY=;
 b=inRv0XdGu7oAACRvXZV23IRYynkIt7VCAisDeuSnRm4X9WQWlz5Kp6ttOBWqD9yG+Ppqfj
 PWL39grR9fz0Gx7uu9pbJEcrF4cX7PY8MSKvNSbXW4c1mSqlUiZK/TG4tJOGAV608FFi8+
 5+gF5Nv62KGk7VdXiOTVqQ16odGlznN629po4PTNvZ6+C/T0iYdgAqShxvYWRSHi2J/95R
 8eekHtLvw/0Q+H/OupVmjWsSh7K1HpNvDNHY9m6LzVc6BjMn17eb7aySbqGrZ8DxFGvFfN
 5o0jhChiB4vN85/PMDaSggpJFKgbooSlRpHT6wtmMEKQA61UgT4BLTZu6bZcyg==
To: "Zhihao Cheng" <chengzhihao1@huawei.com>, <song@kernel.org>, 
	<magiclinan@didiglobal.com>, <xiao@kernel.org>, <eadavis@sina.com>, 
	<abd.masalkhi@gmail.com>, "yu kuai" <yukuai@fygo.io>
X-Lms-Return-Path: <lba+26ab1eb90+326113+vger.kernel.org+yukuai@fygo.io>
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@fygo.io
Subject: Re: [PATCH v4] md: Fix the null-ptr-deref of 'mddev->private' while submitting IO
Date: Tue, 22 Sep 2026 10:44:28 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20260920063704.3809608-1-chengzhihao1@huawei.com>
Received: from [192.168.1.104] ([39.182.0.164]) by smtp.larksuite.com with ESMTPS; Tue, 22 Sep 2026 02:44:32 +0000
References: <20260920063704.3809608-1-chengzhihao1@huawei.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-raid@vger.kernel.org>, 
	<yangerkun@huawei.com>, <yi.zhang@huawei.com>
From: "yu kuai" <yukuai@fygo.io>
Message-Id: <22bd8d07-fefb-48ec-bc22-2617c4162c02@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>
Content-Transfer-Encoding: quoted-printable

Hi,

=E5=9C=A8 2026/9/20 14:37, Zhihao Cheng =E5=86=99=E9=81=93:
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
>   drivers/md/md.c | 17 ++++++++++++++++-
>   1 file changed, 16 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 680b34a63cb3..d81f5bf3bffe 100644
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
> +		if (!mddev->pers)

This is not really what I mean, the checking should only be removed for the=
 case inactive,
not that changing the array to read_only.

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
