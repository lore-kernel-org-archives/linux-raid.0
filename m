Received: from sg-1-37.ptr.blmpb.com (sg-1-37.ptr.blmpb.com [118.26.132.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC38421F10
	for <linux-raid@vger.kernel.org>; Wed,  4 Feb 2026 15:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770220726; cv=none; b=IOwMNNt99SJ814XLpz50InXI4TxHbOQno/1Z5ckDi0NrXHTITZhb4d+zyp7KQoPvEivbYSzsBiGNuz7EF6/T4HMnwnvCdAmNvrbhy19r1EDE5lXVve8SUoZkJZsCC9bCblVAbtDpztCirEeUDZ14zJsr+HcQSMr8wotMguGiYXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770220726; c=relaxed/simple;
	bh=xz6Gzu/W9niVvdTJDkTmHIt8wzTV4WuUSFIvwVIff90=;
	h=Cc:From:Content-Type:To:References:Mime-Version:Subject:Date:
	 Message-Id:In-Reply-To; b=Vp9UpF6hABnEa2nazKYOqaQQttEPwb4pYqsGYAGd3fqgnhF0TiWGMVCo/e1G40y3O1IwFIAdAWvVWrW5rcOyst3JJlzj+i5f9aHqm4rUoPOklaiq6pDSjMTrRuskHfbXyEXgvs4gQv4ERn0g+WHSJX6uroLtXEcxhNJDWtaQjf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=N3l4K8ZU; arc=none smtp.client-ip=118.26.132.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="N3l4K8ZU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1770220713;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=lR2sgvG0rNnaaO3cMx3PkEEs+jLOZdeymmhI8JFqt0M=;
 b=N3l4K8ZUgf6yr6dvHpfBvdENaJyF71gjzFftvi5N+I5zSvSEw1WM98lu9zApxAT+3fHGVd
 gvYY1R4Gbzrl1kQzcc8dleu2ZTj6nsisqeQVeLzmmS0G4HNdJlOdEtiJC1lNl8ZYKSe6Qn
 /h9Gs1ktPjRHRwFmh6bCRvbfCfM0deAyJvtkyCBcZeHL/8vKo3gH84Ujd6NTg7IE7EiNSe
 XAs1v31YRRL8jg0H3GsE/FzeYmAHJVNsQOhSAw4SnasQD2Uz0JOC3HXB7bivx72aTtgA/E
 Fk00JJ/q9QLDX470TsKkIt3HeQ19oXLMss9UB3NvqZYZ9HYBqZiA8TComiHWTw==
Cc: <linux-raid@vger.kernel.org>, <yukuai@fnnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Reply-To: yukuai@fnnas.com
To: "Xiao Ni" <xni@redhat.com>
References: <20260204145912.9463-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
Subject: Re: [PATCH RFC 0/3] md/raid1: data corruption with serialization
Date: Wed, 4 Feb 2026 23:58:29 +0800
Message-Id: <a058e5a3-e96c-4feb-8f9d-e1135951973c@fnnas.com>
User-Agent: Mozilla Thunderbird
In-Reply-To: <20260204145912.9463-1-xni@redhat.com>
X-Lms-Return-Path: <lba+269836ca7+f73fbd+vger.kernel.org+yukuai@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.137]) by smtp.feishu.cn with ESMTPS; Wed, 04 Feb 2026 23:58:30 +0800
X-Original-From: Yu Kuai <yukuai@fnnas.com>

Hi,

=E5=9C=A8 2026/2/4 22:58, Xiao Ni =E5=86=99=E9=81=93:
> A data corruption can happen when using serialization for raid1.
> Serialization is not enabled by default. But it looks like there
> is a data corruption risk if serialization is closed. Because the
> lower driver can't guarantee the sequence which io is written first.
> So it's possible that different member disks will have different
> data for nvme devices. This patch set doesn't open serialization
> by default.

An important idea is that if there are filesystem on top of raid1/10/5, the=
re
is no need to consider overlap bio. The only case for serialization is Writ=
eMostly,
that bio can be returned to user while it's not done for slow disks. And th=
at is
the reason why serialization is for rdev.

We definitely will not enable serialization by default, because there will
be huge performance degradation. And I don't think we'll handle the case us=
er
manage data with raw disk, and write to the same area concurrently. At last=
, if
there are still problem with WriteMostly case, please rebase and keep seria=
lization
for rdev.

>
> Xiao Ni (3):
>    md: add return value of mddev_create_serial_pool
>    md/raid1: fix data corruption by moving serialization to mddev level
>    md/raid1: fix incorrect sector range in serialization
>
>   drivers/md/md-bitmap.c |  28 +++++--
>   drivers/md/md.c        | 171 ++++++++++++++---------------------------
>   drivers/md/md.h        |  30 ++++----
>   drivers/md/raid1.c     |  47 ++++++-----
>   4 files changed, 115 insertions(+), 161 deletions(-)
>
--=20
Thansk,
Kuai
