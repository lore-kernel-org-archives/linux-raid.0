Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D449B33C50D
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 16:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782319870; cv=pass; b=JAK+fmef1S4IVjY0xF5kxoNiWHuc/iSxFzRMzb4zw9xsr7miOgM+qEqgJqZ6D8sRxpeHC6IGIwyCjf3Bn/1LiUo3AwMjAAj6HmoYXkj6ogl6qkIqj5F6BW+ddGVKrQ70hkjfMdOvSlGswaaVQgWgXSpWw0oDkVQVo5eEzCZLuEE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782319870; c=relaxed/simple;
	bh=cjvPvtEsTHCAOU+IjGR4oOnSd0wTDR9pc2SGE/nQchk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MRu3etd/5m0L/u0EPBHNzIqMDs39ksKJIKKk3R9E49HTSacjpE7sqNzBeU+/4qgZvaSuF630ucygVfgfTNZWMc6vCBKXk7y2N3vTePQd9u1AhCLGURPQrXYm1TdhExu3lyIE9pYUEgh53ev9hhQX1Agad+BNG20ulpuXSJktros=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CBC1dK6R; arc=pass smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CBC1dK6R"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-c858961a8efso513770a12.2
        for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 09:51:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782319868; cv=none;
        d=google.com; s=arc-20240605;
        b=IhNYCGN0Gcqp2B6VW7/iaeLbfFzXAmyF1Ff0UDnFkaHMOsyj8hHAYigcRwHz8EniWP
         cANXExgnyZ4qkWZV4D/u/0mmtaHiG5R54N2xUZH+9O+T7s/9Y+LwZuWLMnXUKFO2yvSw
         l1bTLEPxg+CjrfVG9x0dSsafTiWCgoUmQwW7msN0Nz0xupch3QMqZaze5iJ7Tq4rjAUe
         9tOevhPD9dZXVshZE3mQGLuo4gUo7WFSSmOlQLRlCUpvA1e3nqocM2wAgkepTQm6+IFB
         3UElbJ+H3yBF0JeCvjJNg4GqprlHWs6+rz93ikXhJoF1qAVyhCQCqtPcqfPciA5apBxW
         NsAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CkhSwh0tn/SPxaM6seg68NrgymEV8OV7TF7kZYQtoSw=;
        fh=mTP6TkWV1IhQRgyhsEpYqIpiXvhDlZKdHAfNRdOTDjk=;
        b=TjPgl7COjY9dBoEuXZXkaFkaJ5hhRD4TOvEtYv33oT5s+J9d8JCyxVlj+9BMrM5Xzy
         eXwpfLCyyTS9LOmK8Ttpa5thluS986P1RP+7BrY+AX4Z7zXQmpqX69Ck/wvfn4QJfv8/
         fjN/ZOyS6OFjS2K6DfOeFgMfGUIBuUYtSiL/F5pm96tLsQthCCh10909kW+F3fF8ciDA
         dKeuQX4t5sDjA+hWtMG/JgzPSjJzf7vjY2OugI1TRpmhwNPRJVEYND43LJEr2Ewrp/Pt
         +tvf/2GeKU7x1EtEG6855/+yER7GzLCE7hQZM0m3eNlaNR4UyOmfpKchn2t8uY6FYBFi
         uNFQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782319868; x=1782924668; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CkhSwh0tn/SPxaM6seg68NrgymEV8OV7TF7kZYQtoSw=;
        b=CBC1dK6RalpAyA805GdKxPeeh0DIQpZ/PFyrZ2ZPqjYui8gw6ENApiQ2BkSaU79Gvf
         2uzBYY6KfUAPWLFk806lGSjJiQeZEV+VH3m4p1CaqT/ywFCxMK/EJmOQc45nOxrIiBmp
         MqArOJ/NIqAGNgeH+a9C/93N4k6+7IF87sDrmiZ3lVJ7ddBlJ0Ltu93A4LAXjCdMeLUg
         FpEr/nB8ghz8F3tEvcRpH1I/6txnJuF9cqpJibQ11PcfeXNbu+GYfooFr1WXpR/HYTAx
         kzAQ1Mm0BFYBhyDAvEbWZyoAPLrj+9KeP8EpZXh2oGhECzwTXevR3R6y2AB9IBKf6RJ4
         4DvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782319868; x=1782924668;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CkhSwh0tn/SPxaM6seg68NrgymEV8OV7TF7kZYQtoSw=;
        b=M6TyBKemMo0YY1ZvpwiDibT1mhDAnxqarZrX/B79NovWrsDVJD6SmwfyHdG5tiOZlX
         PJwsVq6WdTrFcZecEfrrqt/4rNVdOpZO0MR+1AF84pftuPMHgnsZtRNbD40rP/GNkoeh
         CcNz23vetc8zViIMwEsQUR4caEMV1dXYHyXQYuoMR7dxTToXYHkWH2uUqAcRj4RGH94+
         aqSpvNE03RzFPDjMlyeBzco1lNVbsQKQn6lyU0JcxnV73vbTUvn0g4X4GpAzW3DJ837h
         2gkUm+BXtTbs3sYIBM7aL7oJpPSCIIKVzvj8cG8CrSrOiFnNMhl3vwqgOINXYSBgZaaL
         virA==
X-Gm-Message-State: AOJu0Yy5SFt3tttxLY/qoGB2oFPSoH5oHG8U2N3wjPtQdq6zgqk8aDBq
	f1PLojtHhNvj17F81cv6NKPnQ1EfWKs/Qjd9/MGvs0LiVblc+9tL/QsZcaQYF14dklr8Vh61t0l
	ZjoemQy/Wsl5ub8ObRcZ7uHvyR8zoo9woDyjDXG8YCQ==
