Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFF80C433ED
	for <linux-raid@archiver.kernel.org>; Sat,  8 May 2021 01:54:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A83FC60C3E
	for <linux-raid@archiver.kernel.org>; Sat,  8 May 2021 01:54:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbhEHBzS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 7 May 2021 21:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbhEHBzS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 7 May 2021 21:55:18 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E23C061574
        for <linux-raid@vger.kernel.org>; Fri,  7 May 2021 18:54:16 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id g14so12290305edy.6
        for <linux-raid@vger.kernel.org>; Fri, 07 May 2021 18:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=uxvH7YhZLu+ngO2ZBjaLH1jIWm9L9T2JACxk280Itvk=;
        b=aeudOeS4mfbFacTjS2DFknZZXajK+y6M1EeiYWIExuCtzy7fKvNhMthXxZMpkhgjJa
         at54rRuB0CQ7Ty+spNdj1oHhI41yVDpcZjo0u3gigvtSE03tkf0UIu5qyLUa9/QYE/Kj
         PNwVTSC4SMVl622P+apELKCAkuGqjzx86Lg/myOP+RboDIT3ieGPdI3bH/jCytwTHKIi
         TEj76o+6F9VmB2dbRGKuIFyUqUORcsAkW0BIqOlFaIKk6fz7yFTJuncoELPFSQdrHBwx
         Cnngu0ZhUMJ1l5lqdBIhEs2h1QmShzrnrl+ERHaKfAwwN6AyzcOxfK6ISZDSAobYjnTu
         ysZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=uxvH7YhZLu+ngO2ZBjaLH1jIWm9L9T2JACxk280Itvk=;
        b=P4da/t9NGuOpJP4L0fWsyr6UI0RwmaAbnyHRPTF+FhZ8K2h4t5tuChLT07+xgHPx7X
         3n2qr/zYFwX32Wo8N6i5bopxrXETn7cmZ4e2dyHfIKABglxvZI9YkrZEYqpyeCMvapHS
         PmgkDBiBvSnaQAXxxERftVsgqio/JIeWvFVt7omZQgWXpwKvdvtuv6vGyPyAFhCRODQS
         JtHAeM1twms2kSCPPCYDdSeKb+LlUvN0plQN4cyQczuTH1ATzm+yPOgpUi22koPP0RSn
         dQf8qyYC1jqf9Gw+yNFSdn4fqAqoY5/MggiEV+5lCkkHTL4CnTqM/otvURWRoIuxWSLO
         Y5Rg==
X-Gm-Message-State: AOAM533QT9trqPBLKfQ+fSJma6pdl+0hw7i4UI4YWg3CmPePIkss1SWf
        5+WLcFRO0TJ4dKP+Bni5fghS7usYFwXGLGSHXfXeMQlzo1fhdluR
X-Google-Smtp-Source: ABdhPJyigFzsCGV+YdLNmc2SvKDxLdhAFMTFx6RtHUPDHHvlI+376XhAXGBIBePCdHWutfNQfWYjOSNl9p0bEcjwU4A=
X-Received: by 2002:aa7:c7c5:: with SMTP id o5mr15082190eds.31.1620438854981;
 Fri, 07 May 2021 18:54:14 -0700 (PDT)
MIME-Version: 1.0
References: <CAC6SzHJLG=0_URJUsgQshpk-QLh6b8SBJDrfxiNg4wikQw4uyw@mail.gmail.com>
 <8626adeb-696c-7778-2d5e-0718ed6aefdb@redhat.com> <CAC6SzHK1A=4wsbLRaYy9RTFZhda6EZs+2FjuKxahoos_zAd0iw@mail.gmail.com>
 <871rakovki.fsf@vps.thesusis.net> <CAC6SzHKKPCk4fOx7b2CxMWorPghRPMH3GD2v7vcC_YLKbDn7KA@mail.gmail.com>
 <20210507145312.qjrvho4m64s3uz3t@bitfolk.com>
In-Reply-To: <20210507145312.qjrvho4m64s3uz3t@bitfolk.com>
From:   d tbsky <tbskyd@gmail.com>
Date:   Sat, 8 May 2021 09:54:03 +0800
Message-ID: <CAC6SzHL+o6TY_7JhHvdZ52cu5DZySFk4nj84TnHf+p9nOvnp3g@mail.gmail.com>
Subject: Re: raid10 redundancy
To:     list Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Andy Smith <andy@strugglers.net>
> On Fri, May 07, 2021 at 09:47:39AM +0800, d tbsky wrote:
> > I thought someone test the performance of two ssd, raid-1 outperforms
> > all the layout. so maybe under ssd it's not important?
>
> If you're referring to this, which I wrote:
>
>     http://strugglers.net/~andy/blog/2019/06/01/why-linux-raid-10-sometimes-performs-worse-than-raid-1/
>
> then it only matters when the devices have dramatically different
> performance. In that case is was a SATA SSD and an NVMe, but
> probably you could see the same with a rotational HDD and a SATA SSD.
> Also, it was a bug (or rather a missing feature). RAID-10 was
> missing the ability to choose to read from the least loaded device,
> so it's the difference between getting 50% of your reads from the
> much slower device compared to hardly any of them.
> And Guoqing Jiang fixed it 2 years ago.

sorry I didn't find that comprehensive report before. what I saw is
that raid10 and raid1 performance are similar and raid1 is a little
faster.
so I just use raid1 at two disks conditions these years. like the
discussion here
https://www.reddit.com/r/homelab/comments/4pfonh/2_disk_ssd_raid_raid_1_or_10/
I don't know if the situation is the same now. I will try to do my
testing. but I think in theory they are similar under multiple
process.
