Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBFE8C4361B
	for <linux-raid@archiver.kernel.org>; Wed, 16 Dec 2020 04:29:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7813B22210
	for <linux-raid@archiver.kernel.org>; Wed, 16 Dec 2020 04:29:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725710AbgLPE3L (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:29:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:45010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725275AbgLPE3K (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 15 Dec 2020 23:29:10 -0500
X-Gm-Message-State: AOAM530LaRGCaorLdP3Ew5PPjL+nwZ/nGlBXEXYU9guZXp0qJmBcsLZG
        Tmusd2yyOUCDXkf+fkPu3IdP2RdwY82L3ypGMUc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608092910;
        bh=pXmc0xY4veHzuC+UYnNUrEmo1gi4+K0e1eY6LHGUpDU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Cr7QYVDXLJ4980+JOOil78s6WBacaWcHk5+bZR5DhCXl9Tj8/OX12qOKSjNLG0hFZ
         sqTkjJjQVE22TTzKR0CisMltw+LSS1EvzcTSL3/p9UkHPq7+1gPYLLDQb6aIH9W+A2
         ZP4ejG1zXdb0eQW5ofwBDdAnDCaAPUiDW3Mt1fO78WcvXRzYYz8xpOGKhYM+F02EPt
         ImTq00nyR35zB1JEl7PsZRhjWTff/Exvq3jcS+SFjE9rhCGtzMh069U01C/TJdWeYl
         WGXgEOOJpzwxmYfb+LimW/8Ou/VDKrVUdzXOmmeo7G445DCPj8j04a9HLk5+/CDz62
         w5qb/i/qQfwdg==
X-Google-Smtp-Source: ABdhPJyjRVYSdJOLNappa5fdyY+tLn1CtELznfCd9I4xyMLfCixc0IH0pV7LMzEYMhXpPvqaGh4PaUX5YmJNvvt6xE4=
X-Received: by 2002:ac2:5199:: with SMTP id u25mr11848031lfi.438.1608092908561;
 Tue, 15 Dec 2020 20:28:28 -0800 (PST)
MIME-Version: 1.0
References: <89d2eb88e6a300631862718024e687fc3102a4e1.camel@seblu.net>
 <CAPhsuW4upOOUq13argQ_0VK0Xwrof7K9vzKO8NjKxL7qPMKtDg@mail.gmail.com> <5d57edd9de751d009023407666f97e72a31f1459.camel@seblu.net>
In-Reply-To: <5d57edd9de751d009023407666f97e72a31f1459.camel@seblu.net>
From:   Song Liu <song@kernel.org>
Date:   Tue, 15 Dec 2020 20:28:17 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4zE+a0rh6f+tFeM8QcW6GP2evd03X89agxrm0=WpDTxw@mail.gmail.com>
Message-ID: <CAPhsuW4zE+a0rh6f+tFeM8QcW6GP2evd03X89agxrm0=WpDTxw@mail.gmail.com>
Subject: Re: Array size dropped from 40TB to 7TB when upgrading to 5.10
To:     =?UTF-8?Q?S=C3=A9bastien_Luttringer?= <seblu@seblu.net>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Dec 15, 2020 at 6:28 PM S=C3=A9bastien Luttringer <seblu@seblu.net>=
 wrote:
>
>
> On Tue, 2020-12-15 at 15:53 -0800, Song Liu wrote:
> > On Tue, Dec 15, 2020 at 10:40 AM S=C3=A9bastien Luttringer <seblu@seblu=
.net>
> > wrote:
> >
> >
> > Hi,
> >
> > I am very sorry for this problem. This is a bug in 5.10 which is fixed
> > in 5.10.1.
> > To fix it, please upgrade your kernel to 5.10.1 (or downgrade to previo=
us
> > version). In many cases, the array should be back normal. If not, pleas=
e try
> >
> >        mdadm --grow --size <size> /dev/mdXXX.
> >
> > If the original array uses the full disk/partition, you can use "max" f=
or
> > <size>
> > to safe some calculation.
> >
> > Please let me know if you have future problem with it.
>
> Hello,
>
> The array didn't returned to normal after a reboot on 5.10.1. The `mdadm =
--grow
> --size max /dev/md0` command did the trick. The e2fsck detect no error, s=
o we
> are back online.
>
> Thanks you for your help and especially your quick answer.

I am glad that helped.

Song
