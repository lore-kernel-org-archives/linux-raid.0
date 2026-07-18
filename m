Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160C12E8897
	for <linux-raid@vger.kernel.org>; Sat, 18 Jul 2026 08:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784364990; cv=none; b=dRA09py0kykBDbvvFdkJ14UnD8Yl0fkIRFGUL77f+w0a3ZRZ9475N3lJqMsYwyE2XkP1Sw1CuhPnGb5oJ4/JKMXEfJKrXc2laFdulwKLk1V6cqQ1jTC6M/7+rD/Y+E4ikpQVZE2PjVSyfnrB/hXM2Jv2PLnEbPpQaxuVl8ev4iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784364990; c=relaxed/simple;
	bh=Qp9dkJI88IYdbS30dWIc3IlmydB+ch5HmadXCISablc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RlkJPcADJE4tSSpVCmupcBnIzh2/ei/0603LElP9gmp4A1Cm0b9BQczm4FRVAy9CqT+p6tdTIRh9W/2+uWAK8rSAWspwwg4vwAoHAbXJQpEW//P1/kZgWT4U212gw3MH5pktnXyQjNwy8Qy3z6cYPPQtYAq/U+MHwq3QgQoj+hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OM3DLbqE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OM3DLbqE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E8CE1F000E9;
	Sat, 18 Jul 2026 08:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784364988;
	bh=37HuYJuiK0JXgivqqg5W0gWLBLH//07gg6SG/hHf9DU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OM3DLbqEu3RtnQd2F6yDVg3f6g3yzuXL5PCZTjXeYhfUcd7E9G83eYmSGQfm8SUI+
	 QVOpIlgRBsv4T6I7HNFk9GMZeWwVxy5iZ50bcYh/uV7A7wpKCnrjW2rGhiA+svPetV
	 fE8Y9r+Eqt8RqFLpn702PbYH0JpbeE1xrWP6oXC9a5DP/mcmCQYwuz7pJ1Mu08E7Aa
	 D8qywHl9k9+2Wfm3lv3VxZ2/WXz7P4XJbhDAOQoqU2n0sRPRue8xfH2aM8zFYRDK/6
	 TsAS70+EzxGiwAUIg2MmFIr9I/RFy0KqOK/1GQs6VMjcH9YLTjREwL50K8KyHWQKaN
	 sWiibFSCEDZ+g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] md: scope memalloc_noio to allocation critical
 sections
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chen Cheng" <chencheng@fnnas.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260718084218.417895-1-chencheng@fnnas.com>
References: <20260718084218.417895-1-chencheng@fnnas.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 18 Jul 2026 08:56:28 +0000
Message-Id: <20260718085628.7E8CE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] In `backlog_store()`, an error path unlocks the mddev but fails to=
 resume it, leaving the array permanently suspended.
--

--- Patch [1]: [PATCH v2] md: scope memalloc_noio to allocation critical se=
ctions ---
commit 6df6cebcdd6ace34da5732a820e0ad95df14d0fc
Author: Chen Cheng <chencheng@fnnas.com>

    md: scope memalloc_noio to allocation critical sections

This patch fixes a token leak issue where PF_MEMALLOC_NOIO could leak across
tasks when saving the token in mddev_suspend() and restoring it in
mddev_resume(). It refactors the code to call memalloc_noio_save() directly
before memory allocation in mdraid operations after the array has been
successfully suspended.

Link: https://github.com/chencheng-fnnas/reproducer/blob/main/repro-md-noio=
-token-leak.sh

> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 0f02e2956398d..f005bc9494ecf 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -2629,10 +2629,12 @@ static ssize_t
>  location_store(struct mddev *mddev, const char *buf, size_t len)
>  {
>  	int rv;
> +	unsigned int noio_flags;
> =20
>  	rv =3D mddev_suspend_and_lock(mddev);
>  	if (rv)
>  		return rv;
> +	noio_flags =3D memalloc_noio_save();

[ ... ]

While reviewing this file, I noticed a pre-existing issue in backlog_store(=
):

drivers/md/md-bitmap.c:backlog_store() {
    ...
	rv =3D mddev_suspend_and_lock(mddev);
	if (rv)
		return rv;

	/*
	 * Without write mostly device, it doesn't make sense to set
	 * backlog for max_write_behind.
	 */
	rdev_for_each(rdev, mddev) {
		if (test_bit(WriteMostly, &rdev->flags)) {
			has_write_mostly =3D true;
			break;
		}
	}
	if (!has_write_mostly) {
		pr_warn_ratelimited("%s: can't set backlog, no write mostly device availa=
ble\n",
				    mdname(mddev));
		mddev_unlock(mddev);
		return -EINVAL;
	}
    ...
}

[Severity: High]
This is a pre-existing issue, but the error path for !has_write_mostly in
backlog_store() calls mddev_unlock(mddev) instead of
mddev_unlock_and_resume(mddev).

If a privileged user writes to the bitmap/backlog sysfs file when there are=
 no
write-mostly devices in the array, mddev_suspend_and_lock(mddev) is called,=
 but
the array is never resumed on this error path.=20

Does this permanently leave mddev->suspended elevated, blocking normal I/O
processing and any future suspend/resume operations on the array?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260718084218.4178=
95-1-chencheng@fnnas.com?part=3D1
