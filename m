Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9BC6C2B9F4
	for <linux-raid@archiver.kernel.org>; Sat, 26 Jun 2021 00:23:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE7A361962
	for <linux-raid@archiver.kernel.org>; Sat, 26 Jun 2021 00:23:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbhFZA0O (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 25 Jun 2021 20:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbhFZA0N (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 25 Jun 2021 20:26:13 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68792C061574
        for <linux-raid@vger.kernel.org>; Fri, 25 Jun 2021 17:23:51 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id h11so12445916wrx.5
        for <linux-raid@vger.kernel.org>; Fri, 25 Jun 2021 17:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=3zrz2hlk/Xdy/5xo1RyVFdS2pqd8iCl5ewMgibWYb8I=;
        b=QmDX++iqV9vZlc0vNACRq6+/d0rvU90DkyThCl19TLGHymCPvgbwauTOEA57jE7NGl
         a/d9ImpXqBFkvXb96WMeIjijOeLCShVaEof+GCIQfV6jp+C1raF5Y/xMg1k+8GAdepw7
         zzTvxrr0sp2aRBtGmTawlUYlNTGSKXKA8hfOWlAUtYVEUN5qigVjgzh1x3v3P9VmNeEp
         guUDRqjctGxr9op5Kwh0N9lSB5Jy9jQl844A/YfgoQDs6ZUxOHS/5H71Q167YlMHKuQf
         OP0GYraXsg3zZsH77Y2qBceT5XJzyDaJNwUws+SSBTdcRGlVUX3FLZqZhkcyaq6BkIY3
         MeDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=3zrz2hlk/Xdy/5xo1RyVFdS2pqd8iCl5ewMgibWYb8I=;
        b=mWQX3H/I1cwgAuop44S2Nz4YAHjDdKIC1yaSRE4eX5TbQc1Rs3Mbje8sgKB52rURQy
         HU9X3NpOdUtDzb0w9kBNInq+aF8Ot1O3VBwhwQCvadMtBVaXLDXUMkN2+VA1/juCFkpc
         4bkPL5d+dV2wMBvvYiXO/cC95FjAFck5JcQ2OQlLuXu+aioHyEHS8Z25zB+iWGRtzCHq
         /z5bAZcbWct10IbGoi9Rs49+asZfm7LhzhotIZ8974icQ9FPayinyiXXdGXyjKraBqs+
         DlKrkab0M+e0azvhibHuWwrYcH8lvVdrMzEwc8qST0zE+hZXTHVG1XrouNydKuf5iCXS
         BvHw==
X-Gm-Message-State: AOAM532/lmQCqIcltXzqs3Ogr/N7JUrEp82KJLAFHfwG4qjakWrggMd7
        rLLt2t5N+2iMA+fq3q4ggQVExou5yEl1Xp8C5R1mZbT/HHyx1Oxci9Y=
X-Google-Smtp-Source: ABdhPJz++TZC6tdTY3l/9SLJRz3VXQWLFc1P4sR2XnbjkwPbBjfyLbItxO4rATSQLoQWmi/U8w4zlnWyLtl8nl3gZZo=
X-Received: by 2002:a05:6000:18ab:: with SMTP id b11mr14386969wri.42.1624667029854;
 Fri, 25 Jun 2021 17:23:49 -0700 (PDT)
MIME-Version: 1.0
References: <CACsGCyRLJ7Lr5rpxUDaNRzZr=s0LjK8wwOENC2RXmNsHvz4HaA@mail.gmail.com>
 <20210625220845.57wcwz4sppavywf6@bitfolk.com>
In-Reply-To: <20210625220845.57wcwz4sppavywf6@bitfolk.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Fri, 25 Jun 2021 18:23:33 -0600
Message-ID: <CAJCQCtQ3zzqxQbtGCSko80d-u1zkWMPwkGQXf92p8Ozty+XGEg@mail.gmail.com>
Subject: Re: Redundant EFI Systemp Partitions (Was Re: How does one enable
 SCTERC on an NVMe drive (and other install questions))
To:     Linux-RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Jun 25, 2021 at 4:08 PM Andy Smith <andy@strugglers.net> wrote:
>
> Hello,
>
> On Mon, Jun 21, 2021 at 12:00:13AM -0500, Edward Kuns wrote:
> > looks like maybe I cannot use the installer to set up RAID mirroring
> > for /boot or /boot/efi.  I may have to set that up after the fact.
>
> In November 2020 I had this discussion on debian-user:
>
>     https://www.mail-archive.com/debian-user@lists.debian.org/msg762784.html
>
> The summary was that the ESP is for the firmware and the firmware
> doesn't know about MD RAID, so is only ever going to see the member
> devices.
>
> You could lie to the firmware and tell it that each MD member device
> is an ESP, but it isn't. This will probably work as long as you use
> the correct metadata format (so the MD metadata is at the end and
> the firmware is fooled that the member device is just a normal
> partition). BUT it is in theory possible for the firmware to write
> to the ESP and that would cause a broken array when you boot, which
> you'd then recover by randomly choosing one of the member devices as
> the "correct" one.
>
> Some people (myself included, after discovering all that) decided
> that putting ESP on an MD device was too complicated due to these
> issues and that it would be better to have one ESP on each bootable
> device and be able to boot from any of them. The primary one is
> synced to all the others any time there is a system update.
>
> Ubuntu have patched grub to detect multiple ESP and install grub on
> all of them.
>
> In theory it would be possible to write an EFI firmware module that
> understands MD devices and then you could put the ESP on an MD array
> in the same way that grub can boot off of an MD array.

Yeah, efifs might have it
https://github.com/pbatard/efifs

One solution is making the ESP static, other than OSLoader updates. A
"stub" grub.cfg points to $BOOT/grub/grub.cfg or $BOOT/grub2/grub.cfg,
where $BOOT is typically mounted at /boot; and then follow the Boot
Loader Spec to add drop-in configuration files for each menu entry.
Typically there is one drop in file per kernel. This is how Fedora has
worked for several releases now. It permits the two grub.cfg's to
remain static, is less prone to problems if replacing it or modifying
it is interrupted by a crash. And the snippets are a more user
friendly format for editing, should it be deemed necessary, while
being less fragile.

A canonical ESP that resides virtually in /usr I think is another way
of doing all of this; and use a service unit to sync from /usr to each
ESP by mounting them e.g. somewhere in /run, in sequence, thereby
containing any problems with interruptions.

https://systemd.io/BOOT_LOADER_INTERFACE/
https://systemd.io/BOOT_LOADER_SPECIFICATION/

While some platforms are currently left out of the specs, I think it's
better to grow the spec to make booting more reliable and a lower
maintenance burden rather than continuing to do things in a rather ad
hoc manner.


-- 
Chris Murphy
