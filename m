Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C08BC433F5
	for <linux-raid@archiver.kernel.org>; Thu, 31 Mar 2022 18:14:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233806AbiCaSQc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 31 Mar 2022 14:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231908AbiCaSQc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 31 Mar 2022 14:16:32 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B7F8D691
        for <linux-raid@vger.kernel.org>; Thu, 31 Mar 2022 11:14:44 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-2e5e31c34bfso7261667b3.10
        for <linux-raid@vger.kernel.org>; Thu, 31 Mar 2022 11:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=nbBuWg6h46HY+sJ6bCSIZCOzusnJLxYU43Fog/ZSgzQ=;
        b=HDHuWfbjZMkg4myg7dvjHzJ9dX5eZR3L892CT0RLLqpCWZqfvpA2srF7rIPkuwyKUd
         VeLnLjHVT26f/K16QeoE80/sMzB8oRtR2eBAvDagYfK9USaCJvpmMDe4cWC+UJm6Nlhi
         mG+12ipQbz9lDlXVYHEuliC+1TMOqFJ5Q8ysDH9zC/9GfpXob1vZdVnlIzwlIi99uzZZ
         mHrEYA9fPTszJ/LxPl/EFfam+MlmEOq8Pl0QhMDX/9aujYk+oLD0xdvYQIO4HjnDzmBY
         ef3rjaZBXwHs3o/NPEGDCGrKVXTkzjzshZp8AaUSsHtp0BOghwkG+mFB27Yi2cUm9IXI
         o3gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=nbBuWg6h46HY+sJ6bCSIZCOzusnJLxYU43Fog/ZSgzQ=;
        b=l876/nTTDhIxJWFmrn5vyn+dYNhVtVmwfMuYL+DctrPQsIYrhFIDloUBToOj2Fzgrv
         +s7d4b+0GxpCESeVOhuC74eyMtXK7X3wmcGn9g3zUDT/R2fufdUatrQE3PQp5PW+L40a
         Md64MgpvJi5/Fjo6iAFg734/7RXlcLSTVR1Ng+H9z33H0AYfz7p63Yzqj/nta0fPEPzJ
         omjXyK5G5oLpxx8i6C6jc87/5gHw7CHwfwjTKRGqTKdKjCya9a7MXQsDTKxyzjjTA7CS
         Y3yfy/rt8QDF2TsZG/18nuViT3zZt0YO9l+3Jq0EEkTju7dKxyAaK9EpRApFwML2sjiV
         6Icg==
X-Gm-Message-State: AOAM532IJ15rzkMNUF4vaT+Lo3IibUZ1pLxCIidEv/Hlo2rUvFS70yXg
        lEdkOkDEE346B+yVpgs/iAXwD0Zec0SPjWicejUxPGat
X-Google-Smtp-Source: ABdhPJy5cc6Dtid/P55/qskzBzoWPEHksFNSUtv3unWo+gSKBFZmYArcuiKxnikxHd5mhZbu2TCO91Fqhke9i63iPSU=
X-Received: by 2002:a81:9104:0:b0:2e5:b044:2ac2 with SMTP id
 i4-20020a819104000000b002e5b0442ac2mr6230639ywg.498.1648750483695; Thu, 31
 Mar 2022 11:14:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAKRnqN+_=U58dT5bvgWJ1DgyEuhjsbmCuDL+xOLxmcuG1ML4qg@mail.gmail.com>
 <e3573002-05f3-3110-62a6-e704385f877f@youngman.org.uk>
In-Reply-To: <e3573002-05f3-3110-62a6-e704385f877f@youngman.org.uk>
Reply-To: bruce.korb+reply@gmail.com
From:   Bruce Korb <bruce.korb@gmail.com>
Date:   Thu, 31 Mar 2022 11:14:07 -0700
Message-ID: <CAKRnqNLjsX9nVLrLedo4tfxtg0ZBz=6XJu=-z_Ebw6Auh+oz-Q@mail.gmail.com>
Subject: Re: Trying to rescue a RAID-1 array
To:     Wols Lists <antlists@youngman.org.uk>
Cc:     brucekorbreply <bruce.korb+reply@gmail.com>,
        linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Mar 31, 2022 at 10:06 AM Wols Lists <antlists@youngman.org.uk> wrote:
>
> On 31/03/2022 17:44, Bruce Korb wrote:
> > I moved the two disks from a cleanly shut down system that could not
> > reboot and could not
> > be upgraded to a new OS release. So, I put them in.a new box and did an install.
> > The installation recognized them as a RAID and decided that the
> > partitions needed a
> > new superblock of type RAID-0.
>
> That's worrying, did it really write a superblock?

Yep. That worried me, too. I did the command to show the RAID status of the two
partitions and, sure enough, both partitions were now listed as RAID0.

> > Since these data have never been
> > remounted since the
> > shutdown on the original machine, I am hoping I can change the RAID
> > type and mount it
> > so as to recover my. .ssh and .thunderbird (email) directories. The
> > bulk of the data are
> > backed up (assuming no issues with the full backup of my critical
> > data), but rebuilding
> > and redistributing the .ssh directory would be a particular nuisance.
> >
> > SO: what are my options? I can't find any advice on how to tell mdadm
> > that the RAID-0 partitions
> > really are RAID-1 partitions. Last gasp might be to "mdadm --create"
> > the RAID-1 again, but there's
> > a lot of advice out there saying that it really is the last gasp
> > before giving up. :)
> >
>
> https://raid.wiki.kernel.org/index.php/Asking_for_help

Sorry about that. I have two systems: the one I'm typing on and the one
I am trying to bring up. At the moment, I'm in single user mode building
out a new /home file system. mdadm --create is 15% done after an hour :(.
It'll be mid/late afternoon before /home is rebuilt, mounted and I'll be
able to run display commands on the "old" RAID1 (or 0) partitions.

> Especially lsdrv. That tells us a LOT about your system.

Expect email in about 6 hours or so. :) But openSUSE doesn't know
about any "lsdrv" command. "cat /proc/mdstat" shows /dev/md1 (the
RAID device I'm fretting over) to be active, raid-0 using /dev/sdc1 and sde1.

> What was the filesystem on your raid? Hopefully it's as simple as moving
> the "start of partition", breaking the raid completely, and you can just
> mount the filesystem.

I *think* it was EXT4, but. it might be the XFS one. I think I let it default
and openSUSE appears to prefer the XFS file system for RAID devices.
Definitely one of those two. I built it close to a decade ago, so I'll be moving
the data to the new /home array.

> What really worries me is how and why it both recognised it as a raid,
> then thought it needed to be converted to raid-0. That just sounds wrong
> on so many levels. Did you let it mess with your superblocks? I hope you
> said "don't touch those drives"?

In retrospect, I ought to have left the drives unplugged until the install was
done. The installer saw that they were RAID so it RAID-ed them. Only it
seems to have decided on type 0 over type 1. I wasn't attentive because
I've upgraded Linux so many times and it was "just done correctly" without
having to give it a lot of thought. "If only" I'd thought to back up
email and ssh.
(1.5TB of photos are likely okay.)

Thank you so much for your reply and potentially help :)

Regards, Bruce
