Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4631306775
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 16:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782317559; cv=none; b=PAFj6/u8vvUbDeaFs8VRQ8hy5L7rMTCCOM/SRFvpIRWdSkH+YbiBkzBhAjgOUgpO3dnu/hmS+d7mVpJBoxw1EULaF3+lrNrWyiGfWsF/3w4Nm6Az/J3M2rr3pITIJeNdCc4oUvoyTsounqn5lqDTaCGXg/8SvTvROSN3DYkoJHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782317559; c=relaxed/simple;
	bh=p0HTkEi4ohWfNOXLACz5HqqgKMvrmT9Nt7MgUMRRzAY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tZbhAJwd++66o/+FReGFAswLfNd6i7so7hsmy5TziGm4h2kSKLivmGXcxeFCDbeOSMdTBYkZGizm75+X6SZAKMkbk7GS9JQx87MndgdCZ1+lHAz+eclTOH7im60IUuIqseya1+gi1gSS42r9YzcZyHEEbLOhgy6/yYIjImhSjhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BLEm4Oo2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BLEm4Oo2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6813B1F000E9;
	Wed, 24 Jun 2026 16:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782317558;
	bh=jew1YLSshQ4GTdn45OxAcFA4NmCIv9q1TSQtlLSTSCQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BLEm4Oo2zVQvudc16GvELvCTncPLe8hrQ+kvACKRbUFs+6uYfan8ls674PnkQnklS
	 9cWaE2QEwHNkw+ij6L7xsXNi3hiw1NQeq1WTiFCTRNSNVCrCNzEXUfvaO959N6BRO1
	 VTUskrWoiqE4XjdLNXU2RrpgpVvJj3Rv8Wy00TnsSHm5RnhCkTrjmZCPtcJwXxlIhy
	 CeWUatjeA3z6PdGGHrKRJF65tCuCLrGR6jAXKiq6ePigrpPMEVFP5x3EPvJ1k/LbG5
	 qcFCwMa+bynvZO24ZHp4u0RUU8EYlGi+fqoZlRQTdgI5wynXHu3O1sJe9qWRSHIwYi
	 dQScxDqBTB3Og==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5/8] md/raid5: submit a window of stripes during
 resync/recovery
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hiroshi Nishida" <nishidafmly@gmail.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260624155452.211646-6-nishidafmly@gmail.com>
References: <20260624155452.211646-1-nishidafmly@gmail.com>
 <20260624155452.211646-6-nishidafmly@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 16:12:37 +0000
Message-Id: <20260624161238.6813B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] The batch loop ignores the return value of md_bitmap_start_sync(),=
 forcing clean stripes to be unnecessarily synchronized.
- [High] Time-of-check to time-of-use race on the array's degraded state, l=
eading to silent data corruption via incorrect bitmap updates.
--

commit 01d1e80ee6aa253c48c233e7fc218fbdac9522fa
Author: Hiroshi Nishida <nishidafmly@gmail.com>

md/raid5: submit a window of stripes during resync/recovery

This commit alters raid5_sync_request() to dispatch up to 32 stripes per
call instead of one. It attempts to submit the remaining stripes in the
window with a non-blocking flag to avoid the per-stripe throttle sleep.

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 9cb4ed3bd85c5..8e9edaaca667b 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6620,16 +6621,7 @@ static inline sector_t raid5_sync_request(...)
[ ... ]
> -	sh =3D raid5_get_active_stripe(conf, NULL, sector_nr,
> -				     R5_GAS_NOBLOCK);
> -	if (sh =3D=3D NULL) {
> -		sh =3D raid5_get_active_stripe(conf, NULL, sector_nr, 0);
> -		/* make sure we don't swamp the stripe cache if someone else
> -		 * is trying to get access
> -		 */
> -		schedule_timeout_uninterruptible(1);
> -	}
> -	/* Need to check if array will still be degraded after recovery/resync
> +	/* Check once whether array will still be degraded after recovery/resyn=
c.
>  	 * Note in case of > 1 drive failures it's possible we're rebuilding
>  	 * one drive while leaving another faulty drive in array.
>  	 */
> @@ -6640,13 +6632,42 @@ static inline sector_t raid5_sync_request(...)
>  			still_degraded =3D true;
>  	}
> =20
> +	/* First stripe: block if stripe cache is full, then throttle. */
> +	sh =3D raid5_get_active_stripe(conf, NULL, sector_nr, R5_GAS_NOBLOCK);
> +	if (sh =3D=3D NULL) {
> +		sh =3D raid5_get_active_stripe(conf, NULL, sector_nr, 0);
> +		/* make sure we don't swamp the stripe cache if someone else
> +		 * is trying to get access
> +		 */
> +		schedule_timeout_uninterruptible(1);
> +	}

[Severity: High]
Does moving the degraded check before the stripe allocation introduce a
time-of-check to time-of-use race?

If a drive fails during the potential sleep in raid5_get_active_stripe() or
schedule_timeout_uninterruptible(), the stale still_degraded value is used
below to update the bitmap. This could incorrectly clear the NEEDED bit,
potentially leaving parity inconsistent if the system crashes before the sy=
nc
completes.

>  	md_bitmap_start_sync(mddev, sector_nr, &sync_blocks, still_degraded);
>  	set_bit(STRIPE_SYNC_REQUESTED, &sh->state);
>  	set_bit(STRIPE_HANDLE, &sh->state);

[ ... ]

> +	win_sector =3D sector_nr + RAID5_STRIPE_SECTORS(conf);
> +	for (submitted =3D 1;
> +	     submitted < RAID5_SYNC_WINDOW && win_sector < max_sector &&
> +	     win_sector < mddev->resync_max;
> +	     submitted++, win_sector +=3D RAID5_STRIPE_SECTORS(conf)) {
> +		sh =3D raid5_get_active_stripe(conf, NULL, win_sector,
> +					     R5_GAS_NOBLOCK);
> +		if (!sh)
> +			break;
> +		md_bitmap_start_sync(mddev, win_sector, &sync_blocks,
> +				     still_degraded);
> +		set_bit(STRIPE_SYNC_REQUESTED, &sh->state);
> +		set_bit(STRIPE_HANDLE, &sh->state);

[Severity: High]
Does this batch loop unnecessarily synchronize clean stripes?

The boolean return value of md_bitmap_start_sync() is ignored here. If the
first stripe needs sync but subsequent stripes in the window are clean, this
loop unconditionally queues every stripe for synchronization regardless of
its clean/dirty state, forcing read-rebuild-write cycles on clean stripes.

> +		raid5_release_stripe(sh);
> +	}
> +
> +	return submitted * RAID5_STRIPE_SECTORS(conf);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260624155452.2116=
46-1-nishidafmly@gmail.com?part=3D5
