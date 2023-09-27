Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 390A4E80A88
	for <linux-raid@archiver.kernel.org>; Wed, 27 Sep 2023 05:20:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjI0FUO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 27 Sep 2023 01:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbjI0FTZ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 27 Sep 2023 01:19:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74F344A3
        for <linux-raid@vger.kernel.org>; Tue, 26 Sep 2023 22:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695791212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l3JLbfTd+91AU1g6fE7ktURt7BkT7T2Jnsf0rr1D9Lo=;
        b=h+4yIQTUVQN1lH6wJO8u2bZIrmyCinlsDK5N6m/K12jlDkgoo0QYrNwXGGVNuu4YlCsee8
        mlPLKiIBaGprP+0X/YlAlORUXdYpWHmy4PP1PfTJBGCsL4Ot3E4KfUFkZCeBAUKnUZ7qiX
        yd1CUg4ZgvFMN6W75kdU29U+D2Xc5Aw=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-13-gxCVy6BlNXuHRj-Y6DecFw-1; Wed, 27 Sep 2023 01:06:50 -0400
X-MC-Unique: gxCVy6BlNXuHRj-Y6DecFw-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2775d6943c3so6601308a91.1
        for <linux-raid@vger.kernel.org>; Tue, 26 Sep 2023 22:06:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695791209; x=1696396009;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l3JLbfTd+91AU1g6fE7ktURt7BkT7T2Jnsf0rr1D9Lo=;
        b=v3cv+qEHlDI4kL6s2Bh+IgV29DxgjbuIiF6DF8MHC/SntiK5/tqKLw59QkvCgKdcrc
         N4MVHZdk442z55LxH/8uKN4q2VIWexlfEV8dKacjP4CZPX7+Hm+8JPcijx8//qY+yUSe
         BTgFTCeE0sRCP3CXUdH1jcnGa4hfpQtkbQtuNf/VcybEtc2abBltxdSeUq66+1wyBF4I
         yytITWZK+6QSXQL7V/cSmY2ba3fCMaiVC2CoDZdhG/B5E8syEiNQEjAzZ+CAWEHJgPnv
         c50gozbzUzHD6HkBnvYuttuDrqMJRtK4BDeFVidLLEaUBQ/8VDgGGai/mnFDtiPKiQAH
         SrrQ==
X-Gm-Message-State: AOJu0YzYRqvrI2jLDDM6uc4Q9zJQ8Ws3ptgGh+ffvlbRU4ea+EMU6G/q
        0gCTi1z3DdVEhY/HL3MpKYiAvptv3Re3y+6plPfHjjQVlDRvcEucyEfSracKrPWzL0OwCQwHlBT
        OknHWI94B/ZgQuiCdllxNJXMPtvA4ZC4qzuJYONHHQzZaCC2OOE7ycQ==
X-Received: by 2002:a17:90a:800c:b0:277:522d:11e5 with SMTP id b12-20020a17090a800c00b00277522d11e5mr687545pjn.2.1695791209458;
        Tue, 26 Sep 2023 22:06:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFzGo8kJIOr6VqfMQV5hY5eT0bT4PM+xEn/1HIL7gd75eRaLHiuR68xJOf0vO9fpKRO1AK5yjIorkmG7xeMsEQ=
X-Received: by 2002:a17:90a:800c:b0:277:522d:11e5 with SMTP id
 b12-20020a17090a800c00b00277522d11e5mr687534pjn.2.1695791209069; Tue, 26 Sep
 2023 22:06:49 -0700 (PDT)
MIME-Version: 1.0
References: <20230927025219.49915-1-xni@redhat.com> <20230927025219.49915-4-xni@redhat.com>
 <b093b5be-2374-46f5-80b6-5247ef3de961@molgen.mpg.de>
In-Reply-To: <b093b5be-2374-46f5-80b6-5247ef3de961@molgen.mpg.de>
From:   Xiao Ni <xni@redhat.com>
Date:   Wed, 27 Sep 2023 13:06:38 +0800
Message-ID: <CALTww28KRHQ2pH6pc3ai5MSOAA069G-F0F2OvX5gd+MDsnZJAg@mail.gmail.com>
Subject: Re: [PATCH 3/4] mdadm: Avoid array bounds check of gcc
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Sep 27, 2023 at 12:36=E2=80=AFPM Paul Menzel <pmenzel@molgen.mpg.de=
> wrote:
>
> Dear Xiao,
>
>
> Thank you for your patch.
>
> Am 27.09.23 um 04:52 schrieb Xiao Ni:
> > With gcc version 13.2.1 20230918 (Red Hat 13.2.1-3) (GCC), it reports e=
rror:
> > super-ddf.c:1988:58: error: array subscript -1 is below array bounds of
> > =E2=80=98struct phys_disk_entry[0]=E2=80=99 [-Werror=3Darray-bounds=3D]
>
> I wouldn=E2=80=99t wrap pasted lines.

Hi Paul

I thought it exceeds the max character limit which is used for kernel
patch rule. I'll change it back.

>
> > The subscrit is defined as int type. And it can be smaller than 0.
>
> subscript?

yes
>
> > To avoid this error, add -Wno-array-bounds flag in Makefile.
>
> Wouldn=E2=80=99t it be better to fix the error and not work around it by
> disabling the warning?

I want to do this first. But the logic bellow indeed checks if the
subscript is lower than 0.
It's the reason I add -Wno-array-bounds.

                info->data_offset =3D be64_to_cpu(ddf->phys->
                                                  entries[info->disk.raid_d=
isk].
                                                  config_size);
                info->component_size =3D ddf->dlist->size - info->data_offs=
et;
                if (info->disk.raid_disk >=3D 0)
                        pde =3D ddf->phys->entries + info->disk.raid_disk;

Do you have any suggestions for this?

Best Regards
Xiao

>
>
> Kind regards,
>
> Paul
>
>
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> >   Makefile | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/Makefile b/Makefile
> > index 5eac1a4e9690..47da883a9fb9 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -50,7 +50,7 @@ ifeq ($(origin CC),default)
> >   CC :=3D $(CROSS_COMPILE)gcc
> >   endif
> >   CXFLAGS ?=3D -ggdb
> > -CWFLAGS =3D -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-para=
meter
> > +CWFLAGS =3D -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-para=
meter -Wno-array-bounds
> >   ifdef WARN_UNUSED
> >   CWFLAGS +=3D -Wp,-D_FORTIFY_SOURCE=3D2 -O3
> >   endif
>

