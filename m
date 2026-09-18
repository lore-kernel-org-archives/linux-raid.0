Received: from va-2-60.ptr.blmpb.com (va-2-60.ptr.blmpb.com [209.127.231.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB26C33A700
	for <linux-raid@vger.kernel.org>; Fri, 18 Sep 2026 06:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.60
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789711595; cv=none; b=ujl+IjZNUuBfQvYZyXRRIyLwEvzQjipxptCfNW5xMgiQtwJ+ZcgpehKG/fI63Uiqc0lEAvsClo6xSpYI83sgfVgVAavTEOTHpfP6oocbIkzpR6fMHtsV9fSKVTiP9BS6uSVRUEcdepZPxZupcVJF5Atv9mZp1XHMvTgjy2BjMyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789711595; c=relaxed/simple;
	bh=cYNPLQlMsc61Ae0pd3Dqi84O95BpRIU6+9o8jeZXm04=;
	h=From:Date:Message-Id:Mime-Version:Content-Type:In-Reply-To:To:Cc:
	 Subject:References; b=ZZ+wg1mmFurtMcCwvK4pG84qMVIbC0mfoUHe20NVXxp7VSWUhoMOA0N8fCIx3mjom6F8ROsaWURH4h/5mu/4ONnvPpGimDtJkg+s65+D7TYkr/nj9Ac585bAp+FEzSETTgEpa/SyLlb8RAB9c+2WNJ+hqDrmGpaD0xBNot8NjHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=RM1wv/nn; arc=none smtp.client-ip=209.127.231.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="RM1wv/nn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1789711577;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=lqW7qZabmWxswye34J0CAFYr5tIhfPWj+VejfW6v0n0=;
 b=RM1wv/nn6ci4C12kuVCdnUokvtpsbFeCzP8jJ969yBEmeZyz/IPyxb29lCF5P6X9J1ze/C
 UHl5uDu9Nc0P+B4VWpVqB6/7R69LeOjrkF/BdwIR3QXIZPxh1PlJDz228+rsIsVxZVfF73
 1Ue7hDe+v00PDrGcW3l17dtDF6LfU27Je6qKBDZC71MtaDegP3+HcoUm97cC5zb5LL+eTe
 t4qoRQlr7FmQ3DjqTFAaR4Hg2cB4Z91+LOeNGgSv1UOuoQDawi+XdRzU3OjHU1Q43JoR/T
 PVr6RJjC1JHal17PfAq49iZTh6jxFLAmBsRBDgoCmny7fzqpP6nqpwlJiBxpSg==
From: "yu kuai" <yukuai@fygo.io>
Date: Fri, 18 Sep 2026 14:06:12 +0800
Message-Id: <d896d273-ac1b-484c-9a71-cb60a85d389b@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20260917024205.2331019-1-chengzhihao1@huawei.com>
Reply-To: yukuai@fygo.io
Received: from [192.168.1.104] ([39.182.0.142]) by smtp.larksuite.com with ESMTPS; Fri, 18 Sep 2026 06:06:16 +0000
X-Original-From: yu kuai <yukuai@fygo.io>
To: "Zhihao Cheng" <chengzhihao1@huawei.com>, <song@kernel.org>, 
	<xiao@kernel.org>, <magiclinan@didiglobal.com>, <eadavis@sina.com>, 
	<abd.masalkhi@gmail.com>, "yu kuai" <yukuai@fygo.io>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<yangerkun@huawei.com>, <yi.zhang@huawei.com>
Subject: Re: [PATCH v2] md: Fix the null-ptr-deref of 'mddev->private' while submitting IO
X-Lms-Return-Path: <lba+26aacd4d9+c59cec+vger.kernel.org+yukuai@fygo.io>
References: <20260917024205.2331019-1-chengzhihao1@huawei.com>
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: quoted-printable

Hi,

=E5=9C=A8 2026/9/17 10:42, Zhihao Cheng =E5=86=99=E9=81=93:
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
> It is a common problem for raid0/1/10/5, and __md_stop could be
> triggered by several paths(eg. ioctl, sysfs, ->dtr). Fix it by
> replacing mddev_lock() with mddev_suspend_and_lock() for all
> __md_stop() callers. The caller dm_table_destroy() is guaranteed
> being invoked with device suspended, so raid_dtr() could keep
> using mddev_lock_nointr(). Besides, fail the submitting IO in
> md_handle_request() if the 'mddev->pers' becomes NULL.
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
>   drivers/md/md.c | 32 +++++++++++++++++++++++++++++---
>   1 file changed, 29 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 680b34a63cb3..3dfc34caa2dc 100644
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
> @@ -4657,6 +4671,8 @@ array_state_store(struct mddev *mddev, const char *=
buf, size_t len)
>   {
>   	int err =3D 0;
>   	enum array_state st =3D match_word(buf, array_states);
> +	unsigned int noio_flags =3D 0;
> +	bool suspend =3D false;
>  =20
>   	/* No lock dependent actions */
>   	switch (st) {
> @@ -4666,9 +4682,11 @@ array_state_store(struct mddev *mddev, const char =
*buf, size_t len)
>   	case broken:		/* cannot be set */
>   	case bad_word:
>   		return -EINVAL;
> +	case inactive:
>   	case clear:
> +		suspend =3D true;
> +		fallthrough;
>   	case readonly:
> -	case inactive:
>   	case read_auto:
>   		if (!mddev->pers || !md_is_rdwr(mddev))
>   			break;
> @@ -4702,9 +4720,11 @@ array_state_store(struct mddev *mddev, const char =
*buf, size_t len)
>   		spin_unlock(&mddev->lock);
>   		return err ?: len;
>   	}
> -	err =3D mddev_lock(mddev);
> +	err =3D suspend ? mddev_suspend_and_lock(mddev) : mddev_lock(mddev);

Unlike ioctl path, where the checking of opener is just 1, mddev_set_closin=
g_and_sync_blockdev() here
already check there is no opener, so there can't be any IO inflight.

>   	if (err)
>   		return err;
> +	if (suspend)
> +		noio_flags =3D memalloc_noio_save();
>  =20
>   	switch (st) {
>   	case inactive:
> @@ -4775,7 +4795,12 @@ array_state_store(struct mddev *mddev, const char =
*buf, size_t len)
>   			mddev->hold_active =3D 0;
>   		sysfs_notify_dirent_safe(mddev->sysfs_state);
>   	}
> -	mddev_unlock(mddev);
> +	if (suspend) {
> +		mddev_unlock_and_resume(mddev);
> +		memalloc_noio_restore(noio_flags);
> +	} else {
> +		mddev_unlock(mddev);
> +	}
>  =20
>   	if (st =3D=3D readonly || st =3D=3D read_auto || st =3D=3D inactive ||
>   	    (err && st =3D=3D clear))
> @@ -8299,6 +8324,7 @@ static bool md_ioctl_need_suspend(unsigned int cmd)
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
