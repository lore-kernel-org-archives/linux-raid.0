Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83653C19F2D
	for <linux-raid@archiver.kernel.org>; Sun, 14 Aug 2022 00:49:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbiHNAtR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 13 Aug 2022 20:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiHNAsl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 13 Aug 2022 20:48:41 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 778FC39BA9
        for <linux-raid@vger.kernel.org>; Sat, 13 Aug 2022 17:48:40 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id z22-20020a056830129600b0063711f456ceso3101858otp.7
        for <linux-raid@vger.kernel.org>; Sat, 13 Aug 2022 17:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc;
        bh=3l9csivhC8gP2/EWDG3PIsoAxf3T1L1vXDdd+K0eRvk=;
        b=h33wbGxz7AC2nkYVPhM0/iqqH5k6JypLWJMN6ArUo/BsyvLJqZcUzGidLNv+yrthJx
         mGzEzOO7me/oYr4ACumBcHjy2DvHlruoiZMfY0ZjxIQucPcg9sR78ZZ5Ct4J7D4dja1f
         E2zqIA6CyYBXO6RuQrbaCtRTQ0H1FF7U5EHMCqSeuwI3Xarc8j8JGQStnVHktIcxaplu
         KKLakZhyActw0FIfZbS188u3o/qDU3R3BnCiqw6T9YSL2YSqaRLopkAY2t1dWZU1th5P
         h4EXJeAp4pJH8TumfR4f/MYgJN3NrYnxmP4fOl4fAFoaarTPJFtpTXtY8c5OPe4+3UHq
         S4mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc;
        bh=3l9csivhC8gP2/EWDG3PIsoAxf3T1L1vXDdd+K0eRvk=;
        b=Fvp7whSt0iSAm5KPkn630KhlPIN10g2L1G66SdIbXXcwY6l14suH+Fkdb0tK/FKwXA
         octXNpmRJDg6kdCS0OUbib/OHnnxoaKRXthlpr3GeaRUeUW/9dOJRMu3NM/o6KyVOk05
         241LFxz1O9hV7/aG7nemM3eMavxpv1BTMGDuUSUKMAz0ExTy0NwWz0VKEUBugof9s7Ub
         vx8yuODmWu1GbJDe/Jrm/suN0inp3xK2ItfDHB/D8IGfKQunI6YmVSnIzUGyxQYdSRvw
         pZuYaFpu4I3inf61ZfFV5++9gEqZLaoNCWi6AexJGZF1XVyT5mPKB1cieOr80OS7QiPy
         ZRKw==
X-Gm-Message-State: ACgBeo3zxPVAH322ZMrECg9z6LsBWxBaFqOnNXdCLqI9bjszDuQMG0VM
        /0fD/x0m1gxYCNn+olopoXQDhr+2UzQ1rlGMOco/bGcwCJs=
X-Google-Smtp-Source: AA6agR415tphZ1cnmwPObbO4nZPSeUWh0j77gN4mhjTelvT7Q6JX+tCkeSJAOdiAh239o6S9bReP4+lDurVZ1OV0nnU=
X-Received: by 2002:a9d:4a8:0:b0:60c:76b1:f1be with SMTP id
 37-20020a9d04a8000000b0060c76b1f1bemr3863282otm.347.1660438119487; Sat, 13
 Aug 2022 17:48:39 -0700 (PDT)
MIME-Version: 1.0
References: <CAGRSmLt0gMZ6_XUE_24tEZaKHB1tviANpZKVs+Jsr5OiE22y8Q@mail.gmail.com>
 <CAGRSmLvJTtW=fbYN+F523V9Sngim2wZK+6VaxaNdraRdX+6saA@mail.gmail.com>
In-Reply-To: <CAGRSmLvJTtW=fbYN+F523V9Sngim2wZK+6VaxaNdraRdX+6saA@mail.gmail.com>
From:   "David F." <df7729@gmail.com>
Date:   Sat, 13 Aug 2022 17:48:28 -0700
Message-ID: <CAGRSmLuk6GmUD7p0Nf1jg821EYAyUout2dck+z80yZL8-81N_A@mail.gmail.com>
Subject: Re: mdadm not assembling RAID?
To:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

What I did to make it work was add nodmraid to kernel parameter - but
since I need to use dmraid sometimes and I want to use the init script
to handle it, I removed 63-md-raid-array.rules and 85-dmraid.rules
from udev so raid doesn't try to automatically start at boot.

However, when trying to do: mdadm --assemble --scan --no-degraded -v

you end up with:

mdadm: looking for devices for further assembly
mdadm: Cannot assemble mbr metadata on /dev/sdc1
mdadm: Cannot assemble mbr metadata on /dev/sdc
mdadm: Cannot assemble mbr metadata on /dev/sda5
mdadm: Cannot assemble mbr metadata on /dev/sda3
mdadm: Cannot assemble mbr metadata on /dev/sda2
mdadm: no recongnizeable superblock on /dev/sda1
mdadm: /dev/sda is identified as a member of /dev/md/imsm0, slot 0.
mdadm: /dev/sdb is identified as a member of /dev/md/imsm0, slot 1.
mdadm: added /dev/sdb to /dev/md/imsm0 as 1
mdadm: added /dev/sda to /dev/md/imsm0 as 0
mdadm: timeout waiting for /dev/md/imsm0
mdadm: looking for devices for further assembly
mdadm: looking for devices for further assembly
mdadm: Cannot assemble mbr metadata on /dev/sdc1
mdadm: Cannot assemble mbr metadata on /dev/sdc
mdadm: Cannot assemble mbr metadata on /dev/sda5
mdadm: Cannot assemble mbr metadata on /dev/sda3
mdadm: Cannot assemble mbr metadata on /dev/sda2
mdadm: no recongnizeable superblock on /dev/sda1
mdadm: /dev/sda is busy - skipping
mdadm: /dev/sdb is busy - skipping
mdadm: cannot open device /dev/md/imsm0: No such file or directory

If I left the rules in place, dmraid takes over, if I do this:

dmsetup remove_all
mdadm --assemble --scan --no-degraded -v

then it comes up fine as well.

Help!
Thanks.



On Sat, Aug 13, 2022 at 4:02 PM David F. <df7729@gmail.com> wrote:
>
> So it does have something to with the mapper devices.   If I add
> "nodmraid" kernel parameter then mdadm raid works like it did before.
>  I want searching config parameters for the kernel to see if I enabled
> DMRAID somehow but didn't find any.   Why is the new disk/updated
> programs automatically starting dmraid?   could it be udev rules .. I
> don't really understand them .. but dmraid is an option for non intel
> type raid, so what happens is dmraid is tried first for all but the
> intel items, then mdadm is used.  But this is not coming from my call
> of dmraid, it's coming from someplace automatic ??
>
> On Sat, Aug 13, 2022 at 12:58 PM David F. <df7729@gmail.com> wrote:
> >
> > I have an older system with Intel RAID (striped) I use to test updates
> > to my linux boot disk to ensure the RAID is still working.  I just
> > went through a big update of all the utilities and shared libraries
> > along with moving from 5.10 to 5.15 kernel.  There was a stage where
> > the kernel was updated to 5.15 but all the utilities and shared
> > libraries were not (and md raid was working).  The problem is now
> > there are no md devices created, but there are a bunch of dm devices
> > created that never were before.
> >
> > This group has been very helpful in the past.  I hope you can help
> > with what is going on here?  Does it have something to do with the
> > updated devmapper ?  Should I revert?
> >
> > I put both the old working information and the new information below -
> > separated by the 3 lines of equals.
> >
