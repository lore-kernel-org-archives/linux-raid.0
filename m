Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD392C64E7A
	for <linux-raid@archiver.kernel.org>; Tue,  1 Dec 2020 13:02:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47D5F207FF
	for <linux-raid@archiver.kernel.org>; Tue,  1 Dec 2020 13:02:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hnTws+4A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389958AbgLANCR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 1 Dec 2020 08:02:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbgLANCR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 1 Dec 2020 08:02:17 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16DF4C0613CF
        for <linux-raid@vger.kernel.org>; Tue,  1 Dec 2020 05:01:37 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id j205so3952576lfj.6
        for <linux-raid@vger.kernel.org>; Tue, 01 Dec 2020 05:01:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EDNiKqYcGRWQjGa/WLyfsDHmk+zBidEvXqZsXCRD2aM=;
        b=hnTws+4A1ACtxPH1uQMqhNLwfw+u57uoD8CQCCVZTBvcDiSmF+UfhxFNguL9qpOksr
         uKt7n5JqD/vFtqRPt2lLqFekbHBpio+x3xdxI6gzLrUu8y4tRwLXUlP+lFHUgnQOBDwB
         PsEuXPd92m1aN8m5xs7++zOJNYYnDAN11MKW7nIBC6cQCmoJbVdMFwXlep6NrrZ8t4cw
         sXFAp1SIxx9po44Z7XgGQgf/ZmLQaprcyBQFxmI9/IRQu8V+0+uqVkQ6NVLHy1p1Pm/5
         Qhptfib0LEL/idch8hu6ayeIfEPQEVTPOh+JKbEZzFMRTbzW2NPwvdvk/9OEIg0FyWr2
         AutQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EDNiKqYcGRWQjGa/WLyfsDHmk+zBidEvXqZsXCRD2aM=;
        b=s/mZtoKSYbPYb0w5mTWAhFKc1Tf5IfjsCljFOG8enYyeKzoPKg/+x0cH8lixSi7rnL
         YFTApw2WgUzSH3G2gTuoZSZXoBqyhd02lr5/2N1qt2Ph/O0532lWH8J3Q5StbOSMFqVN
         9fkExBCliyRM0R3CX8afzf6erOORnUZWLFhFyf8QsOX4y5pqQN1b2wKx2R8Q/s+sklVk
         MAYOyDDWbhN4efAUvsn6taMWL4nkFf8OdQSiQgvLM76ORL02vRa0HaKjLwoL6LSGqwKQ
         HJQOc/Zp5QSre9Lzxr96PqnBc+vYyP1QGx3GOVRJN39s87kDXK5+/vz4KD9tgEJrPFir
         ON5A==
X-Gm-Message-State: AOAM533vqLiDa+XLFlx1XuETpW+u01GvISBW7Dksajhf6GfJbrftTjXU
        ppHF/AWiLSicP2BLpfExev0wSXjGyEFWJotJduY=
X-Google-Smtp-Source: ABdhPJwHyLj2B8/NLAn4ReJDbZ0uhXy6tjCPP0l6Wvv7sqs77vI9NTlN4iTs3Z9sQmYuq/TyKfAZgjR6N47odXyD0QE=
X-Received: by 2002:a19:c705:: with SMTP id x5mr1206793lff.16.1606827694573;
 Tue, 01 Dec 2020 05:01:34 -0800 (PST)
MIME-Version: 1.0
References: <CAJH6TXjsg+OE5rUpK+RqeFJRxBiZJ94ToOdUD5ajjwXzYft9Vw@mail.gmail.com>
 <CAJH6TXgED_UGRcLNVU+-1p8BVMapJkRmvZMndLYAKjX_j6f7iw@mail.gmail.com> <5FC62A4F.9000100@youngman.org.uk>
In-Reply-To: <5FC62A4F.9000100@youngman.org.uk>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Tue, 1 Dec 2020 07:01:23 -0600
Message-ID: <CAAMCDefErBEP22cVqLNO3P1fGpXkih=9nFW1OMVQZEAorgB88Q@mail.gmail.com>
Subject: Re: Fwd: [OT][X-POST] RAID-6 hw rebuild speed
To:     Wols Lists <antlists@youngman.org.uk>
Cc:     Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>,
        "General discussion - ask questions, receive answers and advice from
        other ZFS users" <zfs-discuss@list.zfsonlinux.org>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

You would need to look at the rate that data passes under the head on
the 2 disks, if the disks are several generations apart then rate
could be significantly different.

If the new disk has higher density platters than the old disk then the
data rate will be higher just because of the higher density and when
you add in the rpm changes that adds even more.   On most disks data
sheet it will list the rate that bits pass under the head, so compare
that between the 2 disks.

So what is the model of each disk and how big is the partition used
for the array on each of the 8 disks?

On Tue, Dec 1, 2020 at 5:37 AM Wols Lists <antlists@youngman.org.uk> wrote:
>
> On 01/12/20 09:57, Gandalf Corvotempesta wrote:
> > Sorry for the OT and X-POST but these 2 lists are full of skilled
> > storage engineer.
> > For a very,very,very,very long time I used 15k SAS 3.5'' disks. A
> > RAID-6 hardware (8 disks) took about 20 hours to rebuild.
> >
> > Now I've replaced a 3.5 disks with a 15k SAS 2.5'' disk. raid is
> > rebuilding properly, but the ETA is less then 1 hours.
> >
> > I've moved from a 20 hours rebuild to about 50 minutes rebuild, by
> > just changing one 3.5' disks with a 2.5'
> >
> > Is this normal ? I'm thinking something strange is happening
> >
> Your rebuild time is effectively the time it takes to write to the new
> disk. So I'm guessing if you had to wipe and rebuild one of the old
> disks it would again be 20 hours. So what's different about the new disk?
>
> Yes I know it's a 2.5". But could it be it's SATA-3 as opposed to the
> old ones being SATA-2? There's a whole bunch of things it could be.
>
> But my money's on it having a bigger cache. The ETA is based on how fast
> it can read from the existing array and the rebuild hasn't yet filled
> the cache. Once that fills up and the disk write speed kicks in, the ETA
> will start climbing fast as the write speed starts dominating the ETA.
> That said, it'll probably be faster than the old 20hrs, but I don't know
> by how much.
>
> Cheers,
> Wol
