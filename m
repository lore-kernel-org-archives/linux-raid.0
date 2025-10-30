Received: from sg-1-12.ptr.blmpb.com (sg-1-12.ptr.blmpb.com [118.26.132.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1539F1D86DC
	for <linux-raid@vger.kernel.org>; Thu, 30 Oct 2025 02:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761791915; cv=none; b=U8p7GBBV7LQ44WpIBQJKmbpPtoOi5HzRRM5ru9nOKRbpEl9b5wUFaRl9zvcB6UopFi0I5lvxJZOWM+C4WIIOf6rpGMe/Hh0jMVgL18Sz0QByIx/+KiXC73Xj4/Pp3bc2bTNV5YpqqKk6xzN8zC2aMUCATdWgbJc3RuXNxI0O5kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761791915; c=relaxed/simple;
	bh=R46gAfYqiumCaJuLQEZh8TtWDQSw3Y4UhfsvsmheOR0=;
	h=References:Content-Type:Message-Id:Cc:From:Subject:Date:
	 In-Reply-To:To:Mime-Version; b=hzZQAfnhzLA62u9g3veGcDZ+NNUDedepwcjl3gfpRFgq6X8izu6ki2VcbJglySWxK4DgeOk95+0+Kb8wC26kZDRWYjNrgMWa6hKovsCeQgl6ic6x+CEhanklUmXYhCqHqllNZC15WLcPwv9L0wYpPyGwUPWrq6HmUbImuX2EPsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=O/ujQBaV; arc=none smtp.client-ip=118.26.132.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="O/ujQBaV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1761791907;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=F/iiLAqBGyZrI9cveUzgHIKgMnlZPCL+4OeqwYcGXF4=;
 b=O/ujQBaVzqRSY8M0wTx7s/4a7waZxSnGb7rDGw6EfKtGDNcCEoZSKiOi4pB7z3Ceu+UFyI
 BSCyHuZD178hQzrovBECTp/klj9FxqenFu4ut7SVdq5kV8H0Pjz/EINiyhkjCQjyzkMZqt
 Nv0UqK7kamzCu2psRqptS1g8LwefON3atlEv1pGSP4sHRXx3DV5RSHGpictFbBeQPQgKRp
 mxGyCLpWd/q1YrzBK84ZxNavpD8TNKWf89AY9tWZqrjHm8nB6t53igZzRsFMD0UzMOBDSA
 A5+QS+ijGIiGTPpuniKqhB9l4BCmyqV+c4EKEHrbiyUbG6a2BH3nr3xqSMQJFQ==
User-Agent: Mozilla Thunderbird
References: <20251027150433.18193-1-k@mgml.me> <20251027150433.18193-8-k@mgml.me>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26902cfa1+f2f8f1+vger.kernel.org+yukuai@fnnas.com>
Message-Id: <40543443-02b8-427f-9fd9-3489b975d969@fnnas.com>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<yukuai@fnnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Subject: Re: [PATCH v5 07/16] md/raid1: refactor handle_read_error()
Date: Thu, 30 Oct 2025 10:38:22 +0800
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20251027150433.18193-8-k@mgml.me>
To: "Kenta Akagi" <k@mgml.me>, "Song Liu" <song@kernel.org>, 
	"Shaohua Li" <shli@fb.com>, "Mariusz Tkaczyk" <mtkaczyk@kernel.org>, 
	"Guoqing Jiang" <jgq516@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from [192.168.1.104] ([39.182.0.168]) by smtp.feishu.cn with ESMTPS; Thu, 30 Oct 2025 10:38:24 +0800
Reply-To: yukuai@fnnas.com

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
>   drivers/md/raid1.c | 14 ++++++--------
>   1 file changed, 6 insertions(+), 8 deletions(-)

Reviewed-by: Yu Kuai <yukuai@fnnas.com>
