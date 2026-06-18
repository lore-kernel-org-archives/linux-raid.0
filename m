Received: from va-2-40.ptr.blmpb.com (va-2-40.ptr.blmpb.com [209.127.231.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4CB399359
	for <linux-raid@vger.kernel.org>; Thu, 18 Jun 2026 11:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781782014; cv=none; b=ljH7mHUAkOInXsTVjtO0SU1PH0ABBulEpVc8nNicHyxRIM8Fx6XGlUqqupt+PgZSCHH2tTICmf+HR8kwD+/CI6aWrtRWYyeC7hIuhIqYSVa1W+8rk8ti7MNPE6WKdGRlI3VhiIU+KAq39pxigYgqfxodiXcquU+dJ9qMDE+wxpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781782014; c=relaxed/simple;
	bh=yUJlRRcBublk5f/JgaFW7OaghjmSYYcaJPjhGc8x3IY=;
	h=Date:Message-Id:Mime-Version:References:Content-Type:To:Cc:From:
	 Subject:In-Reply-To; b=BwpayYOduyhM/wG4RmB49piyo/mc6740kzQYDOr96MigcjhOQ2O/T6TCibWaDOY33BW4nqhrCO5orKChNyRmujczcIn/VTRjpOoOsF+Q8dEX8v4xGdYjlTN8SXQBx7fgzTJLtmRtE3h+/YNDTN4TpCAjTDwJGjBfQWsmNxRHUDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=GJDhN7rl; arc=none smtp.client-ip=209.127.231.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="GJDhN7rl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1781782006;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=yUJlRRcBublk5f/JgaFW7OaghjmSYYcaJPjhGc8x3IY=;
 b=GJDhN7rlYbEZXb+vpt8rqpUqT8jwHDkZnlKoYlTbGjzzlRsIVcxpVif2FTbVIw8jeDk4Ed
 BgIAMzeBva7wICvJUM0811xcIt3eZyGB+yMrbOSCee8Vi4mq7CY7J8mskiu60qEZwIJi2N
 EwqLM3vM17X0mAm/QBDhNHUcqrcwcTo6zrw3gH2IVifn9xOco71oUCkIQACUtnhomCc79V
 yBovcmxuvbZ0RMUArnWhn7+IAiYBjZlcR+e2z6cbUW+pW3IieZO1VKFGMMIyVc06yMX5cy
 onUKVYw95sn75ua+Fo3bpEw4ereBAyPebC9u5Hl5lRO2P61y6Ymif3f4SmaQ4A==
Date: Thu, 18 Jun 2026 19:26:42 +0800
Message-Id: <76dd7a7b-b1ad-4f61-9eda-5957f712ed87@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
X-Original-From: Chen Cheng <chencheng@fnnas.com>
References: <20260618065544.954309-1-chencheng@fnnas.com> <5e6ce9e2-4da9-4ded-be8c-fad3ee153d90@molgen.mpg.de>
X-Lms-Return-Path: <lba+26a33d5f4+c48f53+vger.kernel.org+chencheng@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Received: from [192.168.8.62] ([183.34.170.8]) by smtp.feishu.cn with ESMTPS; Thu, 18 Jun 2026 19:26:43 +0800
Content-Transfer-Encoding: quoted-printable
To: "Paul Menzel" <pmenzel@molgen.mpg.de>
Cc: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>, <yukuai@fnnas.com>, 
	<chenchneg33@gmail.com>, <linux-kernel@vger.kernel.org>
From: "Chen Cheng" <chencheng@fnnas.com>
Subject: Re: [PATCH] md/raid5: protect batch_head->bm_seq updates
In-Reply-To: <5e6ce9e2-4da9-4ded-be8c-fad3ee153d90@molgen.mpg.de>

=E5=9C=A8 2026/6/18 18:36, Paul Menzel =E5=86=99=E9=81=93:
> Dear Chen,
>=20
>=20
> Thank you for very much.
>=20
> Am 18.06.26 um 08:55 schrieb Chen Cheng:
>> From: Chen Cheng <chencheng@fnnas.com>
>>
>> bm_seq means "stripe delay to flush until bm_seq <=3D seq_write".
>>
>> do_release_stripe() keeps STRIPE_BIT_DELAY stripes on bitmap_list
>> when bm_seq >=3D seq_write.
>>
>> after raid5d() flushes bitmap update and ++seq_write, and
>> active_bit_delay() retry to release delayed stripes.
>>
>> the stripe batch head must carry the newest bm_seq among all
>> member stripes, because the whole batch later released according
>> to the batch head state and bm_seq.
>>
>> race scenario:
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> 1. cpu0 - sh0->bm_seq=3D101; cpu1 - sh1->bm_seq=3D102;
>> 2. both cpu0 and cpu1 read batch_head->bm_seq =3D 100;
>> 3. cpu1 write 102, and cpu0 overwrite with 101;
>>
>> the point is, if the head has a lower bm_seq than one of its
>> members, the whole batch could be released before that
>> member's bitmap is flushed.
>> and the on-disk bitmap not record sh1's changes.
>=20
> It=E2=80=99s a little hard to read. Could you please improve the wording =
of the=20
> last paragraph, and maybe also start each sentence with a capital=20
> letter. Maybe also use 75 characters per line.
>=20
> Do you have a reproducer by any chance?

Hi Paul,

Thanks to review, and , I will follow your advise.

Actually, I have some reproducer to hit KCSAN reports in RAID-5, but not=20
for this one. Because it's reported by sashiko-review bot, and , I think=20
it's a true risk.

I will try to make a reproducer for this case later , after I figure-out=20
the other KCSAN reports.


>=20
>> Signed-off-by: Chen Cheng <chencheng@fnnas.com>
>=20
> Also add a Fixes: tag?
>=20
>> ---
>> =C2=A0 drivers/md/raid5.c | 13 ++++++-------
>> =C2=A0 1 file changed, 6 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index a08230aac711..ee145a7bf9e8 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -980,32 +980,31 @@ static void stripe_add_to_batch_list(struct=20
>> r5conf *conf,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * at this p=
oint, head's BATCH_READY could be cleared, but we
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * can still=
 add the stripe to batch list
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 list_add(&sh->bat=
ch_list, &head->batch_list);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_unlock(&head->batch_hea=
d->batch_lock);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 head->batch_head =
=3D head;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sh->batch_head =
=3D head->batch_head;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_lock(&head->=
batch_lock);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 list_add_tail(&sh=
->batch_list, &head->batch_list);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_unlock(&head->batch_loc=
k);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> -=C2=A0=C2=A0=C2=A0 if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->s=
tate))
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (atomic_dec_return(&conf-=
>preread_active_stripes)
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 < IO=
_THRESHOLD)
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 md_w=
akeup_thread(conf->mddev->thread);
>> -
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (test_and_clear_bit(STRIPE_BIT_DELAY, =
&sh->state)) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int seq =3D sh->b=
m_seq;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (test_bit(STRI=
PE_BIT_DELAY, &sh->batch_head->state) &&
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 sh->batch_head->bm_seq - seq > 0)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 seq =3D sh->batch_head->bm_seq;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 set_bit(STRIPE_BI=
T_DELAY, &sh->batch_head->state);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sh->batch_head->b=
m_seq =3D seq;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0 spin_unlock(&head->batch_head->batch_lock);
>> +
>> +=C2=A0=C2=A0=C2=A0 if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->s=
tate))
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (atomic_dec_return(&conf-=
>preread_active_stripes)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 < IO=
_THRESHOLD)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 md_w=
akeup_thread(conf->mddev->thread);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 atomic_inc(&sh->count);
>> =C2=A0 unlock_out:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unlock_two_stripes(head, sh);
>> =C2=A0 out:
>=20
>=20
> Kind regards,
>=20
> Paul
