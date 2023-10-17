Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D702DCDB483
	for <linux-raid@archiver.kernel.org>; Tue, 17 Oct 2023 12:05:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234972AbjJQMFb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 17 Oct 2023 08:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234913AbjJQMFN (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 17 Oct 2023 08:05:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BFCDA4
        for <linux-raid@vger.kernel.org>; Tue, 17 Oct 2023 05:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697544265;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EOgIr7QhQxdRm5fv7jVpAZ1iBhHoI7Wq6R7/vii79fc=;
        b=a3O4RKCW5iIKcgw9MhJDvVVJEsfjMLga8Fp6nsU9qPNoN+hL65b+WEyF2KewC3ZwPWHFgW
        3tJtuDLtMg44Rnn8Du5yQ/0f/LVUqb/ULDVEbm/TsMK8ZM5rrLpdGX18DtqgB+uWepmB4R
        lQWVpSqBz3cmgWnvPSjdlLAmbHLhyiE=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-404-2v0rPZChOxW1bf6vE7LrGg-1; Tue, 17 Oct 2023 08:04:23 -0400
X-MC-Unique: 2v0rPZChOxW1bf6vE7LrGg-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-27d56564684so3124931a91.2
        for <linux-raid@vger.kernel.org>; Tue, 17 Oct 2023 05:04:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697544263; x=1698149063;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EOgIr7QhQxdRm5fv7jVpAZ1iBhHoI7Wq6R7/vii79fc=;
        b=PcM3StAC9GNOGJ3YCEDXXxJ9LpN0PrWR1w0fIHvGaLX9p+gIIrp3bkv377cSfCzcmz
         HWY4RJff+InPjJhfJOg9y02m9DmvvngDGWwGETNCmwDpdXt+hwKeGinoj5QJ20SE+CZZ
         Bkl+aKjPkfHhnK/fIY2QTvjJJ7UWTTmpSF25LnAEX41nQ1QRDCkFLdHlEujJMcAJKsTR
         CdYL51CfuZZ4Z/4IlJ8Qeah92u9G+bVnUmhH1+oe5kbuBmGbeu7/nIu04C942622qmA3
         2c7f209lehLr8CMr1bdwynLltaKRrMDII1QaihdatTpXH7aFZ/rNrVfFJf5Ft6+a8vjp
         Rv7w==
X-Gm-Message-State: AOJu0YxiuSMKF160DD6u+6iG1RsQp2VsEjIj9KHbDZSSjAi4i6vWetF3
        CNkNy4CcW1z4mq6KjZVC1isdgMM5rxBqFHUUeQjT811DZ5XoVFXPwBTl8kHqnyh8S+N8Yaqk6oC
        uY5eVTwWwo58lqlYF1cTHYHTqnHA7lEIc8vEVXA==
X-Received: by 2002:a17:90a:cf8e:b0:279:2dac:80b3 with SMTP id i14-20020a17090acf8e00b002792dac80b3mr1886333pju.44.1697544262740;
        Tue, 17 Oct 2023 05:04:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHOgwVsVVXoPJJXMqQA0oPXCGq4SJkrCF2mctbpOzRTcGdDjlEtqXCnXXh7wec0GbVbJ+ezyJlManTuPT/drk8=
X-Received: by 2002:a17:90a:cf8e:b0:279:2dac:80b3 with SMTP id
 i14-20020a17090acf8e00b002792dac80b3mr1886308pju.44.1697544262405; Tue, 17
 Oct 2023 05:04:22 -0700 (PDT)
MIME-Version: 1.0
References: <20231017035142.41168-1-xni@redhat.com> <20231017093601.000019e5@linux.intel.com>
In-Reply-To: <20231017093601.000019e5@linux.intel.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Tue, 17 Oct 2023 20:04:10 +0800
Message-ID: <CALTww2_PEUh1nocV0isTTTtU6KSFy+23D5ZjuOxWGxDzYPNSPQ@mail.gmail.com>
Subject: Re: [PATCH V2 1/1] mdadm/super1: Add MD_FEATURE_RAID0_LAYOUT for all
 raid0 after kernel v5.4
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     jes@trained-monkey.org, colyli@suse.de, neilb@suse.de,
        linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Oct 17, 2023 at 3:36=E2=80=AFPM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> On Tue, 17 Oct 2023 11:51:42 +0800
> Xiao Ni <xni@redhat.com> wrote:
>
> > After and include kernel v5.4, it adds one feature bit
> > MD_FEATURE_RAID0_LAYOUT. It must need to specify a layout for raid0 wit=
h more
> > than one zone. But for raid0 with one zone, in fact it also has a defal=
ut
> > layout.
> >
> > Now for raid0 with one zone, *unknown* layout can be seen when running =
mdadm
> > -D command. It's the reason that mdadm doesn't set MD_FEATURE_RAID0_LAY=
OUT for
> > raid0 with one zone. Then in kernel space, super_1_validate sets mddev-=
>layout
> > to -1 because of no MD_FEATURE_RAID0_LAYOUT. In fact, in raid0 io path,=
 it
> > uses the default layout. So in fact after/include kernel v5.4, all raid=
0
> > device have layout.
> >
> > Fixes: 329dfc28debb ('Create: add support for RAID0 layouts.')
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> >  super1.c | 21 ++-------------------
> >  1 file changed, 2 insertions(+), 19 deletions(-)
> >
> > diff --git a/super1.c b/super1.c
> > index 856b02082662..653a2ea6c0e4 100644
> > --- a/super1.c
> > +++ b/super1.c
> > @@ -1978,26 +1978,10 @@ static int write_init_super1(struct supertype *=
st)
> >       unsigned long long sb_offset;
> >       unsigned long long data_offset;
> >       long bm_offset;
> > -     int raid0_need_layout =3D 0;
> >
> > -     for (di =3D st->info; di; di =3D di->next) {
> > +     for (di =3D st->info; di; di =3D di->next)
> >               if (di->disk.state & (1 << MD_DISK_JOURNAL))
> >                       sb->feature_map |=3D __cpu_to_le32(MD_FEATURE_JOU=
RNAL);
> > -             if (sb->level =3D=3D 0 && sb->layout !=3D 0) {
> > -                     struct devinfo *di2 =3D st->info;
> > -                     unsigned long long s1, s2;
> > -                     s1 =3D di->dev_size;
> > -                     if (di->data_offset !=3D INVALID_SECTORS)
> > -                             s1 -=3D di->data_offset;
> > -                     s1 /=3D __le32_to_cpu(sb->chunksize);
> > -                     s2 =3D di2->dev_size;
> > -                     if (di2->data_offset !=3D INVALID_SECTORS)
> > -                             s2 -=3D di2->data_offset;
> > -                     s2 /=3D __le32_to_cpu(sb->chunksize);
> > -                     if (s1 !=3D s2)
> > -                             raid0_need_layout =3D 1;
> > -             }
> > -     }
>
> We need to keep this code. Neil made MD_FEATURE_RAID0_LAYOUT always added=
 for
> device with various sizes. You are extending it not replacing.
>
> I understand that now it sets MD_FEATURE_RAID0_LAYOUT if it detects
> member devices with various sizes. Kernel version is irrelevant so I susp=
ect
> that if someone creates zoned raid0 array, it fails to start array if
> MD_FEATURE_RAID0_LAYOUT is not supported by the MD driver. User must
> acknowledge that by layout=3Ddangerous (it means no layout I think).
>
> We don't want remove this. It prevents users from data corruption.
>
> Your change is to start always setting MD_FEATURE_RAID0_LAYOUT if it seem=
s to be
> safe i.e. kernel is >=3D5.4 but it does not invalidate the raid0_need_lay=
out
> routine from the reason raised above.
>
> Please correct me if I missed something or if I'm wrong. I did not tested=
 it.
> I trust that you made necessary testing and can provide real-life input h=
ere.
>
> Thanks,
> Mariusz
>

Hi Mariusz

Thanks. I'll add the check <5.4 situation

Best Regards
Xiao

