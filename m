Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A751FC433B4
	for <linux-raid@archiver.kernel.org>; Thu, 22 Apr 2021 05:59:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 634FD61453
	for <linux-raid@archiver.kernel.org>; Thu, 22 Apr 2021 05:59:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhDVF7j (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 22 Apr 2021 01:59:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:57204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229533AbhDVF7h (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 22 Apr 2021 01:59:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3638261450
        for <linux-raid@vger.kernel.org>; Thu, 22 Apr 2021 05:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619071143;
        bh=atKdAuQIzBiFzt380T/lFskm5tmVtsCijMdp/lMmK+U=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=HVOJSJIeEq1hGYtx155IRWLgkGQGJ2Z/CVDYw8l8UG3hBAB1xdJ/r/xZBlaS+npAy
         lV8jystYIuk7han8ty9CTMp8sqZLrH/aLNqG19alUVDYXLztQ6kwDwIkyKVdyfM+YK
         BKLBNpezW+0k6f0/pUFd+hEFcKQ2VDiEVyo5CYPCKTtc1r87v8fZIA1pjrfxjZx15b
         +bSZrxTnt/Gl4cWDHH8aTV9Tmm8ZNt3imLRDIFyVBjcap6v9KaqjhOEsT/59NeLsSK
         6fuDC+ifJjUPRcQ8bO/wyysGWsvXJyj+jQ7JVKFyggD0odcUSZms+pfO5qykCFhK9G
         hR+VcN4ducpCQ==
Received: by mail-lj1-f179.google.com with SMTP id a1so50462504ljp.2
        for <linux-raid@vger.kernel.org>; Wed, 21 Apr 2021 22:59:03 -0700 (PDT)
X-Gm-Message-State: AOAM531AP3EdWCb4nNfU20n23q8gvaJfTLyfELdLaBEsCd/TB5A1bRXp
        soXlWTXE5Hgus1ZidCurnFQcTt+3e36JLQY/jKQ=
X-Google-Smtp-Source: ABdhPJzuB+l4WRYSCliXJH5/WBvciDAMsima73zpaQHNyrZa88vU5V68qBEFs6Eppg7sktZND9Z31EpV/qQJTDzxlFg=
X-Received: by 2002:a2e:a379:: with SMTP id i25mr1329137ljn.344.1619071141454;
 Wed, 21 Apr 2021 22:59:01 -0700 (PDT)
MIME-Version: 1.0
References: <607f4fd0.1c69fb81.9f7e7.05ef@mx.google.com> <CAPhsuW4qW_mMfQuf3efn18AAt4xHQz25+YKjuynwDzzDYLY=Pw@mail.gmail.com>
 <CAECXXi6iaOStikDmNpzEx+Urd_Y8xvyNEVNQitFr4p0nxtBCxg@mail.gmail.com>
In-Reply-To: <CAECXXi6iaOStikDmNpzEx+Urd_Y8xvyNEVNQitFr4p0nxtBCxg@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 21 Apr 2021 22:58:50 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4GAUrh4=59TMWs7fedH-pHpxiTH1F2X5PwxjPYdm7FHg@mail.gmail.com>
Message-ID: <CAPhsuW4GAUrh4=59TMWs7fedH-pHpxiTH1F2X5PwxjPYdm7FHg@mail.gmail.com>
Subject: Re: [PATCH] md/raid1: properly indicate failure when ending a failed
 write request
To:     Paul Clements <paul.clements@us.sios.com>,
        Yufen Yu <yuyufen@huawei.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Apr 21, 2021 at 10:38 AM Paul Clements
<paul.clements@us.sios.com> wrote:
>
> On Tue, Apr 20, 2021, 7:49 PM Song Liu <song@kernel.org> wrote:
> > On Tue, Apr 20, 2021 at 3:05 PM Paul Clements <paul.clements@us.sios.com> wrote:
> > >
> > > This patch addresses a data corruption bug in raid1 arrays using bitmaps.
> > > Without this fix, the bitmap bits for the failed I/O end up being cleared.
> >
> > I think this only happens when we re-add a faulty drive?
>
> Yes, the bitmap gets cleared when the disk is marked faulty or a write
> error occurs. Then when the disk is re-added, the bitmap-based resync
> is, of course, not accurate.
>
> Is there another way to deal with a transient, transport-based error,
> other than this?
>
> For instance, I'm using nbd as one of the mirror legs. In that case,
> assuming the failures that lead to the device being marked faulty are
> just transport/network issues, then we want the resync to be able to
> correctly deal with this. It has always worked this way since a long
> time ago. There was a fairly recent commit
> (eeba6809d8d58908b5ed1b5ceb5fcb09a98a7cad) that re-arranged the code
> (previously all write failures were retried via flagging with
> R1BIO_WriteError).

So I guess we need "Fixes eeba6809d8d589"?

CC Yufen, who authored the above patch.

>
> Does the patch present a problem in some other scenario?

I don't think this presents any problem.

Applied to md-next. (so no need to resend for the Fix tag).

Thanks,
Song
