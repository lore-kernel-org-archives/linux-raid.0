Received: from va-2-60.ptr.blmpb.com (va-2-60.ptr.blmpb.com [209.127.231.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9EFCA6B
	for <linux-raid@vger.kernel.org>; Sat, 20 Jun 2026 18:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.60
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781980317; cv=none; b=D5rmku01liMsK345Y6BP2jsZBcxM0HBKml+Vl2+5kisuahDu2ix1rNsUn8OxGX6L1DvdAEqs9RlJfZUsyAXb2tAcFjNwVsfYUpQeIJUPy0/wQ+bfTyabe3G2RVrTMVXqPhEN0tC0aCkmPwGshnajlS4NLbfm3Vi0OffAqX9u5EE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781980317; c=relaxed/simple;
	bh=tUpCQ+4O6NGlhAKjjHFtBgvIokoirlSYmbyl1/Qf0Wo=;
	h=From:Message-Id:Date:References:Subject:Mime-Version:Content-Type:
	 To:Cc:In-Reply-To; b=saTiddiPZ6PSeC4/NhEIRBNm0PdPYW6dNX2lSiVS2p15aI+Mgi+oGfYP4VrgXvYx5w1ki2CcpbE9E45+dVqrAQCMbKGpCfaCr63Gkk6n3KzYKUyepQWZcpxKumWeUbswNnA5o7H5b1FbbDVzpRyqF/ocffBL6yb1uLVrl4L1JC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=gPdHY+vs; arc=none smtp.client-ip=209.127.231.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="gPdHY+vs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1781980302;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=ZUErGpzc8Xn9ZIDCNIvGTInQkF6mr7ybonyo8oXLi9A=;
 b=gPdHY+vshTGSILccWAZR2RvWXCtpftdNsi4syOlUvss5v+xv7KDGFYVOs2xzddaVpw0mZu
 /9IEvJ1xczR3jo8+17fK8oVS+zsU030sI33NYawPYfgfyMTiCH0y01yH3EQDMBuZocVTkr
 cU5k7shheUHHZfytm9Nk4H9cs2quiETS7O7rT/Iy7Vgfs8JnFP46shOGPWMfuWyh3hgICp
 PO7OAP+xs1Xq6suDM0BDuFQSfrCPBN4QBWysFCMRLaB1Xko8A2OzRaCB6LCoEtoQMNoZno
 O3pedq+rF1FaVU7cvUvIsJ/suFzxvvAhZx8Utfhb8twoG7qd8Pgbf/2uGAQWaw==
User-Agent: Mozilla Thunderbird
X-Lms-Return-Path: <lba+26a36dc8d+1f80f9+vger.kernel.org+yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Message-Id: <1a6ea422-8d8b-4ab0-8ac5-ce515b2a3f9b@fygo.io>
Received: from [192.168.1.104] ([39.182.0.148]) by smtp.larksuite.com with ESMTPS; Sat, 20 Jun 2026 18:31:40 +0000
Reply-To: yukuai@fygo.io
Date: Sun, 21 Jun 2026 02:31:36 +0800
References: <20260613182810.1317258-1-abd.masalkhi@gmail.com>
Content-Transfer-Encoding: quoted-printable
X-Original-From: yu kuai <yukuai@fygo.io>
Subject: Re: [PATCH v2 0/4] md/raid1,raid10: fix write-path reference leaks and clean up error handling
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>, <song@kernel.org>, 
	<yukuai@fygo.io>, <magiclinan@didiglobal.com>, <xiao@kernel.org>, 
	<axboe@kernel.dk>, <hare@suse.de>, <john.g.garry@oracle.com>, 
	<martin.petersen@oracle.com>, <vverma@digitalocean.com>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<yukuai@fygo.io>
In-Reply-To: <20260613182810.1317258-1-abd.masalkhi@gmail.com>

=E5=9C=A8 2026/6/14 2:28, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:

> Hi,
>
> This series fixes several write-path failure handling issues in raid1 and
> raid10 and then follows up with a cleanup of raid1_write_request().
>
> The first two patches fix writes_pending leaks caused by failure paths
> that complete bios without reaching the normal write completion path.
> The raid1 fix also addresses a barrier reference leak when
> wait_blocked_rdev() fails after wait_barrier() succeeds.
>
> The third patch fixes additional writes_pending and barrier reference
> leaks in raid10 discard handling.
>
> The final patch simplifies raid1_write_request() error handling.
>
> Patches:
> md/raid1: fix writes_pending and barrier reference leaks on write failure=
s
> md/raid10: fix writes_pending leak on write request failures
> md/raid10: fix writes_pending and barrier reference leaks on discard fail=
ures
> md/raid1: simplify raid1_write_request() error handling
>
> Changes in v2:
>   - fix writes_pending leaks in addition to the barrier reference leaks
>   - add raid10 fixes for analogous write and discard failure paths
>   - add a follow-up cleanup patch to simplify raid1_write_request()
>   - simplifies raid1_write_request() error handling.
>   - Link v1: https://lore.kernel.org/linux-raid/20260611132500.763528-1-a=
bd.masalkhi@gmail.com/
>
> Thanks,
> Abd-Alrhman
>
> Abd-Alrhman Masalkhi (4):
>    md/raid1: fix writes_pending and barrier reference leaks on write
>      failures
>    md/raid10: fix writes_pending leak on write request failures
>    md/raid10: fix writes_pending and barrier reference leaks on discard
>      failures
>    md/raid1: simplify raid1_write_request() error handling
>
>   drivers/md/raid1.c  | 74 ++++++++++++++++++++++++---------------------
>   drivers/md/raid10.c | 28 ++++++++++++-----
>   2 files changed, 60 insertions(+), 42 deletions(-)
Applied to md-7.2

--=20
Thanks,
Kuai
