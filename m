Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 492E6C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 16 Nov 2021 08:36:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B7656152B
	for <linux-raid@archiver.kernel.org>; Tue, 16 Nov 2021 08:36:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbhKPIjC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 16 Nov 2021 03:39:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31279 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232339AbhKPIi7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Tue, 16 Nov 2021 03:38:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637051759;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/X7I9HowBs17FvxDzQCLVR01Om7FlX99H34awOmINek=;
        b=jR8Y91lSWjVAqshC+YKcFKXRRh6cAMOPVDcx+jd6mig/2CTk+RyCF27eAJbIG77VdGMGuV
        A4XmqhC9Cj3WaGskqKJzqUEfha4S9GKBIJebkh+BbOetHYJw6FZPzktRyVmEVHTKlIHNKL
        RNSrQVSi3ec/jUTOXOrerIjbxFEkmy4=
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com
 [209.85.221.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-476-0WIOIrF5OoO5b_aeZdmEAw-1; Tue, 16 Nov 2021 03:35:58 -0500
X-MC-Unique: 0WIOIrF5OoO5b_aeZdmEAw-1
Received: by mail-vk1-f199.google.com with SMTP id m25-20020a056122215900b002fac70f81c1so7852252vkd.5
        for <linux-raid@vger.kernel.org>; Tue, 16 Nov 2021 00:35:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/X7I9HowBs17FvxDzQCLVR01Om7FlX99H34awOmINek=;
        b=0paxlN3DhHUJot70T02PS2VCICpD/3Yl2sduD4L+Lfoon9VQyi7S1mm/BojBWmfrvI
         nlgaerNN//RXC70E9NeQYqfCJS3KjEiEWiJpyxeTCjOWFEAsKQ1ZGzlr9qc9MlHCSPEQ
         0onNfr/LOtfOg1kd+T239ZH+Hps6sM5B6Nuxq+6KEmoJKhlm3NkeHAJ92zFgqVZp8vZN
         heJrfOALgS5npDwTOUG6ekYRylZ+OO8U9PtMt/uRsmXMdtaKq7ECWcK1FpeVscChswN4
         aiLsotCXomh4yC6dZg1+oIqyEr6IXPNukdaeNRGz4jZ6wO/YAI9AJxSeCLmZ+V4xYS6G
         xEBg==
X-Gm-Message-State: AOAM531nri/KUZpbZL94B0k+ot9qWJzzrlOUuGB//hA17R8smzBmu19Y
        uBqT/2yzqZ0v0EzUU3nmvhbdNLlWV5adHAMdGpvtYLZUpx3R1TVwZ/5TnPemal7umKgXmKXg/FZ
        KmmL1999+MpGkWvYn+ziwOM2gpy2tcGMRtuOxGw==
X-Received: by 2002:a05:6102:356e:: with SMTP id bh14mr53288537vsb.21.1637051757654;
        Tue, 16 Nov 2021 00:35:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx0FJ/XsXgRBp0ve51BXW9ApIh+0xtUmWZjE0EzXX0kU1KsLT+fXjq9XmHKYhAZt2msekQ5BuKX7i2bBGCNod8=
X-Received: by 2002:a05:6102:356e:: with SMTP id bh14mr53288502vsb.21.1637051757431;
 Tue, 16 Nov 2021 00:35:57 -0800 (PST)
MIME-Version: 1.0
References: <20211112142822.813606-1-markus@hochholdinger.net>
 <CALTww28689G2xbZ9sWFpviXLwB1WKPfQL6Y1girjiBMEvWcQRw@mail.gmail.com>
 <181899007.qP1mJhO4kW@enterprise> <afc770b3-3ded-5ff3-6794-263165fe8343@youngman.org.uk>
In-Reply-To: <afc770b3-3ded-5ff3-6794-263165fe8343@youngman.org.uk>
From:   Xiao Ni <xni@redhat.com>
Date:   Tue, 16 Nov 2021 16:35:45 +0800
Message-ID: <CALTww2-0dAftGm5YkpwORgYDk5FZ5FmRdLqzB-NO3tWsePv=ig@mail.gmail.com>
Subject: Re: [PATCH] md: fix update super 1.0 on rdev size change
To:     Wol <antlists@youngman.org.uk>
Cc:     Markus Hochholdinger <Markus@hochholdinger.net>,
        Song Liu <song@kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Nov 16, 2021 at 4:07 AM Wol <antlists@youngman.org.uk> wrote:
>
> On 15/11/2021 18:39, Markus Hochholdinger wrote:
> > (Because of other reasons, we have intentionally choosen the superblock at the
> > end of the device.)
> >
> > We change the device size of raid1 arrays, which are inside a VM, on a regular
> > basis. And afterwards we grow the raid1 while the raid1 is online. Therefore,
> > the superblock has to be moved.
>
> A perfect example of this (although I can't see myself growing the
> partitions in this case) is a mirrored /boot.
>
> Superblock 1.0 means that anything can read the partition without
> needing to know about raid. One less thing to go wrong. And I can raid-1
> an EFI partition - I just need to make sure I only modify it from within
> linux so it gets mirrored across both drives. I would want that as
> protection against my primary drive failing - then my EFI partition is
> mirrored letting me boot from the secondary.

Hi Wol

Thanks for the case. If I understand right, this is a case of using
super1.0 right?
Because before boot, it can't know this is a raid device. So it can't read data
if the raid is created with superblock 1.1 and 1.2. Only super1.0 can be used,
Because the data is stored at start of member disk when using super1.0. The
system can read partition table even they don't know it's a raid device leg.

Regards
Xiao

