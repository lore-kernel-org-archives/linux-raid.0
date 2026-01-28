Received: from sg-1-19.ptr.blmpb.com (sg-1-19.ptr.blmpb.com [118.26.132.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045B3347BA5
	for <linux-raid@vger.kernel.org>; Wed, 28 Jan 2026 09:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769592637; cv=none; b=KU+ozCZaR157wrBJtPGU5KUvTexEWBNDyvWH0wEBsZDhj4FPqqRLB8ruoNAXYpWJg1pKfraWdG418kKK9S7iflK1YfSw+5DKwI9cWm0P/42Hpd0hpSvsm5hloYqJXqqF0WaLbKpCXP+J4kSNRm+yFE2z4SJ1tb+W2s0TboxANEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769592637; c=relaxed/simple;
	bh=oveZMi12F5nbZMa6nofQOOi0wDYUU5sOtXbHt9PrHRY=;
	h=Message-Id:References:In-Reply-To:To:Date:Content-Type:
	 Mime-Version:Cc:Subject:From; b=lIQkZvsV1xiIrOeCVQDlrDAu1NcLjk7d+dUJHtPBtFPQwwdfX4j2s+gt8a4Rn5kEC3TSSEw7OHg4w/Y0vE7laSVA8PfLLyJ2ZzWIYs0QXdeXtUapPDo2gmKFWYlvQ4eEVAvnFSviKuIIVgtFWrOGwLAfavBvznJ1vNxUIFGivmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=JRIb4PNT; arc=none smtp.client-ip=118.26.132.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="JRIb4PNT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1769592623;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=HesK6xr7Rs38Ov5jCtRR0f15/UGeKBFj9qXE+X9F5ZE=;
 b=JRIb4PNT73yOfy120Rqo6TaokB4eYr3npFzv2NAgTmJjQWKmX8r1AYzGwpbw+FgYl8DH5A
 QM7qgkj+wiMGgm93DnBmoc8jfpCVC/KxiyjN9oyGALlhDNSuV2g8PCXHpBozOaVVYGLAAN
 UmJDJn2sM1Bz10jEkm2cGn3LeW1doWFMU4BrKatBCXFX2nCTjmjhzwSqtVCFanwmLfE4dZ
 uamQt23VuxwZAOtzmSXhT9vepplD+aZQ6f6hLuboZK1Otaj8psNPiNeaVFmjEF5bv57Cuv
 QW2NmnbcSr908MPW1gpum0P5OnKiK241e/LOevegtnABYIwG6PHTkrQ3RN0kzA==
Message-Id: <4eba52c0-a416-454b-a072-0965dfed722a@fnnas.com>
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+26979d72d+3cd046+vger.kernel.org+yukuai@fnnas.com>
References: <20260128082430.96788-1-tj.iam.tj@proton.me>
In-Reply-To: <20260128082430.96788-1-tj.iam.tj@proton.me>
To: "Tj" <tj.iam.tj@proton.me>
Date: Wed, 28 Jan 2026 17:30:18 +0800
Content-Language: en-US
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
Reply-To: yukuai@fnnas.com
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Cc: <linux-kernel@vger.kernel.org>, <linux-raid@vger.kernel.org>, 
	<yukuai@fnnas.com>
Subject: Re: md: regression: incorrect warn about updating super block failure
From: "Yu Kuai" <yukuai@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.137]) by smtp.feishu.cn with ESMTPS; Wed, 28 Jan 2026 17:30:20 +0800

Hi,

=E5=9C=A8 2026/1/28 16:25, Tj =E5=86=99=E9=81=93:
> Commit 8c9e376b9d1a222 introduces an error message that is incorrectly re=
ported for LVM raid volumes:
>
> $ journalctl --dmesg --priority err
>   md_update_sb: can't update sb for read-only array mdX
>   md_update_sb: can't update sb for read-only array mdX
>   md_update_sb: can't update sb for read-only array mdX
>   md_update_sb: can't update sb for read-only array mdX
>   md_update_sb: can't update sb for read-only array mdX
>   md_update_sb: can't update sb for read-only array mdX
>   md_update_sb: can't update sb for read-only array mdX
>   md_update_sb: can't update sb for read-only array mdX
>   md_update_sb: can't update sb for read-only array mdX
>   md_update_sb: can't update sb for read-only array mdX
>   md_update_sb: can't update sb for read-only array mdX
>   md_update_sb: can't update sb for read-only array mdX
>   md_update_sb: can't update sb for read-only array mdX
>   md_update_sb: can't update sb for read-only array mdX
>   md_update_sb: can't update sb for read-only array mdX
>   md_update_sb: can't update sb for read-only array mdX
Yeah, we should bypass dmraid, will fix it soon.
>
> $ sudo dmsetup table --target raid
> SUNNY-Documents: 0 20971520 raid raid1 3 0 region_size 4096 2 254:74 254:=
75 254:76 254:77
> SUNNY-Media: 0 171966464 raid raid1 3 0 region_size 4096 2 254:69 254:70 =
254:71 254:72
> SUNNY-NAS: 0 46874624 raid raid1 3 0 region_size 4096 2 254:15 254:16 254=
:17 254:18
> SUNNY-Projects: 0 23068672 raid raid1 3 0 region_size 4096 2 254:20 254:2=
1 254:22 254:23
> SUNNY-SourceCode_wcorig: 0 478150656 raid raid1 3 0 region_size 4096 2 25=
4:26 254:27 254:28 254:29
> SUNNY-WINE: 0 16777216 raid raid1 3 0 region_size 4096 2 254:80 254:81 25=
4:82 254:83
> SUNNY-etc: 0 106496 raid raid1 3 0 region_size 4096 2 254:57 254:58 254:5=
9 254:60
> SUNNY-home_wcorig: 0 301989888 raid raid1 3 0 region_size 4096 2 254:46 2=
54:47 254:48 254:49
> SUNNY-l8r: 0 16777216 raid raid1 3 0 region_size 4096 2 254:37 254:38 254=
:39 254:40
> SUNNY-machines_old: 0 34185216 raid raid1 3 0 region_size 4096 2 254:32 2=
54:33 254:34 254:35
> SUNNY-opt: 0 41943040 raid raid1 3 0 region_size 4096 2 254:64 254:65 254=
:66 254:67
> SUNNY-rootfs: 0 67108864 raid raid1 3 0 region_size 4096 2 254:3 254:4 25=
4:5 254:6
> SUNNY-usr_local: 0 16777216 raid raid1 3 0 region_size 4096 2 254:52 254:=
53 254:54 254:55
> SUNNY-var_wcorig: 0 25165824 raid raid1 3 0 region_size 4096 2 254:9 254:=
10 254:11 254:12
>
>
--=20
Thansk,
Kuai
