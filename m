Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63C51E4A0
	for <linux-raid@vger.kernel.org>; Sun,  5 May 2024 17:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714930702; cv=none; b=b4B5USJ+iBEDtaxhNQe0l3vQQnghQ1Rc+VKGQNdPQhDyg6lXZtpduTkJtoI7/FTkWvwvCqemsrPRmUV4CujIzdmiGXzbcb0lD4/KsU8EF5zuWEYRbUzU1N+YDn/Tr4Md7UBXOVLl63NQLSMvtvnk9rBQDvs2Cw4mHvW/AOx7WHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714930702; c=relaxed/simple;
	bh=rKfPJY55ppSVOVNCNi1/BAQaXzeP2cf70Aib8AfWZ9g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qYDj9nNmHQQk4+pBgpLpKd/OLRKCRzezuIa0EiRQKXfIYyW+50V7iBfvXmTpDx5GFGNi58wOJhXWUtLaNAOA+tMeHKLXpR1GfYlETHwo8ShHHN8id3YBkUJq/lCyNgKKp4LnFuijQXK1ERaz8WSUXj1qDb9kwhrTjsDDwimvN1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lmzLuzzU; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lmzLuzzU"
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2e1fa2ff499so27967131fa.0
        for <linux-raid@vger.kernel.org>; Sun, 05 May 2024 10:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714930698; x=1715535498; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xaRArr9fDgwk+335lMlQfqLJ1QPW4M4LQDaooC70MGE=;
        b=lmzLuzzUyyRMWabianFbZSWD4Z9nFc6jUR8zz2RRqzh3sooeMVUfWJEmD1lgVt269J
         GxXC90QrulLoMN05igX7zmnhKJY+nvnyxAmins3En38qtmqgrSJuUOUMKREOkeYdyw7z
         cqdR5uJbeR+EFXm90cvSCi9nyaBVkq9/Fc/de3kAjOJjwlfBANze5h8QmTegc816KclX
         YdwXQn6nHNwtdbe3Ay7DfX1tBTrMJe+H3gtc0a8nK9QIQkSDM2Op3TbHPrZ/CxqH7EJf
         R7WggAvxB7Lh28XGzr7H8rYvtWH4pbYPBSYJ7e159UTbhVQLpccncJNcJFmztRYWZXER
         h0xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714930698; x=1715535498;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xaRArr9fDgwk+335lMlQfqLJ1QPW4M4LQDaooC70MGE=;
        b=vbiOzE7y9iwim7lIud6VYk8rLOem0Ym7f1TmDUDtE4+XmHLKMDLHNcW1SQlWHIZ1So
         zWeDMRwir3Xn06DzrNdy4TmCj4jR+jYcf0F09bmxC2FXSKAdb9+RnDXVkXigWESCaJl9
         Ua36fFALRcplgfKMs4g8D7BL6snIKrt+xF/3H2ZfaDjmwZNDmat0b1kZ874YzKROLh5d
         hF7G0aPP1CLsIM7G/GWxobornDCyXANV0shVrKDJ1s23ZHJMaNoA4WGQoi2YuCbFnKkG
         D9KU6caMcV7tM0GEliYy3taln7kO9FQc9JT5s4qXE0NZoNZGvqwCay2UxCUfWIjg1vqc
         l8mA==
X-Forwarded-Encrypted: i=1; AJvYcCV56vfIwwEsMBjWWMatCnTp2SeNFnjEB9Z7lq2Ph9SgvWxMM2B+icCUnE6k9LlT0joYc4lZKdXoXkwGDGfomgdjdnqczXZ6OlL5EA==
X-Gm-Message-State: AOJu0YyFprZuDP0CsXHZd+AvdgcdXLZ94+WL4CNpqiGDIsidXxcKF3au
	wUJwI0Uvxdgvw9CaxrmnrSn8OUnoksn9GJ09rANhz2yvkcNzV+u9vNd9MZQNCYvenB9sR7IMj1U
	PkzJdCxKQn3LX2d3f/T0kzrbyYg/zbliW
X-Google-Smtp-Source: AGHT+IHyqxOdKC+dCCIYf+DSspb/oMkhN2s0wqDzg2vzGqOXPo9cjtDsq3RtnLV7PZiRhne8Rbtw2i4vYiw/rh+hiqI=
X-Received: by 2002:a05:6512:34d3:b0:51f:6081:82fc with SMTP id
 w19-20020a05651234d300b0051f608182fcmr2058585lfr.9.1714930698281; Sun, 05 May
 2024 10:38:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240505133923.267977-1-fontaine.fabrice@gmail.com> <4ddf4e3b-cdf0-4e15-8070-42b20253eeca@molgen.mpg.de>
In-Reply-To: <4ddf4e3b-cdf0-4e15-8070-42b20253eeca@molgen.mpg.de>
From: Fabrice Fontaine <fontaine.fabrice@gmail.com>
Date: Sun, 5 May 2024 19:38:06 +0200
Message-ID: <CAPi7W82uzvHBYgzAvPO5jPsSrA+D50WRuHQj43sY0wLqx=Na+Q@mail.gmail.com>
Subject: Re: [PATCH] Makefile: add USE_PIE
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Jes Sorensen <jes@trained-monkey.org>, 
	Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Paul,

Le dim. 5 mai 2024 =C3=A0 19:22, Paul Menzel <pmenzel@molgen.mpg.de> a =C3=
=A9crit :
>
> Dear Fabrice,
>
>
> Thank you for your patch.
>
> Am 05.05.24 um 15:39 schrieb Fabrice Fontaine:
> > Do not hardcode -pie and allow the user to drop it (e.g. PIE could be
> > enabled or disabled by the buildsystem such as buildroot)
>
> This sounds reasonable, but it changes the current default behavior,
> doesn=E2=80=99t it? Could you please elaborate, when this was added, and =
if the
> new default would break systems?

Why are you saying that it changes the current default behavior?
USE_PIE is set to 1 by default but perhaps I missed something.

>
> A formal nit pick for the commit messages would be to please add a
> dot/period at the end of sentences.)
>
> > Signed-off-by: Fabrice Fontaine <fontaine.fabrice@gmail.com>
> > ---
> >   Makefile | 6 +++++-
> >   1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/Makefile b/Makefile
> > index 7c221a89..a5269687 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -137,7 +137,11 @@ LDFLAGS =3D -Wl,-z,now,-z,noexecstack
> >   # If you want a static binary, you might uncomment these
> >   # LDFLAGS +=3D -static
> >   # STRIP =3D -s
> > -LDLIBS =3D -ldl -pie
> > +LDLIBS =3D -ldl
> > +USE_PIE =3D 1
> > +ifdef USE_PIE
> > +LDLIBS +=3D -pie
> > +endif
> >
> >   # To explicitly disable libudev, set -DNO_LIBUDEV in CXFLAGS
> >   ifeq (, $(findstring -DNO_LIBUDEV,  $(CXFLAGS)))
>
>
> Kind regards,
>
> Paul

Best Regards,

Fabrice
