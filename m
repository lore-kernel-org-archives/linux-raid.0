Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7206C146D6A
	for <linux-raid@vger.kernel.org>; Tue, 18 Mar 2025 08:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742285910; cv=none; b=N/pICrswoOYLLThiOVK0Z9jtu+cg8/OeAgUJVvlr/pBkSo1U6CJ+Lrq0Ln+KYlFZ9Q9cDmKDvEbDd4qhMKdWlhln3ExI6Uez+koScdObtWc7v79DSfHGTbQeDWQ3nptz82jACVm97jSVdHZoczzCg327MSCZXOkwq/rmXOcYIu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742285910; c=relaxed/simple;
	bh=sUCMCjyRhT9khG6Dr7Bm2aUIVsQ7oH3d2U0rwQoerrY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FXUpPP0ImZpmQxneCQlc5XnbiRKmlsRUCvS4AAri95YikBAuKA3KGCZ1NVbwTKSFnYp/K8pfs6MOJWtszwnGEvhVrHuZnw7IDRKsJXH3xxyBVEyFTCVsuc3RUmlYdXaOXZjBBUOPtMpeE41bwSG88XMRyUVFM5AQ5EpPokGqSeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FVAkd/6d; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FVAkd/6d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742285907;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=746JNW11L9zzJsLpF841AlcCyfbqtwDQruPU3yRuKAc=;
	b=FVAkd/6dJYLKhtS2QCSzw95//5p6ZULcpAA82OUZWD/5uzfuaombhg2BLOcNCTM1oV//DD
	KOoa1qAoTv8iC7UYyVqFqVxBmgVb5IMdkO9fNt5dbL2DIlJHklMSrr5WA/CWVTnBOB2bOW
	Yd1kyylOjrRLi76hHSPVw+OyIZHU7xY=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-694-Q5inz0UfOoSNaj4jSWHp8w-1; Tue, 18 Mar 2025 04:18:25 -0400
X-MC-Unique: Q5inz0UfOoSNaj4jSWHp8w-1
X-Mimecast-MFC-AGG-ID: Q5inz0UfOoSNaj4jSWHp8w_1742285904
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-30c13a6f641so25367821fa.3
        for <linux-raid@vger.kernel.org>; Tue, 18 Mar 2025 01:18:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742285903; x=1742890703;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=746JNW11L9zzJsLpF841AlcCyfbqtwDQruPU3yRuKAc=;
        b=CPf6pyiSq9hgC3RL4wF34y2huAnly2Z7iFuoWgcsO9Ac9fl6rmr6+B+GZRb3Cctevr
         x90s/9PfJl3QsLm0T1kPNVQj4+J9ZBUD8ZOzqlNNiVBekZW+xA1VZ8omdOnMYJs6zByJ
         8B21U0MEGLkpvOad0t9lA5jnMUUucOxZrx/Z90mb6JN/mT5GuwsUfCxWqFBOaNBb0rBv
         ttY0PV3rWC4NQnk2an4K3xCLJi+X2vfpvt1Ns+hNiIwmoW3214Vx+jtYfLHFCKaVJL1k
         +V9UNt1/MVrTsoVVeIWZat2LGhGo9xj38k7iqmpPLwNdout7+aguwiXwzTtdMlfzQmgi
         7ZLQ==
X-Gm-Message-State: AOJu0Yx3nIwdcGhoYFDb1XLF/L9VbLQrONzCaFunj0zWXjBaJVoOBYHG
	P4LeZJUATCv50GXLrZQfi990z/R/Y9Eqvw8P15YEy/AvlU/zM4cqMIMIwFEXYMV9/FdjijoLRMW
	Mad99m7u5xg07/AI/X++dHCiN1P7IzR175EfjCXtqNOTT8dc0RTwrtOtAI8MxOuA4pwYy5kVvJl
	99w5z6qI7btahxn08wmlXDq04i1IHTjWOhMfgTnVum7rUbGUI=
X-Gm-Gg: ASbGncuvhGi11aexxy0dgc22O8FiTfP28bcY5rT24Yu86VDwO8n94WEu5CNrKC67ZiN
	Owy5OYVbwqVmRA1hsShsy6Lba+mz0iAe7gtxUwINmR7yFtaXa3PaCz9yxiNIKId+4BCYVnKPkjw
	==
X-Received: by 2002:a2e:8006:0:b0:308:f0c9:c4cf with SMTP id 38308e7fff4ca-30c4a8e548fmr76670741fa.33.1742285902800;
        Tue, 18 Mar 2025 01:18:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH/MAuEeuQmwcnCmNCD3VHe3KmBJp/24vjnjRYHdokUGxztSFtlPdu5WAae3Foxd9p871LD3nqjUgHCNPqy0VI=
X-Received: by 2002:a2e:8006:0:b0:308:f0c9:c4cf with SMTP id
 38308e7fff4ca-30c4a8e548fmr76670591fa.33.1742285902383; Tue, 18 Mar 2025
 01:18:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250318054638.58276-1-xni@redhat.com> <a5cd31f5-b7b8-4859-9a8e-1ef58f3aee95@molgen.mpg.de>
