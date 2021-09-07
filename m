Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F1A5C433EF
	for <linux-raid@archiver.kernel.org>; Tue,  7 Sep 2021 17:56:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81F8060F14
	for <linux-raid@archiver.kernel.org>; Tue,  7 Sep 2021 17:56:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234449AbhIGR5N (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 7 Sep 2021 13:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233562AbhIGR5M (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 7 Sep 2021 13:57:12 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C431C061575
        for <linux-raid@vger.kernel.org>; Tue,  7 Sep 2021 10:56:06 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id z2so6311054qvl.10
        for <linux-raid@vger.kernel.org>; Tue, 07 Sep 2021 10:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6j45SgdHDPq0kTPwY+CeLco9cH3LK8psUAO4LYX32nA=;
        b=VclF5+tmB7ieOn3dam8e2CzBmGUa4ASOPib55U8cQOnDXwA4B0OrCIDdE44vJOqMLb
         roGF9p4pD9FANlOqXZ7r9TcBX/4IMtfPOa73RUzryesdu8ap7DeMQ1qqw0kVnzrIZBGb
         B/XUeoinuxat7L6JtaA6xjG68MBMc83qMcd88qKFy+eSNNv45dXwD68OLBVqcYNvJrEE
         fGtmu0K8f72X7VBrND6skGpBXWJQa5M/xm4zL9jyM63VU1zXNSUkCxJZyWp/EU1ZzKyZ
         XhuD2pnnWlpCyDy+VdynxhmzcCdFz9jIYOwkQ6hAYTVihmuCyQg97Iy8zkswUOYl3wHt
         kO9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6j45SgdHDPq0kTPwY+CeLco9cH3LK8psUAO4LYX32nA=;
        b=HlK3U6WV66YxmWoTzI37YW9MQf891mP/lik2/14q3ACRpSVqEIRA+IMUdjReykQy3Q
         6HyVm8zM0ZQ5ynHsB2V1EmRJAhz+nbF/r02QEPYEBYtyQGV1WBhU25VHuBgfNiwoTPdC
         R4kY4O7Lwl/HeBCUWcQXV1u5kFv5JR62nBTxICmBrROrVRpHbIW0ZCQbr30ibeePlX/l
         z6r9Pz2hWnGUDS/wcFUm3EvwvzvLoPr5klTFHlVt+hbQzyM/URRNHIPdlSrV4tseAh1Z
         TPVx4KXx4l6fmsPI6h+pEzoHUyG1D4pXYgCraKFKq12c0Yly7sjOy4gZJC1ASFdlVilj
         mihg==
X-Gm-Message-State: AOAM531sFoq8clSmrBNdWIcR/LGhTLbXq9uRi9Oa0ql8D3Q1DFmEHArG
        p2tH1tNks+nebzFiR6hcMm8mJGh8joDhU0MUlow=
X-Google-Smtp-Source: ABdhPJzcSSa5vgDZlfQV/0+PLhqFRkh5HP4G+Mr4vKxEjDQ9kdDiFuUKz3yiN4a6aVtj6kIKaGMcoVC5mAwrSPfUF1I=
X-Received: by 2002:a0c:cb8f:: with SMTP id p15mr18290731qvk.2.1631037365619;
 Tue, 07 Sep 2021 10:56:05 -0700 (PDT)
MIME-Version: 1.0
References: <CA+Kggd7mUF9MWdJsLtAQMv=KXtwaNvj6BqfM+NMyffE86iHBoQ@mail.gmail.com>
 <20210907125201.0cc77658@natsu> <20210907141835.259010e3@natsu>
In-Reply-To: <20210907141835.259010e3@natsu>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Tue, 7 Sep 2021 12:55:54 -0500
Message-ID: <CAAMCDedp=YqZg9=o=KwQ7GHLvq+eoAJ7Sw1syVpZ7r_nm4ibDw@mail.gmail.com>
Subject: Re: mdadm resync causes stable system to crash every 2 or 3 hours
To:     Roman Mamedov <rm@romanrm.net>
Cc:     Ryan Patterson <ryan.goat@gmail.com>,
        Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

My older system would reliably crash(total hardware reset, crashdump
did not dump, hardware would boot back up all very quickly) doing a
check / resync.   I finally on one of the boot ups saw the "machine
check" logged messages and decoded it.  Mine came back to PCIe error.
I disassembled, vacuumed and cleaned the connecters on the PCIE SAS
card, and for good measure moved said PCI'e card (LSI SAS2008  card)
to the one other x8 slot I had, just in case the slot itself was bad..
   Those changes made it reliable now.  Full check 1x per week, up 11
weeks now, MTBF prior was 2-3 weeks max.   So long as I did not do a
resync/check the above machine was "perfectly" stable and would stay
up.

So remember rsync puts a lot of stress on power supplies, it uses
PCI-e buses heavily, and a lot of other components.

This is what I had in messages when it was booting back up after the
hardware crash/cycle.
Jun 14 04:25:05 rahrah kernel: [    0.560897] mce: [Hardware Error]:
Machine check events logged
Jun 14 04:25:05 rahrah kernel: [    0.560897] mce: [Hardware Error]:
CPU 0: Machine Check: 0 Bank 4: f600000000070f0f

And note I have seen issues with the 12-16TB disks (this are OEM disks
so it is unclear who really made them, but it could very well be
seagate) where they seem to respond massively slow.  with timeouts
high enough they respond, but are so slow that they are unable to keep
up with the load the app needs.   The fix that has been being used is
to find the troublemaker disk (will show in various io tools as being
very busy/slow/slow response to smartctl commands also/and often has
bad sector count non-zero and rising) and replace it.    Were I have
experience with these disks we have a lot of them and replacements
with this process have been solving the issues.

I would certainly make sure that if you cannot set scterc then you set
the scsi timeouts high enough.  The 12-16TB ones aren't via mdadm they
are via a hardware raid controller, but said hardware raid controller
seems to have a lot of trouble dealing with the slow disks.

On Tue, Sep 7, 2021 at 4:20 AM Roman Mamedov <rm@romanrm.net> wrote:
>
> On Tue, 7 Sep 2021 12:52:01 +0500
> Roman Mamedov <rm@romanrm.net> wrote:
>
> > On Mon, 6 Sep 2021 20:44:31 -0400
> > Ryan Patterson <ryan.goat@gmail.com> wrote:
> >
> > > My file server is usually very stable.  The past week I had two mdadm
> > > arrays that required recync operations.
> > > * newly created raid6 array (14 x 16TB seagate exos)
> > > * existing raid 6 array, after a reboot resync on hot spare (14 x 4TB
> > > seagate barracuda)
> > >
> > > During both resync operations (they ran one at a time) the system
> > > would routinely experience a major error and require a hard reboot,
> > > every two or three hours.  I saw several errors, such as:
> > > * kernel watchdog soft lockups [md127_raid6:364]
> > > * general protection faults (I have a few saved with the full exception stack)
> > > * exceptions in iommu routines (again I have the full error with
> > > exception stack saved)
> > > * full system lockup
> >
> > So in other words the server is very stable, unless asked to do full-speed
> > reads from all disks at the same time.
> >
> > I'd suggest to check or improve cooling on the HBA cards, and then try a
> > different PSU.
>
> Also the motherboard chipset cooling, since that's a lot of PCI-E traffic.
> Maybe the CPU cooling as well, or at least check the CPU temperatures during
> this load.
>
> And since you have full logs and backtraces, there's no point in waiting to
> post those, just go ahead. Maybe they will point to something other than
> suspect hardware, or at least to which part of hardware to suspect.
>
> --
> With respect,
> Roman
