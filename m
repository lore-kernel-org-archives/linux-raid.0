Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795741316;
	b=k05bbrOYn55fYlTmOoMSzqlUvXahQDO1+RPmDyvh+VoNrhUXjGqofABID91DmHRRRBrX
	 z1DunpPaQ6fiy3GfGBTkAyxcLVVgyUyvacAGHQqfQzodZJQ7xuCVALOgvJAWvbv7/lt+O
	 NU2W+1K9Gna5t6WbBhx7CuEqB94o0QpgBrSHfyQFUqoBxpvY6keOXYWllorg/ToFOhj8W
	 XZkiGz2uCnqwvpmV5AYH4tUhXubmBIZn15GLTG354HFLU/iYXrkPS37O0DqpjfeSb+dVj
	 YKUuO9UNynOrbklYwVBxP8wU3rrM7nWc5b76cdxZWUcXOsOPDhsOOb2cBvLv+5w+qNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795741316;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=HrG0+ZNIcCtlcqfclKULrHvkJRF7TPK+7Pr0mauU+po=;
	b=JzZkX/CBiwVhTa7I1zV+plTpI+FRBjNTqxuYkBaxuf4CxLAwZX1/TkyFAMZHrcSxMoer
	 W/5ZGmbBZ5MCcpkqMsee5Kkcl/2V5EdWxHolM/+lX0SaIHipC+tHs/8D+rQRxB9GQFybZ
	 7KewHrGHKtpDRtbG4gW1J1UBLj5BKxG1qVnykiuHWW+orDc63OhMSvef+QgsZluepqp93
	 ywThCV9V+3O47SOECPZYABvSwSwXj+oQ72Vdcoy1TMc4s/vT1gjlg+e+31rreGhO+ASyY
	 vB+RaqKdDudG5y1EGdLPdx80VVsOc/jKYdoLSJ50vQd5a4at9nob+04+EGNtNlJO2CA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NpjhqVyx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24EF3606A31C
	for <linux-raid@vger.kernel.org>; Fri, 27 Nov 2026 01:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NpjhqVyx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6DA51F00899;
	Fri, 27 Nov 2026 01:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795741316;
	bh=HrG0+ZNIcCtlcqfclKULrHvkJRF7TPK+7Pr0mauU+po=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NpjhqVyxZh0RmKXdb3OV3A3BS3DF+jdHLI1x9MuioJZL8zw4UpabZrzrXOxCIUdkn
	 99MxxiP58mpK65WorlOxf8mGz/fSNyfUObTL40+G4DmXHI9gUA+PT0Yulk+DJZOmsl
	 8gVre7N2cd/5ErEXSs2R51IfDukD9EbdsHM7Fw88fJ6krrhVpHk50ttlVyl6LVcKhj
	 UYAgfpeZzXXYSc+/NJ1Zb+l1xW9XI56ko/d65EW8TPjKyf1rHOLzUv/enltUHrKMMk
	 5GwNcOAqimKYZo7yu+JmxAO8cNcVMFlrHJ1WQg0NiAW4dBuMavwK+y0yXgPhHIeYz1
	 z52FX4ON7mOSQ==
Message-ID: <sashiko-outbox-236387@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 7/8] md/raid1,raid10: hold writes that skip a newly
 failed device
Reply-To: sashiko-reviews@lists.linux.dev
To: "Miroslav Cimerman" <mc@raidlab.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20261127003231.1180197-8-mc@raidlab.org>
References: <20261127003231.1180197-1-mc@raidlab.org>
 <20261127003231.1180197-8-mc@raidlab.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 01:01:55 +0000
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential
issues to consider:
- [High] md/raid1,raid10: ignored errors on faulty device skip hold and
  underflow nr_pending
- [Medium] md/raid10: newly failed replacement devices skipped in
  raid10_write_request()
- [Medium] md/raid1: write-behind bypasses hold for faulty rdev in
  raid1_write_request()
- [Medium] md/raid1,raid10: race with slot_store() when selecting faulty
  rdev
--

commit 1e300613f1afedbc7152ab6fe06cab49a896efac
Author: Miroslav Cimerman <mc@raidlab.org>

md/raid1,raid10: hold writes that skip a newly failed device

This commit assigns writes to a newly Faulty device while it is still
Blocked or after MD_BROKEN is set, so that raid1_submit_write() fails the
copy and holds the write until the superblock records the failure.

[ ... ]

> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index f596b36ec6e10..508673e8c02e8 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1524,8 +1524,15 @@ static bool raid1_write_request(struct mddev *mdde=
v, struct bio *bio,
>  			write_behind =3D false;
> =20
>  		r1_bio->bios[i] =3D NULL;
> -		if (!rdev || test_bit(Faulty, &rdev->flags))
> +		if (!rdev)
> +			continue;
> +		if (test_bit(Faulty, &rdev->flags)) {
> +			if (raid1_write_to_faulty(mddev, rdev)) {
> +				atomic_inc(&rdev->nr_pending);
> +				r1_bio->bios[i] =3D bio;
> +			}
>  			continue;
> +		}
> =20
>  		if (test_bit(WriteErrorSeen, &rdev->flags)) {
>  			sector_t first_bad;

[Severity: Medium]
Can a write-behind bio still complete early before the superblock update wh=
en
a WriteMostly device becomes Faulty after wait_blocked_rdev()?

raid1_write_request() sets write_behind =3D true for a WriteMostly rdev bef=
ore
checking Faulty, and later increments r1_bio->behind_remaining when cloning
for that Faulty rdev.  Because write-behind requires an active bitmap,
raid1_add_bio_to_plug() queues the clones instead of calling
raid1_submit_write() immediately, so R1BIO_WriteError is not set yet.  If t=
he
working non-WriteMostly copy completes before raid1_submit_write() fails the
queued Faulty WriteMostly clone, raid1_end_write_request() sees
behind_remaining >=3D remaining - 1 with R1BIO_Uptodate set and
R1BIO_WriteError still clear, and completes master_bio early.

[Severity: Medium]
Can selecting an already-Faulty rdev here (and in raid10_write_request())
race with slot_store() and cause a NULL pointer dereference?

Unlike state_store(), slot_store() does not suspend the array via
rdev_attr_store().  Because an already-Faulty rdev has In_sync cleared,
slot_store() can remove it as soon as Blocked is clear and nr_pending is 0:

CPU0                                  CPU1
raid1_write_request()
  test_bit(Faulty, &rdev->flags)
  raid1_write_to_faulty(mddev, rdev)
                                      slot_store()
                                        clear_bit(Blocked, &rdev->flags)
                                        remove_and_add_spares()
                                          ...
                                          raid1_remove_disk()
                                            /* nr_pending =3D=3D 0 */
                                            p->rdev =3D NULL
  atomic_inc(&rdev->nr_pending)
  r1_bio->bios[i] =3D bio
  ...
  rdev =3D conf->mirrors[i].rdev
  bio_alloc_clone(rdev->bdev, ...)    <-- NULL pointer dereference

> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 519b6ac0accd0..6ea84eb8bf874 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1387,14 +1387,19 @@ static bool raid10_write_request(struct mddev *md=
dev, struct bio *bio,
> =20
>  		rdev =3D conf->mirrors[d].rdev;
>  		rrdev =3D conf->mirrors[d].replacement;
> -		if (rdev && (test_bit(Faulty, &rdev->flags)))
> +		r10_bio->devs[i].bio =3D NULL;
> +		r10_bio->devs[i].repl_bio =3D NULL;
> +
> +		if (rdev && test_bit(Faulty, &rdev->flags)) {
> +			if (raid1_write_to_faulty(mddev, rdev)) {
> +				r10_bio->devs[i].bio =3D bio;
> +				atomic_inc(&rdev->nr_pending);
> +			}
>  			rdev =3D NULL;
> +		}

[Severity: High]
What happens when bio is a REQ_OP_DISCARD or REQ_RAHEAD request and
raid1_write_to_faulty() gives it to a Faulty rdev (both here and in
raid1_write_request())?

raid1_submit_write() fails the clone with bio_io_error(), but
raid1_end_write_request() and raid10_end_write_request() compute
ignore_error =3D true for REQ_OP_DISCARD and REQ_RAHEAD bios:

drivers/md/raid10.c:raid10_end_write_request() {
	bool ignore_error =3D !raid1_should_handle_error(bio) ||
		(bio->bi_status && bio_op(bio) =3D=3D REQ_OP_DISCARD);
	...
	if (bio->bi_status && !ignore_error) {
		...
	} else {
		...
	}

	one_write_done(r10_bio);
	if (dec_rdev)
		rdev_dec_pending(rdev, conf->mddev);
}

Because ignore_error is true, R1BIO_WriteError / R10BIO_WriteError is never
set, so the request is not held for the superblock update (or failed on
MD_BROKEN).  In raid10_end_write_request(), taking the else branch also
leaves dec_rdev =3D 1 and decrements rdev->nr_pending while leaving
r10_bio->devs[slot].bio non-NULL with bi_status !=3D 0.  If another copy in=
 the
same r10_bio sets R10BIO_MadeGood and schedules handle_write_completed(),
handle_write_completed() sees bio !=3D NULL && bio->bi_status on the Faulty
slot and calls rdev_dec_pending() a second time, underflowing
rdev->nr_pending (or dereferencing NULL if rdev was already removed).

>  		if (rrdev && (test_bit(Faulty, &rrdev->flags)))
>  			rrdev =3D NULL;

[Severity: Medium]
Should a newly Faulty replacement device (rrdev) also hold the write while =
it
is Blocked or after MD_BROKEN is set?

wait_blocked_dev() waits for blocked replacement devices just as it did
before commit f2e7e269a752 ("md/raid10: pull the code that wait for blocked
dev into one function"), and after raid10_spare_active() marks a finished
replacement In_sync and marks the old rdev Faulty (without Blocked), the
active mirror stays in conf->mirrors[d].replacement until
raid10_remove_disk() moves it.  If rrdev fails between wait_blocked_dev() a=
nd
this loop (or after MD_BROKEN is set), setting rrdev =3D NULL skips it with=
out
holding the write, allowing the write to complete before the superblock
records rrdev's failure.  (Note that raid10_end_write_request() and
handle_write_completed() also currently do not set R10BIO_WriteError or hold
writes when a repl_bio fails.)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127003231.1180=
197-1-mc@raidlab.org?part=3D7
