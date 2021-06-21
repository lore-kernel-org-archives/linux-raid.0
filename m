Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EE68C48BC2
	for <linux-raid@archiver.kernel.org>; Mon, 21 Jun 2021 16:58:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13B3660C3F
	for <linux-raid@archiver.kernel.org>; Mon, 21 Jun 2021 16:58:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbhFURAV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 21 Jun 2021 13:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233523AbhFURAI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 21 Jun 2021 13:00:08 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1BADC0253A8
        for <linux-raid@vger.kernel.org>; Mon, 21 Jun 2021 09:29:00 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id m3so10938493wms.4
        for <linux-raid@vger.kernel.org>; Mon, 21 Jun 2021 09:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=RDeuyqO50C+1G3iGwqHa+KoifTcTWbA5G9yqzbRlYPs=;
        b=nudmELTkw9kpK7B9bPIJHWucG3QvqnZA/lbYz9oW8AIIbDkklAqviNZRM7gIRt/DkS
         dCha2iGOoR0KSdKQQ9gDjbQCWzEAM8IVZjiOCzpUKgcC6rtNWXz7Bc+J42GnaobL5Jv7
         kGx9jWZKzb5O3Nh3AavIP5N4M0Tz9aUKd4fbpjTg0jfQEAg7+FHukv59dV06NH5talSI
         AB1ziuguDFUz/ZOy2gEvsTZIm9sg99hCSMncpLHRi+SKa2w4lTyVXJheL1u/Ns6UloBy
         C4JG/40g+mqbfD7F8/+G6CGpwYe7mTWg0TA7xScNSgsa2P+AT5KuXdNIGYGSbPL2Nix7
         wjnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=RDeuyqO50C+1G3iGwqHa+KoifTcTWbA5G9yqzbRlYPs=;
        b=Mhjq+d5oZTr62xrNEUNsYUfBR/6h5e2hSeoM/d6O1eEDJN7SpvvAfDaQ4H6JlMrwVi
         wjpSatF5Vrr0NOBy10/INIdTjJc2kWm0eJjUXCzClSkGjQE1VvXQ0LXsCb5CshaqvyxF
         thyxk/ZilmBGArz1n3m7JLvnYI97U5FA/pY5Ig3fVxlFJn9SGw7TPvG27BDZtT8vPggS
         X0nvyPzEYeyfv3WTNDbmJSMGwEFElls84935eXYXrAweiKRsO+fgM2Mi0gX7arGo+3bi
         pR1qmfaOxn8muKuuJ12q1jc4O4sF4tGUkSuGixJShICHlnSD+2UTCHbq55bHmOSeK4bt
         Um8g==
X-Gm-Message-State: AOAM531Ir+74eU1wzX1LbgaVN9TWhVrTFWdvCZt7M5wza2zbON75OtAR
        fGzkFPiwhaZCDchK4lrqSOUPtKr6mekf4MyPGnS0Nj2IjboSRwxV
X-Google-Smtp-Source: ABdhPJwA+cNyLMrJCAl2Udxlq5FYtXhWgy4uGBH+KMNdQib4rAk4a4WfkbcriMGFOwbRibcKmUB907qSAg5MqBEBndM=
X-Received: by 2002:a1c:4d3:: with SMTP id 202mr27940074wme.11.1624292939334;
 Mon, 21 Jun 2021 09:28:59 -0700 (PDT)
MIME-Version: 1.0
References: <CACsGCyRLJ7Lr5rpxUDaNRzZr=s0LjK8wwOENC2RXmNsHvz4HaA@mail.gmail.com>
In-Reply-To: <CACsGCyRLJ7Lr5rpxUDaNRzZr=s0LjK8wwOENC2RXmNsHvz4HaA@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Mon, 21 Jun 2021 10:28:43 -0600
Message-ID: <CAJCQCtQqtnh37hii+4Lb5gN33UWO+fWAcqBPyZJFM9rcp=ztEA@mail.gmail.com>
Subject: Re: How does one enable SCTERC on an NVMe drive (and other install questions)
To:     Linux-RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

> 2) Topic two - RAID on /boot and /boot/efi
>
> It looks like RHEL 8 and clones don't support the installer building
> LVM on top of RAID as they used to.

I haven't tried it more recently in Fedora than a couple of years but
it was putting LVM on mdadm raid, so I'd expect it is too for RHEL 8.
I'm not sure how favoring LVM raid (LVM management and metadata, but
still uses the md kernel driver) is exposed in the installer GUI,
maybe it's just distinguished in kickstart?

>It also
> looks like maybe I cannot use the installer to set up RAID mirroring
> for /boot or /boot/efi.

I'm virtually certain it will create an ESP on mdadm metadata v 0.9
for /boot/efi, at least it used to. And it was discussed at the time
on this list as not a good idea because these are strictly mdadm
member drives, they aren't ESP's until the raid is assembled. So it
leads to discontinuity in the best case. You either have to lie with a
partition type claiming it's an ESP and yet it's really an mdadm
member; or you tell the truth by saying it's an mdadm member but then
possibly the firmware won't read from it because it has the wrong type
guid. And some firmware care about that and others don't.

Further, it's possible for the firmware to write to the ESP. Which in
this case means it modifies a member drive outside of kernel code and
now they mismatch. As long as no further writes happen to either drive
separate or via md, you could do a scrub repair and force the second
drive to match the first. So long as the firmware modified the first
drive, following scrub repair they'd both be properly in sync rather
than regressing to a prior state. But I think this is just damn sloppy
all the way around. The UEFI spec doesn't address syncing ESPs at all.
And so we're left with bad hacks like using software raid rather than
a proper utility that determines which drive has the most recent
changes and syncing them to the other(s), which could be as simple as
an rsync service unit for this task. Or possibly better would be for
the canonical contents of the distro directory that belongs on the
ESP, to actually be in /usr and sync from it as the primary source, to
all the ESPs. Neither /boot nor /boot/efi need to be persistently
mounted. It's just lack of resources and a good design that we keep
these things around all the time. They only need to be mounted when
they're updated. And they don't need to be mounted during boot because
they're used strictly by the firmware to achieve boot.

A better idea would be using x-systemd.automount and
x-systemd.idle-timeout so that it's mounted on demand and unmounted
when idle. Perhaps even better would be an exclusive owner that
handles such things. One idea proposed is bootupd,
https://github.com/coreos/bootupd and it could be enhanced to sync all
the ESPs as well, in multiple disk scenarios.




-- 
Chris Murphy
