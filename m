Return-Path: <SRS0=wQ6l=CG=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF977C433E6
	for <linux-raid@archiver.kernel.org>; Fri, 28 Aug 2020 22:16:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A91932080C
	for <linux-raid@archiver.kernel.org>; Fri, 28 Aug 2020 22:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598652978;
	bh=lT29+K40Cx+HYX2gSy654+F5M3sFb+JGRhbCgT7QB0I=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=AIoj7g98oNVNkKKU2xaaQyafduQiyZSZKANK+7M6+5JnCYgSnG6vgmn8B+WT/vyhr
	 cLBlAOoX6QnA9nR2OKZzVQDFQmlJdTQWM8Anp6L2Qk91GnLUvOWx/jmTR0ps8G1Rhg
	 9Vnb/i+IM3EuoumiHvQXQ4QnBr/SiKFN9pXyjaBU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgH1WQS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 28 Aug 2020 18:16:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:51826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726338AbgH1WQO (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 28 Aug 2020 18:16:14 -0400
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E866F2086A
        for <linux-raid@vger.kernel.org>; Fri, 28 Aug 2020 22:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598652974;
        bh=lT29+K40Cx+HYX2gSy654+F5M3sFb+JGRhbCgT7QB0I=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=rZWLWSHKlDfPSZ1Nsns6cnmpx3zCmDODyXwVk/fKHeTHzWOhSey80gEH0qSk/cmdV
         F+yPcBtq669dmonEQPn+/kF5fdlflhEz7UopVtWU1fN/Tr1hbkmwEhXTpK75wxMnzG
         6WLwG41Ww+8HRbxbIMSG4tVcAUofmvnQNyvUociU=
Received: by mail-lf1-f52.google.com with SMTP id x77so465185lfa.0
        for <linux-raid@vger.kernel.org>; Fri, 28 Aug 2020 15:16:13 -0700 (PDT)
X-Gm-Message-State: AOAM532zqPBvXev8LxZ8sCTkS0zKLAloHpmmHxIpmXULyTldDAjjppds
        L2gilJZzz9ZxKFIXTM3wEtjuiEHPCh4P6V1xZrQ=
X-Google-Smtp-Source: ABdhPJyCL+VkzRncRad3zHCeSFjtJ1weCAMUNDdbUmB8RPRHjbpihY4XtTwHy1h6z0ORw3l+61ecxx2L1Cd0275w/5M=
X-Received: by 2002:a19:404e:: with SMTP id n75mr279632lfa.172.1598652972253;
 Fri, 28 Aug 2020 15:16:12 -0700 (PDT)
MIME-Version: 1.0
References: <1598334183-25301-1-git-send-email-xni@redhat.com> <1598334183-25301-5-git-send-email-xni@redhat.com>
In-Reply-To: <1598334183-25301-5-git-send-email-xni@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 28 Aug 2020 15:16:00 -0700
X-Gmail-Original-Message-ID: <CAPhsuW55WD0iNSEtu9xwV4zEDWxAu_ycMM6ecpoz_DXcooeMLw@mail.gmail.com>
Message-ID: <CAPhsuW55WD0iNSEtu9xwV4zEDWxAu_ycMM6ecpoz_DXcooeMLw@mail.gmail.com>
Subject: Re: [PATCH V5 4/5] md/raid10: improve raid10 discard request
To:     Xiao Ni <xni@redhat.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Nigel Croxon <ncroxon@redhat.com>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Coly Li <colyli@suse.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Aug 24, 2020 at 10:43 PM Xiao Ni <xni@redhat.com> wrote:
>
[...]
> ---
>  drivers/md/raid10.c | 254 +++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 253 insertions(+), 1 deletion(-)
>
[...]
> +
> +static void raid10_end_discard_request(struct bio *bio)
> +{
> +       struct r10bio *r10_bio = bio->bi_private;
> +       struct r10conf *conf = r10_bio->mddev->private;
> +       struct md_rdev *rdev = NULL;
> +       int dev;
> +       int slot, repl;
> +
> +       /*
> +        * We don't care the return value of discard bio
> +        */
> +       if (!test_bit(R10BIO_Uptodate, &r10_bio->state))
> +               set_bit(R10BIO_Uptodate, &r10_bio->state);

We don't need the test_bit(), just do set_bit().

> +
> +       dev = find_bio_disk(conf, r10_bio, bio, &slot, &repl);
> +       if (repl)
> +               rdev = conf->mirrors[dev].replacement;
> +       if (!rdev) {
> +               /* raid10_remove_disk uses smp_mb to make sure rdev is set to
> +                * replacement before setting replacement to NULL. It can read
> +                * rdev first without barrier protect even replacment is NULL
> +                */
> +               smp_rmb();
> +               repl = 0;
repl is no longer used, right?

> +               rdev = conf->mirrors[dev].rdev;
[...]

> +
> +       if (conf->reshape_progress != MaxSector &&
> +           ((bio->bi_iter.bi_sector >= conf->reshape_progress) !=
> +            conf->mddev->reshape_backwards))
> +               geo = &conf->prev;

Do we need to set R10BIO_Previous here? Also, please run some tests with
reshape in progress.

Thanks,
Song
