Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3965C197A0
	for <linux-raid@archiver.kernel.org>; Sat, 18 Nov 2023 00:32:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234284AbjKRAcU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 17 Nov 2023 19:32:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232504AbjKRAcT (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 17 Nov 2023 19:32:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E804E10CE
        for <linux-raid@vger.kernel.org>; Fri, 17 Nov 2023 16:32:15 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72347C433D9
        for <linux-raid@vger.kernel.org>; Sat, 18 Nov 2023 00:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700267535;
        bh=jXKeJgS2efdeMW4uax+hDxFhcDk5npNFT1+zFEUZb2M=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=fqNNbBxq/JhNPpmAX5TxM3CstlfJzx4HhbdBcNLdN3Q9/6jvFGVLZz6ODssvHXRll
         C1bN98O9T33eWp18PJ0RX4doINUh9cq/R8ZcEc20UwERb2FSFbL5Zov+m6eLOw5XO1
         U0G7ve4go2/U2AcRQBfyrcnDNhXxr73zNrB7z/DdLTs2A8gmjboeRkcxWLDePonZMd
         YHjaAYfb6skwPEoTTg/+IJvU8c2He+NExPPwWYWQ/APgYVtuWcArdciluMchWxdujz
         VMzqINiboCWbhkUf3kw3wZx8hdoQrUyUiSlDt8/iYqaZmT0ujOkI3o51GKdzc46Hz3
         fUHcxkHgPIZgQ==
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-507e85ebf50so3384971e87.1
        for <linux-raid@vger.kernel.org>; Fri, 17 Nov 2023 16:32:15 -0800 (PST)
X-Gm-Message-State: AOJu0YyXcyw49ztroVQPFAa/Q4trrCBjWRhnSB8jG++2WY/B40/QURcA
        uDzQYSSz1Ieb0k5U3j/YaYpYNQdR9nU11t5lhIY=
X-Google-Smtp-Source: AGHT+IGzdR13CFoknC3hQoaKVSXX98FA5eFCg5mgyMyFqXD5N0rpGMQWBThfLNeAn8wHcGTVgGrk+FxYy6kZVWli7lI=
X-Received: by 2002:ac2:4567:0:b0:50a:77e9:d07a with SMTP id
 k7-20020ac24567000000b0050a77e9d07amr745858lfm.44.1700267533576; Fri, 17 Nov
 2023 16:32:13 -0800 (PST)
MIME-Version: 1.0
References: <5727380.DvuYhMxLoT@bvd0> <CAPhsuW4+Ktd7mzTQ6M4n9-=8vgyMDJUi8Xkcv50JXTf_2yqTFA@mail.gmail.com>
 <1956a189-107b-4445-9e53-336f1533c4b9@huaweicloud.com>
In-Reply-To: <1956a189-107b-4445-9e53-336f1533c4b9@huaweicloud.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 17 Nov 2023 16:32:01 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6v+acp9jrwt-19fF7BUpLtDTRvVG4FNimpww4ztODHrg@mail.gmail.com>
Message-ID: <CAPhsuW6v+acp9jrwt-19fF7BUpLtDTRvVG4FNimpww4ztODHrg@mail.gmail.com>
Subject: Re: [REGRESSION] Data read from a degraded RAID 4/5/6 array could be
 silently corrupted.
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     Bhanu Victor DiCara <00bvd0+linux@gmail.com>,
        Xiao Ni <xni@redhat.com>,
        Mateusz Grzonka <mateusz.grzonka@intel.com>,
        linux-raid@vger.kernel.org, regressions@lists.linux.dev,
        jiangguoqing@kylinos.cn, jgq516@gmail.com,
        "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Nov 16, 2023 at 5:05=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2023/11/17 0:24, Song Liu =E5=86=99=E9=81=93:
> > + more folks.
> >
> > On Fri, Nov 10, 2023 at 7:00=E2=80=AFPM Bhanu Victor DiCara
> > <00bvd0+linux@gmail.com> wrote:
> >>
> >> A degraded RAID 4/5/6 array can sometimes read 0s instead of the actua=
l data.
> >>
> >>
> >> #regzbot introduced: 10764815ff4728d2c57da677cd5d3dd6f446cf5f
> >> (The problem does not occur in the previous commit.)
> >>
> >> In commit 10764815ff4728d2c57da677cd5d3dd6f446cf5f, file drivers/md/ra=
id5.c, line 5808, there is `md_account_bio(mddev, &bi);`. When this line (a=
nd the previous line) is removed, the problem does not occur.
> >
> > The patch below should fix it. Please give it more thorough tests and
> > let me know whether it fixes everything. I will send patch later with
> > more details.
> >
> > Thanks,
> > Song
> >
> > diff --git i/drivers/md/md.c w/drivers/md/md.c
> > index 68f3bb6e89cb..d4fb1aa5c86f 100644
> > --- i/drivers/md/md.c
> > +++ w/drivers/md/md.c
> > @@ -8674,7 +8674,8 @@ static void md_end_clone_io(struct bio *bio)
> >          struct bio *orig_bio =3D md_io_clone->orig_bio;
> >          struct mddev *mddev =3D md_io_clone->mddev;
> >
> > -       orig_bio->bi_status =3D bio->bi_status;
> > +       if (bio->bi_status)
> > +               orig_bio->bi_status =3D bio->bi_status;
>
> I'm confused, do you mean that orig_bio can have error while bio
> doesn't? If this is the case, can you explain more how this is
> possible?

Yes, this is possible.

Basically, a big bio is split by md_submit_bio =3D> bio_split_to_limits, so
we will have two bio's into md_clone_bio(). Let's call them
parent_orig_bio and split_orig_bio. Errors from split_orig_bio will be
propagated to parent_orig_bio by __bio_chain_endio(). If
parent_orig_bio succeeded, md_end_clone_io may overwrite the error
reported by split_orig_bio. Does this make sense?

Thanks,
Song
