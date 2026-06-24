Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5CA333F8A5
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 17:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782320517; cv=pass; b=WTm4YMxePWKtDSWQfkPTgPXFp832u0yJfMGuaeQEfbNrDIg3r6gXVOwcs1KOdrMevvrfIfY00FRCm0BVNa4T2gGblPeA0b+cAtq3yG26OXE1KdIgXLMRrcMpx1M0PGObqhYWkUWDi5by6vNNVMMeu5ZqR5Yhp5uG6a0rW4nNNVI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782320517; c=relaxed/simple;
	bh=IEnlcR40Ofp2M9bOp50jNBFJL7CwLeUtAjIhQ6M+58I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gHheKO4GYMbFRpEaYwml3xaYuEDBdz/8FJxr9q8BcPgSqn/6SoLDNgm9ZstEQsIoVzL9e+pjdt3Q9lwIzm6xY9OZxRgekUV3fDVBNRmaHzPwBNDY1EbXk2Kuv5BUR9vcQnfg2i13aHJOmfhLUP9Su/okmNoBo1EjEU8M2YQZc5M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bUddegs4; arc=pass smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bUddegs4"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2c7cfa17fedso10343515ad.3
        for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 10:01:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782320515; cv=none;
        d=google.com; s=arc-20240605;
        b=VpeavgsQMOaXpjMvBu1jR336Pcr0UnkZn0RogKhwPbMK5FJ3GkSBt2kybBu6xzMmvw
         1FAqRbn/jzQEamVHJr5roOYZvz+uEGEJwCr2V08LvDar7f7JLiVInuA9iMpaD0DOuNWB
         WILtSxwt788ib/P4NaIIMvgWe/ShcIdVDndSH0MTsLOJw/1PQvjVzE7dBsnm+5760PQl
         khYoFjF0SR3vi1BZItOIKZCJnKwEMLIkXkmce0rSNxzagKWcWHL40sdTGzKf1XhkeZDs
         l8eK/TmuhOSPnlyn5B2hqAwOnzChffO+SEkEktBaA26/iuoIiGiDzAXshunxV+76v69v
         ackw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kaOi2FI8KJXRo8Ej4CH3FqXJaSTUFin19ugye02gcZc=;
        fh=nkINftD/X38VeDQxWsD9gFZEHDG8FBcv0eD3E2aJKS4=;
        b=jgnngvSSmifxtHqs6QDWiPE2Esmtzra9pe6oIPAt/QHReDy9+EUyCqc2/AFuqOGLfl
         KhhVX7wG8sDv94s4wXCZ1jz7SzfxDo/n9+wdi29LyWrvoR+NqHq5nsSoOznzeb7A6alJ
         0/iOEypZSpP7NJIE4XNbxQzUKLEVqCWxLT873QwUkEkR9FlAZ1LMj3ZauOVErADd7NDu
         v3RVQ6fK2esSBksZ4HytRSdNWNs3RYFtGtvrOBsHteCdsKapIdMpVsVd9fdKO+6JzXRN
         yDmdN8+d2P4sebFjYYWd/egT1v1MleF4YvHvwgKduNvQSIxBU8rf+sze5EfG9Wcv+WfK
         2A4Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782320515; x=1782925315; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kaOi2FI8KJXRo8Ej4CH3FqXJaSTUFin19ugye02gcZc=;
        b=bUddegs4jO/NOxaGomOdF7y8B6o8KdyZ5mtxlwzaIW/7sFTbGkYE5O9TtQkNAd3nom
         HIumo9gVfl9j3gTdrJc9fLhMDDhsQLnBRc9hcgmiG6ZfBTnMUE3brn5YbB+68pl6KHus
         1bZJWsIdFxArxaHe5Mfe6JG/xfXNM0c7G0qoA3zL/8yJVSsTQjAloCN/VhbyjFMNa720
         MKqlUAqht/97a4XGAFRpOkhLh21gLIAIC9gga5VjZZeDg4P2j32XdcL/QLO/VwC8H3Dl
         BhLGcxbIgjGskmSxNhG4AkoofQtS6KPS/YyB/nW3Tc+HaxSd9DV8mvcpK7Vqqb5ECYfz
         ZxTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782320515; x=1782925315;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kaOi2FI8KJXRo8Ej4CH3FqXJaSTUFin19ugye02gcZc=;
        b=Z8mh56sddOjka2M94JL5sB0Kt7k6ZOn1eYQDxJhFTK1D8vtKNlgdhXVz74DYE05NTk
         BIzSM5velt8HFm9s8KVaQUTlAs3zDAfARHZHD/P4GOGg2HpQ3l0Qdun/tVZL/swxm3oL
         30f++WYx+zqP3/9x01GcC689c2Z3y20peK0c8VXHFL2dIDQ5GZXpiQuNme5CSeE2gQgM
         R6fXMETsnkMUd2GTToRP/VSMlhCI3q7SNmJmA5s20Aw/2257eDFiyGVGWhmNOhS9WuQb
         JXYHySbYXzQ9hTwmxElcAiwG7PyrIIZJUbOZZzPIqWGBonn90Dvh8lm/MVCHFnt0a9Bq
         m7ww==
