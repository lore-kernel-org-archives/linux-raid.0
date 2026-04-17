Received: from ext7.scm.com (ext7.scm.com [49.12.148.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29BAB38552F
	for <linux-raid@vger.kernel.org>; Fri, 17 Apr 2026 08:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.12.148.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776412895; cv=none; b=P7BUs+HWjgSoGsBh9NF/N5PzPyo+D65CGFVuiHQRB9VGTsZfZPJIo+siDzoY3YrxMDLBKj20lgEOqjRLVj4pWZVODQRe7bTxoza9dx4Cm0Ozq00hR/65l+BI9eqgq8rdMHsahe7iYIdRuL6hBfJIEGDitUN4/TZzWJzXY1vkIuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776412895; c=relaxed/simple;
	bh=oPjOv4RQlZZye75EZYoiDimZbkc8gdp9fHXmDa0AQD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DTiLZx/bh0QTP+W/yNfdSFknYkFWsyIx90v1oKO8bBbtgvZnZcm3tJdC1POhe1xpMUHXd4U0S2IJVwXpsWZGNvN07S8qhVevub/6jssKKwQHztvQHWt7scDTg7sFrDwlKMiLD004lygqWa5uEmYmXRuns6Y/LYnwCfbZJL/oQSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=scm.com; spf=pass smtp.mailfrom=scm.com; dkim=pass (4096-bit key) header.d=scm.com header.i=@scm.com header.b=VN10czGf; arc=none smtp.client-ip=49.12.148.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=scm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=scm.com header.i=@scm.com header.b="VN10czGf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=scm.com;
	s=ext7dkim24; t=1776412882;
	bh=IhITPrMMoC6IOss8tgkSEXPWGVd9zJ/7/bYUYeXF7sY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VN10czGfdeK/34JZJxG8g9exlZIioC/JgcQXQ+gng67a8MNbx7HeLAWfautkw2/pk
	 upzIp6eVTR94+cXdguFEYvE3Y/QUKkqFxjcxINWx4qtOKbRDuH4ynVjZ+ZpRpozjnN
	 zzKsIGa7j/M8LtQw1rNpqGfsS6CB0l7KH25unqN5Fvffv36TN/hx/a676iAMgsVTZn
	 GmV4FaTS5oQ05xPzXiW/A97658B7EYXAUhLkZxAk3QqGxuQpRf1w76u77j4GfXyh0W
	 1wy4ZssyNgRshlug1m/GP5+5tx7GDMqVZDi6MoLeFimVW9BpO9AccixgcEEsvs7bz5
	 ovrR2Oc9bSWg2g+qlRw/548dmXx0FpJ97yOtRLve7LStrhYfdxraCc17tAZq5aZGWD
	 3xy2nzMyzmAY4DrH6zqKNuVv/BVUu1kqe9qLL1hG2TvKKhfFWZpfXB6VbEeZ9X4Szs
	 WAydSYCJwJBJpj+9jsqycmf/be+MyoLCNHFPCTuZwajE+j2Cco1MNlkdHjoXpb0Jed
	 EXjWrgCzCws4md9l6O+0uZu4hVsPKIrNFXtXB6H11BqNc4WwZ9+xFaylDYhpWvYO2t
	 ScGvQV9ahvlZqHteVAuxUlIk5lM2lt3nGaE/epkJ2rCb0whUU3mkYSesho59wsCGpf
	 pSZLgS+nViTyK+aHXfILlUm0=
X-Virus-Scanned: Debian amavisd-new at ext7.scm.com
From: =?UTF-8?B?VG9tw6HFoQ==?= Trnka <trnka@scm.com>
To: linux-raid@vger.kernel.org, song@kernel.org, yukuai@fnnas.com,
 Keith Busch <kbusch@meta.com>
Cc: linan122@huawei.com, axboe@kernel.dk, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH] md/raid1,raid10: don't fail devices for invalid IO errors
Date: Fri, 17 Apr 2026 10:01:19 +0200
Message-ID: <2528293.RxA6XjA2Nv@electra>
In-Reply-To: <20260416140345.3872265-1-kbusch@meta.com>
References: <20260416140345.3872265-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Thursday, 16 April 2026 16:03:45, CEST Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
>=20
> BLK_STS_INVAL indicates the IO request itself was invalid, not that the
> device has failed. When raid1 treats this as a device error, it retries
> on alternate mirrors which fail the same way, eventually exceeding the
> read error threshold and removing the device from the array.
>=20
> This happens when stacking configurations bypass bio_split_to_limits()
> in the IO path: dm-raid calls md_handle_request() directly without going
> through md_submit_bio(), skipping the alignment validation that would
> otherwise reject invalid bios early. The invalid bio reaches the
> lower block layers, which fail the bio with  BLK_STS_INVAL, and raid1
> wrongly interprets this as a device failure.
>=20
> Add BLK_STS_INVAL to raid1_should_handle_error() so that invalid IO
> errors are propagated back to the caller rather than triggering device
> removal. This is consistent with the previous kernel behavior when
> alignment checks were done earlier in the direct-io path.
>=20
> Fixes: 5ff3f74e145adc7 ("block: simplify direct io validity check")
> Link: https://lore.kernel.org/linux-block/2982107.4sosBPzcNG@electra/
> Reported-by: Tom=C3=A1=C5=A1 Trnka <trnka@scm.com>
> Signed-off-by: Keith Busch <kbusch@kernel.org>

Tested-by: Tom=C3=A1=C5=A1 Trnka <trnka@scm.com>

> ---
>  drivers/md/raid1-10.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
> index c33099925f230..56a56a4da4f83 100644
> --- a/drivers/md/raid1-10.c
> +++ b/drivers/md/raid1-10.c
> @@ -293,8 +293,13 @@ static inline bool raid1_should_read_first(struct md=
dev
> *mddev, * bio with REQ_RAHEAD or REQ_NOWAIT can fail at anytime, before
> such IO is * submitted to the underlying disks, hence don't record
> badblocks or retry * in this case.
> + *
> + * BLK_STS_INVAL means the bio was not valid for the underlying device.
> This + * is a user error, not a device failure, so retrying or recording
> bad blocks + * would be wrong.
>   */
>  static inline bool raid1_should_handle_error(struct bio *bio)
>  {
> -	return !(bio->bi_opf & (REQ_RAHEAD | REQ_NOWAIT));
> +	return !(bio->bi_opf & (REQ_RAHEAD | REQ_NOWAIT)) &&
> +		bio->bi_status !=3D BLK_STS_INVAL;
>  }




