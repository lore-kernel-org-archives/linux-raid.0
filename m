Received: from sg-3-29.ptr.tlmpb.com (sg-3-29.ptr.tlmpb.com [101.45.255.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B7635A3A4
	for <linux-raid@vger.kernel.org>; Tue, 16 Jun 2026 04:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.45.255.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781582720; cv=none; b=C9Lh26sEza1eTkE1eMLT10AOa0xp6gKWwBZ8vS1apjIovELPhu+9YGKBERgRLqMuFTbDEcAsXnbm8YBbahY79R/JR/+t2RcjcWfFdOEcCBGMhOg0kCYHnnrbbHCLXnxEz0q2uEAnuZVktRsXyTciG0ck81gNbM+X/2AVapWlFx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781582720; c=relaxed/simple;
	bh=q+yEAJ9zHc6IAufHG3LvWwwuJhw6lIAslZ0oMZGbX/M=;
	h=References:To:Subject:Date:Message-Id:Content-Type:In-Reply-To:Cc:
	 From:Mime-Version; b=BsCjY7nd0Q1TT1wNvsIXlFeZ7ToGUzEHcMo/3RjMrnoHuY/M+wFPtOtRxpTJPiddeQdx7PLKyPvMBgP5tXjoUMF3e3yi5xhLwgfZnipllTjzzORryYC/BeIrtb5/kj/988uOzeOG7KlgxOkKA6qoCWOXvlwKYa9PbMAw18XKOgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=TILhfN6H; arc=none smtp.client-ip=101.45.255.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="TILhfN6H"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1781582674;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=ESzF895AoHZXK4/g8cRewm9giil7RjP9kYNAm+NtV6A=;
 b=TILhfN6HQqK5ls4h7OYz+R9K6SkcmW0z856bltncNYWlrZ2sdbZ9DPfHF4Ioz3HvB62CEe
 pDSV7KeCcxlpeuzip7oxWZ3xApmvQbx2eXCXtwreSDP8CxSrGt1dQog0/nYIWGETlLaIfL
 sz4MvMxpjP9Nem0rPzQtUMp/oRmIUj3AFE/cOhINL2iU1om25UXLOHlpWVHr9vOOLZaz1o
 D7zAwKVaxK6OBKIf4JEiFNZWLlhFax6B+g7yuui4qUwGbxmN1gU11VD3m1yC8r4+ClINyZ
 UwuN0neFcjuFLNSqo7741iMCBiVOyAzfFvnt8sL5ZrXbe8NSNcwNS9VgAbgrTg==
References: <20260615113450.2088877-1-chencheng@fnnas.com> <20260615114929.E5BAD1F00A3A@smtp.kernel.org>
Received: from [192.168.8.62] ([183.34.162.81]) by smtp.feishu.cn with ESMTPS; Tue, 16 Jun 2026 12:04:31 +0800
To: <sashiko-reviews@lists.linux.dev>
Subject: Re: [PATCH v2] md/raid5: fix reshape deadlock while failed devices more than max degraded
User-Agent: Mozilla Thunderbird
X-Lms-Return-Path: <lba+26a30cb50+30fc13+vger.kernel.org+chencheng@fnnas.com>
Date: Tue, 16 Jun 2026 12:04:30 +0800
Message-Id: <ddaaa79b-6171-40a5-a004-0178ecc0a44f@fnnas.com>
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20260615114929.E5BAD1F00A3A@smtp.kernel.org>
X-Original-From: chencheng <chencheng@fnnas.com>
Content-Transfer-Encoding: quoted-printable
Cc: <yukuai@fygo.io>, <linux-raid@vger.kernel.org>
From: "chencheng" <chencheng@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0

=E5=9C=A8 2026/6/15 19:49, sashiko-bot@kernel.org =E5=86=99=E9=81=93:
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [Critical] Clearing STRIPE_EXPANDING prematurely in handle_failed_resha=
pe() allows a destination stripe to be freed and reused while asynchronous =
DMA is still writing to its pages, leading to DMA-after-free memory corrupt=
ion.
> --
>
> commit ec55b78c975b4f9f35e287b83bee72d76b92b33a
> Author: Chen Cheng <chencheng@fnnas.com>
>
> md/raid5: fix reshape deadlock while failed devices more than max degrade=
d
>     =20
> This patch fixes a deadlock in raid5 reshape by cleaning up stripe states
> (including destination and source stripes) when failed devices exceed the
> max degraded count.
>
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index d0d7f96fd7cd9..2f4d82bd7c2e6 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -3730,6 +3730,78 @@ handle_failed_sync(struct r5conf *conf, struct st=
ripe_head *sh,
>>   		md_sync_error(conf->mddev);
>>   }
>>  =20
>> +/*
>> + * handle_failed_reshape - handl failed stripes when reshape failed and
>> + *			   degraded devices >=3D max_degraded
> [ ... ]
>
>> +static void handle_failed_reshape(struct r5conf *conf, struct stripe_he=
ad *sh,
>> +				  struct stripe_head_state *s)
>> +{
>> +	int i;
> [ ... ]
>
>> +	/* release the destination stripes that are waiting to be filled */
>> +	if (test_and_clear_bit(STRIPE_EXPAND_SOURCE, &sh->state)) {
>> +		for (i =3D 0; i < sh->disks; i++) {
>> +			int dd_idx;
>> +			struct stripe_head *sh2;
>> +			sector_t bn, sec;
>> +
>> +			if (i =3D=3D sh->pd_idx)
>> +				continue;
>> +			if (conf->level =3D=3D 6 && i =3D=3D sh->qd_idx)
>> +				continue;
>> +
>> +			bn =3D raid5_compute_blocknr(sh, i, 1);
>> +			sec =3D raid5_compute_sector(conf, bn, 0, &dd_idx, NULL);
>> +			sh2 =3D raid5_get_active_stripe(conf, NULL, sec,
>> +					R5_GAS_NOBLOCK | R5_GAS_NOQUIESCE);
>> +			if (!sh2)
>> +				continue;
>> +
>> +			if (test_and_clear_bit(STRIPE_EXPANDING, &sh2->state)) {
> [Severity: Critical]
> Could clearing STRIPE_EXPANDING prematurely here lead to a DMA-after-free=
?
>
> During a reshape, a destination stripe (sh2) might require data from mult=
iple
> source stripes. STRIPE_EXPANDING normally prevents the destination stripe=
 from
> being returned to the free list before all data is copied.
>
> If Worker 1 is handling a source stripe via handle_stripe_expansion(), it
> submits an asynchronous DMA copy to sh2's pages and then calls
> raid5_release_stripe(sh2) to drop its reference BEFORE waiting for the DM=
A to
> complete:
>
> drivers/md/raid5.c:handle_stripe_expansion() {
>      ...
>              raid5_release_stripe(sh2);
>          }
>      /* done submitting copies, wait for them to complete */
>      async_tx_quiesce(&tx);
>      ...
> }
>
> If the array concurrently fails, Worker 2 could enter handle_failed_resha=
pe()
> for a different source stripe, look up sh2, clear its STRIPE_EXPANDING bi=
t,
> and release it.
>
> If sh2's refcount drops to 0 without STRIPE_EXPANDING set, could it be
> added to the inactive_list and reallocated (or have its pages freed) whil=
e
> the DMA from Worker 1 is still actively writing to it?


that make sense, however I can't find a card or processer to support offloa=
d
memcpy , neither emulate, so I can't re-produce this scenario.


theoretically, the fix way I can think of is use refcnt to point-out the nu=
mber
of offloading memcpy tasks, after reach to zero, the destination stripe do
cleanup, otherwise , delay source stripe handle.



>> +				atomic_dec(&conf->reshape_stripes);
>> +				wake_up(&conf->wait_for_reshape);
>> +				md_done_sync(conf->mddev,
>> +					     RAID5_STRIPE_SECTORS(conf));
>> +			}
>> +
>> +			clear_bit(STRIPE_EXPAND_READY, &sh2->state);
>> +
>> +			raid5_release_stripe(sh2);
>> +		}
>> +	}
>> +}
