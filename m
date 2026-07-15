Received: from va-2-42.ptr.blmpb.com (va-2-42.ptr.blmpb.com [209.127.231.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463983EB0FA
	for <linux-raid@vger.kernel.org>; Wed, 15 Jul 2026 09:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784106579; cv=none; b=Rg8avDbJaw1Vb9ruW48Q4eDWLIGBxa2TjqzNC6jIBrn4wINCNiLOF9kGQpIoEzA9kkAMswM0unInamyucyZlnmw9D+QPnzymt4F14oZ/J9KqUWjE/jfvrhSf1Ggn1iH1SujNhNByO0NarE90w9saiD+5PkFOESyyB3GfB/J5X0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784106579; c=relaxed/simple;
	bh=gjQ0L4cjLtJI1SBhLwbcua00QZ5yXbEE8/6yBzuKPjw=;
	h=References:To:Content-Type:Cc:From:Subject:Date:Message-Id:
	 Mime-Version:In-Reply-To; b=bVJA+C+7S7vSHaKqpBZOOB+yg9fcaEkR+Or9p+Iv0MXZp7dDsSykuWSq9isiUKVZjIajDTbSJnnv/XpN1C5LoGBBDXKdSFJSrBDUbPV2eynUY0YCnb+N6BsZ57Ae5VdBhi67mSt3IcIW+Nb+zs31CZPSL//4YCCweTOkZNobmO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=iP/Y4CUe; arc=none smtp.client-ip=209.127.231.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="iP/Y4CUe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1784106562;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=i7XbYNbE/Tm0dN6OZO1KNd8nDbLx0PGrBUuDMn5mlVk=;
 b=iP/Y4CUeIYyOAtm4qoeTgSEWd8lR0J3tJ9dMgTSEDApkQjd2gN7a22zYrr4y2lgnMMbf+3
 hEQk/uMz9LwbfdtSKGAwazoWZOEjADKXr8cUNojA2eJJ7XUNzYUSKHskfZ++Hop61U9kQ/
 /GZ7gKpQXUnIcq0G6mx7GWl4MBnXYEIFVge0GlScw+Z/02p/xnNN2ZHcVub/3U3F/+VMvk
 xyiDCiALFehs/Cf78FnLaPG+NwZDtvn8v4sx7rA0IautoTpwuqwQ2+RfFcZm/wkiiGYRmH
 wi+ywM9cp38pdToNpnOMmEK1/qjeu3cT38wFB+fExBniMaqTxDFrraPkLnj00g==
User-Agent: Mozilla Thunderbird
X-Lms-Return-Path: <lba+26a574e41+2fa024+vger.kernel.org+yukuai@fygo.io>
References: <20260710101521.1714-1-abd.masalkhi@gmail.com> <20260710101521.1714-3-abd.masalkhi@gmail.com>
Reply-To: yukuai@fygo.io
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>, <song@kernel.org>, 
	<magiclinan@didiglobal.com>, <xiao@kernel.org>, <axboe@kernel.dk>, 
	<vverma@digitalocean.com>, <john.g.garry@oracle.com>, 
	<martin.petersen@oracle.com>, <linux-kernel@vger.kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Received: from [192.168.1.104] ([39.182.0.157]) by smtp.larksuite.com with ESMTPS; Wed, 15 Jul 2026 09:09:20 +0000
Content-Type: text/plain; charset=UTF-8
Cc: <linux-raid@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH v4 2/7] md/raid1: restrict atomic write limits and handle runtime constraints
Date: Wed, 15 Jul 2026 17:09:17 +0800
Message-Id: <6b0b5038-d9d6-4b4f-b750-adbf790e83ac@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: yu kuai <yukuai@fygo.io>
In-Reply-To: <20260710101521.1714-3-abd.masalkhi@gmail.com>

=E5=9C=A8 2026/7/10 18:15, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:

> Restrict the RAID1 atomic write limits by setting chunk_sectors to
> BARRIER_UNIT_SECTOR_SIZE so that atomic writes never straddle a barrier
> unit.
>
> A bio that passes block-layer validation may still become unserviceable
> within RAID1 due to bad blocks or write-behind constraints. In the former
> case, complete the bio with EIO. In the latter case, disable
> write-behind rather than failing the bio with EIO.
>
> Fixes: f2a38abf5f1c ("md/raid1: Atomic write support")
> Fixes: a4c55c902670 ("md/raid1: simplify raid1_write_request() error hand=
ling")
> Reviewed-by: John Garry<john.g.garry@oracle.com>
> Signed-off-by: Abd-Alrhman Masalkhi<abd.masalkhi@gmail.com>
> ---
> Changes in v4:
>   - Improve the commit message.
>   - Add Reviewed-by tag from John Garry.
>   - Link to v3:https://lore.kernel.org/linux-raid/20260708101341.473750-3=
-abd.masalkhi@gmail.com/
>
> Changes in v3:
>   - Set chunk_sectors to BARRIER_UNIT_SECTOR_SIZE instead of setting
>     atomic_write_hw_unit_max.
>   - Avoid enabling write-behind when the atomic write exceeds the
>     write-behind limit.
>   - Link to v2:https://lore.kernel.org/linux-raid/20260628142420.1051027-=
3-abd.masalkhi@gmail.com/
>
> Changes in v2:
>   - Drop the early atomic write split check from raid1_write_request().
>   - Advertise the atomic write size limit via queue limits.
>   - Disable write-behind instead of failing atomic writes when the
>     BIO_MAX_VECS limit is encountered.
>   - Link to v1:https://lore.kernel.org/linux-raid/20260623072456.333437-3=
-abd.masalkhi@gmail.com/
> ---
>   drivers/md/raid1.c | 25 ++++++++++---------------
>   1 file changed, 10 insertions(+), 15 deletions(-)
Reviewed-by: Yu Kuai <yukuai@fygo.io>

--=20
Thanks,
Kuai
