Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793672630;
	b=iM0jjN1vWe0z+ZF3u8h8+EWzlNAguERa213FLvY42sFeeNiu89zikm3bKxMyCv1pL9nB
	 hQzdy0iVO2R5hOd4PsRlKj6PQmVbh5l/Q+XAR6ibcGVfoN3dcf5D9/pvH0RsjDNxM5AUi
	 HVKA8bHI1VGr1pmwSIf7bE+AOLl/7jiw8X5rUR0KTBVnktI9KNUISwuvu9iGPSgT05WOH
	 RsWnmtqV3ovtbD4MLeu6pMfuygbhjB6uJNAezmdu8hUU5eoo58dPHH/e6C27noOEir7cj
	 ur+ZIASoJ0mEeJlEsNKHC6lANEKEjPbMUWKquhHkY8QKssPkwbr4zrAMcE46w3uJQFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793672630;
	h=DMARC-Filter:DKIM-Signature:Mime-Version:Content-Transfer-Encoding:
	 Content-Type:Subject:From:References:Cc:To:In-Reply-To:
	 X-Original-From:X-Lms-Return-Path:User-Agent:Reply-To:Message-Id:
	 Received:Date;
	bh=oxQllBAFT/GD689LugUGzY1mG/UNAwQ+Yi2gGE1tTSA=;
	b=I0fm20r09gCD2lhTi5D0XW9apgstIJE8wFBrxZQAoaptHRclqF9wmZ59HXFa3rEZxRpj
	 tu4myhriweHegVaemDIn7/SWGdQBBeSvAW/Jrp8ocgfnJE4Y8TrvLdynRaCnweMrlwvBm
	 WUvOzJn/H1fItAtcUxm+hFELdEhYriVBrTd3TGkPKdOjEZh2VrrR+j0dQDxzlyaw0LPNb
	 cx35nrvs53vhCcEsvbhH/PSxZXfOh+SZ/5EW8DM8ka56TxI3lrp4Nv+cURcHFen0GWfen
	 hwgEq4areqorO2KqM/Qx5I2Z/UzaW+/EmUdzPsy+/Uu65fmt31S42vx77OgkuxkFNaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=NnIXjQCH;
	arc=none smtp.remote-ip=209.127.231.20
Received: from va-2-20.ptr.blmpb.com (va-2-20.ptr.blmpb.com [209.127.231.20])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129F7606A327
	for <linux-raid@vger.kernel.org>; Tue,  3 Nov 2026 02:23:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 129F7606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=NnIXjQCH
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1793672624;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=oxQllBAFT/GD689LugUGzY1mG/UNAwQ+Yi2gGE1tTSA=;
 b=NnIXjQCHVQlC2eaQbNsvVXVPUIt3jYmfUYkdts2m5umi2Z3PgbUH7l60tM6nJZGCyw+2gy
 U9pu0YStIiO3nQjBiZ2jmiQnl4FVrNw0hlOVX0dSDgj6s1FXoHU/TCAPwMKkUm8nQ6sw5C
 /rr11YcjhueN0FyrNFjQaVPAx0BEt1vANOBYMnFrONJjMX95Ko3vVeUkv/WZnUu6b44DDP
 Pus3evB/r0ZqOExBV7W95WZrloKIaVdaSBPJsCf2O9VRf2Q9PX3uBr+Ja/UJ81Xsl6wAg0
 kcldmxByH2nOFo1wPHeM6CbpBsD22bpjy90oWWbn53myZjz1mPau8iWwDjaXrA==
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Subject: Re: [PATCH] md: Fix an unlock in an error path of lbs_store()
From: "yu kuai" <yukuai@fygo.io>
References: <9dd41992e8b2d4bd63f74a245d34fa7850529bed.1793044632.git.bvanassche@acm.org>
Cc: "Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
To: "Bart Van Assche" <bvanassche@acm.org>, "Song Liu" <song@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
In-Reply-To: <9dd41992e8b2d4bd63f74a245d34fa7850529bed.1793044632.git.bvanassche@acm.org>
X-Original-From: yu kuai <yukuai@fygo.io>
X-Lms-Return-Path: <lba+26ae945af+c2b3fc+vger.kernel.org+yukuai@fygo.io>
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@fygo.io
Message-Id: <cfc6e703-70cc-4f63-9fb1-875cb6cc4b1d@fygo.io>
Received: from [192.168.1.104] ([39.182.0.25]) by smtp.larksuite.com with ESMTPS; Tue, 03 Nov 2026 02:23:43 +0000
Date: Tue, 3 Nov 2026 10:23:39 +0800

Hi,

=E5=9C=A8 2026/10/27 3:57, Bart Van Assche =E5=86=99=E9=81=93:
> If mddev_lock() fails, lbs_store() calls mddev_unlock() although the
> reconfig_mutex is not held. Fix this by returning the mddev_lock() error
> code directly. This bug has been detected by the Clang thread-safety
> analyzer.
>
> Fixes: 62ed1b582246 ("md: allow configuring logical block size")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/md/md.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)

This problem is already fixed:

[PATCH] md: fix mddev_unlock() called without holding lock in=20
lbs_store() - Jack Wang <https://lore.kernel.org/all/20260920103705.23191-1=
-jinpu.wang@ionos.com/>

>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index ac03b99f6428..7ce527073be9 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6049,11 +6049,10 @@ lbs_store(struct mddev *mddev, const char *buf, s=
ize_t len)
>  =20
>   	err =3D mddev_lock(mddev);
>   	if (err)
> -		goto unlock;
> +		return err;
>  =20
>   	err =3D mddev_set_logical_block_size(mddev, lbs);
>  =20
> -unlock:
>   	mddev_unlock(mddev);
>   	return err ?: len;
>   }

--=20
Thanks,
Kuai
