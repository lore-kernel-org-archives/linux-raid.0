Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A311D6DB6
	for <linux-raid@vger.kernel.org>; Thu, 17 Oct 2024 09:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729157119; cv=none; b=NgDdqeTp0pBJjuOjxHFjPSc7Eg0EBfBJu391B+yq+rjIdYDiOcQ7tXTQGamy7YdaUJcfDhjo1HJrefP4Y/h3/EoGJPk2JUJVLsKCToSJXemMpNH1mocRl/zUV9EPxDQRC4kug6t/6Djfq7Awk6yKr+LGTk1D/QhPSFzKktgFt9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729157119; c=relaxed/simple;
	bh=Nv1cj8T/ugY8aSlhvHMb8p0vitdjzZdvqVFgehud4uA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bnCEypxUmlB1PmHl7VM5sT7av7ZqB+1b82mr3DLNMWLyhT7Dd/XajNBFKwgZKtT3bljxU4MEAvzklgaLSolbyoV3vAtk8iNnhD2nthdkRzyf/jVs/aV96alp4dHJC9W5T2it0ca2ICtONwAbsRfiOXfQ4lRVvz/LQ6BCFH91NlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jSNHuG+r; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jSNHuG+r"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729157115;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uuhAttYgrkqwKZ85S0tAI7vmiboLHxU6/5ZusFfIlP8=;
	b=jSNHuG+rKW3lpPBKNiyaD/Yo2xwB6SdgyZdVpo2X0dRxASfqoaK377Je4stB3Abj57MJDt
	+PBm0Lf4Cx2f2KQgJTZqmhMzL7qq80lf1PjTay+YpLD6EGGFsisZNr5uj3pi7TPn2HHcsy
	SgHW/J2iRtOudgGzJXAOpn31P5mb/3E=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-376-zn2UKaW1MvyrVGgSajhHag-1; Thu, 17 Oct 2024 05:25:12 -0400
X-MC-Unique: zn2UKaW1MvyrVGgSajhHag-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-71e6241c002so773357b3a.1
        for <linux-raid@vger.kernel.org>; Thu, 17 Oct 2024 02:25:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729157111; x=1729761911;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uuhAttYgrkqwKZ85S0tAI7vmiboLHxU6/5ZusFfIlP8=;
        b=q70lpdI8u5xzPcVegQBwm2QfH9uqAZ9ITZAHn8sF6MlHWNnpoPlzvmFSsXima+ReUC
         EscV1LC10AhC80ToCF9HKLmE3y9E1VXs/BZRkCB3B7GY2iOpblutG9FepQ8whI0YYSSe
         gOnLZSzskMeNc0gOjluiYXybxzjJT+WhVeNTM3xfQ9ZS4k2+xnJwytwU+qDS6Jp55QU4
         xKtVLgDjYJKaDISHQ89V3P4hBCni/BhRF/adN2fhhcYiw0vbkXdJkjwzyEyHHqgEn8a7
         KgIGtMYUv6vmPVD1UoYxUDKgLlcq7gjrXMatSUJTNdmSm0VlcdtDkQjREXqiEzH1UxZq
         gezQ==
X-Forwarded-Encrypted: i=1; AJvYcCUyDFEdtGOgmSW633hd7EoaGHkmYtgyQbvd0dICzykImyYQ1xRhNOoul9kvEx00JRjPWMKadmyrwe4l@vger.kernel.org
X-Gm-Message-State: AOJu0Yyxc+aFK5aDnkevKPDqgHzWYx4odhGv7+tLx/xyVEllO3qrneYc
	dmtDwu5AOJKBQhjJXHw1pl4Rw49qcDygHrASZscwNVsnHQKP0TndKCrVntY1JqYvRCCOsnIms26
	aPh9vjMhVPiiaftLqZzlzy2+416LnucJ5lxzeff7OKglZm1qq7zicPQEbKwIvzk8NmBsdIZjaqn
	14N7i4cebZREHAZT2eJ6xlO39DfhEwcAi0jw==
