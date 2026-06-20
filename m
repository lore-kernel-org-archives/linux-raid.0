Received: from va-2-52.ptr.blmpb.com (va-2-52.ptr.blmpb.com [209.127.231.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4D734F497
	for <linux-raid@vger.kernel.org>; Sat, 20 Jun 2026 21:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781991524; cv=none; b=k4z0TXHbUCmp7yHJSOKG3sYVyFS7Uq06K4ZBKagu1bvP9XfylQRzpAAdZzw5VAFclJuVkHE63henlP9+lnL12spiiqY5pe/V7RPh7QWKV0+Ag0OPQS5PZ/rTyayKf8fMbiEr6nDqT+g6BVNyGSemtIHyUPq9zYpsaOI8s0rK9/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781991524; c=relaxed/simple;
	bh=v2/GBU71/v2GlYws16A8MdqZrxcHBn1DcwgipnNo/4Y=;
	h=Mime-Version:References:In-Reply-To:Date:Message-Id:From:Subject:
	 To:Cc:Content-Type; b=DN9t0HBI4DVr69AWBAemKYqBOOkpZD2E/o9qk8/yIn8id0XPVYNb03gZvrx/XcwUpxU9S0wrYDUAIUeOBjL5V3D7P1LwD04Bgp4M+OBGMxRr3kMCbPrwjcedOUEiWs6Gx+BaflLGCRWfpYw9bHe4qwRSBAlPT74X5gucy4eZfTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=osnZGZAG; arc=none smtp.client-ip=209.127.231.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="osnZGZAG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1781991518;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=kFFKHz2xu+/SzYtBYOHgOYysifhwXewdjkSxeDh+OKs=;
 b=osnZGZAGysQutIxcp0e79eECxziYrjxdt5AxLvw/fn33NamnnDVljDLEFuuccXuiaDGzJf
 yD8PB2mWqZYnpHqALMtGx1DBKp2SBxJuaNyGXuOD6dsLuAPvl4GAwd3AZC6HfxI0mRZbJz
 dPaFeKrRACA1DitvWrML0tXyVabm8TQuKSYiVgdWnhPJp8ucTrKfpHg8jSSr4Oy6DEmhYK
 DYnjQRA/AakDVnrHoZ80FNmNL65DE9M3D/TgQRugWITrkDl0thLx89am/8Cdrsuw6W/SsW
 49r7Jv3e1o/r8cMichWJLQW3ACwvn5K+xPq520DR6qP1+KWeJ5s+T1BS5NGeHA==
Content-Transfer-Encoding: quoted-printable
Reply-To: yukuai@fygo.io
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260618134748.1168360-1-chencheng@fnnas.com>
In-Reply-To: <20260618134748.1168360-1-chencheng@fnnas.com>
Date: Sun, 21 Jun 2026 05:38:34 +0800
Message-Id: <97dd132f-398c-41e0-bbc5-fe1ba9645da8@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH] md/raid5: use stripe state snapshot in break_stripe_batch_list()
X-Original-From: yu kuai <yukuai@fygo.io>
Received: from [192.168.1.104] ([39.182.0.148]) by smtp.larksuite.com with ESMTPS; Sat, 20 Jun 2026 21:38:37 +0000
X-Lms-Return-Path: <lba+26a37085e+3ace23+vger.kernel.org+yukuai@fygo.io>
To: "Chen Cheng" <chencheng@fnnas.com>, <linux-raid@vger.kernel.org>, 
	<yukuai@fygo.io>
Cc: <linux-kernel@vger.kernel.org>
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8

=E5=9C=A8 2026/6/18 21:47, Chen Cheng =E5=86=99=E9=81=93:

> From: Chen Cheng<chencheng@fnnas.com>
>
> The patch just suppress KCSAN noise. No functional change.
>
> RAID-5 can group multi full-stripe-write aka stripe_head into a
> batch aka batch_list, with one head_sh leading them. Call
> break_stripe_batch_list() when the batch is finished, or,
> a stripe has to be dropped out of the batch.
>
> break_stripe_batch_list() reads stripe state several times while
> request paths can update thost state words concurrently with
> lockless bitops, which reported by KCSAN.
>
> Use a snapshot to guarantees that the value used for
> warning, copying, and handle checks is internally consistent
> at current read moment.
>
> KCSAN report:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KCSAN: data-race in __add_stripe_bio / break_stripe_batch_list
>
> write (marked) to 0xffff8e89d4f0b988 of 8 bytes by task 4323 on cpu 3:
>    __add_stripe_bio+0x35e/0x400
>    raid5_make_request+0x6ac/0x2930
>    md_handle_request+0x4a2/0xa40
>    md_submit_bio+0x109/0x1a0
>    __submit_bio+0x2ec/0x390
>    submit_bio_noacct_nocheck+0x457/0x710
>    submit_bio_noacct+0x2a7/0xc20
>    submit_bio+0x56/0x250
>    blkdev_direct_IO+0x54c/0xda0
>    blkdev_write_iter+0x38f/0x570
>    aio_write+0x22b/0x490
>    io_submit_one+0xa51/0xf70
>
> read to 0xffff8e89d4f0b988 of 8 bytes by task 4290 on cpu 4:
>    break_stripe_batch_list+0x3ce/0x480
>    handle_stripe_clean_event+0x720/0x9b0
>    handle_stripe+0x32fb/0x4500
>    handle_active_stripes.isra.0+0x6e0/0xa50
>    raid5d+0x7e0/0xba0
>
> Signed-off-by: Chen Cheng<chencheng@fnnas.com>
> ---
>   drivers/md/raid5.c | 45 ++++++++++++++++++++++++++-------------------
>   1 file changed, 26 insertions(+), 19 deletions(-)
Applied to md-7.2

--=20
Thanks,
Kuai
