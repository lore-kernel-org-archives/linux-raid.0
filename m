Received: from sg-3-41.ptr.tlmpb.com (sg-3-41.ptr.tlmpb.com [101.45.255.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F8F1C84A0
	for <linux-raid@vger.kernel.org>; Thu, 30 Jul 2026 08:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.45.255.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785399075; cv=none; b=DYS9j/l1ThZ88+zBEhpwzCML+EFdDtfanRF0/NSPGfHKiaAmhkXRA1C1aRo9mX2xM5GypRRmlKj9v/3LZSFPA+yzu1GWBfA3ILiA1lfKeLw5OtYM5wgGHrMN0mnvc+Wewkj3BBYUx89dE3ORkIRmg5lezN9+8RYWiGCQFm159CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785399075; c=relaxed/simple;
	bh=tNtlNmD8778HAJnomsTuab9VT5GlxXHI2KMVKTR71mM=;
	h=In-Reply-To:Content-Type:Date:Message-Id:Subject:Cc:From:
	 References:To:Mime-Version; b=DrvizJaFTdeVRrCx2Bt3fi5TxfpahKLqGxTGC7jCU2tejPigJN937+5+Zd0Wu/kBqF+ljDVYhhQZg2lGe9ISkjPqbOp0yphGSzBlFv2G0FViEqxbk3ZMUedx1q1sk7FqxhDW5wamKJpaveTrTu1KkV3pP/uw3KCdB8mMiFfAURg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=hNCFRN+l; arc=none smtp.client-ip=101.45.255.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="hNCFRN+l"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785398979;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=9a9qlKheM41V9tVOAOi1sJuzaAGCmycW+IKJ5deOY98=;
 b=hNCFRN+lPhYIZBDH6eRJ7j8L+07tVmH1uQHMY8x4unhfw2P8AuGnB+aQBVsNabyP55Cqqd
 AEzA+o1KCFFM5LwkkDvzeqCzq7sb6PDFNpSFbA307gdiaUG0gMnu4ngi1SHJa1n/bTADfb
 LCnXnz2XnpBzKz6N+0rYfJf6J2+dvlhwyfi49Eo506XMAcm7y2HfamaCAiD+0W/jc7hkE7
 K5yp7yV1BIW4anW/seVHsTSsGOvtYDi6yX6Zky2QLpWWZwaAoUTzepNJh2EZY/+GP0QI/5
 SN0EtN7VnXbm8auuaqzDE5uk9n4mM7w2m3z1bFCoYSFs0mGmbt6Ndol7g7YGgA==
In-Reply-To: <20260622142146.56637-1-sajal2005gupta@gmail.com>
Content-Type: text/plain; charset=UTF-8
Received: from [192.168.1.104] ([39.182.0.181]) by smtp.larksuite.com with ESMTPS; Thu, 30 Jul 2026 08:09:38 +0000
Reply-To: yukuai@fygo.io
Date: Thu, 30 Jul 2026 16:09:34 +0800
Message-Id: <acacbf2b-8f1f-4568-9246-12d9d8afd0f0@fygo.io>
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2] md/raid5-ppl: fix use-after-free in ppl_do_flush()
Cc: <yukuai3@huawei.com>, <tomasz.majchrzak@intel.com>, 
	<linux-kernel@vger.kernel.org>, <error27@gmail.com>, 
	<skhan@linuxfoundation.org>, <me@brighamcampbell.com>, 
	<linux-kernel-mentees@lists.linux.dev>
From: "yu kuai" <yukuai@fygo.io>
References: <20260622142146.56637-1-sajal2005gupta@gmail.com>
To: "Sajal Gupta" <sajal2005gupta@gmail.com>, <linux-raid@vger.kernel.org>, 
	<song@kernel.org>, "yu kuai" <yukuai@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>
User-Agent: Mozilla Thunderbird
X-Lms-Return-Path: <lba+26a6b06c2+d1deb8+vger.kernel.org+yukuai@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0

=E5=9C=A8 2026/6/22 22:06, Sajal Gupta =E5=86=99=E9=81=93:

> The loop in ppl_do_flush() continues iterating after calling
> ppl_io_unit_finished(), touching io->pending_flushes and leading to a
> use-after-free.
>
> Add a break statement to stop the loop once io is freed.
>
> Fixes: 1532d9e87e8b ("raid5-ppl: PPL support for disks with write-back ca=
che enabled")
> Reported-by: Dan Carpenter<error27@gmail.com>
> Closes:https://lore.kernel.org/all/ajJF2wKYWRk4GGCK@stanley.mountain/
> Signed-off-by: Sajal Gupta<sajal2005gupta@gmail.com>
> ---
> Compile tested only.
>
> Changes in v2:
>   - drop the refcount_t conversion
>
> v1:https://lore.kernel.org/all/20260622080656.22786-1-sajal2005gupta@gmai=
l.com/
>
>   drivers/md/raid5-ppl.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
Applied to md-7.3

--=20
Thanks,
Kuai
