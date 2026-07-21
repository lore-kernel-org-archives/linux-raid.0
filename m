Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58BA347126B;
	Tue, 21 Jul 2026 18:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657081; cv=none; b=bQJ5Rmm6gGHLwfd3gcBz2/LtEKE6xeac1bmGz1+lqghRpD8gkhd9bE38QD27ecjUK75OmDO+yyf6YjQMctFBGsIGxnztu7m801d5A2VDMuA8LXXiBTRZaWw6eejQmQzLXQ78WnmGOwsXBcUysCYw/Mw9MZpDzH/YHC5Bu1gw/BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657081; c=relaxed/simple;
	bh=z3SqKLC5nHyGTglC3PDkKzvuIrPnQAd3syBFGUsk1Ps=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=H+bORhbZ1MShnx/7mE2gJnp8bprys5nkMs64nBKGmRgmtmQ8lndGYU44ATxI//mAcE5+x2aigK8wWr+ko3Upw45wluOpqGeWBuQSwtM0Zu/dQC9hd3iXaPM4qMxqxEf5+Kdq+mg8Kr8h4+xZKbtXggyXlDsueLgvsT61/K/la2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ExHV+lof; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ExHV+lof"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F23181F00A3A;
	Tue, 21 Jul 2026 18:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784657080;
	bh=6mOzzdDXs5Ap0xWEO6FIXXXDh0gV2mul2YgQrxsjy8s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ExHV+lofHah0QNOaYcM7XWzGSrDF/3g86dDOrS/Js0E+51LkCuYgiM1yiVBcMIoPJ
	 xTQNNHZFOgeAssVyGjYQO3stwub3nA2GLmsR8XjHsAyQk/W2jLD9F55/vHn+Fn6dlV
	 LfYPyrlnpyDjvZXRAwZSwKvWo/XQOiPPCtqKrAOuL7QElo6WvujWfZWUa1vrExhsKG
	 VIKZQyN1dKWwiJebQ2FXjYdRAihra1QUnvbtXJtCPRlMCw7oslVH3rWKJ/H2a3klcL
	 ZCxk0QtwmSJGFARhArOmkUQhL/u2QYSDJPIsXv9rb+1Vf69qEevrnW0NNsx26N9gCV
	 kXM+nb6GODlWg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 3/8] md/raid1: serialize non-write-behind writes on
 CollisionCheck rdevs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: linux-pci@vger.kernel.org, yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260721174502.111503-4-mykola@meshstor.io>
References: <20260721174502.111503-1-mykola@meshstor.io>
 <20260721174502.111503-4-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 21 Jul 2026 18:04:39 +0000
Message-Id: <20260721180439.F23181F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Using CollisionCheck to gate serialization for normal writes expos=
es a pre-existing serial_info_pool allocation failure, causing continuous W=
ARN_ON log spam on the hot path.
- [High] Hot-added devices silently bypass write serialization under MD_SER=
IALIZE_POLICY, risking data corruption.
--

--- Patch [3]: [PATCH v3 3/8] md/raid1: serialize non-write-behind writes o=
n CollisionCheck rdevs ---
commit d02939f61be1abbb8081faa2ba5a3540f9714678
Author: Mykola Marzhan <mykola@meshstor.io>

md/raid1: serialize non-write-behind writes on CollisionCheck rdevs

This commit modifies the write path to serialize non-write-behind writes
based on the CollisionCheck flag rather than MD_SERIALIZE_POLICY. This
ensures they are properly ordered against in-flight behind writes. It also
updates the completion path to use the same condition for removing
serialization.

> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index afe2ca96ad8c2..997f79c05db7b 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -564,7 +564,7 @@ static void raid1_end_write_request(struct bio *bio)
>  				call_bio_endio(r1_bio);
>  			}
>  		}
> -	} else if (test_bit(MD_SERIALIZE_POLICY, &rdev->mddev->flags))
> +	} else if (test_bit(CollisionCheck, &rdev->flags))
>  		remove_serial(rdev, lo, hi);

[Severity: High]
This isn't a bug introduced by this patch, but changing the gate to
CollisionCheck exposes the normal write path to a pre-existing error handli=
ng
bug that results in continuous WARN_ON spam on the hot path.

If mempool allocation fails during a hot-add of a WriteMostly device,
mddev_create_serial_pool() calls rdevs_uninit_serial(). However,
rdevs_uninit_serial() only clears CollisionCheck on devices already in
mddev->disks, leaving the new device with CollisionCheck set but a NULL
serial_info_pool.

Before this patch, normal writes checked MD_SERIALIZE_POLICY and ignored
CollisionCheck, avoiding the bug. Now, does this cause every normal write to
call wait_for_serialization() (triggering the first WARN_ON) and then
remove_serial() (triggering a second WARN(1) since the IO was never recorde=
d)?

>  	if (r1_bio->bios[mirror] =3D=3D NULL)
>  		rdev_dec_pending(rdev, conf->mddev);

[ ... ]

> @@ -1677,7 +1677,11 @@ static bool raid1_write_request(struct mddev *mdde=
v, struct bio *bio,
>  			mbio =3D bio_alloc_clone(rdev->bdev, bio, GFP_NOIO,
>  					       &mddev->bio_set);
> =20
> -			if (test_bit(MD_SERIALIZE_POLICY, &mddev->flags))
> +			/*
> +			 * CollisionCheck marks every rdev with a serial
> +			 * tree; order against in-flight write-behind I/O.
> +			 */
> +			if (test_bit(CollisionCheck, &rdev->flags))
>  				wait_for_serialization(rdev, r1_bio);

[Severity: High]
This is a pre-existing issue, but does checking CollisionCheck instead of
MD_SERIALIZE_POLICY silently bypass write serialization for hot-added devic=
es
under MD_SERIALIZE_POLICY?

If MD_SERIALIZE_POLICY is enabled and a normal device is hot-added,
mddev_create_serial_pool() currently lacks a check for MD_SERIALIZE_POLICY
and returns early without creating a serial tree or setting CollisionCheck:

drivers/md/md.c:mddev_create_serial_pool() {
    ...
    if (rdev && !rdev_need_serial(rdev) &&
        !test_bit(CollisionCheck, &rdev->flags))
        return;
    ...
}

Previously, checking MD_SERIALIZE_POLICY here caused a NULL pointer
dereference when trying to serialize the hot-added device without a serial
tree. By checking CollisionCheck instead, the crash is avoided, but does
this mean overlapping writes can now complete out of order on the
reconstructed mirror, leading to silent data corruption?

>  		}
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260721174502.1115=
03-1-mykola@meshstor.io?part=3D3
