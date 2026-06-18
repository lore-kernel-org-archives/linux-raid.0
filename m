Received: from va-2-37.ptr.blmpb.com (va-2-37.ptr.blmpb.com [209.127.231.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32E1315D53
	for <linux-raid@vger.kernel.org>; Thu, 18 Jun 2026 03:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781754079; cv=none; b=h+T2Z4mSPFydWA0yAAuacJEeQprQDMFs1FjaApeNA1JqCJQenWDq2CikprXnKtbTgdGGwjXwfc7cn+uIJPDLDR/8N5CzXqu8JgaO3SlkqggMCBIW0+TXs8YmLpy+P8UQaZPb1NN+sll0mtxYf4N16WcHnE9jgycYUc5QwDrn9Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781754079; c=relaxed/simple;
	bh=GB2CGxiVXiwwIBGUquuq0pcJk+W4fiCpQlrILlK3YF4=;
	h=From:Subject:References:Message-Id:Mime-Version:Cc:In-Reply-To:To:
	 Date:Content-Type; b=KXF+7Iw4T3N4kd2hd117OtKCk5XQ9gj2NunlHNn5KzV3fo+G3qcK+a4Ph3Iuk1HOVBRqiQmeDbiM4f9uv7eNyB6zVme0muItpeHaf7xFN07iW6DSlKfaVD2HtqKmBdrWySe5C/FyCFcN1vKV4wuQJwLJmunvQrdUNCbRTEh0ba4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=rXh+HWoO; arc=none smtp.client-ip=209.127.231.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="rXh+HWoO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1781754072;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=fJ8uBvKCl/b//LtCUtVSxBUtPP1ma0gdfVNEhV05WDA=;
 b=rXh+HWoOEC6LIRk+JIqGfPUktxmUBEjirEU0+7fm/Cr4O4g2YSm3HpGoUAz5LFjo2BVTww
 5qFYlcFTTDg4AHC0ZbOzEjEHFr7ytDNfoU/+2oY3a/iqXlpQQ+/65yAw84jj/bS9eJBB98
 4FP5AKw7Pxtm01izXUIojjXbw7gsAF/dVGtyrciDAgc0b/Z49UNFkDejmQvt3QEzrcoz51
 otFa2v3loMiAv6mHeyTbx+Iq5ooaxj5leLC5S8M07fg+W6ncU6pHmuUuXkDk6df2H8iFOK
 4zfQfIHkHQIv3TKKinCYotIxT+5nxF+HpXP2odmuiI9BNchanetBPdij4NvqKA==
From: "Chen Cheng" <chencheng@fnnas.com>
Subject: Re: [PATCH] md/raid5: let stripe batch bm_seq comparison wrap-safe
References: <20260618025735.915113-1-chencheng@fnnas.com> <20260618031232.831A41F000E9@smtp.kernel.org>
User-Agent: Mozilla Thunderbird
Message-Id: <8607405e-66cc-495a-9f67-1b68a4b56852@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from [192.168.8.62] ([183.34.170.8]) by smtp.feishu.cn with ESMTPS; Thu, 18 Jun 2026 11:41:09 +0800
Cc: <yukuai@fygo.io>, <linux-raid@vger.kernel.org>
X-Original-From: Chen Cheng <chencheng@fnnas.com>
X-Lms-Return-Path: <lba+26a3368d6+8b1f08+vger.kernel.org+chencheng@fnnas.com>
In-Reply-To: <20260618031232.831A41F000E9@smtp.kernel.org>
Content-Transfer-Encoding: quoted-printable
To: <sashiko-reviews@lists.linux.dev>
Date: Thu, 18 Jun 2026 11:41:08 +0800
Content-Type: text/plain; charset=UTF-8

=E5=9C=A8 2026/6/18 11:12, sashiko-bot@kernel.org =E5=86=99=E9=81=93:
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
>=20
> New issues:
> - [Medium] Wrap-safe sequence comparison introduces signed integer overfl=
ow, triggering UBSAN.
>=20
> Pre-existing issues:
> - [High] Concurrent lockless read-modify-write of `batch_head->bm_seq` ca=
n result in lost bitmap flush sequence updates.
> --
>=20
> commit 38cbf25fbeef1204525d320e539132e2704c3653
> Author: Chen Cheng <chencheng@fnnas.com>
>=20
> md/raid5: let stripe batch bm_seq comparison wrap-safe
>=20
> This commit alters the comparison of sequence numbers in the RAID5
> stripe batching path to correctly handle wrap-around by using subtraction=
.
>=20
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index d0d7f96fd7cd9..5882670f7d0c9 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -996,7 +996,7 @@ static void stripe_add_to_batch_list(struct r5conf *=
conf,
>>   	if (test_and_clear_bit(STRIPE_BIT_DELAY, &sh->state)) {
>>   		int seq =3D sh->bm_seq;
>>   		if (test_bit(STRIPE_BIT_DELAY, &sh->batch_head->state) &&
>=20
> [Severity: High]
> This isn't a bug introduced by this patch, but it appears that the shared
> batch_head->bm_seq is being accessed and updated locklessly here. If mult=
iple
> threads concurrently append stripes to different parts of the batch list,
> could Thread A and Thread B concurrently read batch_head->bm_seq, compare=
 it,
> and write it back, causing a race?
>=20
> An unguarded read-modify-write might allow a thread writing an older
> sequence number to overwrite a newer one written by another thread. If bm=
_seq
> gets overwritten with an older value, could the batch start processing be=
fore
> the newer bitmap flush completes, potentially risking data corruption on =
power
> loss?
>=20
>> -		    sh->batch_head->bm_seq > seq)
>> +		    sh->batch_head->bm_seq - seq > 0)
>=20

good catch..

> [Severity: Medium]
> Since both sh->batch_head->bm_seq and seq are signed ints, does this wrap=
-safe
> comparison introduce a signed integer overflow when the sequence wraps?
>=20
> While the kernel is compiled with -fno-strict-overflow so it functions as
> intended, subtracting two signed integers whose difference exceeds the
> representable range of a 32-bit signed integer can trigger Undefined Beha=
vior
> Sanitizer (UBSAN) splats.
>=20
> Could this be written by casting to unsigned before subtraction and back =
to
> signed, such as (s32)((u32)a - (u32)b) > 0, to avoid UBSAN warnings and
> potential kernel panics on environments with panic_on_warn?
>=20
>>   			seq =3D sh->batch_head->bm_seq;
>>   		set_bit(STRIPE_BIT_DELAY, &sh->batch_head->state);
>>   		sh->batch_head->bm_seq =3D seq;
>=20

I am fine with both way .. raid5 use the template "a - b > 0" directly=20
for a long time

     e.g. "sh->bm_seq - conf->seq_write > 0" in do_release_stripe()

(s32)((u32)a - (u32)b) > 0 is more rigorous, and "a - b > 0" much cleaner .
