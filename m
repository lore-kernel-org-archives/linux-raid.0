Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795233538;
	b=xVrtm3Ry2TxCftS5n8UAGoU+ejG4DOREmcmcCe00mCKE9M88HNjG9tL+BsQw0IuxMFGc
	 qIz30VUYmPFh7rn6I7RuTsQSS3TzB/U2hgSG/Rm1ArPDbeHEcCb3HXha1I7q3qk3FWuHU
	 yO6UapxHv0znsGVXbiVXMuEuDLNi74+Ycc17Ou+mCnnqFL/k8T1fr/K8s65u6SUdxqvLm
	 SZig0VeGaP7D8mG5L9eH47m/KMa68XJAHGJsiOPptGE/vwva8PiBudWZE2k4oAK6PT1E6
	 KcYrntoYwiDFcBvupR2ZZ0pJalnNxVeWn8FBz4wZnM90PefRpPHMNI3yUSJi5qpbRSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795233538;
	h=DMARC-Filter:DKIM-Signature:User-Agent:X-Lms-Return-Path:
	 Content-Transfer-Encoding:Content-Type:To:Cc:From:Message-Id:Reply-To:
	 Mime-Version:Received:Subject:Date:In-Reply-To:X-Original-From:
	 References;
	bh=yofjDEr5Dkjx7MQ31wnuFXB7HN/7rlhAChlwZ6N1djs=;
	b=uU65emqwvxkdbIh7XxwxZfCwLEgDOzarpzT3VRxedkuR4BHObfbvJprHOrxCkEJdGNkm
	 JrvX71GjvyvdwJkq17u0zjQHMcXJSoO0Wy5oIdacNFWKdB8AbkWNeGo2azNFPJGp/OXAO
	 OkOnyGK+S9xzM0nmaBvX7cOc71bDjWke7rXcEgsrA/moQl2IO2e4VeKUZtg2hQjVkJWro
	 EKhMrN1iYpn8rReFBYdO0x6Mk8CTMFtTJClB7iUVpS94U2TYkovCSSLxSHfoxyfD9ar/f
	 +vB5KZYZ+ptQuZx7cQd3Vof/60yO+g1jitSkbPEF/2IWKeMSNjd5YWo51ENteNGEMwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=mv60N1Et;
	arc=none smtp.remote-ip=209.127.231.41
Received: from va-2-41.ptr.blmpb.com (va-2-41.ptr.blmpb.com [209.127.231.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0E2606A6A4
	for <linux-raid@vger.kernel.org>; Sat, 21 Nov 2026 03:58:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0A0E2606A6A4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=mv60N1Et
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1795233531;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=yofjDEr5Dkjx7MQ31wnuFXB7HN/7rlhAChlwZ6N1djs=;
 b=mv60N1Etgqs/cgZtT8zLiR2Mg0btZc/tXIsW5oSRnndppGHGU/E5twckMyiMrH1OB3BDgz
 5CSDp4nmMStajGLeaHrXSXMv23+cUudQOYU/HqD02IGrQrN8ql7dmkLbSCE/Z3tbkmTnW8
 uriEyqkf74OWYZbEns3H9fm0l3mPeGkWz9YGf+gbm07ULEa/oVFbLiAKYDICJfVHzgCXCb
 zfhVbnfdMylZ97OTL/d7BfrkRjlnPoIM9cJKzTbvVn2XiTa2IDQ7rgJoiKt4Czu5ycOhLI
 /rRJUL6piOSJ0cbg/uH05HNR6jbV3q01MNR0rMD1NFoWXWo1UDLILYx/LfWOQw==
User-Agent: Mozilla Thunderbird
X-Lms-Return-Path: <lba+26b0116fb+9aaf18+vger.kernel.org+yukuai@fygo.io>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
To: <shao.mingyin@zte.com.cn>, <song@kernel.org>, 
	<linux-raid@vger.kernel.org>, "yu kuai" <yukuai@fygo.io>
Cc: <magiclinan@didiglobal.com>, <xiao@kernel.org>, 
	<linux-kernel@vger.kernel.org>
From: "yu kuai" <yukuai@fygo.io>
Message-Id: <8fd7fbd6-8948-4e6c-84a2-2dfc378f18cc@fygo.io>
Reply-To: yukuai@fygo.io
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Received: from [192.168.1.104] ([39.182.0.159]) by smtp.larksuite.com with ESMTPS; Sat, 21 Nov 2026 03:58:50 +0000
Subject: Re: [PATCH] md/raid1: drop the redundant sysfs_unlink_rdev()
Date: Sat, 21 Nov 2026 11:58:46 +0800
In-Reply-To: <20261101200958563ZkI79UKy510arbmzZJPzd@zte.com.cn>
X-Original-From: yu kuai <yukuai@fygo.io>
References: <20261101200958563ZkI79UKy510arbmzZJPzd@zte.com.cn>

Hi,

=E5=9C=A8 2026/11/1 20:09, shao.mingyin@zte.com.cn =E5=86=99=E9=81=93:
> raid1_reshape() unlinks the old "rd{d}" link, assigns the new
> raid_disk, then unlinks again.  The second call targets "rd{d2}", a slot
> that has no sysfs link yet, so it is a no-op; sysfs_link_rdev() below
> creates it.
>
> Signed-off-by: Shao Mingyin<shao.mingyin@zte.com.cn>
Applied, btw, patch format is a bit strange.

--=20
Thanks,
Kuai
