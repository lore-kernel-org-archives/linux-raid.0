Received: from sg-3-45.ptr.tlmpb.com (sg-3-45.ptr.tlmpb.com [101.45.255.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469A43B4E8F
	for <linux-raid@vger.kernel.org>; Fri,  7 Aug 2026 08:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.45.255.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786091849; cv=none; b=J04/Ww0N2ppmpjMT4clfipVwcTBWD4PCuRRbBJvCe5bOicovLOhKCfXyZXGq5roNgHP9gPRWR83RP0NqhEsDMzW34nLhd4J3KaVMwrVYgEan3IepofyWVQyGfq59qPnXFhaoqWM/Ml/FPO0BWEB83BG+YSGwp6oxZR7kCgEK3DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786091849; c=relaxed/simple;
	bh=26TtM+JmJF0pUOu9Lncxx+BXrwH622VnFC8j1tcgN9I=;
	h=Cc:From:Date:Message-Id:Content-Type:Subject:In-Reply-To:To:
	 Mime-Version:References; b=RE10PX7fIzwm6ZISqgWnLZBSSUkKQ2v1z8nXtYaaRqMXhbJvv4cGskhhn9/TRP9Tz+bG1G+raH40+bTCDK96QvZ90iZvmXvZkBCLLT9uOAK06Wj0gMjcs05tamEVy9PAu1qCKZdkljrn1kvnGXIk0AxYBaZfp6Cto/SpVVJpS+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=W3n81REc; arc=none smtp.client-ip=101.45.255.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="W3n81REc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1786091749;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=68tcV8wVZNnLB2uZjoqW/Rt09IKxNsMQew5ndfyZTdw=;
 b=W3n81REcEUqTuRjzAPj6RGfxQwRPjqnXUtagY0iXRd9cMovl8N7F6Z3KP6AJvqO53Y4cfK
 FCcgSsFbe4DHPaO+VlDagR4srl8pw1phTefUUt+RmQPtmkv5aSZ/7H1m/argoRxGSC2A3u
 X9vI3OMNlfuZMlAFl5/UU5kjlkG4CoC0jyVIa5Xpx3xSRTtji0wnnLJO+3C14pLZQPtjZC
 wEQA4NSVpF4E0zIHUhfJmuKH0xyTnqI5RXry/3NLnEc0M0lKIinCh3kYluJncJjU4XiQlD
 CbtXAbS62o0yQKtGI2hd0o6HSUnZXS5XLM8v+zNscXwngXvVy2zG/pe/MG8nNw==
Reply-To: yukuai@fygo.io
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From: "yu kuai" <yukuai@fygo.io>
Date: Fri, 7 Aug 2026 16:35:46 +0800
Message-Id: <0dfc39a8-6ed6-49c9-acfd-6dc722f008e1@fygo.io>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [PATCH 1/1] md: skip discard on unsupported member devices
In-Reply-To: <20260731074729.1885314-1-wale.zhang.ftd@gmail.com>
Content-Transfer-Encoding: quoted-printable
Received: from [192.168.1.104] ([39.182.0.170]) by smtp.larksuite.com with ESMTPS; Fri, 07 Aug 2026 08:35:48 +0000
To: "Wale Zhang" <wale.zhang.ftd@gmail.com>, <song@kernel.org>, 
	<magiclinan@didiglobal.com>, <xiao@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: yu kuai <yukuai@fygo.io>
References: <20260731074729.1885314-1-wale.zhang.ftd@gmail.com>
User-Agent: Mozilla Thunderbird
X-Lms-Return-Path: <lba+26a7598e5+dde7d7+vger.kernel.org+yukuai@fygo.io>

=E5=9C=A8 2026/7/31 15:47, Wale Zhang =E5=86=99=E9=81=93:

> blk_stack_limits() uses min_not_zero() when stacking discard limits.
> Thus an array containing devices with different discard capabilities can
> expose discard support as long as at least one member has a non-zero
> discard limit.
>
> raid0 and raid10 use md_submit_discard_bio() to submit a discard bio to
> each member covered by the request.  The helper currently also submits
> bios to members whose max_discard_sectors is zero.  The block layer
> completes these bios with BLK_STS_NOTSUPP, and bio chaining propagates
> that status to the original discard request.
>
> Discard is optional, so skip members which do not support it.  Members th=
at
> do support discard continue to receive their portion of the request.
>
> Signed-off-by: Wale Zhang<wale.zhang.ftd@gmail.com>
> ---
>   drivers/md/md.c | 4 ++++
>   1 file changed, 4 insertions(+)
Applied to md-7.3

--=20
Thanks,
Kuai
