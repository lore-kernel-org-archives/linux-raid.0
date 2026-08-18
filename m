Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD85F391832
	for <linux-raid@vger.kernel.org>; Tue, 18 Aug 2026 07:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787038474; cv=none; b=QkgYOveSC8ZgzgcnDkDNhgzSQmORwPtLgFVZUYSW9EIX0IOL8gKT7hQGm1EaznxgdoQ2Js1+rb+N4bgglHfWb7UlggwQ71f82sPDmqkCOmCGS6lm1nN6KQz3yMo7VFj7z93aOJU8dJBxdXgKtlAylRqn776gqqR2MseUuUtqVqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787038474; c=relaxed/simple;
	bh=zop8tL4gLiGoehThgXcxumGfa4lpR48srdL1hZ9uGqQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=krHZe3cn9wAc8XHz3q8y7LwnPwG3mU5hNRp95rmSl7PlviClKKs4eZgWYq0z1pBEVVhdER7C0bHrXY0Ihy/GvcwOHlu/ZpO/qmi0GisiXH9P03x73d+8v3XwD+K6g6aLwHRH94jGgdMUeMxX/Yl7bDqX7WDxAAXeI6PBG5ty0fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dWN6pS3w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dWN6pS3w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B3B41F00A3A;
	Tue, 18 Aug 2026 07:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787038467;
	bh=iBhl2l1hjm/ws91lTCZd717lpErppNIv1jTlviaJUrM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dWN6pS3wrRZQSbJvzYTch94u5k/Q+en44YVcIxaYXYpCmT6jCRkuZx4ac+QIq7W8V
	 yOzshldJdNTv4f9pH5wSCQDlrnpHK63zW6Z0vt1jTljsgpfQkJTYjsp2UY/p2u35uC
	 sb9Bj3ofElGkoqrrXUFByZcm0MmQKhGVUO9HIkVecGl7BV6gXGp+TfAd2zEo6ATi/p
	 Efn7Jyb3phkxw6CG5wjWViB/XKhKdCy6LnOjbLA2MzKaukFHgo2uvl+CubdFedpolr
	 6NKNgHHOZQmwsGPquHcOUKEZareESsNHccTiTTh+d92RRn2eF/NUpdcPlIb8/UJ3XV
	 Ft07u1W5sX/uA==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 4/5] md/raid1: use rot policy when no nonrot disk is
 readable
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chen Cheng" <chencheng@fnnas.com>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260818070646.1029149-5-chencheng@fnnas.com>
References: <20260818070646.1029149-1-chencheng@fnnas.com>
 <20260818070646.1029149-5-chencheng@fnnas.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 18 Aug 2026 07:34:26 +0000
Message-Id: <20260818073427.3B3B41F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Low] The patch leaves behind dead code related to `conf->nonrot_disks`.

Pre-existing issues:
- [High] Lockless iteration over `conf->mirrors` lacks `READ_ONCE()` and RC=
U protection, leading to TOCTOU NULL pointer dereferences and Use-After-Fre=
e during concurrent device removal.
--

--- Patch [4]: [RFC PATCH 4/5] md/raid1: use rot policy when no nonrot disk=
 is readable ---
commit 53dd92b2fd0628bc1951a803d06d7fa324cf3f85
Author: Chen Cheng <chencheng@fnnas.com>

md/raid1: use rot policy when no nonrot disk is readable

has_nonrot selects mixed policy or rot-only policy. Currently, has_nonrot
is true if conf->nonrot_disks > 0, which counts every nonrot disk including
faulty or WriteMostly disks. This commit updates the logic to look at disks
that can actually take the read, and if none are nonrot, uses the rot-only
policy.

> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 523b55d427791..f476d4dea4be5 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -795,6 +795,24 @@ static int raid1_rr_pos(int disk, int start, int n)
>  	return ((disk % n) - start + n) % n;
>  }
> =20
> +static bool raid1_has_readable_nonrot(struct r1conf *conf,
> +				      struct r1bio *r1_bio)
> +{
> +	int disk;
> +
> +	for (disk =3D 0; disk < conf->raid_disks * 2; disk++) {
> +		struct md_rdev *rdev;
> +
> +		if (r1_bio->bios[disk] =3D=3D IO_BLOCKED)
> +			continue;
> +		rdev =3D conf->mirrors[disk].rdev;
> +		if (rdev_readable(rdev, r1_bio) &&
> +		    test_bit(Nonrot, &rdev->flags))
> +			return true;

[Severity: High]
This is a pre-existing issue, but does this lockless iteration over
conf->mirrors lack READ_ONCE() and RCU protection?

In raid1_has_readable_nonrot(), we read conf->mirrors[disk].rdev locklessly.
If HOT_REMOVE_DISK runs concurrently, raid1_remove_conf() can zero the rdev
pointer. Without READ_ONCE(), the compiler might reload the pointer between
the NULL check inside rdev_readable() and test_bit(Nonrot, &rdev->flags),
causing a NULL pointer dereference.

Additionally, since raid1_read_request() (which calls read_balance() and th=
en
raid1_has_readable_nonrot()) does not hold rcu_read_lock(), could the reader
be preempted, allowing md_kick_rdev_from_array() to complete synchronize_rc=
u()
and free the rdev, resulting in a Use-After-Free?

This identical pattern is also present in choose_best_rdev().

> +	}
> +	return false;
> +}
> +

[ ... ]

> @@ -816,7 +834,7 @@ static int choose_best_rdev(struct r1conf *conf, stru=
ct r1bio *r1_bio)
>  {
>  	int disk;
>  	int rr_start =3D 0;
> -	bool has_nonrot =3D READ_ONCE(conf->nonrot_disks);
> +	bool has_nonrot =3D raid1_has_readable_nonrot(conf, r1_bio);

[Severity: Low]
Does this change leave conf->nonrot_disks as dead code?

By removing the only reader of conf->nonrot_disks in choose_best_rdev(),
should the nonrot_disks field also be removed from struct r1conf in
drivers/md/raid1.h, as well as the updates to it in raid1_add_conf() and
raid1_remove_conf()?

>  	struct read_balance_ctl ctl =3D {
>  		.closest_dist_disk      =3D -1,
>  		.closest_dist           =3D MaxSector,

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818070646.1029=
149-1-chencheng@fnnas.com?part=3D4
