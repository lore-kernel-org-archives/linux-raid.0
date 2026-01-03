Received: from sg-1-22.ptr.blmpb.com (sg-1-22.ptr.blmpb.com [118.26.132.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6862423BD1D
	for <linux-raid@vger.kernel.org>; Sat,  3 Jan 2026 09:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767433042; cv=none; b=mthfMYJ7769Y0JKzkCWJR6VEprCMcBd25l0L0jBiEZlGW34ISKgyv/zgQ0NRDIIyfTrw16h4CO2p/3xst+2A80sbqhmq2cVOwSAO46y6vwuHjsz7dj5SvwfKSd9TN9a9pmOLntcvfy8uJAOg13f99gn5DAWeV1DYV8PwSa8CZJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767433042; c=relaxed/simple;
	bh=n04YoXLWd8HWqVY5/NWkCdusg6ZleoQsnTL+i8AI5nY=;
	h=To:Cc:Content-Type:From:Subject:In-Reply-To:References:Date:
	 Message-Id:Mime-Version; b=GJFns50daZAo+T5meMwV1anCzK9wScKM1B36Adxfud0NYbTAudkKLkuznYVsSH/MOvQT/oGpRSQNDAACCxhMQjDRIT+v+PCwdp9X74pHJ/qPvK9nqcV2wszJF1LTarUFlGsVHEdl1scvYNyewBEt+fsPcDLib1CuTxyQkHAe8QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=LVDgELG4; arc=none smtp.client-ip=118.26.132.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="LVDgELG4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1767433026;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=p1HDDhpta+APboVeGaIYIpPgikLakeMY2oVrdKJKdZ8=;
 b=LVDgELG4f4ImgRz74zZ0E+Vy/09Idvh2nblqbQxd7F9Fqt0AKh0YOhNnVD42q23Gow8vBb
 W7PsFNv4s5hgzcNnNAvPyxqOvt3hXw4uaouvZqRBZzulAFejBkONzfTd11FAO80F3vDWjx
 wCcc5Iy5iSc/J8FHGX+i1ADklM4fBp+zS81BFEee60DP2+un+hJl+rdYUad3t5HHHTAe/W
 Whj7m1eFhaOOXpcvCE7vki74ac4DjROYFK1FJ+6fdp99Ri9QfNlyk02vveK30uT0lf0cY3
 3dMONMW/pA/2ToSC+t+iOn8Yw97TFgQj7h/cmV8tZP2JDGZO+7xcsG76tG6J4A==
To: <linan666@huaweicloud.com>, <song@kernel.org>, <neil@brown.name>, 
	<namhyung@gmail.com>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<k@mgml.me>, <yangerkun@huawei.com>, <yi.zhang@huawei.com>, 
	<yukuai@fnnas.com>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
User-Agent: Mozilla Thunderbird
From: "Yu Kuai" <yukuai@fnnas.com>
Subject: Re: [PATCH v3 03/13] md/raid1,raid10: return actual write status in narrow_write_error
X-Original-From: Yu Kuai <yukuai@fnnas.com>
In-Reply-To: <20251215030444.1318434-4-linan666@huaweicloud.com>
References: <20251215030444.1318434-1-linan666@huaweicloud.com> <20251215030444.1318434-4-linan666@huaweicloud.com>
Reply-To: yukuai@fnnas.com
Date: Sat, 3 Jan 2026 17:37:00 +0800
Message-Id: <e429dabc-8f93-44a2-9024-1d9c669ef800@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26958e340+4cd947+vger.kernel.org+yukuai@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.186]) by smtp.feishu.cn with ESMTPS; Sat, 03 Jan 2026 17:37:03 +0800

Hi,

=E5=9C=A8 2025/12/15 11:04, linan666@huaweicloud.com =E5=86=99=E9=81=93:
> From: Li Nan <linan122@huawei.com>
>
> narrow_write_error() currently returns true when setting badblocks fails.
> Instead, return actual status of all retried writes, succeeding only when
> all retried writes complete successfully. This gives upper layers accurat=
e
> information about write outcomes.
>
> When setting badblocks fails, mark the device as faulty and return at onc=
e.
> No need to continue processing remaining sections in such cases.
>
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>   drivers/md/raid1.c  | 17 +++++++++--------
>   drivers/md/raid10.c | 15 +++++++++------
>   2 files changed, 18 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 90ad9455f74a..9ffa3ab0fdcc 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2541,11 +2541,15 @@ static bool narrow_write_error(struct r1bio *r1_b=
io, int i)
>   		bio_trim(wbio, sector - r1_bio->sector, sectors);
>   		wbio->bi_iter.bi_sector +=3D rdev->data_offset;
>  =20
> -		if (submit_bio_wait(wbio) < 0)
> +		if (submit_bio_wait(wbio)) {
>   			/* failure! */
> -			ok =3D rdev_set_badblocks(rdev, sector,
> -						sectors, 0)
> -				&& ok;
> +			ok =3D false;
> +			if (!rdev_set_badblocks(rdev, sector, sectors, 0)) {
> +				md_error(mddev, rdev);
> +				bio_put(wbio);
> +				break;
> +			}
> +		}
>  =20
>   		bio_put(wbio);
>   		sect_to_write -=3D sectors;
> @@ -2596,10 +2600,7 @@ static void handle_write_finished(struct r1conf *c=
onf, struct r1bio *r1_bio)
>   			 * errors.
>   			 */
>   			fail =3D true;
> -			if (!narrow_write_error(r1_bio, m))
> -				md_error(conf->mddev,
> -					 conf->mirrors[m].rdev);
> -				/* an I/O failed, we can't clear the bitmap */
> +			narrow_write_error(r1_bio, m);

I remembered that I said please change this helper to void.

>   			rdev_dec_pending(conf->mirrors[m].rdev,
>   					 conf->mddev);
>   		}
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 40c31c00dc60..21a347c4829b 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -2820,11 +2820,15 @@ static bool narrow_write_error(struct r10bio *r10=
_bio, int i)
>   				   choose_data_offset(r10_bio, rdev);
>   		wbio->bi_opf =3D REQ_OP_WRITE;
>  =20
> -		if (submit_bio_wait(wbio) < 0)
> +		if (submit_bio_wait(wbio)) {
>   			/* Failure! */
> -			ok =3D rdev_set_badblocks(rdev, wsector,
> -						sectors, 0)
> -				&& ok;
> +			ok =3D false;
> +			if (!rdev_set_badblocks(rdev, wsector, sectors, 0)) {
> +				md_error(mddev, rdev);
> +				bio_put(wbio);
> +				break;
> +			}
> +		}
>  =20
>   		bio_put(wbio);
>   		sect_to_write -=3D sectors;
> @@ -2936,8 +2940,7 @@ static void handle_write_completed(struct r10conf *=
conf, struct r10bio *r10_bio)
>   				rdev_dec_pending(rdev, conf->mddev);
>   			} else if (bio !=3D NULL && bio->bi_status) {
>   				fail =3D true;
> -				if (!narrow_write_error(r10_bio, m))
> -					md_error(conf->mddev, rdev);
> +				narrow_write_error(r10_bio, m);
>   				rdev_dec_pending(rdev, conf->mddev);
>   			}
>   			bio =3D r10_bio->devs[m].repl_bio;

--=20
Thansk,
Kuai
