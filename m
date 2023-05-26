Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03B67C7EE29
	for <linux-raid@archiver.kernel.org>; Fri, 26 May 2023 02:41:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233648AbjEZCld (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 25 May 2023 22:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbjEZClb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 25 May 2023 22:41:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B48B2
        for <linux-raid@vger.kernel.org>; Thu, 25 May 2023 19:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685068846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CVPWmOBD3fbCHLTG+v/xUn2E+9Kzmv1DET7EjW7MBDk=;
        b=LaEAVggEbl0VoYLY+X/PzfTZ3piquHY1wO6OuKDGrYh45mWt84v81fC+hEhdJIZ3LSNIi0
        MEbRgP+x2pur94W/PsEi2bJhzKdLPmfharEc6yxRNewQEhHDuN+tHw79hK3DGQoVQBPw6G
        XAN6hZOnrxHgJlBa87oEYq9DIAsWujQ=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-508-LkneYnIFOoGjR_FO877E8A-1; Thu, 25 May 2023 22:40:44 -0400
X-MC-Unique: LkneYnIFOoGjR_FO877E8A-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1ae3f6df1afso3174775ad.1
        for <linux-raid@vger.kernel.org>; Thu, 25 May 2023 19:40:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685068843; x=1687660843;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CVPWmOBD3fbCHLTG+v/xUn2E+9Kzmv1DET7EjW7MBDk=;
        b=Rhs5CU8axbcZ1tKYUdWV5DT2AEzU1ga6NcTStk45cGGq/SJiRwZtTbj7OHWRpkIAxT
         x/W11FT6lAkbKgXmhlPWWwA5VMjqYxW3HeiVGwej2wDCGYDxjkUEG9XRO+4w46LWjtME
         KZkzUcLd9YlaBjCu8Hvzu5G0OWYMhPcGL1cgYSwkrBfigq70oTMqmIrOQKgKmZavG6HN
         3FhqiMw2IvYjUUbVVgTswxfSoR6YR9XyMnibf28dWinCDalLtnOzdQt/7zJg7xR9HpND
         RQvOo23ULflAiAkUBXbJAADFMvbKdJb7Tge5zo2Vq1WLbPvq5nfh0u+//6DyH801pSc7
         BDPQ==
X-Gm-Message-State: AC+VfDzotrUf2REHoW9lxfOmRFVEStYJPRd8XqtDdtXORsdturAmKUC0
        cwobzWMZ0GvqLrTa19o2XZhO9qSxYWLotcJkIJaJ2DnwsOIURFHqMi3ebdHVUD70mCNoF6WsmiL
        eEfDOB61jgXmYDwcRPt8H/8MQHyzD62xdbFMMOA==
X-Received: by 2002:a17:902:a50d:b0:1a2:6257:36b9 with SMTP id s13-20020a170902a50d00b001a2625736b9mr713991plq.31.1685068843764;
        Thu, 25 May 2023 19:40:43 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ48oxfdcIhWM/PJg9txQELdSj5pWOyYh/+YQQdj5D6JQgPamFGLosW/6N1FDce8sbFmDztfZ4b/fx8uZy+w63s=
X-Received: by 2002:a17:902:a50d:b0:1a2:6257:36b9 with SMTP id
 s13-20020a170902a50d00b001a2625736b9mr713977plq.31.1685068843539; Thu, 25 May
 2023 19:40:43 -0700 (PDT)
MIME-Version: 1.0
References: <CALTww28aV5CGXQAu46Rkc=fG1jK=ARzCT8VGoVyje8kQdqEXMg@mail.gmail.com>
 <CALTww2_4pS=wF6tR0rVejg1ocyGhkTJic0aA=WCcTXDh+cZXQQ@mail.gmail.com> <1dd27191-a4c7-101a-1d1b-5f71503756a6@huaweicloud.com>
In-Reply-To: <1dd27191-a4c7-101a-1d1b-5f71503756a6@huaweicloud.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Fri, 26 May 2023 10:40:32 +0800
Message-ID: <CALTww28_feZ7zW6fLPeyhsuvUcXukGtjTZKQ+_cQ9TQpc06TgA@mail.gmail.com>
Subject: Re: Fwd: The read data is wrong from raid5 when recovery happens
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Song Liu <song@kernel.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Nigel Croxon <ncroxon@redhat.com>,
        "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, May 26, 2023 at 10:18=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> =
wrote:
>
> Hi,
>
> =E5=9C=A8 2023/05/26 10:08, Xiao Ni =E5=86=99=E9=81=93:
> > I received an email that this email can't delivered to someone. Resent
> > it to linux-raid again.
> >
> > ---------- Forwarded message ---------
> > From: Xiao Ni <xni@redhat.com>
> > Date: Fri, May 26, 2023 at 9:49=E2=80=AFAM
> > Subject: The read data is wrong from raid5 when recovery happens
> > To: Song Liu <song@kernel.org>, Guoqing Jiang <guoqing.jiang@linux.dev>
> > Cc: linux-raid <linux-raid@vger.kernel.org>, Heinz Mauelshagen
> > <heinzm@redhat.com>, Nigel Croxon <ncroxon@redhat.com>
> >
> >
> > Hi all
> >
> > We found a problem recently. The read data is wrong when recovery
> > happens. Now we've found it's introduced by patch 10764815f (md: add
> > io accounting for raid0 and raid5). I can reproduce this 100%. This
> > problem exists in upstream. The test steps are like this:
> >
> > 1. mdadm -CR $devname -l5 -n4 /dev/sd[b-e] --force --assume-clean
> > 2. mkfs.ext4 -F $devname
> > 3. mount $devname $mount_point
> > 4. mdadm --incremental --fail sdd
> > 5. dd if=3D/dev/zero of=3D/tmp/pythontest/file1 bs=3D1M count=3D100000 =
status=3Dprogress
> > 6. mdadm /dev/md126 --add /dev/sdd
> Can you try to zero superblock before add sdd? just to bypass readd.

Hi Kuai

I tried with this. It can still be reproduced.

>
> Thanks,
> Kuai
> > 7. create 31 processes that writes and reads. It compares the content
> > with md5sum. The test will go on until the recovery stops
> > 8. wait for about 10 minutes, we can see some processes report
> > checksum is wrong. But if it re-read the data again, the checksum will
> > be good.
> >
> > I tried to narrow this problem like this:
> >
> > -       md_account_bio(mddev, &bi);
> > +       if (rw =3D=3D WRITE)
> > +               md_account_bio(mddev, &bi);
> > If it only do account for write requests, the problem can disappear.
> >
> > -       if (rw =3D=3D READ && mddev->degraded =3D=3D 0 &&
> > -           mddev->reshape_position =3D=3D MaxSector) {
> > -               bi =3D chunk_aligned_read(mddev, bi);
> > -               if (!bi)
> > -                       return true;
> > -       }
> > +       //if (rw =3D=3D READ && mddev->degraded =3D=3D 0 &&
> > +       //    mddev->reshape_position =3D=3D MaxSector) {
> > +       //      bi =3D chunk_aligned_read(mddev, bi);
> > +       //      if (!bi)
> > +       //              return true;
> > +       //}
> >
> >          if (unlikely(bio_op(bi) =3D=3D REQ_OP_DISCARD)) {
> >                  make_discard_request(mddev, bi);
> > @@ -6180,7 +6180,8 @@ static bool raid5_make_request(struct mddev
> > *mddev, struct bio * bi)
> >                          md_write_end(mddev);
> >                  return true;
> >          }
> > -       md_account_bio(mddev, &bi);
> > +       if (rw =3D=3D READ)
> > +               md_account_bio(mddev, &bi);
> >
> > I comment the chunk_aligned_read out and only account for read
> > requests, this problem can be reproduced.
> >
>


--=20
Best Regards
Xiao Ni

