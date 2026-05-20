Received: from va-2-29.ptr.blmpb.com (va-2-29.ptr.blmpb.com [209.127.231.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB401372EF0
	for <linux-raid@vger.kernel.org>; Wed, 20 May 2026 12:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779281236; cv=none; b=oDvLu6fTfC9LIZtoTJv6VUOkUlX+lPtuUNvM9nyWcYzUg6fRUAY0Fxxnbm2HpDUYBzKiCl7sNr8TUpjEphgwdc5ys+IxbGjLlFVCBS/1rOQwjtscvF8I1/2a3KeWhttY/CQ2u1ZuWBfBIAJue9kxYfhNBxDLoB8MBf+QoY1RuCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779281236; c=relaxed/simple;
	bh=1Q6IFZCNR5HZcX0LYbMAsMTOEXcQog04CfH14g81knc=;
	h=Mime-Version:References:In-Reply-To:Content-Type:Cc:Subject:Date:
	 Message-Id:From:To; b=kMV8IVMiI7fxynz3NIrVOV7dBjEeuSrYvi6XVqBQ3OJp9rKXQbOp1YGKNTBoHJqqJNWEf++f0hsUWjtUTDGrPgN80NSqSwJrOerzZ+aTfXP1QEC7bmuklKioc/qxkOe/Hlg8lInYxYV3eBRJ1Di0memI3ycL6CtJPCnRMrFbauU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=n1Odpzw/; arc=none smtp.client-ip=209.127.231.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="n1Odpzw/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1779281109;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=5w8vA58aHUc08+syn3h3Lfwn2qma+OfW3fMCp1BBF4g=;
 b=n1Odpzw/KCyaeOo1KAQ8Ua+o3oFOLPKVu3Qd1OCL9fu+9gXsZNagr//FWR76vWAq+3sL0+
 g9R0CAN5pIgm/78KqpDn2g1ImFoZvNlTKC7CH+05ArJ32ExPyZxji+vCw7ATa1evi0pKNE
 GJiqSKSpWKGCOsGfL565tW4L/INcpES9JkWctA+TenucgZkeeJ2j10ehx8gXAs3rcjHlz4
 juydEa52bVH4A7HoFtvZ51W3e+wmTvpAgT+XXmgQwegvjExyR0XN3bGYFkRuFUyBX9FwFo
 bFWXQ2zj65QNEgVPJ9sEKz7yN437Sy4sZqx3U5toCFdz3L57kkQ8RT6cVN8R2A==
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260428130524.448063-1-abd.masalkhi@gmail.com>
In-Reply-To: <20260428130524.448063-1-abd.masalkhi@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Reply-To: yukuai@fygo.io
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] md: skip redundant raid_disks update when value is unchanged
Date: Wed, 20 May 2026 20:45:04 +0800
Message-Id: <6657dd7b-36b4-4709-adf6-24a6c1317d4e@fygo.io>
From: "Yu Kuai" <yukuai@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.188]) by smtp.feishu.cn with ESMTPS; Wed, 20 May 2026 20:45:06 +0800
User-Agent: Mozilla Thunderbird
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>, <song@kernel.org>, 
	<yukuai@fygo.io>
Content-Language: en-US
X-Original-From: Yu Kuai <yukuai@fygo.io>
X-Lms-Return-Path: <lba+26a0dacd3+6ff054+vger.kernel.org+yukuai@fnnas.com>

=E5=9C=A8 2026/4/28 21:05, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:

> Calling update_raid_disks() with the same value as the current one
> can trigger unnecessary work. For example, RAID1 will reallocate
> resources such as the mempool for r1bio.
>
> Signed-off-by: Abd-Alrhman Masalkhi<abd.masalkhi@gmail.com>
> ---
>   drivers/md/md.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
Applied to md-7.2

--=20
Thansk,
Kuai
