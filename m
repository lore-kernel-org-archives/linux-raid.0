Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B3C3BE162
	for <linux-raid@vger.kernel.org>; Wed,  8 Jul 2026 10:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783506704; cv=none; b=Pz8eRx9kNQw7scZls53U7BAiuKo6jNCkBQnlixVE1M9Z5VtUp/GrCahUEzzDIVdjaYIAMwTkcezVOy1hZJaglaEOY+mUsan0tFvNgwrIGxv9pBMlpT5fdj3URkN25I52h96W++TL/+MtzjM5c06kCSGVlnrMGOIu3Le/nknsuGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783506704; c=relaxed/simple;
	bh=ShfKYLmpFafL9KoddMxHzqDdFERYNTwDC1B/afQagIs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZPfgZVdr5yoW9SYA65AHJsa9FaSW5F+yZ58uBcFYs3+pVuoi9sfOptoWvQXraSUC1BkUqO6FeLDT3pUTsNCQ7C3oGzDpb5bF29GjkwKbFQNNjtgHJc6QOIMRA/RsrAIMeqOKQd2zqD+Hz5Y2RC24OpOo/nMSUR1rrMR740G11gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UqHtgxBI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UqHtgxBI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FC141F000E9;
	Wed,  8 Jul 2026 10:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783506696;
	bh=BDduYsPBb5lwx1odJPczgYil2QiueSXQWZULveBflkU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UqHtgxBIyMf7+bip6ArRAO+vQBRD/hCH7QYV99o8U+SAsTHHAGV3bQqZaASFb+71c
	 Fxu3mbqqVC38B71FjpfKLLv2wmINFkDzROTHZyDR0WKmw94K2cJvNGIVE3QOx7z27V
	 Tbq2QQhr2W9V9SCvHHk9CiJG8jZuGKngljPFC8YsoNh4Pxn+A3PW0zmdy8uI3Lb8c4
	 wjZfzGmRPI9DNUqfqc15c5nEm7SmAFR0Rx1ufvi0KmBtOf7K4YNZweEIqtUwzdJITN
	 vUFgg4mN3xq7embTeZnuJLYOqZ8NPnHGm2sUsHhf7KzeeeiTFkB5Q+nRseKx9Logn/
	 OkrlSRX2pkp1A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 3/7] md/raid10: consistently fail atomic writes that
 require splitting
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260708101341.473750-4-abd.masalkhi@gmail.com>
References: <20260708101341.473750-1-abd.masalkhi@gmail.com>
 <20260708101341.473750-4-abd.masalkhi@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 08 Jul 2026 10:31:35 +0000
Message-Id: <20260708103136.3FC141F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] A concurrent promotion or removal of a disk causes a NULL pointer =
dereference in the err_handle cleanup path.
--

--- Patch [3]: [PATCH v3 3/7] md/raid10: consistently fail atomic writes th=
at require splitting ---
commit 39f996c40527039ea2fa463cb02f7e201f0a4e7d
Author: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>

md/raid10: consistently fail atomic writes that require splitting

RAID10 currently handles one badblock path explicitly by failing atomic
writes with EIO. However, another badblock path can also reduce the
writable range and force the bio through bio_submit_split_bioset(),
which implicitly completes the bio with EINVAL. This patch explicitly=20
fails atomic writes in the common split check instead.

Link: https://lore.kernel.org/linux-raid/20260628142420.1051027-4-abd.masal=
khi@gmail.com/

> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index bd322eccdc3ff..3480fc7907f01 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c

[ ... ]

> @@ -1493,6 +1484,9 @@ static bool raid10_write_request(struct mddev *mdde=
v, struct bio *bio,
>  		r10_bio->sectors =3D max_sectors;
> =20
>  	if (r10_bio->sectors < bio_sectors(bio)) {
> +		if (atomic)
> +			goto err_handle;
> +

[Severity: High]
This is a pre-existing issue, but can this lead to a NULL pointer dereferen=
ce
if a concurrent disk removal or promotion occurs?

In the err_handle cleanup path, the replacement pointer is locklessly
re-read from the array configuration:

err_handle:
	for (k =3D 0;  k < i; k++) {
		int d =3D r10_bio->devs[k].devnum;
		struct md_rdev *rdev =3D conf->mirrors[d].rdev;
		struct md_rdev *rrdev =3D conf->mirrors[d].replacement;

If raid10_write_request() executes without holding rcu_read_lock() or
reconfig_mutex (since it can sleep), it might increment nr_pending on the
active replacement disk and set r10_bio->devs[i].repl_bio =3D bio.

Concurrently, if raid10_remove_disk() promotes the replacement disk, it sets
conf->mirrors[d].replacement =3D NULL.=20

When this goto is hit because an atomic write needs splitting, the lockless
re-read will fetch NULL for rrdev. Since r10_bio->devs[k].repl_bio is
non-NULL, the code calls rdev_dec_pending(rrdev, mddev), which will
dereference the NULL pointer.

>  		allow_barrier(conf);
>  		bio =3D bio_submit_split_bioset(bio, r10_bio->sectors,
>  					      &conf->bio_split);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260708101341.4737=
50-1-abd.masalkhi@gmail.com?part=3D3
