Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BFE36AB46
	for <linux-raid@vger.kernel.org>; Fri, 27 Mar 2026 09:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774604517; cv=pass; b=YulyYeZkKxNp/SuTmq6a0inrLsxz8ZU/+i7FqrFFMUpl8ywl3ntWpmF8enhWFSgq1O2gXs/BPsYoazmBxhatgcAghwqMGzmGj9Lsg+l9VTOB7iGSd5r308/0H5F3GWUQtG3Al5LIFtedBiUUykG1WKVCPTdn6nRFU+cLRflYHoc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774604517; c=relaxed/simple;
	bh=O5SHb5d2wtHlhsINITOyWdOmpvs/XBQKNAPJKGRE0yI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gdWrSQQkYof8oimYFoVD67y35ZDYAUrZHYXLi5AhHNXVgietVj3fjzf6DITyaohXDGYXPwd7CnArDdhLranbPeDBPQ4j8itp9wkSwhUuo6AJRiwtRxmDvhZw4QWB2RU2fqzWAeHaQqLn8aYjvut+Sr2HJxNQ8nODwoT03nIPHgI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sB31WOBW; arc=pass smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sB31WOBW"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b9358dd7f79so337585966b.1
        for <linux-raid@vger.kernel.org>; Fri, 27 Mar 2026 02:41:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774604514; cv=none;
        d=google.com; s=arc-20240605;
        b=FthXnTHaVMl2syN1g596ngtAWsoiFCLb3OPb7n7Ek+39r3dAmtebCS0+7x466A5FcT
         5iPkR4UFCQ6xYh7FoZc4oSpebf4aDSCo66UxmMcPrKBeAD0IZMa65boh1Sx8+tGK1T2i
         eUCzmXsghd+0APwGNwq6bmdsneTSZ91GDifp6hWKI4JJ/025T+dH8KiZzni5e1lQbWcQ
         BnSuf0od/gb/sm6yLiMtdFhip9t4mfYZpBbfme1MpOfqpj8RHETrIWP2Js14MmfuXOqw
         4eItmLKFSzaL3vr2d92TaI8MDK15JZDwn4unZCmMCpvV150qxprlvpp+TuQwgjkM/udE
         idNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=O5SHb5d2wtHlhsINITOyWdOmpvs/XBQKNAPJKGRE0yI=;
        fh=JDpdfeLFVSyJeHOrbJpt1/m5yNhxxkSPGxP7XqBnm1g=;
        b=BJFx3zIF1HNPVWTVam/xhPND7czF0mXChBx+tdfDq4VkW8srMxdJxlYL1UDQRvy+gH
         f7DjQFo5gVnynk3A0ljob5adeY8GpPnvQTYIVIsfATRoLCIZ+7a4us58/7HYLBj4ocb5
         wMRXJOyb4R0UnOUGHsvOXvyY3DyCOfbqbWoIMFybPpBc0zxTzJByTMWaiG/Cu6t/Nvhq
         UZeBhOrjq91TxF6uXaTLkquAp3WIF0qrv4/YLKSWxPibniSUVyjZur4J/p7agmaBucE9
         G2q++nc6rIl+Bi/nc4I1xuIAPMrqS8+fwGtl6d3oQMWvxDJdIof976+VBMJTmuSFAU/R
         xYmw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774604514; x=1775209314; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=O5SHb5d2wtHlhsINITOyWdOmpvs/XBQKNAPJKGRE0yI=;
        b=sB31WOBWjrSxlW98slA2SfD5eXs3hdpMG4vUBkX2sxRhCLAxg7w+Dix9vIm4hzQO8J
         ItSGsOPQMCOWXzthwBWZUoO+QdvxTvUqf0nozE+oBJBzTZaT3zLIvmGqIunfIFxRVRZR
         7N2dEWe3x5LUL/DYk5KnZUBD1DfeWkpKDpEvSXqL26NSYymt8xCC/nBrjWTioR9gqrbH
         Ka8nINV7kqDHxMfmlzlgruJXS6hMkgRCb9wIr0Q4W3Hm3RUJhCd2z0cIjTcQwwJviJeU
         edDg6k2JH7/cQQeHWDWoVmQSN7fHMo9De2zuijWd94yaBFxJJC1ty6aGbM7tJAco/rkg
         QVUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774604514; x=1775209314;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O5SHb5d2wtHlhsINITOyWdOmpvs/XBQKNAPJKGRE0yI=;
        b=h4xvLLMm44t+qPLgnIZZZXkhiYJpWr9zOxSRFQpIFoZCHFb/Zsd9gFDTe0ETtH7ZiQ
         fxwU052Sq91ob9LBY80T1NcZnkwmrsv7s++u/Vqzo9lwHU/ztP5v0ymYRIfguoHuZbHz
         8wDRKhnoct2phPnkuuo7CegQXBVe9nHGPkZDibqmD1h0ptumCDBROJHB3bASiADErb7O
         LolGA2lKIjojn/Q8qGGxrdzkimPLzsNQYYGHI3I4YRgqvxB+96391dugdT/zTZEqIcXF
         a77+oNrl3RFgy0XMLDtrQk4C4BO1+VDd7iv73zR6U1CZG1nlRpIbeaHRxK9W/EoGoBKQ
         7yvg==
