Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC79FC7EE29
	for <linux-raid@archiver.kernel.org>; Fri, 26 May 2023 03:03:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233139AbjEZDDL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 25 May 2023 23:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231691AbjEZDDJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 25 May 2023 23:03:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EEB4BB
        for <linux-raid@vger.kernel.org>; Thu, 25 May 2023 20:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685070141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jS/9BHK510UeV0fbNPzUg+vuPuddVumzOvk67FL7Dw8=;
        b=T6IGCIJOUYUnSd5LUEIVG++Nrkr+w+g0bKorIsZXpQuCHHSRgKXUvpOcjRVCmYiErf0QCh
        jUUfkkiFzQ08AJCI3tdbRmI5KY1tEqMzXn3Nl/LEL8WTMughRZuTET7AcJdbIrKIbyYBBE
        J31Znu0QJHcZsrx7fu7QJdbZxVgx6Sg=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-177-jAp99ZZDMrurwunRHRf_BA-1; Thu, 25 May 2023 23:02:20 -0400
X-MC-Unique: jAp99ZZDMrurwunRHRf_BA-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1ae7eea1d5dso2784875ad.1
        for <linux-raid@vger.kernel.org>; Thu, 25 May 2023 20:02:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685070139; x=1687662139;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jS/9BHK510UeV0fbNPzUg+vuPuddVumzOvk67FL7Dw8=;
        b=LKVJjqqV7gnRUOj/9p6IzRvphgY9iurRn6jm99DjLT4/89C9I9PdrogkpdmroLOvb2
         hOVpjrcAb2IEVwZXF76SKM53hajEvGu/5ln0FOxzLi2tXrB73tb5/q6+LxJxD/T+9lu7
         OxokBVTd2qth08JgyFGbUsGajUDqyIcLOdxpUX8DRJYg8xz6C1noF0tKhdXP35EqsJKb
         3ndZWK9JDVxODIqJwjQ8D7bnrY8L0bED6dqeZBT37m4rp7wbplxcZyA1qyIybIBG3T+R
         r1p9KIgfIfs5nCboTxD54eL2xI6NHpRG2zAUik4bospPUiaWaoJ7hqlwqBf9+Whc3JBS
         B36Q==
X-Gm-Message-State: AC+VfDxl14h6mIY9BN0TZ1h5cwPKPNOYRPps36/uT3Bj7GtVfaZBOFMr
        PiCsB+jwWhN8v5qiIRKncxneRS6abVBjDE0O0dTBHt+Muvp5ZaAs4F1POuQMwigllCFFhtfYFqg
        jfSyRhEiS1DAD066T6ZJ1LQjHxnDJyddEpdnKuQ==
X-Received: by 2002:a17:902:e5c3:b0:1af:cbdb:9772 with SMTP id u3-20020a170902e5c300b001afcbdb9772mr472308plf.18.1685070139509;
        Thu, 25 May 2023 20:02:19 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4HDHp5c1Zr2BUKPtJ/nhExJMjfxC2UsWaXPgRwVraYJ0vwrUKxj9/b/9+LD52axPBpbfPMcHv4qex+iIo0oDs=
X-Received: by 2002:a17:902:e5c3:b0:1af:cbdb:9772 with SMTP id
 u3-20020a170902e5c300b001afcbdb9772mr472286plf.18.1685070139255; Thu, 25 May
 2023 20:02:19 -0700 (PDT)
MIME-Version: 1.0
References: <CALTww28aV5CGXQAu46Rkc=fG1jK=ARzCT8VGoVyje8kQdqEXMg@mail.gmail.com>
 <CALTww2_4pS=wF6tR0rVejg1ocyGhkTJic0aA=WCcTXDh+cZXQQ@mail.gmail.com>
 <1dd27191-a4c7-101a-1d1b-5f71503756a6@huaweicloud.com> <CALTww28_feZ7zW6fLPeyhsuvUcXukGtjTZKQ+_cQ9TQpc06TgA@mail.gmail.com>
 <25f36f90-e2ee-7af3-2bfa-8fa9747f6dfd@huaweicloud.com>
In-Reply-To: <25f36f90-e2ee-7af3-2bfa-8fa9747f6dfd@huaweicloud.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Fri, 26 May 2023 11:02:08 +0800
Message-ID: <CALTww28n-qks2yD4JowZ+ewUgLOqszxK0buN84v9Z9mS_=4iqQ@mail.gmail.com>
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