X-Forwarded-Encrypted: i=1; AHgh+RouMTtNUj5H/sZpHgaLone2NUOShvrJeMcKq2O01m2fcxagRSJbeJ4LY8pmlQI46O8u6tDl4Z0tr35l@vger.kernel.org
X-Gm-Message-State: AOJu0YxziENZ0p0KveYvWKrcRphsbwaMdKI/1fyKpyk2YHaaTmRvCmHI
	dsGKkgIkAIZIgbLoDxESclMrWFtbyBHKMBRa1bIyOrXGL6eYsrMu/jETvAlPoVmgUF7t+xoVHjs
	fgF/UBsPWZFskN/4Hs7I/ior8BpvNzDEA2lZeqhQS+w==
X-Gm-Gg: AfdE7ckaAAw6vU36fqX3iUylHbWAI9q9/ibNDrGRhY+mQZOI+Y50QYxIW6g+hL6/zcf
	yoLdarGJqBkL+ZQWpt8+BfnVqVHxmxFQK+QnHCCBm2DM5cfBgkZyZyooUw8uKDq6LLO0rbtDIQL
	DQIMEfMSHipi0+uYa8aXHMPi0udY7tRVSLeZwPRnpWEIJZipSq5TIjebgD2jTG+5HkzsCK1rRL9
	JuviAMcYxdqy60Br+UcqpFBsj6y0IEa/ndc+MIoXO99STVbczmgL1BUnOffiIBdGgWRcbCyhTKd
	xz6AClfzS05cZAf8r6rRJQ7NL973vWK6GdtIwPjVii8uxLPUQF6c/AXaSLv9BoZDCmlETKMxFRG
	N1SEVuqkSQ6qw4V5nTXP0iDw=
X-Received: by 2002:a17:902:ea08:b0:2ae:450c:951e with SMTP id
 d9443c01a7336-2c7e1538ea4mr43720445ad.17.1782320514821; Wed, 24 Jun 2026
 10:01:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260624155452.211646-1-nishidafmly@gmail.com>
 <20260624155452.211646-8-nishidafmly@gmail.com> <20260624160917.1508E1F000E9@smtp.kernel.org>
In-Reply-To: <20260624160917.1508E1F000E9@smtp.kernel.org>
From: Hiroshi Nishida <nishidafmly@gmail.com>
Date: Wed, 24 Jun 2026 10:01:43 -0700
X-Gm-Features: AVVi8CfIVKsbV7HRoSR2KmegZf5pZmJbYFAFDKc55a2x-PNcx3YNYozfm1ixLuw
Message-ID: <CAE1ksKQnBogsm5nW7z0t9iZsb12xwVfTzzRGgpoBS8VxckS-1Q@mail.gmail.com>
Subject: Re: [PATCH 7/8] md/raid5: raise MAX_STRIPE_BATCH from 8 to 32
To: sashiko-reviews@lists.linux.dev
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

 > [High] Raising MAX_STRIPE_BATCH to 32 while keeping the spawn threshold =
at 8
 > lets the first worker grab all 32 stripes and starves the others.

