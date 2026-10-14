Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49584FECC9
	for <linux-raid@vger.kernel.org>; Wed, 14 Oct 2026 12:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791979230; cv=none; b=eIbb0vRoyqyKJnBABElH+Sygsxi9xFeqRDXBgaqUfxg6O7mPrFF9ENAdmPX5k3pvq+B6HhyYA070z2Ydc4E+f0O7QvzDnQiMupHCPrvAC+2gJ4XRkm/G3OPBzn29AWUpgAtXRBhlrA1FncpiP4U3q0opSvST+vQbRm9RpuAkm5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791979230; c=relaxed/simple;
	bh=Zp3p6QYHTxLXTYrxzaNkZDkrtkQCuEe/LNUM002tbnA=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Bm2IXQVImrqIEVNuSaF+ZTtl/xyT5NucHbenzvKFCSoJcVEifyBN1AEWHCXOCahHSSJsMABLxWxzJgMCZ/ataZ/dDlLKRtPX1y9Xf51l0RI3SAlaGdNmLdk41mDE4064fGsvHgXs2Xa+8LvacvCBM3RRCS8BYvqDYXooFaEerVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QiPcXzPz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QiPcXzPz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 032BE1F000FF;
	Wed, 14 Oct 2026 12:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791979228;
	bh=cT/5I4mwvGWrUYS80C64p0SnLPkk5FalS47KZDOxOIo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QiPcXzPzB5IW3ySQEUAi0qOES1/QBvdh74VksA2rKgFBMVzloY7DfqRoKAr0xLKHZ
	 foo7Q81ryiYKo4wPwHDJBFJI85aqfQAPBFqjuapl6Dyo+iYeCRkCRQ9b6FbEK1cVmN
	 FlwGG1x7H7eneG9o4BjyB7ArY5aQnwMl7gH/DYw7ZanZgzwhfGZj3+RftY13ocmW1O
	 T8jGNySuafTFmi3YhguBFJjRQgD7W28wG49pDOYEYJkk/4p2axAiTCyJqlllTD/7zS
	 opJebbMNovbEmuLn4IPrQCu7xHkHSvJ7E0s0YeeCO0UREAt30vXlQJif78Cx8UDi6a
	 OcBC9FGH/P6qw==
Message-ID: <sashiko-outbox-171234@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] md: allow growing logical_block_size on a running array
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jack Wang" <jinpu.wang@ionos.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20261014114830.615589-1-jinpu.wang@ionos.com>
References: <20261014114830.615589-1-jinpu.wang@ionos.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 12:00:27 +0000
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] md: Unbalanced mutex unlock on mddev_lock() failure in lbs_store()
- [High] md: TOCTOU race in lbs_store() bypasses opener check and deadlocks=
 via queue freeze
--

commit 4267b7426d911d22ecfdc4aa203d879ce4f9a759
Author: Jack Wang <jinpu.wang@cloud.ionos.com>

    md: allow growing logical_block_size on a running array
   =20
    Growing logical_block_size on a running array required stopping it
    first. Handle it directly in lbs_store(), similar to
    mddev_set_closing_and_sync_blockdev(): under open_mutex, refuse with
    -EBUSY if the array is closing or has openers, otherwise apply the
    bigger LBS.

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 680b34a63cb3d..c885d405bf466 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c

[ ... ]

> @@ -6026,8 +6026,36 @@ lbs_store(struct mddev *mddev, const char *buf, si=
ze_t len)
>  	if (mddev->pers) {

[Severity: High]
Since this check of mddev->pers is performed locklessly, can a concurrent
thread starting the array race with it?

If mddev->pers is null, we fall through to the bottom path and block on
mddev_lock(mddev). Concurrently, another thread executing do_md_run() could
acquire reconfig_mutex, set mddev->pers to non-null, start the array, and
release the lock.

When lbs_store() wakes up and acquires reconfig_mutex, it does not re-verify
mddev->pers or check atomic_read(&mddev->openers) > 0 before calling
mddev_set_logical_block_size():

drivers/md/md.c:lbs_store() {
    ...
	if (mddev->pers) {
        ...
		return len;
	}

	err =3D mddev_lock(mddev);
	if (err)
		goto unlock;

	err =3D mddev_set_logical_block_size(mddev, lbs);
    ...
}

Does this blindly apply a new logical block size to a running array with
active openers? Furthermore, since mddev_set_logical_block_size() invokes
queue_limits_commit_update_frozen() which waits for all active I/O to drain
while holding reconfig_mutex, could this deadlock if active I/O completion
requires reconfig_mutex?

[Severity: High]
If mddev_lock() fails (e.g., interrupted by a signal, returning -EINTR),
does it jump to an unbalanced unlock?

drivers/md/md.c:lbs_store() {
    ...
	err =3D mddev_lock(mddev);
	if (err)
		goto unlock;

	err =3D mddev_set_logical_block_size(mddev, lbs);

unlock:
	mddev_unlock(mddev);
	return err ?: len;
}

Because mddev_lock() failed, reconfig_mutex was not acquired, but the unlock
label unconditionally calls mddev_unlock(mddev) to release it. Could this
attempt to unlock an unheld mutex and trigger a lockdep splat or kernel
panic?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014114830.6155=
89-1-jinpu.wang@ionos.com?part=3D1
