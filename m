Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795839081;
	b=IFcN3WLtT6EY38yn6Rjm1MVHT+ZQMC70XF5aLb93iV4Hhr/fu+Y16a0ECOIAkW/4aDfn
	 TpT3Z186FLzL0ui4XF8Vu5Ukmhg4EGTZggIiRrQIybZaA/at7d0u4jSETltzrU2m46HLH
	 Kg33j0eA91lApAXpZVgU9svHX1X2beWIbYwmgPRCS8qjqlnLcYQFGgleSJIniiJXeoyeB
	 w6X2TvVykWSd+3UPNfVsLcwlO9j7C7RlO8klGRZqOwcEMds8EZvp2AHMATWmfje4M/8FI
	 9DjlHC6fmmbuGpjPQAIALund4lgFpV59sVQDBYhzmqIUk7uK7bPlFN1Q0Ro9VzZl6JA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795839081;
	h=DMARC-Filter:DKIM-Signature:From:Date:Mime-Version:X-Original-From:
	 Content-Type:To:Cc:In-Reply-To:References:X-Lms-Return-Path:
	 Content-Transfer-Encoding:Subject:User-Agent:Content-Language:
	 Message-Id:Received;
	bh=ZEqs40Rf/Imt0CafY/o57h7J+a+Us7++1SuP9TFYybo=;
	b=38K/gIr5+BvYWrr4dDtLu90tieI67FPJsiIZ9pq5JxXAjhJtpBqE1tOZSGVl1Ckcmdiy
	 EbeKMJRTkl5zU2xDn7FZnSf0xPpTpFsPhI2FBFwCa8VB1gACJwb3A1Y+BEWzapBuphrba
	 2ARS2CULLI/Chf0rBALf9l0Hkj0pG3g7jMBPzwUbkMJff7/dYVtRNueCKr+GGM9WS+RVT
	 /TOMevQm6j+mGZq+9CbQvAeKmr34ZEcZbN+AjN4I0/kz2YLs8pW+0OmvNqYIYQdZtEnU/
	 z2xsDzF013E9C4O1/OUodR4POp+yejRdOgOd0kn77Mal1E8o0p82ir6SENEusrl819w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=VQAuVd3i;
	arc=none smtp.remote-ip=209.127.231.41
Received: from va-2-41.ptr.blmpb.com (va-2-41.ptr.blmpb.com [209.127.231.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A6A606A31C
	for <linux-raid@vger.kernel.org>; Sat, 28 Nov 2026 04:11:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 67A6A606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=VQAuVd3i
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1795839076;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=ZEqs40Rf/Imt0CafY/o57h7J+a+Us7++1SuP9TFYybo=;
 b=VQAuVd3iNiXH9lNE3SXnIH/oCWDpWrqalpBdQBn5+Ma6sZ2eufylgJ8mT6Ia+1go9Jpwa2
 Yo6grt9NAV3IhVRNseUSX+76Crts2TPQ77OhO7Ce5BdyWs04ICCLCFjmCv8JX5pfmBqH5Z
 ySBeJh7BW3SslkivOGMRu8wO9KBfzzeQXnhc9hEJri9DtJn4IO4cda9+OWu0darHUtMB0N
 1EW5abLE65BRVtMSAFXYsiv/XNkZtHcTvaw7K2z9dYafPmZZAMMXLlkKer/TO40LG7lI2f
 8pzNNeuqCeRSNb2xNjIzEjrnSS/BSxGfq/pjolmlhAn6Iu788jVsTiiXPYt+lw==
From: "Chen Cheng" <chencheng@fygo.io>
Date: Sat, 28 Nov 2026 12:11:11 +0800
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
Content-Type: text/plain; charset=UTF-8
To: "Song Liu" <song@kernel.org>, "Yu Kuai" <yukuai@fygo.io>
Cc: "Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <nixiao@fygo.io>, 
	<linux-raid@vger.kernel.org>
In-Reply-To: <20261128040527.3087280-1-chencheng@fygo.io>
References: <20261128040527.3087280-1-chencheng@fygo.io>
X-Lms-Return-Path: <lba+26b0a5463+f0d4e6+vger.kernel.org+chencheng@fygo.io>
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] md: identify array and device in metadata write errors
User-Agent: Mozilla Thunderbird
Content-Language: en-US
Message-Id: <90cdaf01-289f-4d95-ab8f-55fbb5c93155@fygo.io>
Received: from [198.18.0.1] ([183.34.192.120]) by smtp.larksuite.com with ESMTPS; Sat, 28 Nov 2026 04:11:14 +0000

Ignore this one please, a apologize for noise because misuse my 
deprecated e-mail address, thanks.

On 2026/11/28 12:05, Chen Cheng wrote:
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
