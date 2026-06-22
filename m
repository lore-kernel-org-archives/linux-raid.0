Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA91281525
	for <linux-raid@vger.kernel.org>; Mon, 22 Jun 2026 12:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782131156; cv=none; b=NjWKw2O7GpCf9mi2+wE5rURYDB1a9sfs8EWsHtyhUmpwYH9s/m4qksPFFfmFJ9FaYTWteeAq7aSrpyL4SC0N0l7U2d5w4BnP7mpgy46eIHCvmEkMbfzr/I3yJtAlGIb0INk3/Xa6IS3OdynFkJteuDPUaNKU7yVEZf7dbZ33554=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782131156; c=relaxed/simple;
	bh=JiDKfE+HgIuNk9GGi/ds75cx+LLFt4H8AUHQgudtSS0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Ne5DdxIFfy8C2s6DrJLK70LzAad9nbhuoQ4OvCZ6ixGgNIuSHR/T0+wr3cOCH/j9ySS0GNwcipv59HISHOGNe8VBitom3y+4OodCFGuwXqvR5y+ann4MrPGH/GlgRDa094rJ7N+c+bIl/RqYZOqZhFvs/vcrYRE6jdHJWYfO/nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R4v0BIma; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R4v0BIma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E43991F000E9;
	Mon, 22 Jun 2026 12:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782131155;
	bh=eHfuFin0hXlsrV0Uy8A4K0UG7pdhr16hXIWDJ5wNzaE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=R4v0BImaw2JgcuN3/X8g2qiu9nC5SPkzmAnIlM9Pxdm3icV4tQm52SZLQKLWM+aDe
	 VMJJ/CLtNan9mHc3F1N2ZjzBgJdx2RVni3cgDwSO3nOYO/hGNSa6rpBi+VsqN1OkvQ
	 7DLPknSYj9w39tSdDYW5BBrLT/XnBHbpQ2SU9BieNAt37dRu24swsY+g8XtVRCebZn
	 A8LZ3mkbFluCLcparfLdPtH/A6CcfOKhjAxOubzMY7QRLoTQ4SalDg9nNx7dndK01K
	 7zmGiShI7w6qj/ZP7uAi5x20Dml/BZbCVd6qS2mQovMCt2BOpTN9kLtx/PDIJXcHrI
	 BQqxcRWlTA80Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 1/3] md: suspend array when sync_action=reshape
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chen Cheng" <chencheng@fnnas.com>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260622121312.1775322-2-chencheng@fnnas.com>
References: <20260622121312.1775322-1-chencheng@fnnas.com>
 <20260622121312.1775322-2-chencheng@fnnas.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 22 Jun 2026 12:25:54 +0000
Message-Id: <20260622122554.E43991F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

New issues:
- [High] Unmatched mddev_resume() on mddev_lock() failure causes mddev->sus=
pended underflow.
- [High] The retry loop bypasses array re-suspension but leaves the suspend=
ed flag set, causing unprotected reshape and double-resume.
- [High] Suspending the array before calling flush_work() creates a circula=
r memory reclaim deadlock.

Pre-existing issues:
- [High] Cross-task corruption of PF_MEMALLOC_NOIO flags when mddev_suspend=
() and mddev_resume() are interleaved.
--

commit ec573079e939aa92bfb3fd89247846ae57883ef2
Author: Chen Cheng <chencheng@fnnas.com>

md: suspend array when sync_action=3Dreshape