In-Reply-To: <a5cd31f5-b7b8-4859-9a8e-1ef58f3aee95@molgen.mpg.de>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 18 Mar 2025 16:18:10 +0800
X-Gm-Features: AQ5f1JrwmyPelXg6Lqrhoep8XE8F7T2uk6zSf8UBUQQVojKet2jqhbuF2GVO16o
Message-ID: <CALTww295vr1+3eiqqQ=49jPNxF58k0avLU3wnJstpmGE+2nGzg@mail.gmail.com>
Subject: Re: [PATCH 1/1] mdadm: check posix name before setting name and devname
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: linux-raid@vger.kernel.org, ncroxon@redhat.com, 
	mariusz.tkaczyk@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 18, 2025 at 3:38=E2=80=AFPM Paul Menzel <pmenzel@molgen.mpg.de>=
 wrote:
>
> Dear Xiao,
>
>
> Thank you for the patch. Wasn=E2=80=99t a similar patch sent to the list =
already
> months ago?
>
> For the commit message subject/title I suggest:
>
> mdadm: Allow to assemble existing arrays with non-POSIX names

Hi Paul

Thanks for reminding me about this. I forgot about this patch. I can't
find the patch. Do you still have the link for it?

>
> Am 18.03.25 um 06:46 schrieb Xiao Ni:
> > It's good to has limitation for name when creating an array. But the ar=
rays
>
> =E2=80=A6 to have limitations =E2=80=A6
>
> > which were created before patch e2eb503bd797 (mdadm: Follow POSIX Porta=
ble
> > Character Set) can't be assembled. In this patch, it removes the posix
> > check for assemble mode.
>
> =E2=80=9CIn this patch=E2=80=9D is redundant in the commit message. Maybe=
:
>
> So, remove the POSIX check for assemble mode.

good to me.

>
> Maybe add how to reproduce this? Is there a way to create a non-POSIX
> name with current mdadm, or should such a file be provided for tests.

For example:

* build mdadm without patch e2eb503bd797
* mdadm -CR /dev/md/tbz:pv1 -l0 -n2 /dev/loop0 /dev/loop1
* mdadm -Ss
*  build with latest mdadm, and try to assemble it.
* mdadm -A /dev/md/tbz:pv1 --name tbz:pv1
mdadm: Value "tbz:pv1" cannot be set as name. Reason: Not POSIX compatible.

Regards
Xiao
>
> > Fixes: e2eb503bd797 (mdadm: Follow POSIX Portable Character Set)
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> >   config.c |  8 ++------
> >   mdadm.c  | 11 +++++++++++
> >   2 files changed, 13 insertions(+), 6 deletions(-)
> >
> > diff --git a/config.c b/config.c
> > index 8a8ae5e48c41..ef7dbc4eb29f 100644
> > --- a/config.c
> > +++ b/config.c
> > @@ -208,11 +208,6 @@ static mdadm_status_t ident_check_name(const char =
*name, const char *prop_name,
> >               return MDADM_STATUS_ERROR;
> >       }
> >
> > -     if (!is_name_posix_compatible(name)) {
> > -             ident_log(prop_name, name, "Not POSIX compatible", cmdlin=
e);
> > -             return MDADM_STATUS_ERROR;
> > -     }
> > -
> >       return MDADM_STATUS_SUCCESS;
> >   }
> >
> > @@ -512,7 +507,8 @@ void arrayline(char *line)
> >
> >       for (w =3D dl_next(line); w !=3D line; w =3D dl_next(w)) {
> >               if (w[0] =3D=3D '/' || strchr(w, '=3D') =3D=3D NULL) {
> > -                     _ident_set_devname(&mis, w, false);
> > +                     if (is_name_posix_compatible(w))
> > +                             _ident_set_devname(&mis, w, false);
> >               } else if (strncasecmp(w, "uuid=3D", 5) =3D=3D 0) {
> >                       if (mis.uuid_set)
> >                               pr_err("only specify uuid once, %s ignore=
d.\n",
> > diff --git a/mdadm.c b/mdadm.c
> > index 6200cd0e7f9b..9d5b0e567799 100644
> > --- a/mdadm.c
> > +++ b/mdadm.c
> > @@ -732,6 +732,11 @@ int main(int argc, char *argv[])
> >                               exit(2);
> >                       }
> >
> > +                     if (mode !=3D ASSEMBLE && !is_name_posix_compatib=
le(optarg)) {
> > +                             pr_err("%s Not POSIX compatible\n", optar=
g);
> > +                             exit(2);
> > +                     }
> > +
> >                       if (ident_set_name(&ident, optarg) !=3D MDADM_STA=
TUS_SUCCESS)
> >                               exit(2);
> >
> > @@ -1289,6 +1294,12 @@ int main(int argc, char *argv[])
> >                       pr_err("an md device must be given in this mode\n=
");
> >                       exit(2);
> >               }
> > +
> > +             if (mode !=3D ASSEMBLE && !is_name_posix_compatible(devli=
st->devname)) {
> > +                     pr_err("%s Not POSIX compatible\n", devlist->devn=
ame);
> > +                     exit(2);
> > +             }
> > +
> >               if (ident_set_devname(&ident, devlist->devname) !=3D MDAD=
M_STATUS_SUCCESS)
> >                       exit(1);
> >
>

