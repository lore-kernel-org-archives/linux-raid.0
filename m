Received: from va-2-36.ptr.blmpb.com (va-2-36.ptr.blmpb.com [209.127.231.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC71F3101C8
	for <linux-raid@vger.kernel.org>; Tue, 28 Apr 2026 08:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777365170; cv=none; b=EuJmpTz8QVq8TrroOOYeD5kgjbDwgkscoNQFRgX9cUlS6P2Z5rhiXpj6ZhnbkiwPIJ0Y89xa17tGMO+jvv/gepHQOpMLGE0hGaoZr3gpmC82oU0jd71UytmsOQ2smWCpiKeY84cUW+9/qkQpKDeVTqer8oTpwn9/W2x0dF6Y3I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777365170; c=relaxed/simple;
	bh=pIHABbnrYjWnvGwVzXPoI/1xvnAjltrRfmLWH7wlwzU=;
	h=Date:Message-Id:Mime-Version:In-Reply-To:Cc:Subject:References:
	 Content-Type:To:From; b=Tq4wuvXFNL6s+gtF6Im1F5o/SJ3k+4xk1oPzhpjeipBzQmLwQNimiLqxu3RXbAZ6N+dz4GkTX+iTPMr6PdBTuggKuqUlShFqdRiKH+0ynSk+S/ketolbop6g6f5ZFQDSkiKO52o3USVm0K02WhYeZSKnvGAHe09kuNiuTa8N3PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=unl/eBBR; arc=none smtp.client-ip=209.127.231.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="unl/eBBR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1777365159;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=BLxleqeaahmG3ULXVbRao6S+XTlDw3HS+ySLo7Slhn0=;
 b=unl/eBBRnYMyZHpS7qeIXppSb/qpiNdntf5Efnq+78WRHqSR7V2OPb/uaUgTy5GsLJDjl4
 P/KTBgN+ExPio6qwMlZdjYeR6zj3oFRMgDJsZrts5KeLMfIOIQ8Is5hamATsIQRNpbkubH
 5cBdu+cZ/RVXf8XGUcNFvBBi+ULUlTmJgk+agScs6X8DgmfiMaU67EPSUp7YF5ek5hzerz
 iYuLOqvgHi7gUgfxFgz3aZcScBpO+1n4otom2QD0QEKKupSuY/hsdwIVQLyp59yEeJa5II
 bo/u0sCO3cwnFq40XFSvbjfUVyo0/GAnzkFiwdBq+2WS4PUHlmkhiGqPjK+Y4w==
Date: Tue, 28 Apr 2026 16:32:33 +0800
Message-Id: <282278bc-7d71-4049-89f4-a9f3968504dd@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from [192.168.1.104] ([39.182.0.183]) by smtp.feishu.cn with ESMTPS; Tue, 28 Apr 2026 16:32:35 +0800
In-Reply-To: <CAHYQsXRN6uof4yyDR6qGteQ=wZTt86VUx7km6k=LbNAQ3wxGiQ@mail.gmail.com>
Reply-To: yukuai@fnnas.com
Cc: "Junrui Luo" <moonafterrain@outlook.com>, "Song Liu" <song@kernel.org>, 
	"Li Nan" <linan122@huawei.com>, "NeilBrown" <neil@brown.name>, 
	"Jonathan Brassow" <jbrassow@redhat.com>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>, 
	<yukuai@fnnas.com>
Subject: Re: [PATCH] md/raid10: fix divide-by-zero in setup_geo() with zero far_copies
Content-Transfer-Encoding: quoted-printable
References: <SYBPR01MB7881A5E2556806CC1D318582AF232@SYBPR01MB7881.ausprd01.prod.outlook.com> <beca1657-0180-4f9b-8de1-ca7776c9614a@fnnas.com> <CAHYQsXRN6uof4yyDR6qGteQ=wZTt86VUx7km6k=LbNAQ3wxGiQ@mail.gmail.com>
User-Agent: Mozilla Thunderbird
Content-Language: en-US
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8
To: "Yuhao Jiang" <danisjiang@gmail.com>
From: "Yu Kuai" <yukuai@fnnas.com>
X-Lms-Return-Path: <lba+269f070a5+597f3d+vger.kernel.org+yukuai@fnnas.com>

Hi,

=E5=9C=A8 2026/4/19 13:59, Yuhao Jiang =E5=86=99=E9=81=93:
> Hi Kuai,
>
> This report was reported by me, so Junrui added me as Reported-by.

This is fine, however, please do not add downstream reported-by tag.
If you want to add the reported-by tag, please report the problem to
patchwork first. :)

>
> Thanks,
>
> On Sun, Apr 19, 2026 at 12:43=E2=80=AFAM Yu Kuai <yukuai@fnnas.com> wrote=
:
>
>     Hi,
>
>     =E5=9C=A8 2026/4/16 11:39, Junrui Luo =E5=86=99=E9=81=93:
>     > setup_geo() extracts near_copies (nc) and far_copies (fc) from the
>     > user-provided layout parameter without checking for zero. When fc=
=3D0
>     > with the "improved" far set layout selected, 'geo->far_set_size =3D
>     > disks / fc' triggers a divide-by-zero.
>     >
>     > Validate nc and fc immediately after extraction, returning -1 if
>     > either is zero.
>     >
>     > Fixes: 475901aff158 ("MD RAID10: Improve redundancy for 'far'
>     and 'offset' algorithms (part 1)")
>     > Reported-by: Yuhao Jiang<danisjiang@gmail.com>
>
>     So again I can't find a report, and Reported-by usually should be
>     followed
>     by a Closes link to the original report.
>
>     Applied with Reported-by tag removed.
>
>     > Cc:stable@vger.kernel.org <mailto:Cc%3Astable@vger.kernel.org>
>     > Signed-off-by: Junrui Luo<moonafterrain@outlook.com>
>     > ---
>     >=C2=A0 =C2=A0drivers/md/raid10.c | 2 ++
>     >=C2=A0 =C2=A01 file changed, 2 insertions(+)
>
>     --=20
>     Thansk,
>     Kuai
>
>
>
> --=20
> Yuhao Jiang

--=20
Thansk,
Kuai
