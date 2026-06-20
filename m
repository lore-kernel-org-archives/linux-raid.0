Received: from sg-3-44.ptr.tlmpb.com (sg-3-44.ptr.tlmpb.com [101.45.255.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC653B7A8
	for <linux-raid@vger.kernel.org>; Sat, 20 Jun 2026 20:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.45.255.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781987531; cv=none; b=I53UZLaWZ95kXmA2VHxnKYUH50+t4B/ImOC9ElY1qd/5XA82qkyRg42Vo4ey24Asmy1XRTXl+uvlDeGgHyKnTv45vv4/HV/e/dvzp6OCF/5viGe8LoePtCT24j0OLZq0LwPeyEnerPKgURAMt4rL22USIjUmmPwe/CETP/n7+8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781987531; c=relaxed/simple;
	bh=uWyePVhyQEhsxRk0jPEpsUpS9yyb5crcfYJMQcT8C8M=;
	h=References:From:Subject:Mime-Version:Date:Message-Id:In-Reply-To:
	 To:Cc:Content-Type; b=sodYUF3NEd7LFMKEWmWHQiCjzk1tEwlTEN7uFdLWKpmb3OsE5cIblXSU+zpfB5US5aDziuJrPcw0dHsOvIWlXR+2cTZDnaiSFhW9h41ebd5013O6gI5m2W7JdClRDVuF8MwKVfakNS7YF+r7NHkfpx4CvBwyUawI7JhG5f/ri5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=RaIMK9hC; arc=none smtp.client-ip=101.45.255.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="RaIMK9hC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1781987441;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=oc6w5ozIOvyx77Sc0krFwxu+DXzqg/VFt8RQeh09KP8=;
 b=RaIMK9hC0kpyQA5TWWSlRKZvGvU6D2R4dUg6MXKeXTDMpTZ/L+ljhze1xFmSmasmmglt/X
 ZAVucIVlNF1NXYlxv3TBt+HqzwR9hTaJYhVTYXDJNVgjr03dxL2EZnjc0Hl3Fqb7HBZdHR
 TjhTSYxHMWcs1DaOWzqbdfDzMjirnmXA4oCG6yaIKRtqPhLsz0cknVswz9B7iSdUN0Gmj2
 FwcoNpnG+bmRcOs2dfM3mlb6F+lacMa1qI6Pi0es9VZv7opDa6gKKCkR/oV/5DFSQfmKxe
 o3Kdg4942k9PVGRt3WS/JBRQz/lUZuKQOsRuI0i7T9XOPUYjtuXvRBd7AkRH2Q==
X-Original-From: yu kuai <yukuai@fygo.io>
References: <20260611101350.759154-1-abd.masalkhi@gmail.com>
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH] md/raid1: free r1_bio when REQ_NOWAIT is set and read would block on retry
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from [192.168.1.104] ([39.182.0.148]) by smtp.larksuite.com with ESMTPS; Sat, 20 Jun 2026 20:30:39 +0000
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+26a36f870+fe73b0+vger.kernel.org+yukuai@fygo.io>
Reply-To: yukuai@fygo.io
Date: Sun, 21 Jun 2026 04:30:35 +0800
Message-Id: <6b5204ab-dd2e-460c-b2cc-2ed04f6fa816@fygo.io>
In-Reply-To: <20260611101350.759154-1-abd.masalkhi@gmail.com>
User-Agent: Mozilla Thunderbird
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>, <song@kernel.org>, 
	<yukuai@fygo.io>, <magiclinan@didiglobal.com>, <xiao@kernel.org>, 
	<vverma@digitalocean.com>, <axboe@kernel.dk>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	"sashiko-bot" <sashiko-bot@kernel.org>, <yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8

=E5=9C=A8 2026/6/11 18:13, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:

> When a read is retried, raid1_read_request() may be called with a
> pre-allocated r1_bio. If wait_read_barrier() fails for a REQ_NOWAIT
> read, the bio is completed and the function returns immediately. In this
> case the existing r1_bio is leaked.
>
> This fixes a leak of pre-allocated r1_bio structures for retried reads.
>
> Fixes: 5aa705039c4f ("md: raid1 add nowait support")
> Reported-by: sashiko-bot<sashiko-bot@kernel.org>
> Closes:https://sashiko.dev/#/patchset/20260611083514.754922-1-abd.masalkh=
i@gmail.com?part=3D1
> Signed-off-by: Abd-Alrhman Masalkhi<abd.masalkhi@gmail.com>
> ---
>   drivers/md/raid1.c | 6 ++++++
>   1 file changed, 6 insertions(+)
Applied to md-7.2

--=20
Thanks,
Kuai
