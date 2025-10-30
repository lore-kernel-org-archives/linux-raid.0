Received: from va-2-35.ptr.blmpb.com (va-2-35.ptr.blmpb.com [209.127.231.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB4F167272
	for <linux-raid@vger.kernel.org>; Thu, 30 Oct 2025 02:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761790485; cv=none; b=mPwluLZTy6gGuN/RDTm2nTK2N8EMTUpI1ctEQzfY5ozZqmFHjle6qOIoZkaEuhOPY7U1AG60Gyn2efQ+rN0HPt1cUqntDKP+sphPVFqDSNKRq0QiQsbm+yPV3UkgiXuVkctNKLwjz7aRooUcyiuKkuigYd5gA/20EhOZfclDDq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761790485; c=relaxed/simple;
	bh=3ZChRu8l8Ocb11ALE9MuCwWyYWsaX4PJ9HKaC5MpeDc=;
	h=Message-Id:References:From:Date:Cc:Content-Type:In-Reply-To:To:
	 Subject:Mime-Version; b=Hdivv0InWPRI0JUqf5JBM075+Rrzb5VlpOPzZPfhdtR2hbqLhZrmZ4d+J72MnHvY/Hyu31SVp9yB/shB3ZCNgx82vzlitjhpWtiFl61yfY3PoNtXWi/iWq7GfXDkJLHg0m2brMRleCK/FJQ5IBW2ENiOr1rARVUB7GkAegitcDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=fail smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=DPCEq+2e; arc=none smtp.client-ip=209.127.231.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="DPCEq+2e"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1761789566;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=TFNzpWGB60q9ORcJFUu5EIYWym+NnCK6t8plrVdYWx4=;
 b=DPCEq+2e+jMp+v89cd7eZqxW9+OZ5fR7WRwPEvFqHAdQ7bnZIbxIwZdHxVsckXuJrwb+aU
 hGQerms9YlDyRPulBvTcLI0Uj90hLEjfbAzWrtPsQ3z9jw3MzhMx1urIADpUmFnvwyqMPU
 IbujUCaMDLpieAgD/Zpyo9kdgTwxp8qpgfyhv4xn3sqUb6fAW7BS523nFr84EXFU4JB4IO
 zzmq5H9wlcqXjTELgiviupTNJZozXPItN1J9lQ63G9iptGYZ7sHpghkotp8Ve5BN6vdJU/
 Xw6231fUGXVjXKDSoRzEvX35UmF0aQXxakazt7UKuUpB7dQLci+i38fY7g5W7g==
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Message-Id: <d2fa618a-6757-4ed1-9626-6e97e227d9fa@fnnas.com>
User-Agent: Mozilla Thunderbird
References: <20251027150433.18193-1-k@mgml.me> <20251027150433.18193-2-k@mgml.me>
X-Lms-Return-Path: <lba+26902c67c+4b6446+vger.kernel.org+yukuai@fnnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Date: Thu, 30 Oct 2025 09:59:20 +0800
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Received: from [192.168.1.104] ([39.182.0.168]) by smtp.feishu.cn with ESMTPS; Thu, 30 Oct 2025 09:59:22 +0800
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20251027150433.18193-2-k@mgml.me>
Reply-To: yukuai@fnnas.com
To: "Kenta Akagi" <k@mgml.me>, "Song Liu" <song@kernel.org>, 
	"Shaohua Li" <shli@fb.com>, "Mariusz Tkaczyk" <mtkaczyk@kernel.org>, 
	"Guoqing Jiang" <jgq516@gmail.com>
Subject: Re: [PATCH v5 01/16] md: move device_lock from conf to mddev
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0

=E5=9C=A8 2025/10/27 23:04, Kenta Akagi =E5=86=99=E9=81=93:

> Move device_lock from mddev->private (r1conf, r10conf, r5conf)
> to the mddev structure in preparation for serializing md_error() and
> introducing new function that conditional md_error() calls to
> improvement failfast bio error handling.
>
> This commit only moves the device_lock location with no functional
> changes. Subsequent commits will serialize md_error() and introduce
> a new function that calls md_error() conditionally.
>
> Signed-off-by: Kenta Akagi<k@mgml.me>
> ---
>   drivers/md/md.c          |   1 +
>   drivers/md/md.h          |   2 +
>   drivers/md/raid1.c       |  51 +++++++-------
>   drivers/md/raid1.h       |   2 -
>   drivers/md/raid10.c      |  61 +++++++++--------
>   drivers/md/raid10.h      |   1 -
>   drivers/md/raid5-cache.c |  16 ++---
>   drivers/md/raid5.c       | 139 +++++++++++++++++++--------------------
>   drivers/md/raid5.h       |   1 -
>   9 files changed, 135 insertions(+), 139 deletions(-)

Reviewed-by: Yu Kuai <yukuai@fnnas.com>
