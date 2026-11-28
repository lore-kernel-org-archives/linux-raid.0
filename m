Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795839238;
	b=Z5+3JTyZsOt/FqWd/zXgfFKU3FJPBwrfzsRvEu7/CBgYy7+eD2kqDjFwgx+Sr77Wbezc
	 9jm2MTbfROB+zg7FZ0tWOlYFa6moYQK6METANEKu8CFJbPksnYwwSOOgvi86lBydw3TO/
	 KXgbyltB9NXOZybCrh7SJNnmKbYYSCSDffbrKKJJeqJ0XUf3x60+eTrAFilPei31Q3Eo4
	 9dJdC+samg11bf0Y6NLBw0EpxhpflksclWlp68YGZxR/LSSK5QtfOlMwwdCgB+TP4G3Mo
	 wvLCr68dKC5Cyu4PJeNJ8XT5WxX+Gpixl8RQqQG04kK8cl7Yvy7u8/iRFt/Wn+Mkw+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795839238;
	h=DMARC-Filter:DKIM-Signature:Received:References:User-Agent:To:Cc:
	 From:Subject:Mime-Version:X-Original-From:Content-Transfer-Encoding:
	 Content-Language:Date:Message-Id:Content-Type:In-Reply-To:
	 X-Lms-Return-Path;
	bh=J8nqDA43uuhMF+9YM//+c82Ss1ff12xJ6v6ttGiKSpA=;
	b=bAYLgRoRsjghYllj+a5H0qr3bSyi2FZQlb23GiBYU16smiY+00OSNd7OZU96XFmo/c32
	 xvI4k+2IX7z0XAGuw1Hx2y4pVnGbwZUIKqZTk1mQ5C8Xs0yasDK0Ofa2ixGpRenKDItDZ
	 FZIrOKnjH5F97Itep7tLiHXt+MzOy7HGDxhLiA6LYVyaldwBYDWF6bEUFc4bl+DrtWm5U
	 rZF47xF6AINR4nPIifGfijkj/7dKgzwfg1AvD5nSFlTSwLDLnWrZUgfrH0PqceJsKu8C6
	 Ly2zFZ1NVudPXDi0ITABUe8+IPQdEMs9BTCmzE2LvF8pT6F94BZpVIj2Gb0qmSYLXYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=g2iOPYM5;
	arc=none smtp.remote-ip=209.127.231.44
Received: from va-2-44.ptr.blmpb.com (va-2-44.ptr.blmpb.com [209.127.231.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31C4606A31C
	for <linux-raid@vger.kernel.org>; Sat, 28 Nov 2026 04:13:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A31C4606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=g2iOPYM5
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1795839230;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=J8nqDA43uuhMF+9YM//+c82Ss1ff12xJ6v6ttGiKSpA=;
 b=g2iOPYM5qorj+W3o7sSwUaXmDNmVunZId4bPFT5KlkUKZnhsvdfsUPNI26M9ASsMCDb1Wd
 3/6T1Q+MsdnKvJZDrkSwZMN4yrnGbB1SzKJ9RyG3tV3WLCLv6TEn/4EwqJGVOCu0DiuBvw
 JE/uvNh8d/67w3mzod0/W3JokQWKjSEi4wSmADHuJIJ82OC/ecMg1SXVRYwL+PczXsn5np
 1KpBNN+3IRNdY/GeThIGqzzO3x4Gvbbp9+g47M5g0iv+YRLnYHed1Q8STQ1V5hfUuj3i47
 uuwwrFHeuIoh365bjPy1eZgdufjm8+qldCENpIlJkODls4Lfnd4YRyzNjP5h1Q==
Received: from [198.18.0.1] ([183.34.192.120]) by smtp.larksuite.com with ESMTPS; Sat, 28 Nov 2026 04:13:48 +0000
References: <20261128033316.3082583-1-chencheng@fygo.io>
User-Agent: Mozilla Thunderbird
To: "Chen Cheng" <chencheng@fnnas.com>, "Song Liu" <song@kernel.org>, 
	"Yu Kuai" <yukuai@fygo.io>
Cc: "Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <nixiao@fygo.io>, 
	<linux-raid@vger.kernel.org>
From: "Chen Cheng" <chencheng@fygo.io>
Subject: Re: [PATCH] md: identify array and device in metadata write errors
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Original-From: Chen Cheng <chencheng@fygo.io>
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Date: Sat, 28 Nov 2026 12:13:46 +0800
Message-Id: <6061e6a7-1ce3-4e0a-86f1-969666315011@fygo.io>
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20261128033316.3082583-1-chencheng@fygo.io>
X-Lms-Return-Path: <lba+26b0a54fd+6b039e+vger.kernel.org+chencheng@fygo.io>

Ignore this one please, a apologize for noise because misuse my 
deprecated e-mail address, thanks.

On 2026/11/28 11:33, Chen Cheng wrote:
> The error log in super_written() does not show which array or device
> failed. Add both names to help locate the failed write.
> 
> Signed-off-by: Chen Cheng <chencheng@fygo.io>
> ---
>   drivers/md/md.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 03e35386a802..5c4c721dbba4 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1107,11 +1107,12 @@ static void super_written(struct bio *bio)
>   {
>   	struct md_rdev *rdev = bio->bi_private;
>   	struct mddev *mddev = rdev->mddev;
>   
>   	if (bio->bi_status) {
> -		pr_err("md: %s gets error=%d\n", __func__,
> +		pr_err("md: %s: %pg: %s gets error=%d\n",
> +		       mdname(mddev), bio->bi_bdev, __func__,
>   		       blk_status_to_errno(bio->bi_status));
>   		md_error(mddev, rdev);
>   		if (!test_bit(Faulty, &rdev->flags)
>   		    && (bio->bi_opf & MD_FAILFAST)) {
>   			set_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags);
