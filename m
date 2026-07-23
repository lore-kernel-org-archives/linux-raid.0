Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39A1473C9B
	for <linux-raid@vger.kernel.org>; Thu, 23 Jul 2026 11:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784807258; cv=none; b=kOIPu8WS+PDI8XKT8fXWLSr54IYWRt/vLt52OniO6y9TQFxmS982RbwaDASMxnSmMzA0geqD19XiyUNwQWDz+rgLVjPJzape26qyhsoKRW/64vUaBfOLJqLRvciJ5UvkXx1mVNqfJewv5iIYww4sVg+x0aHmZqDb2/+QRRL8ggo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784807258; c=relaxed/simple;
	bh=ZLINl3R1dEdsmi/A7sluW7q9Ur03okOq9+IwNMUPHTk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bt3yIh2w0mnUMIKdnKtlTg0E92uvx2kCQaDTSWWimqgGD/9dZHeYkSMuxPEe/BkdYZE2xun1ejopDCfsuFPLHyH5bYyTuwJifafTSiQpE/vMgS0yqDDeJbT5J9sImb4qxdOdYaHMqU4LyazPQ3cq+odSPOgxV5yj/VoOmjGDJYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFEE81F000E9;
	Thu, 23 Jul 2026 11:47:28 +0000 (UTC)
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] md/raid1: create serial pool adding rdev to array with
 serialize_policy=1
Reply-To: sashiko-reviews@lists.linux.dev
To: "Martin Wilck" <martin.wilck@suse.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260723112741.1206836-1-mwilck@suse.com>
References: <20260723112741.1206836-1-mwilck@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 11:47:24 +0000
Message-Id: <20260723114728.CFEE81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but `mddev_create_se=
rial_pool` silently ignores memory allocation failures, leading to a guaran=
teed kernel panic on subsequent I/O.
- [High] This problem wasn't introduced by this patch, but echoing `-writem=
ostly` to a device's sysfs state unconditionally destroys its serialization=
 structures, even if the array-wide `MD_SERIALIZE_POLICY` is active, causin=
g a NULL pointer dereference on the next I/O.
--

--- Patch [1]: [PATCH] md/raid1: create serial pool adding rdev to array wi=
th serialize_policy=3D1 ---
commit ac16670aca465de3c72a1f91b7b1bbb4e463a255
Author: Martin Wilck <martin.wilck@suse.com>

md/raid1: create serial pool adding rdev to array with serialize_policy=3D1
   =20
The raid1.c code calls wait_for_serialization() if the MD_SERIALIZE_POLICY
is set, and wait_for_serialization assumes that rdev->serial is
initialized. Normally this will be the case for arrays that have
the serialize_policy sysfs attribute set to 1.
   =20
But when a new rdev is added to an existing array in bind_rdev_to_array(),
the condition at mddev_create_serial_pool() causes creation of rdev->serial
to be skipped. Fix it.
   =20
Fixes: 69b00b5bb235 ("md: introduce a new struct for IO serialization")
Signed-off-by: Martin Wilck <mwilck@suse.com>

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d1465bcd86c81..baf79c501c9ec 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -234,7 +234,8 @@ void mddev_create_serial_pool(struct mddev *mddev, st=
ruct md_rdev *rdev)
>  {
>  	int ret =3D 0;
> =20
> -	if (rdev && !rdev_need_serial(rdev) &&
> +	if (!test_bit(MD_SERIALIZE_POLICY, &mddev->flags) &&
> +	    rdev && !rdev_need_serial(rdev) &&
>  	    !test_bit(CollisionCheck, &rdev->flags))
>  		return;
> =20

[Severity: High]
This isn't a bug introduced by this patch, but I noticed that
mddev_create_serial_pool() silently ignores memory allocation failures.

If rdev_init_serial() or mempool_create_kmalloc_pool() fails due to memory
pressure, mddev_create_serial_pool() catches the error but returns early
without propagating it:

drivers/md/md.c:mddev_create_serial_pool() {
	...
	if (ret)
		return;

	if (mddev->serial_info_pool =3D=3D NULL) {
	...
}

Callers like bind_rdev_to_array() proceed as if successful, setting the
MD_SERIALIZE_POLICY bit. On the next I/O, raid1_make_request() invokes
serialization functions like check_and_add_serial() that unconditionally
dereference the unallocated rdev->serial pointers:

drivers/md/raid1.c:check_and_add_serial() {
	...
	struct serial_in_rdev *serial =3D &rdev->serial[idx];
	spin_lock_irqsave(&serial->serial_lock, flags);
	...
}

Should mddev_create_serial_pool() return an error code instead of void to
prevent this crash?

[Severity: High]
This is another pre-existing issue, but while reviewing the serialization
logic I noticed that echoing "-writemostly" to a device's state via sysfs
unconditionally destroys its serialization structures.

In state_store(), this destroys the serial pool for the specific rdev witho=
ut
checking the array-wide policy:

drivers/md/md.c:state_store() {
	...
	} else if (cmd_match(buf, "-writemostly")) {
		mddev_destroy_serial_pool(rdev->mddev, rdev);
		clear_bit(WriteMostly, &rdev->flags);
	...
}

This unconditionally frees rdev->serial for the device:

drivers/md/md.c:mddev_destroy_serial_pool() {
	...
	if (rdev)
		rdev_uninit_serial(rdev);
	...
}

If the array-wide MD_SERIALIZE_POLICY is still active, the next I/O will
invoke wait_for_serialization() and remove_serial(), which dereference the
now-freed rdev->serial pointer:

drivers/md/raid1.c:check_and_add_serial() {
	...
	struct serial_in_rdev *serial =3D &rdev->serial[idx];
	spin_lock_irqsave(&serial->serial_lock, flags);
	...
}

Should state_store() check if MD_SERIALIZE_POLICY is still active before
destroying the serial pool?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723112741.1206=
836-1-mwilck@suse.com?part=3D1
