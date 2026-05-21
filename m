Received: from va-2-27.ptr.blmpb.com (va-2-27.ptr.blmpb.com [209.127.231.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5620D2D877A
	for <linux-raid@vger.kernel.org>; Thu, 21 May 2026 01:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779326824; cv=none; b=byktZ6BX4NUYTlICZl15Vpo18qESI/du+V6YoOh5KQ0YXfsBsQEZ9rlRpDKgQn1c/JQUcng0C+VmVkKkJKOx74+nOCHCeUYmP6msoaEOZh2NYJTu4UezPWGeV521U64slqZlXayjZGRl+D8hVFNYD7smMfbU4APNpHD6OmjiiDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779326824; c=relaxed/simple;
	bh=a9mJ+MH707TZjUz2syJ3icq1fx1VtbSptaN9k9O8eR4=;
	h=In-Reply-To:Cc:Content-Type:From:References:To:Date:Subject:
	 Message-Id:Mime-Version; b=WUfvBKdmLWiWUFYfJPYXZq92N645fiY6a6LQXy+UxVQ4eq4YiJgcctSvq310Rc23fbxphWcA1ng78EQUp0PPInFExzEERhdShRTkRK8I2i+koNEg+Wpuitw2FjV+EZn7ryMae3QeAQkEtiBlh7namlktvJUifbetUTIm29q88ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=vbwGuDd4; arc=none smtp.client-ip=209.127.231.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="vbwGuDd4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1779326812;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=SV9lPPfmxwDbBbTudG+ZBkbt0ONvISG4IKYcaMt5zOo=;
 b=vbwGuDd4lAGPWDYR/t0DhxUVIhLhmni0O0KutTSBoIp3LCm6IPAxT1zuJqbS6wWOdUabZv
 51+nIe6ZF+p7c/dMy+amd2nHofPtd0tjH61iPOsjgMc3v+TtnMC7lbAmhHEaMMEsoBKdWn
 FY9/VG44y5rJoh2sWXLvrf1R+EZZc/00MT1y7LWJo+c7mHC4G7sUX/NG9uzENZRy1WOna5
 UdM0Gz9f+B3zHlLFM9bttodk0eGrGY2bsWJQnn5UUgvNgeVEK213po0FkD1IYihwGCy5WM
 tVljc2fL9mNwFpaI/BxeR+8PboajviUEuIdSvoRJwrXr7b/BOG/s4n8e83rxjw==
In-Reply-To: <20260501114652.590037-4-abd.masalkhi@gmail.com>
Reply-To: yukuai@fygo.io
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<yukuai@fygo.io>
Received: from [192.168.1.104] ([39.182.0.188]) by smtp.feishu.cn with ESMTPS; Thu, 21 May 2026 09:26:49 +0800
Content-Type: text/plain; charset=UTF-8
From: "Yu Kuai" <yukuai@fnnas.com>
References: <20260501114652.590037-1-abd.masalkhi@gmail.com> <20260501114652.590037-4-abd.masalkhi@gmail.com>
Content-Language: en-US
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>, <song@kernel.org>, 
	<xni@redhat.com>, <neilb@suse.com>, <shli@fb.com>
Date: Thu, 21 May 2026 09:26:48 +0800
X-Lms-Return-Path: <lba+26a0e5f5b+3e2751+vger.kernel.org+yukuai@fnnas.com>
Content-Transfer-Encoding: quoted-printable
X-Original-From: Yu Kuai <yukuai@fygo.io>
Subject: Re: [PATCH v2 3/3] md/raid1,raid10: fix bio accounting for split md cloned bios
Message-Id: <e0a1bfe1-f106-4587-9433-117fbd8e65ec@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird

Hi,

=E5=9C=A8 2026/5/1 19:46, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
> Use md_cloned_bio() to control bio accounting instead of relying
> on r1bio_existed in raid1 or the io_accounting flag in raid10.
>
> The previous logic does not reliably reflect whether a bio is an
> md cloned bio. When a failed bio is split and resubmitted via
> bio_submit_split_bioset() on the error path, this can lead to either
> double accounting for md cloned bios, or missing accounting for bios
> returned from bio_submit_split_bioset()
>
> Fix this by using md_cloned_bio() to detect md cloned bios and
> skip accounting accordingly.
>
> Fixes: bb2a9acefaf9 ("md/raid1: switch to use md_account_bio() for io acc=
ounting")
> Fixes: 820455238366 ("md/raid10: switch to use md_account_bio() for io ac=
counting")

The same as patch 2, I don't think this patch fix any problem. And I
think current IO accounting is correct.

> Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
> ---
> This patch depends on patch 1.
>
> Changes in v2:
>   - New patch.
> ---
>   drivers/md/raid1.c  | 2 +-
>   drivers/md/raid10.c | 8 ++++----
>   2 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index c52ecd38c163..dfaf34141325 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1396,7 +1396,7 @@ static void raid1_read_request(struct mddev *mddev,=
 struct bio *bio,
>   	}
>  =20
>   	r1_bio->read_disk =3D rdisk;
> -	if (!r1bio_existed) {
> +	if (likely(!md_cloned_bio(mddev, bio))) {
>   		md_account_bio(mddev, &bio);
>   		r1_bio->master_bio =3D bio;
>   	}
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 8c6fc398260e..93af7bbc9005 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1146,7 +1146,7 @@ static bool regular_request_wait(struct mddev *mdde=
v, struct r10conf *conf,
>   }
>  =20
>   static void raid10_read_request(struct mddev *mddev, struct bio *bio,
> -				struct r10bio *r10_bio, bool io_accounting)
> +				struct r10bio *r10_bio)
>   {
>   	struct r10conf *conf =3D mddev->private;
>   	struct bio *read_bio;
> @@ -1226,7 +1226,7 @@ static void raid10_read_request(struct mddev *mddev=
, struct bio *bio,
>   	}
>   	slot =3D r10_bio->read_slot;
>  =20
> -	if (io_accounting) {
> +	if (likely(!md_cloned_bio(mddev, bio))) {
>   		md_account_bio(mddev, &bio);
>   		r10_bio->master_bio =3D bio;
>   	}
> @@ -1552,7 +1552,7 @@ static void __make_request(struct mddev *mddev, str=
uct bio *bio, int sectors)
>   			conf->geo.raid_disks);
>  =20
>   	if (bio_data_dir(bio) =3D=3D READ)
> -		raid10_read_request(mddev, bio, r10_bio, true);
> +		raid10_read_request(mddev, bio, r10_bio);
>   	else
>   		raid10_write_request(mddev, bio, r10_bio);
>   }
> @@ -2872,7 +2872,7 @@ static void handle_read_error(struct mddev *mddev, =
struct r10bio *r10_bio)
>  =20
>   	rdev_dec_pending(rdev, mddev);
>   	r10_bio->state =3D 0;
> -	raid10_read_request(mddev, r10_bio->master_bio, r10_bio, false);
> +	raid10_read_request(mddev, r10_bio->master_bio, r10_bio);
>   	/*
>   	 * allow_barrier after re-submit to ensure no sync io
>   	 * can be issued while regular io pending.

--=20
Thansk,
Kuai
