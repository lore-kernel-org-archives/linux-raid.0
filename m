Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C351C860C
	for <linux-raid@vger.kernel.org>; Thu,  8 May 2025 02:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746672837; cv=none; b=LTw/OPWvYwntQ5WYgo7jU0dZoELA9x++rRbyEXK2eZ7oOpdIPLpQ3+4VCAEkQU/FGvxyrIGiPCvG/Y4eCXRR+OzKOEpKtfMkHergJkcB6d+iOHylmFbCPtFzsZr7CBVcX+AXx09tk0Os5TeciQ+MwGlDnTV3SQLxbEtX7zPz7Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746672837; c=relaxed/simple;
	bh=AvWxyd/ltdDjgVJ5RrEmlxmwjrHVV55GjoFGdPDuxPE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UzpNbdlGwxRSgTTSRJhSamL9lxhJCqi9nnb9F56dVtrRdMVzFlsuIuMEl1xOGzxt3IlbQ2kp9ygaVuhKi3SEHf6hV0r0RHdXp7QVlfIaWl++vbXHtpNlgY7Y/YZCUNwK7HifTvXfpu9m6tZWOCxj50kxcI0NmnxEZv+oac7O41I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ckHZw/9P; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ckHZw/9P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746672834;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=stvWtN/m1ttOQ9kqx5/HsO01uLkcD9/Iz5U7HrRg9kE=;
	b=ckHZw/9P5Gcl1y++1Dv2aIrMumkzUx6BcQjRQZIvF/el4r8nmdrfbkxtB764Z3q8g85qmU
	J7WpiyzpaTPwlQxQhrfrAjEFoBHMbkwu8wN+qdwtLGtMW04gtjweeW0vf6oqV6lNpKOWqc
	3S3x/ND5UsaDkaRjYwD07hJvShBY3GY=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-499-Wp1V5ZFSOf-N9QsBGcIEmQ-1; Wed, 07 May 2025 22:53:53 -0400
X-MC-Unique: Wp1V5ZFSOf-N9QsBGcIEmQ-1
X-Mimecast-MFC-AGG-ID: Wp1V5ZFSOf-N9QsBGcIEmQ_1746672832
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-30d6a0309f6so2492641fa.2
        for <linux-raid@vger.kernel.org>; Wed, 07 May 2025 19:53:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746672831; x=1747277631;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=stvWtN/m1ttOQ9kqx5/HsO01uLkcD9/Iz5U7HrRg9kE=;
        b=grxS3BUkVh4Cpnv1NS6npm1K382aCM7vq5jYv+jiZA5X5CGMjyEKB/U2+pOnriXSAP
         mt3UYugvFGAnPjerJXfoTaSdQHNn4eSpHyE+WX0tw30tFObO/JetcfNL/Xv0LndvVvsk
         n0GgiGk54/mUv2hh8Z7vNL/7XPE9dZ2P2KfxuZpN5xhPb2oQ7UzZzVvFmbFwG4yt6mvV
         E+7pC+aYs8AywhJOQXtBSxxmhq2AuQlEUUg9hHfCJ1xHV3hPwhf1P67kTr2VIdbtBMC0
         6oynzxEelJa+LY9eAwnKO/F/fmrN36RIcAUagqSMFq9ZsUoiRHXRYf0JET8YPL5uVjY/
         Orew==
X-Gm-Message-State: AOJu0YyxHq4Reo4DYrPz5B5Y7ETkFVPIWDbSoICSKnIgfCOgTYQdqDgv
	dLz6YbEf9aDnt9TzFkrANgZrQB0tl2RHDirIJNfOzhzAaFupN40C3n2qT/7VkQORNTgcn+3/loR
	ang1STg342y5AQotGmDgMbh7S2SCfcISMT0H3qSg0mAu9TIeTCiUXK79iXazBCy+RL77RPpexR8
	wWWEjA9Ek3modCSMpB5PAHSYFLleqzo31aoA==
X-Gm-Gg: ASbGncvuFHk2IqxY5kToKlw/9mzXYDIDjh7PlD5Yr6y3KDIGXNhVZwRfrCHIN5xlQwm
	NOR4+7Hd1h1I9ResEUPsRlmt2sOZAAH3hqN+ON1MD9CkttTgWjk9Ut3Tqkw8NMiGJk6zbkQ==
X-Received: by 2002:a05:651c:516:b0:308:f580:729e with SMTP id 38308e7fff4ca-326ad3232femr20201891fa.27.1746672831465;
        Wed, 07 May 2025 19:53:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEI78nO10dDEyTJu1V/64zePXUEMTb/p/g8lS4rGspf7MIR7fhpqcSqEhp9yj1SI6Nhd3vZ/Gbb83nQZSwDvNA=
X-Received: by 2002:a05:651c:516:b0:308:f580:729e with SMTP id
 38308e7fff4ca-326ad3232femr20201821fa.27.1746672830962; Wed, 07 May 2025
 19:53:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250507122002.20826-1-xni@redhat.com> <20250507122002.20826-3-xni@redhat.com>
 <01fd9e77-6a01-46f6-865e-d8be47aae87b@molgen.mpg.de>
