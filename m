Received: from sg-3-45.ptr.tlmpb.com (sg-3-45.ptr.tlmpb.com [101.45.255.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB13255F2D
	for <linux-raid@vger.kernel.org>; Sun, 19 Apr 2026 05:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.45.255.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776577434; cv=none; b=gmIrchl7CZYHUlygx4Lh/QSRUwAmVItD+PALbQYO2vArkz8NVZvHEd6pjO9McJtt8j8XNfOI5IdsB3swFA33A8kCQTPWk1OxE+vTNY2mvms/HMUupgv1tGmRqusdQ3820N38gHePSCU/DOc9NCQxsD8i1LGRuZyuOB2TgheOfxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776577434; c=relaxed/simple;
	bh=sG8uZdT4JSUekBmPa6OJFhEBusDE1BxpeuK+0BdP/xM=;
	h=References:Subject:Message-Id:From:In-Reply-To:Date:Mime-Version:
	 Content-Type:To:Cc; b=qsIjaboyQDppC/HEUy834ljlAqdEa6hVYDOqyYoWNCgS2QTW8joyi4DXxdvX1Jr+wS6q7xjp0bvstnZNDuKAeUR0gOD4vjgP0r0PdGhrXJRxsiqjwAamUZ+bf3BWU01cUBYjP33t6puF7e4HJ/lrcNVlxziKHZve2KOxDbCDMOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=oJaY8S/I; arc=none smtp.client-ip=101.45.255.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="oJaY8S/I"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1776577387;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=5VH2NoxTYDRBtinO5c2xTAnI0ukORwtztZEvNeeBcQE=;
 b=oJaY8S/Idlynn3aPOP+3j+vdYCnM0ka8QZe7L9unrqhPbK1vUuODnlFDy6ejwclzn5nf6J
 PHivEwq7WlcTS8lvIJU3Bus37g++uayFvLBiq5cD3ks6xgiDbQTyWC3pyAzIYpkmQAhQCb
 i9sifKh995EdzPzrPZQUmRDsAjqdwAFgmM6MFGOSFSR1HxDOaUGzfBqbdi/8RefyQ0AQrm
 heg2p9VyabdKbxcUoYgmgsrKW7MQG8jfbjwy05aodvqwk+p1x/NngxB4lLmntsM8omQxKX
 rm/Kn+n8iXcgiVQ06+MoDc6+ZcYwSV76hz8DBfwCqEW6SgJytwnddp6lxWbvvA==
References: <SYBPR01MB7881A5E2556806CC1D318582AF232@SYBPR01MB7881.ausprd01.prod.outlook.com>
Subject: Re: [PATCH] md/raid10: fix divide-by-zero in setup_geo() with zero far_copies
Message-Id: <beca1657-0180-4f9b-8de1-ca7776c9614a@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.144]) by smtp.feishu.cn with ESMTPS; Sun, 19 Apr 2026 13:43:05 +0800
From: "Yu Kuai" <yukuai@fnnas.com>
User-Agent: Mozilla Thunderbird
In-Reply-To: <SYBPR01MB7881A5E2556806CC1D318582AF232@SYBPR01MB7881.ausprd01.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Date: Sun, 19 Apr 2026 13:43:03 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+269e46b69+7574bb+vger.kernel.org+yukuai@fnnas.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Reply-To: yukuai@fnnas.com
To: "Junrui Luo" <moonafterrain@outlook.com>, "Song Liu" <song@kernel.org>, 
	"Li Nan" <linan122@huawei.com>, "NeilBrown" <neil@brown.name>, 
	"Jonathan Brassow" <jbrassow@redhat.com>, <yukuai@fnnas.com>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	"Yuhao Jiang" <danisjiang@gmail.com>, <stable@vger.kernel.org>

Hi,

=E5=9C=A8 2026/4/16 11:39, Junrui Luo =E5=86=99=E9=81=93:
> setup_geo() extracts near_copies (nc) and far_copies (fc) from the
> user-provided layout parameter without checking for zero. When fc=3D0
> with the "improved" far set layout selected, 'geo->far_set_size =3D
> disks / fc' triggers a divide-by-zero.
>
> Validate nc and fc immediately after extraction, returning -1 if
> either is zero.
>
> Fixes: 475901aff158 ("MD RAID10: Improve redundancy for 'far' and 'offset=
' algorithms (part 1)")
> Reported-by: Yuhao Jiang<danisjiang@gmail.com>

So again I can't find a report, and Reported-by usually should be followed
by a Closes link to the original report.

Applied with Reported-by tag removed.

> Cc:stable@vger.kernel.org
> Signed-off-by: Junrui Luo<moonafterrain@outlook.com>
> ---
>   drivers/md/raid10.c | 2 ++
>   1 file changed, 2 insertions(+)

--=20
Thansk,
Kuai
