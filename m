Return-Path: <SRS0=H5I/=DN=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2E14C41604
	for <linux-raid@archiver.kernel.org>; Tue,  6 Oct 2020 14:59:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B99F206B5
	for <linux-raid@archiver.kernel.org>; Tue,  6 Oct 2020 14:59:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ITu3ihKW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbgJFO7z (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 6 Oct 2020 10:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbgJFO7y (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 6 Oct 2020 10:59:54 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47829C061755
        for <linux-raid@vger.kernel.org>; Tue,  6 Oct 2020 07:59:54 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id p15so6954620ljj.8
        for <linux-raid@vger.kernel.org>; Tue, 06 Oct 2020 07:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4MaadEzX/qSEzQxtTFTB4WhrW45cA4ng071nqN9WNO4=;
        b=ITu3ihKWKt40nwJDFao5oo8p+a+PnM4yo6VabymvWlEwravo1Vnk6TVqEShpBJl+Fl
         jq/oLqRJO5wuTaFOyDuFzGd8M+Kt5xH3evoEKLLpco/5VXTcte6UbKxwczpRvsxAgPmR
         RqC7N6ivwV4XYSoZSdefsoIul8s6fYJKswywpIu7bOX5+4FkgBL1apF23CX5MnaZq5d9
         m+ywvc9i9wXtYen+seLfrzv8HSG7DCe7v+IPEsK87+R88OT2jX0GFidMP7Ic4vOQcOzY
         zH9YmYvtgtuE6kBcWQwUE4kUbFkCGb1L/hhQ3rj5lFVLadVhj8QMoh6a9kGaECIFPkzJ
         5k5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4MaadEzX/qSEzQxtTFTB4WhrW45cA4ng071nqN9WNO4=;
        b=sQu47fBHxASNMFvOQ+u9wghr6+7fDcGKjhwwp8p4c3DfYSzRMuxlOh2efW9Mzd2iik
         /sByRG2v9pGcr62l4vtItRLSRESidydRGrHJWYk9gkmDFI/WP8mbSoo1WPYuRuvHBCUz
         Dmnh0PzC2ptIXppNf7w1ZmS4KV07ssLdQwtyIJO3E93F0ydeEBVwjrvBo8hFMjCOG07Z
         8WQM6bdIMTkNHXFHNb5Pwj38nhhdnO6qfOvnH+E+ZozfACY0CCoymcHeBk7AF2orN8iJ
         RNZfQfGESUNTrPBSFl2a3h6MHr/096AgYSSDxMCfU2FKq9G/yLlsLu8m679quzdHTvqM
         FHBg==
X-Gm-Message-State: AOAM530FmtniohdTfxDPdkmtIFLnSnT+qlQqaF8sXPkhoQtP5FV64Z2K
        yvlq+6sPkrvbLVkVGJjNVjoAEFUQTpqTqVBcBfKF9HwO8G2cfA==
X-Google-Smtp-Source: ABdhPJyb82CvPUP6Xgh1tZzjnq88oL29OSwPhrbhLwwnr/9bcKARu7xIHasmsIHU8G9N5O4CcrZv1FsWmH7MxAE2Eec=
X-Received: by 2002:a2e:50d:: with SMTP id 13mr1812282ljf.195.1601996391414;
 Tue, 06 Oct 2020 07:59:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAHscji30ACa2d0qz-nr5vqPYOP642dwjS5BY07g2DQS7GBG-2A@mail.gmail.com>
 <20201005184449.54225175@natsu> <CAHscji0pNezf6xCpjWto5-21ayoCeLWm34GTYh5TSgxkOw90mw@mail.gmail.com>
 <20201005190421.4ecd8f1b@natsu> <CAHscji1VrccTOaQc4GdWof4E+Bzs5KL0-tJJj0ZUM9Db=QBriw@mail.gmail.com>
 <CAAMCDedZfx+w3NT_QgB0KGkeEQikCtYVy9YuiNEhNaEjXF1C8w@mail.gmail.com>
 <CAHscji01ikKz4fQ_9i4Tb3AraTD+ZcXBbK-Mm+zY4p3p2qbF4Q@mail.gmail.com>
 <CAAMCDeeRNnoC6mdj7L1PdD5Ztek1tzm++UPi3k=hWvBUA=oLxQ@mail.gmail.com> <5be31543-22ec-dd9f-fd08-d759c4b0df3a@youngman.org.uk>
In-Reply-To: <5be31543-22ec-dd9f-fd08-d759c4b0df3a@youngman.org.uk>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Tue, 6 Oct 2020 09:59:39 -0500
Message-ID: <CAAMCDefj4koi_+g-vdzWpfSB21KLgRq2kJ9sCZK04iX85b_qfw@mail.gmail.com>
Subject: Re: do i need to give up on this setup
To:     antlists <antlists@youngman.org.uk>
Cc:     Daniel Sanabria <sanabria.d@gmail.com>,
        Roman Mamedov <rm@romanrm.net>,
        Linux-RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The controller is crap, and is expected to have serious issues no
matter what drives are on the controller.

Given the green's don't seem to have any reallocated blocks, I am
guessing the controller is 90%+ of the problem, and right now may be
all of the problem.  If you lose all of the disks on the marvell
controller at roughly the same time, that is the controller bug and
not a disk issue.  It also does not seem to be caused by a disk issue,
the controller just seems to have a race condition when multiple
operations are being done at the same time the controller just
"crashes" and stops responding to all drives on that controller.

On Tue, Oct 6, 2020 at 6:29 AM antlists <antlists@youngman.org.uk> wrote:
>
> On 06/10/2020 11:53, Roger Heflin wrote:
> > When the card has an
> > issue all of the ports seem to stop responding to commands.  I am
> > guessing the firmware on the card somehow crashes or gets into some
> > sort of endless loop.  I reported it to marvel, they blamed the OS'es
> > ACHI drivers,even though the AHCI drivers worked perfectly fine with
> > the built in AMD ports.
>
> So we've got the crap drives on the crap controllers ... would it make
> any difference if you put the Greens on the motherboard, and the Caviars
> on the Marvell? Caviars I believe are good quality drives that might
> take enough load off the Marvell to enable it to work sort-of okay ...
>
> Oh - and replace the Greens pretty soon - I don't know how they compare
> against other drives quality-wise, but they are optimised in a raid
> anti-pattern.
>
> Cheers,
> Wol
