Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E64EC433F5
	for <linux-raid@archiver.kernel.org>; Mon, 31 Jan 2022 19:46:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232738AbiAaTqu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 31 Jan 2022 14:46:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231583AbiAaTqt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 31 Jan 2022 14:46:49 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC37C061714
        for <linux-raid@vger.kernel.org>; Mon, 31 Jan 2022 11:46:49 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id j24so10806758qkk.10
        for <linux-raid@vger.kernel.org>; Mon, 31 Jan 2022 11:46:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vNICDSKfpWpOLE7IBgspBdycd3A2At2je2bMsQG9Wqg=;
        b=Hf5nqaMpAkAF+heAnXxN6OUbp9EkkwuWvmNDHPBi3QTfm8DpuMlfI7tj+xvyk+CBO4
         k8f2as+tXdOzshND13rF/5UH6iduXeP88v/jHTbcNexNLaOzMEmQo2yUHY2TY6E91+uc
         6Ngk6k0b8F91o2lkRCSo5vz1QVv+IU8bz6Nro4SrU1N2GFZpPLT+8Fo8Odfrlgpp2LRe
         K9hlTKXoQc+ikgyznzilIKFD8nFEItjssDhp3VxhM5YwDIMlgFOXqSSa3l3tsXc93Nf6
         Ha/jMaVFhDAk2OAfwBTu2H43UKaJGJQ4Pp+Y+MK1B+9P1IPt/eDyrSWwZoVMC+0JGxat
         eYrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vNICDSKfpWpOLE7IBgspBdycd3A2At2je2bMsQG9Wqg=;
        b=OZ8SYXIx1yJKhWnwaqN5+0yTevUcZ/pfE1tXoItMgcFtFE8ykD0Xz5nGnCgYkItxK/
         xfoVxCkU9LM2qejUpCA1eW6+Uze3qhpbN2kG1pH2yzzYsw5S+eoLexIaBvFn5xG7LnJM
         mJP841kV/EdJBbTO3N/B7Peg+XgJKuEToenUQ0AGZe9ur+ZHuxrS2lNYrMkU0tp/h2dV
         QW7iZU4e8f3giVzLGQuM+oXukhmuk7X7Afmnm6TeEuS8zCMjbLchEHKt3hbKU7nrV5f0
         I1G2EkgrP2Y/bUKpXuRpNpTQ3RO8kxIotA7Lfx8nlUZ9wtRKbnn3XE6zOI2TMyF/GMXm
         VxBw==
X-Gm-Message-State: AOAM532S9Nielrcu+Z/+VuN/Vdyv/POAiQ+JlmLIsPNcrRFNbB345iAh
        jx++rHLyGvu7r93VC8WC57RSc8iwbX1awPeSLlY1nvEi
X-Google-Smtp-Source: ABdhPJxane34gzB8Dr/i2bdzYUMdEbvZq/1mj+Bh3nuyKywxoTy35vdVPDQNHmuTqDxVe6lGkxMeyvprPe1U4bjw/+o=
X-Received: by 2002:a05:620a:4623:: with SMTP id br35mr8519631qkb.586.1643658408461;
 Mon, 31 Jan 2022 11:46:48 -0800 (PST)
MIME-Version: 1.0
References: <20220121164804.GE14596@justpickone.org> <6cfb92e5-5845-37ff-d237-4c3d663446e3@youngman.org.uk>
 <33fb3dfd-e234-14d9-7643-3449c700a241@youngman.org.uk> <b052c0be-a57b-7e2f-c2ca-44a58e971e39@youngman.org.uk>
 <CAAMCDeeXT2Sy5Tczou7X6uO1yJx9TigEmJz9guwPUjT5SiEzQQ@mail.gmail.com>
 <7571b432-4b19-3de4-b04d-3a46b09b0629@turmel.org> <c3b7a580-952f-7c7a-fddc-88ca0b5fde84@youngman.org.uk>
 <87leyvvrqp.fsf@esperi.org.uk> <CAAMCDee0zoWB9ud6wxvfSj0rpswFde9dd2T3chur4R9YFnRPwQ@mail.gmail.com>
 <d4036e94-4df8-c068-c72c-926d910c63b4@demonlair.co.uk> <698869e2-b45c-a355-f58b-d7b1b4f7830d@turmel.org>
In-Reply-To: <698869e2-b45c-a355-f58b-d7b1b4f7830d@turmel.org>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Mon, 31 Jan 2022 13:46:34 -0600
Message-ID: <CAAMCDee4yWfockZLKyPqj_UbrBv02=97yfPuchG-Ahd8sRdd4A@mail.gmail.com>
Subject: Re: hardware recovery and RAID5 services
To:     Phil Turmel <philip@turmel.org>
Cc:     Geoff Back <geoff@demonlair.co.uk>, Nix <nix@esperi.org.uk>,
        Wols Lists <antlists@youngman.org.uk>,
        David T-G <davidtg+robot@justpickone.org>,
        Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I have been warranty/replace them when the sectors refuse to
reallocate, and/or the disks continue to hit the ERC/TLER timeout all
of the time with bad sectors growing rapidly with no end in sight.

If one is using raid6 and given the low rate of bad sectors, then it
is pretty unlikely that there will be data loss.  If one was using
raid5 things would be more worrisome.


On Mon, Jan 31, 2022 at 1:21 PM Phil Turmel <philip@turmel.org> wrote:
>
> On 1/31/22 14:07, Geoff Back wrote:
>
> >
> > If a disk has one or more bad sectors, surely the only logical action is
> > to schedule it for replacement as soon as a new one can be obtained; and
> > if it's still in warranty, send it back.  If the data is valuable enough
> > to warrant use of RAID (along with, presumably, appropriate backups)
> > surely it is too valuable to risk continuing to use a known faulty disk?
> >
> > In which case, I would suggest that dangerous experiments that try to
> > force the disk to reallocate the block are arguably pointless.
> >
> > Just my opinion, but one that has served me well so far.
> >
> > Regards,
> >
> > Geoff.
>
> I would be surprised if you got warranty replacement just for a few
> re-allocated sectors.  The sheer quantity of sectors in modern drives
> and the tiny magnetic domains involved means **no** drive is error-free.
>   Just most defects are identified and mapped out before shipping.
> Reallocations cover the marginal cases.
>
> I replace drives when re-allocations hit double digits, though I've had
> to run a few corners cases well past that point.
>
> Phil
