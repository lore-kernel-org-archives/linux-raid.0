Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793670811;
	b=htjUo+OOM72bzMwlmPabWIGHvkeJpQJMhFVL+a0cDXRMgFamNblKOqdkoxmNLhLjVZgh
	 jlzpRyk7pnPO6xbzhxPPYr7BmRAw4J2mG8nsg30SBVXK9OC7rjNQulV7HHW6mPLHWcU0Q
	 SvqfMFZjrQEt3hL/wwpbE20ywNgQJ52afYbh5Vy6hF2gAzDq3rwubO+fPLEoI2Ynx6pBz
	 nXdgbB6HCePprTJd5JhSmrRufX2hasdCTLYvR6n6mN0jquRmV/glV5XSqmmPvcZ36c1S8
	 FYlsVcRVd4Mhy+pqfpnL3TtbqVaiTjuxtswGU7KwdUM45c1jXKdjqrlLYj2SbPgO5ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793670811;
	h=DMARC-Filter:DKIM-Signature:Date:Mime-Version:Received:
	 X-Original-From:From:To:Subject:Content-Type:
	 Content-Transfer-Encoding:References:Reply-To:X-Lms-Return-Path:Cc:
	 In-Reply-To:User-Agent:Message-Id;
	bh=0mcZiMssm+nV8vlLOA/UxbEB8G9QgJwIn4A5a4GlkeU=;
	b=bdnnRnEN7q91TyUtIbwoamg3D3dNp77Siz/FRq0A1lsZrLmoj2QEb2hcVteKWSPe9dlb
	 +V/kvz3XLtb3rCDJu0KtWUysmszVomvaCBv4XSLxg0gTB2/GyzK/0Av5ob0YjaeYVcHlB
	 HMPcRoBh1+d364AavsaPoai1vn855eSmltXKvPORKFD+5qv2UjzJXFFZTfjss85ecayK5
	 52QaRNTeMyHOWzmDcup3i2lT00CE8mBXthv8vKKiAO9Lzna2z7BUGNLA4/K6oFfEe4fD4
	 r/bWLM96tILioQoogP5uMm4CYjt6SQJ+++31wcNIbgVrqdgxBi6Mmnmwe7PDG0VCyGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=VyEH4RYS;
	arc=none smtp.remote-ip=209.127.231.20
Received: from va-2-20.ptr.blmpb.com (va-2-20.ptr.blmpb.com [209.127.231.20])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1029606D812
	for <linux-raid@vger.kernel.org>; Tue,  3 Nov 2026 01:53:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A1029606D812
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=VyEH4RYS
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1793670799;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=0mcZiMssm+nV8vlLOA/UxbEB8G9QgJwIn4A5a4GlkeU=;
 b=VyEH4RYS9nspR/+gsXphjq4UZ0H/99nFOeY7twoNKraTD/dLcqPVRiZ7ck1tkstcQ5hrTw
 LiXJUrGIOx8oE0JPswtPCYzNUPxTmNgYwjWCxnAsxiZcIBJRezZ/qTrdlKGUT6RzVYPNiE
 Arxxlb2LpY1P6gCxQ1TBoU4ylNxYF2pTdYH3AD74LnCGICS/k1YF5t65AqKd1Le2e+wuYk
 8UZzdcHOEgwvgiJzVBmz7BcJoxS81gg5K+FDORLvVTT0ezB/tAqQ0f3Y9JGH7AhhhcDujs
 QbDiL+BXli2Nvnvuv2a/Ll6T+HR0UBqudi6jTqYCW5TjkSzgFRzDSpmJA8vRNQ==
Date: Tue, 3 Nov 2026 09:53:14 +0800
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Received: from [192.168.1.104] ([39.182.0.25]) by smtp.larksuite.com with ESMTPS; Tue, 03 Nov 2026 01:53:17 +0000
X-Original-From: yu kuai <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
To: "zhanghao" <zh_exit@163.com>, <song@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH v2] md/raid5: fix inverted condition in rdev_set_badblocks call
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <20261017074343.59513-1-zh_exit@163.com> <20261017083737.61793-1-zh_exit@163.com>
Reply-To: yukuai@fygo.io
X-Lms-Return-Path: <lba+26ae93e8e+3f064a+vger.kernel.org+yukuai@fygo.io>
Cc: <magiclinan@didiglobal.com>, <xiao@kernel.org>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<stable@vger.kernel.org>
In-Reply-To: <20261017083737.61793-1-zh_exit@163.com>
User-Agent: Mozilla Thunderbird
Message-Id: <d862e16f-a444-4572-b0af-38b3768ed978@fygo.io>

=E5=9C=A8 2026/10/17 16:37, zhanghao =E5=86=99=E9=81=93:

> Commit fd4d44c14ff6 ("md: mark rdev Faulty when badblocks setting fails")
> attempted to unify badblock handling but introduced a logic inversion in
> raid5_end_read_request().
>
> The original check was:
>
>      if (!(set_bad && In_sync && rdev_set_badblocks(...)))
>              md_error(...);
>
> which records badblocks when `set_bad && In_sync`, and calls md_error()
> either when recording fails or when the rdev is not In_sync. The new
> condition `if (!(set_bad && In_sync))` skips rdev_set_badblocks() exactly
> during recovery/reshape (In_sync is set), so failed badblock updates no
> longer trigger md_error() and the rdev is not marked Faulty. This allows
> reconstruction to continue on a disk with a saturated badblock table,
> potentially propagating corrupted data to the replacement disk.
>
> Restore the intended behavior by recording badblocks when `set_bad &&
> In_sync`, and calling md_error() in the else branch so that non-In_sync
> rdevs, replacement devices, and the too-many-read-errors path are still
> marked Faulty.
>
> Fixes: fd4d44c14ff6 ("md: mark rdev Faulty when badblocks setting fails")
> Cc:stable@vger.kernel.org
> Signed-off-by: zhanghao<zh_exit@163.com>
> ---
> v2:
> - Add the else branch calling md_error() for the !(set_bad && In_sync)
>    cases, as pointed out by Sashiko: replacement device read errors,
>    the too-many-read-errors path, and non-In_sync uncorrectable reads
>    would otherwise no longer mark the rdev Faulty.
>
>   drivers/md/raid5.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
Applied

--=20
Thanks,
Kuai
