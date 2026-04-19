Received: from va-2-35.ptr.blmpb.com (va-2-35.ptr.blmpb.com [209.127.231.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968E034DB54
	for <linux-raid@vger.kernel.org>; Sun, 19 Apr 2026 04:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776574303; cv=none; b=B1EWdx0VKqxPAkIULfBzOn8CchsOlPqzI233W8Ue1+7gJ1HgnqWf/tOqKEmQRJSZde/vKO6Vd3E30+mzxBLW56mFTrRwaTCQpCCxzmcQwNgD8CjW8iAdZERjVTW+vo8AImlPfonao24u4l8TqgB/hnYuk38/0u76Fqjl2bOm/zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776574303; c=relaxed/simple;
	bh=pXzGApBgzv6w4Ww8dQLuSwCSpQHACYX8pD1hf8LMDq0=;
	h=To:Cc:Date:Content-Type:Subject:Message-Id:Mime-Version:
	 References:From:In-Reply-To; b=tjjnypLEDQxRnYjK6hFEDahHmKvrc6FLLRgOzCv4yKUfJv8hN/2Usj3SLSg3saTZaqePIR8flueoaRRMUhsRTpbC9/6mPB9iGRch6Ji7wMzZaDPojWzcjX6cBPxi9D3ES7vTzxWkld68oSEDIun8B0xK8QMoVvbaNaODWB8wAHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=G6w7H6Nk; arc=none smtp.client-ip=209.127.231.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="G6w7H6Nk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1776574294;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Nx40uM5Q6PbNSzGYciRKYnEMPYrCpf2Q2scrCr2ljNY=;
 b=G6w7H6Nkehb+2AvsVOfj7XmqsHW+gOS5FfPUMbjdeu6DwEQIg+oWR3Ltt/KmoyDiz61TYN
 9kS69Jo/D0r6iyaGe1HwoAIIV6126X9o8hzFT3sQn6T3nEaBmk86GW0BM8R+Kz9Jypo37/
 ySJP5g6wCA91L2un7tkFKRWzdDThvSgGhSTM+4f3f8z7QAsfy9/6wa09I2f+Gnio/dnSIh
 fxRcMQTNh2iShvQB37gIK8fGllr4NBUv/OtH3s17DynUVk9xEXfz0HIaAlO9E3iVMtK/SK
 6TxsZLkmsePqF85DTqw0BgqacfGDTFoJxr0RINITTdgKYZY4OBosy4oIbuiDNw==
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>, <song@kernel.org>, 
	<linan666@huaweicloud.com>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<yukuai@fnnas.com>
Date: Sun, 19 Apr 2026 12:51:29 +0800
Content-Type: text/plain; charset=UTF-8
Received: from [192.168.1.104] ([39.182.0.144]) by smtp.feishu.cn with ESMTPS; Sun, 19 Apr 2026 12:51:31 +0800
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Reply-To: yukuai@fnnas.com
Subject: Re: [PATCH v2] md: use md_free_cloned_bio() in md_end_clone_io()
Message-Id: <36f8b219-140d-4d66-85f9-2522215f5a2b@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260415081941.352389-1-abd.masalkhi@gmail.com>
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+269e45f54+31608a+vger.kernel.org+yukuai@fnnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>
User-Agent: Mozilla Thunderbird
In-Reply-To: <20260415081941.352389-1-abd.masalkhi@gmail.com>
Content-Language: en-US

Hi,

=E5=9C=A8 2026/4/15 16:19, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
> md_end_clone_io() and md_free_cloned_bio() share identical teardown
> logic. Use md_free_cloned_bio() in md_end_clone_io() for cleanup and
> call bio_endio() afterwards.
>
> Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
> ---
> Changes in v2:
>   - Reuse md_free_cloned_bio() instead of introducing a new helper
>   - Link to v1: https://lore.kernel.org/linux-raid/20260414103813.307601-=
1-abd.masalkhi@gmail.com
> ---
>   drivers/md/md.c | 13 +------------
>   1 file changed, 1 insertion(+), 12 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index ac71640ff3a8..8565566a447b 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9212,20 +9212,9 @@ static void md_end_clone_io(struct bio *bio)
>   {
>   	struct md_io_clone *md_io_clone =3D bio->bi_private;
>   	struct bio *orig_bio =3D md_io_clone->orig_bio;
> -	struct mddev *mddev =3D md_io_clone->mddev;
> -
> -	if (bio_data_dir(orig_bio) =3D=3D WRITE && md_bitmap_enabled(mddev, fal=
se))
> -		md_bitmap_end(mddev, md_io_clone);
> -
> -	if (bio->bi_status && !orig_bio->bi_status)
> -		orig_bio->bi_status =3D bio->bi_status;
> -
> -	if (md_io_clone->start_time)
> -		bio_end_io_acct(orig_bio, md_io_clone->start_time);
>  =20
> -	bio_put(bio);
> +	md_free_cloned_bio(bio);
>   	bio_endio(orig_bio);
> -	percpu_ref_put(&mddev->active_io);
>   }
>  =20
>   static void md_clone_bio(struct mddev *mddev, struct bio **bio)

Same as I replied to v1,
This patch is no longer needed after following patch:
https://lore.kernel.org/r/20260408043548.1695157-1-bmarzins@redhat.com

--=20
Thansk,
Kuai
