Received: from va-2-35.ptr.blmpb.com (va-2-35.ptr.blmpb.com [209.127.231.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0AE03B7A8
	for <linux-raid@vger.kernel.org>; Sun, 22 Mar 2026 18:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774204392; cv=none; b=Bg64kLkuVWylwat1Mp+apEgT6OrgTWPSONClIpLXDuhcELAj0+RhZnGlDRQk1GUHvSxHp/uGr4qPHphLw94QnW8Uut37B+vHlphWhzPItndjDpp1xRXpnA4vo4CQtMJNu6oS9yWh01qGaIe0mNVU/TB/b7a3m2neGGdKLwkGG9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774204392; c=relaxed/simple;
	bh=ymzd+sQlerKiwMRwsSKj0BlSunH8eqCcv4UR9qpENKI=;
	h=In-Reply-To:Mime-Version:Content-Type:To:Message-Id:Date:
	 References:Cc:From:Subject; b=Bol1QpnokBFfESa9WmXQNNZNlulIdHyXwj8RfRPalU8eR6Gei/vUfZbp5Rn3VrkDPrLOS+HoYEhqLvEUKcl1wtnuLFYb8zU7agwuXyTR+aczBOg+QWRC57NyvJhyWObyGIN2+xmV8IGBti8qnfhedr0942bLaNT27lJJ6S53De0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=DJgYiSFk; arc=none smtp.client-ip=209.127.231.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="DJgYiSFk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1774204380;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=axTLgALXnCSaCMhPGVMwUoKM8lB14h0BNCbBuawD4IM=;
 b=DJgYiSFkn9bln6DvI74SH7Do2/z0c1CRzKCEKxtlJNJiWlfW+x+MdRJ4ZBFvHZN98txG0C
 XtQhwO9513HNw2vBsf15/4oi2VC4cwjtfk35y07ImV7q2ol+ALZNNn0FVD6iZV2zkeZiJL
 9mibsdElSdeRD0V1Gpk9P0wIxfQuGw7UEW+KNk8fbyzhkqzg7d1V3/g3cOhz1KYfV03/Y1
 r2lBxNI06M91W2ScEpSZXMrv4fEuWDE8cjHiUfg452ivkQ7G7Wrf68+OtL0sKzl+ebCWWB
 TvOPNYzPppRz/Ka9RS7ZnhYyOpeMhPptUQefKh2UTysnCPYGQX1vUM6n7BeC6w==
X-Original-From: Yu Kuai <yukuai@fnnas.com>
In-Reply-To: <20260304110919.15071-1-chencheng@fnnas.com>
Reply-To: yukuai@fnnas.com
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from [192.168.1.104] ([39.182.0.158]) by smtp.feishu.cn with ESMTPS; Mon, 23 Mar 2026 02:32:57 +0800
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
To: "Chen Cheng" <chencheng@fnnas.com>, "Song Liu" <song@kernel.org>, 
	<yukuai@fnnas.com>
Message-Id: <e0b1b4a0-af72-477e-9eae-fa0348c3f783@fnnas.com>
X-Lms-Return-Path: <lba+269c035da+e9f8a1+vger.kernel.org+yukuai@fnnas.com>
Date: Mon, 23 Mar 2026 02:32:55 +0800
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: quoted-printable
References: <20260304110919.15071-1-chencheng@fnnas.com>
Cc: "Li Nan" <linan122@huawei.com>, <linux-raid@vger.kernel.org>
From: "Yu Kuai" <yukuai@fnnas.com>
Subject: Re: [PATCH 1/2] md/raid5: remove stale md_raid5_kick_device() declaration

=E5=9C=A8 2026/3/4 19:09, Chen Cheng =E5=86=99=E9=81=93:

> Remove the unused md_raid5_kick_device() declaration from raid5.h -
> no definition exists for this function.
>
> Signed-off-by: Chen Cheng<chencheng@fnnas.com>
> ---
>   drivers/md/raid5.h | 1 -
>   1 file changed, 1 deletion(-)
Applied

--=20
Thansk,
Kuai
