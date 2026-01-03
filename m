Received: from sg-1-11.ptr.blmpb.com (sg-1-11.ptr.blmpb.com [118.26.132.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA17194AD7
	for <linux-raid@vger.kernel.org>; Sat,  3 Jan 2026 10:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767435387; cv=none; b=JZAY3maeXvuqv1ftZ0dXg7Zff/kiKfVmvxODqCt2NNvd4e7AlhbBsGES703iNmqAtooPX8Zbx/HHTs+ht98aWAwKBIz7VSt0UOJnfC0qqbah0wsG9Gsp1Bcrsmip/5drpt6VLJXSZxqNaAjWVzY/iqn7P+Rm6jgmMDxKV8VAocE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767435387; c=relaxed/simple;
	bh=Iu0ECBlyGoCcddvPOgEmPSVpCs73VWM3erCyj2tBvao=;
	h=Message-Id:In-Reply-To:Content-Type:Mime-Version:From:Cc:Subject:
	 References:To:Date; b=O7XAMOKhCLZVgKpn6l/AOgfsrMwn05xy+PoCUgKFPKyHac4U2WR/5KH0JOUgzXApBsFC/Mgf9ZPGz1JCGaQwo+bSVy9Xy1QTiSHTWsjJvx/Ds3GEvoLkHAX8mXqs3fOLmQqQ4iEJlXxgepdK9RcYHuni99cUVVNSsGy7RhVVjT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=A2iKFxV1; arc=none smtp.client-ip=118.26.132.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="A2iKFxV1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1767435371;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=xGykaKJg0CgfE40ZkCH44SrQjudL52WI8jtKIsf2CXY=;
 b=A2iKFxV1qXVczvNAw1ILo05V88cJYn8d1qQmz7Ip/BZYZROgRxYq9D0c6l9TDHHjVIliDz
 10IeteiGGUV65AylCxO4ZRMDRUKiYHecVR/tvanMQbxgpD5cmQjSFsni98rB0QoKPb77kK
 WEKNbZ36+4KYwa/ouYdnPC24XCovrnCiQPUgmYgh801Vf51MR1DkZY3hTjhmFSI7xqxme5
 j/CShwrtqGTtFNpQkh+ZZnXR05tOn4JSBecxNqgv4NRvZYUUfTaAqwwGFDoyvKflt9pW4R
 NZaypQtGB4Uhx9c/5PVQhKjWevWNaZy5KNgnSF82+B9KBP/5G3gEV98qX2Qrgw==
Message-Id: <989e77fa-43ec-4a44-b762-72073593ed77@fnnas.com>
In-Reply-To: <20251215030444.1318434-5-linan666@huaweicloud.com>
X-Lms-Return-Path: <lba+26958ec69+597674+vger.kernel.org+yukuai@fnnas.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Reply-To: yukuai@fnnas.com
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Yu Kuai" <yukuai@fnnas.com>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<k@mgml.me>, <yangerkun@huawei.com>, <yi.zhang@huawei.com>, 
	<yukuai@fnnas.com>
Subject: Re: [PATCH v3 04/13] md/raid1,raid10: set Uptodate and clear badblocks if narrow_write_error success
References: <20251215030444.1318434-1-linan666@huaweicloud.com> <20251215030444.1318434-5-linan666@huaweicloud.com>
Content-Language: en-US
To: <linan666@huaweicloud.com>, <song@kernel.org>, <neil@brown.name>, 
	<namhyung@gmail.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.186]) by smtp.feishu.cn with ESMTPS; Sat, 03 Jan 2026 18:16:08 +0800
Date: Sat, 3 Jan 2026 18:16:04 +0800

Hi,

