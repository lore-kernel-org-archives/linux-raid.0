Received: from va-2-28.ptr.blmpb.com (va-2-28.ptr.blmpb.com [209.127.231.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE1E9371CEC
	for <linux-raid@vger.kernel.org>; Sun, 19 Apr 2026 04:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776572759; cv=none; b=VzvmBo3J9CX3n7378W/EN7iHxCMNzvw5MUbrp1x3VyLJc15r1DajhcppujyA+T/b5Npz5E1u6QnOpdq3TmAA9w1gcUHnTRo1pjPL/OAfq2fZlmdqlR+CkMVwGTqK/PqKCe7cqPwmNN5cndP4hClZ/NoRWQhVqUH0dgvIkTUD8kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776572759; c=relaxed/simple;
	bh=DxHjym7ItzVVJURruzc6jUJmnZ2GWkGiwdlZmFdPRRM=;
	h=To:Date:From:Subject:References:In-Reply-To:Cc:Message-Id:
	 Mime-Version:Content-Type; b=TYPhpKs+WfdMUplgIRDt8WRagM8iNBKsBQi1V3juMUKOUOoMDJ6aLweqI/5Z6zrHd19wIZnyB4V04XK749OeRFaslpwVCF+g/irSjIUwkyfdFHmzIVltW5czQNqBJjn/6wRitaXDvptwWHtroLyJJHxvy0ZVUyoBulHXjb8UQas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=jxFxMRK3; arc=none smtp.client-ip=209.127.231.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="jxFxMRK3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1776572632;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Dmfbzy9tYE/eC34uoO9gEE3rVxKXdrK4zrCf1UaVEOY=;
 b=jxFxMRK3tGrFkasAly5QjZFPuhZBj9rmXxZtb/u9465pTp1jkE6mOTHFjhSvcqTYMYJkFF
 tzFdMHanWPLZ4Uf82+uUm8UUAE5vyj+zv3eeuwmfq345VTvA0GaMZmWcSqLG4GhzIW/HMK
 w/S6lIvFTODMbCSguS043o1OVPy0mUzk+B9dKnEOYpmNvUblu8eQfDsxs4Oo3rKj4mL0ym
 qQ/OUxQONwmwTIepsgM3M8dbtTAa2AID0TSYspYTdaqiKYrw9Cr2/dwGuEw6w3ybLIjlQS
 NEmFMFBDOxcxeKtl3paVD70s7Jy9TShsfqCBCPYKUHVELeXjomrrBe6UvS+gFA==
User-Agent: Mozilla Thunderbird
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Content-Transfer-Encoding: quoted-printable
Reply-To: yukuai@fnnas.com
To: "Xiao Ni" <xiaoraid25@gmail.com>, <song@kernel.org>
Date: Sun, 19 Apr 2026 12:23:48 +0800
X-Lms-Return-Path: <lba+269e458d6+bebf2c+vger.kernel.org+yukuai@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.144]) by smtp.feishu.cn with ESMTPS; Sun, 19 Apr 2026 12:23:50 +0800
Content-Language: en-US
From: "Yu Kuai" <yukuai@fnnas.com>
Subject: Re: [PATCH 1/1] MAINTAINERS: Add Xiao Ni as md/raid reviewer
References: <20260414022956.48271-1-xiaoraid25@gmail.com>
In-Reply-To: <20260414022956.48271-1-xiaoraid25@gmail.com>
Cc: <linan666@huaweicloud.com>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <yukuai@fnnas.com>
Message-Id: <99a06cab-e83c-4cf4-81d7-7e414a27a198@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8

=E5=9C=A8 2026/4/14 10:29, Xiao Ni =E5=86=99=E9=81=93:

> From: Xiao Ni<xiao@kernel.org>
>
> I've been actively involved in the md subsystem, contributing bug
> fixes, performance improvements, and participating in code reviews.
> I will help improve patch review coverage and response time.
>
> Signed-off-by: Xiao Ni<xiao@kernel.org>
> ---
>   MAINTAINERS | 1 +
>   1 file changed, 1 insertion(+)
Applied

--=20
Thansk,
Kuai
