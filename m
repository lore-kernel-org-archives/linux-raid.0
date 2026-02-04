Received: from sg-1-34.ptr.blmpb.com (sg-1-34.ptr.blmpb.com [118.26.132.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F201933DEE3
	for <linux-raid@vger.kernel.org>; Wed,  4 Feb 2026 16:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770224070; cv=none; b=tHHtDEsyP5+HofeXs+teUq5LLBN6CP+AY26dpyvcMueFJhKv2Amq3IEOz4s5vmaIKcthhcVd0VFRyzs9sKR92NDTpkJr4M5xlml8ahwCncAWlN2p8lU+PStQLoSNorLJ4o3DlGJgonT7VEIgEskOVxI89dNU96wGCHshu7rUeYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770224070; c=relaxed/simple;
	bh=5qrbFmPf+eFEaLpLqjHXQjVyDMZCkGc9/780IlCRg0c=;
	h=In-Reply-To:References:Date:To:Subject:Mime-Version:Message-Id:
	 Content-Type:Cc:From; b=qzlEsbfwlfRzZbU2bNk89va8juJgSCLrzRY3cRUR0Mhm6hLVrEUX7CpKMlY/J9ZqK5FahDkiJP6LnUby5S/UpOvZtPsrsQqu3MClauLIsROE/mu+F6LQAjUqIPKEz8c9zqInFQhcjEwGmjjpiwf3tPGgWPfR8v/8PcpN5Dctgak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=qFvGElw6; arc=none smtp.client-ip=118.26.132.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="qFvGElw6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1770223949;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=xZQ5wxRX+kLBPsgwYcZR1itx2YWDDsBBJ3y/+gO/cDE=;
 b=qFvGElw6daI+nopOnLc7zeeFhFstvQ2YamSZxboNSbHClIGUFYgIjS+LS3Yfn/m9AlfMIp
 CmhFnV8Hv2Z03ntr4REp9ZUchH4C9Uc5LId4jCPdreYyJLHt4R3ADdbzDUzdLJJpFqbA3j
 n8X2QeJ0w26KQ2Y41sbMTkFiNIrceeKjQKvwD1AWr+/iTPA8ykM2fFYFkl2Iw3DZl1UmAW
 40z39LFLOUtCY6KH9qgOb+q4v/SAPcqKbRSLGhecQ5Uhroh415qJAloY+uFnMKD2Bc6k2m
 wu9mq8fmKT3sk0oBlzpZSlu4krlYRrx9xYI0J1qc0GAf2vY9EqrsT2F7Uoqm5Q==
In-Reply-To: <20260128075708.2259525-7-linan666@huaweicloud.com>
References: <20260128075708.2259525-1-linan666@huaweicloud.com> <20260128075708.2259525-7-linan666@huaweicloud.com>
User-Agent: Mozilla Thunderbird
Date: Thu, 5 Feb 2026 00:52:24 +0800
Received: from [192.168.1.104] ([39.182.0.137]) by smtp.feishu.cn with ESMTPS; Thu, 05 Feb 2026 00:52:26 +0800
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+26983794b+9c4430+vger.kernel.org+yukuai@fnnas.com>
To: <linan666@huaweicloud.com>, <song@kernel.org>
Subject: Re: [PATCH v2 06/14] md: Clean up folio sync support related code
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-Id: <0b8ba3a3-ce7e-4fd0-aacb-3ea62876acc8@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Reply-To: yukuai@fnnas.com
Cc: <xni@redhat.com>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <yangerkun@huawei.com>, 
	<yi.zhang@huawei.com>, <yukuai@fnnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>

Hi,

=E5=9C=A8 2026/1/28 15:57, linan666@huaweicloud.com =E5=86=99=E9=81=93:
> From: Li Nan <linan122@huawei.com>
>
> 1. Remove resync_get_all_folio() and invoke folio_get() directly instead.
> 2. Clean up redundant while(0) loop in md_bio_reset_resync_folio().
> 3. Clean up bio variable by directly referencing r10_bio->devs[j].bio
>     instead in r1buf_pool_alloc() and r10buf_pool_alloc().
> 4. Clean up RESYNC_PAGES.
>
> Signed-off-by: Li Nan <linan122@huawei.com>
> Reviewed-by: Xiao Ni <xni@redhat.com>
> ---
>   drivers/md/raid1-10.c | 22 ++++++----------------
>   drivers/md/raid1.c    |  6 ++----
>   drivers/md/raid10.c   |  6 ++----
>   3 files changed, 10 insertions(+), 24 deletions(-)

I think this patch can be merged into patch 5.

> diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
> index 300fbe9dc02e..568ab002691f 100644
> --- a/drivers/md/raid1-10.c
> +++ b/drivers/md/raid1-10.c
> @@ -1,7 +1,6 @@
>   // SPDX-License-Identifier: GPL-2.0
>   /* Maximum size of each resync request */
>   #define RESYNC_BLOCK_SIZE (64*1024)
> -#define RESYNC_PAGES ((RESYNC_BLOCK_SIZE + PAGE_SIZE-1) / PAGE_SIZE)
>   #define RESYNC_SECTORS (RESYNC_BLOCK_SIZE >> 9)
>  =20
>   /*
> @@ -56,11 +55,6 @@ static inline void resync_free_folio(struct resync_fol=
io *rf)
>   	folio_put(rf->folio);
>   }
>  =20
> -static inline void resync_get_folio(struct resync_folio *rf)
> -{
> -	folio_get(rf->folio);
> -}
> -
>   static inline struct folio *resync_fetch_folio(struct resync_folio *rf)
>   {
>   	return rf->folio;
> @@ -80,16 +74,12 @@ static void md_bio_reset_resync_folio(struct bio *bio=
, struct resync_folio *rf,
>   			       int size)
>   {
>   	/* initialize bvec table again */
> -	do {
> -		struct folio *folio =3D resync_fetch_folio(rf);
> -		int len =3D min_t(int, size, RESYNC_BLOCK_SIZE);
> -
> -		if (WARN_ON(!bio_add_folio(bio, folio, len, 0))) {
> -			bio->bi_status =3D BLK_STS_RESOURCE;
> -			bio_endio(bio);
> -			return;
> -		}
> -	} while (0);
> +	if (WARN_ON(!bio_add_folio(bio, resync_fetch_folio(rf),
> +				   min_t(int, size, RESYNC_BLOCK_SIZE),
> +				   0))) {
> +		bio->bi_status =3D BLK_STS_RESOURCE;
> +		bio_endio(bio);
> +	}
>   }
>  =20
>  =20
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index d9c106529289..5954ead7dfd4 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -181,18 +181,16 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, voi=
d *data)
>   	for (j =3D 0; j < conf->raid_disks * 2; j++) {
>   		struct resync_folio *rf =3D &rfs[j];
>  =20
> -		bio =3D r1_bio->bios[j];
> -
>   		if (j < need_folio) {
>   			if (resync_alloc_folio(rf, gfp_flags))
>   				goto out_free_folio;
>   		} else {
>   			memcpy(rf, &rfs[0], sizeof(*rf));
> -			resync_get_folio(rf);
> +			folio_get(rf->folio);
>   		}
>  =20
>   		rf->raid_bio =3D r1_bio;
> -		bio->bi_private =3D rf;
> +		r1_bio->bios[j]->bi_private =3D rf;
>   	}
>  =20
>   	r1_bio->master_bio =3D NULL;
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 7533aeb23819..5c0975ec8809 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -183,19 +183,17 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, vo=
id *data)
>   		if (rbio)
>   			rf_repl =3D &rfs[nalloc + j];
>  =20
> -		bio =3D r10_bio->devs[j].bio;
> -
>   		if (!j || test_bit(MD_RECOVERY_SYNC,
>   				   &conf->mddev->recovery)) {
>   			if (resync_alloc_folio(rf, gfp_flags))
>   				goto out_free_folio;
>   		} else {
>   			memcpy(rf, &rfs[0], sizeof(*rf));
> -			resync_get_folio(rf);
> +			folio_get(rf->folio);
>   		}
>  =20
>   		rf->raid_bio =3D r10_bio;
> -		bio->bi_private =3D rf;
> +		r10_bio->devs[j].bio->bi_private =3D rf;
>   		if (rbio) {
>   			memcpy(rf_repl, rf, sizeof(*rf));
>   			rbio->bi_private =3D rf_repl;

--=20
Thansk,
Kuai
