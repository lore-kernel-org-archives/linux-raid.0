Received: from va-2-58.ptr.blmpb.com (va-2-58.ptr.blmpb.com [209.127.231.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB0A48124D
	for <linux-raid@vger.kernel.org>; Wed, 23 Sep 2026 11:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790162163; cv=none; b=i2hDhoYoWi5oTob24/xK+wGGJsRDWsqkxar8q3ShAfB8LBJx+8HAVKoIQtqTsUsZP56Q3Pqs8UYEhBrvuAAZb/QWfRwTr+uFAwNjbvSUnyyARBDpleFz3AXoH4LFnQasRwUCtaxeK3CEO/HTrHwO8MSphFD3iaysKuHIdlFd2Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790162163; c=relaxed/simple;
	bh=jitZB8F9F1v+1W/BfCoAkSqOsagliyLwkW9wj0NiVOA=;
	h=References:Cc:From:To:Mime-Version:In-Reply-To:Subject:Message-Id:
	 Date:Content-Type; b=kPubgEsuqQUO1fkwaKdLJ69nXWJ2WwzPvRvn4Wk9wS6IJWOkgHGf3m2bKcQkSGMPcVHFrM/S5KgFPEXCn8WeEqJiEXYIFn+wucwysvmvuUgYMdiDOMGA3CJv24VHKI5bu6fvfssPBlotJWvHTCoqchczUCaRVlLvb/NMjb+LRt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=jgGTrKD0; arc=none smtp.client-ip=209.127.231.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="jgGTrKD0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1790162147;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=vTXwUoG0YrOP5+/xSMF7ok6KIOTZTTi+Llnc0nIw16w=;
 b=jgGTrKD0Q75EsnzTWpuyxo4oEqVskfVSFEyhkxXw9Z5DMLSGWpdPt23v07N7Kk2OvXCZFa
 HtL3NidZ86VU9MvRNS0YvrBCOnr7HWgm8EvfO2bQL1/noU4TF2RRgdhi2uL3Rl0vtRkES4
 b+UB1Rv2ER09Uwtc7PT5gDXb51I7LhUV44l7VCowZXZr9MFTGqJRyQ2lcGsgMzIexOl4sm
 uQ1O6KDDQTmvCAszaNiaUa+JBFSUsQnu5VB72KpbN1sbhOgupjqSO/WG6qJmrBBuVfvEWb
 s9K/13R4+t+3VJVlzjg1QI0YM6lqfmtW5sRJECuWrZ+ulKuxXxYNDrfTXzFd5w==
References: <20260921081009.278532-1-peng.fan@oss.nxp.com> <20260921081009.278532-2-peng.fan@oss.nxp.com>
X-Original-From: yu kuai <yukuai@fygo.io>
Cc: <linux-kernel@vger.kernel.org>, "Peng Fan" <peng.fan@nxp.com>, 
	<linux-raid@vger.kernel.org>
From: "yu kuai" <yukuai@fygo.io>
Received: from [192.168.1.104] ([39.182.0.179]) by smtp.larksuite.com with ESMTPS; Wed, 23 Sep 2026 11:15:46 +0000
Content-Transfer-Encoding: quoted-printable
To: "Peng Fan (OSS)" <peng.fan@oss.nxp.com>, "Song Liu" <song@kernel.org>, 
	"Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
In-Reply-To: <20260921081009.278532-2-peng.fan@oss.nxp.com>
Reply-To: yukuai@fygo.io
Subject: Re: [Patch V2] md/raid: use assign_bit() where applicable
Message-Id: <f46a226a-6c7b-4a50-99f7-40400fb377db@fygo.io>
X-Lms-Return-Path: <lba+26ab3b4e3+7b2038+vger.kernel.org+yukuai@fygo.io>
Date: Wed, 23 Sep 2026 19:15:43 +0800
Content-Type: text/plain; charset=UTF-8

=E5=9C=A8 2026/9/21 16:10, Peng Fan (OSS) =E5=86=99=E9=81=93:

> From: Peng Fan<peng.fan@nxp.com>
>
> Convert open-coded if/else with set_bit/clear_bit to the assign_bit API.
>
> Done with Coccinelle semantic patch:
>      // set_bit -> clear_bit =3D> assign_bit
>
>      @@
>      expression cond, bit, addr;
>      @@
>
>      -if (cond)
>      -        set_bit(bit, addr);
>      -else
>      -        clear_bit(bit, addr);
>      +assign_bit(bit, addr, cond);
>
>      // clear_bit -> set_bit =3D> assign_bit
>
>      @@
>      expression cond, bit, addr;
>      @@
>
>      -if (cond)
>      -        clear_bit(bit, addr);
>      -else
>      -        set_bit(bit, addr);
>      +assign_bit(bit, addr, !cond);
>
> Signed-off-by: Peng Fan<peng.fan@nxp.com>
> ---
>
> V2:
>   Separate device-mapper and mraid
>   https://lore.kernel.org/all/20260918141737.3023011-1-peng.fan@oss.nxp.c=
om/
>
>   drivers/md/md.c          | 22 ++++++----------------
>   drivers/md/raid5-cache.c |  6 ++----
>   drivers/md/raid5.c       |  6 ++----
>   3 files changed, 10 insertions(+), 24 deletions(-)
Applied to md-7.4

--=20
Thanks,
Kuai
