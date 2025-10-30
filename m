Received: from sg-1-17.ptr.blmpb.com (sg-1-17.ptr.blmpb.com [118.26.132.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00143314B8F
	for <linux-raid@vger.kernel.org>; Thu, 30 Oct 2025 02:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761791512; cv=none; b=RRonuMlO812pj7e/Iofpq/yHyW3GjldKQ9AbzykouEuSk/gJEUg7iOBNF8IRi1VhRibSCB/vMDJpv6pSGurTPFEq67PUvObylksVZa6U/6xC3qcrSHnCc7L44xjUacQMHvQ8mPBsaToHhbKxE1eDEt4kJ91y2fZKptWOuozd8xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761791512; c=relaxed/simple;
	bh=HnOcmMp6g+DAOtp5gH56m8gVUubhi0chyyWQzyAsI+Y=;
	h=Mime-Version:From:Message-Id:In-Reply-To:References:Cc:Subject:
	 Date:To:Content-Type; b=L2hcxgToK+46HQfqdzt0vBdX3pAgcQ1VY4VWwH3gtGjWh0g6p3NjZj6dwesvR8Wfl3OsYBzOHOtWlzqNfme+bZZ9EH3ofisNLjjStSvtKQRurtAfd+8jpfkezVDoEZuFor1dvLWGa2IVAF0k8WWNf2jDX1yt2qUHlZkTA0n7tRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=rc77yqUA; arc=none smtp.client-ip=118.26.132.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="rc77yqUA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1761791497;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Wss5dHJesro920Q2af4wKlNPPfjjqJ7ieraUu5LPXP4=;
 b=rc77yqUAjlGmatLoU3vOO8Qds7zvyYEUnF4neCLQXgyQUKs9vCCKxP+keHrTb7FWRBQq29
 kyhj4RtDGPPZpABOKW0RStvMSkVLlr+F/SfJaZORJ81WBTcByxpRA7SotmOIuNEJ4tj4Ds
 rrfWfR/PUmS9Zn3jA98n5YP8WatsyCC3+/ixHxSKgm+j3ZqiYYJcgkRsUwa6G9+JRxiMaO
 mTsp/teirEbpErwplMpQaeMM4mC8kOK4Lij3P32xa4TnzJcVMg4bMD/GjcL305QwNU2lxO
 ufSqW2vLJkYjCURNb/2BSLArZTB6rPMJeM6lbM/ko9FjQXm0IoXDG/YSXwp+8A==
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
From: "Yu Kuai" <yukuai@fnnas.com>
Message-Id: <10e48729-ce2e-4a00-a5e7-a469631ccc99@fnnas.com>
In-Reply-To: <20251027150433.18193-6-k@mgml.me>
User-Agent: Mozilla Thunderbird
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.168]) by smtp.feishu.cn with ESMTPS; Thu, 30 Oct 2025 10:31:34 +0800
References: <20251027150433.18193-1-k@mgml.me> <20251027150433.18193-6-k@mgml.me>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<yukuai@fnnas.com>
Subject: Re: [PATCH v5 05/16] md/raid1: implement pers->should_error()
Date: Thu, 30 Oct 2025 10:31:32 +0800
Content-Transfer-Encoding: quoted-printable
To: "Kenta Akagi" <k@mgml.me>, "Song Liu" <song@kernel.org>, 
	"Shaohua Li" <shli@fb.com>, "Mariusz Tkaczyk" <mtkaczyk@kernel.org>, 
	"Guoqing Jiang" <jgq516@gmail.com>
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26902ce07+bc3b44+vger.kernel.org+yukuai@fnnas.com>
Reply-To: yukuai@fnnas.com

Hi,

=E5=9C=A8 2025/10/27 23:04, Kenta Akagi =E5=86=99=E9=81=93:
> The failfast feature in RAID1 and RAID10 assumes that when md_error() is
> called, the array remains functional because the last rdev neither fails
> nor sets MD_BROKEN.
>
> However, the current implementation can cause the array to lose
> its last in-sync device or be marked as MD_BROKEN, which breaks the
> assumption and can lead to array failure.
>
> To address this issue, introduce a new handler, md_cond_error(), to
> ensure that failfast I/O does not mark the array as broken.
>
> md_cond_error() checks whether a device should be faulted based on
> pers->should_error().  This commit implements should_error() callback
> for raid1 personality, which returns true if faulting the specified rdev
> would cause the mddev to become non-functional.
>
> Signed-off-by: Kenta Akagi <k@mgml.me>
> ---
>   drivers/md/raid1.c | 35 +++++++++++++++++++++++++++++++++++
>   1 file changed, 35 insertions(+)
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 202e510f73a4..69b7730f3875 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1732,6 +1732,40 @@ static void raid1_status(struct seq_file *seq, str=
uct mddev *mddev)
>   	seq_printf(seq, "]");
>   }
>  =20
> +/**
> + * raid1_should_error() - Determine if this rdev should be failed
> + * @mddev: affected md device
> + * @rdev: member device to check
> + * @bio: the bio that caused the failure
> + *
> + * When failfast bios failure, rdev can fail, but the mddev must not fai=
l.
> + * This function tells md_cond_error() not to fail rdev if bio is failfa=
st
> + * and last rdev.
> + *
> + * Returns: %false if bio is failfast and rdev is the last in-sync devic=
e.
> + *	     Otherwise %true - should fail this rdev.
> + */
> +static bool raid1_should_error(struct mddev *mddev, struct md_rdev *rdev=
, struct bio *bio)
> +{
> +	int i;
> +	struct r1conf *conf =3D mddev->private;
> +
> +	if (!(bio->bi_opf & MD_FAILFAST) ||
> +	    !test_bit(FailFast, &rdev->flags) ||
> +	    test_bit(Faulty, &rdev->flags))
> +		return true;

The above checking is the same for raid1 and raid10, so I think it should g=
o to
the caller, and you don't need to pass in bio.

> +
> +	for (i =3D 0; i < conf->raid_disks; i++) {
> +		struct md_rdev *rdev2 =3D conf->mirrors[i].rdev;
> +
> +		if (rdev2 && rdev2 !=3D rdev &&
> +		    test_bit(In_sync, &rdev2->flags) &&
> +		    !test_bit(Faulty, &rdev2->flags))
> +			return true;
> +	}

Why not use the same checking from raid1_error()? You can factor out a
helper for this. And BTW, now I feel it's better to name the new method
like rdev_last_in_sync().

Thanks,
Kuai

> +	return false;
> +}
> +
>   /**
>    * raid1_error() - RAID1 error handler.
>    * @mddev: affected md device.
> @@ -3486,6 +3520,7 @@ static struct md_personality raid1_personality =3D
>   	.free		=3D raid1_free,
>   	.status		=3D raid1_status,
>   	.error_handler	=3D raid1_error,
> +	.should_error	=3D raid1_should_error,
>   	.hot_add_disk	=3D raid1_add_disk,
>   	.hot_remove_disk=3D raid1_remove_disk,
>   	.spare_active	=3D raid1_spare_active,
