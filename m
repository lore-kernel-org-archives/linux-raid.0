Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C97D1F09BF
	for <linux-raid@vger.kernel.org>; Tue, 18 Mar 2025 08:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742287437; cv=none; b=eVZxMB04Rij6q78HtuSFR/MqkxTogILCaIMeOQHIAU7gyEaGTDvTf8Xfab79qAEs/f5M8KRJvHgynHIO4AhP5D3xg7lgduqI7XxEbw3GofHI2x2q5EVON9Uo3cE4Ckbu/QRJkVMOjhPi5ftN4qQevoR0PB7GnOREraIM6Pnwkvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742287437; c=relaxed/simple;
	bh=pSPBggvT8h7gFQHr/fZ5p6fobqkAKJCnhoSV6r3nNFk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SgyZgYZqAEJG3+/KzsQiCCVE/iL7q/67SnSoktGtCde/D9uUsB7rgtMcmzYkGTGh1sawCP6c/DjAzOSYRzIP1ofya/+t3qrxjKi2TKW9VLBmJ649+82svuNfvr52Lnfu1pH5HVXLf53fPZRMJDMDvNi1qGjeAYVzFTqd54eBhNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dKQg23Vz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dKQg23Vz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742287434;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LYD/l6lcZygkchNasDbylgUkCUyqoXl7XQPwXzw0gzQ=;
	b=dKQg23Vza74063okiGW2XVb21G5MP0yyHl/byFVfM/ZXeJ0tXTIFah84RfZ9Ng6LT1zZdi
	7Fh8KaM57UAcdwF6METC5zMW5yli6Npo5x0ML8mBVk65TiDlpXKs/UAzij714S+UqPAMZS
	7wBndGflJzvQVFetBnaBtSDM+Ql90rM=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-648-UPlT3cjpOmadTiflcpLedg-1; Tue, 18 Mar 2025 04:43:53 -0400
X-MC-Unique: UPlT3cjpOmadTiflcpLedg-1
X-Mimecast-MFC-AGG-ID: UPlT3cjpOmadTiflcpLedg_1742287432
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5499d4435caso2635892e87.0
        for <linux-raid@vger.kernel.org>; Tue, 18 Mar 2025 01:43:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742287431; x=1742892231;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LYD/l6lcZygkchNasDbylgUkCUyqoXl7XQPwXzw0gzQ=;
        b=d6qac4qA09n81ZkviDYhD+HueLSk44ObyrlW9SAw+wlWjdgRxE1CI9ALqv/nN53EmL
         PxrVFmFKVxa6gl44F+pN1J7hHydSqg9LplS+Oj1QV843boExBAfohfninScz8BjzF2J4
         cOiXfI4z6+xgnsfUMGcDsCDgRROJRZLgMSkWk2q5kQ1gFaSP74b9EnMoUcdgzUv3o/sw
         2vAakF7pLQ1TaSVRNaFuNJbE0MKLE0CSH2P48phHJx4pQvVp9AnhMcPUixJ1nPhnm/Ra
         E7XLuT9QwZhrvhHv5IpfdUYsp4cY6Rtuexf1znd7jJGhs2sGCGsZQrg2pt+aRmgckuae
         PQ1Q==
X-Gm-Message-State: AOJu0YwBK1OMO4zf+z+/YWDpbzpn7X5iek3DaIdYC46Cu3I9XWa/YbLe
	MgHzczRmom0h0pXNLACxL5au1FBob6QIZ+zeO82kvYA9HTSWRAbYU0GQpjYITD0hm3bfugV8OtB
	crJI2LWPV08FLrkgphLNNP821W5K/WkjJ1S6cydI7DOV/7XXzRDQWuele4+AU0+/yD00q972xa+
	j0tMOcum+QG+xVx+HkaxbW5pDpOpqlHB0QshTTMTi0ZYQt
X-Gm-Gg: ASbGncsNuS5tImaV/9Lop0uTHgGy/RvSxAhRsLZA+oBpH0HECzIYe6OGVyQPExrtikR
	AQekFYyw57DVCpEmNGkAy4BTbqO0WuN6rRAALLedXkl1kDT/i3tX+L9DEHYuNE+6Eq4OvHJ4CPg
	==
