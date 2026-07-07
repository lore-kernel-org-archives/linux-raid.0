Received: from va-2-52.ptr.blmpb.com (va-2-52.ptr.blmpb.com [209.127.231.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C0B2F7EE4
	for <linux-raid@vger.kernel.org>; Tue,  7 Jul 2026 01:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783386782; cv=none; b=Qi0k5JJUrDLHEbBLkMdo9yAy6I+rw07DS8whNRQ8r53LARx8W8hk0apfRPxJRfw9ejA/WBElRUes3AFOZHPH8NV0f9s2zCUHeVcT1HtRfdia5YOgnb8lcGKsokhTTC15LNmi4tuYaZqqoAaVQObgBYO6bWs9rcTuYsXm1O/TLTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783386782; c=relaxed/simple;
	bh=0Wnug118WIeak9+fNGgu7t9xJzjXOQ70oKEw/FCxW6k=;
	h=In-Reply-To:To:References:Subject:From:Date:Mime-Version:Cc:
	 Message-Id:Content-Type; b=RmYMv9hwMPRp99YZo6tMZ0KxU6gFW3HhVYrD4oq5wsQJqeeUsU9vsACO9stax8FkihluHQgddHchXmJm4bwQksdpTYQOSOv0PiH+/OphEY6+gVmrJY0pPiRFplsZbEpteZKk38+Vrp1dDMWNG3NOOvnBlAP+YgodRcFmBLI90zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=nXPfJGSJ; arc=none smtp.client-ip=209.127.231.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="nXPfJGSJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1783386767;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=0Wnug118WIeak9+fNGgu7t9xJzjXOQ70oKEw/FCxW6k=;
 b=nXPfJGSJrTLjILv/FDIcZlxkMeyL7H5peOBPD/orm/9NF/YBTExti5l4PvK5sioyeiM4+3
 NxqEK1yHKmM01EHwvh4Qo/forIbr4ja/qFD9dKD8HFntJs/JHMR8tSK/B4DZE50+P1E+zw
 VrWZ0lAKCpZgQl2gqY9BGs5KeUTFINEObDJuv6DafUEHtfnfGc8yWoFIXHojB3U8FFIvzb
 kWvEYhMT6cv6dyTASF1kgW8tHKTBEmD3i4hkie097YgvKlfv4Jk2SqdVLH+U+UjsZuRrxR
 xHYMQ9sgK+7/Vv9PfQp/oylblqunemjxi+PzVsn+3FnhhzgKXCK07KTBYgHdvg==
X-Lms-Return-Path: <lba+26a4c528f+796846+vger.kernel.org+yukuai@fygo.io>
In-Reply-To: <m2se5x6wff.fsf@gmail.com>
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>, 
	"yu kuai" <yukuai@fygo.io>, <song@kernel.org>, 
	<magiclinan@didiglobal.com>, <xiao@kernel.org>
Content-Transfer-Encoding: quoted-printable
X-Original-From: yu kuai <yukuai@fygo.io>
References: <20260630075640.1081634-1-abd.masalkhi@gmail.com> <0a7dc7e2-30af-44de-8c29-b6e27a62fa55@fygo.io> <m2se5x6wff.fsf@gmail.com>
Subject: Re: [PATCH] md: avoid modifying spares while the array is not suspended
From: "yu kuai" <yukuai@fygo.io>
Date: Tue, 7 Jul 2026 09:12:43 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	"sashiko-bot" <sashiko-bot@kernel.org>
Message-Id: <4f0b2516-65bd-41fa-abc3-3cd76951ec46@fygo.io>
User-Agent: Mozilla Thunderbird
Received: from [192.168.1.104] ([39.182.0.144]) by smtp.larksuite.com with ESMTPS; Tue, 07 Jul 2026 01:12:46 +0000
Content-Type: text/plain; charset=UTF-8
Reply-To: yukuai@fygo.io

Hi,

=E5=9C=A8 2026/7/6 3:58, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
>> The problem looks real, however, I think this will cause a change that u=
ser will be awared,
>> if there are really spares that can be removed from conf, but array is n=
ot suspended here,
>> user will still expect rdev will be removed from conf automatically.
>>
>> In md_start_sync, if suspend is false, can we check again after mddev_lo=
ck? If suspend is
>> supposed to be true, we can release the lock and retry with suspend =3D =
true.
>>
> Yes, I see, and your approach is much better. But what do you think
> about taking the lock first and then checking only once?

I don't get what you mean. If we take the lock and then check that array sh=
ould
suspend, we still have to release the lock before we suspend the array.

--=20
Thanks,
Kuai
