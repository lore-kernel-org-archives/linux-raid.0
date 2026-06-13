Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFBF21257F
	for <linux-raid@vger.kernel.org>; Sat, 13 Jun 2026 18:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781376478; cv=none; b=OA/Jr/5q0m/KdiRzZZyXghKb3lg9l7lfROMTrBONz+dBk28uyP+kHTf1IPKCSipW/0BPjlU2mFlRzEw5+zJHFLqUm5zj52FOZ5vuyYrthFYR6TyVKIL6T0WvEMMNqJWDHqTdkAJAI9krJMLMKTrc0yPf8vq5V31FiGAnePHYBMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781376478; c=relaxed/simple;
	bh=ytRjA7ljM4GMqKH9JNX0EBQRfG3hy9/NAcrYLMXXaWQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Yk90IC9SwfAM1sBojn8FA04id+gRH9ZYrEjRLYJOxAqqVesOTvgSeqk3g+PfGRyOpCrMPI6VVCLvqA/MWXgmEUz75yAHT68xrcBb221deZujC5MevzTLGesFa3rR72ijGtjFPcXYdFtBHSwjB9hDk0z29bT78gzQFe3OqiYQBM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZcnFOJUn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZcnFOJUn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57BC51F000E9;
	Sat, 13 Jun 2026 18:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781376477;
	bh=3JIjanCdF89gfQdEYMz9LqKlRnoQ1GJuVt2+Fr6hbTU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZcnFOJUnc7xpEH/b5o8yn2X+xzgxF4OaEI5o+p/Cgv1ebByO07cPKrENyjHZLqzOv
	 FxuOHvYc5uwlIwmhjbie1sI93lXmGosV3a90eXclvG03dV7Km/O4Ua70eN8SQoWDqt
	 TYR9kqS8bMp1iuJb4gcVPa0wz7RUXylM0VdOyVGWHT4PUTdR2QL6Bx4N8p+tjbwsNW
	 8dJ15T4vtADJH5+lh0TU9xQB3wEnW0xqg/KhCHu1VNXzjtzXv7IhHRwNrxV78bkpLW
	 kY7ebmW1zHiuVYMMHVbQxzCJmhOf8t3zgK2dvzgTKe4uh3XP+zwfmS/saTBKxg8ioO
	 bU4kJIhhLoXLA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 4/4] md/raid1: simplify raid1_write_request() error
 handling
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260613182810.1317258-5-abd.masalkhi@gmail.com>
References: <20260613182810.1317258-5-abd.masalkhi@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 13 Jun 2026 18:47:56 +0000
Message-Id: <20260613184757.57BC51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Critical] Moving `atomic_inc(&rdev->nr_pending)` down opens a race windo=
w with `hot_remove_disk`, leading to a NULL pointer dereference during erro=
r handling or a Use-After-Free in clustered configurations.

Pre-existing issues:
- [High] A `REQ_ATOMIC` write can be silently split if a bad block overlaps=
 the start of the write, violating atomicity guarantees.
--

commit c334f57d91677f32131f21e50bb32b83136e5a60
Author: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>

md/raid1: simplify raid1_write_request() error handling

This commit delays the rdev->nr_pending increment until after badblocks
are checked to avoid incrementing and immediately decrementing on skipped
devices. It also consolidates error handling paths and modifies REQ_ATOMIC
failures to complete with BLK_STS_NOTSUPP instead of I/O errors.

> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 632d72607e11e..86d4f224ffb11 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
[ ... ]
> @@ -1576,23 +1573,21 @@ static bool raid1_write_request(struct mddev *mdd=
ev, struct bio *bio,
>  		if (!rdev || test_bit(Faulty, &rdev->flags))
>  			continue;
> =20
> -		atomic_inc(&rdev->nr_pending);
>  		if (test_bit(WriteErrorSeen, &rdev->flags)) {
>  			sector_t first_bad;
>  			sector_t bad_sectors;
>  			int is_bad;
> =20
> -			is_bad =3D is_badblock(rdev, r1_bio->sector, max_sectors,
> +			is_bad =3D is_badblock(rdev, sector, max_sectors,
>  					     &first_bad, &bad_sectors);
> -			if (is_bad && first_bad <=3D r1_bio->sector) {
> +			if (is_bad && first_bad <=3D sector) {
>  				/* Cannot write here at all */
> -				bad_sectors -=3D (r1_bio->sector - first_bad);
> +				bad_sectors -=3D (sector - first_bad);
>  				if (bad_sectors < max_sectors)
>  					/* mustn't write more than bad_sectors
>  					 * to other devices yet
>  					 */
>  					max_sectors =3D bad_sectors;
> -				rdev_dec_pending(rdev, mddev);
>  				continue;

[Severity: High]
This is a pre-existing issue, but does this logic skip the rejection of
REQ_ATOMIC bios if a bad block overlaps the start of the write?

When is_badblock() finds a bad block at or before the write sector, the
code shrinks max_sectors to force a split at the boundary and then calls
continue. Because of the continue, the REQ_ATOMIC bio skips the rejection
logic below.

Could this silently split an atomic write into smaller pieces and submit
them to the healthy mirrors via bio_submit_split_bioset(), violating
block-level atomicity guarantees?

>  			}
>  			if (is_bad) {
[ ... ]
>  				if (bio->bi_opf & REQ_ATOMIC) {
> -					rdev_dec_pending(rdev, mddev);
> -					goto err_handle;
> +					bio->bi_status =3D BLK_STS_NOTSUPP;
> +					bio_endio(bio);
> +					goto err_dec_pending;
>  				}
> =20
> -				good_sectors =3D first_bad - r1_bio->sector;
> +				good_sectors =3D first_bad - sector;
>  				if (good_sectors < max_sectors)
>  					max_sectors =3D good_sectors;
>  			}
>  		}
> +
> +		atomic_inc(&rdev->nr_pending);

[Severity: Critical]
Does moving atomic_inc(&rdev->nr_pending) down open a race window with
hot_remove_disk()?

Because nr_pending acts as an existence lock that prevents the device from
being removed from the array configuration by raid1_remove_conf(),
incrementing it after the is_badblock() and test_bit(WriteErrorSeen, ...)
checks means md_check_recovery() could evaluate rdev_removeable() while
nr_pending is 0 and call hot_remove_disk().

If raid1_remove_conf() unlinks the device by setting
conf->mirrors[i].rdev =3D NULL, when this thread resumes and the I/O
eventually fails, would the error handling path (handle_write_finished()
calling narrow_write_error()) read conf->mirrors[i].rdev and dereference a
NULL pointer?

Additionally, in clustered configurations, if the unlinked rdev is
immediately freed by md_kick_rdev_from_array(), could this lead to a
use-after-free directly in raid1_write_request() when evaluating
test_bit(WriteErrorSeen, &rdev->flags) or is_badblock()?

>  		r1_bio->bios[i] =3D bio;
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260613182810.1317=
258-1-abd.masalkhi@gmail.com?part=3D4