This patch suspends the md array before starting a reshape operation to
prevent new requests from allocating objects from the old pool during
the transition. The array is then resumed on exit.

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 096bb64e87bd5..e139f36e30b92 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5258,26 +5258,37 @@ static ssize_t
>  action_store(struct mddev *mddev, const char *page, size_t len)
>  {
>  	int ret;
> +	bool suspended =3D false;
>  	enum sync_action action;
> =20
>  	if (!mddev->pers || !mddev->pers->sync_request)
>  		return -EINVAL;
> =20
> +	action =3D md_sync_action_by_name(page);
> +	if (action =3D=3D ACTION_RESHAPE) {
> +		ret =3D mddev_suspend(mddev, true);

[Severity: High]
This is a pre-existing issue, but does calling mddev_suspend() and
mddev_resume() from concurrent contexts risk corrupting the PF_MEMALLOC_NOIO
task flags?

When mddev_suspend() is called, it stores the task-specific NOIO flag into
the global mddev structure:

drivers/md/md.c:mddev_suspend() {
    ...
    mddev->noio_flag =3D memalloc_noio_save();
    ...
}

If two tasks concurrently enter mddev_suspend(), the second task increments
the suspend counter without overwriting mddev->noio_flag. If the first task
then resumes (e.g., on a lock failure) it decrements the counter but return=
s=20
early because the array is still suspended:

drivers/md/md.c:__mddev_resume() {
    if (mddev->suspended) {
        mutex_unlock(&mddev->suspend_mutex);
        return;
    }
    ...
    memalloc_noio_restore(mddev->noio_flag);
}

This prevents the first task from restoring its NOIO flag. When the second
task later resumes and drops the counter to 0, it incorrectly restores the
first task's flags onto its own context. Could this leave the first task
stuck in NOIO mode indefinitely?

> +		if (ret)
> +			return ret;
> +		suspended =3D true;
> +	}
>  retry:
>  	if (work_busy(&mddev->sync_work))
>  		flush_work(&mddev->sync_work);

[Severity: High]
Can holding the array suspended while synchronously waiting for the worker
thread expose the worker's memory allocations to a circular deadlock?

If md_start_sync() allocates memory with GFP_KERNEL in the kworker thread
(for example, when calling md_register_thread()), it can trigger direct
memory reclaim. Because the worker thread did not transition the array to
suspended itself, it does not inherit the PF_MEMALLOC_NOIO flag.

Consequently, memory reclaim can issue I/O to the md device. Since the array
is now suspended, md_handle_request() will block this I/O indefinitely. The
worker thread hangs waiting for I/O, and action_store() hangs here in
flush_work() waiting for the worker thread, permanently deadlocking the
array. Is it safe to suspend the array before flushing the work?

> =20
>  	ret =3D mddev_lock(mddev);
> -	if (ret)
> +	if (ret) {
> +		mddev_resume(mddev);
>  		return ret;
> +	}

[Severity: High]
Does this unconditional mddev_resume() risk underflowing the mddev->suspend=
ed
counter if the array was not actually suspended?

If action_store() is called with an action other than ACTION_RESHAPE, the
array is not suspended. If the subsequent mddev_lock() fails (e.g., if it is
interrupted by a signal), the error path unconditionally calls mddev_resume=
().

Since the array was not suspended, __mddev_resume() decrements
mddev->suspended from 0 to -1. Because mddev->suspended is a signed integer
and -1 evaluates to true, subsequent calls to mddev_suspend() will see
mddev->suspended !=3D 0, increment it back to 0, and return immediately wit=
hout
actually pausing I/O. Could this permanently break the suspension mechanism
for the array?

> =20
>  	if (work_busy(&mddev->sync_work)) {
> -		mddev_unlock(mddev);
> +		if (suspended)
> +			mddev_unlock_and_resume(mddev);
> +		else
> +			mddev_unlock(mddev);
>  		goto retry;
>  	}

[Severity: High]
Will the retry loop bypass array re-suspension while leaving the local
suspended flag set to true?

If work_busy(&mddev->sync_work) is true, the code unlocks and resumes the
array, then jumps back to the retry label. However, the retry label is plac=
ed
after the mddev_suspend() block.=20

The code will not re-suspend the array, but the local 'suspended' boolean
remains true. As a result, the reshape operation proceeds on an active,
unsuspended array. Furthermore, when the function exits, it will call
mddev_unlock_and_resume() again because 'suspended' is true, leading to a
double-resume and another mddev->suspended underflow.

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260622121312.1775=
322-1-chencheng@fnnas.com?part=3D1
