Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08FF0EE49AF
	for <linux-raid@archiver.kernel.org>; Wed, 23 Aug 2023 02:29:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232182AbjHWC3v (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 22 Aug 2023 22:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232167AbjHWC3v (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 22 Aug 2023 22:29:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2539CF9
        for <linux-raid@vger.kernel.org>; Tue, 22 Aug 2023 19:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692757741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PHoyPB6fdwlZo0rv+RRNeP2XexnPFlJevWCB+hETQnY=;
        b=W3C/BrmbXXozM9Eriz26YsD2kKbdMdNh7xPgMXbf7Vso542t62vv6XfM/w8H39cFN/adeH
        E0MGDa2qQEQ8KHoLpd2UYFOZOBBoYVjrQczU/5OobkIm3Dy4+6cIDctAbo/K6qj2vU4K1c
        eZG6FeiblQ9WnKK8r3mBpRRVoXZPeGY=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-159-YEnuTPo2M7yD-Hgs9NqxqA-1; Tue, 22 Aug 2023 22:29:00 -0400
X-MC-Unique: YEnuTPo2M7yD-Hgs9NqxqA-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-68a3d6ce18cso4117136b3a.0
        for <linux-raid@vger.kernel.org>; Tue, 22 Aug 2023 19:29:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692757739; x=1693362539;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PHoyPB6fdwlZo0rv+RRNeP2XexnPFlJevWCB+hETQnY=;
        b=YFbsxGa2HxxV8jEtSZaXduMX3ohw5qmC2XYI3lKugRfmvhnksSnQVChtc3GxXgUOO2
         yjBgwuXDI26PerSgP0Qfh1/GJ9cXiQnjUW+1KK3r5OVTJTEFifjHKskYmK9lhkCNHYQa
         AnjAqXHjD/VZ2Bp/OyaoOZb6DpA7Jc51ZkRpsmIUsrNbN6butTUcDQC+hokRgfh/krko
         yXgflnteQAjXENMKzd1VhWiBPA4zxQoqt/L9UW/WIlfMdtUsBAlKhn93VwiieZpb4v5w
         3qq/S7Qjj7FxHOEvs2yFjPjWGrwQWRAv/iiIcHZsWctFWCT7GTQaZYjlIxYoHZXbceyO
         jCOQ==
X-Gm-Message-State: AOJu0Yzj8qdDxBHa/N3B51Cx+Two9gWAiBZBucLiI2TGXlJUQAnifQb5
        gsQcbhnn90iv5jw2fWfKakTEBN6ek+8KPsYjAH5kMK8nkd/4mTV9nzMSRFeaJdnXB4d2RKCVpaU
        aRJIo3Qx/WAxyA0BJQ1aRCTcDs9Wl+5YKb0Dl+w==
X-Received: by 2002:a05:6a00:4692:b0:68a:2260:c84d with SMTP id de18-20020a056a00469200b0068a2260c84dmr13308985pfb.10.1692757739316;
        Tue, 22 Aug 2023 19:28:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGudGZREZyEnBHgQfHNztSMsv0KUVLA8pexCc2cTkPyY7n3tBTy4gUCac65Dd08oLW1olPBKRFnR8vUNwTWR48=
X-Received: by 2002:a05:6a00:4692:b0:68a:2260:c84d with SMTP id
 de18-20020a056a00469200b0068a2260c84dmr13308977pfb.10.1692757739026; Tue, 22
 Aug 2023 19:28:59 -0700 (PDT)
MIME-Version: 1.0
References: <20230820090949.2874537-1-yukuai1@huaweicloud.com>
 <20230820090949.2874537-6-yukuai1@huaweicloud.com> <CALTww28fa_LUVfzswTmpascZEYr-PdyjgoU88A+H9Q7CP04VXA@mail.gmail.com>
In-Reply-To: <CALTww28fa_LUVfzswTmpascZEYr-PdyjgoU88A+H9Q7CP04VXA@mail.gmail.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Wed, 23 Aug 2023 10:28:48 +0800
Message-ID: <CALTww2-gdFHh4j+_bwuT2fX_OHMFfra3p34PM4rNZv0OCqPKcw@mail.gmail.com>
Subject: Re: [PATCH -next v3 5/7] md: factor out a helper rdev_is_spare() from remove_and_add_spares()
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     song@kernel.org, mariusz.tkaczyk@linux.intel.com,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        yukuai3@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Aug 23, 2023 at 10:20=E2=80=AFAM Xiao Ni <xni@redhat.com> wrote:
>
> On Sun, Aug 20, 2023 at 5:13=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com>=
 wrote:
> >
> > From: Yu Kuai <yukuai3@huawei.com>
> >
> > There are no functional changes, just to make the code simpler and
> > prepare to delay remove_and_add_spares() to md_start_sync().
> >
> > Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> > ---
> >  drivers/md/md.c | 15 ++++++++++-----
> >  1 file changed, 10 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index ceace5ffadd6..11d27c934fdd 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -9169,6 +9169,14 @@ static bool rdev_removeable(struct md_rdev *rdev=
)
> >         return true;
> >  }
> >
> > +static bool rdev_is_spare(struct md_rdev *rdev)
> > +{
> > +       return !test_bit(Candidate, &rdev->flags) && rdev->raid_disk >=
=3D 0 &&
> > +              !test_bit(In_sync, &rdev->flags) &&
> > +              !test_bit(Journal, &rdev->flags) &&
> > +              !test_bit(Faulty, &rdev->flags);
> > +}
> > +
> >  static int remove_and_add_spares(struct mddev *mddev,
> >                                  struct md_rdev *this)
> >  {
> > @@ -9217,13 +9225,10 @@ static int remove_and_add_spares(struct mddev *=
mddev,
> >         rdev_for_each(rdev, mddev) {
> >                 if (this && this !=3D rdev)
> >                         continue;
> > +               if (rdev_is_spare(rdev))
> > +                       spares++;
> >                 if (test_bit(Candidate, &rdev->flags))
> >                         continue;
>
> Hi Kuai
>
> Why not put rdev_is_spare after testing Candidate?
>
> Best Regards
> Xiao

I know the answer now, Because the next patch wants to put codes into
the function rdev_addable
>
> > -               if (rdev->raid_disk >=3D 0 &&
> > -                   !test_bit(In_sync, &rdev->flags) &&
> > -                   !test_bit(Journal, &rdev->flags) &&
> > -                   !test_bit(Faulty, &rdev->flags))
> > -                       spares++;
> >                 if (rdev->raid_disk >=3D 0)
> >                         continue;
> >                 if (test_bit(Faulty, &rdev->flags))
> > --
> > 2.39.2
> >

Reviewed-by: Xiao Ni <xni@redhat.com>

