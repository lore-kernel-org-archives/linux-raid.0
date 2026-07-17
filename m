Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A4937AA65
	for <linux-raid@vger.kernel.org>; Fri, 17 Jul 2026 04:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784262573; cv=none; b=g0a/eAm1CLZwJu8mjOfExpGSDwqw9hQS7EB2lqAp93FeKbR5BI0T/dzHqTe0PhnzbFooHciPckXyGYnDpDq/27BViQwtELGacd11ZNw1zeglQA58yTfTVIsjPvpfiQdfWyL2fK0VeaHpISA8N4o9MymYLWD6xK6AgL5Jnd38sJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784262573; c=relaxed/simple;
	bh=t+PVtHcfgITznZE+W7X9JGqHGQj1zAqhqfMxN6FI2O4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OxSuIH6hxBgjwJvEabso74rlylhNAAyg0tm1r/4+r6jADj5qCegxAVAcn1ptzunfGBq63vbyc5fKbrC8LT8EaQEF4DpFP4zgPYmWlkkN2CEzRo9ATTR3oak6+4wGFm34lCfg9ginubatyTef2bXHexKqVdkrHsVzzYLfQcBZiyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PLWnDr3I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PLWnDr3I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5ED91F000E9;
	Fri, 17 Jul 2026 04:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784262572;
	bh=/qmxAPrjBMiJMoa4kYeGo5l99itTGXG0dUn5GTKkJFE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PLWnDr3IZE28PdfMcMnnLqo1se7PCeSKZJ3QMLGQ/XZ/ANCRi0mv+Q4lnewd3fS+s
	 B6t7VdVM3i0vShfRA6kn01OO9gA/22DYpcM0/+l7dkzpqfkTRveWFLnpBzHbSB5cvy
	 eb8IJCGTLwYMktxqLpxHt8INcajEHRV4M+Xh0Qr/M4c5Y7PaQs9BUROfDWoL+gzNkY
	 iw+/K8hmFmh00kJ1Hffyc8gHN/9rIFvZIzPCe9S+1RP0F12hEOyaKcBwcXsB9R9x4r
	 LIOZJSV+44n+aeMtaKcRjvIOnomnpFSpWLCOkqgiJ0H2R5ZRzFwZluKl+y4Gaqa4WN
	 IWlNwd15NOF5g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] md: clear MD_CLOSING when array_state_store() bails on
 interrupted lock
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jack Wang" <jinpu.wang@ionos.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260717041746.363740-1-jinpu.wang@ionos.com>
References: <20260717041746.363740-1-jinpu.wang@ionos.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 04:29:31 +0000
Message-Id: <20260717042931.E5ED91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Unconditional clearing of MD_CLOSING on the error path can clear a=
 flag owned by a concurrent thread, exposing the array to use-after-free ra=
ces during teardown.
--

--- Patch [1]: [PATCH] md: clear MD_CLOSING when array_state_store() bails =
on interrupted lock ---
commit 919b922dd46da90c5c7e1a2b46106db8f5e8ffbf
Author: Jack Wang <jinpu.wang@cloud.ionos.com>

md: clear MD_CLOSING when array_state_store() bails on interrupted lock

This commit addresses a bug where an interrupted lock in array_state_store()
leaves MD_CLOSING set, preventing the array from being reopened. It modifies
the error path to jump to the existing cleanup logic to clear the flag.

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d1465bcd86c81..c4de2053593a0 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -4696,7 +4696,7 @@ array_state_store(struct mddev *mddev, const char *=
buf, size_t len)
>  	}
>  	err =3D mddev_lock(mddev);
>  	if (err)
> -		return err;
> +		goto out_clear_closing;

[Severity: High]
Does this unconditionally clear MD_CLOSING even if this thread didn't set i=
t?

If Thread A initiates array teardown (e.g., via md_ioctl(STOP_ARRAY)), it s=
ets
MD_CLOSING, takes reconfig_mutex, and sets mddev->pers =3D NULL.

If Thread B concurrently writes "inactive" to array_state, it skips setting
MD_CLOSING because mddev->pers is NULL:

drivers/md/md.c:array_state_store() {
...
	case inactive:
...
		if (!mddev->pers || !md_is_rdwr(mddev))
			break;
		err =3D mddev_set_closing_and_sync_blockdev(mddev, 0);
...
}

Thread B then calls mddev_lock(), which blocks because Thread A holds the
reconfig_mutex. If Thread B receives a signal, mddev_lock() returns -EINTR,
and we jump to out_clear_closing:

> =20
>  	switch (st) {
>  	case inactive:

[ ... ]

> @@ -4769,6 +4769,7 @@ array_state_store(struct mddev *mddev, const char *=
buf, size_t len)
>  	}
>  	mddev_unlock(mddev);
> =20
> +out_clear_closing:
>  	if (st =3D=3D readonly || st =3D=3D read_auto || st =3D=3D inactive ||
>  	    (err && st =3D=3D clear))
>  		clear_bit(MD_CLOSING, &mddev->flags);

Because st =3D=3D inactive, Thread B blindly clears MD_CLOSING, even though=
 it
never set it.

Could this allow a third thread to successfully open the device (since
md_open() only checks MD_CLOSING) while Thread A is actively destroying the
array data structures, leading to a use-after-free?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717041746.3637=
40-1-jinpu.wang@ionos.com?part=3D1
