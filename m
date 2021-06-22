Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC8E9C4743C
	for <linux-raid@archiver.kernel.org>; Tue, 22 Jun 2021 01:48:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB8DA611C1
	for <linux-raid@archiver.kernel.org>; Tue, 22 Jun 2021 01:48:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbhFVBvN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 21 Jun 2021 21:51:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20971 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229663AbhFVBvM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 21 Jun 2021 21:51:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624326537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bv4Y6MHLXIbEPaIpLuiXtLafLWy630ExgSl5up0FmUk=;
        b=dKvl/eK22kktOMuSFtFwTwM+uJJLMv24XnuNC+NlT+LarGsG/iIC1K6qQkYD988FL4kcGT
        RLT01v89t/J30UCnHALJY2FtztU/iLwuYo8wQqOVZyyEHCLaLa3f7jXaXhXaQZ0lCKwnOZ
        JRE1FuOJu9p2ULFXdqHofys4Ua2nwog=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-262-cUKb1Zj6Maay3xxvetsd2Q-1; Mon, 21 Jun 2021 21:48:55 -0400
X-MC-Unique: cUKb1Zj6Maay3xxvetsd2Q-1
Received: by mail-ej1-f69.google.com with SMTP id l6-20020a1709062a86b029046ec0ceaf5cso4564029eje.8
        for <linux-raid@vger.kernel.org>; Mon, 21 Jun 2021 18:48:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bv4Y6MHLXIbEPaIpLuiXtLafLWy630ExgSl5up0FmUk=;
        b=lleR9jNoqkukIZGgGd8Omw2PR9o/uPvxyo10lXlIvFBpE6EM7Y6l5K/bTnnK9CQWYK
         /F9ortfRHTJiX4g1R+ejHUS+fqAFiQRMOX5oe8Z9pUt2oU5pMpjvbrdyMg4vvHz2jlHu
         bXU+FPMf/9df7qf8DGKcV8A0+2CuQtB1yb7hB3ZAfd2w6J1+0C18RH7rpV7WQdcTsWhg
         DBfZ/PaaOBl3yirJGMqF3pvGQScgmb2iHInDEldjx00GVSawqpf+oxvx8JqivEzD+2BB
         txqNn+Z+SzQXEq6ZrH6vlaSuFIjc4Oy7HsNZqaJgMw1uTwYCu04hkJcV0g3c/8MHKphH
         mCGw==
X-Gm-Message-State: AOAM5304JBNIa0e3Ffs/PRpw8nq4rBfD33Jeqd2/wrh02rXk1EEa31bP
        jXu5FNP+0/5m2xW41252g/wwVJkuH6mDe6acqOBq4sqYn2fbUTkknEs/y8GUHObD0nKMszOCNMD
        URk1j4mtx5Nt9J6zY96jKl1PzsIR+QWinXpMXrQ==
X-Received: by 2002:a17:906:2b18:: with SMTP id a24mr1124508ejg.239.1624326534446;
        Mon, 21 Jun 2021 18:48:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy+yjNmyAf7nn7Y1v33+YFO4uB4LwGSDWxLzDQ34j5qYOJvQCGoUvLIEMCQeL4iZ4UWJeUmPfMr2gxOtbj5QrU=
X-Received: by 2002:a17:906:2b18:: with SMTP id a24mr1124501ejg.239.1624326534313;
 Mon, 21 Jun 2021 18:48:54 -0700 (PDT)
MIME-Version: 1.0
References: <85F98DA6-FB28-4C1F-A47D-C410A7C22A3D@gmail.com>
 <YL4Z/QJCKc0NCV5L@T590> <C866C380-7A71-4722-957F-2CE65BDACF26@gmail.com>
 <YMAOO3XjOUl2IG+4@T590> <1C6DB607-B7BE-4257-8384-427BB490C9C0@gmail.com>
 <CALTww28L7afRdVdBf-KsyF6Hvf-8-CORSCpZJAvnVbDRo6chDQ@mail.gmail.com>
 <ED5B1993-9D44-4B9C-A7DF-72BD2375A216@gmail.com> <13C1B2E3-B177-4B05-9FF3-AEE57E964605@gmail.com>
 <CALTww29rcAwSfbpsBzM_pnVSuVTYyt-YJryeUaNkHetCjXktCg@mail.gmail.com> <5EFF6838-7ED8-4B14-BD43-4D4E67628149@gmail.com>