X-Received: by 2002:a05:6512:b06:b0:545:519:2d9e with SMTP id 2adb3069b0e04-549c3989567mr10300930e87.47.1742287430496;
        Tue, 18 Mar 2025 01:43:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG5KKJYeQCDfjYA2Yj4tdzdQul5mb2oGSnXYkbMwdwppwLUoCi/gN3OiDiw1TETp1u4xMu2Ed9GSFmb5BNZzmc=
X-Received: by 2002:a05:6512:b06:b0:545:519:2d9e with SMTP id
 2adb3069b0e04-549c3989567mr10300924e87.47.1742287430045; Tue, 18 Mar 2025
 01:43:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250318054638.58276-1-xni@redhat.com> <a5cd31f5-b7b8-4859-9a8e-1ef58f3aee95@molgen.mpg.de>
 <CALTww295vr1+3eiqqQ=49jPNxF58k0avLU3wnJstpmGE+2nGzg@mail.gmail.com> <773b0d70-2862-4bfc-b837-8685f481ec8c@molgen.mpg.de>
In-Reply-To: <773b0d70-2862-4bfc-b837-8685f481ec8c@molgen.mpg.de>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 18 Mar 2025 16:43:38 +0800
X-Gm-Features: AQ5f1JpSJFwXHgiqntYzcTd1To_eFGqo7gNb-iqRLhqL9ANtwcuQ_dpY8vbijbs
Message-ID: <CALTww2_9hQE7NAQHY2ntpg=snAsywuinJqNULzF+E08aysF6kQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] mdadm: check posix name before setting name and devname
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: linux-raid@vger.kernel.org, ncroxon@redhat.com, 
	mariusz.tkaczyk@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 18, 2025 at 4:24=E2=80=AFPM Paul Menzel <pmenzel@molgen.mpg.de>=
 wrote:
>
> Dear Xiao,
>
>
>
> Am 18.03.25 um 09:18 schrieb Xiao Ni:
> > On Tue, Mar 18, 2025 at 3:38=E2=80=AFPM Paul Menzel <pmenzel@molgen.mpg=
.de> wrote:
>
> >> Thank you for the patch. Wasn=E2=80=99t a similar patch sent to the li=
st already
> >> months ago?
> >>
> >> For the commit message subject/title I suggest:
> >>
> >> mdadm: Allow to assemble existing arrays with non-POSIX names
>
> > Thanks for reminding me about this. I forgot about this patch. I can't
> > find the patch. Do you still have the link for it?
>
> I searched for *e2eb503bd797* in the linux-raid archive [1], I found the
> patch and discussion *[PATCH] Add the ":" to the allowed_symbols list to
> work with the latest POSIX changes* [2]. So, similar, and I think only
> the topic of already created arrays came up, your patch solves. Sorry
> for the confusion.

Thanks for finding it. It doesn't resolve the problem. So this patch
tries to resolve the problem.

>
> >> Am 18.03.25 um 06:46 schrieb Xiao Ni:
> >>> It's good to has limitation for name when creating an array. But the =
arrays
> >>
> >> =E2=80=A6 to have limitations =E2=80=A6
> >>
> >>> which were created before patch e2eb503bd797 (mdadm: Follow POSIX Por=
table
> >>> Character Set) can't be assembled. In this patch, it removes the posi=
x
> >>> check for assemble mode.
> >>
> >> =E2=80=9CIn this patch=E2=80=9D is redundant in the commit message. Ma=
ybe:
> >>
> >> So, remove the POSIX check for assemble mode.
> >
> > good to me.
> >
> >> Maybe add how to reproduce this? Is there a way to create a non-POSIX
> >> name with current mdadm, or should such a file be provided for tests.
> >
> > For example:
> >
> > * build mdadm without patch e2eb503bd797
> > * mdadm -CR /dev/md/tbz:pv1 -l0 -n2 /dev/loop0 /dev/loop1
> > * mdadm -Ss
> > *  build with latest mdadm, and try to assemble it.
> > * mdadm -A /dev/md/tbz:pv1 --name tbz:pv1
> > mdadm: Value "tbz:pv1" cannot be set as name. Reason: Not POSIX compati=
ble.
>
> Thank you. For running tests, re-building mdadm might not be feasible.
> But having these instructions would be great to have in the commit
> message nevertheless.