On Fri, May 26, 2023 at 10:48=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> =
wrote:
>
> Hi,
>
> =E5=9C=A8 2023/05/26 10:40, Xiao Ni =E5=86=99=E9=81=93:
> > On Fri, May 26, 2023 at 10:18=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.c=
om> wrote:
> >>
> >> Hi,
> >>
> >> =E5=9C=A8 2023/05/26 10:08, Xiao Ni =E5=86=99=E9=81=93:
> >>> I received an email that this email can't delivered to someone. Resen=
t
> >>> it to linux-raid again.
> >>>
> >>> ---------- Forwarded message ---------
> >>> From: Xiao Ni <xni@redhat.com>
> >>> Date: Fri, May 26, 2023 at 9:49=E2=80=AFAM
> >>> Subject: The read data is wrong from raid5 when recovery happens
> >>> To: Song Liu <song@kernel.org>, Guoqing Jiang <guoqing.jiang@linux.de=
v>
> >>> Cc: linux-raid <linux-raid@vger.kernel.org>, Heinz Mauelshagen
> >>> <heinzm@redhat.com>, Nigel Croxon <ncroxon@redhat.com>
> >>>
> >>>
> >>> Hi all
> >>>
> >>> We found a problem recently. The read data is wrong when recovery
> >>> happens. Now we've found it's introduced by patch 10764815f (md: add
> >>> io accounting for raid0 and raid5). I can reproduce this 100%. This
> >>> problem exists in upstream. The test steps are like this:
> >>>
> >>> 1. mdadm -CR $devname -l5 -n4 /dev/sd[b-e] --force --assume-clean
> >>> 2. mkfs.ext4 -F $devname
> >>> 3. mount $devname $mount_point
> >>> 4. mdadm --incremental --fail sdd
> >>> 5. dd if=3D/dev/zero of=3D/tmp/pythontest/file1 bs=3D1M count=3D10000=
0 status=3Dprogress
> >>> 6. mdadm /dev/md126 --add /dev/sdd
> >> Can you try to zero superblock before add sdd? just to bypass readd.
> >
> > Hi Kuai
> >
> > I tried with this. It can still be reproduced.
>
> Ok, I asked this because we found readd has some problem while testing
> raid10, and it's easy to reporduce...
>
> Then, there is a related fixed patch just merged:
>
> md/raid5: fix miscalculation of 'end_sector' in raid5_read_one_chunk()
>
> The upstream that you tried contain this one?


Hi

My test version doesn't have this patch. But as mentioned in the
original email, I comment the codes that calling raid5_read_one_chunk
out and it still can reproduce this bug. So this patch should not fix
this bug.

Regards
Xiao

>
>
> Thanks,
> Kuai
> >
> >>
> >> Thanks,
> >> Kuai
> >>> 7. create 31 processes that writes and reads. It compares the content
> >>> with md5sum. The test will go on until the recovery stops
> >>> 8. wait for about 10 minutes, we can see some processes report
> >>> checksum is wrong. But if it re-read the data again, the checksum wil=
l
> >>> be good.
> >>>
> >>> I tried to narrow this problem like this:
> >>>
> >>> -       md_account_bio(mddev, &bi);
> >>> +       if (rw =3D=3D WRITE)
> >>> +               md_account_bio(mddev, &bi);
> >>> If it only do account for write requests, the problem can disappear.
> >>>
> >>> -       if (rw =3D=3D READ && mddev->degraded =3D=3D 0 &&
> >>> -           mddev->reshape_position =3D=3D MaxSector) {
> >>> -               bi =3D chunk_aligned_read(mddev, bi);
> >>> -               if (!bi)
> >>> -                       return true;
> >>> -       }
> >>> +       //if (rw =3D=3D READ && mddev->degraded =3D=3D 0 &&
> >>> +       //    mddev->reshape_position =3D=3D MaxSector) {
> >>> +       //      bi =3D chunk_aligned_read(mddev, bi);
> >>> +       //      if (!bi)
> >>> +       //              return true;
> >>> +       //}
> >>>
> >>>           if (unlikely(bio_op(bi) =3D=3D REQ_OP_DISCARD)) {
> >>>                   make_discard_request(mddev, bi);
> >>> @@ -6180,7 +6180,8 @@ static bool raid5_make_request(struct mddev
> >>> *mddev, struct bio * bi)
> >>>                           md_write_end(mddev);
> >>>                   return true;
> >>>           }
> >>> -       md_account_bio(mddev, &bi);
> >>> +       if (rw =3D=3D READ)
> >>> +               md_account_bio(mddev, &bi);
> >>>
> >>> I comment the chunk_aligned_read out and only account for read
> >>> requests, this problem can be reproduced.
> >>>
> >>
> >
> >
>


--=20
Best Regards
Xiao Ni

