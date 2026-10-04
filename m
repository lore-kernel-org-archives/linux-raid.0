Received: from va-2-58.ptr.blmpb.com (va-2-58.ptr.blmpb.com [209.127.231.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64DBE346E64
	for <linux-raid@vger.kernel.org>; Sun,  4 Oct 2026 15:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791129303; cv=none; b=Qe/JbPdW5Gc6xGko6Cin0ksJPY3Sh/GFsxw9Nj9BC9tBFRSRAGS5xdqwdeHAk3c6MNuGJ8Qy4Q7Cq86TrmFq98SFgnrxYjssg+h6nrkPeHp2BVQr1W9Ft/ngmaGvbOPuSmJqqKpEPqM7GKOqPmLtx1itCxGoPz7wpUWSzqOBxgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791129303; c=relaxed/simple;
	bh=rtPD//bWwu393dOBBUWZx/CheiAozL89AO3KCZYdFBA=;
	h=References:Cc:From:In-Reply-To:Subject:Message-Id:Date:
	 Mime-Version:Content-Type:To; b=q5yI+2Z8uKrxEm4c0e0iJ2j362ZvtRBLae5hly4BllBNVxG4ZCc7MZIS6sTzVelzl9+9P7QnRymGVrEzVmXPsogZb1S0wQj/duqqnNIs+3N0kL4r8uxCyE/u+tWgtiy2SZb7bB2WlkIyLDq94vLxJFXE4gkIKsJSlGlrvGLluWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=VxkqIgNd; arc=none smtp.client-ip=209.127.231.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="VxkqIgNd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1791129290;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=4vryk1DEKogU2H6y67+W/lTNTWEftQjvJaN1iwXNBN0=;
 b=VxkqIgNdFSXgDlEg4vTk0Ru7sakLFC9itHcH++xpFjUIEbeHx+t0T9M3cCP/CVEuC/oEkp
 07dOkEF/URi3GdYk34iNCzwaK00A/ymN+9k3qm+VMtGxeNTNEVVP6D4pNw5+gg0lnr8aKI
 suwUEfvs0ee0FXSdpbPvS/U5GUZPTdEaBSdE5Ul0sSklPw2LugrLwyyoUTavxGiFaCVKRC
 Qz80P8uxN5tRCf1DMvbh91T0GbyyLTs2+pPloQ3avehuU/woYAPkJ8p02vSxKw08i/sWnF
 uQOH10Lw4QMFGuYUQQdxyPtQx2NwTr8hT/6Lw/N7dm6Dh/pGM7ZS2WIW9gcqtA==
References: <20261003101948.1690687-1-dayou5941@163.com>
Cc: <magiclinan@didiglobal.com>, <xiao@kernel.org>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	"Li Youhong" <liyouhong@kylinos.cn>, 
	<syzbot+89a9ab2a134d092fffae@syzkaller.appspotmail.com>
From: "yu kuai" <yukuai@fygo.io>
In-Reply-To: <20261003101948.1690687-1-dayou5941@163.com>
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] md: drain active_io before clearing pers on stop
Message-Id: <44ca54b6-9012-4d25-93ff-743c34231c2b@fygo.io>
X-Lms-Return-Path: <lba+26ac276c9+f57c47+vger.kernel.org+yukuai@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>
Received: from [192.168.1.104] ([39.182.0.177]) by smtp.larksuite.com with ESMTPS; Sun, 04 Oct 2026 15:54:48 +0000
Reply-To: yukuai@fygo.io
Date: Sun, 4 Oct 2026 23:54:45 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "Li Youhong" <dayou5941@163.com>, <song@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
User-Agent: Mozilla Thunderbird

Hi,

=E5=9C=A8 2026/10/3 18:19, Li Youhong =E5=86=99=E9=81=93:
> From: Li Youhong <liyouhong@kylinos.cn>
>
> STOP_ARRAY clears mddev->pers while a direct bio can already be in
> md_handle_request(). fork() shares the block-device file, so openers
> stays 1 and the stop is allowed, and sync_blockdev() does not wait for
> O_DIRECT. The bio passes the pers check in md_submit_bio(), then pers
> is cleared and md_handle_request() dereferences pers->make_request.
>
> Suspend the array before __md_stop() so percpu_ref_kill(active_io) makes
> later tryget_live fail and the wait runs until every make_request holder
> has dropped the ref. The suspend taken here is resumed after pers is
> cleared, which wakes bios blocked in md_handle_request(). They see
> pers =3D=3D NULL and complete with bio_io_error(). dm-raid already holds
> its own suspend across md_stop() and that path is unchanged.
>
> reconfig_mutex is dropped around mddev_suspend() and mddev_resume().
> stop_draining is set across that window so mddev_lock() returns
> -EBUSY.
>
> Reported-by: syzbot+89a9ab2a134d092fffae@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D89a9ab2a134d092fffae
> Fixes: 409c57f38017 ("md: enable suspend/resume of md devices.")
> Signed-off-by: Li Youhong <liyouhong@kylinos.cn>
> ---
>   drivers/md/md.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++---
>   drivers/md/md.h |  7 ++++++
>   2 files changed, 66 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 680b34a63cb3..85158a99277f 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -395,6 +395,8 @@ static bool is_suspended(struct mddev *mddev, struct =
bio *bio)
>  =20
>   bool md_handle_request(struct mddev *mddev, struct bio *bio)
>   {
> +	struct md_personality *pers;
> +
>   check_suspended:
>   	if (unlikely(md_cloned_bio(mddev, bio))) {
>   		/*
> @@ -402,6 +404,12 @@ bool md_handle_request(struct mddev *mddev, struct b=
io *bio)
>   		 * active_io reference, so percpu_ref_get() is safe here.
>   		 */
>   		percpu_ref_get(&mddev->active_io);
> +		pers =3D READ_ONCE(mddev->pers);
> +		if (!pers) {
> +			percpu_ref_put(&mddev->active_io);
> +			bio_io_error(bio);
> +			return true;
> +		}
>   	} else {
>   		if (is_suspended(mddev, bio)) {
>   			/* Bail out if REQ_NOWAIT is set for the bio */
> @@ -409,14 +417,20 @@ bool md_handle_request(struct mddev *mddev, struct =
bio *bio)
>   				bio_wouldblock_error(bio);
>   				return true;
>   			}
> -			wait_event(mddev->sb_wait, !is_suspended(mddev, bio));
> +			wait_event(mddev->sb_wait, !is_suspended(mddev, bio) ||
> +				   !READ_ONCE(mddev->pers));
> +		}
> +		pers =3D READ_ONCE(mddev->pers);
> +		if (!pers) {
> +			bio_io_error(bio);
> +			return true;
>   		}
>   		if (!percpu_ref_tryget_live(&mddev->active_io))
>   			goto check_suspended;
>   	}
> -	if (!mddev->pers->make_request(mddev, bio)) {
> +	if (!pers->make_request(mddev, bio)) {
>   		percpu_ref_put(&mddev->active_io);
> -		if (mddev_is_dm(mddev) && mddev->pers->prepare_suspend)
> +		if (mddev_is_dm(mddev) && pers->prepare_suspend)
>   			return false;
>   		goto check_suspended;
>   	}
> @@ -7097,6 +7111,32 @@ static void __md_stop(struct mddev *mddev)
>   	clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
>   }
>  =20
> +/* Drop reconfig_mutex around suspend so in-flight IO can update the sup=
erblock. */
> +static int md_suspend_for_stop(struct mddev *mddev, bool interruptible)
> +{
> +	int err;
> +
> +	lockdep_assert_held(&mddev->reconfig_mutex);
> +
> +	WRITE_ONCE(mddev->stop_draining, 1);
> +	mutex_unlock(&mddev->reconfig_mutex);

Creating a new wheel will just make code more complicated. Check following =
patch for the
correct fix:

[PATCH v5] md: Fix the null-ptr-deref of 'mddev->private' while=20
submitting IO - Zhihao Cheng <https://lore.kernel.org/all/20260922030538.16=
34904-1-chengzhihao1@huawei.com/>

> +	err =3D mddev_suspend(mddev, interruptible);
> +	mddev_lock_nointr(mddev);
> +	WRITE_ONCE(mddev->stop_draining, 0);
> +	return err;
> +}
> +
> +static void md_resume_for_stop(struct mddev *mddev)
> +{
> +	lockdep_assert_held(&mddev->reconfig_mutex);
> +
> +	WRITE_ONCE(mddev->stop_draining, 1);
> +	mutex_unlock(&mddev->reconfig_mutex);
> +	__mddev_resume(mddev, false);
> +	mddev_lock_nointr(mddev);
> +	WRITE_ONCE(mddev->stop_draining, 0);
> +}
> +
>   void md_stop(struct mddev *mddev)
>   {
>   	lockdep_assert_held(&mddev->reconfig_mutex);
> @@ -7164,6 +7204,8 @@ static int do_md_stop(struct mddev *mddev, int mode=
)
>   	struct gendisk *disk =3D mddev->gendisk;
>   	struct md_rdev *rdev;
>   	int did_freeze =3D 0;
> +	int err =3D 0;
> +	int resume =3D 0;
>  =20
>   	if (!test_bit(MD_RECOVERY_FROZEN, &mddev->recovery)) {
>   		did_freeze =3D 1;
> @@ -7181,6 +7223,18 @@ static int do_md_stop(struct mddev *mddev, int mod=
e)
>   		}
>   		return -EBUSY;
>   	}
> +
> +	if (mddev->pers) {
> +		err =3D md_suspend_for_stop(mddev, true);
> +		if (err) {
> +			if (did_freeze) {
> +				clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> +				set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> +			}
> +			return err;
> +		}
> +		resume =3D 1;
> +	}
>   	if (mddev->pers) {
>   		if (!md_is_rdwr(mddev))
>   			set_disk_ro(disk, 0);
> @@ -7205,6 +7259,8 @@ static int do_md_stop(struct mddev *mddev, int mode=
)
>   		if (!md_is_rdwr(mddev))
>   			mddev->ro =3D MD_RDWR;
>   	}
> +	if (resume)
> +		md_resume_for_stop(mddev);
>   	/*
>   	 * Free resources if final stop
>   	 */
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index b6d2e8929a0f..745f0c57f669 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -414,6 +414,8 @@ struct mddev {
>   	unsigned long			sb_flags;
>  =20
>   	int				suspended;
> +	/* Set while do_md_stop() has dropped reconfig_mutex to drain IO. */
> +	int				stop_draining;
>   	struct mutex			suspend_mutex;
>   	struct percpu_ref		active_io;
>   	int				ro;
> @@ -719,6 +721,11 @@ static inline int __must_check mddev_lock(struct mdd=
ev *mddev)
>   		ret =3D -ENODEV;
>   		mutex_unlock(&mddev->reconfig_mutex);
>   	}
> +	/* do_md_stop() is waiting for active_io with the mutex dropped. */
> +	if (!ret && READ_ONCE(mddev->stop_draining)) {
> +		ret =3D -EBUSY;
> +		mutex_unlock(&mddev->reconfig_mutex);
> +	}
>  =20
>   	return ret;
>   }

--=20
Thanks,
Kuai
