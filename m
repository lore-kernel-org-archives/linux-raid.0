Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297CD3AC0FC
	for <linux-raid@vger.kernel.org>; Mon, 22 Jun 2026 12:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782132168; cv=none; b=nScJZBc9sejF7+uGMEkih049Vbicuj1MSP9vC4GZtU+VXSpPV0LOAnxmBGofPRamMsHwitnfQw1OaUmeJzJvQr4uJREeKv4mpOLHKjTPYFOCGFUQNqyy+XPgQu37SDu8UmcHJq1x+GQRGo9A5gr9fCO3SV+aIsJcHh51SZ3cdKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782132168; c=relaxed/simple;
	bh=kXwrTG95gxGDEgXWtrWWI3GLW3ZhZZoTy9soFv+N6sA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=h6DgfLhUL6fkXdhrOPUmqNKrag+IcsbWbVRHkcWWcYy6LP2SPrK+mKhOy87bJzhLIygo58IdHsBUhpnsYOroUz84wNyvZiovsi01V0f96zQn1JAhBeh9sBCe09NYqqCiVDmWFaRWZP7BWjkGwcp56FIUcScfNk8JrKn2HNk1kJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X/7nmeIh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X/7nmeIh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A05811F000E9;
	Mon, 22 Jun 2026 12:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782132166;
	bh=QDPl5EcYhI7GhK2ONfjb0irQU9l9O3pTwFrdHcHxAYg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=X/7nmeIhlOVi5s4sw8dQ50QYGa7Yo7iFvtSrMJkWo2E8G224XTp5jHQr4OKZBnzB6
	 TcThuwhoXoOagf4XI3+rZJwuxVjfWpv872OW092LKvIrxkGd8+ev1j6l3x+yMVBULB
	 hXQiAUz8P6GUyRNcasfD8Icy+BI1Uc7aTRtAXquzhqqaK0j4eW14OcRL8hEhxgNh5d
	 bzNKrkPD8WAmfWEPEJh0kX4ZEibEvsHJcf9aNuHdChAADkCI1Pw+a/8FT+CPR73qIV
	 wBdcxAxXSVdytUDLkSKw4KO7iVj11IJt4gORmyT2UMySReo50MdNbb5k5npKCIzfID
	 i0Crb/zFFv6kA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 2/3] md/raid10: resize r10bio_pool for reshape
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chen Cheng" <chencheng@fnnas.com>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260622121312.1775322-3-chencheng@fnnas.com>
References: <20260622121312.1775322-1-chencheng@fnnas.com>
 <20260622121312.1775322-3-chencheng@fnnas.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 22 Jun 2026 12:42:46 +0000
Message-Id: <20260622124246.A05811F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] Replacing `conf->r10bio_pool` during `raid10_start_reshape()` =
races with discard I/O completion, leading to mempool Use-After-Free and he=
ap out-of-bounds writes.
--

commit 1d797159800c9f37dc1886dd00e8c5968da7d731
Author: Chen Cheng <chencheng@fnnas.com>
Subject: md/raid10: resize r10bio_pool for reshape

This commit updates raid10_start_reshape() to allocate a new, larger
r10bio_pool when the number of raid disks changes. The old pool is then
destroyed and replaced with the new one.

> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -4511,6 +4527,10 @@ static int raid10_start_reshape(struct mddev *mdde=
v)
>  	mddev->raid_disks =3D conf->geo.raid_disks;
>  	mddev->reshape_position =3D conf->reshape_progress;
>  	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
> +	if (new_pool) {
> +		mempool_destroy(conf->r10bio_pool);
> +		conf->r10bio_pool =3D new_pool;
> +	}

[Severity: Critical]
Does this introduce a race condition with discard I/O completion?

In the discard completion path, raid_end_discard_bio() calls bio_endio()
on the master bio before freeing the r10bio:

raid_end_discard_bio() {
        ...
        bio_endio(r10bio->master_bio);
        ...
        free_r10bio(r10bio);
}

Calling bio_endio() invokes md_end_clone_io(), which decrements the
mddev->active_io refcount. If this drops to zero, mddev_suspend() can return
while the thread is still executing raid_end_discard_bio().

If that happens, raid10_start_reshape() can proceed to destroy
conf->r10bio_pool and assign new_pool here, while free_r10bio() is still
about to use it.

Could this lead to free_r10bio() releasing the object into a destroyed
mempool, or freeing a smaller r10_bio object into the newly allocated pool
designed for larger objects (which could cause a heap out-of-bounds write
later when __make_request() clears the devs array)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260622121312.1775=
322-1-chencheng@fnnas.com?part=3D2
