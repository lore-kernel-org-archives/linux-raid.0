Received: from va-2-54.ptr.blmpb.com (va-2-54.ptr.blmpb.com [209.127.231.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EED941A506
	for <linux-raid@vger.kernel.org>; Sun, 20 Sep 2026 11:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789905078; cv=none; b=C6MnGR3j0pNyKSw8MHHaLYwgF3b+Gjcm2gQU2iZvFWEHV7qREuyDBqNp4H/S+lnc1+Q+tILhKFp4xZxssSegwktjy1riI1CtoDvu89u5xfe/6Ek4EnP98W3u11ocQdFVNStuvlnzdGcnpSSGOY7itePmv/dM/pi3zcuShiw5I2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789905078; c=relaxed/simple;
	bh=Bw39X9AkTUoh/aHMDqTy8Y4i1sHlfc+cuooNbm5nWgs=;
	h=Message-Id:Content-Type:Cc:Subject:Date:References:To:From:
	 Mime-Version:In-Reply-To; b=EZDHWPUE/ET996eO4/z97wpGqyIibkhH+43im5d5lDM/TmRxcyesOlTvZoxMPV+AYlM784Xqb006bvNipjAJ16MPza9xKysq+eEvWnG6TmeG6jbrVYjA5Wzck5GqUxt0L8sMsNgNB5aFXB3AgYSPO5lpi+sKCxTPcmqzFamZzVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=Ihr0q8Kc; arc=none smtp.client-ip=209.127.231.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="Ihr0q8Kc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1789905061;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=4ohIn79VTQwaPZDLQ4bf9CpjIqYPmTtX+vxVGjEsJ6w=;
 b=Ihr0q8KcvGDAweIWla7IkixnooUdKnVDP3ZIa7WUvcOa0B62NCyYzNo53EqFUvMk3AAXL/
 dHZaokNaLclQPKf8uxg+AUrIkGY5oG5YEiQj3yTbcxNKwC7CEtDy5/HJ7ujTDPjsiv+Csm
 KTy1D98wi1tpMuzZYjBlYj4oHQS/n9pYtyqI7NF39h+6QvEI2TwfTG7ITktFcvONOKshAJ
 dBEfBrurg3Myv/rd7wMJn1JWv+x7VLhjsbnBD+pJtn4CPx8QThbwBWap9Xsh49xte+HaBx
 WXsGEgrXWnn3um9vNlnnKnBYQOo2w7DUVjKCMWZXmIAZSlO3fbHB07RJCMyQNw==
Message-Id: <fad92649-e362-443a-93ea-205b11247e6d@fygo.io>
Content-Type: text/plain; charset=UTF-8
X-Original-From: yu kuai <yukuai@fygo.io>
Cc: "Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	"NeilBrown" <neil@brown.name>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] md: fix bblog_size-driven OOB read in super_1_load() and super_1_sync()
Date: Sun, 20 Sep 2026 19:50:56 +0800
Content-Transfer-Encoding: quoted-printable
References: <20260917083820.57091-1-ndaugoing@gmail.com> <20260917083820.57091-2-ndaugoing@gmail.com>
Received: from [192.168.1.104] ([39.182.0.142]) by smtp.larksuite.com with ESMTPS; Sun, 20 Sep 2026 11:50:59 +0000
To: "zjamg" <ndaugoing@gmail.com>, "Song Liu" <song@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26aafc8a4+ef42b0+vger.kernel.org+yukuai@fygo.io>
Reply-To: yukuai@fygo.io
In-Reply-To: <20260917083820.57091-2-ndaugoing@gmail.com>
User-Agent: Mozilla Thunderbird

Hi,

=E5=9C=A8 2026/9/17 16:38, zjamg =E5=86=99=E9=81=93:
> In super_1_load(), when the on-disk feature_map does not have the
> MD_FEATURE_BAD_BLOCKS flag set, but sb->bblog_offset is non-zero,
> rdev->badblocks.shift is initialized to 0 while completely bypassing
> the sectors > (PAGE_SIZE / 512) validation check on sb->bblog_size.

How can this happen? If this is just raw disk metadata inject failure,
just add a checking in super_1_load() is enough.

>
> Subsequently, when badblocks are updated, super_1_sync() enables the
> MD_FEATURE_BAD_BLOCKS feature flag and assigns bb->size directly from
> sb->bblog_size without validating that bb->size fits within the single
> allocated rdev->bb_page (which is PAGE_SIZE, or PAGE_SIZE / 512 sectors).
>
> When md_update_sb() later writes metadata via md_write_metadata(), an
> unvalidated bb->size (e.g. 0xFFFF) results in a bio whose length exceeds
> the backing page, causing out-of-bounds reads into kernel memory during
> block I/O and leaking kernel slab/page contents to disk.
>
> Fix this by:
> 1. Validating sb->bblog_size in the 'else if (sb->bblog_offset !=3D 0)'
>     branch of super_1_load(), returning -EINVAL on oversized values.
> 2. Clamping bb->size in super_1_sync() to PAGE_SIZE / 512 to ensure it
>     never exceeds the backing rdev->bb_page capacity.
>
> Fixes: 2699b67223ac ("md: load/store badblock list from v1.x metadata")
> Cc: stable@vger.kernel.org
> Signed-off-by: zjamg <ndaugoing@gmail.com>
> ---
>   drivers/md/md.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 680b34a63cb3..d2433cf41e65 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1934,8 +1934,11 @@ static int super_1_load(struct md_rdev *rdev, stru=
ct md_rdev *refdev, int minor_
>   			if (!badblocks_set(&rdev->badblocks, sector, count, 1))
>   				return -EINVAL;
>   		}
> -	} else if (sb->bblog_offset !=3D 0)
> +	} else if (sb->bblog_offset !=3D 0) {
> +		if (le16_to_cpu(sb->bblog_size) > (PAGE_SIZE / 512))
> +			return -EINVAL;
>   		rdev->badblocks.shift =3D 0;
> +	}
>  =20
>   	if ((le32_to_cpu(sb->feature_map) &
>   	    (MD_FEATURE_PPL | MD_FEATURE_MULTIPLE_PPLS))) {
> @@ -2313,7 +2316,8 @@ static void super_1_sync(struct mddev *mddev, struc=
t md_rdev *rdev)
>  =20
>   			bb->sector =3D (rdev->sb_start +
>   				      (int)le32_to_cpu(sb->bblog_offset));
> -			bb->size =3D le16_to_cpu(sb->bblog_size);
> +			bb->size =3D min_t(sector_t, le16_to_cpu(sb->bblog_size),
> +					 PAGE_SIZE / 512);
>   		}
>   	}
>  =20

--=20
Thanks,
Kuai
