Received: from va-2-56.ptr.blmpb.com (va-2-56.ptr.blmpb.com [209.127.231.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F97446055
	for <linux-raid@vger.kernel.org>; Thu, 17 Sep 2026 06:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789627649; cv=none; b=Oa0dxQ4ZDoBzfiioKdYmDOTBl2Rpn0JvjuSfKYjO6Fa5vy5P/zOR8qoh92ZcVy0pbgu93jpIZNIRvtLNfa1rqeGmuD/43nqZhwgM5+EbWjGM5Xzlj32hSLY6PC4SBIzr50ubZgUeTRPnypPOf6Wrdx8yyjvFRN3l7CNFmsyc2cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789627649; c=relaxed/simple;
	bh=e+khsdLG9blooTeHHpnzcWv4rhH51aMyUJs9jUoJWE8=;
	h=From:Date:Message-Id:Mime-Version:In-Reply-To:To:Cc:Subject:
	 References:Content-Type; b=nsOe4Bb0uNqH1rVTH/UrZQmkNKXikWHpJJCitXps6vl6Av9Ki6HCBGYURDW6utpdA3hvNJxGIZ537ukANvICo24frHqFVrkcXfuHs2efeYN+va7iqn0rNBQVm6/sv6nnkUmKBPo0ovKn6K2LyAcNOaebcke2GVJTA6zR/9YUjaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=cJC+xZCC; arc=none smtp.client-ip=209.127.231.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="cJC+xZCC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1789627642;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=wRW++kxdHlia9XtRrz1yYiFvBj+oa21DVF+CwMDnMAQ=;
 b=cJC+xZCC12Hq9k/xGcaBtlxcXCLOIeg02txUpsMR6PhFqjIAhzLK2kOjG6vjyYkkXJhSEG
 cMfVFi9VqbVvX5IaYkZANjs21Rs7mCQJfYLgYyXuDZETs3IOcev+HfSCJvfuQwn0dMjBuN
 GyNcjNeA7a611AcnGVlm7cNPLhYLexyN7JdZcG5CDjBhLvOY3Dl9iVUrbNCFizvt7XVMTO
 EcWOPOtAz1Cc2uuIq1OLI70A0nrj8F6eo2zIIaTavNTe+IBLlCsPwgKnAWOYEhikM64Prw
 ubzuTbYcC0hL54ml1rW/jF4KLmaFt5CvaJ8W3U903ZKkEW+tx2hLcZJlas6Spw==
From: "yu kuai" <yukuai@fygo.io>
Date: Thu, 17 Sep 2026 14:47:17 +0800
Message-Id: <e7bf70d3-2fd8-4cbf-ad61-05e89878cbf3@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260915081731.122933-1-chengzhihao1@huawei.com>
X-Lms-Return-Path: <lba+26aab8cf9+6f24a6+vger.kernel.org+yukuai@fygo.io>
To: "Zhihao Cheng" <chengzhihao1@huawei.com>, <song@kernel.org>, 
	<artur.paszkiewicz@intel.com>, <shli@fb.com>, "yu kuai" <yukuai@fygo.io>
User-Agent: Mozilla Thunderbird
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<yangerkun@huawei.com>, <yi.zhang@huawei.com>
Subject: Re: [PATCH] md/raid5: setup_conf: Fix null-ptr-def in error handling path
Received: from [192.168.1.104] ([39.182.0.142]) by smtp.larksuite.com with ESMTPS; Thu, 17 Sep 2026 06:47:21 +0000
X-Original-From: yu kuai <yukuai@fygo.io>
Reply-To: yukuai@fygo.io
References: <20260915081731.122933-1-chengzhihao1@huawei.com>
Content-Type: text/plain; charset=UTF-8

=E5=9C=A8 2026/9/15 16:17, Zhihao Cheng =E5=86=99=E9=81=93:

> For raid5 setup_conf, if an error(eg. bioset_init fails) happens before
> 'conf->mddev =3D mddev', following error handling path could trigger a
> null-ptr-def problem:
>
>   free_conf
>    log_exit
>     raid5_has_ppl
>      test_bit(MD_HAS_PPL, &conf->mddev->flags) // conf->mddev is NULL !
>
> Fix it by initializing conf->mddev in advance.
>
> Fixes: 3418d036c81d ("raid5-ppl: Partial Parity Log write logging impleme=
ntation")
> Signed-off-by: Zhihao Cheng<chengzhihao1@huawei.com>
> ---
>   drivers/md/raid5.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
Applied to md-7.4

--=20
Thanks,
Kuai
