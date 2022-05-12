Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C15A8C433EF
	for <linux-raid@archiver.kernel.org>; Thu, 12 May 2022 16:27:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356482AbiELQ1A (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 12 May 2022 12:27:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356473AbiELQ0x (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 12 May 2022 12:26:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E9013B569;
        Thu, 12 May 2022 09:26:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB5B461FC5;
        Thu, 12 May 2022 16:26:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AFEFC385B8;
        Thu, 12 May 2022 16:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652372805;
        bh=k8tdP8hFke1dIvOXUigxmaWTXzeuwGky9NQpGDkGvfk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Z++amXAnX4beXH+dT5KvXmhI4pEWOlGn6oiVhEwUcRdXLLkDigeDKt+IIl+Wspuxv
         NJQJHqleQwjolLbFCDJto/7xQVVYJsbYUyRI5WF4f/pMvvaKjbukE7OnPJP6DgWms4
         dKvXsb7ge3aPpXPlWd6de5W74Zh9zqcy2JuVAj1nNIZt4AJyFwXr7l0NiFddQ33nPc
         JF7Qseh794FKVgfS6KkyPmBCUS3be8UyCrVqboSbiO6PuytKGNaq0cCwmC9Iwb9UI+
         7L737Ka1BJpEFyq+QOzUHkMCysLcfUyEmwOA4ibcS4WBUP/fZU3i91YIOjt4AOactO
         Pqqc3/PZZcZwA==
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-2f7d7e3b5bfso62825307b3.5;
        Thu, 12 May 2022 09:26:45 -0700 (PDT)
X-Gm-Message-State: AOAM530a0/ELB7zg6MYtiPbgbZSPxKamVaWfy9Z8Y/xFrnU1HdU4FzPI
        yWu3rry+8QDx4prsmFTByHAW3GNTGaxEM/vRNiw=
X-Google-Smtp-Source: ABdhPJzvf9yf7GRdk47J43oxFcIBC+7RLdpKOyyh1E0UWIwsju3rtYYxG1oiqNKTwgfsjcxyxXpDm7tqJaUsteu4PmI=
X-Received: by 2002:a81:e93:0:b0:2f9:effe:cf4 with SMTP id 141-20020a810e93000000b002f9effe0cf4mr934480ywo.460.1652372804352;
 Thu, 12 May 2022 09:26:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220512061913.1826735-1-hch@lst.de> <290eada6-226a-6570-1860-c4ca1d680993@molgen.mpg.de>
 <20220512062727.GA20557@lst.de> <c38cf859-4462-629e-1bc5-f3e300a8764c@molgen.mpg.de>
In-Reply-To: <c38cf859-4462-629e-1bc5-f3e300a8764c@molgen.mpg.de>
From:   Song Liu <song@kernel.org>
Date:   Thu, 12 May 2022 09:26:33 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6WXHCWs0oVqkmPWwP4Uj0H9r1+CuPMQ4nbqef+FTh97A@mail.gmail.com>
Message-ID: <CAPhsuW6WXHCWs0oVqkmPWwP4Uj0H9r1+CuPMQ4nbqef+FTh97A@mail.gmail.com>
Subject: Re: [PATCH] md: remove most calls to bdevname
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Christoph Hellwig <hch@lst.de>,
        linux-raid <linux-raid@vger.kernel.org>,
        linux-block@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, May 12, 2022 at 1:01 AM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
>
> Dear Christoph,
>
>
> Am 12.05.22 um 08:27 schrieb Christoph Hellwig:
> > On Thu, May 12, 2022 at 08:25:28AM +0200, Paul Menzel wrote:
>
> >> Am 12.05.22 um 08:19 schrieb Christoph Hellwig:
> >>> Use the %pg format specifier to save on stack consuption and code size.
> >>
> >> consu*m*ption
> >>
> >> Did you do any measurements?
> >
> > Each BDEVNAME_SIZE array consumes 32 bytes on the stack, and they are
> > gone now without any additional stack usage elsewhere.
>
> Understood.
>
> For comparing the code size, out of curiosity, I built `drivers/md` from
> md-next, commit 74fe94569da7 (md: protect md_unregister_thread from
> reentrancy), without and with your patch with gcc 11.1.0, and got:
>
> ```
> $ diff -u <(cd drivers/md-before/ && du -a | sort -k2) <(cd drivers/md/
> && du -a | sort -k2)
> --- /dev/fd/63  2022-05-12 09:51:23.354107016 +0200
> +++ /dev/fd/62  2022-05-12 09:51:23.355107064 +0200
> @@ -1,4 +1,4 @@
> -11064  .
> +11052  .
>   4      ./.built-in.a.cmd
>   48     ./.dm-bio-prison-v1.o.cmd
>   20     ./.dm-bio-prison-v1.o.d
> @@ -287,7 +287,7 @@
>   24     ./md-multipath.o
>   260    ./md.c
>   28     ./md.h
> -308    ./md.o
> +304    ./md.o
>   4      ./modules.order
>   1380   ./persistent-data
>   48     ./persistent-data/.dm-array.o.cmd
> @@ -356,7 +356,7 @@
>   148    ./raid10.c
>   8      ./raid10.h
>   4      ./raid10.mod
> -108    ./raid10.o
> +104    ./raid10.o
>   88     ./raid5-cache.c
>   76     ./raid5-cache.o
>   8      ./raid5-log.h
> @@ -364,4 +364,4 @@
>   48     ./raid5-ppl.o
>   252    ./raid5.c
>   32     ./raid5.h
> -212    ./raid5.o
> +208    ./raid5.o
> ```
>
>
> Kind regards,
>
> Paul

Applied to md-next. Thanks!

Song