X-Gm-Message-State: AOJu0YzXYa2utgS/UTSsovYL2tPZ0JKpZCfaUk+kVNIk+on9uaUWthp2
	QYe5szcPhncyr1Svv0u6iMf1/AhzMcryUd7AmAhd4tDcpI29hDoXjBUxSYOsNvRx7UOZmsgM6Bl
	zM2d7vLR9MvrSgshQkxrb0LYjTXVBM+PM1CN6
X-Gm-Gg: ATEYQzz+7ksl9MQQW7gEFW0EtR3XETtz8aTBnnENDF4gbzIJ0X6yp0FAAtXEFwfvDTS
	xQS7GB97gtip5o1UsOuiBO3NhAgb3hkRwaOfyRUc66hN/ePPzigUTAzD2JewnPihdA2zPOOT1dw
	ZhoS/C1d8RhKvuVQbsjBq1mEp6xCzCyz2EBX2fAdnCQ2caFC07OOwUehI1KE4v9K+MNbgB8gRzC
	M6yp96wud3nZSMmeZcoZlF2QxeUi84GSYjSQr21e5Gh7h/YTdjZuLjybHa8l3hwo8nTI/5ruMTt
	/1459ZYpqwnymC+n9n0=
X-Received: by 2002:a17:907:3e97:b0:b98:b51:6f51 with SMTP id
 a640c23a62f3a-b9b507a58c4mr130160766b.35.1774604513924; Fri, 27 Mar 2026
 02:41:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAiJnjrPXEdgt5U5=13e62z4Vw=UzPaSZO8NpoqAoNV2+KQSTQ@mail.gmail.com>
 <45fbc816-f385-462a-b339-836218e46958@fnnas.com>
In-Reply-To: <45fbc816-f385-462a-b339-836218e46958@fnnas.com>
From: Anton Gavriliuk <antosha20xx@gmail.com>
Date: Fri, 27 Mar 2026 11:41:42 +0200
X-Gm-Features: AQROBzBx_kOIeU5IK4N1abXtT3DxI1RBdIcHoZX1IGcnynIpiT5x13FDwFI_cAE
Message-ID: <CAAiJnjpJstjnDOFvgjmAX5kbgmSnNFGD9U6eMgcCDmSS6LV5RQ@mail.gmail.com>
Subject: Re: md-raid support 50/60 & spare space support
To: yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi

> We're probably won't invent a new raid 50/60. BTW we're working on performance
> improvement for large raid5 arrays for at most 64 disks, results looks great.
> However, it might take sometime before we push our work to upstream.

That's great.
Raid5/6 needs to be improved for keeping PCIe 5.0 NVMe SSDs
performance. Just like your lock-less bitmap :-)
I have some PCIe 5.0 CM7-V NVMe SSDs.
So I would be glad to assist you in testing if required.

> Can you explain more about spare space?

I meant distributed spare capacity, instead of dedicated spare disks
(standard hot spares)
As far as I understand, now raid5/6 does not distribute "spare blocks"
evenly across the entire array to allow for the massively parallel,
high-speed rebuilds.

Anton
