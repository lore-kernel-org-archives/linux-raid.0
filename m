Received: from sg-3-41.ptr.tlmpb.com (sg-3-41.ptr.tlmpb.com [101.45.255.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B010311C3E
	for <linux-raid@vger.kernel.org>; Sun, 19 Apr 2026 06:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.45.255.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776578860; cv=none; b=UX1csye4UiSRV7TN1AQbGrL/tPBaeBys5cBnBzLu/0qy9Txc3CSckesr6RNIV4Ljk9qEF0NIYLn0HmDHjN2mPMY3sFRTJ0ozPLLXsB+RvGu6nfpMof5MFnWESvRR36qe76K/n7Fu+YjeNB+eZ69/OoNz8bKu//coTZoKKRxOIZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776578860; c=relaxed/simple;
	bh=JndVFHM2TTUNhIkPAtkrDQ3MPvQM8m9cV4oYYXLUKVE=;
	h=To:Subject:Date:Message-Id:In-Reply-To:From:Mime-Version:
	 Content-Type:Cc:References; b=O0X1rdDqG7ozrY2/D3O9B2YzJIqcChu6g6ePGOXJT3AZTJRE96W/GPvJA8CNXlNmSYk/IpWAow6tUL3h42WzCEDlNnW17JDVHSbniCbAJ5EuyY6rhsFRcfdXC0TC32YXvxbfu5gO4enEv5del4UeJFHW24hx3/Lb0Zcm2QpDvIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=JsI1q9rE; arc=none smtp.client-ip=101.45.255.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="JsI1q9rE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1776578810;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=1lpwmprIYYttd+yvZgPHrLTgewuGig/lJCi0mkeCFy8=;
 b=JsI1q9rEWKNiMch2YIl29yJ4/eYCPuWlu6Aive7rpGQNCRHJOxV7TVTb/UtiqFP6/c7Khd
 mfKd1n+RbB87xVMntSFlLDl0ycrr8YIGbnjhx7ne9sDLldyeD5caKSgnckGHI2iDfxaG6b
 j1+ZoGvxMxQPtX2415LUDErbbF7Yy7N2c7zZO3vY97tUK58iYPFybX0nGGmBhLcpZ9/rYe
 zTIfkQxch+De5axkQyJEgNXkG1UvUgGFp2Jd0P/pYOZf8WxZMknkYHzqtP5EGp++4XBM1G
 J+f8J0qVpQxCLVLZGyO2i40deZhWEjSzidKXrDFnsQs+ox5YW7VH1roCwTEFxQ==
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.144]) by smtp.feishu.cn with ESMTPS; Sun, 19 Apr 2026 14:06:47 +0800
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>, <song@kernel.org>
Subject: Re: [PATCH 0/2] md: small cleanups in MD driver
Date: Sun, 19 Apr 2026 14:06:45 +0800
Message-Id: <86d980c3-7736-4645-9c61-236f5527405c@fnnas.com>
X-Lms-Return-Path: <lba+269e470f8+f911f5+vger.kernel.org+yukuai@fnnas.com>
In-Reply-To: <20260415140319.376578-1-abd.masalkhi@gmail.com>
Reply-To: yukuai@fnnas.com
From: "Yu Kuai" <yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<yukuai@fnnas.com>
User-Agent: Mozilla Thunderbird
Content-Language: en-US
References: <20260415140319.376578-1-abd.masalkhi@gmail.com>
Content-Transfer-Encoding: quoted-printable

=E5=9C=A8 2026/4/15 22:03, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:

> Hi,
>
> This small series contains two cleanups in the MD driver.
>
> Patch 1: replaces a wait loop in md_handle_request() with wait_event()
> Patch 2: replaces a mutex_lock() with mddev_lock_nointr()
>
> Thanks,
> Abd-Alrhman
>
> Abd-Alrhman Masalkhi (2):
>    md: replace wait loop with wait_event() in md_handle_request()
>    md: use mddev_lock_nointr() in mddev_suspend_and_lock_nointr()
>
>   drivers/md/md.c | 10 +---------
>   drivers/md/md.h |  2 +-
>   2 files changed, 2 insertions(+), 10 deletions(-)
Applied

--=20
Thansk,
Kuai
