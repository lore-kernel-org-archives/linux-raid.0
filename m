Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE003E3DBE
	for <linux-raid@vger.kernel.org>; Fri, 26 Jun 2026 08:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782463902; cv=none; b=mTIreNCTIOkl3w7YosUeM5hl04CQn9E7RTOdAqO1L/E9d1YO8PFllZaM5PtR+bSpuQ7yQuiN+bU9FCsQZ+RnQxAmXUYRWGmFU4DTIFgGIISHhd6GJh1BnEn8SlFh24joerWN2TECUGfSGWjeGLqdXGNSjN67b/78Sx4W8hsPva0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782463902; c=relaxed/simple;
	bh=CwJSSElVRZ5HGw7cvVaod5HcF7qaRh+6WmXylBpN6xc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VQHo93obVL21PLZeHt1T+TMyMmX8ItEG/JEOEkTrewZ4jmAp9cXd5JF7Dzc5WsaZRrQ2U8um1RMhreaxTmpkD0ItNPRVr/TtTybMPWLlFqub+QUU+2cAkebacqCL17oasEZz4mo6I8Y5N5kTjk34RpFa04qE/RgyFx31h6FwR/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hgoh8mLn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hgoh8mLn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AEBC1F000E9;
	Fri, 26 Jun 2026 08:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782463901;
	bh=DBa3gmPHrcaiMYgXHhufSQu49YRMpZvFd/q32hUmDL8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Hgoh8mLnbuAAFkbA6xEcMya/nw9W17SpFxfKmGivx5x3+m33szc7mBgei/kneeOFS
	 JE/6WTFO83mIB092lO8TwJ7G7wLojOm2RAIcnavfm1FwKgw3jMmOtnEPwzjNwwnQu8
	 z1GdENu3gzUJQ+A2dI1M053nT/jB1f7EEFrM03/ymLO1t5mmIcdpzt59ZMlPqMQ3wE
	 DXzLv+cFFD4qHssSJx9ER6F9OBPKnYPXWdrPYSqP442PcKzA8BbZfZ3Saor10S9Zcd
	 mZ/dZgC8jV/gL9K12HBlV1uVhk0garkghxPTgsh1SzSfL/YMnKVSz9pfBV3P+jWL7k
	 bAE+UL8NNmVqA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 next] drivers/md/md: Use bounded strings ops when
 setting disk->disk_name
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Laight" <david.laight.linux@gmail.com>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260626084334.3012-1-david.laight.linux@gmail.com>
References: <20260626084334.3012-1-david.laight.linux@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 26 Jun 2026 08:51:40 +0000
Message-Id: <20260626085141.3AEBC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Inconsistent coding style for the sizeof operator in newly added co=
de.
--

commit 663613700e83a5bb9c1749d80b4fae68752645fb
Author: David Laight <david.laight.linux@gmail.com>

drivers/md/md: Use bounded strings ops when setting disk->disk_name

This commit replaces unbounded strcpy() and sprintf() with bounded strscpy()
and snprintf() operations when setting the disk_name in md_alloc() to impro=
ve
safety.

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d1465bcd86c81..afbdc52a11270 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6354,11 +6354,11 @@ struct mddev *md_alloc(dev_t dev, char *name)
[ ... ]
>  	if (name)
> -		strcpy(disk->disk_name, name);
> +		strscpy(disk->disk_name, name);
>  	else if (partitioned)
> -		sprintf(disk->disk_name, "md_d%d", unit);
> +		snprintf(disk->disk_name, sizeof(disk->disk_name), "md_d%d", unit);
>  	else
> -		sprintf(disk->disk_name, "md%d", unit);
> +		snprintf(disk->disk_name, sizeof (disk->disk_name), "md%d", unit);

[Severity: Low]
This isn't a bug, but there is an inconsistent coding style for the sizeof
operator here in md_alloc(). The adjacent branch uses sizeof(disk->disk_nam=
e)
without a space, while this newly added branch includes a space. The kernel
coding style prefers no space after sizeof.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260626084334.3012=
-1-david.laight.linux@gmail.com?part=3D1
