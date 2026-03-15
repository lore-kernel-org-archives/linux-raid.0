Received: from va-2-38.ptr.blmpb.com (va-2-38.ptr.blmpb.com [209.127.231.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78C93750B5
	for <linux-raid@vger.kernel.org>; Sun, 15 Mar 2026 17:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773594725; cv=none; b=B2CM8+LDjGWJkg9HxXPu2og/ec8KP5xZ4qSEprB7Zj5V7JpGfpPL7Yj20x6mg6fAkF+0+6QT3VHsheKLJKiuP1hi4Cao6QnfVrxHUm5zxjX1ynob+CiOvZ2buivIo6EL+tZHzGcAq4E1nazETS+YBjG4zN0/DZC0O39BazI/yBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773594725; c=relaxed/simple;
	bh=E1j494bVW/W0u8q446ODoEzoVrS3ceas8wBNjvazHFI=;
	h=Message-Id:From:Date:Content-Type:To:Subject:Mime-Version:
	 References:In-Reply-To; b=S/D+X7KzZONiXHrCwcyVSpFuJgucVN6CCbSfc5TXjOZQaWMsxzrqSlvmQI36GKrPKB6bYMrV6igFZI8coG/dUM9yaXz6SdMkplEO7b/ErCRtFmghk8ACxOjlSNjSP/8hqoEv6s+yCRQUBfnh1rPxCuMfAr6LxTJbx7V0exVufik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=GAM4DYit; arc=none smtp.client-ip=209.127.231.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="GAM4DYit"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1773594718;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=E1j494bVW/W0u8q446ODoEzoVrS3ceas8wBNjvazHFI=;
 b=GAM4DYitB6CmPGVVhx0n2E4xqllxq0d/du0UZMvrDCyW0sQHGFGj8pOcpdFI3pZ0hYEYLB
 j4La8hIWRwL6Qyib9PF1LvuoA7dbAMLeXTAvNlblGE8IMQ+NRyF/gP/V1FCw+AHCDlwB5U
 q3mISnUEPD0UmMZHg9jDYMcXhlPfCH6ScgE54eXmoTHjDS2ndUaRohtIFQOywTm1yQnGGV
 1pdthWUPGAgsPXioFDty0aNMr4cSwFzFfTFrMas0plY5aer66/WgJhy/zMLfMroNcy4d45
 TTEAaGIMcLIudwgdaWspI/d+F92yPizGxjswS/1VpSYjroYt+h9SWwA86LsjqQ==
Reply-To: yukuai@fnnas.com
Message-Id: <45fbc816-f385-462a-b339-836218e46958@fnnas.com>
Content-Transfer-Encoding: quoted-printable
From: "Yu Kuai" <yukuai@fnnas.com>
Date: Mon, 16 Mar 2026 01:11:54 +0800
Content-Type: text/plain; charset=UTF-8
To: "Anton Gavriliuk" <antosha20xx@gmail.com>, <linux-raid@vger.kernel.org>, 
	<yukuai@fnnas.com>
Subject: Re: md-raid support 50/60 & spare space support
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from [192.168.1.104] ([39.182.0.175]) by smtp.feishu.cn with ESMTPS; Mon, 16 Mar 2026 01:11:55 +0800
User-Agent: Mozilla Thunderbird
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Content-Language: en-US
X-Lms-Return-Path: <lba+269b6e85c+dc2018+vger.kernel.org+yukuai@fnnas.com>
References: <CAAiJnjrPXEdgt5U5=13e62z4Vw=UzPaSZO8NpoqAoNV2+KQSTQ@mail.gmail.com>
In-Reply-To: <CAAiJnjrPXEdgt5U5=13e62z4Vw=UzPaSZO8NpoqAoNV2+KQSTQ@mail.gmail.com>

Hi,

=E5=9C=A8 2026/3/6 19:17, Anton Gavriliuk =E5=86=99=E9=81=93:
> Hi
>
> Are there any plans to add support for md-raid 50/60 ?
> Maximum recommended number of disks for single raid5 shouldn't exceed 8.
> So raid 50/60 would be very useful for systems with 64-96 disks.

We're probably won't invent a new raid 50/60. BTW we're working on performa=
nce
improvement for large raid5 arrays for at most 64 disks, results looks grea=
t.
However, it might take sometime before we push our work to upstream.

>
> And also any plans for spare space support (instead of spare disk) ?

Can you explain more about spare space?

>
> Anton
>
--=20
Thansk,
Kuai
