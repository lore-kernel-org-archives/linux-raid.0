Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A62D37C11B;
	Sun, 19 Jul 2026 11:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784459504; cv=none; b=eLZbwTmJCdbnR38CoFNcpkxHRechqkJma8vnf244ht3tV19gYaPHkzIAB0ECMkO8bpRGpRUWRRtVJ0C/s6mpZDTrmFFTTVRm/p+lPv1nl0ipZJyNvVb5qCNKcyuB/0/KbtvZMk+MeuOkccdQ1BVGshbjmqdJ7V/XXd7nJ4OYn6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784459504; c=relaxed/simple;
	bh=pgpUK0wFVu38lQLKO7Hx5xQAoM6kapAP3UmxLIpQfL8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ht3WwFR66XrvZawAug9vrBjwhj7PRjquFWlcLv3+uBfJ4bTuhs0PbmxQjqf8HhWM3XtNDP8/tdyZ20iLEFhA48/CZBLILtt/3Y9XPiCIQ1ghcJ9bsywhT+cFC8R2G4t850klcGgL6/b84SnS3Y44T9BvqQXiWIY8uGtnjqSGuLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=huB4///a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="huB4///a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66E81F000E9;
	Sun, 19 Jul 2026 11:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784459502;
	bh=eicqpIhBLBohzg6N8U+Mp1DkQD/3b8m5s/YuczxOZRI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=huB4///ao3L2iHMjHB+bbDSrtMHfPJYsTDxSP/4paFUMW5pSWK6iudPLAZj/Jw9tS
	 IvUw5WT4rhtksF356j1NcHniDtZocDvLQMKqhRju4znn0oEpYEg8hPysp2gHG6oVB1
	 4OWE9rAQ3kVOUJcarMylLVNtLW90cWwio083edjJPaih7RHk2TOmNvB3M9vlfUZthI
	 8ORCZs7yl5mx2G0d7XyvQEhbvMGyGAGYl5fbXO8KUGR01ZQMkhXkO9i5Uk0NlWeuwS
	 Z/wj0MRSPPa+rOz5T8PA3V3WjyNUYA7OBU+46nP0Mh38T39x39C/oMk92agU47eEln
	 aKEYok2lU2Dow==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 6/7] md/raid1,raid10: skip futile retries on P2PDMA
 mapping failures
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: yukuai@fygo.io, linux-pci@vger.kernel.org, linux-raid@vger.kernel.org
In-Reply-To: <20260719105327.864949-7-mykola@meshstor.io>
References: <20260719105327.864949-1-mykola@meshstor.io>
 <20260719105327.864949-7-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 19 Jul 2026 11:11:42 +0000
Message-Id: <20260719111142.B66E81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Forcing REQ_OP_WRITE on failed dataless bios in narrow_write_error=
() causes a NULL pointer dereference.
- [High] narrow_write_error drops critical bio flags (such as REQ_FUA or RE=
Q_PREFLUSH) when retrying failed writes.
- [High] Possible NULL pointer dereference when logging unrecoverable read =
errors in raid1.
--

--- Patch [6]: [PATCH v2 6/7] md/raid1,raid10: skip futile retries on P2PDM=
A mapping failures ---
commit ff103403bf433f1316745e0b4415b739bb72c8d1
Author: Mykola Marzhan <mykola@meshstor.io>

md/raid1,raid10: skip futile retries on P2PDMA mapping failures

This commit adds tracking for P2PDMA masters via a state bit to handle peer
device memory mapping failures explicitly. It prevents kicking healthy mirr=
ors
and short-circuits futile retry loops by treating unroutable P2PDMA bio
failures as a property of the topology rather than the medium.

> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
[ ... ]
> @@ -1378,6 +1388,8 @@ static void raid1_read_request(struct mddev *mddev,=
 struct bio *bio,
>  	else
>  		init_r1bio(r1_bio, mddev, bio);
>  	r1_bio->sectors =3D max_read_sectors;
> +	if (md_bio_is_p2pdma(bio))
> +		set_bit(R1BIO_P2PDMA, &r1_bio->state);
> =20
>  	/*
>  	 * make_request() can abort the operation when read-ahead is being

[Severity: High]
This is a pre-existing issue, but could the error logging in
raid1_read_request() result in a NULL pointer dereference?

When an unrecoverable read error occurs, handle_read_error() drops its
active reference to the failing device via rdev_dec_pending() and then calls
raid1_read_request() to attempt a retry.

If read_balance() cannot find an alternative mirror, the error logging uses
conf->mirrors[r1_bio->read_disk].rdev->bdev:

    rdisk =3D read_balance(conf, r1_bio, &max_sectors);
    if (rdisk < 0) {
        if (r1bio_existed)
            pr_crit_ratelimited("md/raid1:%s: %pg: ...\n",
                        mdname(mddev),
                        conf->mirrors[r1_bio->read_disk].rdev->bdev,
                        r1_bio->sector);
        raid_end_bio_io(r1_bio);
        return;
    }

Since the reference to this disk was just dropped and the RCU read lock
is not held, is it possible for a concurrent hot_remove_disk operation to s=
et
rdev to NULL, leaving this bdev access unprotected?

[ ... ]
> @@ -2539,7 +2553,7 @@ static void fix_read_error(struct r1conf *conf, str=
uct r1bio *r1_bio)
>  	}
>  }
> =20
> -static void narrow_write_error(struct r1bio *r1_bio, int i)
> +static void narrow_write_error(struct r1bio *r1_bio, int i, bool coarse)
>  {
>  	struct mddev *mddev =3D r1_bio->mddev;

[Severity: High]
This isn't a bug introduced by this patch, but does the error retry path
in narrow_write_error() inadvertently corrupt the bio operation and flags?

When cloning a failed bio for retrying, the code unconditionally overwrites
the bi_opf field:

    wbio->bi_opf =3D REQ_OP_WRITE;

If the failed master bio was a dataless operation (such as REQ_OP_WRITE_ZER=
OES),
the operation override happens before bio_trim(). For multi-block requests,
bio_trim() calls bio_advance(). Because the bio is now incorrectly seen as a
standard write, bio_no_advance_iter() returns false, and the block layer
attempts to advance the NULL bi_io_vec, which will cause a kernel panic.

Additionally, the direct assignment of REQ_OP_WRITE completely clobbers
pre-existing request flags. If a flush or FUA write fails and is retried,
it seems it will be submitted as a normal asynchronous write. If the retry
succeeds, data durability guarantees might be violated since the data could
only reside in the volatile disk cache.

[ ... ]
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
[ ... ]
> @@ -2786,7 +2803,7 @@ static void fix_read_error(struct r10conf *conf, st=
ruct mddev *mddev, struct r10
>  	}
>  }
> =20
> -static void narrow_write_error(struct r10bio *r10_bio, int i)
> +static void narrow_write_error(struct r10bio *r10_bio, int i, bool coars=
e)
>  {
>  	struct bio *bio =3D r10_bio->master_bio;

[Severity: High]
This is a pre-existing issue, but does narrow_write_error() similarly
corrupt dataless bios and drop durability flags here?

Similar to raid1, the clone unconditionally overwrites bi_opf:

    wbio->bi_opf =3D REQ_OP_WRITE;

While bio_trim() happens before the override in raid10 (avoiding the
iterator crash), it appears to submit the modified REQ_OP_WRITE bio
without a payload to lower drivers, which could crash during DMA mapping.

It also drops critical bio modifiers like REQ_FUA or REQ_PREFLUSH, which
could lead to silent data corruption on power failure if a synchronous write
encounters a transient error.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260719105327.8649=
49-1-mykola@meshstor.io?part=3D6
