Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09B81E7C2E;
	Sun, 19 Jul 2026 11:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784459298; cv=none; b=WoqenpfJ2zZvGArp0h8LsaBPKhaeemUGKZV4/UjKHv66gThZof0NQ/HqqYyhm69h9XEPTSPnFGvym1bWaXPAknVHbzBIjM8ZJOaDX+slTsPfF6t7OD3uzxb0p2tHvf0NZToKifm1jTv2ZcBpHugnQ/HqKh1Sv5HrsSFqSo0iqfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784459298; c=relaxed/simple;
	bh=Vcn2fxcn+kFXBE7E4Xto8E1/cdomZjscw8oi3+cKTNQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TvNVOX8am14MZZ5l9h3OAKrEjwPkIqBHmtlik0yyIptRRX64st9pU2lbeghJeiLuqaz5Hr0Ne/TThLlYyN006oGnDVqkqaC80oWSSY52983z1rJuyLy3Tl66TLisewO9bLZpp3YQHgUrh5MRn+EPDLzEU0PEo9DH2G+CTGiz7E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mwHMRiO9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mwHMRiO9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 193E81F000E9;
	Sun, 19 Jul 2026 11:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784459297;
	bh=1bMSedFfiG4eFI/LIworAfGO4azskM7FAuok5QwaPFU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mwHMRiO9IM8fbai03WoDq5meGEnOuO9OZ0QJLLxrhAP2rqVEdv2JX8PV8nRGXpxTA
	 vXQEOTyu2wExhwUHMNrcp+D0lS27q9pyC/UQnKLBeL1WaHYIy8G75UmsFRQFziuxGw
	 dZsc6VLI6KoS7s4RkU237erTRKTZ+mVnWy1gunUj9KcfBhxTbK1c/7PYM1Oup2mIz+
	 yhf2Aly9FbFa9W3MybHJBcVWu1acDwbZUYBb0+oNHMevCJtSG0mruhrdPYrz9uT6d+
	 vG410oNeaduMhMcb+6wqa8UiZnWBEu8j4oY0pJdIjfl2y1+l1hLVEXe7p4DcmvW396
	 ycq9flA7OTWBw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/7] md/raid1: serialize non-write-behind writes on
 CollisionCheck rdevs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: linux-raid@vger.kernel.org, linux-pci@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260719105327.864949-4-mykola@meshstor.io>
References: <20260719105327.864949-1-mykola@meshstor.io>
 <20260719105327.864949-4-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 19 Jul 2026 11:08:16 +0000
Message-Id: <20260719110817.193E81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] Hot-added disks silently bypass array-wide serialization when MD_S=
ERIALIZE_POLICY is enabled, defeating write ordering guarantees.

Pre-existing issues:
- [High] REQ_NOWAIT bios can block during clone allocation and serializatio=
n, violating non-blocking semantics.
- [High] The serialization logic fails to properly order a write against al=
l overlapping in-flight writes when there are multiple independent collisio=
ns.
--

--- Patch [3]: [PATCH v2 3/7] md/raid1: serialize non-write-behind writes o=
n CollisionCheck rdevs ---
commit 26970b9339baa20abd27398542d6d87116b76717
Author: Mykola Marzhan <mykola@meshstor.io>
md/raid1: serialize non-write-behind writes on CollisionCheck rdevs

This commit changes the gate for non-write-behind serialization in raid1
from the array-wide MD_SERIALIZE_POLICY to the per-device CollisionCheck
flag. This ensures write-behind writes and non-write-behind writes are
correctly serialized against each other on members that require it.
Discards are also now ordered on this path.

> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
[ ... ]
> @@ -1677,7 +1677,14 @@ static bool raid1_write_request(struct mddev *mdde=
v, struct bio *bio,
>  			mbio =3D bio_alloc_clone(rdev->bdev, bio, GFP_NOIO,
>  					       &mddev->bio_set);

[Severity: High]
This is a pre-existing issue, but does this code block REQ_NOWAIT bios?

Calling bio_alloc_clone() with GFP_NOIO can block in memory reclaim, and
wait_for_serialization() unconditionally sleeps in wait_for_completion().

If the original bio has the REQ_NOWAIT flag set, won't this violate the
non-blocking semantics and potentially stall async submission threads like
io_uring?

> -			if (test_bit(MD_SERIALIZE_POLICY, &mddev->flags))
> +			/*
> +			 * Order against in-flight write-behind I/O: a
> +			 * behind write is acked early, and an unordered
> +			 * overwrite could land first, leaving its stale
> +			 * data on the member last. CollisionCheck marks
> +			 * every rdev that owns a serial tree.
> +			 */
> +			if (test_bit(CollisionCheck, &rdev->flags))
>  				wait_for_serialization(rdev, r1_bio);

[Severity: High]
Does this change unintentionally disable serialization for hot-added disks?

If a user enables serialize_policy to enforce strict write ordering, and th=
en
hot-adds a new disk that isn't WriteMostly, mddev_create_serial_pool() in
drivers/md/md.c will exit early:

drivers/md/md.c:mddev_create_serial_pool() {
    ...
    if (rdev && !rdev_need_serial(rdev) &&
        !test_bit(CollisionCheck, &rdev->flags))
        return;
    ...
}

Because this setup exits without allocating a serial tree or setting the
CollisionCheck flag, won't the new per-device check here in
raid1_write_request() silently bypass wait_for_serialization() for the new
disk, even though the array-wide MD_SERIALIZE_POLICY is active?

[Severity: High]
This is a pre-existing issue, but does wait_for_serialization() handle
multiple overlapping writes correctly?

If we have two in-flight writes, A (sectors 0-100) and Y (sectors 120-200),
and a new write B (sectors 50-150) is submitted, it overlaps both. When B
checks for collisions, it finds A and waits.

When A completes, remove_serial() inserts B into the interval tree and wakes
it up:

drivers/md/raid1.c:remove_serial() {
    ...
    raid1_rb_insert(iter_si, &serial->serial_rb);
    complete(&iter_si->ready);
    ...
}

When B re-checks for collisions in check_and_add_serial(), the tree now
contains B and Y. raid1_rb_iter_first() will return B since its start sector
is lower than Y's:

drivers/md/raid1.c:check_and_add_serial() {
    ...
    head_si =3D raid1_rb_iter_first(&serial->serial_rb, lo, hi);
    if (head_si && head_si !=3D si) {
    ...
}

Since head_si =3D=3D si (B =3D=3D B), the collision handler is skipped. Doe=
s this
mean B will execute concurrently with Y, bypassing serialization for the
120-150 region?

>  		}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260719105327.8649=
49-1-mykola@meshstor.io?part=3D3
