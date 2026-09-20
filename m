Received: from va-2-56.ptr.blmpb.com (va-2-56.ptr.blmpb.com [209.127.231.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1245F36215E
	for <linux-raid@vger.kernel.org>; Sun, 20 Sep 2026 04:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789879458; cv=none; b=mZC59Bd4CRgTYEJRXXOWxbz53eLV+0kxKORtrJwTpO982j1lKk4E15BvGX1YFoYh2VNOxEit+C8W40PPgCFMqFpXGn1JPg12U0wnWESIBBjaTWJwB0GMhd7CBDzHLjBfOC7eQD960HXmaHcznbGKC+7ZzhACs+hKooRRH6VAwdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789879458; c=relaxed/simple;
	bh=BqflKFAAP6AuOcEgkKxEPmOLeXcjze/O0+7WHaU7qqo=;
	h=Date:References:To:From:Mime-Version:In-Reply-To:Cc:Subject:
	 Content-Type:Message-Id; b=rTlmfSPwGXoV4Pt7xrDMZ9hy/NJjqcQYDqx78rT/TCExgHX3Re9bh0Og+idYlWSNXQyhG/AGTeZlsPFlM7CHk6Ld94UzomwOvNwZamH1jqpCoz4O3TfU5mfkz5AadeyhtKiNHb2FsnAY2KACxcIaoHlNs1nje0feiMZSVt/BgXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=gsW8ml8X; arc=none smtp.client-ip=209.127.231.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="gsW8ml8X"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1789879440;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=AG9GzthLPeLuU3YNwkQS4FKboAZLYa3nsvotKpK/sTs=;
 b=gsW8ml8XUGHygozkfVDEbffBCzXtXjQT7lgrotWQy9tVOSXly8NxuT+gHHgSQEjQuF6KXy
 dOOv3aVQglRA8TK4XU4nQcm19oQ2IUg2TYN0WpzrF6kPRnLsaRhDFCVjoMorrOo8FNDex/
 /GwmCQI6Jp0wAP4CiNl1IgInzm4Qn1VI7/khyd48aLpbSNDcgBT0yJPma2mwhxcorzJpEb
 CVfAQzOihfm+izTxRengrmHoQ0aZQLhVvUUL9j3whJ/RA97TnVAMTZjE5oN5jHNxW/tzMT
 SIno1R+SGuIThR+YvIn+P8PymK1iqFdwwZaL/BRQkemCGXw7imSYeKjoJeT/kw==
Date: Sun, 20 Sep 2026 12:43:55 +0800
Content-Transfer-Encoding: quoted-printable
References: <20260918070900.1945351-1-chengzhihao1@huawei.com>
To: "Zhihao Cheng" <chengzhihao1@huawei.com>, <song@kernel.org>, 
	<xiao@kernel.org>, <magiclinan@didiglobal.com>, <eadavis@sina.com>, 
	<abd.masalkhi@gmail.com>, "yu kuai" <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
User-Agent: Mozilla Thunderbird
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <20260918070900.1945351-1-chengzhihao1@huawei.com>
X-Original-From: yu kuai <yukuai@fygo.io>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<yangerkun@huawei.com>, <yi.zhang@huawei.com>
Subject: Re: [PATCH v3] md: Fix the null-ptr-deref of 'mddev->private' while submitting IO
Received: from [192.168.1.104] ([39.182.0.142]) by smtp.larksuite.com with ESMTPS; Sun, 20 Sep 2026 04:43:59 +0000
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26aaf648f+6fd1cb+vger.kernel.org+yukuai@fygo.io>
Reply-To: yukuai@fygo.io
Message-Id: <4d4e5f48-d65d-47e3-a143-cd0740d22d27@fygo.io>

Hi=EF=BC=8C

=E5=9C=A8 2026/9/18 15:09, Zhihao Cheng =E5=86=99=E9=81=93:
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
> The caller dm_table_destroy() is guaranteed being invoked with device
> suspended, so raid_dtr() could keep using mddev_lock_nointr().
> The caller array_state_store() is guaranteed by the check
> mddev_set_closing_and_sync_blockdev(mddev, 0). For example, someone open
> /dev/mdx, write something and close /dev/mdx, it won't trigger the
> problem, all dirty pages can be flushed before mddev->openers decrement.
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

In array_state_store(), !md_is_rdwr() checking before mddev_set_closing_and=
_sync_blockdev()
should be removed.

>   drivers/md/md.c | 15 +++++++++++++++
>   1 file changed, 15 insertions(+)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 680b34a63cb3..e73338c26d53 100644
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
