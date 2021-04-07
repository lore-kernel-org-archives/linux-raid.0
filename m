Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 855EDC433B4
	for <linux-raid@archiver.kernel.org>; Wed,  7 Apr 2021 20:15:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58510611C9
	for <linux-raid@archiver.kernel.org>; Wed,  7 Apr 2021 20:15:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355992AbhDGUPL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 7 Apr 2021 16:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356000AbhDGUPL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 7 Apr 2021 16:15:11 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B7E0C061760
        for <linux-raid@vger.kernel.org>; Wed,  7 Apr 2021 13:15:01 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id d5-20020a17090a2a45b029014d934553c4so1096061pjg.1
        for <linux-raid@vger.kernel.org>; Wed, 07 Apr 2021 13:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=tpQt+97tUpg77hQIt/7xETM6NN8ilbA/x35rrjA/Txg=;
        b=DtLA86dFuexXq9SCHR8cKjps6K3JYV/tEnOPjm5/EPM7DbmBNVi7hh9jeray+8x/H6
         IxrysSRbIPUxo6qVRXfQZNFuDh2GsCFOlg7VvOmaO9vBoVCBYdw5DkYnXPcm+ROBrvK4
         UvrYP1IIRCujA7qiWkzokLTtUXEb22v7hfqrJTPi9DQXC+Nl7eiJ6pnEqMSM0oh8M0dX
         LqYaekJASvliZT+1zxddM0qM0DH6qjV2h1ijky/M3JBxmEMv31vtLrTfmbg1CMDDGquS
         cz4dAPR9qvof7hSozdGm4mQHlQHy9/1BegTEp51C45VRMu2lWdRCfuFKHRcZf12ZVCzW
         +aOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=tpQt+97tUpg77hQIt/7xETM6NN8ilbA/x35rrjA/Txg=;
        b=fRfdiZFreiEZRBfNpmJhfEa/3+OsPoRJSvke9koh+6wmO7uS0JKppmdLbJZgWAxlFR
         MI5+KYJefEEXsUWXEv6lgv6jYd7TMqSPpfs+aCP3eLZPBCWoR8XyFtmLQkKrHyyxaRWB
         KjW/ay5S6wR8v0Mjy/fIuJRo6bqT+VsUIbYDmGGQ7CCXpv1Pl9KzDUkvRpzZ36rDlXTH
         1mQf/vVHXwMpTtSdkgAffBtWbsOc8fFgCQ95boGY7hz8lLnU2KJO3bkU24PWTCn3nz+d
         ukU6XMpzcpIL0fBIom+9bwLD0mIyZFTe3qFqCfxOPCuxOsT3Z3SfoRbRm5oe8HivpxAF
         MQ2g==
X-Gm-Message-State: AOAM5305dIdj5XAbYxm8sicmHxu9KRII6LgeDdb2ldNQlkL9aDePztGO
        DrAE+dmz7/AETLaiO9to3P+tfLe7InQeE/il0Vku9sbY
X-Google-Smtp-Source: ABdhPJyX8Wlwvg4fzYDhoJZnc4oDWPpkte5/KiTLE9veSCEYSV7kBraU8vckZLsPyDGq+KXOrWvoPlX843JpxKMK7bc=
X-Received: by 2002:a17:90a:7444:: with SMTP id o4mr4937122pjk.205.1617826500557;
 Wed, 07 Apr 2021 13:15:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210328021210.GA1415@justpickone.org> <20210402004001.GH1711@justpickone.org>
 <62cc89ea-b9cf-d8a3-3d52-499fd84f7cc3@youngman.org.uk> <20210402050554.GF1415@justpickone.org>
 <CAAMCDecNM8X9tdWo-WKpQA3BE=_J=XKc1D75rcQiQN0owZ9kJQ@mail.gmail.com>
 <20210405034659.GG1415@justpickone.org> <CAAMCDecX3nawcYC4hFX+VjQTiHPaZDUb1RcM66=OBFoxhLwY4Q@mail.gmail.com>
 <5f58e78d-8d8c-c66c-7674-79832e22f200@youngman.org.uk> <20210405174649.GH1415@justpickone.org>
 <583e250c-09f2-6c95-c62a-623e29cf0179@youngman.org.uk>
In-Reply-To: <583e250c-09f2-6c95-c62a-623e29cf0179@youngman.org.uk>
From:   Mark Wagner <carnildo@gmail.com>
Date:   Wed, 7 Apr 2021 13:14:49 -0700
Message-ID: <CAA04aRSf1ZDz_bHRsV6hRvZEV09B+G7JGfQ3uv4psET-_593xA@mail.gmail.com>
Subject: Re: bitmaps on xfs
To:     Linux RAID list <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Apr 6, 2021 at 12:14 AM antlists <antlists@youngman.org.uk> wrote:

> (I don't understand it, but if a system crashes in the middle
> of a raid-5 write it can apparently mess things up something horrid).

Short version is that the disks making up a RAID stripe don't always
get written simultaneously.  If things crash just wrong, you can get
half the stripe with old data, half the stripe with new data, and no
way to tell which is which.  A journal fixes this by writing the data
twice: first to the journal, then to the array.  If the system crashes
while writing to the journal, you've still got the entire old data on
the array; if it crashes while writing to the array, you've got the
entire new data on the journal.  You're never in an inconsistent
half-and-half situation.

-- 
Mark
