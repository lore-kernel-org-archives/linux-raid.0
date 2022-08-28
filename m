Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55D4FECAAD5
	for <linux-raid@archiver.kernel.org>; Sun, 28 Aug 2022 17:34:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiH1Rey (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 28 Aug 2022 13:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiH1Rew (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 28 Aug 2022 13:34:52 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E204C113B
        for <linux-raid@vger.kernel.org>; Sun, 28 Aug 2022 10:34:51 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id z72so4901687iof.12
        for <linux-raid@vger.kernel.org>; Sun, 28 Aug 2022 10:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc;
        bh=WlWOaIDjjk5cPBdvojWEWx6fL3AFY3vnC0IcHHysueU=;
        b=gm+JpD59XsRIn+FIUnhTgfjQwb/09jKmftWtvIDmJQPytqT7pC9BLQhIoMCggG6XUb
         Twhr1Ju8mUlxcfR3KQRYM04KffHmX1uGEgLHaq8qc9J0nPF+vdti9a8lKEZltCua+Qe6
         PaL9YlH7kpkk3RW5G7wkqB8Z49IzQTdtniA+7YoVHxoQrcgzQC0uHMDSAbvwNXCHRwgZ
         AvJ/MuuXbJlx+ZWYM45lssiDbxEooWP4H8Eu0FHyodr8g9QlnPjWuoeVBzZhn0g1Dm96
         UbM5xBY9flnXvO64cLpbepsx0HyAPj+KdKXhhCpIV5ua9IG1pHVX0YkJB+xN5No4r3M7
         D58g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc;
        bh=WlWOaIDjjk5cPBdvojWEWx6fL3AFY3vnC0IcHHysueU=;
        b=B4KrZHMWsmgYIFancA0ZM4qSVjqtEVF0yLq0sMOeXLYNFNZktBbXLEnHW+UkeCrX23
         jEwhyRknSsLOvHuY7gYNcIwIX19AixBvc0Kirmw0M7bUIU0IL/RXrXCPCt2aJhyV+0JM
         tD+osEmMFeaKvcKHnlzVhulyhWnvqwRTubnk5lHqqkombeFszjqv8jOLu0p7XROaG2c0
         yFSNNaxLjeWmHaCZ1yq1sO/h7LGPQpa7BqIAt7MND3vx5qhJ3lWYNasQabn9lrm0cSGh
         glDvDopFuob0YLbAvt+Hqsc+KtcmsgczYletrxTeeqVGYWnupZ5bb2IEFvrdXGLHeRXp
         Ci9A==
X-Gm-Message-State: ACgBeo0S0Pbj3ZUElGTnvMMlB8kxGX+ThkxJ813JZFLX/5ISkHXvgjZe
        8g7JDh91Nxz5lhKXEdw5+GH3+ckJXVLJZocEAVZSom6YwA==
X-Google-Smtp-Source: AA6agR7ZiGhbZlEn7UU0+WILLhzbtPmuCrAgi6F0xakKMW7s9F90j2O3kJIU0bbwcFFDPgafCXStwO6pTh/cCo9xFW4=
X-Received: by 2002:a05:6602:2ac9:b0:68b:2630:9669 with SMTP id
 m9-20020a0566022ac900b0068b26309669mr3889898iov.188.1661708091034; Sun, 28
 Aug 2022 10:34:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAKAPSkJLd836Zp3xU=zSOHg3qcEmi29Y2qOwWzeAFaDp+dNTvg@mail.gmail.com>
 <20220828171156.56iqcps7z6hvzarp@bitfolk.com> <20220828172211.bugbzc5xv3bkp72o@bitfolk.com>
In-Reply-To: <20220828172211.bugbzc5xv3bkp72o@bitfolk.com>
From:   Peter Sanders <plsander@gmail.com>
Date:   Sun, 28 Aug 2022 13:34:40 -0400
Message-ID: <CAKAPSkJP=_nrEcELZAi8U5=_DiOXvSTADDNU1GKkZ8ySdkV5nQ@mail.gmail.com>
Subject: Re: RAID 6, 6 device array - all devices lost superblock
To:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

It was set up on the device level, not partitions.  (I remember
getting some advice on the web that device was better than
partition... Yay for internet advice)

I'm surveying my other disks to see what I have available to do the
overlay attempt.

What are the size of the overlay files going to end up being?

I did run into UEFI vs AHCI issues early in the process.. they are all
set to non-UEFI.

OS update was onto a new SSD...

On Sun, Aug 28, 2022 at 1:23 PM Andy Smith <andy@strugglers.net> wrote:
>
> On Sun, Aug 28, 2022 at 05:11:56PM +0000, Andy Smith wrote:
> > I'm wondering if this is one of those motherboards that at boot
> > helpfully writes a new empty GPT
>
> Sorry, all the other replies speculating the same have just arrived
> in my inbox!
