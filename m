Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D652A379ECF
	for <linux-raid@vger.kernel.org>; Thu, 10 Sep 2026 08:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789030190; cv=none; b=Fun76p+MkwPHnvFTDSEBPnH+SwbdMlflBW/xRAl5ChxUDPAtMtoePdqjRJeBpfov31hHImERIQIGb4LkUDe7GkSeXfcRvRt/YEJcgHhOJkpeuxWg5/5K4wPUppFdwb5vBbi35/S6djcCt9KLyjKms+O9MxlK7nmUvP7gpImVVvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789030190; c=relaxed/simple;
	bh=dQr5rcG/jYUYbElsKw5/xgrHuzUiGLK+3WToIlV9Y1M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fz5jn2zSv0nABvpaO9tiOjPAJ5OxdFHpJXHf3BHyCUAevCxCwwsUISGwBgTXz/pUmPYpXUYVmUJzVshR4rUgTWCC1WspsRxEeca+OC0v6HXa42Tfo/1204r0aiIXVJe/AL7bBr9HJu74Q/LoPiAiwHA/EmeL2vVGOWNxiPE1hcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gefv1VyP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gefv1VyP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C151F000FF;
	Thu, 10 Sep 2026 08:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789030187;
	bh=kgvQHGM0ZWbS2Uz/DRajgIGco2Bmwe2u75JSisEj9Q0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Gefv1VyPXDYJh8RnEmEhk46jua8gzp9NiI/Z33qS9J36IiaVmMxEWNI8lJ8itst03
	 EErxgSICzyGa9PNUMiaXro/Vm6dJGGI4YC7ET9Pkj+B7w8WRySylln3LNi66OIhWF2
	 HRN4q1Yu18XT8P+4JRX40N/+occzreVR09chLIvD+yCzh9qfme5488iwNmI8X+OPYS
	 Ufv22wtkC8F3AS2Tv+AYLaU18IffpUofCsBV3+Opu1IERqaKtkF45kT1ou/bPYmQXq
	 lRwkcuBJz0S8WqH3prcqBoZKgS1XQ+S33KvopycBMwoX3HBwaO/21851WY7YH4XFMU
	 tEQd6kvkF40gA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 6/8] md: pass a queue_limits through ->run()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jack Wang" <jinpu.wang@ionos.com>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260910081114.1605746-7-jinpu.wang@ionos.com>
References: <20260910081114.1605746-1-jinpu.wang@ionos.com>
 <20260910081114.1605746-7-jinpu.wang@ionos.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Sep 2026 08:49:46 +0000
Message-Id: <20260910084947.08C151F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Array starts successfully but fails to apply its queue limits if q=
ueue_limits_commit_update() returns an error, leaving a running array with =
inconsistent block limits.
--

commit a296ef119cee93cfa123eae52144130e9c5df88f
Author: Jack Wang <jinpu.wang@cloud.ionos.com>

md: pass a queue_limits through ->run()

This commit delegates the application of queue limits to the top-level call=
ers
that start the array. This is done to prevent lock inversion between the
reconfig_mutex and q->limits_lock. Personalities now pass the limits up
to be committed by the caller.

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c

[ ... ]

> @@ -4826,6 +4880,9 @@ array_state_store(struct mddev *mddev, const char *=
buf, size_t len)
>  			mddev->hold_active =3D 0;
>  		sysfs_notify_dirent_safe(mddev->sysfs_state);
>  	}
> +	/* apply the limits before the array takes I/O */
> +	if (limp)
> +		err =3D queue_limits_commit_update(q, limp) ?: err;
>  	mddev_unlock(mddev);

[Severity: High]
If queue_limits_commit_update() fails here, does it leave the array in an
inconsistent state?

The limits are committed after do_md_run() has already activated the array.
If the commit fails, an error is returned to userspace, but the running arr=
ay
isn't stopped or rolled back. Can this lead to block layer warnings, driver
crashes, or data corruption if I/O requests exceed the capabilities of the
underlying devices?

[ ... ]

> @@ -8660,7 +8742,7 @@ static int md_ioctl(struct block_device *bdev, blk_=
mode_t mode,
>  		goto unlock;
> =20
>  	case RUN_ARRAY:
> -		err =3D do_md_run(mddev);
> +		err =3D do_md_run(mddev, limp);
>  		goto unlock;

[Severity: High]
Similarly, when do_md_run() successfully starts the array here, the limits
are committed later in the function (under the unlock label). If that commit
fails, the array will remain active with unvalidated or default limits.

Should there be a rollback mechanism (e.g., calling do_md_stop()) if the
limits cannot be successfully applied after the array is started?

> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c

[ ... ]

> @@ -3185,10 +3186,19 @@ static int raid1_set_limits(struct mddev *mddev)
>  	err =3D mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
>  	if (err)
>  		return err;
> +	/*
> +	 * The caller owns an update and commits it itself; taking
> +	 * q->limits_lock here would take it a second time.
> +	 */
> +	if (caller_lim) {
> +		*caller_lim =3D lim;
> +		return 0;
> +	}
> +
>  	return queue_limits_set(mddev->gendisk->queue, &lim);
>  }

[Severity: High]
By unconditionally returning 0 when caller_lim is provided, are we deferring
all limit validation until after the array is fully activated?

Because the personality's ->run() method copies the limits but does not
validate them with the block layer, the first point of failure becomes
queue_limits_commit_update() in the caller. Since the caller currently
lacks rollback handling, this guarantees the array is left running with
invalid limits if the configuration is rejected by blk_validate_limits().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260910081114.1605=
746-1-jinpu.wang@ionos.com?part=3D6