It's right. I'll add them into the commit message.

Regards
Xiao
>
> >>> Fixes: e2eb503bd797 (mdadm: Follow POSIX Portable Character Set)
> >>> Signed-off-by: Xiao Ni <xni@redhat.com>
> >>> ---
> >>>    config.c |  8 ++------
> >>>    mdadm.c  | 11 +++++++++++
> >>>    2 files changed, 13 insertions(+), 6 deletions(-)
> >>>
> >>> diff --git a/config.c b/config.c
> >>> index 8a8ae5e48c41..ef7dbc4eb29f 100644
> >>> --- a/config.c
> >>> +++ b/config.c
> >>> @@ -208,11 +208,6 @@ static mdadm_status_t ident_check_name(const cha=
r *name, const char *prop_name,
> >>>                return MDADM_STATUS_ERROR;
> >>>        }
> >>>
> >>> -     if (!is_name_posix_compatible(name)) {
> >>> -             ident_log(prop_name, name, "Not POSIX compatible", cmdl=
ine);
> >>> -             return MDADM_STATUS_ERROR;
> >>> -     }
> >>> -
> >>>        return MDADM_STATUS_SUCCESS;
> >>>    }
> >>>
> >>> @@ -512,7 +507,8 @@ void arrayline(char *line)
> >>>
> >>>        for (w =3D dl_next(line); w !=3D line; w =3D dl_next(w)) {
> >>>                if (w[0] =3D=3D '/' || strchr(w, '=3D') =3D=3D NULL) {
> >>> -                     _ident_set_devname(&mis, w, false);
> >>> +                     if (is_name_posix_compatible(w))
> >>> +                             _ident_set_devname(&mis, w, false);
> >>>                } else if (strncasecmp(w, "uuid=3D", 5) =3D=3D 0) {
> >>>                        if (mis.uuid_set)
> >>>                                pr_err("only specify uuid once, %s ign=
ored.\n",
> >>> diff --git a/mdadm.c b/mdadm.c
> >>> index 6200cd0e7f9b..9d5b0e567799 100644
> >>> --- a/mdadm.c
> >>> +++ b/mdadm.c
> >>> @@ -732,6 +732,11 @@ int main(int argc, char *argv[])
> >>>                                exit(2);
> >>>                        }
> >>>
> >>> +                     if (mode !=3D ASSEMBLE && !is_name_posix_compat=
ible(optarg)) {
> >>> +                             pr_err("%s Not POSIX compatible\n", opt=
arg);
> >>> +                             exit(2);
> >>> +                     }
> >>> +
> >>>                        if (ident_set_name(&ident, optarg) !=3D MDADM_=
STATUS_SUCCESS)
> >>>                                exit(2);
> >>>
> >>> @@ -1289,6 +1294,12 @@ int main(int argc, char *argv[])
> >>>                        pr_err("an md device must be given in this mod=
e\n");
> >>>                        exit(2);
> >>>                }
> >>> +
> >>> +             if (mode !=3D ASSEMBLE && !is_name_posix_compatible(dev=
list->devname)) {
> >>> +                     pr_err("%s Not POSIX compatible\n", devlist->de=
vname);
> >>> +                     exit(2);
> >>> +             }
> >>> +
> >>>                if (ident_set_devname(&ident, devlist->devname) !=3D M=
DADM_STATUS_SUCCESS)
> >>>                        exit(1);
>
> Kind regards,
>
> Paul
>
>
> [1]: https://lore.kernel.org/linux-raid/?q=3De2eb503bd797
> [2]:
> https://lore.kernel.org/linux-raid/20241015173553.276546-1-loberman@redha=
t.com/
>

