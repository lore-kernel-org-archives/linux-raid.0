Received: from sg-1-13.ptr.blmpb.com (sg-1-13.ptr.blmpb.com [118.26.132.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6018F32B99B
	for <linux-raid@vger.kernel.org>; Thu, 30 Oct 2025 02:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761792004; cv=none; b=PYtPOtaSxqc3gWxZcfjxfbrIxkXW91ezVqhDUCGSuCSSdAR9dgy7MkvkcE9cs/Wf6qxj7kuEeK+/O0q+a0z38hMVpII4xOC+w1pCDDqVMSB7ewoILNQOFC5mrLk2QDsSg2LbluKNsK2Ur0b1JMiswQeDW99IgkKa5OqODiggVTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761792004; c=relaxed/simple;
	bh=ThNrNURslt67ENdzzidR8I57heYr+EHWMgLGfBYpWJk=;
	h=Mime-Version:References:Cc:Subject:Content-Type:To:From:
	 Message-Id:Date:In-Reply-To; b=A6i4FyR3vg5WBSMyRbU47a9OoJ59gqGK3OwuBc0lSxMdvjuBwS21+V07WFVYCztvTgaeYFAisqjbuv2GWAP/Fm8qRXedg1CC2GIu+Bq5v1awb7Ne/59hRuQdQNSwhSpg+iuUx8Esj+WR4S36PYtGt2DymAC3hpZsw7MZyR52FPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=EbLknmts; arc=none smtp.client-ip=118.26.132.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="EbLknmts"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1761791994;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=PpETjQCrXpmPKARG99vTEdxE6+OSeGvIljYABF1mUa0=;
 b=EbLknmtsU/GHUFe9NFvx2P8ovm2+TjEIpJ/aUlCWrR6wv3m/FaJ8RxTozL+xgTdlEjtiuX
 dn5e1blCzmydBeOqXN+UO28AouLM6Fsw+AST5TPlqxhcve2TvgDRtjjPG8wgtPl9ttQ/qZ
 KJBV6lIW/fC8F9kgCNf4SgJjMdg6R4eDNbwsIFIGAe6a/1+kIVLH/JqnXThLsbG9+fo9i5
 zA2l5/EJUnnr4gjRly/vzzPs9X+uLjNnaRps6DmZZ85IGnO0f+huiHIsSvDXNAkx0biFxZ
 9XXuTpz2xbHUw2fvbJK4LmF9VQW0mYzwEimmLhht/xX8uGTkjsm2AfR/yC+XDA==
Reply-To: yukuai@fnnas.com
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251027150433.18193-1-k@mgml.me> <20251027150433.18193-9-k@mgml.me>
Content-Transfer-Encoding: quoted-printable
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<yukuai@fnnas.com>
Subject: Re: [PATCH v5 08/16] md/raid10: refactor handle_read_error()
User-Agent: Mozilla Thunderbird
X-Original-From: Yu Kuai <yukuai@fnnas.com>
X-Lms-Return-Path: <lba+26902cff8+b3b649+vger.kernel.org+yukuai@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.168]) by smtp.feishu.cn with ESMTPS; Thu, 30 Oct 2025 10:39:51 +0800
Content-Type: text/plain; charset=UTF-8
To: "Kenta Akagi" <k@mgml.me>, "Song Liu" <song@kernel.org>, 
	"Shaohua Li" <shli@fb.com>, "Mariusz Tkaczyk" <mtkaczyk@kernel.org>, 
	"Guoqing Jiang" <jgq516@gmail.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Message-Id: <a203ac26-20be-4cd6-9969-860cf9878b94@fnnas.com>
Date: Thu, 30 Oct 2025 10:39:49 +0800
In-Reply-To: <20251027150433.18193-9-k@mgml.me>

=E5=9C=A8 2025/10/27 23:04, Kenta Akagi =E5=86=99=E9=81=93:

> For the failfast bio feature, the behavior of handle_read_error() will
> be changed in a subsequent commit, but refactor it first.
>
> This commit only refactors the code without functional changes. A
> subsequent commit will replace md_error() with md_cond_error()
> to implement proper failfast error handling.
>
> Signed-off-by: Kenta Akagi<k@mgml.me>
> ---
>   drivers/md/raid10.c | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)

Reviewed-by: Yu Kuai <yukuai@fnnas.com>
