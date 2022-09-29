Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3325AC433FE
	for <linux-raid@archiver.kernel.org>; Thu, 29 Sep 2022 14:25:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235532AbiI2OZM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 29 Sep 2022 10:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235035AbiI2OZE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 29 Sep 2022 10:25:04 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00B40275E8
        for <linux-raid@vger.kernel.org>; Thu, 29 Sep 2022 07:24:59 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id 3so920720qka.5
        for <linux-raid@vger.kernel.org>; Thu, 29 Sep 2022 07:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=wXZkiD20hdCTPVcZMfXTAj3nCtO6sMYCK1jkwMmRZUY=;
        b=a1g3vRMppNAR5fSI65C+Abu7dkSyLCx1lhBbZLm1oJTZ6UKHhxiFHr+cQQiUio+Jo5
         EO4eaP1Q/KpfeTC0BAa3kD74bGYaU7RuLYH9cppp+t9HfzrMBCRfDHuSYXUz7V1ZdWxT
         bj6aFrxiNQw24aH6ifTCvpSzKbnJJ+lN9rRWJxTCmb967V/scwWmCSeQLJpEzzZEZGc6
         wIpRNEA+0e2lCxvBJAGwUyuec/toRn9JacT7fVpSNTGQU+LnDUxa7yZxVfjulZkO2VXA
         Aa/M/g5CMJMxHEKg1i6upw6Q7m+R3Q6C7LUJBekfmDNUnEsUIJawwq6llVl4GiShIb0b
         PFUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=wXZkiD20hdCTPVcZMfXTAj3nCtO6sMYCK1jkwMmRZUY=;
        b=AaQW5Rq9BduPkurCMDgedFYxD6XCC/zthoTwMbrloGEi5MT7i/LcxFlJFqhUsxrUg5
         jPPZmJ2s/CSWPNeuQVD4RmOYvJjkCqA0Caf14SVBYvQZLjCT3zYO7ENseCs9az66W4YW
         UtKGBG/MytfC8cqtqT3ypKYzmLW2ZVfocHheAgZt5f7JGy/H4L/pW2sGRaC5FE2xlgej
         6MT6IfOBRWu8xcULPc66oVmPxqxwRwyfP7JeifUM8J9NsIzRKEziNBx+rWsMJSpOzWr7
         5plugsrWh0Rk7HHf9sR4Zg3aVo6ywudd6Qg1fTiRzLgHtHQ3RGOEjLqVxWMKTt9M1Xpq
         HW4Q==
X-Gm-Message-State: ACrzQf2cdwtOMQgMuPIrNQ8PMOy/vPBP3dQGsT7foAgsgSkScG3+PFiH
        gyxlWAdNk/lWgTJzgTdbvh4JIkBGmx92iY6SEYzt1aun
X-Google-Smtp-Source: AMsMyM7m5dCUrVnuJn320INC4lHlVO7Djrv7BCSsqY/S1lr9Lcxb1Rr5Hir02hGIV3EAeo2IwhajcgjWLDan/8ev/ps=
X-Received: by 2002:a05:620a:46a4:b0:6ce:c4af:5a54 with SMTP id
 bq36-20020a05620a46a400b006cec4af5a54mr2356916qkb.377.1664461498485; Thu, 29
 Sep 2022 07:24:58 -0700 (PDT)
MIME-Version: 1.0
References: <87o7xmsjcv.fsf@esperi.org.uk> <d28a695e-1958-d438-b43d-65470c1bbe7a@youngman.org.uk>
 <87bktjpyna.fsf@esperi.org.uk> <2a0119a2-814f-d61b-cf82-b446c453e6dc@youngman.org.uk>
 <875yjpo56x.fsf@esperi.org.uk> <CAAMCDect7m24tQaDZ7dqv+En2LveaLfOtTgYNJu5G1jtzVmbUg@mail.gmail.com>
 <878rm2fj3u.fsf@esperi.org.uk>
In-Reply-To: <878rm2fj3u.fsf@esperi.org.uk>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Thu, 29 Sep 2022 09:24:47 -0500
Message-ID: <CAAMCDedShpj=MZwfUqmSokdvSMhtypXkLQi6UHnhiCqG2SnckA@mail.gmail.com>
Subject: Re: 5.18: likely useless very preliminary bug report: mdadm raid-6
 boot-time assembly failure
