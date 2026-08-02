Received: from va-2-49.ptr.blmpb.com (va-2-49.ptr.blmpb.com [209.127.231.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35BE175A81
	for <linux-raid@vger.kernel.org>; Sun,  2 Aug 2026 19:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785698036; cv=none; b=kcZ0UjGKCJNCeueBwT8PdPPOvVVLL/AjtwFK8idga43k/7zZ/dor03yQI5K5W43Gn5qDO85v2pTjHAuFLMslPZREf45OOCa0FBtoN72QHX8iTMXIOTNoePl5e76ak0x+oyX8QaTt4zKxFVSu9+gvQubo1V0YKX7rvKOkNX1O3oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785698036; c=relaxed/simple;
	bh=SBs5C8vhbITQS1mgBjViKBIJ8d7Z041kOyVA4wIc7WI=;
	h=Cc:From:Date:References:Subject:Mime-Version:Content-Type:To:
	 Message-Id:In-Reply-To; b=fFQjEsC7uc/4m2u+H0mILzmPEltqpyCbiXPah+sa6c6veDAFdCJTM8NZfbMWK4lbfzBn8R0FogYBn+kOg6ELq+JwwcjFmcQ47SzmJJeFaHtdlbZFXJRkU3rF3uUwUnWMOAZdNrzTg6JplNHDjNsU3OYfdNy6MjMG/HDrDusV7ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=RG4Y8lS/; arc=none smtp.client-ip=209.127.231.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="RG4Y8lS/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785698024;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=SBs5C8vhbITQS1mgBjViKBIJ8d7Z041kOyVA4wIc7WI=;
 b=RG4Y8lS/MzmGAlD3hYJzQGoLv9PbKoo6k6qL8u5H5/l6NsnqKMSiL/Fo9Uz2Hkto5deWsr
 L6Vxl09LIqcOTzHyDYV6lDHTy011waefDR/J6kCyGThZZH38R6tcxcq1vsT3GzEVvu1ROB
 mwjJwrFRgMhcq1hI6+ERRImXmQ0xbhKhFx1OEqdqkK7dtqjZpBrlM4Y7wHNaLBy20VE8XN
 0ZSscn5DhDYDYq+OFkhtOco+I54YinRZu4SA8x/upKxTq0e9BZH1+mdp+BrG20X2NABsap
 YRPAxL/MqHoUilsAfCLSkDSUTwMMPwKiy4dIHAOVJaxIzB7y7P+nWikhSMhj+Q==
Cc: "Song Liu" <song@kernel.org>, "Li Nan" <magiclinan@didiglobal.com>, 
	"Xiao Ni" <xiao@kernel.org>, "Su Yue" <glass.su@suse.com>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From: "yu kuai" <yukuai@fygo.io>
Date: Mon, 3 Aug 2026 03:13:40 +0800
References: <20260801172519.2982121-1-yukuai@kernel.org> <20260802161310.8097-1-mykola@meshstor.io>
Reply-To: yukuai@fygo.io
Subject: Re: [PATCH v4 00/25] md: improve lockless bitmap reshape support
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird
X-Original-From: yu kuai <yukuai@fygo.io>
Received: from [192.168.1.104] ([39.182.0.181]) by smtp.larksuite.com with ESMTPS; Sun, 02 Aug 2026 19:13:43 +0000
To: "Mykola Marzhan" <mykola@meshstor.io>, "yu kuai" <yukuai@fygo.io>
Message-Id: <208b2610-e155-457d-886f-9d12c7bc2874@fygo.io>
In-Reply-To: <20260802161310.8097-1-mykola@meshstor.io>
X-Lms-Return-Path: <lba+26a6f96e8+dd34d3+vger.kernel.org+yukuai@fygo.io>
Content-Transfer-Encoding: quoted-printable

Hi,

=E5=9C=A8 2026/8/3 0:13, Mykola Marzhan =E5=86=99=E9=81=93:
> Hi Kuai,
>
> I ran v4 through the same rig as v2. All 25 patches applied cleanly
> and build individually, the four problems I reported against v2 stay
> fixed, and extra tests aimed at v4's new code (the raid5 boundary
> split, the resize quiesce, the new reshape_lock under PROVE_LOCKING)
> were all clean.
>
> If raid10 tests on this base hit KASAN in free_r10bio(), that is Chen
> Cheng's separate r10bio bug, not this series; with the fix from
> latest md-7.3 the same tests are clean.
>
> Tested-by: Mykola Marzhan <mykola@meshstor.io>

Thanks for the test, while go through sashiko reviews, there are some new i=
ssues
that I checked are real, not big problems, however I'll send a new version.=
 And
if you don't mind, I'll include your tested-by tag with v4 patches.

>
> Thanks,
> Mykola

--=20
Thanks,
Kuai
