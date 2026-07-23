Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F1B3EAC60;
	Thu, 23 Jul 2026 21:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784840692; cv=none; b=I/l2lLLuEdWIcqs7vIhQJAQUPPFvdyDHoHnmWGgbg+JytlVA27RMOhVU4QkGCmAXg4sogGk1YejxgSQc9RFO+/988g1ZmXip8YJvu4kGw8GL0ytqkNDPkhMK6uK/KP6FJk+z+uSARBE5jnvmGoJ/Uo4csdb8cD6zuMyr0+bxyRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784840692; c=relaxed/simple;
	bh=SbUgXBaeETIL3kRVtGjIO68xME3MaBWJ/TamGG0NaL4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Auvdz91bTm/XOe71etu+CCIngyzig8oAv+DjVoDyt4l+Qtorcym9zsXVhMbPdG3Bvs9BY3ZLBKBK0/H7aHBRChYWjBLJSux6CojNY3vbAwT0GwHYUCgMgIs5JVWO3nz5ddYIacsuz6aVV98RrDX+lQdTzkXUU/CKocyhR/zn934=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VFcG6q47; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VFcG6q47"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 278EA1F000E9;
	Thu, 23 Jul 2026 21:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784840681;
	bh=bmEW5YMfrwCWDNPR9cYoHo8wVg8j/QbeVnphV5sWjFY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VFcG6q479q3W9Ftvvdyt3HYQA5/ScjJtRtYzRuSe8lE9y6Zbuds3kktL8/Bgm2FSS
	 OCLWLdiPbr61NgkY99AcMfDaEMaLzETLxfu7FPG8w8DexKFE3wJEehBnvbEy3pR3Ht
	 GZY8m1hsfvzWmKyEaO9BOsp/e1Xs/YGtHe+mOhC+4gNWTlEQ0tFTTJwB3p8enTsR4Q
	 8XCi/Id257eL/3men/WgUF5zLY9S1lW3Fj3hXf7CT0SqPQkEglnHJ0PlgMw+Pw8n9q
	 1sKeaUTGM2iaZEo7eizbVyve9o7ZRjmda6IMo5wy6i9ur/9/huEe8ZGuHQbEkMdEgR
	 whntO/bfuRPRg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 03/10] md/raid1: serialize non-write-behind writes on
 CollisionCheck rdevs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: yukuai@fygo.io, linux-pci@vger.kernel.org, linux-raid@vger.kernel.org
In-Reply-To: <20260723204206.76930-4-mykola@meshstor.io>
References: <20260723204206.76930-1-mykola@meshstor.io>
 <20260723204206.76930-4-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 21:04:40 +0000
Message-Id: <20260723210441.278EA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Hot-added devices silently bypass the array's `MD_SERIALIZE_POLICY=
`, leaving them vulnerable to overlap write data corruption.

Pre-existing issues:
- [High] Dynamic evaluation of `CollisionCheck` during write-behind I/O com=
pletion races with sysfs state changes, leading to use-after-free and memor=
y leaks.
--

--- Patch [3]: [PATCH v5 03/10] md/raid1: serialize non-write-behind writes=
 on CollisionCheck rdevs ---
commit b12be35453573f37c0313dbe2cfc0eb2808cb133
Author: Mykola Marzhan <mykola@meshstor.io>
md/raid1: serialize non-write-behind writes on CollisionCheck rdevs

This patch changes the serialization gate in raid1 to use CollisionCheck
instead of MD_SERIALIZE_POLICY. It aims to correctly serialize on
write-mostly members when write-behind is armed, and remove a latent NULL
dereference.

Cc: stable@vger.kernel.org

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

[Severity: High]
This is a pre-existing issue, but does this unlocked dynamic check of
CollisionCheck create a time-of-check to time-of-use race against sysfs
state changes?

When -writemostly is echoed to sysfs, mddev_suspend() is called. For
write-behind I/O, mddev->active_io is decremented early when non-writemostly
clones finish, which allows mddev_suspend() to return while the write-mostly
clone is still in flight.

Then state_store() in drivers/md/md.c calls mddev_destroy_serial_pool()
which frees rdev->serial and clears CollisionCheck:

drivers/md/md.c:rdev_uninit_serial() {
    if (!test_and_clear_bit(CollisionCheck, &rdev->flags))
        return;

    kvfree(rdev->serial);
    rdev->serial =3D NULL;
}

When the in-flight write-mostly clone subsequently completes here in
raid1_end_write_request(), could it check CollisionCheck and either call
remove_serial() on the freed pointer, or skip it and leak the serial_info
elements?

>  		remove_serial(rdev, lo, hi);
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

[Severity: High]
By gating serialization exclusively on CollisionCheck, do hot-added devices
now silently bypass serialization?

When an array has MD_SERIALIZE_POLICY enabled and a new device is hot-added,
mddev_create_serial_pool() skips initializing the device's serial tree
because it doesn't check the global policy flag.

Since CollisionCheck remains unset for the new device, this change masks
the previous NULL pointer dereference crash by skipping serialization for
the hot-added device entirely. Will this leave the array vulnerable to
overlap write data corruption when stale data persists?

>  				wait_for_serialization(rdev, r1_bio);
>  		}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723204206.7693=
0-1-mykola@meshstor.io?part=3D3
