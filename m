Received: from va-2-35.ptr.blmpb.com (va-2-35.ptr.blmpb.com [209.127.231.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439DE374728
	for <linux-raid@vger.kernel.org>; Tue, 28 Apr 2026 08:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777364727; cv=none; b=MNnPBJyIXHEepEDN40RfCC939V4xDWcKUSw/n3g7ovxFaerWTEPW++m/Qe/TRIgUFSrjpxUK863Iw9Q1QHlMCFqoJJHhfq/UtksRSBVoBuMbFmMnmvRnIm10GV7rHjvvwPobPePPEybCm65OGKb58P6bxDiQ13uYO3wTn2iG88w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777364727; c=relaxed/simple;
	bh=cqJXZnJQXqsJkJVPIzmLb+QAPSjHX3tSzEwu7rRa9Xg=;
	h=To:Message-Id:References:Subject:Date:Mime-Version:Content-Type:
	 Cc:From:In-Reply-To; b=XDQX4lz9xuwF/0bNdD/4hryHJo0DaDqaGs20cNShgB4mJss6igEQzzZQ7h1OG0jm9fO18ZsGTrdUEXNpBJRRRGI4ZvO2XTglwDDtHzMQv5KDKEl11ErpQr9lGwj4nnHd+QQ6ZACbyNUyza/HrvyAjrSPNrJBrkA1ZGOi7jzny0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=cYr62vpH; arc=none smtp.client-ip=209.127.231.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="cYr62vpH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1777364714;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=JqB9cy70hwHtjIVUFRZiILqL5MhAu2nLPU23XRRuSe4=;
 b=cYr62vpHW9veAMGuhBUSUP4TZTTFBhBdv3odbid0Lv/UJ3VOZoFY2A9hQxWnBJoIim1KtF
 WXbnG4hWgNb5YN04jUOKLj2h62DvM81CeV2GmMbZzcv8HrLCQ9JiJa+GufAqUwnev0CLbp
 +jQCEFaQK2WVg7Cx+rIna5cqfJfYiOmbSnMa0/MPdbmXtY04MKNRBE0OC1kwMAqRvnK1+b
 mTo9TyYPBRu9tWDNlASYwwRV1QEVbh3q1SOyKO5Fz1tadCYAB71iyS7Sx11IrpRjNSb0nj
 lY3VDIDfb1pCIFKjhGUA8qM/pQBRlPOY08xiDu1FEduSlfW1ETojNREqI/OjTw==
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>, <song@kernel.org>
Message-Id: <9748ccf8-7d4f-495f-8083-eb640008f073@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.183]) by smtp.feishu.cn with ESMTPS; Tue, 28 Apr 2026 16:25:11 +0800
References: <20260425085843.3725-1-abd.masalkhi@gmail.com>
Content-Transfer-Encoding: quoted-printable
Reply-To: yukuai@fnnas.com
Subject: Re: [PATCH] md: skip redundant raid_disks update when value is unchanged
Date: Tue, 28 Apr 2026 16:25:09 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird
X-Lms-Return-Path: <lba+269f06ee8+4caf63+vger.kernel.org+yukuai@fnnas.com>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<yukuai@fnnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>
In-Reply-To: <20260425085843.3725-1-abd.masalkhi@gmail.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Content-Language: en-US

Hi,

=E5=9C=A8 2026/4/25 16:58, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
> Calling update_raid_disks() with the same value as the current one
> can trigger unnecessary work. For example, RAID1 will reallocate
> resources such as the mempool for r1bio.
>
> Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
> ---
> It returns -EINVAL for the same value. If silent success is preferred
> instead, please let me know so I adjust its behavior.
> ---
>   drivers/md/md.c | 9 ++++++---
>   1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 0e55639211f2..cb66c4ebbafa 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -4409,9 +4409,12 @@ raid_disks_store(struct mddev *mddev, const char *=
buf, size_t len)
>   	err =3D mddev_suspend_and_lock(mddev);
>   	if (err)
>   		return err;
> -	if (mddev->pers)
> -		err =3D update_raid_disks(mddev, n);
> -	else if (mddev->reshape_position !=3D MaxSector) {
> +	if (mddev->pers) {
> +		if (n !=3D mddev->raid_disks)
> +			err =3D update_raid_disks(mddev, n);
> +		else
> +			err =3D -EINVAL;

Changing return value in this case is not expected, especially from
success to failure.

> +	} else if (mddev->reshape_position !=3D MaxSector) {
>   		struct md_rdev *rdev;
>   		int olddisks =3D mddev->raid_disks - mddev->delta_disks;
>  =20

--=20
Thansk,
Kuai
