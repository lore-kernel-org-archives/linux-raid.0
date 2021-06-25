Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A8D7C2B9F4
	for <linux-raid@archiver.kernel.org>; Fri, 25 Jun 2021 20:04:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C02A61429
	for <linux-raid@archiver.kernel.org>; Fri, 25 Jun 2021 20:04:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhFYUHN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 25 Jun 2021 16:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbhFYUHK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 25 Jun 2021 16:07:10 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12C64C061574
        for <linux-raid@vger.kernel.org>; Fri, 25 Jun 2021 13:04:41 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id x21-20020a17090aa395b029016e25313bfcso6188506pjp.2
        for <linux-raid@vger.kernel.org>; Fri, 25 Jun 2021 13:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kRDKlJTvKjm3OvkIggHkSRhrRF1ON1eSY0mMVc8Wik0=;
        b=eT2LIs8tk9Y7/DVDKaRSIB75LWEqS5YEaEKJwRFILGTbz9QpEJRgSwov+IfjNiGNoW
         n3MhJNhci1reYC08x7522DgvVXx88niUnj92djevNOQrrArXld3mFSe8SZsB7TCAICio
         2aQKGzAitXU5yB9/Aggh6mpxgX6+MgIj06/qFeqsuVSewza2KnHkVb6Qn5rJ2ymakjCp
         jKyK/MOd/lUXbjvDVepRkF6MNXg1eLV3oyy66Fj4kvB/ZILHNjXd+dI5YLCOiQmbGcOW
         3MKqg36PWOJxupfX6E06aEbr2DW5DhE1l9BOSAHT1DdfMzp3f1+j1Veiem6GSMZyBomF
         yB5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kRDKlJTvKjm3OvkIggHkSRhrRF1ON1eSY0mMVc8Wik0=;
        b=BmXhoiReDQD2/lEymQGCisczKpdEzeDkm/1xZVqd11QjfCiG6xtiM55dEJSFVD0by8
         KNU1Ku7i+cb4xODdLWKCKZTmrDwAkby5uUyME8kCZXWmUdHE8m8wF24ux90Dk/7qJmB5
         qfhKlRsRFWQcsQC+Q+3gpLRy2IXCv2yzjwC5ROWJVFfnj2897Iih6xToyosw75BN6cWr
         v1yO7boIjF2DvTNzLYf83vtcGJI5qz2KlcaDd3WlKGeji0W/DHGrRST9xAW7KI9/ph7b
         5UmXQnB7R1lHWhv23ynY0aqHKrwDlnYQRAK3/FGPFXpvlzXmBUtlx2kzxKMEH/yUJbko
         uu4Q==
X-Gm-Message-State: AOAM533Z5BVJMKiiE9RYheW98HgCf5o6hqeTgZpw1jbqpd8PAejZkYIn
        uNlZ8NT1x+r9xlyj6FYfqcqH4TOB3e/RYWKeqkKbOkuqL5A=
X-Google-Smtp-Source: ABdhPJz7e6cYMeeJwsGicsEaVaVd2N98TUSKPQhjfczkpI1xeaNgdvKR1LeUaxGICCU9gotiCRJg33WJB0bmfdOu8dU=
X-Received: by 2002:a17:90a:4d4e:: with SMTP id l14mr12985930pjh.129.1624651480236;
 Fri, 25 Jun 2021 13:04:40 -0700 (PDT)
MIME-Version: 1.0
References: <03ca5974-60ed-d596-7eff-cac44f4a6d62@gmail.com>
 <24787.28117.662584.586506@quad.stoffel.home> <1986d43d-11e9-fbf0-7812-0aafc6568855@youngman.org.uk>
 <CAAMCDedHYKqBDfTysU=-CtxRMVpftPK1+crewRM2yuTDDq653A@mail.gmail.com>
 <CAAMCDee-1J2DVQWPyqe-rZ-E=Ers3Msvdn8+KpFnRxeyQafXWg@mail.gmail.com> <24788.46596.805675.840409@quad.stoffel.home>
In-Reply-To: <24788.46596.805675.840409@quad.stoffel.home>
From:   Mark Wagner <carnildo@gmail.com>
Date:   Fri, 25 Jun 2021 13:04:29 -0700
Message-ID: <CAA04aRQErD-cG5KThbtHSCX9LvPJLQzdZ+Y+wK_Gv12JAPhkQg@mail.gmail.com>
Subject: Re: Question: RAID cabinet for home use
To:     John Stoffel <john@stoffel.org>
Cc:     Roger Heflin <rogerheflin@gmail.com>,
        antlists <antlists@youngman.org.uk>,
        Bill Hudacek <bill.hudacek@gmail.com>,
        mdraid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Jun 24, 2021 at 9:43 AM John Stoffel <john@stoffel.org> wrote:
>
> >>>>> "Roger" == Roger Heflin <rogerheflin@gmail.com> writes:
>
> Roger> resending without html.  Lovely that you seem to have to disable html
> Roger> on each reply.
>
> Roger>  I found an $80 rackmount case that has 2 sets of 3x5.25" bays and
> Roger> would take 2 of the  4 into 3 3.5" hot swap bays (icy dock or athena
> Roger> like devices).
> Roger> https://www.newegg.com/black-istarusa-d-416/p/N82E16811165215
>
> This looks like an interesting case, lots and lots of drive bays...
>
> https://www.newegg.com/rosewill-rsv-l4500u-black/p/N82E16811147328?quicklink=true
>
> and it looks like it even has USB3 on the front.

Looks like a USB3 update of the case I'm using.  It's basically a
9x5.25"-bay case with three 3x5.25" -> 5x3.5" adapters.  The adapters
it comes with aren't hotswap capable, but it's easy to pull them out
and replace them with ones that are.

-- 
Mark
