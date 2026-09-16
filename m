Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B4248B38A
	for <linux-raid@vger.kernel.org>; Wed, 16 Sep 2026 12:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789561983; cv=none; b=ZxpLHPFfkEduD7r6lKICXQ1mLzGzpe5NvguwUgIwyDHGci5LQ5XixZbr8JfscXDv0odgeaFAVJ4vgAqu5mJa1cMfIE9QlYtDT4uj2c7Wb7ZLf43hBMuIzykyJLHYMKUIAey+JBcNYh1F/FEbuI4o+gbJZCd+ZEr3gPCtDo80oQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789561983; c=relaxed/simple;
	bh=gOgiMuuCjhLMJYWZlXpzeSMzcvZSPWwhznmzVw/zsEM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JMBcTytze8oKjNSUHWgP/0UiKqIf8g5OVObafpLStLBGlEeMHluN1vLYZownuJvyhZ1lFR+jivVtzMQEmWaNMFkglf09Vi56C8qu1fiDd8Kdn2jaqsLPG/fqac2bN8j/hKAJfkT/QbBuTqMC3gmkRO5c2ff3TTWIOmVL/EtYoe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IRGnssFD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IRGnssFD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77B101F00893;
	Wed, 16 Sep 2026 12:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789561981;
	bh=ThBiEWa+O0MKCWqgHNMN8Uae9/cTWAev9ZVZJtDpMu8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IRGnssFD3nYBTG9jIuYVIZYIKnfBKLZYQ98TQd9Wpu1qdVp8y8RXsY884jnwRsxDy
	 phAyCfJmbPrYcLv7sFqBG1SGsS7jut5dENkkS3EnA9Swm9EkrJiytdXJPy9WSWXkZy
	 fX4C9rQKIm7AHF/xpXe3mNdX2+jBPbxcqcMYYs+tjmkqR+g4mYXUidsu1eMLSNvoMz
	 jzHBeQJzJSMajLcvSZzComXMd5ZVj6pElpKvY5PKBKk7clprSrC72OenVuPgrfsNMq
	 2xSlUFCtEx3+JTdP/PjMp3hhJgj8Wzu7jvnZL85B7uqfZ0BsjOk04QnQLEyrHwREwM
	 VxJ2TuasCwp9Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] md: Fix the null-ptr-deref of 'mddev->private' while
 submitting IO
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhihao Cheng" <chengzhihao1@huawei.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260916121120.1242281-1-chengzhihao1@huawei.com>
References: <20260916121120.1242281-1-chengzhihao1@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 16 Sep 2026 12:33:00 +0000
Message-Id: <20260916123301.77B101F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] md: NULL pointer dereference in md_handle_request() on array t=
eardown
- [High] md: memory reclaim deadlock due to premature memalloc_noio_restore
--

commit 86c9448b538e3d50a408040bfd47956ef0397e1a
Author: Zhihao Cheng <chengzhihao1@huawei.com>

md: Fix the null-ptr-deref of 'mddev->private' while submitting IO

This patch replaces mddev_lock() with mddev_suspend_and_lock() across
__md_stop() callers. It aims to prevent concurrent IO submissions from
dereferencing mddev->private while the array is being torn down.

Closes: https://syzkaller.appspot.com/bug?extid=3D3fe892ea5fc292e1353f

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 680b34a63cb3d..e292acd54bb00 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
[ ... ]
> @@ -4775,7 +4781,12 @@ array_state_store(struct mddev *mddev, const char =
*buf, size_t len)
>  			mddev->hold_active =3D 0;
>  		sysfs_notify_dirent_safe(mddev->sysfs_state);
>  	}
> -	mddev_unlock(mddev);
> +	if (suspend) {
> +		memalloc_noio_restore(noio_flags);
> +		mddev_unlock_and_resume(mddev);

[Severity: Critical]
Could unconditionally resuming the array here lead to a NULL pointer
dereference for trapped IOs?

If an IO is submitted concurrently with array teardown (e.g. sysfs inactive
or STOP_ARRAY ioctl), it is trapped in md_handle_request() by wait_event()
waiting for the array to not be suspended.

The teardown thread sets mddev->pers =3D NULL in md_stop() and then calls
mddev_unlock_and_resume() here. The resumption resurrects active_io and wak=
es
up the trapped IO, which then blindly dereferences mddev->pers:

drivers/md/md.c:md_handle_request() {
        ...
        if (!percpu_ref_tryget_live(&mddev->active_io))
                goto check_suspended;
        }
        if (!mddev->pers->make_request(mddev, bio)) {
        ...
}

[Severity: High]
Is there a risk of a memory reclaim deadlock due to the NOIO restoration or=
der
here?

By restoring NOIO flags before calling mddev_unlock_and_resume(), we run
mddev_unlock() without NOIO protection while the array is still suspended:

drivers/md/md.h:mddev_unlock_and_resume() {
        mddev_unlock(mddev);
        mddev_resume(mddev);
}

If memory reclaim is triggered by allocations inside mddev_unlock() and tri=
es
to submit IO to this suspended array, it will block indefinitely waiting for
the array to resume, preventing this thread from ever reaching mddev_resume=
().

> +	} else {
> +		mddev_unlock(mddev);
> +	}
> =20
>  	if (st =3D=3D readonly || st =3D=3D read_auto || st =3D=3D inactive ||
>  	    (err && st =3D=3D clear))
[ ... ]
> @@ -8299,6 +8310,7 @@ static bool md_ioctl_need_suspend(unsigned int cmd)
>  	case HOT_REMOVE_DISK:
>  	case SET_BITMAP_FILE:
>  	case SET_ARRAY_INFO:
> +	case STOP_ARRAY:

[Severity: Critical]
Might unconditionally suspending and then resuming the array during STOP_AR=
RAY
lead to a similar NULL pointer dereference for trapped IOs?

Because STOP_ARRAY now returns true here, the existing logic in md_ioctl()
will suspend the array, call do_md_stop(), and then unconditionally restore
NOIO flags and call mddev_unlock_and_resume(mddev).

This allows trapped IOs waiting in md_handle_request() to wake up after
mddev->pers has been cleared, resulting in a NULL pointer dereference when
they attempt to call mddev->pers->make_request().

[Severity: High]
Will this NOIO restoration order cause the same memory reclaim deadlock in =
the
ioctl path?

As in the sysfs path, md_ioctl() now suspends and later restores NOIO before
mddev_unlock_and_resume(mddev), risking a deadlock if allocations within
mddev_unlock() trigger reclaim that submits IO to the suspended array:

drivers/md/md.c:md_ioctl() {
        ...
        if (suspend) {
                memalloc_noio_restore(noio_flags);
                mddev_unlock_and_resume(mddev);
        ...
}

>  		return true;
>  	default:
>  		return false;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260916121120.1242=
281-1-chengzhihao1@huawei.com?part=3D1
