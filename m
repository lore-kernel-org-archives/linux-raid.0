Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF38142E8A
	for <linux-raid@vger.kernel.org>; Mon,  6 May 2024 15:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715010877; cv=none; b=c4Vk2/e2kkPTWII48B4inZAppPQjoeEZ5yYw/0jykxwBf5X8XTKAJhtS868d4cQbTjQNUYDqkmi28YrVh5pwIgqYNzVbxwqyoq/wca6YIUy7oJohQ1IKARHuTAk/FOE+y08vp9ubE+HqCYXs0OpDfSGAJwf2YwkKHS7XD1KxS6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715010877; c=relaxed/simple;
	bh=HD2Lr70I1iaNbFfTsVhdHXdzxz7xKET3Bj586QmEvN4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tcDQTPB3k15fHFssjm/WDXIlhEVcoj7jR3/E3vUAPbWy2vCO6hV9V/zRRCapG/G/mcSf7HYBT+hR7NsFvwHzeW3l75aordrXESwKeHDqUtMBzTqMei847HnSoVTwAeqqiCpgNfOL/P3kD5zx13kKbBHqzVCEkrWGkeILBlWdMyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cofbo4aY; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cofbo4aY"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-51fea3031c3so2554052e87.0
        for <linux-raid@vger.kernel.org>; Mon, 06 May 2024 08:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715010874; x=1715615674; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9rFbUTM/eTnD7X3tyAT1XWNTp1dxxcak5j8zWDDgzWM=;
        b=cofbo4aYGe2+ffmDDbQ8T82QLnSUQDjJ/oHt4lS2uQ4a7yklc30fpk35fkHGtRtOLC
         EepYip5X3uvgF7ZI99H0g3slQ78DbHeELMCdTI1WM9Lqxxggnw0kvHzX2+CUBiICqZSn
         Hi73w6CUhpy/flpe8LpKA8BehxnwBE1MiPcvT0XdETFr0POaQDOOtWB7RSww/kBUxdfc
         guxCnhLtORg46xd6q/wLPTt3Py9EKSChzl/Pzh2puR5lVllLfxvOKcDsBW7dlzfYh6Gc
         GE2Un1qWfIMzuTiuCzzj1+1tkUfQr4Ok4W1UnVgHfCQtiBF6qgHenSVkFA6wYLHwb7+Z
         WNlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715010874; x=1715615674;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9rFbUTM/eTnD7X3tyAT1XWNTp1dxxcak5j8zWDDgzWM=;
        b=Ajoov85ZbnFSqgbUp6ahyD3m8CZgsdan6BE7OKc2Dd9OYBTOHpwGO9CyQUJWyOMXCK
         ADvku2dDHecaYzG6qabN+RQyp3JYld1vvB8SDhC8xNtoc/1osQ79/srH4LdYILj24gQ3
         By9pHzChMzlB8AdqB8kO8dm6O9o8y+a9tmC4BGDyh4QhZpoO3E0uI4LZJYu/TABY3nyb
         4+xMR1Oatts4GJnxKSai9dpmHlH5pW1ARW/PPUrwcH1EJkyS9RMyuUXXzboHYrAX90HV
         Jk810+JY8NuyQUl2UFzVsTqybeTff3f+8uU7ru4hBZcSCT7LPt8h9zEER7ZAevj9vMx3
         UBKw==
X-Gm-Message-State: AOJu0YyJlYMVjcx8NnHdxJLQ3Q3RcqfWsqU1uxwU0omiZ3RCUrSGQCWO
	cNCorI6nX2bCB4yYcrfETkvWzZ2I4f+y8ZtpVqnJGpmYwJQu1T2rqOctk1zgklEF7M+54PoerxH
	tjVCMFzWxUr5xFtPw5cNeJH2ozp1ON1emVlg=
X-Google-Smtp-Source: AGHT+IG+I9UojaDhWuNeNgnPCO9OEuys/SLdbCVQw7v4tsk67pgU/bon/b8Rmnq05Qf+g6MymfaWYOauOHJyBLQHHV0=
X-Received: by 2002:ac2:550e:0:b0:51f:3b4d:b087 with SMTP id
 j14-20020ac2550e000000b0051f3b4db087mr8620884lfk.63.1715010874032; Mon, 06
 May 2024 08:54:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240505133923.267977-1-fontaine.fabrice@gmail.com> <20240506165644.000066aa@linux.intel.com>
In-Reply-To: <20240506165644.000066aa@linux.intel.com>
From: Fabrice Fontaine <fontaine.fabrice@gmail.com>
Date: Mon, 6 May 2024 17:54:22 +0200
Message-ID: <CAPi7W837_3Jn_oK1y5_ud6_eJKZufpzdi75QuW7h1EUTpHcP-A@mail.gmail.com>
Subject: Re: [PATCH] Makefile: add USE_PIE
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc: linux-raid@vger.kernel.org, Jes Sorensen <jes@trained-monkey.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le lun. 6 mai 2024 =C3=A0 16:56, Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> a =C3=A9crit :
>
> On Sun,  5 May 2024 15:39:23 +0200
> Fabrice Fontaine <fontaine.fabrice@gmail.com> wrote:
>
> > Do not hardcode -pie and allow the user to drop it (e.g. PIE could be
> > enabled or disabled by the buildsystem such as buildroot)
>
> What about -fPIE? It is in CWFLAGS but it is configurable.
> Do you specify you own set of CWFLAGS?

Yes, CWFLAGS is set to an empty value.

>
> >
> > Signed-off-by: Fabrice Fontaine <fontaine.fabrice@gmail.com>
> > ---
> >  Makefile | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/Makefile b/Makefile
> > index 7c221a89..a5269687 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -137,7 +137,11 @@ LDFLAGS =3D -Wl,-z,now,-z,noexecstack
> >  # If you want a static binary, you might uncomment these
> >  # LDFLAGS +=3D -static
> >  # STRIP =3D -s
> > -LDLIBS =3D -ldl -pie
> > +LDLIBS =3D -ldl
> > +USE_PIE =3D 1
> > +ifdef USE_PIE
> > +LDLIBS +=3D -pie
> > +endif
> >
> >  # To explicitly disable libudev, set -DNO_LIBUDEV in CXFLAGS
> >  ifeq (, $(findstring -DNO_LIBUDEV,  $(CXFLAGS)))
>
> AFAIK -pie is not library specifier, it is a a gcc linking setting so hav=
ing it
> in LDLIBS seems weird to me. What about making LDFLAGS configurable?

Sure, moving -pie to LDFLAGS and allowing the user to override it will
also work.

>
> diff --git a/Makefile b/Makefile
> index 7c221a891181..adac7905ab57 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -132,12 +132,12 @@ CFLAGS +=3D -DUSE_PTHREADS
>  MON_LDFLAGS +=3D -pthread
>  endif
>
> -LDFLAGS =3D -Wl,-z,now,-z,noexecstack
> +LDFLAGS ?=3D -pie -Wl,-z,now,-z,noexecstack
>
>  # If you want a static binary, you might uncomment these
>  # LDFLAGS +=3D -static
>  # STRIP =3D -s
> -LDLIBS =3D -ldl -pie
> +LDLIBS =3D -ldl
>
> It works on my setup however I'm not deeply sure if it is correct.
> Let me know if it resolves your issue. I would prefer to give possibility=
 to
> customize LDFLAGS rather than add ifdef to Makefile.
>
> Thanks,
> Mariusz

Best Regards,

Fabrice
