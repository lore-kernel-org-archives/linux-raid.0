Received: from va-2-47.ptr.blmpb.com (va-2-47.ptr.blmpb.com [209.127.231.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973FB3597B
	for <linux-raid@vger.kernel.org>; Sat, 20 Jun 2026 21:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781990848; cv=none; b=Ipyye7ZvR7AsSYo8HIDa/c/1YpZfvbq7ZkgNRRQaJ2sMKotCUFXfBuAapY1tbFHRIYboExfKmmuqX8Gb2+u7I18t993MzcTj/Hi3z2cnFJCZyZI1f8T1ZHRVSsoR9hePR92ysvwshK9hUy2yc4HMNzTFGE4FX49vAd62ORZvqkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781990848; c=relaxed/simple;
	bh=1Zdoq37+7mdbMDJf1puhMUfO/zaPiaWwsEhC/NmnY98=;
	h=From:Message-Id:References:Cc:Mime-Version:In-Reply-To:To:Subject:
	 Date:Content-Type; b=oIPm8oWPr8k73bP/J9IjXdlP2Hg6FdN9IvwmRHPvO+0pli/PMxaUlJL+vyMqEXyT2ojGvTCMzGq6JeMQBMYq74mxScDXoBNd6Zbikj3eg1vjzzh6YxFFR2Wx7yCvpZ8zpZ0DKQdZJjpOrr6D9Ps/IwvFGEqZyNjwu671/XFoIqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=EVfcBZp6; arc=none smtp.client-ip=209.127.231.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="EVfcBZp6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1781990839;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=GB/igPnvyup6jjvYXaA4CVgWhMNWlCJWO5ThAOyPRCw=;
 b=EVfcBZp6klmFjOesMmC2l5QP3njtVnBh2VtooSHnmD8qzdinNV7K68INGcrABRZsSOwzM5
 HB9QxtbzapUTsPTVe7YK0A8+hLOM28VCARrnR9gpphr/q1l1fpippvJvJa0nUhswi2NFsW
 Q/WIGZOuVi7I7LsVVrv7wrIa91b7sA29H8XORgoqtI8n4ae3iiZBavRpY8Yj+XjKVV6bB3
 3CetIBRVQRTQyMO21myK9thcqw4VEzKnZ16L5wIWtqPn8imuq56jCtDyU7QTrM7XuJ6auW
 0+tfARVypSWAhRTAX8XpHbnEo9eDnZldWxaSdtSFyuxhTNqqnVopQaGImQHeYQ==
From: "yu kuai" <yukuai@fygo.io>
Message-Id: <0733d846-2eaa-4396-a807-d206b7ca60a4@fygo.io>
References: <20260618025735.915113-1-chencheng@fnnas.com>
Cc: <chenchneg33@gmail.com>, <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <20260618025735.915113-1-chencheng@fnnas.com>
X-Lms-Return-Path: <lba+26a3705b6+4423f7+vger.kernel.org+yukuai@fygo.io>
To: "Chen Cheng" <chencheng@fnnas.com>, <linux-raid@vger.kernel.org>, 
	<yukuai@fygo.io>
Subject: Re: [PATCH] md/raid5: let stripe batch bm_seq comparison wrap-safe
Date: Sun, 21 Jun 2026 05:27:14 +0800
Content-Transfer-Encoding: quoted-printable
Received: from [192.168.1.104] ([39.182.0.148]) by smtp.larksuite.com with ESMTPS; Sat, 20 Jun 2026 21:27:18 +0000
Reply-To: yukuai@fygo.io
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird
X-Original-From: yu kuai <yukuai@fygo.io>

=E5=9C=A8 2026/6/18 10:57, Chen Cheng =E5=86=99=E9=81=93:

> From: Chen Cheng<chencheng@fnnas.com>
>
> Once the 32-bit seq wraps, a newer bm_seq can look smaller
> than old, so .. covert to wrap-safe calculate way.
>
> Signed-off-by: Chen Cheng<chencheng@fnnas.com>
> ---
>   drivers/md/raid5.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
Applied to md-7.2

--=20
Thanks,
Kuai
