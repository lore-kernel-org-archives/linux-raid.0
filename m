Received: from va-2-40.ptr.blmpb.com (va-2-40.ptr.blmpb.com [209.127.231.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67202F5487
	for <linux-raid@vger.kernel.org>; Wed,  4 Feb 2026 16:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770223221; cv=none; b=qZ8V49ltfiqUVxg3ieXpJ0R+7i3c9Nm1oQ6Nd21/ngb3Ht29uAuh2PhwTlQfhf/eZkFDuBhEMeNsHsVldCDc/TP6nKkKsRH3XXEIizCmuFmKO1pFDdywYlCExszics9wUD425DJI+GBsT/2VKq1cy7PD+0ukbJ0FbGgX4oXiSgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770223221; c=relaxed/simple;
	bh=tvTjxpnx1kaGe0ylOjqPxWcaIVak2657qvTontSnrrQ=;
	h=Cc:Date:To:Subject:References:From:In-Reply-To:Content-Type:
	 Message-Id:Mime-Version; b=QTHESS5d4Vy6WzcTCIH53T6L/Jh0rATKDAcCS/c2PlDw51HWq4WA+HsFl1lvDNHLIMDdSecHCYfTxNGchPFX7O8DMt06DxRvh8wbmrrk/2+oCJxLBsz/heQLr3aQThkSX2BxLgyBqwG5m8zlXnBM7nQ4aot7tZZ/fVh/vJgwl04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=WEbtTuE6; arc=none smtp.client-ip=209.127.231.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="WEbtTuE6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1770223131;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=dlV8FbdDIMgWZZ0g4Vo4J3KZPwb7g+CQ8ouO0AFj/+c=;
 b=WEbtTuE6seg0wmFZiQiDuoRlPZkbyZiX0iQPS2RAtDr4LF3IytNvwCZ0O/MGygpDWK3s3T
 LDHbPKcmLf/+IPFqjsmUp515qv68Whq/aefsKZgda6Dgk0ZE2J3z5OA+ZZuUHz4gNQvS2O
 Hx8D2DLKRUVmqarlJT57JU+T8V2JD+P6oRGrZgU/2VUxZIY5u6BJ/TKpBwRUk7ptfCzhJK
 hKZPOarZfZyW2tPSir2lT47TVhhOBzgrCpoTpie5XxVmYt0Lbc85/XNHipxQjrvLsXYb7N
 JoFgD+ZJSpJGZmk8dBHWLwqTmX2WM58XobE7nReuGqqeftLdTUIjsf4I6blqkA==
Cc: <xni@redhat.com>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <yangerkun@huawei.com>, 
	<yi.zhang@huawei.com>, <yukuai@fnnas.com>
Date: Thu, 5 Feb 2026 00:38:47 +0800
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Content-Transfer-Encoding: quoted-printable
Reply-To: yukuai@fnnas.com
To: <linan666@huaweicloud.com>, <song@kernel.org>
Subject: Re: [PATCH v2 02/14] md: introduce sync_folio_io for folio support in RAID
References: <20260128075708.2259525-1-linan666@huaweicloud.com> <20260128075708.2259525-3-linan666@huaweicloud.com>
From: "Yu Kuai" <yukuai@fnnas.com>
User-Agent: Mozilla Thunderbird
X-Lms-Return-Path: <lba+269837619+ee7264+vger.kernel.org+yukuai@fnnas.com>
In-Reply-To: <20260128075708.2259525-3-linan666@huaweicloud.com>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Received: from [192.168.1.104] ([39.182.0.137]) by smtp.feishu.cn with ESMTPS; Thu, 05 Feb 2026 00:38:48 +0800
Message-Id: <3f79f293-2a77-43ad-b28d-a21ab59e112c@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0

Hi,

=E5=9C=A8 2026/1/28 15:56, linan666@huaweicloud.com =E5=86=99=E9=81=93:
> From: Li Nan <linan122@huawei.com>
>
> Prepare for folio support in RAID by introducing sync_folio_io(),
> matching sync_page_io()'s functionality. Differences are:
>
> - Replace input parameter 'page' with 'folio'
> - Replace __bio_add_page() calls with bio_add_folio_nofail()
> - Add new parameter 'off' to prepare for adding a folio to bio in segment=
s,
>    e.g. in fix_recovery_read_error()
>
> sync_page_io() will be removed once full folio support is complete.
>
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>   drivers/md/md.h |  2 ++
>   drivers/md/md.c | 27 +++++++++++++++++++++++++++
>   2 files changed, 29 insertions(+)
>
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index a083f37374d0..410f8a6b75e7 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -920,6 +920,8 @@ void md_write_metadata(struct mddev *mddev, struct md=
_rdev *rdev,
>   extern int md_super_wait(struct mddev *mddev);
>   extern int sync_page_io(struct md_rdev *rdev, sector_t sector, int size=
,
>   		struct page *page, blk_opf_t opf, bool metadata_op);
> +extern int sync_folio_io(struct md_rdev *rdev, sector_t sector, int size=
,
> +		int off, struct folio *folio, blk_opf_t opf, bool metadata_op);
>   extern void md_do_sync(struct md_thread *thread);
>   extern void md_new_event(void);
>   extern void md_allow_write(struct mddev *mddev);
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 5df2220b1bd1..b8c8a16cf037 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1192,6 +1192,33 @@ int sync_page_io(struct md_rdev *rdev, sector_t se=
ctor, int size,
>   }
>   EXPORT_SYMBOL_GPL(sync_page_io);
>  =20
> +int sync_folio_io(struct md_rdev *rdev, sector_t sector, int size, int o=
ff,
> +		  struct folio *folio, blk_opf_t opf, bool metadata_op)
> +{
> +	struct bio bio;
> +	struct bio_vec bvec;
> +
> +	if (metadata_op && rdev->meta_bdev)
> +		bio_init(&bio, rdev->meta_bdev, &bvec, 1, opf);
> +	else
> +		bio_init(&bio, rdev->bdev, &bvec, 1, opf);
> +
> +	if (metadata_op)
> +		bio.bi_iter.bi_sector =3D sector + rdev->sb_start;
> +	else if (rdev->mddev->reshape_position !=3D MaxSector &&
> +		 (rdev->mddev->reshape_backwards =3D=3D
> +		  (sector >=3D rdev->mddev->reshape_position)))
> +		bio.bi_iter.bi_sector =3D sector + rdev->new_data_offset;
> +	else
> +		bio.bi_iter.bi_sector =3D sector + rdev->data_offset;

Above code are the same as sync_page_io(), I think you can just remove sync=
_page_io()
directly in this patch, and convert to sync_folio_io() by passing in page_f=
olio(page).

> +	bio_add_folio_nofail(&bio, folio, size, off);
> +
> +	submit_bio_wait(&bio);
> +
> +	return !bio.bi_status;

Please also change return value to bool, and replace the checking to
bio.bi_status =3D=3D BLK_STS_OK.

> +}
> +EXPORT_SYMBOL_GPL(sync_folio_io);
> +
>   static int read_disk_sb(struct md_rdev *rdev, int size)
>   {
>   	if (rdev->sb_loaded)

--=20
Thansk,
Kuai
