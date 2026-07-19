Received: from lf-1-33.ptr.blmpb.com (lf-1-33.ptr.blmpb.com [103.149.242.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598AE153BE9
	for <linux-raid@vger.kernel.org>; Sun, 19 Jul 2026 12:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.149.242.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784465742; cv=none; b=ldFaQFsVhRTWTENNCpZlvR4k8+AtV/tAahdWdjoiCslG0reCiSUveSHgcNVOhfF9ht0DqUSKt9HxlXTyM5zQQrZKEodeFd5Tktwv3tcTI/DjcGJhFQ3JWhWkXr4CE2nC3Vhs3L0pZ1hWR69vp2Kv2SRCvOqX7N5K9MZtm3YE+M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784465742; c=relaxed/simple;
	bh=5bQfoukhnRMLow/ae/cLGbR/mU0M4WOo8QxdTYHv2+c=;
	h=From:Message-Id:In-Reply-To:References:Date:Mime-Version:
	 Content-Type:To:Subject:Cc; b=hf7WrHP0UgYBGcpZeI1wC3tGf8Qw6F2sKiORqrTey6JdzLZ9auTXdpzjwG8JxkPUpYRvx37mkua+IXp9CxKs2lSzI8nlslsyMiobAUmg4AKaE67WcptO8p4+qf/AhqKiZRL8IO7+k6fsw7tZ5G5aU+sufU4CzdhKKaBhnyKni0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=K9bxAFxL; arc=none smtp.client-ip=103.149.242.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="K9bxAFxL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1784465687;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=1dYjN/TVTrbtFCweYWA2tWVnGUbGDz2RlP0EYcx9uGU=;
 b=K9bxAFxLAZ83JRkHHADNHHcw4+0RJOJ2jNNlhOWjiVbeVwCLn8DaxG/PxV1qrJkqc4Ftw9
 +ibEVe4G4Y1Q/n7QlCFtpgDGijgVmkjpAWB1WQpRTt/BONEJefMQ5m6GPmd52Y+4+CRwxl
 QkskbJlLj1e6mVT7oZJ10dN84Z32NrZRJp2hr3MNvIz49eed4YsNgWMpxMVgGMnav5yKIx
 bwAEaDyAXB2V61B8lC0wz7XWYgnArspPJIO/EVs4PRBiPC0G3UnIv0hzizV3JiAIYqlzuR
 asznrkvjhfwE2xJpMAd2o2CH46AS9TBOsXHj7tP3dU0eVw0Z/4JhzW/TxscFJA==
From: "yu kuai" <yukuai@fygo.io>
Message-Id: <8ff91547-4841-4cea-87bc-9d6979df61ab@fygo.io>
In-Reply-To: <20260711161326.962336-1-zhanggenjian@126.com>
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@fygo.io
References: <20260711161326.962336-1-zhanggenjian@126.com>
Date: Sun, 19 Jul 2026 20:54:42 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: "Genjian" <zhanggenjian@126.com>, <song@kernel.org>, <yukuai@fygo.io>, 
	<magiclinan@didiglobal.com>, <xiao@kernel.org>
Subject: Re: [PATCH] md/raid5: complete discard bios while reshape is active
X-Original-From: yu kuai <yukuai@fygo.io>
Received: from [192.168.1.104] ([39.182.0.157]) by smtp.larksuite.com with ESMTPS; Sun, 19 Jul 2026 12:54:46 +0000
X-Lms-Return-Path: <lba+26a5cc916+983ed5+vger.kernel.org+yukuai@fygo.io>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	"Genjian Zhang" <zhanggenjian@kylinos.cn>

Hi,

=E5=9C=A8 2026/7/12 0:13, Genjian =E5=86=99=E9=81=93:
> From: Genjian Zhang <zhanggenjian@kylinos.cn>
>
> make_discard_request() returns without completing the bio when reshape
> is in progress. Discard callers block in submit_bio_wait()
> waiting for a completion that never arrives.  The caller hangs in
> uninterruptible sleep, and this does not resolve when reshape finishes.
>
> Complete the bio with BLK_STS_AGAIN so userspace can retry after reshape,
> consistent with the existing policy of not processing discard during
> reshape.
>
> Tested on a loop-backed RAID5 array during mdadm --grow: without this
> patch, blkdiscard hangs in bio_await() and remains in uninterruptible
> sleep after md reports "reshape done"; with this patch it returns
> -EAGAIN instead.
>
> Signed-off-by: Genjian Zhang <zhanggenjian@kylinos.cn>
> ---
>   drivers/md/raid5.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index ffb5fcde54a9..4c3b42b2af85 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -5722,9 +5722,11 @@ static void make_discard_request(struct mddev *mdd=
ev, struct bio *bi)
>   	if (WARN_ON_ONCE(bi->bi_opf & REQ_NOWAIT))
>   		return;

As nowait will be removed soon, I'm fine leaving it here.

Reviewed-by: Yu Kuai <yukuai@fygo.io>

>  =20
> -	if (mddev->reshape_position !=3D MaxSector)
> +	if (mddev->reshape_position !=3D MaxSector) {
>   		/* Skip discard while reshape is happening */
> +		bio_endio_status(bi, BLK_STS_AGAIN);
>   		return;
> +	}
>  =20
>   	if (!raid5_discard_limits(mddev, bi))
>   		return;

--=20
Thanks,
Kuai
