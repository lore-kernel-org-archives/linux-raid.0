Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795233441;
	b=2+x2D53Jk3PTQCvyryduwp2Pg0vN6ImsTbDKINi9k4zmcE/QDSlR2wE8ReISExRidQ94
	 Tbv1YhiqX6RSJTcn29G/UnPizAyzLza50rIMNw6RZcDtUsqKAo29WH3nWqf9/m67Hzy+6
	 PubA/svebNa0BPcOBrX7+yWPUzS158w2KvDAE+ZcMkytHlW9XVkCxJAL+85XZ05Ke20ux
	 FBJLgCuyDwXQ+NXDKJ0wTBMfIY5UIA/imqriTdXD5UNGCTtszTX0jIEjVKEY4+qR5ERi2
	 nMtot0qQwxt/sgroO7xfxcWymCt5Am0TJRIBbBbCYueHeHedeCDcJ8qWM/rUA0ku76A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795233441;
	h=DMARC-Filter:DKIM-Signature:From:Message-Id:X-Lms-Return-Path:
	 User-Agent:References:Subject:Date:Mime-Version:In-Reply-To:To:
	 Received:Content-Transfer-Encoding:Content-Type:Reply-To:
	 X-Original-From;
	bh=ZK7OAS8yLy0R7OLa9rbaAIiJkcMNZo5CucExyd2a+gQ=;
	b=SRzbo+ArUlOBoGqtCEJmWeSaVA+ettkEGAtQ/2oqHusi3SGlSUj2C70qoO3ojtvMqQrj
	 b9PB/K6ofMjnJeS79HnIlheBx4dp2dacIyADxBleU9Buk6RP/vooeBDtwuJxkfUAyW9cB
	 YHZDbQv1R56+9hwZ806RjbRA6JHqr/UmIieEDHAtlEEUj8/BRhbEnr5Vu83sct6zAr3kJ
	 jZZeVrpJmi+9YqGceYp0FoREhMLfOA6EAFAr0rG5+CVg0moRSfjKcbt8AbN5sV8tKOWja
	 EUjLfAE4UVVe8urSlXgkrRzOviOLTipsUIohpK2ygRcbXV7r4iozCtczCFEjui8Mcug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=UgtUEweQ;
	arc=none smtp.remote-ip=209.127.231.45
Received: from va-2-45.ptr.blmpb.com (va-2-45.ptr.blmpb.com [209.127.231.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E716606A6BF
	for <linux-raid@vger.kernel.org>; Sat, 21 Nov 2026 03:57:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3E716606A6BF
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=UgtUEweQ
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1795233428;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=ZK7OAS8yLy0R7OLa9rbaAIiJkcMNZo5CucExyd2a+gQ=;
 b=UgtUEweQKIK5mR6/mFDZVZxUTXo/4QmYn9nC4+NbMgefZxJySZqZX/mn+ChN4rY5+NoWj4
 vB0urFlG+n/8fUlASzRZ6io+mPelhG8GpJca3sz+oHamHR/T86x9Td3HYINCY4dLf/2AvF
 ly3p6PSxXsqWdSfDv8g3YaeycWcAjkfzg2gEeZBkkx3Sd6yw3Am+h6FjjVcXZDGM3PhY7k
 +26309X1NXsMgKvJuYeHclxX3WiNSnhOmWQQC52+kRz3nVy0gBKj3DRrfcLa+Gw1XE44Yk
 xVMDBnUXWbXounVtK+O/JvvPn73qWRkPEenMZU+W6IMl/bzX2/0+v2t4TpDogA==
From: "yu kuai" <yukuai@fygo.io>
Message-Id: <9392ceb7-f883-4dcf-8668-35f5bb0eef7c@fygo.io>
X-Lms-Return-Path: <lba+26b011693+058d16+vger.kernel.org+yukuai@fygo.io>
User-Agent: Mozilla Thunderbird
References: <20261024220842.665158-1-bugfood-ml@fatooh.org>
Subject: Re: [PATCH v1] md/raid10: avoid resync when there is no room for redundancy
Date: Sat, 21 Nov 2026 11:57:02 +0800
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
In-Reply-To: <20261024220842.665158-1-bugfood-ml@fatooh.org>
To: "Corey Hickey" <bugfood-ml@fatooh.org>, "Song Liu" <song@kernel.org>, 
	<linux-raid@vger.kernel.org>, "yu kuai" <yukuai@fygo.io>
Received: from [192.168.1.104] ([39.182.0.159]) by smtp.larksuite.com with ESMTPS; Sat, 21 Nov 2026 03:57:06 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Reply-To: yukuai@fygo.io
X-Original-From: yu kuai <yukuai@fygo.io>

=E5=9C=A8 2026/10/25 6:08, Corey Hickey =E5=86=99=E9=81=93:

> From: Corey Hickey<bugfood-c@fatooh.org>
>
> RAID-10 allows creation/assembly with missing devices. If the maximum
> number of devices are missing, then a resync can do nothing--there is
> nowhere to copy the data. A simple example of this is a four-device
> RAID-10 with two devices missing.
>
> In this case, the kernel spends a while on a resync that copies no data
> at all. The time required for this can vary, but takes ~3 minutes for a
> 4x1TB RAID-10 on a Ryzen 7 7840HS, for example. Meanwhile, /proc/mdstat
> reports nonsense values for finish=3D and speed=3D.
>
> md10 : active raid10 loop1[2] loop0[0]
>        2147219456 blocks super 1.2 512K chunks 2 near-copies [4/2] [U_U_]
>        [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>..........]  resync =3D 52.2% (112=
1300864/2147219456) finish=3D96179868.0min speed=3D0K/sec
>        bitmap: 16/16 pages [64KB], 65536KB chunk
>
> Neither RAID-1 nor RAID-5 do a resync when there are too few devices.
> For RAID-10, Add a check that avoids the resync when possible. This
> matches an equivalent (but more simple) check in raid1.c.
>
> Link:https://bugzilla.kernel.org/show_bug.cgi?id=3D222085
> Link:https://www.reddit.com/r/linuxquestions/comments/1lh9to0/kernel_is_s=
tuck_resyncing_a_4drive_raid10_array/
> Signed-off-by: Corey Hickey<bugfood-c@fatooh.org>
> ---
>   drivers/md/raid10.c | 4 ++++
>   1 file changed, 4 insertions(+)
Applied

--=20
Thanks,
Kuai
