Received: from va-2-50.ptr.blmpb.com (va-2-50.ptr.blmpb.com [209.127.231.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B6027FB18
	for <linux-raid@vger.kernel.org>; Sun, 19 Jul 2026 10:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784457141; cv=none; b=FGkFjC4DAllQIOeiAvMVLYEeZS8Nl5hnicSPdVnYk7CPHUNg7dHbiQ/bN8EU2MwcgwAifZ4hvKuk2uS/BHaRgeqOrfHXNPii+1ga9lEF6UQRKxcnm3/vUbAkf9aEgZdmSKcOMDlWcUocE48F6cnUvZMETk2mKArOy4m4YIf1BpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784457141; c=relaxed/simple;
	bh=xZSgGfc0S/iZ66o9sPIFocknf21KtT1C1VASGPqfvsg=;
	h=Date:Mime-Version:In-Reply-To:Message-Id:References:To:Cc:From:
	 Subject:Content-Type; b=IB5Fks0dt1O/IjbI7xXoapBLYTeCVa26iNjYPscUdaE9EIvjJSSrBSs7jahIOqSXN7G0bYxs0yibcIfRVGqPJnb8lVbhJAXAFu3OPj4JOgaYibCfbqVrmUtdeniO7YNNOCPxQjcFelMNJDPfOqzwnkJ2UyMYdqChD+KPUxEeJe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=bCDjT1HK; arc=none smtp.client-ip=209.127.231.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="bCDjT1HK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1784457130;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=QfL9vLv+g/SPY4MH+EVuNnLBQA7XUz0nG3MlSD03spM=;
 b=bCDjT1HKEW6txkzuHNCf7ITE7AQBWvWH7kmEL9HEXH3v9c9H9aCMCr0TXRPgOrd+JsU2R7
 +uYdYNRNKtRdI4CqNhlC7NapCoeGTg6B8p9OhKZ04HmxuRvTr/t7PRVS9pVPbhK7TOnQNw
 LW7uwQI5pQgCTjVpQ94aaR7cP38DIJ1xRx5LQMZSotXKcv+ZPNvc2wM66OnFfUHzzHzur2
 rSWwKIW0dye2qgg+UWDlyRuR9JtD2jKj6CnFaG+2GBOAY7oKkoA1/XBeOeB2Fwz6PhRL1s
 hCqrhHKCkq8TgzrOGPzfju/iTHT2aQM5tqRgcaBVkX047ZKFiInIAcQYjq8cOA==
Date: Sun, 19 Jul 2026 18:32:05 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <20260718034236.4119093-1-chencheng@fnnas.com>
Reply-To: yukuai@fygo.io
Message-Id: <bc7ebf3f-0434-4cba-9957-34ada1a2c0ce@fygo.io>
References: <20260718034236.4119093-1-chencheng@fnnas.com>
To: "Chen Cheng" <chencheng@fnnas.com>, <linux-raid@vger.kernel.org>, 
	<yukuai@fygo.io>
Cc: <chencheng@fygo.io>, <linux-kernel@vger.kernel.org>
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH] md/bitmap: resume array on backlog_store() error path
Content-Transfer-Encoding: quoted-printable
Received: from [192.168.1.104] ([39.182.0.157]) by smtp.larksuite.com with ESMTPS; Sun, 19 Jul 2026 10:32:09 +0000
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26a5ca7a9+a44738+vger.kernel.org+yukuai@fygo.io>
User-Agent: Mozilla Thunderbird
X-Original-From: yu kuai <yukuai@fygo.io>

=E5=9C=A8 2026/7/18 11:42, Chen Cheng =E5=86=99=E9=81=93:

> From: Chen Cheng<chencheng@fnnas.com>
>
> backlog_store() suspends the array before checking whether a write-mostly
> device exists. If no such device exists, the error path only unlocks
> reconfig_mutex and leaves the array suspended, blocking subsequent I/O.
>
> Use mddev_unlock_and_resume() to release both states.
>
> Fixes: 58226942ad3d ("md: use new apis to suspend array before mddev_crea=
te/destroy_serial_pool")
>
> Signed-off-by: Chen Cheng<chencheng@fnnas.com>
> ---
>   drivers/md/md-bitmap.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
Reviewed-by: Yu Kuai <yukuai@fygo.io>

--=20
Thanks,
Kuai
