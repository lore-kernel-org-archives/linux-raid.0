Received: from va-2-53.ptr.blmpb.com (va-2-53.ptr.blmpb.com [209.127.231.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9471544CF59
	for <linux-raid@vger.kernel.org>; Wed, 23 Sep 2026 11:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790162588; cv=none; b=lCjpZHk/MlNK5J6A+59wIawN9N97GCSVbP1DtJR/qMzarkd/B7QuT0/zLgU2qN3cf5NuHUuNigblu0Y64s4001VpzO9BV8W+QoXpyl/1s2qnALv+OsrSWtjpdbP60HH4zjVdeSRh1fBtnwPj9RqmvVP0+kKlGvaxAn4DOAxa9Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790162588; c=relaxed/simple;
	bh=yeTvWsNEIJPMDykQxD+0xlnCBmg8UnMA+VCs/frk33k=;
	h=From:Subject:Message-Id:Mime-Version:Content-Type:References:To:
	 Cc:Date:In-Reply-To; b=bG1+J7J0PTS+Q4fkyfX3yEop+3Ro3q9pfMDuv2fexDgK/tNM8x2nUEUCnvrsOY+bwdgUHnUq7Eyg3X0FW29v+kPP98XX9cxIJ7uF8+60TXp3mEbjG46bKpDEVOY0tu9arBn6YxZ3kNxezjlPiICqeY70AluiP9M85M0LvGvoyC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=f/WRtr7v; arc=none smtp.client-ip=209.127.231.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="f/WRtr7v"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1790162573;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=wBh0zfsJL9m1PN7Sc0m23yvDyRKsSbnbllarqg1mzbo=;
 b=f/WRtr7vav054xQTUcE3FeqVjAL9FjL/ba52t6UVHhfM/DbVTO7tkKzvKl4Kw2XCZS2+/o
 Qm+ddyaLMzdEuk1xejPucLSH0HxGLw81xQ+9Rcq6Vtnc8itvrFMtpC6uJaTcFvOImjkfXp
 NacHYG0rLLlq5qaPolVJbFyqvIHoyOKMCr8JENxYpiZKQkLqooVZmOjb7fkCvvaeSHPE9c
 Z+kmeMB+Li4jaC9dLGeZEEynO90LBOx08LaAThSVk8HOCzMt0PKgm/xfQ+/FYBhQKFI4OC
 vR30sh3ltsK8fwNd35B/rl0CQahcoMDKjtF/j/3MxacQPxuuaE0ZdLLmYoCFQw==
X-Lms-Return-Path: <lba+26ab3b68c+f91d8a+vger.kernel.org+yukuai@fygo.io>
Reply-To: yukuai@fygo.io
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH 2/2] md: add defensive bounds check for bio in md_write_metadata()
Message-Id: <763fbafc-8cf2-42dc-8a60-ab3ce2895342@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Original-From: yu kuai <yukuai@fygo.io>
References: <20260917083820.57091-1-ndaugoing@gmail.com> <20260917083820.57091-3-ndaugoing@gmail.com>
Received: from [192.168.1.104] ([39.182.0.179]) by smtp.larksuite.com with ESMTPS; Wed, 23 Sep 2026 11:22:52 +0000
To: "zjamg" <ndaugoing@gmail.com>, "Song Liu" <song@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Cc: "Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	"NeilBrown" <neil@brown.name>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>
Date: Wed, 23 Sep 2026 19:22:48 +0800
In-Reply-To: <20260917083820.57091-3-ndaugoing@gmail.com>
User-Agent: Mozilla Thunderbird

Hi,

=E5=9C=A8 2026/9/17 16:38, zjamg =E5=86=99=E9=81=93:
> md_write_metadata() allocates a single-bvec bio via bio_alloc_bioset()
> with nr_vecs =3D 1 and attaches a single page 'page' (either rdev->sb_pag=
e
> or rdev->bb_page) via __bio_add_page(bio, page, size, offset).
>
> Because the bio can only ever represent a single backing page, passing
> a non-positive size or a length where offset + size > PAGE_SIZE is invali=
d
> and can lead to out-of-bounds reads during I/O submission.
>
> Add a defensive check in md_write_metadata() so that any oversized or
> invalid request triggers WARN_ON_ONCE() and aborts before constructing
> the bio.
>
> Signed-off-by: zjamg <ndaugoing@gmail.com>
> ---
>   drivers/md/md.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d2433cf41e65..3fda2965c631 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1142,6 +1142,9 @@ void md_write_metadata(struct mddev *mddev, struct =
md_rdev *rdev,
>   	if (test_bit(Faulty, &rdev->flags))
>   		return;
>  =20
> +	if (WARN_ON_ONCE(size <=3D 0 || offset + size > PAGE_SIZE))
> +		return;

This is not a proper checking, as there is no error handler here. A better =
solution should
either make the rdev faulty or retry the metadata. But I don't think this i=
s necessary, as
there isn't any path to trigger this error other than raw disk metadata inj=
ect.

> +
>   	bio =3D bio_alloc_bioset(rdev->meta_bdev ? rdev->meta_bdev : rdev->bde=
v,
>   			      1,
>   			      REQ_OP_WRITE | REQ_SYNC | REQ_IDLE | REQ_META

--=20
Thanks,
Kuai
