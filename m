Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD55470E96;
	Wed, 22 Jul 2026 19:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784747681; cv=none; b=oMIVGCvnUxRas7pUYTSlSeIdQGB68pXsZJeZewCfOs+KDT/B9lo4A4LrQ3ZFT0+ZMjFUjIQHjqlbMiZu7midXsDi7vE7DPd9FLmDDQV7YYrgLMJoEtJJrvnDA2KxIwKXU2/BaGzl7A9U9u3/aEuuGULp8t6tRjAjaDiYBXXVSe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784747681; c=relaxed/simple;
	bh=n9930oe18gHvIOlNlzuoKScoIzJS1bGLIZ3/sGqeEsw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=q8TBgTI2j+1ZUC0JnDZ1O9iVCjmkxk95Zbs22QdtKYtm8+gVPGvBIn4wuf9G6LZh0QfwuWzzWg2MNFYgbmib391GZUeJMSSXtAj+52BBux0eNJmjn71sytAdSbHNcCF6ruu1/o4MdQYDt7YD4lwFKyhFcaKA0T/MeGWHJTZCLbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A6a2uLXL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A6a2uLXL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913661F000E9;
	Wed, 22 Jul 2026 19:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784747679;
	bh=2o+VLY5Gxvn2gnlUXmOVZ1mNtvmBV4e40K06QwCIxtI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=A6a2uLXL/OCdgXLFwIMXXkPJ3X5J2vR0+8jwLqEMFKUcQ0lDpTub8tO+33XXPlZPC
	 WjVDO2r8AzW7bVxt7bf5fpwp4U90W0QEfUDZAFfp/ddNBsW+euKCG/+iVEC0aWn8lF
	 wj3RXG79P7MNtp6rz/RWOkE1qRqMzDVaQIDRDOVKOi23ln5t6FlLZb2XjudTgLzL4O
	 Y6PjLKdRR8qSkjRa/9cD71jqogzF9FSXaaEIpHf1iB4gEuwL+BRFOlMS/j37MMoPB5
	 C2qw6VdtcRO1FXyTgCHO4/4618SxdjtIHmAeYTpI8nG9GkkYtcdtewUFzqGlPS+syt
	 WOHTAootS4FTA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 3/9] md/raid1: serialize non-write-behind writes on
 CollisionCheck rdevs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: linux-pci@vger.kernel.org, yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260722185841.449934-4-mykola@meshstor.io>
References: <20260722185841.449934-1-mykola@meshstor.io>
 <20260722185841.449934-4-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 22 Jul 2026 19:14:39 +0000
Message-Id: <20260722191439.913661F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [Medium] Hot-added devices silently bypass the MD_SERIALIZE_POLICY serial=
ization.

Pre-existing issues:
- [Critical] Concurrent overlapping I/Os cause RB-tree double-insertion and=
 corruption in `wait_for_serialization` and `remove_serial`.
- [High] Toggling `-writemostly` or `serialize_policy` via sysfs races with=
 in-flight I/Os, causing a Use-After-Free of `rdev->serial` and leaking `se=
rial_info`.
--

--- Patch [3]: [PATCH v4 3/9] md/raid1: serialize non-write-behind writes o=
n CollisionCheck rdevs ---
commit cb65d8bde9fd6c1299852f1cafb33bef4da080a2
Author: Mykola Marzhan <mykola@meshstor.io>

md/raid1: serialize non-write-behind writes on CollisionCheck rdevs

This commit changes the write serialization gating from the global
MD_SERIALIZE_POLICY flag to the per-device CollisionCheck flag. It fixes
a race with write-behind I/O on write-mostly members and avoids a latent
NULL dereference for hot-added devices.

Fixes: d0d2d8ba0494 ("md/raid1: introduce wait_for_serialization")
Cc: stable@vger.kernel.org

> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
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
This is a pre-existing issue, but does toggling -writemostly or
serialize_policy via sysfs race with in-flight I/Os here?

When mddev_suspend() is called during reconfiguration, it waits for new I/O
submissions to finish, but it does not wait for in-flight cloned bios on
the underlying disks to complete.

If mddev_destroy_serial_pool() clears CollisionCheck and frees rdev->serial
concurrently, and an in-flight bio completes, raid1_end_write_request()
might read CollisionCheck as true and dereference the freed rdev->serial
inside remove_serial().

If it reads the flag as false, it skips remove_serial(), leaking the
serial_info mempool element.

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

[Severity: Medium]
Does this change allow hot-added devices to completely bypass serialization
when the global serialize policy is active?

If an administrator sets serialize_policy=3D1 and a new device is hot-added,
mddev_create_serial_pool() skips initializing the serial tree for the new
device because it checks rdev_need_serial() and CollisionCheck (which is
not set yet).

Since this gate in raid1_write_request() now only checks CollisionCheck
instead of MD_SERIALIZE_POLICY, the hot-added device skips serialization
entirely.

[Severity: Critical]
This isn't a bug introduced by this patch, but can concurrent overlapping
I/Os cause an RB-tree double-insertion during wait_for_serialization()?

If three overlapping I/Os (A, B, C) arrive in sequence (e.g. A=3D[25-35],
B=3D[20-30], C=3D[10-20]):

I/O A is inserted. I/O B overlaps A, and gets added to A's wait list.
I/O C overlaps B but not A, so C is inserted.

When A completes, it removes itself, inserts B into the tree, and wakes B.
B wakes up and calls check_and_add_serial(), which finds C. B is added to
C's wait list and sleeps again, but remains linked in the RB-tree.

When C completes, it removes itself, splices B's waiters, and calls
raid1_rb_insert() on B again, corrupting the tree structure.

>  		}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260722185841.4499=
34-1-mykola@meshstor.io?part=3D3
