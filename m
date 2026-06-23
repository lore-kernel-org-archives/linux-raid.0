Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B280B2264C0
	for <linux-raid@vger.kernel.org>; Tue, 23 Jun 2026 12:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782219322; cv=none; b=HRf+KSwRp292SwSGad9RafhM6nzrNtGsPtNd9UozkIX8qM6Y6Dry9SeSC21Ib2iSoeR+0U+O2D2m8+lPyGboKtmuzI4T29TfsWyzuTvXeRpXFBXIaYye2xqgk0mEMqQAX4yX+yM+Wux7DWc5tjDTpUd/V9Z2d4L7TpqhDmrthXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782219322; c=relaxed/simple;
	bh=+ZRz0YyBFvNdz1CdUxF5ie/awgsJjyh2Oi9WnRSKZOM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CzWb5e1jnD0SeiYDZeR6wh939uWUGWr5klYb5vVyt0GaO2Dt+0q9vSSX/HIm0aZEpC9NuYgIt90FqBzXP5bttHYBCeDWxedNxM3BtcQBwKUcGC+hLrXzW81EJ6SaW4fWFjlEGfXtVBU0pqwp1Yebyej5iE1bci1KNwysR2HJ6uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cirs8oIH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cirs8oIH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FA391F000E9;
	Tue, 23 Jun 2026 12:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782219321;
	bh=Iixuugu2ao3uYq2S6/fhba73qvoZ/ge6yMGj0TbEjdM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cirs8oIHCR7mMTWpdOJk58oBvngQ8CG1Nceiv56mbT078S598wCy4oPHUA74WdaEG
	 SiMTGjszMvYfWQRWzhYYT2GmNbZthtfQxgEDcQ4fgdnsyF9ITjj+aaCG/sqXyJhd2F
	 5t+m6C2VsyjV2hm5l15gh5tODFFsH6Y0wqeC26H+J4vMMBTnJLEfRX88APKWfeGsBX
	 WzFzrhx/ajLJBpedL8TwfrwFSAoI36aosttdNhknOZ50oRaEIDu7ZIxNe0i4AyVGGg
	 dbK6YyysDSD9t9Jaypc9RnxL6rQaeuk8izLkb3X53wttvTtSb77CbkN7kxHSoKGBdB
	 oF9tQNK2VzEYQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 1/3] md: suspend array when sync_action=reshape
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chen Cheng" <chencheng@fnnas.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260623123840.2521340-2-chencheng@fnnas.com>
References: <20260623123840.2521340-1-chencheng@fnnas.com>
 <20260623123840.2521340-2-chencheng@fnnas.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 12:55:20 +0000
Message-Id: <20260623125521.1FA391F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Concurrent calls to mddev_suspend() corrupt current->flags due=
 to a shared mddev->noio_flag.
- [High] TOCTOU race on mddev->pers in action_store leading to NULL pointer=
 dereference.
- [High] Unprotected access to mddev->pers inside mddev_suspend leading to =
TOCTOU and potential Use-After-Free.
--

commit 480ff61edd64974d75f3192274f5151dada9f98c
Author: Chen Cheng <chencheng@fnnas.com>

md: suspend array when sync_action=3Dreshape

This patch modifies action_store() to suspend and lock the array
before starting a reshape operation, and resume it upon exit. This
prevents new requests from allocating objects from an old pool while
the array is being reconfigured.

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 096bb64e87bd5..1377c407614c6 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5263,21 +5263,25 @@ action_store(struct mddev *mddev, const char *pag=
e, size_t len)
>  	if (!mddev->pers || !mddev->pers->sync_request)
>  		return -EINVAL;

[Severity: High]
This is a pre-existing issue, but does checking mddev->pers locklessly
here risk a NULL pointer dereference later in the function?

A process writing "reshape" to sync_action locklessly verifies
mddev->pers !=3D NULL here. If it is preempted or blocks in flush_work(),
a concurrent write to array_state could stop the array, taking
reconfig_mutex and calling do_md_stop(), which sets mddev->pers =3D NULL.

When the first process resumes, it acquires reconfig_mutex via
mddev_lock() and calls mddev_start_reshape() without re-verifying
mddev->pers:

mddev_start_reshape() {
    if (mddev->pers->start_reshape =3D=3D NULL)
    ...
}

Could this cause a kernel panic if do_md_stop() has cleared mddev->pers
concurrently?

> =20
> +	action =3D md_sync_action_by_name(page);
>  retry:
>  	if (work_busy(&mddev->sync_work))
>  		flush_work(&mddev->sync_work);
> =20
> -	ret =3D mddev_lock(mddev);
> +	ret =3D (action =3D=3D ACTION_RESHAPE) ?
> +		mddev_suspend_and_lock(mddev) :
> +		mddev_lock(mddev);

[Severity: Critical]
This isn't a bug introduced by this patch, but does exposing
mddev_suspend_and_lock() to concurrent sysfs writes via ACTION_RESHAPE
risk corrupting current->flags?

If two processes concurrently write "reshape" to the sync_action sysfs
file, they both execute mddev_suspend_and_lock() -> mddev_suspend()
concurrently without external serialization.

The first process increments mddev->suspended from 0 to 1 and saves
its task-local NOIO state into the shared mddev->noio_flag:

mddev_suspend() {
    ...
    if (!mddev->suspended++) {
        ...
        mddev->noio_flag =3D memalloc_noio_save();
    ...
}

The second process increments it from 1 to 2 and skips saving its state.

Upon completion, the first process calls mddev_resume(), decrements the
count to 1, and returns without restoring its state. The second process
calls mddev_resume(), decrements the count to 0, and restores the first
process's state onto itself:

__mddev_resume() {
    ...
    if (--mddev->suspended)
        return;
    ...
    memalloc_noio_restore(mddev->noio_flag);
}

Can this cause a permanent leak of the PF_MEMALLOC_NOIO flag for the
first thread and incorrectly apply it to the last thread?

[Severity: High]
This is also a pre-existing issue in mddev_suspend(), but does calling it
here before acquiring reconfig_mutex allow an unprotected access to
mddev->pers?

If a process writes "reshape", it invokes mddev_suspend() which evaluates
mddev->pers without holding reconfig_mutex or mddev->lock:

mddev_suspend() {
    ...
    if (mddev->pers && mddev->pers->prepare_suspend &&
        reshape_interrupted(mddev))
        mddev->pers->prepare_suspend(mddev);
    ...
}

Concurrently, another process calling do_md_stop() could set
mddev->pers =3D NULL and drop the personality module reference. If
mddev_suspend() checks mddev->pers, but the module is unloaded before
calling mddev->pers->prepare_suspend(), could this result in a NULL
pointer dereference or execution of unmapped memory?

>  	if (ret)
>  		return ret;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623123840.2521=
340-1-chencheng@fnnas.com?part=3D1
