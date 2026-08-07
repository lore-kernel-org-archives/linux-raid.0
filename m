Received: from va-2-42.ptr.blmpb.com (va-2-42.ptr.blmpb.com [209.127.231.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5323D5241
	for <linux-raid@vger.kernel.org>; Fri,  7 Aug 2026 08:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786090334; cv=none; b=Y+IktoJIKzJ9HyE+dm1RnKq53amvZdcZFZuv9alHHrOQgr4WAwSUUQwmsDhLEv2qWALMwJ4pJBpkRlORmZ++HuFBJM1JA1Ff4hHomeF7WCdyclljfaaD0KbFShV+i1Sk+EwEHrI9xkp1rPo2KJAT1W2ks39I5gE4FryScSRMnJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786090334; c=relaxed/simple;
	bh=p6pgtPZ2DnGDOskxaGtuGHIj9xlu1FjHtwQSu+lm8uI=;
	h=From:In-Reply-To:References:Cc:Date:Content-Type:Mime-Version:To:
	 Subject:Message-Id; b=NOi70jtNr/cMcImqY1P5oukXZtXaGmoUAxdqo2Pis6/i+OI7vTC1U2WTsPGP1IBom/rZc1LhRhGPRe+SNIp9+jvEtjcBoO2J/FS6WNNzoUxH0mKBJB6eLWtcUBcZRVeL2fr6pO7foTYzZ3OsqUtaFePZzKqWoefP9ZOCgfyT4fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=kLF2lLL9; arc=none smtp.client-ip=209.127.231.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="kLF2lLL9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1786090318;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=4BKyvWYl8qy4p6RK0KctuuSAq7FlYzl07b3CuIFq5lM=;
 b=kLF2lLL93rGZVgnWUsiHBcyydNYEBEZcvA0n1QsCMPZ59Pa7o95TQ8kZO/KIjAgsjebqx/
 tDYKRyl93KxVhlyoo2yKUpVvWkVEdzwf5vAksJyf1Wrqn4SQ+l+pcX1oR/djRi/gDRjlb7
 of5h0XCqruTT0EVl/oF6xPnObTGokPt1Dh4o8BBs4ZdBnqV5nSCicpV32lXx14pVACaVAd
 kbeKu6LBpkU1uRzn1jZQoI16zDwC+3Xjh4TkKgxGqGpFML82KHFQG0SujtYAzySdgg9d0o
 IY8e9E5+EOkmctrTTT2ILK7xsMGEZUznCuXUHqVt0ze6B1YdBlCFSFu1CCUw/w==
From: "yu kuai" <yukuai@fygo.io>
In-Reply-To: <20260723135535.101995-3-yunye.zhao@linux.alibaba.com>
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: quoted-printable
X-Original-From: yu kuai <yukuai@fygo.io>
References: <20260717062743.128189-1-yunye.zhao@linux.alibaba.com> <20260723135535.101995-1-yunye.zhao@linux.alibaba.com> <20260723135535.101995-3-yunye.zhao@linux.alibaba.com>
Cc: "Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	"Joseph Qi" <joseph.qi@linux.alibaba.com>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>
Date: Fri, 7 Aug 2026 16:11:52 +0800
Received: from [192.168.1.104] ([39.182.0.170]) by smtp.larksuite.com with ESMTPS; Fri, 07 Aug 2026 08:11:56 +0000
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a75934d+7d1ddd+vger.kernel.org+yukuai@fygo.io>
Reply-To: yukuai@fygo.io
To: "Yunye Zhao" <yunye.zhao@linux.alibaba.com>, 
	"Song Liu" <song@kernel.org>, "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH v2 2/3] md: add cond_resched() to md_do_sync()'s skip path
Message-Id: <6de0a94e-de24-40e7-b0af-d15b5787988c@fygo.io>

=E5=9C=A8 2026/7/23 21:55, Yunye Zhao =E5=86=99=E9=81=93:

> When sync_request() reports a skipped region (*skipped =3D=3D 1),
> md_do_sync()'s main loop advances the cursor and takes an early
> continue:
>
> 	j +=3D sectors;
> 	...
> 	if (last_check + window > io_sectors || j =3D=3D max_sectors)
> 		continue;
>
> If the personality returns a small span per call (raid10 recovery
> returns only 128 sectors), syncing a large, mostly clean array iterates
> this branch an enormous number of times without ever yielding the CPU.
> On a non-preemptive kernel the resync thread then trips the soft-lockup
> watchdog:
>
>    watchdog: BUG: soft lockup - CPU#149 stuck for 313s! [mdX_resync]
>     md_bitmap_start_sync+0x6f/0xe0
>     raid10_sync_request+0x2c9/0x1530 [raid10]
>     md_do_sync+0x810/0x1030
>     md_thread+0xa7/0x150
>
> Add a cond_resched().  This does not reduce the wasted iterations; the
> excessive iteration count is a raid10 problem addressed separately.
>
> Cc:stable@vger.kernel.org
> Signed-off-by: Yunye Zhao<yunye.zhao@linux.alibaba.com>

Remove the cc stable as there is no fixtag.

> ---
>   drivers/md/md.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
Applied to md-7.3

--=20
Thanks,
Kuai
