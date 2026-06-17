Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FCE42E06EF
	for <linux-raid@vger.kernel.org>; Wed, 17 Jun 2026 14:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781707433; cv=none; b=QYRuIemuNXjuuW7FriRiXLkZrNz0GogAEMSFFQKh2ZOjcfiCqmRe7MkAmlyBJSk8Uh3jZFn2BOzKWVMFF7ieSp0rG8tZ0J7GFB3EAWKNcmez2JzesbSHXBPuxmIJohB6CkfPM7K/c5KY2BzyPlZRasTvlWAwDoPhmrMcXrYlXb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781707433; c=relaxed/simple;
	bh=2RcwShZ0MhhIuioZxjxI1FSCUu7vHqPlbZoLMK9V59E=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BEUTrQ7AIzcdgpxZ5cRth6kYAr/7p6/3HVLDhV6bPY7F88qpCxt7X6PidA7ZvqdmGQp5lRFheAea4yw+SjmgIjEnAgvTKGuVsn9mbbKAEjnYLf1QhtRCiyeXih8rs06a56ZK2XrKod6ZAWGOn5SFNdVhw9wXd6nxiy1j+/o8xNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cplVnikK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cplVnikK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54E81F000E9;
	Wed, 17 Jun 2026 14:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781707432;
	bh=T4uPhuwOCCqY3JnibFFm/HSAZr3IToANyamKq42yu+g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cplVnikKFhOn/EyIQAnNOTBmDKq9FA3t6TS2E1/Mk/TUyTCh0WUC7JRS8U91pcMz7
	 TQSqVKv14LVFohwUfnkNHOaGqyBWtZ58d1TcaqiF7zE98ViUbbPGKXqRDPHcR7Iu2Y
	 BnKH/XmxgJZ7Nwpe3FXfswau/kYTqd06xErSfttwn1Y2JnHNGcMNJCVQHCik/WiFUP
	 dfCNPQJkhEBu3LFAObfG2uPp6dwyr8Wa7Xr3ax6ThQt4nMw6vZ3iUCCl4ZE05Chp6Z
	 +Jkl4F9bVxLAkKMD/UJgD2i+462UPSDFREfnrvX4FtqHpFwiqIW4VLqSUUIR/wQaNs
	 qzyzrhq57qZ0w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] md/raid5: protect bitmap batch counters aka
 seq_flush/seq_write consistency
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chen Cheng" <chencheng@fnnas.com>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260617142839.882378-1-chencheng@fnnas.com>
References: <20260617142839.882378-1-chencheng@fnnas.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 17 Jun 2026 14:43:51 +0000
Message-Id: <20260617144351.E54E81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Direct integer comparison of sequence numbers `bm_seq` in `str=
ipe_add_to_batch_list` fails to handle integer wrap-around.
--

commit d138461da7f53106a83faa762ae81dbb822cbfca
Author: Chen Cheng <chencheng@fnnas.com>

md/raid5: protect bitmap batch counters aka seq_flush/seq_write consistency

This patch protects seq_flush and seq_write consistency across multiple CPU=
s.
It uses READ_ONCE() and WRITE_ONCE() to prevent data races detected by KCSAN
when assigning sh->bm_seq without holding device_lock.

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index d0d7f96fd7cd9..891c2cb605d30 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3538,7 +3538,7 @@ static void __add_stripe_bio(struct stripe_head *sh=
, struct bio *bi,
>  		 sh->dev[dd_idx].sector);
> =20
>  	if (conf->mddev->bitmap && firstwrite && !sh->batch_head) {
> -		sh->bm_seq =3D conf->seq_flush+1;
> +		sh->bm_seq =3D READ_ONCE(conf->seq_flush) + 1;
>  		set_bit(STRIPE_BIT_DELAY, &sh->state);
>  	}
>  }

[Severity: Critical]
This is a pre-existing issue, but does stripe_add_to_batch_list() handle
32-bit integer wrap-around correctly when comparing sequence numbers?

Since seq_flush, seq_write, and sh->bm_seq increment for each batch, they
will eventually overflow and wrap around to negative values. In other parts
of the code, this is handled using signed subtraction (e.g.,
sh->bm_seq - conf->seq_write > 0).

However, in stripe_add_to_batch_list(), there is a direct comparison:

drivers/md/raid5.c:stripe_add_to_batch_list() {
    ...
    if (test_and_clear_bit(STRIPE_BIT_DELAY, &sh->state)) {
        int seq =3D sh->bm_seq;
        if (test_bit(STRIPE_BIT_DELAY, &sh->batch_head->state) &&
            sh->batch_head->bm_seq > seq)
            seq =3D sh->batch_head->bm_seq;
    ...
}

At the wrap-around boundary, a newer sequence number is numerically less th=
an
an older sequence number. Does this direct comparison incorrectly evaluate =
to
false, assigning the batch head an older sequence number?

Could this cause the batch to be released early when conf->seq_write catches
up, completing before its newer bitmap updates are fully flushed? Should th=
is
comparison use subtraction instead, such as sh->batch_head->bm_seq - seq > =
0?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260617142839.8823=
78-1-chencheng@fnnas.com?part=3D1
