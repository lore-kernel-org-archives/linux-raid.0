Received: from sg-1-17.ptr.blmpb.com (sg-1-17.ptr.blmpb.com [118.26.132.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1146A314B83
	for <linux-raid@vger.kernel.org>; Tue, 28 Oct 2025 12:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761653563; cv=none; b=DZ8xwYEpdUED8KXpotlIHftpQG9sKycM4Ub4CqXT8T+CzB20OeITsvwnnKV6tvJFdLmqdUkIyLYGzqwGOGG41SCw9Hjq3JBlzsLnvjOebHkjFVBb3F6CZEyUUFFfQ/UF385Y6HsHZWMoH/b4p6+7Tl1mFvyWFQQgIS4i+DbpsWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761653563; c=relaxed/simple;
	bh=VHWMyh+dNeS7BtojdmRX1nPfTRSvy/CcULphApk7kp4=;
	h=Message-Id:To:Date:Mime-Version:References:From:Cc:Subject:
	 Content-Type:In-Reply-To; b=Z686ndhyyr64nTflzE9y44+1QKSVPZeAKWE3kfu3zeUMYzkUw0fEYxeOhlgYZdQ4jbMK5eOli81HiLWuBzkr456vqP3TkEhYvFlt/nAkQgJMlB3gey0n2JWfo0s1HxBLLDdkh8KWRPTzgCk3aweqsUZj4I5NBkxIDHZNPnKOsq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=zaCNM8ri; arc=none smtp.client-ip=118.26.132.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="zaCNM8ri"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1761653552;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=giOIBPqQRzHEKUfrCcJhqjbXIb2PCt2QXcLYfGYvyaE=;
 b=zaCNM8rizGCNbAME8gdcUrz0aBY8aVXTVUgr7LJjTmp8jVW7YUZp2H2xEXRybk22eKdjLp
 +rzx8mYtMroD7nQtCab5CW5JikWYt0aKWpje2aCPppCkNaxgetX748RiZj0PNSvkaITCrC
 Ja5S0EQrd6mDDBOCmib27WtaTGWqQWetSevwYoLPckZQSNJSJgjpV8FA1f+ql+rr0k6gMD
 ESZ6GSmvfLHV1lmWy73Ql7CYoETqx/AINeblz7lRIg/ZCMXnDYVwZ/wQ3M6SfQhu3wLzcO
 qhzUHPl2dL0IChqDpw957T5MDnLG4XWvi2B2oUlo+f2kJ1LrVQXYq99Jh2EBTg==
Message-Id: <effbcb62-9bf7-45ff-ad39-1e3be1e63650@fnnas.com>
X-Lms-Return-Path: <lba+26900b32f+d46e72+vger.kernel.org+yukuai@fnnas.com>
Content-Transfer-Encoding: quoted-printable
To: <linan122@huawei.com>, <corbet@lwn.net>, <song@kernel.org>, 
	<hare@suse.de>, <xni@redhat.com>
Date: Tue, 28 Oct 2025 20:12:28 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251027072915.3014463-1-linan122@huawei.com> <20251027072915.3014463-4-linan122@huawei.com>
User-Agent: Mozilla Thunderbird
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.168]) by smtp.feishu.cn with ESMTPS; Tue, 28 Oct 2025 20:12:30 +0800
From: "Yu Kuai" <yukuai@fnnas.com>
Cc: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-raid@vger.kernel.org>, <linan666@huaweicloud.com>, 
	<yangerkun@huawei.com>, <yi.zhang@huawei.com>, <yukuai@fnnas.com>
Subject: Re: [PATCH v7 3/4] md/raid0: Move queue limit setup before r0conf initialization
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20251027072915.3014463-4-linan122@huawei.com>
Reply-To: yukuai@fnnas.com

Hi,

=E5=9C=A8 2025/10/27 15:29, linan122@huawei.com =E5=86=99=E9=81=93:
> From: Li Nan <linan122@huawei.com>
>
> Prepare for making logical blocksize configurable.
>
> Move raid0_set_limits() before create_strip_zones(). It is safe as fields
> modified in create_strip_zones() do not involve mddev configuration, and
> rdev modifications there are not used in raid0_set_limits().
>
> 'blksize' in create_strip_zones() fetches mddev's logical block size. Thi=
s
> change has no impact until logical block size becomes configurable.
>
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>   drivers/md/raid0.c | 13 +++++++------
>   1 file changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index e443e478645a..49477b560cc9 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -68,7 +68,7 @@ static int create_strip_zones(struct mddev *mddev, stru=
ct r0conf **private_conf)
>   	struct strip_zone *zone;
>   	int cnt;
>   	struct r0conf *conf =3D kzalloc(sizeof(*conf), GFP_KERNEL);
> -	unsigned blksize =3D 512;
> +	unsigned int blksize =3D queue_logical_block_size(mddev->gendisk->queue=
);
>  =20
>   	*private_conf =3D ERR_PTR(-ENOMEM);
>   	if (!conf)

I think the following setting of blksize can be removed as well.

blksize =3D max(blksize, ...)

Thanks,
Kuai

> @@ -405,6 +405,12 @@ static int raid0_run(struct mddev *mddev)
>   	if (md_check_no_bitmap(mddev))
>   		return -EINVAL;
>  =20
> +	if (!mddev_is_dm(mddev)) {
> +		ret =3D raid0_set_limits(mddev);
> +		if (ret)
> +			return ret;
> +	}
> +
>   	/* if private is not null, we are here after takeover */
>   	if (mddev->private =3D=3D NULL) {
>   		ret =3D create_strip_zones(mddev, &conf);
> @@ -413,11 +419,6 @@ static int raid0_run(struct mddev *mddev)
>   		mddev->private =3D conf;
>   	}
>   	conf =3D mddev->private;
> -	if (!mddev_is_dm(mddev)) {
> -		ret =3D raid0_set_limits(mddev);
> -		if (ret)
> -			return ret;
> -	}
>  =20
>   	/* calculate array device size */
>   	md_set_array_sectors(mddev, raid0_size(mddev, 0, 0));
