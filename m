Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D15B3ECAAD3
	for <linux-raid@archiver.kernel.org>; Sat, 10 Sep 2022 20:55:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiIJUy6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 10 Sep 2022 16:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiIJUy4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 10 Sep 2022 16:54:56 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BFF425C58
        for <linux-raid@vger.kernel.org>; Sat, 10 Sep 2022 13:54:54 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id q3so4529621pjg.3
        for <linux-raid@vger.kernel.org>; Sat, 10 Sep 2022 13:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=tqCPlufKer4kZILtiYDtRnV8oeQwTeozJApZ7JZ5Zyg=;
        b=EShNCdxs8bMSWlFAPjeOAx9WldJ2iJezVf9QO81Tp0uCnyrqr2D3al00WTklgFdWjy
         569aZr3JV+5KNF74IjL70emlF4KhGGr8R3NMSigHnrfVaUJOK5GvD62h4PlS70vWO3Zn
         Qw0asj959DvNFY1C3bK0XA7SotqgAZxHicCnzW/ckdZKsA7pivTJ9IS8rYTf6nK/ao5V
         yMiTLN/IAnYfySfNEVhlJS8OxxN3aniVy67ZGI6nZhx6PIJ9swv/x5h1GKllOgzzNsH0
         v8T211kFUxnJl03kCKDuBqcS+3IoGFCKWNR1ee+h9jbiakX5TjSxKNjpT7+aGONsCMwn
         ah/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=tqCPlufKer4kZILtiYDtRnV8oeQwTeozJApZ7JZ5Zyg=;
        b=lWvf3Bng7TMB0Xa4KTw/cwzjpsi96ePndLLCCb8xw8i/D7AA27R2ih/QGSwscIpohD
         Adngy8RM9MZAY6DfmMn6FZz7e5STqY4vCxxo6uWM3IRhDca64mrLRBY1qkotae6RA6gr
         2pD/IqFTCtWAnQc7/0U1RPM97tvAiQS4KIElkWwrJC4FXGKneYPerhzf/K4Wa7EMcG75
         gJ5zlIQNHSuiD8YCkCnmOG4U/hbBjiUVxHOZ7/MGNPEKIvEEZrGjM0tBDl1/n072//NS
         c06SECCslaa6tN18d+apBkw/uV1Ikw/k7klwgbatpaJoHQB6N25/PHX0Y+t7Iz5htC8z
         X3LA==
X-Gm-Message-State: ACgBeo3Vq9wHk1AfmdGllAIIHQ+ryxBaluLa8VPgbiAHK43xvKw6nWcK
        4/1D0Fw9dyN6uf35yBvD4b0/ylX3JnnTkHep51OXTA7M
X-Google-Smtp-Source: AA6agR6FFzc5l/itNDHAKWu60SE0/Am82nMhC8tH8BKLVWBhrZ/YnmhDMat60M7g2+5D5FPh9YPP+4rcW8SyRNBqxls=
X-Received: by 2002:a17:90a:5b0d:b0:1fe:3769:5fb8 with SMTP id
 o13-20020a17090a5b0d00b001fe37695fb8mr16732992pji.152.1662843294017; Sat, 10
 Sep 2022 13:54:54 -0700 (PDT)
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
 <CAJJqR23NrYqeZ2HqgJUEAvoVZv1qk6u2oGWOUYzLYRgQxgvW=w@mail.gmail.com>
In-Reply-To: <CAJJqR23NrYqeZ2HqgJUEAvoVZv1qk6u2oGWOUYzLYRgQxgvW=w@mail.gmail.com>
From:   Luigi Fabio <luigi.fabio@gmail.com>
Date:   Sat, 10 Sep 2022 16:54:12 -0400
Message-ID: <CAJJqR20pzcycF3Vf77K1iscmydRe_BEXRO-SqOsARStGuKZh+A@mail.gmail.com>
Subject: Re: RAID5 failure and consequent ext4 problems
To:     Phil Turmel <philip@turmel.org>
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I will be very, very brief: it works.

I put on the overlay, did the first fsck which said it would try the
backup blocks and then complained about not benign able to set
superblock flags and stopped.

At that point, since it said that the FS was modified I assumed that
it had overwritten the block descriptors that were damaged. I tried
mounting -o ro the filesystem without touching it further and... it
works. The files are there, including the newest ones, directory
connectivity is correct as far as several tests can tell....

Of course, I will treat it as a 'damaged' fs, get the files off of
there into a new array, then try the further fsck and see what happens
for curiosity's sake but as far as I am concerned this arrya is no
longer going to be live.

Which is just fine, I got, I believe, what I wanted.

Thank you very much for all your help - I plan to provide a final
update once the copy is done etc.

Let me know where to send scotch. Much deserved.

L

On Sat, Sep 10, 2022 at 4:24 PM Luigi Fabio <luigi.fabio@gmail.com> wrote:
>
> Phil,
> I did indeed go there, but, stupidly, after the fact and I had missed
> the reference to your tool. Not an excuse, but the initial part of the
> process was, as I mentioned, complicated and done while driving....
>
> I'll download lsdrv and snapshot the situation in any case, generate
> the overlay, run the fsck and see what happens.
>
> I'll report back when it's done, which is probably going to be
> tomorrow (fsck times for this filesystem historically have been in the
> 9+ hr range - and the overlay will probably do us no favours
> performancewise).
>
> Back as soon as I have further data. Thank you again for the help.
>
> L
>
> On Sat, Sep 10, 2022 at 4:17 PM Phil Turmel <philip@turmel.org> wrote:
> >
> > Oh, one more thing:
> >
> > If you had followed any of the advice on the linux-raid wiki, you'd have
> > been pointed to my lsdrv project on github:
> >
> > https://github.com/pturmel/lsdrv
> >
> > (Still just python2, sorry.)
> >
> >
> > On 9/10/22 16:14, Phil Turmel wrote:
> > > Hi Luigi,
> > >
> > >
> > > On 9/10/22 15:55, Luigi Fabio wrote:
> > >> Well, I found SOMETHING of decided interest: when I run dumpe2fs with
> > >> any backup superblock, this happens:
> > >>
> > >> ---
> > >> Filesystem created:       Tue Nov  4 08:56:08 2008
> > >> Last mount time:          Thu Aug 18 21:04:22 2022
> > >> Last write time:          Thu Aug 18 21:04:22 2022
> > >> ---
> > >>
> > >> So the backups have not been updated since boot-before-last? That
> > >> would explain why, when fsck tries to use those backups, it comes up
> > >> with funny results.
> > >
> > > Interesting.
> > >
> > >> Is this ...as intended, I wonder? Does it also imply that any file
> > >> that was written to > aug 18th will be in an indeterminate state? That
> > >> would seem to be the implication.
> > >
> > > Hmm.  I wouldn't have thought so, but maybe the backup blocks don't get
> > > updated as often?
> > >
> > > { I think you are about as far as I would have gotten myself, if I
> > > allowed myself to get there. }
> > >
> > > Phil
> >
