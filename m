Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60363448391
	for <linux-raid@vger.kernel.org>; Mon,  7 Sep 2026 14:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788789633; cv=none; b=H84BJGnvD01gxS8n/3C++w5x690FgCYnTDixS2yB/VfJjZUm0h+/vVAgVipwulCPolR9tLLc4OmMKaYEKEI47IH2mLkmUctLOWYcHcP6JpY/ItAEGea1ZU+LV8ylBArjjwJQhE1UHTqlUmz2o8Zexj6XN5qGtctO64IZjvJSJuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788789633; c=relaxed/simple;
	bh=xfuoaY1XKFi6r0RE4Ntd4z93QjXtSG7mDEitUcTqsIM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BldAVh88C5i6Xk5kkFLp4uednOmQnUMpMGOPseZgkfGF3D05bKs+ARF5JfJaFw3Gef1hIkxxBamAgCttXeyczw/UeerzDVkRMH3aJ+tkGp3WNNGtKzI3eNJ2qpUC5LDpeBVRqbNdtDqbH7FxiH/RDsvzkpCqLgnjV+89rL6eVx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nCdhoIPC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nCdhoIPC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C781F1F00A3D;
	Mon,  7 Sep 2026 14:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788789632;
	bh=d89V0UxEF8CTxUg0HRGGy3/XCIvp2WRk8qQFPvX2RaE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nCdhoIPC3MS3aj0HBnadxtJ/r0rKJba0mZSvRcyqIVvEuHkla89um3axZQaPz8duF
	 PHp1JhBCsFCPYHdak3NQBC2VcI8+mGWcFr4oFA7MkN0X/Ocpe4GFETL3Qrpo+dlqIY
	 Xaj6OllzaJhd43bdNFmNHehs9liY5O5xR4labHKhQXaTziB+X207cwfivDuS9kB34M
	 LC6C0wKFnNlQKsi0pbGNMiZPaN9oYW9BgD7wqwhn/xcs1gZdiXV3ie921PB4Ru/DnB
	 SE1elnZY/muqvJO0ieQ9IfaPwvNdTyt+L36IpGFpzNXmU8Dt3JZwvjYjTIx9pET0u9
	 WyZKkxX7Q0cfw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6/6] md: take q->limits_lock before locking and
 suspending the array
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jack Wang" <jinpu.wang@ionos.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260907133929.1081540-7-jinpu.wang@ionos.com>
References: <20260907133929.1081540-1-jinpu.wang@ionos.com>
 <20260907133929.1081540-7-jinpu.wang@ionos.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 14:00:31 +0000
Message-Id: <20260907140031.C781F1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Medium] queue_limits_commit_update() return value is ignored and called =
unconditionally on error paths instead of queue_limits_cancel_update()

Pre-existing issues:
- [High] ABBA deadlock between q->limits_lock and mddev_suspend in level_st=
ore()
--

commit ecb6e260e45c52011fdf103645ad33814409ccd9
Author: Jack Wang <jinpu.wang@cloud.ionos.com>

md: take q->limits_lock before locking and suspending the array

This commit updates the block layer limits locking order for MD devices to
prevent a deadlock when writing queue limits attributes during disk operati=
ons.
It takes the limits update before locking and suspending the array, passing=
 it
down into personality stacks.

> Two callers still take the lock inside reconfig_mutex, both with the
> array suspended: ->start_reshape() from action_store(), which suspends
> before flushing sync_work so the update cannot be held across it, and
> raid*_run() -> queue_limits_set() from level_store(), which already
> hangs on its own because it freezes the queue while suspended.

[Severity: High]
This is a pre-existing issue, but is there a plan to address the ABBA
deadlock in level_store()? When the array is suspended and locked, normal
I/O parks on the queue usage counter. Concurrently, a udev sysfs write can
take q->limits_lock and wait in blk_mq_freeze_queue() for the counter to
drain, while level_store() holds the suspend lock and waits for
q->limits_lock via pers->run() -> queue_limits_set(), causing a system
hang.

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -3780,15 +3783,37 @@ rdev_attr_store(struct kobject *kobj, struct attr=
ibute *attr,
[ ... ]
>  	rv =3D suspend ? mddev_suspend_and_lock(mddev) : mddev_lock(mddev);
>  	if (!rv) {
>  		if (rdev->mddev =3D=3D NULL)
>  			rv =3D -ENODEV;
>  		else
> -			rv =3D entry->store(rdev, page, length, NULL);
> +			rv =3D entry->store(rdev, page, length, limp);
> +		/* apply the limits before the array takes I/O again */
> +		if (limp) {
> +			queue_limits_commit_update(q, limp);
> +			limp =3D NULL;
> +		}

[Severity: Medium]
Are we missing a check for the return value of queue_limits_commit_update()
here? If the block layer rejects the new limits because blk_validate_limits=
()
fails, the return value is ignored. This could allow the array to proceed
using the new disk with old limits, risking I/O errors if requests exceed
the disk's hardware limits.

>  		suspend ? mddev_unlock_and_resume(mddev) : mddev_unlock(mddev);
>  	}
> =20
> +	if (limp)
> +		queue_limits_commit_update(q, limp);
> +

[Severity: Medium]
Does this code incorrectly call queue_limits_commit_update() unconditionally
on error paths? If mddev_suspend_and_lock() or mddev_lock() failed, rv will
be non-zero but limp will still be set. In this situation, the code will
commit unchanged limits instead of cancelling them via
queue_limits_cancel_update().

[ ... ]
> @@ -8618,6 +8673,9 @@ static int md_ioctl(struct block_device *bdev, blk_=
mode_t mode,
>  	    err !=3D -EINVAL)
>  		mddev->hold_active =3D 0;
> =20
> +	if (limp)
> +		queue_limits_commit_update(q, limp);
> +

[Severity: Medium]
Similar to the rdev_attr_store() issue above, should this use
queue_limits_cancel_update() on error paths? If an inner ioctl command
fails, this will erroneously commit the unchanged limits rather than
cancelling the update.

[ ... ]
> @@ -10419,6 +10497,8 @@ static void md_start_sync(struct work_struct *ws)
>  	 *     https://bugzilla.kernel.org/show_bug.cgi?id=3D218200
>  	 * Therefore, use __mddev_resume(mddev, false).
>  	 */
> +	if (limp)
> +		queue_limits_commit_update(q, limp);

[Severity: Medium]
Does this safely handle limit validation failures when adding spares? The
return value is ignored, which could leave the array with outdated limits if
the limits fail to stack correctly.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907133929.1081=
540-1-jinpu.wang@ionos.com?part=3D6