=E5=9C=A8 2025/12/15 11:04, linan666@huaweicloud.com =E5=86=99=E9=81=93:
> From: Li Nan <linan122@huawei.com>
>
> narrow_write_error() returns true when all sectors are rewritten
> successfully. In this case, set R1BIO_Uptodate to return success
> to upper layers and clear correspondinga badblocks.
>
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>   drivers/md/raid1.c  | 24 ++++++++++++++++++++----
>   drivers/md/raid10.c | 17 +++++++++++++++--
>   2 files changed, 35 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 9ffa3ab0fdcc..bd63cf039381 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2587,9 +2587,10 @@ static void handle_write_finished(struct r1conf *c=
onf, struct r1bio *r1_bio)
>   	int m, idx;
>   	bool fail =3D false;
>  =20
> -	for (m =3D 0; m < conf->raid_disks * 2 ; m++)
> +	for (m =3D 0; m < conf->raid_disks * 2 ; m++) {
> +		struct md_rdev *rdev =3D conf->mirrors[m].rdev;
> +
>   		if (r1_bio->bios[m] =3D=3D IO_MADE_GOOD) {
> -			struct md_rdev *rdev =3D conf->mirrors[m].rdev;
>   			rdev_clear_badblocks(rdev,
>   					     r1_bio->sector,
>   					     r1_bio->sectors, 0);
> @@ -2599,11 +2600,26 @@ static void handle_write_finished(struct r1conf *=
conf, struct r1bio *r1_bio)
>   			 * narrow down and record precise write
>   			 * errors.
>   			 */
> -			fail =3D true;
> -			narrow_write_error(r1_bio, m);
> +			if (narrow_write_error(r1_bio, m)) {
> +				/* re-write success */
> +				if (rdev_has_badblock(rdev,
> +						      r1_bio->sector,
> +						      r1_bio->sectors))
> +					rdev_clear_badblocks(rdev,
> +							     r1_bio->sector,
> +							     r1_bio->sectors, 0);
> +				if (test_bit(In_sync, &rdev->flags) &&
> +				    !test_bit(Faulty, &rdev->flags))
> +					set_bit(R1BIO_Uptodate,
> +						&r1_bio->state);

Clear badblocks is fine, although I can't think of any case write io can be
issued to rdev with badblocks existing. And I think it's fine to move above
codes into narrow_write_error() and keep declaring it as void.

> +			} else {
> +				fail =3D true;

Why change the fail here, you also change the logic to return this r1bio ea=
rly,
before this change, r1bio is returned from raid1d() after updating sb. And =
you
don't explain why this is safe.

                 /*
                  * In case freeze_array() is waiting for condition
                  * get_unqueued_pending() =3D=3D extra to be true.
                  */

> +			}
> +
>   			rdev_dec_pending(conf->mirrors[m].rdev,
>   					 conf->mddev);
>   		}
> +	}
>   	if (fail) {
>   		spin_lock_irq(&conf->device_lock);
>   		list_add(&r1_bio->retry_list, &conf->bio_end_io_list);
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 21a347c4829b..db6fbd423726 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -2939,8 +2939,21 @@ static void handle_write_completed(struct r10conf =
*conf, struct r10bio *r10_bio)
>   					r10_bio->sectors, 0);
>   				rdev_dec_pending(rdev, conf->mddev);
>   			} else if (bio !=3D NULL && bio->bi_status) {
> -				fail =3D true;
> -				narrow_write_error(r10_bio, m);
> +				if (narrow_write_error(r10_bio, m)) {
> +					/* re-write success */
> +					if (rdev_has_badblock(rdev,
> +							r10_bio->devs[m].addr,
> +							r10_bio->sectors))
> +						rdev_clear_badblocks(
> +							rdev,
> +							r10_bio->devs[m].addr,
> +							r10_bio->sectors, 0);
> +					if (test_bit(In_sync, &rdev->flags) &&
> +					    !test_bit(Faulty, &rdev->flags))
> +						set_bit(R10BIO_Uptodate, &r10_bio->state);
> +				} else {
> +					fail =3D true;
> +				}
>   				rdev_dec_pending(rdev, conf->mddev);
>   			}
>   			bio =3D r10_bio->devs[m].repl_bio;

--=20
Thansk,
Kuai