X-Received: by 2002:a05:6a00:8906:b0:71e:427e:e679 with SMTP id d2e1a72fcca58-71e8fd5e1admr3687083b3a.4.1729157111429;
        Thu, 17 Oct 2024 02:25:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IExj2bGT78tkGsjpt6y/EXlYyb8wFjSyDw7tvTkpAWS4gSf5ca0gGLZwlkqNe49CPKr55HyC76daI0/p0PkWV0=
X-Received: by 2002:a05:6a00:8906:b0:71e:427e:e679 with SMTP id
 d2e1a72fcca58-71e8fd5e1admr3687057b3a.4.1729157110998; Thu, 17 Oct 2024
 02:25:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241015173553.276546-1-loberman@redhat.com> <20241016101433.00005bb9@linux.intel.com>
 <5321cf0e579ee5e025396e9f9b62432dd2ed3458.camel@redhat.com>
In-Reply-To: <5321cf0e579ee5e025396e9f9b62432dd2ed3458.camel@redhat.com>
From: Xiao Ni <xni@redhat.com>
Date: Thu, 17 Oct 2024 17:24:59 +0800
Message-ID: <CALTww29q5M_to+nN4G6rSdVMMbBj5orBjTE3dCUcBc6ZzAX1bg@mail.gmail.com>
Subject: Re: [PATCH] Add the ":" to the allowed_symbols list to work with the
 latest POSIX changes
To: Laurence Oberman <loberman@redhat.com>
Cc: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>, 
	"Hellwig, Christoph" <hch@infradead.org>, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 16, 2024 at 9:11=E2=80=AFPM Laurence Oberman <loberman@redhat.c=
om> wrote:
>
> On Wed, 2024-10-16 at 10:14 +0200, Mariusz Tkaczyk wrote:
> > On Tue, 15 Oct 2024 13:35:24 -0400
> > Laurence Oberman <loberman@redhat.com> wrote:
> >
> > Hello Laurence,
> > Thanks for the patch.
> >
> > ":" is used internally by native metadata name, we have
> > "hostname:name". We are
> > searching for it specifically, for that reason I think that I cannot
> > accept it.
> > Name must stay simple.
> >
> > If you want this again, I need to full set of mdadm tests that is
> > covering every
> > scenario and is confirming that we are able to determine hostname (if
> > exists)
> > and name in every case correctly.
> >
> > There are some workaround in code for that, I can see that we are not
> > appending
> > homehost if ":" is in the name. It is not user friendly. I prefer to
> > not
> > allow ":" to keep in simpler unless you have really good reason to
> > have it back
> > - there is no reason in commit message.
> >
> >
> > > Signed-off-by: Laurence Oberman <loberman@redhat.com>
> > > ---
> > >  lib.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/lib.c b/lib.c
> > > index f36ae03a..cb4b6a0f 100644
> > > --- a/lib.c
> > > +++ b/lib.c
> > > @@ -485,7 +485,7 @@ bool is_name_posix_compatible(const char *
> > > const name)
> > >  {
> > >         assert(name);
> > >
> > > -       char allowed_symbols[] =3D "-_.";
> > > +       char allowed_symbols[] =3D "-_.:";
> >
> > Because the function has been made to follow POSIX, this cannot be
> > simply added
> > here. Please at least explain that in description.
> >
> > It is not POSIX compatible with this change.
> >
> >
> > >         const char *n =3D name;
> > >
> > >         if (!is_string_lq(name, NAME_MAX))
> >
> > Thanks,
> > Mariusz
> >
>
> Hello
> Apologies Christoph and Mariusz, this could have definitely done with
> more of an explanation.
>
> We have customers complaining about a regression in mdadm since these
> changes happened. They have 1000's of raid devices that can no longer
> be started because they have ":" in the name. Example
> mdadm: Value "tbz:pv1" cannot be set as devname. Reason: Not POSIX
> compatible.
>
> Should we add a --legacy flag where the original behavior is still an
> option, what are your thoughts ?
>
> Regards
> Laurence
>
>

Hi Laurence and Mariusz

Can we allow assemble an array whose devname has ":"? So the users can
assemble the arrays which were created before patch e2eb503bd797
(mdadm: Follow POSIX Portable Character Set).

For creating an array, we can still follow the POSIX policy. So it can
keep the naming rule simpler.

Best Regards
Xiao

