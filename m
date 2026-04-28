Received: from va-2-28.ptr.blmpb.com (va-2-28.ptr.blmpb.com [209.127.231.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3623F0AB6
	for <linux-raid@vger.kernel.org>; Tue, 28 Apr 2026 09:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777366876; cv=none; b=DiF+styMciiG214fYOVwO73uiqexqojigw8bLrY8twTVsDdutWrVFMSzOgAbU1w+n6okfui+O274GFciCdq+CB8tRYVs55KbJY9msEf27bbD7ngwaONyWQRgaSd56ssE99WqYwyhP0AG9oHi9Mo+d/nTUXfDY6MYBIaJLR424Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777366876; c=relaxed/simple;
	bh=VWpq0BpIzBLUcWdooF2eOsNOzVx03Bt0C+eN/LDj03g=;
	h=Mime-Version:Message-Id:Content-Type:In-Reply-To:References:
	 Subject:Cc:From:Date:To; b=IR3dajj6V1/H5KGL6YDQ79VJkpjVBy465fbq6stJBCGAw6QCTP4qAo8LV3HBXUQQmyAR2ERDxGuKMjOCGhzxLPzc65qSZm1tufY3KntsCEbx3ekClDu+q9ySd6LYmg/O9y6YGJW4ZdGNvoCotWMwNyiFTe59E5gDumagEKLXO5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=J1RbdGD0; arc=none smtp.client-ip=209.127.231.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="J1RbdGD0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1777366868;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=kNT0rawSRAh0ubd2T57wEOi5nzMSoFkK659qBNZD+gs=;
 b=J1RbdGD03f06fuNikOHJo6rwjn8MfwvjW3BVDRsdMzk4Cz9KodfvW/UqzsyMekNNyTB5ZP
 H5v5He/gXvuYkYTyKb/I+h3WDj2+0xhSggKJE+EYFirseCQ9TxOG1fLAcn0nJ1+Cof4fxc
 yappdDDIikp0qdcN4lAfaHwEFiFPj8T8IMBP2AzihMsU8eBTUk18B3ejt722v8hMw4yNep
 7QgUTys1P8VGSfK+ktkr+TTrbfEvfjEP5XNMlg9bhnQ4xQliDiPYDynU843xxZ+sW/UsKE
 tN6Iibxlt12JzeP5yWeUYw3nxFHjrVJ00uHw+JDiCAGRmwD3Ri8diciMb6p8Bw==
Received: from [192.168.1.104] ([39.182.0.183]) by smtp.feishu.cn with ESMTPS; Tue, 28 Apr 2026 17:01:04 +0800
Reply-To: yukuai@fnnas.com
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
User-Agent: Mozilla Thunderbird
Message-Id: <c8080c88-81fa-47de-8dd7-c20db7613066@fnnas.com>
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20260423101303.48196-1-abd.masalkhi@gmail.com>
X-Lms-Return-Path: <lba+269f07752+e512c3+vger.kernel.org+yukuai@fnnas.com>
References: <20260423101303.48196-1-abd.masalkhi@gmail.com>
Subject: Re: [PATCH 0/3] md/raid1: small cleanups in MD and raid1 drivers
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<yukuai@fnnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Date: Tue, 28 Apr 2026 17:01:02 +0800
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Content-Language: en-US
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>, <song@kernel.org>

=E5=9C=A8 2026/4/23 18:13, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:

> Hi,
>
> This small series contains three cleanups in the MD and raid1 drivers.
>
> Thanks,
> Abd-Alrhman
>
> Abd-Alrhman Masalkhi (3):
>    md/raid1: replace wait loop with wait_event_idle() in
>      raid1_write_request()
>    md: use mddev_is_dm() instead of open-coding gendisk checks
>    md: use ATTRIBUTE_GROUPS() for md default sysfs attributes
>
>   drivers/md/md.c    | 16 ++++------------
>   drivers/md/raid1.c | 15 ++++-----------
>   2 files changed, 8 insertions(+), 23 deletions(-)
Applied to md-7.1
>
--=20
Thansk,
Kuai