In-Reply-To: <01fd9e77-6a01-46f6-865e-d8be47aae87b@molgen.mpg.de>
From: Xiao Ni <xni@redhat.com>
Date: Thu, 8 May 2025 10:53:39 +0800
X-Gm-Features: ATxdqUGdYVXsGyYtPEZoTMbnJX6tkjVeNCYyLeJ5xRiuW7TpNE7VlqwGHT7p66M
Message-ID: <CALTww29sNLjzWaRFfzPbSZXa1xqRwggHoeLVxQ=GN-HFZUshjA@mail.gmail.com>
Subject: Re: [PATCH 2/3] mdadm: fix building errors
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: linux-raid@vger.kernel.org, mtkaczyk@kernel.org, ncroxon@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 7, 2025 at 9:53=E2=80=AFPM Paul Menzel <pmenzel@molgen.mpg.de> =
wrote:
>
> Dear Xiao,
>
>
> Thank you for your patch. Could you make the summary/title more
> specific? Something like Cast =E2=80=A6?

How about 'Cast be64_to_cpu to unsigned long long'? Or any good suggestion?
>
>
> Am 07.05.25 um 14:20 schrieb Xiao Ni:
> > Some building errors are found in ppc64le platform:
> > format '%llu' expects argument of type 'long long unsigned int', but
> > argument 3 has type 'long unsigned int' [-Werror=3Dformat=3D]
>
> I=E2=80=99d put pasted things in one line.

There is a 75 character number limit for each line in commit.
>
> Also, please state how you fixed this.

Ok, but it's easy to see from the patch. It just do a cast with
(unsigned long long)
>
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> >   super-ddf.c   | 9 +++++----
> >   super-intel.c | 3 ++-
> >   2 files changed, 7 insertions(+), 5 deletions(-)
> >
> > diff --git a/super-ddf.c b/super-ddf.c
> > index 6e7db924d2b1..dda8b7fedd64 100644
> > --- a/super-ddf.c
> > +++ b/super-ddf.c
> > @@ -1606,9 +1606,9 @@ static void examine_vd(int n, struct ddf_super *s=
b, char *guid)
> >                              map_num(ddf_sec_level, vc->srl) ?: "-unkno=
wn-");
> >               }
> >               printf("  Device Size[%d] : %llu\n", n,
> > -                    be64_to_cpu(vc->blocks)/2);
> > +                    (unsigned long long)(be64_to_cpu(vc->blocks)/2));
> >               printf("   Array Size[%d] : %llu\n", n,
> > -                    be64_to_cpu(vc->array_blocks)/2);
> > +                    (unsigned long long)(be64_to_cpu(vc->array_blocks)=
/2));
> >       }
> >   }
> >
> > @@ -1665,7 +1665,7 @@ static void examine_pds(struct ddf_super *sb)
> >               printf("       %3d    %08x  ", i,
> >                      be32_to_cpu(pd->refnum));
> >               printf("%8lluK ",
> > -                    be64_to_cpu(pd->config_size)>>1);
> > +                             (unsigned long long)be64_to_cpu(pd->confi=
g_size)>>1);
>
> Keep the alignement from before?

We usually use tab rather than spaces. So it's better to use tab here.
But I don't want to fix all the alignments problem.

>
> >               for (dl =3D sb->dlist; dl ; dl =3D dl->next) {
> >                       if (be32_eq(dl->disk.refnum, pd->refnum)) {
> >                               char *dv =3D map_dev(dl->major, dl->minor=
, 0);
> > @@ -2901,7 +2901,8 @@ static unsigned int find_unused_pde(const struct =
ddf_super *ddf)
> >   static void _set_config_size(struct phys_disk_entry *pde, const struc=
t dl *dl)
> >   {
> >       __u64 cfs, t;
> > -     cfs =3D min(dl->size - 32*1024*2ULL, be64_to_cpu(dl->primary_lba)=
);
> > +     cfs =3D min((unsigned long long)dl->size - 32*1024*2ULL,
> > +                     (unsigned long long)(be64_to_cpu(dl->primary_lba)=
));
> >       t =3D be64_to_cpu(dl->secondary_lba);
> >       if (t !=3D ~(__u64)0)
> >               cfs =3D min(cfs, t);
> > diff --git a/super-intel.c b/super-intel.c
> > index b7b030a20432..4fbbc98d915c 100644
> > --- a/super-intel.c
> > +++ b/super-intel.c
> > @@ -2325,7 +2325,8 @@ static void export_examine_super_imsm(struct supe=
rtype *st)
> >       printf("MD_LEVEL=3Dcontainer\n");
> >       printf("MD_UUID=3D%s\n", nbuf+5);
> >       printf("MD_DEVICES=3D%u\n", mpb->num_disks);
> > -     printf("MD_CREATION_TIME=3D%llu\n", __le64_to_cpu(mpb->creation_t=
ime));
> > +     printf("MD_CREATION_TIME=3D%llu\n",
> > +                     (unsigned long long)__le64_to_cpu(mpb->creation_t=
ime));
> >   }
> >
> >   static void detail_super_imsm(struct supertype *st, char *homehost,
>
> Can=E2=80=99t this be fixed in the header?

I don't follow you here.

Best Regards
Xiao
>
>
> Kind regards,
>
> Paul
>