X-Gm-Gg: AfdE7ckk9a8Wmkoc/QgpDzzeN+e6keOejl1AhDluqxyhoPvW3dd9vz9qQWvs52+8OdI
	6vI5MDWw1Q6QN3aDjVDmNbWDaDQyvYZyANrLXw2GXMpQrAJuiTsBcuazD4JQlkz7Xlsq7XWJZZP
	oUkdNvP/Ij99eYMxCb/mk0ssVUE4kRRcYNZkDz6IGPLmUsR6pa6HgSZWulqx5BEDHwfRJdqAkKC
	RviWCRQDKnebJzLs28uI2TDaSMySkZwxKjW9L7gXZBBigcGlM3K6v8jxf5GyE1v2nSPKzdzFEJ3
	GaCi9X72snSYzXv3Hl0YGpupk+qyb/TVhGsDGcVyVTy5uW2x++0c4PWFdIwouj413iNuJ8IGtv0
	jJZ+HrdGXqu09
X-Received: by 2002:a17:903:240b:b0:2b0:608d:d8a8 with SMTP id
 d9443c01a7336-2c7e13bad7amr45153165ad.1.1782319868022; Wed, 24 Jun 2026
 09:51:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260624155421.211626-1-nishidafmly@gmail.com>
 <20260624155421.211626-6-nishidafmly@gmail.com> <20260624155828.3C6F91F000E9@smtp.kernel.org>
In-Reply-To: <20260624155828.3C6F91F000E9@smtp.kernel.org>
From: Hiroshi Nishida <nishidafmly@gmail.com>
Date: Wed, 24 Jun 2026 09:50:56 -0700
X-Gm-Features: AVVi8CdhXqTw5nypB8-AWepGa7-ArMWEpSofzhJN9Dg4XePtsj-rfRWJ7mxBlhc
Message-ID: <CAE1ksKTSn6dSApiYdNve8WZuDC7P=6KnDPODsvrWw=FJ-7W=gQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] md: clarify the resync ETA comment in status_resync()
To: sashiko-reviews@lists.linux.dev
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> The comment states that the divisor db is scaled up by 32, but the code
> rt =3D div64_u64(rt, db/32+1); divides db by 32 -- scaling it down.

You're right -- the code divides by db/32, which scales the divisor
*down* by 32 (so the intermediate quotient is 32x larger and keeps
low-order bits a plain divide by db would lose), and rt is then
rescaled by the >> 5.
My rewritten comment had the direction backwards.  I'll fix it in v2:

      rt is, in exact arithmetic, (remaining sectors) * dt / db.  To keep
      precision near the end of resync, when the remaining count is close t=
o db,
      the dividend is divided by db/32 rather than db -- i.e. the divisor i=
s
      scaled down by 32, so the intermediate quotient is 32x larger -- and =
rt is
      scaled back down by 32 (>> 5) afterwards.

  Thanks,

2026=E5=B9=B46=E6=9C=8824=E6=97=A5(=E6=B0=B4) 8:58 <sashiko-bot@kernel.org>=
:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [Low] The newly added comment incorrectly states that the divisor `db` =
is scaled up by 32, when the code actually scales it down.
> --
>
> commit 21672ecf7d2b823245c32b9d2699f7cf1a5c2e7c
> Author: Hiroshi Nishida <nishidafmly@gmail.com>
>
> md: clarify the resync ETA comment in status_resync()
>
> This commit updates the block comment above the remaining-time computatio=
n
> in status_resync() to clarify the calculation logic. It is a comment-only
> change.
>
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 0cd85cc92ed31..a5c0da0d11334 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -8916,17 +8916,11 @@ static int status_resync(struct seq_file *seq, =
struct mddev *mddev)
> >        * db: blocks written from mark until now
> >        * rt: remaining time
> >        *
> > -      * rt is a sector_t, which is always 64bit now. We are keeping
> > -      * the original algorithm, but it is not really necessary.
> > -      *
> > -      * Original algorithm:
> > -      *   So we divide before multiply in case it is 32bit and close
> > -      *   to the limit.
> > -      *   We scale the divisor (db) by 32 to avoid losing precision
> > -      *   near the end of resync when the number of remaining sectors
> > -      *   is close to 'db'.
> > -      *   We then divide rt by 32 after multiplying by db to compensat=
e.
> > -      *   The '+1' avoids division by zero if db is very small.
> > +      * rt is computed as (remaining sectors) * dt / db.  To keep prec=
ision
> > +      * near the end of resync, when the remaining count is close to d=
b, the
> > +      * divisor db is scaled up by 32 before the divide and rt is scal=
ed back
>
> [Severity: Low]
> Is this new comment accurate regarding the math applied to db?
>
> The comment states that the divisor db is scaled up by 32, but looking at
> the actual code:
>
>     rt =3D max_sectors - resync;
>     rt =3D div64_u64(rt, db/32+1);
>
> This divides db by 32, effectively scaling it down rather than up (which =
in
> turn scales the resulting quotient up). Does this comment need to be
> adjusted to reflect the db/32 downscaling?
>
> > +      * down by 32 afterwards.  The '+1' avoids division by zero when =
db is
> > +      * very small.
> >        */
> >       dt =3D ((jiffies - mddev->resync_mark) / HZ);
> >       if (!dt) dt++;
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260624155421.21=
1626-1-nishidafmly@gmail.com?part=3D5



--=20
Hiroshi Nishida
nishidafmly@gmail.com