You're right.  In stock, MAX_STRIPE_BATCH does double duty -- it caps
the greedy dequeue
in handle_active_stripes() AND is the spawn divisor in
raid5_wakeup_stripe_thread() --
and keeping those equal is what balances the workers woken against the
work each one takes.
My patch grew the dequeue cap to 32 but left the spawn divisor at 8,
so for ~32 pending stripes it wakes 4 workerswhile the first greedily
takes all 32 and
the rest find empty lists -- serializing the batch and adding
pointless lock contention, exactly as you describe.

The lock-amortization benefit was never isolated, and re-coupling the two (=
spawn
divisor =3D batch) just trades it for coarser worker granularity, so
I'll drop this
patch from v2 rather than guess at the tuning.

Thanks,

2026=E5=B9=B46=E6=9C=8824=E6=97=A5(=E6=B0=B4) 9:09 <sashiko-bot@kernel.org>=
:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [High] Increasing MAX_STRIPE_BATCH to 32 without proportionally increas=
ing STRIPE_BATCH_WORKERS serializes stripe processing and causes worker sta=
rvation.
> --
>
> commit b1a0a169dabd8b46b6b9ca40375034cf879934c6
> Author: Hiroshi Nishida <nishidafmly@gmail.com>
>
> md/raid5: raise MAX_STRIPE_BATCH from 8 to 32
>
> This commit increases the maximum stripe batch size from 8 to 32 to
> amortize device_lock acquisition over more stripes. It also introduces
> STRIPE_BATCH_WORKERS to decouple the worker spawning threshold from the
> batch size.
>
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > index c8787ab7b309c..ad6230415af33 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> [ ... ]
> > @@ -210,7 +210,7 @@ static void raid5_wakeup_stripe_thread(struct strip=
e_head *sh)
> >       /* at least one worker should run to avoid race */
> >       queue_work_on(sh->cpu, raid5_wq, &group->workers[0].work);
> >
> > -     thread_cnt =3D group->stripes_cnt / MAX_STRIPE_BATCH - 1;
> > +     thread_cnt =3D group->stripes_cnt / STRIPE_BATCH_WORKERS - 1;
> >       /* wakeup more workers */
> >       for (i =3D 1; i < conf->worker_cnt_per_group && thread_cnt > 0; i=
++) {
>
> [Severity: High]
> Will increasing the stripe batch size while keeping the worker spawn thre=
shold
> small serialize stripe processing and starve the worker threads?
>
> With this change, raid5_wakeup_stripe_thread() still wakes up an addition=
al
> worker for every 8 pending stripes (e.g., waking 4 threads for 32 stripes=
).
>
> However, the first awakened worker executing handle_active_stripes() will
> greedily dequeue up to MAX_STRIPE_BATCH (32) stripes under the lock:
>
> drivers/md/raid5.c:handle_active_stripes() {
>     ...
>     while (batch_size < MAX_STRIPE_BATCH &&
>            (sh =3D __get_priority_stripe(conf, group)) !=3D NULL)
>         batch[batch_size++] =3D sh;
>     ...
> }
>
> It appears the first thread will steal all 32 pending stripes and process
> them sequentially, while the other awakened threads acquire the lock,
> find the lists empty, and exit without doing any work.
>
> Could this cause a performance regression by serializing CPU-intensive pa=
rity
> operations onto a single thread, while also creating unnecessary lock
> contention from the starved threads?
>
> > diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> > index 7aeba1fc7f09e..1f37dabd727be 100644
> > --- a/drivers/md/raid5.h
> > +++ b/drivers/md/raid5.h
> [ ... ]
> > @@ -496,7 +496,8 @@ struct disk_info {
> >  #define BYPASS_THRESHOLD     1
> >  #define NR_HASH                      (PAGE_SIZE / sizeof(struct hlist_=
head))
> >  #define HASH_MASK            (NR_HASH - 1)
> > -#define MAX_STRIPE_BATCH     8
> > +#define MAX_STRIPE_BATCH     32      /* stripes per handle_active_stri=
pes pass */
> > +#define STRIPE_BATCH_WORKERS 8       /* stripes-per-worker threshold f=
or spawning */
> >  #define RAID5_SYNC_WINDOW    32      /* stripes to pre-submit per sync=
_request call */
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260624155452.21=
1646-1-nishidafmly@gmail.com?part=3D7



--=20
Hiroshi Nishida
nishidafmly@gmail.com
