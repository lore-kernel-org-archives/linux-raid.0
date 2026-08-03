Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E9121883E
	for <linux-raid@vger.kernel.org>; Mon,  3 Aug 2026 18:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785781220; cv=none; b=FrHc30SlVQKLx6P5erbNYGOcLSm5cjoehnHJu2Y+ul27xeKi8IzAKqMQLkzqo6lorkc462QBKIQF2tJaQwrQ8/QryXhIzOmGQPDdBLFbzX2goC1J3AqT5vjTGgrm82W+ktFC04ebsOV/kpH5WCaCb1+Xz1N8v2O3G3SaZQ7Fx6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785781220; c=relaxed/simple;
	bh=SJURj1NIuxA6qJltj4t0DyW50R2GgD3X01LsCK6k/Nc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kVYCaKbMTE5X1/sRFjzIHqw2vgJbnVK8SNsSCa/qBbQI97uvg2fT5ANjY7Gmk17tVQCqtP6RF/2R5YUX2Y8+b5ZX7JGRGdBBGFDOmkUHmbR4kxHFQ7o8Yb5mwnAZIgk0aEmBQGWxwQqukGr+5LlzsjJcYbxv0Ufs7QXTUv98ddw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KLQ5lXrM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KLQ5lXrM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D41F1F000E9;
	Mon,  3 Aug 2026 18:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785781219;
	bh=KYOdifxQbPM/HBsQlaADf3apXxf661saBdYzy+mSLoY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KLQ5lXrMx1ouaMiQNQZ4pUaxiESB8OC+GIeZjVDynnlT1dfE4vUuho/20NtJUoIZf
	 ZVmpNMrVbLplmcVnv3gzrTUnzydR1/lVz2+vWLrgkVsKjYO6S5nyDEYsLQnpYeC45X
	 966j/+xR4WhH+Zz7gS8Fwizq7gYtC3mQwH66nJESLYJSAYO5cx5Pe2wn8ADj5asqG/
	 oHudHgrhGA37VN7fOhdypXV/As/Q+ymm4ZvSZg6K4wQ15J8O0k65VcTPRD5gpbAqh9
	 /rBxRmEn5TXnnMU5c7CqDcBiZr1aO+ys0pnsspmtHq7UJxDt15qZuon4bQaIcUW/HU
	 a6QVSPF8DlHwA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] md/raid1: don't set array_frozen in raid1_takeover()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bruce Johnston" <bjohnsto@redhat.com>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260803180240.1177104-1-bjohnsto@redhat.com>
References: <20260803180240.1177104-1-bjohnsto@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 03 Aug 2026 18:20:18 +0000
Message-Id: <20260803182019.4D41F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] level_store() completely ignores the return value of pers->run(mdd=
ev), leading to a memory leak and leaving the md array in a broken state if=
 the personality initialization fails.
--

--- Patch [1]: [PATCH] md/raid1: don't set array_frozen in raid1_takeover()=
 ---
commit 6300b6117ffff45fb0af7f09f8050ab659c74d0c
Author: Bruce Johnston <bjohnsto@redhat.com>

md/raid1: don't set array_frozen in raid1_takeover()

raid1_takeover() sets conf->array_frozen =3D 1 on the newly-allocated
r1conf but since commit b39f35ebe86d removed the quiesce call, it
is never cleared and stalls I/O permanently. This commit fixes the
issue by removing the array_frozen assignment in setup_conf().

Link: https://issues.redhat.com/browse/RHEL-191802

> This used to be harmless: level_store() called mddev_resume() right
> after pers->run(), which called raid1_quiesce(mddev, 0) and cleared

[Severity: High]
This is a pre-existing issue, but looking at level_store(), the code
ignores the return value of pers->run(mddev):

drivers/md/md.c:level_store() {
        ...
        pers->run(mddev);
        set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
        ...
}

If pers->run() fails (for example, if raid1_run() fails during
raid1_set_limits() and expects the caller to free mddev->private),
does this leak the personality-specific configuration structure
(like r1conf and its mempools)?

Since the return value is ignored, could this also leave the array in a
broken state where subsequent I/O causes a crash because the active
personality is not fully initialized?

> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index afe2ca96ad8c2..2a247ed5fff11 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -3485,8 +3485,6 @@ static void *raid1_takeover(struct mddev *mddev)
>  		mddev->new_chunk_sectors =3D 0;
>  		conf =3D setup_conf(mddev);
>  		if (!IS_ERR(conf)) {
> -			/* Array must appear to be quiesced */
> -			conf->array_frozen =3D 1;
>  			mddev_clear_unsupported_flags(mddev,
>  				UNSUPPORTED_MDDEV_FLAGS);
>  		}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260803180240.1177=
104-1-bjohnsto@redhat.com?part=3D1
