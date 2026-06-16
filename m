Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94834299A87
	for <linux-raid@vger.kernel.org>; Tue, 16 Jun 2026 13:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781616635; cv=none; b=MZ6fYTofGMbwxGQBqqE3sbTqgtV3wRJ4WoQH/JewV2QGz3lTu7yZrAtG53VVpGoR4/sDCT85J8EbejglyqKYDfdJ13fVAX1D7/VI1p5s59n/FEjSPCb4Ih/+KuTIfbO7xQG0nkhCpCkiocgNSnQsPjQH8OQ0DzYURLniE1hn4N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781616635; c=relaxed/simple;
	bh=WHAa8sT/GWZibGrGlQRIO3gGSfC4lVSBaiJ80q0iKi0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hTNG9vHyfKmBmh9uV6uMUUu2G1IFD5pbk0ArOF/aIrM1nTgZ9lXfngfFmJVjGEN/67iU/2dc22volrjDSOG4YG3NAI3hM95TWlegI1EoQCIACAhGYBrFze7qKYNhqyERMJezIfwe7h49ng1Is7r/OCWamiKgTlWR8NC1x3Ppg3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KnDihOxg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KnDihOxg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015501F000E9;
	Tue, 16 Jun 2026 13:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781616634;
	bh=rJ2JI8hJpl+aJIQ23RyE0ZzK9u/FmXENktH9GCVC9Ko=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KnDihOxgsmn928DbZsOzsh7jBdQq2d+KDEhXDruYgOySKl8Nzxk5iQUFHBQretcvc
	 RNBN4vBWIt26wqlgrPv6nlzUyTO7YdJSVghC4AHXr9MXFXsGCML0eCJabOFD9mW/le
	 nrTMJpt6ALFZSUUwaRQi6OujDZIozZDS2arNpH2++oSSWdVGOTjth43PbJQL8pBvw6
	 ldFzfEcrwD2kwiIZpHvRXXYgUIBEgDO3vXy1CoGaQNoXQqS+H5frji/+9+JbOavNxB
	 s2W3z+gLSr4RJDLwRu131WcEn+TRH9B1/jeX7I9i3IP3+BZwuX4kJoJERlrNp9iYoo
	 ioSIq/z1jWqJw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] md/raid5: protect bitmap batch counters aka
 seq_flush/seq_write
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chen Cheng" <chencheng@fnnas.com>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260616131310.3790554-1-chencheng@fnnas.com>
References: <20260616131310.3790554-1-chencheng@fnnas.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 16 Jun 2026 13:30:33 +0000
Message-Id: <20260616133034.015501F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Missing full memory barriers between the bitmap update/scan an=
d `seq_flush` access allows torn writes.
--

commit 45ef15a300eccd14518bc90e254146a73a49bf51
Author: Chen Cheng <chencheng@fnnas.com>

md/raid5: protect bitmap batch counters aka seq_flush/seq_write

This commit attempts to fix a KCSAN data-race report on conf->seq_flush
in the raid5 code by introducing READ_ONCE() and WRITE_ONCE().

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index d0d7f96fd7cd9..ffc89ebbc4857 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3538,7 +3538,7 @@ static void __add_stripe_bio(struct stripe_head *sh=
, struct bio *bi,
>  		 sh->dev[dd_idx].sector);
> =20
>  	if (conf->mddev->bitmap && firstwrite && !sh->batch_head) {
> -		sh->bm_seq =3D conf->seq_flush+1;
> +		sh->bm_seq =3D READ_ONCE(conf->seq_flush) + 1;

[Severity: Critical]
This is a pre-existing issue, but does this lockless synchronization require
a full memory barrier (smp_mb()) before reading seq_flush?

The producer sequence updates the in-memory bitmap (which drops a lock,
providing only a Store-Release barrier) and then reads seq_flush. Because
there is no full memory barrier between the store to the bitmap and the load
of seq_flush, weakly-ordered CPUs (and even x86, which allows Store-Load
reordering) can reorder the read of seq_flush before the store to the
bitmap becomes globally visible.

Could this lead to silent data corruption on a crash if the consumer sees
the old bitmap state but the producer assigns the stripe to the current
batch?

>  		set_bit(STRIPE_BIT_DELAY, &sh->state);
>  	}
>  }

[ ... ]

> @@ -5755,7 +5755,7 @@ static void make_discard_request(struct mddev *mdde=
v, struct bio *bi)
>  		}
>  		spin_unlock_irq(&sh->stripe_lock);
>  		if (conf->mddev->bitmap) {
> -			sh->bm_seq =3D conf->seq_flush + 1;
> +			sh->bm_seq =3D READ_ONCE(conf->seq_flush) + 1;

[Severity: Critical]
This is a pre-existing issue, but the same missing full memory barrier
pattern appears here in the discard path as well.

>  			set_bit(STRIPE_BIT_DELAY, &sh->state);
>  		}
> =20

[ ... ]

> @@ -6805,12 +6805,13 @@ static void raid5d(struct md_thread *thread)
>  		if (
>  		    !list_empty(&conf->bitmap_list)) {
>  			/* Now is a good time to flush some bitmap updates */
> -			conf->seq_flush++;
> +			int seq =3D READ_ONCE(conf->seq_flush) + 1;
> +			WRITE_ONCE(conf->seq_flush, seq);

[Severity: Critical]
This isn't a bug introduced by this patch, but does the consumer side
also rely dangerously on implicit barriers?

The consumer (raid5d) writes seq_flush and relies on an implicit full
barrier deep inside unplug() (via test_and_clear_bit) to order the
subsequent bitmap scan.

If the producer's missing barrier allows the read of seq_flush to be
reordered, the consumer might flush the old batch and advance seq_write,
unblocking the producer's stripe to be written to disk without its
write-intent bitmap bit being flushed.

>  			spin_unlock_irq(&conf->device_lock);
>  			if (md_bitmap_enabled(mddev, true))
>  				mddev->bitmap_ops->unplug(mddev, true);
>  			spin_lock_irq(&conf->device_lock);
> -			conf->seq_write =3D conf->seq_flush;
> +			WRITE_ONCE(conf->seq_write, seq);
>  			activate_bit_delay(conf, conf->temp_inactive_list);
>  		}
>  		raid5_activate_delayed(conf);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260616131310.3790=
554-1-chencheng@fnnas.com?part=3D1