To:     Nix <nix@esperi.org.uk>
Cc:     Wols Lists <antlists@youngman.org.uk>,
        Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

partprobe will also recreate as needed the partition mappings.

A serial port crossover cable (assuming your machine still has a
serial port and you have another machine close by and a serial port
and/or usb serial cable) can collect all of the console if
console=ttyS0,115200 is set on the boot line (S0 = com1, s1=com2,...)
 Another option would be to use a fat/vfat formatted usb key and save
it on that.

It does not actually matter if the initramfs is built into the kernel
image or not, grub is what loads both the kernel and initrd into
memory and then tells the kernel to execute.   Once the kernel/ramfs
is loaded you don't actually even need to be able to mount /boot and
/boot/efi except to update the kernel and/or change parameters stored
in /boot or /boot/efi.


On Thu, Sep 29, 2022 at 7:41 AM Nix <nix@esperi.org.uk> wrote:
>
> On 22 Jul 2022, Roger Heflin verbalised:
>
> > On Fri, Jul 22, 2022 at 5:11 AM Nix <nix@esperi.org.uk> wrote:
> >>
> >> On 20 Jul 2022, Wols Lists outgrape:
> >>
> >> > On 20/07/2022 16:55, Nix wrote:
> >> >> [    9.833720] md: md126 stopped.
> >> >> [    9.847327] md/raid:md126: device sda4 operational as raid disk 0
> >> >> [    9.857837] md/raid:md126: device sdf4 operational as raid disk 4
> >> >> [    9.868167] md/raid:md126: device sdd4 operational as raid disk 3
> >> >> [    9.878245] md/raid:md126: device sdc4 operational as raid disk 2
> >> >> [    9.887941] md/raid:md126: device sdb4 operational as raid disk 1
> >> >> [    9.897551] md/raid:md126: raid level 6 active with 5 out of 5 devices, algorithm 2
> >> >> [    9.925899] md126: detected capacity change from 0 to 14520041472
> >> >
> >> > Hmm.
> >> >
> >> > Most of that looks perfectly normal to me. The only oddity, to my eyes, is that md126 is stopped before the disks become
> >> > operational. That could be perfectly okay, it could be down to a bug, whatever whatever.
> >>
> >> Yeah this is the *working* boot. I can't easily get logs of the
> >> non-working one because, well, no writable filesystems and most of the
> >> interesting stuff scrolls straight off the screen anyway. (It's mostly
> >> for comparison with the non-working boot once I manage to capture that.
> >> Somehow. A high-speed camera on video mode and hand-transcribing? Uggh.)
> >
> > if you find the partitions missing if you initrd has kpartx on it that
> > will create the mappings.
> >
> >   kpartx -av <device>
>
> I may have to fall back to that, but the system is supposed to be doing
> this for me dammit! :)
>
> The initrd is using busybox 1.30.1 mdev and mdadm 4.0 both linked
> against musl -- if this has suddenly broken, I suspect a lot of udevs
> have similarly broken. But these are both old, upgraded only when
> essential to avoid breaking stuff critical for boot (hah!): upgrading
> all of these is on the cards to make sure it's not something fixed in
> the userspace tools...
>
> (Not been rebooting because of lots of time away from home: now not
> rebooting because I've got probable flu and can't face it. But once
> that's over, I'll attack this.)
>
> > I wonder if it is some sort of module loading order issue and/or
> > build-in vs module for one or more of the critical drives in the
> > chain.
>
> Definitely not! This kernel is almost totally non-modular:
>
> compiler@loom 126 /usr/src/boost% cat /proc/modules
> vfat 20480 1 - Live 0xffffffffc0176000
> fat 73728 1 vfat, Live 0xffffffffc015c000
>
> That's *it* for the currently loaded modules (those are probably loaded
> because I built a test kernel and had to mount the EFI boot fs to
> install it, which is not needed during normal boots because the
> initramfs is linked into the kernel image).
>
> --
> NULL && (void)
