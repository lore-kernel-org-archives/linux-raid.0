Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D4FAC77B7A
	for <linux-raid@archiver.kernel.org>; Sat, 27 May 2023 00:57:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbjE0A5P (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 26 May 2023 20:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjE0A5O (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 26 May 2023 20:57:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1AC4135
        for <linux-raid@vger.kernel.org>; Fri, 26 May 2023 17:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685148987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PliNYaeVyKgmHlvxjV+cayRGh6lGtjzraqlLz9II0MY=;
        b=Pwe3Fc7XjPQDeRdKCmnAyu29UtKfi47vGKFgf4z4D9nW3osnJcnOsmUwDMNqZT8LAVhslp
        g2409y+g6nfEzzoHg14Ix3L19cTL/KDFQxYlwbRYOgGO+sZ5MwjnyNvN7m/xG2076gg1Bd
        08TqRNYx7TVaSJsMKXmPNkeAqOyO18c=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-321-PEL2RSSkN72cBQ7b19JOjg-1; Fri, 26 May 2023 20:56:23 -0400
X-MC-Unique: PEL2RSSkN72cBQ7b19JOjg-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1ae8ed1c293so8730455ad.3
        for <linux-raid@vger.kernel.org>; Fri, 26 May 2023 17:56:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685148982; x=1687740982;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PliNYaeVyKgmHlvxjV+cayRGh6lGtjzraqlLz9II0MY=;
        b=hn1Hp6OQ7qLitTktYPnMbi1hdHKEez4n/TtDHN9VQC9k3hVkZHS3FCYoDE7dZp9+eT
         DUstxQ7hIK0/JEC+LLUehni9k6h4yC4TDqB5X7cm8/xeUBSnSmKoRUaGZmVCcIR0jWsm
         rYj/xw3bZ4LdG8L28fpvN7TB65341IR3ZTqfVcuirDZWKuGQwSXqAyC6PBxVmBB2YMH5
         GDf+CFO021aAf4zLnCwV8MUW1BfPtUsfKXLZ/2UYSR+k8St4a1vV83KH8Vw4Zqd9KidL
         +y+1VVcF9Aec2U03RMpn18bIj4eu6xo67Kui8lJRpWLGvA8pjnnLGVEUYIETihIhZQSX
         b9Ww==
X-Gm-Message-State: AC+VfDwap++kOqlzgQPLOAEjoUBunljz6Pi1+zB0B8jnseyHzzkABe5q
        UDIE5SjsfmvV9n4zeemO1Qh6bM0nfetCFG43H1wSj7Sc1M49Sl/oDvzGMNgN8HEpFCe1EChbMjd
        iINX5AAraQoxM19TTvAnTnXxmHYBu3fKMsy3qvQ==
X-Received: by 2002:a17:902:d504:b0:1ae:72fc:a625 with SMTP id b4-20020a170902d50400b001ae72fca625mr5055730plg.37.1685148982564;
        Fri, 26 May 2023 17:56:22 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6IYWDILqcGtjPTgJexbWh+5sUXcRj/YEosHSkEQxqM+4s8JgZD1URLCch+FaQu6P7956D+ywIu39/VaVctoMg=
X-Received: by 2002:a17:902:d504:b0:1ae:72fc:a625 with SMTP id
 b4-20020a170902d50400b001ae72fca625mr5055710plg.37.1685148982156; Fri, 26 May
 2023 17:56:22 -0700 (PDT)
MIME-Version: 1.0
References: <CALTww28aV5CGXQAu46Rkc=fG1jK=ARzCT8VGoVyje8kQdqEXMg@mail.gmail.com>
 <ebe7fa31-2e9a-74da-bbbd-3d5238590a7c@linux.dev> <CALTww2_ks+Ac0hHkVS0mBaKi_E2r=Jq-7g2iubtCcKoVsZEbXQ@mail.gmail.com>
 <7e9fd8ba-aacd-3697-15fe-dc0b292bd177@linux.dev> <CALTww297Q+FAFMVBQd-1dT7neYrMjC-UZnAw8Q3UeuEoOCy6Yg@mail.gmail.com>
 <20230526111312.000065f2@linux.intel.com> <CAPhsuW4XKYDsEJsbJJX7mDdq_hhF1D8YLN5oyBi746EUtYVv8A@mail.gmail.com>
In-Reply-To: <CAPhsuW4XKYDsEJsbJJX7mDdq_hhF1D8YLN5oyBi746EUtYVv8A@mail.gmail.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Sat, 27 May 2023 08:56:10 +0800
Message-ID: <CALTww29YU+ZtbJanzB0buFfofDMv2C68EL2C_Ocr375amCAh+w@mail.gmail.com>
Subject: Re: The read data is wrong from raid5 when recovery happens
To:     Song Liu <song@kernel.org>
Cc:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        "Tkaczyk, Mariusz" <mariusz.tkaczyk@intel.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Nigel Croxon <ncroxon@redhat.com>
Content-Type: multipart/mixed; boundary="00000000000079ceb005fca2522d"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

--00000000000079ceb005fca2522d
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 27, 2023 at 5:13=E2=80=AFAM Song Liu <song@kernel.org> wrote:
>
> On Fri, May 26, 2023 at 2:13=E2=80=AFAM Mariusz Tkaczyk
> <mariusz.tkaczyk@linux.intel.com> wrote:
> >
> > On Fri, 26 May 2023 15:23:58 +0800
> > Xiao Ni <xni@redhat.com> wrote:
> >
> > > On Fri, May 26, 2023 at 3:12=E2=80=AFPM Guoqing Jiang <guoqing.jiang@=
linux.dev> wrote:
> > > >
> > > >
> > > >
> > > > On 5/26/23 14:45, Xiao Ni wrote:
> > > > > On Fri, May 26, 2023 at 11:09=E2=80=AFAM Guoqing Jiang <guoqing.j=
iang@linux.dev>
> > > > > wrote:
> > > > >>
> > > > >>
> > > > >> On 5/26/23 09:49, Xiao Ni wrote:
> > > > >>> Hi all
> > > > >>>
> > > > >>> We found a problem recently. The read data is wrong when recove=
ry
> > > > >>> happens. Now we've found it's introduced by patch 10764815f (md=
: add io
> > > > >>> accounting for raid0 and raid5). I can reproduce this 100%. Thi=
s
> > > > >>> problem exists in upstream. The test steps are like this:
> > > > >>>
> > > > >>> 1. mdadm -CR $devname -l5 -n4 /dev/sd[b-e] --force --assume-cle=
an
> > > > >>> 2. mkfs.ext4 -F $devname
> > > > >>> 3. mount $devname $mount_point
> > > > >>> 4. mdadm --incremental --fail sdd
> > > > >>> 5. dd if=3D/dev/zero of=3D/tmp/pythontest/file1 bs=3D1M count=
=3D100000
> > > > >>> status=3Dprogress
> > > >
> > > > I suppose /tmp is the mount point.
> > >
> > > /tmp/pythontest is the mount point
> > >
> > > >
> > > > >>> 6. mdadm /dev/md126 --add /dev/sdd
> > > > >>> 7. create 31 processes that writes and reads. It compares the c=
ontent
> > > > >>> with md5sum. The test will go on until the recovery stops
> > > >
> > > > Could you share the test code/script for step 7? Will try it from m=
y side.
> > >
> > > The test scripts are written by people from intel.
> > > Hi, Mariusz. Can I share the test scripts here?
> >
> > Yes. Let us know if there is something else we can do to help here.
>
> I tried to reproduce this with fio, but didn't get much luck. Please shar=
e
> the test scripts.
>
> Thanks,
> Song
>

Hi all

The attachment is the scripts.

1. It needs to modify the member disks and raid name in prepare_rebuild_env=
.sh
2. It needs to modify the member disks and raid name in 01-test.sh
3. Then run 01-test.sh directly

--=20
Best Regards
Xiao Ni

--00000000000079ceb005fca2522d
Content-Type: application/x-gzip; name="readdata.tar.gz"
Content-Disposition: attachment; filename="readdata.tar.gz"
Content-Transfer-Encoding: base64
Content-ID: <f_li5a45b80>
X-Attachment-Id: f_li5a45b80

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
0NhAACIAAA==
--00000000000079ceb005fca2522d--

