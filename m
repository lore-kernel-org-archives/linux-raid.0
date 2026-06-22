Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772D43A759D
	for <linux-raid@vger.kernel.org>; Mon, 22 Jun 2026 12:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782131344; cv=none; b=TMp11BNz5y6XxImO+MjeHF0uciJQQ+Ezv3Sb4RkrQ5I6N2/MD97PApaeou29c5UxRQAi0WNuBwIvAPW+O621Eu3kHE+3rcmfSVsPtvD44M6tIOlr5K8atYlhNc5SVuNZ0F1y5mvSR/CJjVNpFMLqtsLfAuoXrbftdxubITUQso4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782131344; c=relaxed/simple;
	bh=i/thkgwc7DMgkgfeoXe+m8Zh9qYOXmB1jyPzqR/NmYU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=m/YvKaUg0s93ZPakN+Q8DBOyxTNP+J0c+IDXWB9TU/lm9TXdn/jdu5+SJtDGhZhUIV3JJ0LtmxIW7hFpgHgj9lX38tt6clvHyhS6mpXV4rPyJEJhzpgjUkgcr+C5VD7tyNbq+Pvcr6iRAzshYMypJ2IwTm7UlkvbBN9VHAFaymE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VsNbMz9H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VsNbMz9H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F25CD1F00A3A;
	Mon, 22 Jun 2026 12:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782131343;
	bh=sT2eAzNrexT8k1t+WaCHNe2wlSsv7l2Z+7uHTtOBClM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VsNbMz9HgG03c5C9r2fplXYk6uC5Icq84epodz6kMHmFQU3ItWVaeYD4DMRojKptT
	 nCTTHyxqqsuYlYQrgQFVDvR9cd7e0O1jj4B+HH5iH8oAk3K8zWN7yycG2fjE2M+Zeh
	 Hy6JBVmw+b79GiVJv3qdhYoURtDV+qmkWFgSbN/JtRrvJx1zzT62ygdITP3zuGOoIY
	 89aIN3+Gc8rQUshspHBDx6BTINcJcQbwTWh58duZXV7IIbvlu0RKdw2QHrpTBZYGsX
	 Ud/pd8IBNNLsMC5NhA7KEGiEu0IWEBL5H8TfOE+2x0FtElSRMxXOIwQEoFKVEk+jSd
	 u00X1GoJGcawQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 3/3] md/raid10: free r10bio before ending master_bio
 in raid_end_bio_io()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chen Cheng" <chencheng@fnnas.com>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260622121312.1775322-4-chencheng@fnnas.com>
References: <20260622121312.1775322-1-chencheng@fnnas.com>
 <20260622121312.1775322-4-chencheng@fnnas.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 22 Jun 2026 12:29:02 +0000
Message-Id: <20260622122902.F25CD1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Incomplete fix: identical Use-After-Free and mempool corruption in=
 `raid_end_discard_bio`.
- [High] Memory leak of `r10_bio` on `REQ_NOWAIT` write requests during clu=
ster resync or reshape.
--

commit 088539a2820315440079f31df4aa792c8a6bc547
Author: Chen Cheng <chencheng@fnnas.com>

md/raid10: free r10bio before ending master_bio in raid_end_bio_io()

This commit reorders the teardown sequence in raid_end_bio_io() to free
r10_bio before calling bio_endio(). This prevents a race condition where
a concurrent array reshape can alter the geometry and destroy the mempool
after the master bio completes but before the r10_bio is freed.

> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index d740744a97461..a4642c903b202 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -332,12 +332,12 @@ static void raid_end_bio_io(struct r10bio *r10_bio)
>  {
>  	struct bio *bio =3D r10_bio->master_bio;
>  	struct r10conf *conf =3D r10_bio->mddev->private;
> +	bool returned =3D test_and_set_bit(R10BIO_Returned, &r10_bio->state);
> +	blk_status_t status =3D test_bit(R10BIO_Uptodate, &r10_bio->state)
> +				? BLK_STS_OK : BLK_STS_IOERR;
> =20
> -	if (!test_and_set_bit(R10BIO_Returned, &r10_bio->state)) {
> -		if (!test_bit(R10BIO_Uptodate, &r10_bio->state))
> -			bio->bi_status =3D BLK_STS_IOERR;
> -		bio_endio(bio);
> -	}
> +	put_all_bios(conf, r10_bio);
> +	mempool_free(r10_bio, conf->r10bio_pool);
> =20
>  	/*
>  	 * Wake up any possible resync thread that waits for the device
> @@ -345,7 +345,10 @@ static void raid_end_bio_io(struct r10bio *r10_bio)
>  	 */
>  	allow_barrier(conf);
> =20
> -	free_r10bio(r10_bio);
> +	if (!returned) {
> +		bio->bi_status =3D status;
> +		bio_endio(bio);
> +	}
>  }
> =20

[Severity: High]
This is a pre-existing issue, but the exact same race condition appears to
exist in the discard completion path.

In drivers/md/raid10.c:raid_end_discard_bio():

	} else {
		md_write_end(r10bio->mddev);
		bio_endio(r10bio->master_bio);
		free_r10bio(r10bio);
		break;
	}

Since bio_endio(r10bio->master_bio) drops active_io to zero, couldn't this
also wake up mddev_suspend() and allow a concurrent reshape to modify
conf->geo and destroy conf->r10bio_pool before free_r10bio() is called?


[Severity: High]
This is a pre-existing issue, but does raid10_write_request() leak the r10_=
bio
on REQ_NOWAIT requests?

In drivers/md/raid10.c:__make_request():

	r10_bio =3D mempool_alloc(conf->r10bio_pool, GFP_NOIO);
...
	if (bio_data_dir(bio) =3D=3D READ)
		raid10_read_request(mddev, bio, r10_bio);
	else
		raid10_write_request(mddev, bio, r10_bio);

Then in raid10_write_request() during clustered resync:

	if ((mddev_is_clustered(mddev) &&
	     mddev->cluster_ops->area_resyncing(mddev, WRITE,
						bio->bi_iter.bi_sector,
						bio_end_sector(bio)))) {
		DEFINE_WAIT(w);
		/* Bail out if REQ_NOWAIT is set for the bio */
		if (bio->bi_opf & REQ_NOWAIT) {
			bio_wouldblock_error(bio);
			return;
		}

And later during reshape:

		if (bio->bi_opf & REQ_NOWAIT) {
			allow_barrier(conf);
			bio_wouldblock_error(bio);
			return;
		}

Since these paths return immediately, they leave the r10_bio allocated. Cou=
ld
repeated REQ_NOWAIT rejections eventually exhaust conf->r10bio_pool, causing
subsequent allocations in __make_request() to hang indefinitely?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260622121312.1775=
322-1-chencheng@fnnas.com?part=3D3
