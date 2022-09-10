Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 656A1ECAAD3
	for <linux-raid@archiver.kernel.org>; Sat, 10 Sep 2022 20:25:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiIJUZc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 10 Sep 2022 16:25:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiIJUZa (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 10 Sep 2022 16:25:30 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92A603AE48
        for <linux-raid@vger.kernel.org>; Sat, 10 Sep 2022 13:25:29 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id q15-20020a17090a304f00b002002ac83485so4660066pjl.0
        for <linux-raid@vger.kernel.org>; Sat, 10 Sep 2022 13:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=68uuuaAG7ptqlxeteJsbyHoFVpmb2r4DkF4a33acr9Y=;
        b=A4bOJeejsMpBHRjBOsVGM/T4YwkU0rREEqFwak5pSV/wwmgv/Lp7ACVOOfHdu0GnO9
         qJ1Rxw/hKIqjvm3/TpqC8zCOZQeg8pGYufjxIGcZueGKmepE0xQF9TY5PQqDMf13bQdB
         lFWH5ce5UZZFgcVkHo15DbMsDCkG5WM5fuczqxBdiYijr87nfSQEOblMJmmcZPrOUTwf
         sekaAei5ZeE4/e/2tkMIFuNK9s39CSB+prNNC03inrHOZziI9y6r1Wmdi3M4D9kiszAE
         30Mjn8BjAtKX09NiOuR+9ikW9V5mCKBzYXESiaXlQQmKnbnh12s0SLjybXgAW/dJuF7R
         8ncQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=68uuuaAG7ptqlxeteJsbyHoFVpmb2r4DkF4a33acr9Y=;
        b=d0rML4XJqJkC1tubhXJxHx4uwZZ06ifhhzETt4VheE3DHL+56crl3KUv0ItkDyT4MO
         4iTHoqWPEWSYj5lNwkX4Pg4lDN8zkjchn9Zaje0HFmf2cuyikN2NpobBsuZC0o6C6rrh
         mhTnXDO0/T949f/8dUOzZ0kKVSj3DHqCr53wGw//0JUZvAtLFfhNK1VQufRgf5X4DBuH
         k3gy2sC+w/KA0vrN3kfzkMoqdLzPM/0w8Tk/IKnTObzjA4VCPw/wuhXmioGdNhKkuX84
         XvgjMJR0U2VwGbowSvE2jvGchb6FKLsEQtxCwphdXHAdRfbAC+tuIyJTL98vbNdJzCn8
         WVrw==
X-Gm-Message-State: ACgBeo0NvKDfNl93H0mfKu578bS3q3DN2YKKCCs+X4y1fKuo4kjhxjAc
        +Vdlx6lCizU3RxdWAn85ayG9wD8yZg/VbNV1r9U=
X-Google-Smtp-Source: AA6agR6rNKme9jK1aQfC+Xj7FkjOdd6W+UpB3GRTDm+hcZF9clLydbS8z3bdMS48QvxGrbMu9Lo76ep21bynLa6sAWw=
X-Received: by 2002:a17:902:dad1:b0:178:1d6b:cf91 with SMTP id
 q17-20020a170902dad100b001781d6bcf91mr3789152plx.70.1662841529047; Sat, 10
 Sep 2022 13:25:29 -0700 (PDT)
MIME-Version: 1.0
References: <CAJJqR20U=OcMq_8wBMQ5xmWmcBcYoKN5+Fe9sPHYPkZ_yHurQQ@mail.gmail.com>
 <e8b44f4a-b6ae-6912-1b26-f900a24204af@turmel.org> <CAJJqR209OzydScj2jScKvKBR=B6d5JErfaFg=4qcSuC7aEvHEg@mail.gmail.com>
 <CAJJqR22EWec7gMwtVZCxxWc4-w9fEp8jaHWmtENwsLYSi7G5PQ@mail.gmail.com>
 <df503250-7c8e-d6f7-21fd-2fe4f1cae961@turmel.org> <CAJJqR231QRUexo=eqi=ijF+ErT=LZHr7DxWPAqC+RqF51ehmxw@mail.gmail.com>
 <CAJJqR22XEbkzF1wfO_RrnVV01E25q_OBHGdDOyBzOcGfUSwadg@mail.gmail.com>
 <CAJJqR23vGGpL-QRGKi-ft6X4RWWF0SPWJEEa=TPuo1zRnHPS3A@mail.gmail.com>
 <593e868a-d0a4-3ad5-d983-e585607ec212@turmel.org> <CAJJqR23RE3Hfrm-bkiyMm3OjUTCFhXsRvBXr4H8563t1VyY=0g@mail.gmail.com>
 <CAJJqR23+V1_DTzYQv7=6M9U6qbd7yEHE3WR2XuXbaBH2oVqLQw@mail.gmail.com>
 <10e92155-0662-44ca-87b0-16dbdb2efca4@turmel.org> <1e6965ae-5f1a-85ee-cb07-1ef0c57f7f75@turmel.org>
In-Reply-To: <1e6965ae-5f1a-85ee-cb07-1ef0c57f7f75@turmel.org>
From:   Luigi Fabio <luigi.fabio@gmail.com>
Date:   Sat, 10 Sep 2022 16:24:48 -0400
Message-ID: <CAJJqR23NrYqeZ2HqgJUEAvoVZv1qk6u2oGWOUYzLYRgQxgvW=w@mail.gmail.com>
Subject: Re: RAID5 failure and consequent ext4 problems
To:     Phil Turmel <philip@turmel.org>
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Phil,
I did indeed go there, but, stupidly, after the fact and I had missed
the reference to your tool. Not an excuse, but the initial part of the
process was, as I mentioned, complicated and done while driving....

I'll download lsdrv and snapshot the situation in any case, generate
the overlay, run the fsck and see what happens.

I'll report back when it's done, which is probably going to be
tomorrow (fsck times for this filesystem historically have been in the
9+ hr range - and the overlay will probably do us no favours
performancewise).

Back as soon as I have further data. Thank you again for the help.

L

On Sat, Sep 10, 2022 at 4:17 PM Phil Turmel <philip@turmel.org> wrote:
>
> Oh, one more thing:
>
> If you had followed any of the advice on the linux-raid wiki, you'd have
> been pointed to my lsdrv project on github:
>
> https://github.com/pturmel/lsdrv
>
> (Still just python2, sorry.)
>
>
> On 9/10/22 16:14, Phil Turmel wrote:
> > Hi Luigi,
> >
> >
> > On 9/10/22 15:55, Luigi Fabio wrote:
> >> Well, I found SOMETHING of decided interest: when I run dumpe2fs with
> >> any backup superblock, this happens:
> >>
> >> ---
> >> Filesystem created:       Tue Nov  4 08:56:08 2008
> >> Last mount time:          Thu Aug 18 21:04:22 2022
> >> Last write time:          Thu Aug 18 21:04:22 2022
> >> ---
> >>
> >> So the backups have not been updated since boot-before-last? That
> >> would explain why, when fsck tries to use those backups, it comes up
> >> with funny results.
> >
> > Interesting.
> >
> >> Is this ...as intended, I wonder? Does it also imply that any file
> >> that was written to > aug 18th will be in an indeterminate state? That
> >> would seem to be the implication.
> >
> > Hmm.  I wouldn't have thought so, but maybe the backup blocks don't get
> > updated as often?
> >
> > { I think you are about as far as I would have gotten myself, if I
> > allowed myself to get there. }
> >
> > Phil
>
