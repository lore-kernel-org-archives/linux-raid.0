Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795741077;
	b=Q7t/VKDRV/RPyyFoAAiG1P3JquwLo5YR0UUcrmvzbag+OXZ//gC5+3BNzmkKmOSa4Eea
	 j5YiDmPM3hE/n1rHS3bsTApM/JZlitPR7HdPHk34+K3V18tzwE/z5NTgRCxZ00wNzfU89
	 E3aKPah9wYrE8K79O7b5UQoRxUUgLxwYmTAhziTjxTZtkG7dCSMAPoGvxDfa40gdvhOKc
	 VAKIUPF8Av2rDug53fbtlsU2o57JSnM5hdOD+IDomf3BEIFAlnBaVvAbTbEqERP4fsW59
	 voUyaT+J8KvryefB0v7orKNn13/kFH0x6jGlJxTKzPt+N80xEyZVs3wWny/7OD6F8NA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795741077;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=rD7nCyyt9fkvOTsV10d+viAwLj87UqHcUMq+dqgMbp8=;
	b=2H3lfTug2bZQg8OGdCaNHSsgfIkIsPXZG+3qW3F8I+PMKrW8IpDB3+QwoFZ7+t0IuPaA
	 lA8ML0/0R7pMuoo0uPknZYB2cqf6m8HSXnJOjU0AyDzDacjjSXeCF4AQlwhEe+IJNywM4
	 qhW8CqO+GvjtDR5uCCdHfZwUT9Bs+3bTVSM5hw6tJFBPH546mEE77IV12MAFqZPa83v88
	 ScZxPtBPY5YCHinmzlMUpDtJDDKqZJJCWXG7x3Rj1VgckqP7jT2629S5w+LCLVzX8WEm4
	 aUTFeXt6rPQH+jFf47zDJIA7pVzhlfsGx42RSTH25IFjiK3yvU3F7h6sR5Jkr6g01jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="d/dGUoNt";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0477C606A31C
	for <linux-raid@vger.kernel.org>; Fri, 27 Nov 2026 00:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d/dGUoNt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 734DA1F00897;
	Fri, 27 Nov 2026 00:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795741076;
	bh=rD7nCyyt9fkvOTsV10d+viAwLj87UqHcUMq+dqgMbp8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=d/dGUoNt3ln1kkqRfEOUKJLGCmG5nFUPE4keXM+CGS9cJMqM0Ok7Iu8qNxvrwAOI3
	 bFvivY/zRk7HMF7JQc8+lbgUa3fWBoGzXhpn9huaKWhRC8JezDi6SYzObYEKmwUF2a
	 PxZ0DeA1EVWFuYy7K9JvxFae7I7yEihpstQXv0H13qR9kAzi9jCssP+J0umEgi/uFu
	 5oKndyaWx0RA1GyzKBPOx3+cCKHYZAkp1gdrJZPHzngBikuE2gRnwcI3OqcaHRNyXi
	 +qIaZ2RLVal+tJ34y6g4tChOsu1Uyb1fVLSMLRqgGqIYomzb2pdzwQhe59CUvJmOW8
	 z4BRCY+5YD7hQ==
Message-ID: <sashiko-outbox-236382@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5/8] md/raid1,raid10: hold writes that fail on a faulty
 device
Reply-To: sashiko-reviews@lists.linux.dev
To: "Miroslav Cimerman" <mc@raidlab.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20261127003231.1180197-6-mc@raidlab.org>
References: <20261127003231.1180197-1-mc@raidlab.org>
 <20261127003231.1180197-6-mc@raidlab.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 00:57:56 +0000
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] md/raid10: unheld write and nr_pending leak when repl_bio
  fails
--

commit 13f36c8d107f279dd87814c77406033640b24af3
Author: Miroslav Cimerman <mc@raidlab.org>

md/raid1,raid10: hold writes that fail on a faulty device

This commit holds writes whose mirror copy fails on an already Faulty
device in raid1 and raid10 until the superblock records the failure, while
skipping narrow_write_error() retries on Faulty devices.

> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 838ae71205c1a..519b6ac0accd0 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -473,7 +473,6 @@ static void raid10_end_write_request(struct bio *bio)
>  	struct r10conf *conf =3D r10_bio->mddev->private;
>  	int slot, repl;
>  	struct md_rdev *rdev =3D NULL;
> -	struct bio *to_put =3D NULL;
>  	bool ignore_error =3D !raid1_should_handle_error(bio) ||
>  		(bio->bi_status && bio_op(bio) =3D=3D REQ_OP_DISCARD);
> =20
> @@ -505,17 +504,10 @@ static void raid10_end_write_request(struct bio *bi=
o)
>  			}
> =20
>  			/*
> -			 * When the device is faulty, it is not necessary to
> -			 * handle write error.
> +			 * Hold the write until the superblock records the
> +			 * failure, also on a Faulty device.
>  			 */
> -			if (!test_bit(Faulty, &rdev->flags))
> -				set_bit(R10BIO_WriteError, &r10_bio->state);
> -			else {
> -				/* Fail the request */
> -				r10_bio->devs[slot].bio =3D NULL;
> -				to_put =3D bio;
> -				dec_rdev =3D 1;
> -			}
> +			set_bit(R10BIO_WriteError, &r10_bio->state);
>  		}
>  	} else {
>  		/*
> @@ -560,8 +552,6 @@ static void raid10_end_write_request(struct bio *bio)
>  	one_write_done(r10_bio);
>  	if (dec_rdev)
>  		rdev_dec_pending(rdev, conf->mddev);
> -	if (to_put)
> -		bio_put(to_put);
>  }
> =20
>  /*
> @@ -2926,7 +2916,9 @@ static void handle_write_completed(struct r10conf *=
conf, struct r10bio *r10_bio)
>  				rdev_dec_pending(rdev, conf->mddev);
>  			} else if (bio !=3D NULL && bio->bi_status) {
>  				fail =3D true;
> -				narrow_write_error(r10_bio, m);
> +				/* No retries on a Faulty device */
> +				if (!test_bit(Faulty, &rdev->flags))
> +					narrow_write_error(r10_bio, m);
>  				rdev_dec_pending(rdev, conf->mddev);
>  			}
>  			bio =3D r10_bio->devs[m].repl_bio;

[Severity: Medium]
Can a failing r10_bio->devs[slot].repl_bio complete without being held or
leak rdev->nr_pending?

In raid10_end_write_request(), if conf->mirrors[dev].replacement is still
present (repl =3D=3D 1), a write failure only calls md_error() and never se=
ts
R10BIO_WriteError, so the write completes immediately instead of waiting
for the superblock update.

If instead raid10_remove_disk() concurrently promotes p->replacement to
p->rdev and clears p->replacement while repl_bio is in flight,
raid10_end_write_request() falls back to repl =3D 0, sets dec_rdev =3D 0 and
R10BIO_WriteError (now even when the promoted device is Faulty):

drivers/md/raid10.c:raid10_end_write_request() {
	if (repl)
		rdev =3D conf->mirrors[dev].replacement;
	if (!rdev) {
		smp_rmb();
		repl =3D 0;
		rdev =3D conf->mirrors[dev].rdev;
	}
	if (bio->bi_status && !ignore_error) {
		if (repl)
			md_error(rdev->mddev, rdev);
		else {
			rdev_record_write_error(rdev);
			dec_rdev =3D 0;
			...
			set_bit(R10BIO_WriteError, &r10_bio->state);
		}
	}
}

Because the failed bio sits in r10_bio->devs[m].repl_bio rather than
r10_bio->devs[m].bio, handle_write_completed() never sees bio->bi_status on
it:

CPU0                              CPU1
raid10_remove_disk()
  WRITE_ONCE(p->rdev, p->replacement);
  WRITE_ONCE(p->replacement, NULL);
                                  raid10_end_write_request(repl_bio)
                                    rdev =3D conf->mirrors[dev].replacement;
                                    /* NULL -> repl =3D 0, rdev =3D p->rdev=
 */
                                    dec_rdev =3D 0;
                                    set_bit(R10BIO_WriteError, ...);
                                  raid10d()
                                    handle_write_completed()
                                      bio =3D r10_bio->devs[m].bio;
                                      /* bio->bi_status =3D=3D 0 */
                                      bio =3D r10_bio->devs[m].repl_bio;
                                      /* only IO_MADE_GOOD is checked */
                                      <-- rdev->nr_pending leaked,
                                          write not held

That permanently leaks rdev->nr_pending (preventing later disk removal) and
skips holding the write.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127003231.1180=
197-1-mc@raidlab.org?part=3D5
