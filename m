Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 672A1C433EF
	for <linux-raid@archiver.kernel.org>; Thu, 13 Jan 2022 18:26:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237497AbiAMS0c (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 13 Jan 2022 13:26:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbiAMS0a (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 13 Jan 2022 13:26:30 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91723C061574
        for <linux-raid@vger.kernel.org>; Thu, 13 Jan 2022 10:26:30 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id g21so7982069qtk.4
        for <linux-raid@vger.kernel.org>; Thu, 13 Jan 2022 10:26:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mz3czsmSt/uFmzPK+E3Q4l0kS97mT5PE0w/eo8OdQDw=;
        b=gP1DIhRnfrwOcIOpAxbj1ujMzXx/Jpg86ad/+5XXbvd4vTZ1DB/IRtMkp1Mk+qfUKn
         qTBLS0J1mKWATPtDW7ctluukzes6U7byZP7CG2OjL9E30p79D3qkwqYY7OSDVUVGxAQF
         +flFl33J3gX8QYC+fTCk07VvdyEeTyb9TvzMETmWGayETmxFeZwozebEs8Pf/CBQe7EV
         ZPnqy4Aw2FJ6mRKd8OvmBxHn/wx//ORq0pvpQWf6+Qj3f6fOZzLtsln5qJAr0IFGy+Yn
         kfWDN+nmv8a+9US6DA+m+//0L0ugqpNYEaToZLP85PO1M59pkqYcEv+fzkXWj/TTHzf4
         ps9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mz3czsmSt/uFmzPK+E3Q4l0kS97mT5PE0w/eo8OdQDw=;
        b=Zf1h9HuQzhbBTr3Ln3OyMWUXu4CIGqfCYMcg/+SWY/bhg4UCOZ+WAIbYSDwRS5EHFq
         hRo4R3Us7ZYokSGmI4VYhy0OkVDwyhzxyUDiY5Jp7CXl5C11dsQJ2XXdOjZm/ofYugPc
         +684cQnibnNzmt+HdWTX5LsgWCbf00ggt+gV9ZyjHrLRiYBG/P1w+60hwCcF0zOFabJ+
         eOcvmmWb9s/iGB+XJlErii40+WBTTCL04U2lBQ+nyLuOT2QhOK7yUHyxkQMDUO7DSXn9
         0q8ltf18opxPz32xLXRhp/EsnmhSUZYQjwNLzc34x2quCTWuHQKjQttvfxHPLdRlkKyP
         xcIw==
X-Gm-Message-State: AOAM532+l+m/uEZ0xocijJuWNl5aTtVDaAWtpapnSCIVV9GAYI1lCpwd
        yeTzFO15UkLswWzX4UngS24tRtQdVDyK5tTlUFc=
X-Google-Smtp-Source: ABdhPJx/XErSA1gGiM3Fb4JkplPA7e3JBCB09tWaBYdIcNpm8O5exVv/M9w5HCxcxwhLINaMFwALN+0AwNI+cdM9DrU=
X-Received: by 2002:a05:622a:1a14:: with SMTP id f20mr3060008qtb.175.1642098389661;
 Thu, 13 Jan 2022 10:26:29 -0800 (PST)
MIME-Version: 1.0
References: <CAPx-8MP0+C9M9ysigF-gfaUBE8nv7nzbm4HO06yC_z5i3U3D=Q@mail.gmail.com>
 <20220110104733.00001048@linux.intel.com> <CAPx-8MNa97Aokgz8RzfiGEPXFLpzbGduNV9hUOYdGXRmfxSg3g@mail.gmail.com>
 <CAAMCDecViLw=V_nFgJicLa=nDoADScpwg_pfWF2ubF5D=aCsaA@mail.gmail.com>
 <CAPx-8MNgtVuUgdOBsZiQyXmS=nCoj255D+oNrkGOcsNVhixC3g@mail.gmail.com>
 <c94d975f-78d0-259f-bca2-a7b74c55f2a6@sotapeli.fi> <CAPx-8MNO0WaT8j4seOdfoDKoiP=zjo-qkSmFf+ENbxiAAuFrDQ@mail.gmail.com>
In-Reply-To: <CAPx-8MNO0WaT8j4seOdfoDKoiP=zjo-qkSmFf+ENbxiAAuFrDQ@mail.gmail.com>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Thu, 13 Jan 2022 12:26:18 -0600
Message-ID: <CAAMCDeehu9Ktg993fWU8zarpurCaxeS8xY1yxDfdP3aaWv+RMg@mail.gmail.com>
Subject: Re: md device remains active even when all supporting disks have
 failed and been disabled by the kernel.
To:     Aidan Walton <aidan.walton@gmail.com>
Cc:     Jani Partanen <jiipee@sotapeli.fi>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

My experience is that if a sata controller works fine with one disk,
but not 2 then there is a significant bug in the chip attempting to
correctly handle 2 streams and there is likely no way to fix it
because it is a hw issue.  I have seen way too many controllers that
must have passed a limited worthless test process with only one disk,
but won't work reliably with more than one.

My past testing on cheap PCI-e sata controllers was pretty ugly.
They were a pretty unreliable bunch, they would generally work just
good enough to make you think they work, and then fail under load.   I
gave up and spent a bit more to get a used HBA mode LSI SAS2008
controller but that is a pcie-8 controller and can be had for about
$50.

You cannot umount the filesystem once the underlying disk is gone.
step #1 in umounting is to sync what data there is in ram, and with
the device being gone that will never finish and hence will never
umount it, and there will always be access time and/or other data to
be synced from what I have seen.  I have not heard of a way to tell
the kernel that a device/fs is really gone and clean up the dirty
writes related to that device so that it could be umounted.  You can
lazy umount it and that will make the mount point go away from showing
up in the OS, but it really won't be umounted if there is dirty cache
for the device, and/or programs with file open on the disk.

On Wed, Jan 12, 2022 at 6:46 PM Aidan Walton <aidan.walton@gmail.com> wrote:
>
> Thanks Jani,
> Gold info. I have been looking at 2 cheap Mini-PCIe adapters. One uses
> the JMicron and would you believe it the other is using ASMedia.
> Now I have a solid reason to choose the second rather than the first.
>
> In this case it will NOT be,  "Better the devil you know than the
> devil you don't"
> and anyway I don't work hard enough to need 6Gb/s :)
> ATB
> Aidan
>
> On Thu, 13 Jan 2022 at 01:24, Jani Partanen <jiipee@sotapeli.fi> wrote:
> >
> > Aidan Walton kirjoitti 13/01/2022 klo 2.03:
> > > Hi Roger,
> > > As I mentioned, it is a:
> > > JMicron Technology Corp. JMB363
> >
> > If my memory is correct. This chip is trash. If I am right, I have same
> > chip on cheap controller what I bought to get IDE controller mainly, it
> > also has 2xSATA ports and I had only troubles with that controller in linux.
> > If I had no drives on SATA ports, dmesg got spammed port errors. If I
> > had drives installed, they was randomly dropping in and out. Chip itself
> > was running hot as hell, I mean so hot that you could not keep finger on
> > chip. I did put some small finns to it and I think it did help little
> > for drives dropping in and out, but didn't solve it.
> > If you want a cheap controller, get this chip:
> > 02:00.0 SATA controller: ASMedia Technology Inc. Device 1166 (rev 02)
> >
> > It's been quite stable for me and didn't cost much. Only issue I have
> > that I cannot force it's ports transfer speed to example 3.0G. Spinnin
> > rust do not need 6.0G speed what in my experience increase chance for
> > dropouts if you cables aren't 6.0G ready and how do you tell if they are
> > when cable doesn't have any mention about it?
> > I think it's something to do that it's PMP card and I don't understand
> > how you have to format kernel parameter when you have PMP situation. I
> > can tune internal controller all ports just fine, but not this expansion
> > card. Kernel tell you it's forcing them to 3.0G, but when you check
> > later what transfer speed is, it's still 6.0G
> >
> >
