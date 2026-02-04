Received: from sg-1-36.ptr.blmpb.com (sg-1-36.ptr.blmpb.com [118.26.132.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9C133F8B9
	for <linux-raid@vger.kernel.org>; Wed,  4 Feb 2026 16:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770224369; cv=none; b=g0D7wIs4QFlTC2q1rlW3mfIfIeLAxLAQjACHdrXueYzkfrV2KwLzzf7rlMILFNLUy4UDz8YIulCwCKEHOPzq/6VQO7h/9ZxZIbegVt6t8VWJgokT/yJbOYojH8HE74dvCsRUMkhy9ywdmgsCsUwdQG/pIiSH7S+9xthErcybPxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770224369; c=relaxed/simple;
	bh=3+GCQnrFHVZelfTaUJqorBog579HbM4OjAweGsKLszs=;
	h=To:In-Reply-To:Date:Message-Id:Content-Type:References:Cc:From:
	 Subject:Mime-Version; b=D3QB+p15y8JsEaIxFAcrIswYwCKj39Z+sm288o6PLE5h/h66Ws+KQ9uE1vNxZE4g7CzMwigKyGYyrto725Q9sLafSsuuPWu5n1Cwnzr4BDfs3FvOM/PDRZRoRDh/7LKamhsI+iwgh3LLcwbjQdrQfpDGhUoA+HHQK0M2o/PLXSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=urg0+6IM; arc=none smtp.client-ip=118.26.132.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="urg0+6IM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1770224356;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=qsp7fEpjovnSx6YtAldf0Kcookea2yZCczF19D2tMGc=;
 b=urg0+6IMyCzQNyTKb6glV9JNDpckRtJ/zH8EMPbzJEtAJAaTU3x+nf5Adx4Z0HKa6E8pub
 fUwIJyRhj5WSbFtuLC5236r6Dyfg5129OlhvvxuXI/a7yhR9BBHj8m1XTTR/1WiayTW+dT
 rdVGSMIAoVaHnhgCdb05BqLkn2Bc6UyRO7dRcg8lAOOvhy/Kg9WRAh78LoW3AKMq2Vx6hX
 qf5nCrvOkuiRtdoUyUGefVeVX5KeyPV7VaaZQznRnBZI3edLEGsAAzFjsBpIuEcBoqNeHy
 7P/tFLR1wuFDPOIzN5e8nNeMg9Z9eT6STgFTFlQr0aElGCnDdsC81HrXicGSag==
To: <linan666@huaweicloud.com>, <song@kernel.org>
X-Lms-Return-Path: <lba+269837ae3+790cbf+vger.kernel.org+yukuai@fnnas.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260128075708.2259525-12-linan666@huaweicloud.com>
Received: from [192.168.1.104] ([39.182.0.137]) by smtp.feishu.cn with ESMTPS; Thu, 05 Feb 2026 00:59:14 +0800
Date: Thu, 5 Feb 2026 00:59:12 +0800
Message-Id: <1ae55b7f-fd28-4994-8fa5-956864c40139@fnnas.com>
Content-Type: text/plain; charset=UTF-8
References: <20260128075708.2259525-1-linan666@huaweicloud.com> <20260128075708.2259525-12-linan666@huaweicloud.com>
Reply-To: yukuai@fnnas.com
Cc: <xni@redhat.com>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <yangerkun@huawei.com>, 
	<yi.zhang@huawei.com>, <yukuai@fnnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Subject: Re: [PATCH v2 11/14] md: clean up resync_free_folio
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird

Hi,

=E5=9C=A8 2026/1/28 15:57, linan666@huaweicloud.com =E5=86=99=E9=81=93:
> From: Li Nan <linan122@huawei.com>
>
> The resync_free_folio() helper only wraps a single folio_put() call,
> so remove it and call folio_put() directly.
>
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>   drivers/md/raid1-10.c | 5 -----
>   drivers/md/raid1.c    | 4 ++--
>   drivers/md/raid10.c   | 4 ++--
>   3 files changed, 4 insertions(+), 9 deletions(-)

Same as patch 10, I think this patch should be merged into patch 5.

>
> diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
> index 2ff1f8855900..ffbd7bd0f6e8 100644
> --- a/drivers/md/raid1-10.c
> +++ b/drivers/md/raid1-10.c
> @@ -50,11 +50,6 @@ static inline int resync_alloc_folio(struct resync_fol=
io *rf,
>   	return 0;
>   }
>  =20
> -static inline void resync_free_folio(struct resync_folio *rf)
> -{
> -	folio_put(rf->folio);
> -}
> -
>   /*
>    * 'strct resync_folio' stores actual pages used for doing the resync
>    *  IO, and it is per-bio, so make .bi_private points to it.
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index a303349eeff4..b5239b5cb4e9 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -199,7 +199,7 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void =
*data)
>  =20
>   out_free_folio:
>   	while (--j >=3D 0)
> -		resync_free_folio(&rfs[j]);
> +		folio_put(rfs[j].folio);
>  =20
>   out_free_bio:
>   	while (++j < conf->raid_disks * 2) {
> @@ -222,7 +222,7 @@ static void r1buf_pool_free(void *__r1_bio, void *dat=
a)
>  =20
>   	for (i =3D conf->raid_disks * 2; i--; ) {
>   		rf =3D get_resync_folio(r1bio->bios[i]);
> -		resync_free_folio(rf);
> +		folio_put(rf->folio);
>   		bio_uninit(r1bio->bios[i]);
>   		kfree(r1bio->bios[i]);
>   	}
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index d8a5fadfc933..b728131bdad4 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -204,7 +204,7 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, void=
 *data)
>  =20
>   out_free_folio:
>   	while (--j >=3D 0)
> -		resync_free_folio(&rfs[j]);
> +		folio_put(rfs[j].folio);
>  =20
>   	j =3D 0;
>   out_free_bio:
> @@ -234,7 +234,7 @@ static void r10buf_pool_free(void *__r10_bio, void *d=
ata)
>  =20
>   		if (bio) {
>   			rf =3D get_resync_folio(bio);
> -			resync_free_folio(rf);
> +			folio_put(rf->folio);
>   			bio_uninit(bio);
>   			kfree(bio);
>   		}

--=20
Thansk,
Kuai
