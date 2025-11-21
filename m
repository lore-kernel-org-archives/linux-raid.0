Received: from sg-1-21.ptr.blmpb.com (sg-1-21.ptr.blmpb.com [118.26.132.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5B1239567
	for <linux-raid@vger.kernel.org>; Fri, 21 Nov 2025 05:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763702514; cv=none; b=BBCPWLz8ut/5a7qPwnVwE1IYAa9JDW/dRq3GPuBl6DmKflxiZXmMbUT2uy/gSyjgHrMx3XYuzVXrFnIisWFzNHgwURxXkXiRK++iyxNeirNLr8njlIny93VYpQtdD56vl143tvodNMxJlLyN7rUZUM8cB4wNRYpPLji3i6xi1ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763702514; c=relaxed/simple;
	bh=duPM58gvu+k8vpGalUepQkolUMVOZs96h1JcgHNrV4g=;
	h=Message-Id:Date:Mime-Version:In-Reply-To:References:Cc:From:To:
	 Content-Type:Subject; b=PjGxkfVYJ9iYTLoyHoRDr5eCkVqThQ4HMVkyhX/SyOq0crKymZvVDIFm6W+Tj5tpA8UigcwZ0mJKAFiGFCrsBE/k4JUbKHYz5kv414q7zq6iJFuvfpM2/fvQiZ/RzOijE6RK+yDU339La+TDdbztCT1WBI1KKG+OtgBamtY/Ijw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=Dr66vqji; arc=none smtp.client-ip=118.26.132.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="Dr66vqji"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1763702385;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=hRxPIGF/+qH0QPMwEHrwxCmmg+Jh42xRq734BBJITXw=;
 b=Dr66vqjiJhNiRz0ssAIAdMdKPAUMurv+DB8UGLGo4P1C4vE70/HTDgoZZ34oiUdtELyp84
 1talCSU2s15FlgdigxEhD/7z6ZcnAbWVaVJ/yyNS/IAS5+qDL034kwAyLcNnwyDuERCT6H
 46QliXteqUtaolI0KKl47KhPikq5i1kE0hqLEHk6JUArRo2+fwYhHPknwaTEI5B64BgZl2
 p0mYZ2KZshhW3EwuBzffpZ+UtVUK0VlM8ovZ0Y4Y3qJpIWWhApzji9qpu6/wTNAPdTjDgY
 4wzlAu5TtCjhFDRATAPPnmhvcIObtUJy2PMZhYgGKXhgR2O4xQyTIXbgNWC0pQ==
Message-Id: <8140d7a2-e152-4f6b-a16d-5fd1dcc2fe20@fnnas.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Organization: fnnas
Date: Fri, 21 Nov 2025 13:19:40 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <20251121051406.1316884-3-yukuai@fnnas.com>
Content-Transfer-Encoding: quoted-printable
References: <20251121051406.1316884-1-yukuai@fnnas.com> <20251121051406.1316884-3-yukuai@fnnas.com>
Reply-To: yukuai@fnnas.com
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linan122@huawei.com>, <xni@redhat.com>, "Yu Kuai" <yukuai@fnnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>
To: <song@kernel.org>
Received: from [192.168.1.104] ([39.182.0.153]) by smtp.feishu.cn with ESMTPS; Fri, 21 Nov 2025 13:19:42 +0800
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+2691ff66f+8857e9+vger.kernel.org+yukuai@fnnas.com>
Subject: Re: [PATCH] md: support to align bio to limits
Content-Language: en-US
User-Agent: Mozilla Thunderbird

Hi,

I forgot to remove this patch, that is patch 3 in this set, before sending
to mail list, please ignore this one.

=E5=9C=A8 2025/11/21 13:14, Yu Kuai =E5=86=99=E9=81=93:
> For personalities that report optimal IO size, it's indicate that users
> can get the best IO bandwidth if they issue IO with this size. However
> there is also an implicit condition that IO should also be aligned to the
> optimal IO size.
>
> Currently, bio will only be split by limits, if bio offset is not aligned
> to limits, then all split bio will not be aligned. This patch add a new
> feature to align bio to limits first, and following patches will support
> this for each personality if necessary.
>
> Signed-off-by: Yu Kuai <yukuai@fnnas.com>
> ---
>   drivers/md/md.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
>   drivers/md/md.h |  1 +
>   2 files changed, 47 insertions(+)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 7b5c5967568f..b09f87b27807 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -427,6 +427,48 @@ bool md_handle_request(struct mddev *mddev, struct b=
io *bio)
>   }
>   EXPORT_SYMBOL(md_handle_request);
>  =20
> +static struct bio *__md_bio_align_to_limits(struct mddev *mddev,
> +					    struct bio *bio)
> +{
> +	unsigned int max_sectors =3D mddev->gendisk->queue->limits.max_sectors;
> +	sector_t start =3D bio->bi_iter.bi_sector;
> +	sector_t align_start =3D roundup(start, max_sectors);
> +	sector_t end;
> +	sector_t align_end;
> +
> +	/* already aligned */
> +	if (align_start =3D=3D start)
> +		return bio;
> +
> +	end =3D start + bio_sectors(bio);
> +	align_end =3D rounddown(end, max_sectors);
> +
> +	/* bio is too small to split */
> +	if (align_end <=3D align_start)
> +		return bio;
> +
> +	return bio_submit_split_bioset(bio, align_start - start,
> +				       &mddev->gendisk->bio_split);
> +}
> +
> +static struct bio *md_bio_align_to_limits(struct mddev *mddev, struct bi=
o *bio)
> +{
> +	if (!mddev->bio_align_to_limits)
> +		return bio;
> +
> +	/* atomic write can't split */
> +	if (bio->bi_opf & REQ_ATOMIC)
> +		return bio;
> +
> +	switch (bio_op(bio)) {
> +	case REQ_OP_READ:
> +	case REQ_OP_WRITE:
> +		return __md_bio_align_to_limits(mddev, bio);
> +	default:
> +		return bio;
> +	}
> +}
> +
>   static void md_submit_bio(struct bio *bio)
>   {
>   	const int rw =3D bio_data_dir(bio);
> @@ -442,6 +484,10 @@ static void md_submit_bio(struct bio *bio)
>   		return;
>   	}
>  =20
> +	bio =3D md_bio_align_to_limits(mddev, bio);
> +	if (!bio)
> +		return;
> +
>   	bio =3D bio_split_to_limits(bio);
>   	if (!bio)
>   		return;
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 75fd8c873b6f..1ed90fd85ac4 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -630,6 +630,7 @@ struct mddev {
>   	bool	has_superblocks:1;
>   	bool	fail_last_dev:1;
>   	bool	serialize_policy:1;
> +	bool	bio_align_to_limits:1;
>   };
>  =20
>   enum recovery_flags {

--=20
Thanks,
Kuai