In-Reply-To: <5EFF6838-7ED8-4B14-BD43-4D4E67628149@gmail.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Tue, 22 Jun 2021 09:48:42 +0800
Message-ID: <CALTww29nG8URQkocUGhixU-FUPsK9d3P8yGKw8u3ohes+e9yCg@mail.gmail.com>
Subject: Re: [Bug Report] Discard bios cannot be correctly merged in blk-mq
To:     Wang Shanker <shankerwangmiao@gmail.com>
Cc:     Ming Lei <ming.lei@redhat.com>, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi

For normal read/write requests, it needs to consider parity
calculation. Now it uses page size as the unit. The whole design
is based on this. So it's very hard to change this. But there are many
efforts to improve the performance. The batch requests
can improve the performance.
https://www.spinics.net/lists/raid/msg47207.html. It can help to avoid
to send many small
bios to disks.

And for the discard part, I'll try to do this job.

Regards
Xiao

On Mon, Jun 21, 2021 at 3:49 PM Wang Shanker <shankerwangmiao@gmail.com> wr=
ote:
>
> Hi, Xiao
>
> Many thanks for your reply. I realized that this problem is not limited
> to discard requests. For normal read/write requests, they are also first
> get split into 4k-sized ones and then merged into larger ones. The mergin=
g
> of bio's is limited by queue_max_segments, which leads to small trunks of
> io operations issued to physical devices. It seems that such behavior is
> not optimal and should be improved.
>
> I'm not so familiar with raid456. Could you have a look of its code when =
you
> are free? It seems that improving this may result in big changes.
>
> Cheers,
>
> Miao Wang
>
> > 2021=E5=B9=B406=E6=9C=8818=E6=97=A5 20:49=EF=BC=8CXiao Ni <xni@redhat.c=
om> =E5=86=99=E9=81=93=EF=BC=9A
> >
> > Hi Miao
> >
> > So you plan to fix this problem now? The plan is to submit the discard
> > bio directly to disk similar with raid0/raid10.
> > As we talked, it needs to consider the discard region. It should be
> > larger than chunk_sectors * nr_data_disks. It needs
> > to split the bio when its size not aligned with chunk_sectors *
> > nr_data_disks. And it needs to consider the start address
> > of the bio too. If it's not aligned with a start address of
> > chunk_sectors, it's better to split this part too.
> >
> > I'm working on another job. So I don't have time to do this now. If
> > you submit the patches, I can help to review :)
> >
> > Regards
> > Xiao
> >
> > On Fri, Jun 18, 2021 at 2:28 PM Wang Shanker <shankerwangmiao@gmail.com=
> wrote:
> >>
> >> Hi, Xiao
> >>
> >> Any ideas on this issue?
> >>
> >> Cheers,
> >>
> >> Miao Wang
> >>
> >>> 2021=E5=B9=B406=E6=9C=8809=E6=97=A5 17:03=EF=BC=8CWang Shanker <shank=
erwangmiao@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
> >>>
> >>>>
> >>>> 2021=E5=B9=B406=E6=9C=8809=E6=97=A5 16:44=EF=BC=8CXiao Ni <xni@redha=
t.com> =E5=86=99=E9=81=93=EF=BC=9A
> >>>>
> >>>> Hi all
> >>>>
> >>>> Thanks for reporting about this. I did a test in my environment.
> >>>> time blkdiscard /dev/nvme5n1  (477GB)
> >>>> real    0m0.398s
> >>>> time blkdiscard /dev/md0
> >>>> real    9m16.569s
> >>>>
> >>>> I'm not familiar with the block layer codes. I'll try to understand
> >>>> the codes related with discard request and
> >>>> try to fix this problem.
> >>>>
> >>>> I have a question for raid5 discard, it needs to consider more than
> >>>> raid0 and raid10. For example, there is a raid5 with 3 disks.
> >>>> D11 D21 P1 (stripe size is 4KB)
> >>>> D12 D22 P2
> >>>> D13 D23 P3
> >>>> D14 D24 P4
> >>>> ...  (chunk size is 512KB)
> >>>> If there is a discard request on D13 and D14, and there is no discar=
d
> >>>> request on D23 D24. It can't send
> >>>> discard request to D13 and D14, right? P3 =3D D23 xor D13. If we dis=
card
> >>>> D13 and disk2 is broken, it can't
> >>>> get the right data from D13 and P3. The discard request on D13 can
> >>>> write 0 to the discard region, right?
> >>>
> >>> Yes. It can be seen at the beginning of make_discard_request(), where
> >>> the requested range being discarded is aligned to ``stripe_sectors",
> >>> which should be chunk_sectors * nr_data_disks.
> >>>
> >>> Cheers,
> >>>
> >>> Miao Wang
> >>
> >
>

