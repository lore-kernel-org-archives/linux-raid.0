Received: from va-2-59.ptr.blmpb.com (va-2-59.ptr.blmpb.com [209.127.231.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30718403B0C
	for <linux-raid@vger.kernel.org>; Thu, 30 Jul 2026 10:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.59
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785408840; cv=none; b=Q/PN6jp5GM9g0zoe/V0je2hRS+DutMz+CQMYNpx01NP3u4DIZY5PIDyuliiibTefvWWt7aCmDesyFFFhQGgAE3BAZILYIhXZ7lmk4Nk8wcBpskHMRog/ATJyBT8zlAvHO+EduAzyy3CG1EBNAQNW7NAt+8JnknjjXqX8kkhynCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785408840; c=relaxed/simple;
	bh=fd+Btv08roZOJWiKVkpXYOyB1hDhuHGDdtV0LpIKFAw=;
	h=Mime-Version:In-Reply-To:To:From:Subject:References:Date:
	 Message-Id:Content-Type; b=BPKBLgO0bXmpUFkPGEqSmQtIVoXf2d4YouePCyponSkuiEnRaZOztp32zwazq3hNEy6KLRfbvc+ebUi99SUuGjzn5UWnKtRFpOCF/RNq2q7IBmUucq7uq9AHoam9vloOTWcFSKJ8oBpx3rAlVChP101aK0gzpX6mIBIXZ1bUgY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=guZeOFwF; arc=none smtp.client-ip=209.127.231.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="guZeOFwF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785408828;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=cOqzVwvZreP4yv8h7eR+WZuMAVEC9pNbnDy4NBvzF0w=;
 b=guZeOFwF0eNHjV3YMK9605tdS6U7Bqn04NHfDRy1oR0A2aIJQRdzIaGLDPRXjEW52zfNRf
 AhYGVGoAQtQ3J3KOzgSF6aQS9Qo2Bq3hJf+2tBB5xmlQYdzBxIBNP9eSQv9k2s+xPdKu/u
 +npoo4aIVvVQXiq6sHH8q+ZzoZB8X22QK3x7hcsa+OjZxGMCFYjqmiJ/kdUf8HH+0HA1G4
 /Vvda1b4dr+om5DRfBNEmSvTdIIRqM5BXyFxq7zG1rMkH52jckQC0H1G9lqv4YrgvvR7IZ
 ptyWLjZgR0k0iN9uHWxBwg9uMprcNBDja8s9bRf9OhB5CjO1bq002kdj8aRhyg==
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <20260708084701.737763-1-lgs201920130244@gmail.com>
Received: from [192.168.1.104] ([39.182.0.181]) by smtp.larksuite.com with ESMTPS; Thu, 30 Jul 2026 10:53:47 +0000
Reply-To: yukuai@fygo.io
To: "Guangshuo Li" <lgs201920130244@gmail.com>, "Song Liu" <song@kernel.org>, 
	"Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	"Josh Hunt" <johunt@akamai.com>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, "yu kuai" <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH] md/raid10: free r10_bio on write NOWAIT exits
X-Original-From: yu kuai <yukuai@fygo.io>
User-Agent: Mozilla Thunderbird
References: <20260708084701.737763-1-lgs201920130244@gmail.com>
Date: Thu, 30 Jul 2026 18:53:43 +0800
Message-Id: <2e5f15cf-8ebf-49de-9652-b7353ed39047@fygo.io>
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+26a6b2d3c+9b0809+vger.kernel.org+yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8

Hi,

=E5=9C=A8 2026/7/8 16:47, Guangshuo Li =E5=86=99=E9=81=93:
> The change referenced by the Fixes tag made a NOWAIT early exit in
> raid10_write_request() free the r10_bio directly instead of using
> raid_end_bio_io(), avoiding an unmatched allow_barrier() while still
> returning the r10_bio object to the mempool.
>
> The same function has two other NOWAIT early exits. One is before
> regular_request_wait(), where the request has not taken a barrier
> reference. The other is in the reshape metadata path, where the barrier
> reference is released explicitly with allow_barrier(). Both paths end the
> bio and return false, but neither returns the r10_bio object to the
> mempool.
>
> Free the r10_bio on both NOWAIT exits. Keep the existing barrier handling
> unchanged, since only the reshape path has taken a barrier reference.
>
> Fixes: 7d96f3120a7f ("md/raid10: fix deadlock with check operation and no=
wait requests")
> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> ---
>   drivers/md/raid10.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 0a3cfdd3f5df..d480344c5b8f 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1364,6 +1364,7 @@ static bool raid10_write_request(struct mddev *mdde=
v, struct bio *bio,
>   		DEFINE_WAIT(w);
>   		/* Bail out if REQ_NOWAIT is set for the bio */
>   		if (bio->bi_opf & REQ_NOWAIT) {
> +			free_r10bio(r10_bio);
>   			bio_wouldblock_error(bio);
>   			return false;
>   		}
> @@ -1397,6 +1398,7 @@ static bool raid10_write_request(struct mddev *mdde=
v, struct bio *bio,
>   		md_wakeup_thread(mddev->thread);
>   		if (bio->bi_opf & REQ_NOWAIT) {
>   			allow_barrier(conf);
> +			free_r10bio(r10_bio);
>   			bio_wouldblock_error(bio);
>   			return false;
>   		}
This patch is not needed as nowait will be removed for raid10.

--=20
Thanks,
Kuai
