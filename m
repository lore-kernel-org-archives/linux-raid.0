Received: from va-2-59.ptr.blmpb.com (va-2-59.ptr.blmpb.com [209.127.231.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE21433ADBA
	for <linux-raid@vger.kernel.org>; Fri, 31 Jul 2026 05:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.59
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785475065; cv=none; b=u9gyTQCykJbm9N+dOKzUg9zPSBVUvJ0CLd5oZTwmztGpKxrEyPbvH4f5AeX95mq7i9eaVl+AAPYey7tL5tDGtbvhtWA0EnS7TvPexUR6hZxDxZRFCtC8DAinafEEKxiBc6hV3a7PUEzTBzdSaQdcmLEsGl+5cFrZoacfhXBHlm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785475065; c=relaxed/simple;
	bh=B5xwd5vUits8UxtPLBkmFGlH6dLtLt+NkWXu6gt4v7I=;
	h=Date:Message-Id:Content-Type:In-Reply-To:To:Cc:Mime-Version:
	 Subject:References:From; b=G+vWYhra+wEEN292EI2ztL7o0doEymTUIoncSrKoOCXvF5NxR1GVdTWGQKE1VEiewQqeBv/TQS2ar4fP4GabcqaFIdvOwqLioBzAgpBLlGdasdiRm9tZOM6Vl/P+41MHoTiNWLm2jJpbfT4PfcEZY892SPCoh17oPHovIprK03c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=UKfOVu5x; arc=none smtp.client-ip=209.127.231.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="UKfOVu5x"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785475051;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Ryo0md/wQS/OdYrZ2bBr+Ti0pzM3gk9wRU62+yCcmIc=;
 b=UKfOVu5x9QK/1TekpAHZamAJowKCK4Ujp2H4MDHIQ6wc+0D0JCUS4umTK+vUp1paHq6aYF
 5vRdZXJrpxRxgx3r8/tFJZWhfNIMUOzdahU5RnHjQxgIzNiTjnl0JzcHCCO5ufLroRdJkx
 YSN0jpmmTgO3EH4jMKYB6LVZswWMl6pXXzxRUjDEyXmZSaAayj2PPsHrk3VK/kH/iHY6wt
 Wd9CCbKXxI/fJiheBh2o8r6rYcwZDK7rVn9FpI8kNMSfnXeEhj1ISBMYoTo63aBZtkCgZ2
 BdI5HBX/a9eIcG6yiNVyZmk0aCdc3PXRAQwro5pA50fnaBUitPvxAc2eVp6wNg==
Date: Fri, 31 Jul 2026 13:17:25 +0800
Message-Id: <af85e490-8332-423c-a333-06eb532dd672@fygo.io>
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20260711161326.962336-1-zhanggenjian@126.com>
To: "Genjian" <zhanggenjian@126.com>, <song@kernel.org>, 
	<magiclinan@didiglobal.com>, <xiao@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	"Genjian Zhang" <zhanggenjian@kylinos.cn>
Content-Transfer-Encoding: quoted-printable
Reply-To: yukuai@fygo.io
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: yu kuai <yukuai@fygo.io>
Subject: Re: [PATCH] md/raid5: complete discard bios while reshape is active
User-Agent: Mozilla Thunderbird
X-Lms-Return-Path: <lba+26a6c2fea+9d2221+vger.kernel.org+yukuai@fygo.io>
References: <20260711161326.962336-1-zhanggenjian@126.com>
Received: from [192.168.1.104] ([39.182.0.181]) by smtp.larksuite.com with ESMTPS; Fri, 31 Jul 2026 05:17:29 +0000
From: "yu kuai" <yukuai@fygo.io>

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
>  =20
> -	if (mddev->reshape_position !=3D MaxSector)
> +	if (mddev->reshape_position !=3D MaxSector) {
>   		/* Skip discard while reshape is happening */
> +		bio_endio_status(bi, BLK_STS_AGAIN);
>   		return;
> +	}
Rebase and applied to md-7.3
>  =20
>   	if (!raid5_discard_limits(mddev, bi))
>   		return;

--=20
Thanks,
Kuai
