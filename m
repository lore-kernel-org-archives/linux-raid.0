Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 085CAC433FE
	for <linux-raid@archiver.kernel.org>; Wed, 15 Dec 2021 22:05:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbhLOWF1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 15 Dec 2021 17:05:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbhLOWF0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 15 Dec 2021 17:05:26 -0500
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39980C061574
        for <linux-raid@vger.kernel.org>; Wed, 15 Dec 2021 14:05:26 -0800 (PST)
Received: by mail-qk1-x72c.google.com with SMTP id d21so14227580qkl.3
        for <linux-raid@vger.kernel.org>; Wed, 15 Dec 2021 14:05:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pLQ8uqUVo+pLEz40EzSdJ2LDMNMdS9PebVcui444M+k=;
        b=erL5DWFMD5T8HAfQAsNUTC/eIKyk69ClH9TcUAueELLPbGr3rB4zXhNpW7RGBWDvQz
         EEzCS01a11QbfbZCtRkg+3GEXl0QdW5nzs3S2wMqHAwBxNPGfmYNeXHx7GjNmTVkKhaG
         Yl4ldeQOobfA3Jb2AsU3soa3wSlnX1Lv+YR1TyWq3Z4SwUfLvidQaEeC8rBf3eA25Z/N
         9L8YJc17u1uHhd/AHsL97MjCHuNh8p2WmqKkV+jDUEtWNzxca/FcK4kyALBj2eWtYxPF
         n34LNC4cwkgPGpB+/bnPI3CwQtsLoRr5F7fuV7qy+PBqz8QwbZcAJE5XQxSt6WnnaMHX
         Jqwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pLQ8uqUVo+pLEz40EzSdJ2LDMNMdS9PebVcui444M+k=;
        b=diwOgej+mZXekKPsm26YEgndMvOY2dZFxDAakQIEAfgX7YZom2pvE3+4rd3GWIyAKf
         kl3ir9k1/TpkfbEXWWLv6i1NW4LN0UOHvUDitvTlMW2ZRODpxs3QQIj5xZXcT38PwQOk
         /5okyJ3kTlp6q9D/LzZIs0IkcTJnEoGKTGf5cnOlmU4zGFvtYdm2VRiWNVSrFN0DI8Nh
         OlpoNw2hBRCUEPNI4aZ2jzpaRYnEui9eTTxD0vyymw6t1VNQD3Uvh6blLhAi/63Hd9Or
         DsiOngIeFT0FqnSD4T+xEwke/CJA8VCkyMNaU5BP6vG9LiHFGTeH6ywMhH00YPh+D+FA
         Pt/Q==
X-Gm-Message-State: AOAM5307awC4uGzmWMnRca2yi2EeHgfdFecVXRyuFwFZ4pER7CRKykvD
        hv97i+ew0+IPnBTL8dyxbdC5Fw74WjNLZUVq8LMo5TMq7no=
X-Google-Smtp-Source: ABdhPJw4FqoM7I4H2tQ+DxbnwiBrsx+hMSF7TFHDMlVOhA2hxA++uzgNapjyGUjyrHm2aG0ixmpQg3Efw5Jl2HlQoYo=
X-Received: by 2002:a05:620a:4087:: with SMTP id f7mr10370029qko.56.1639605925181;
 Wed, 15 Dec 2021 14:05:25 -0800 (PST)
MIME-Version: 1.0
References: <d8a0d8c9-f8cc-a70a-03a0-aae2fd6c68c2@youngman.org.uk>
 <CAAMCDeekr+a6e7BwyF9b=n49X6YgqUWBc8UtAyZkjFcHBnbyRQ@mail.gmail.com> <cbfc2f45-96d8-4ee7-a12b-5a24bd2f2159@youngman.org.uk>
In-Reply-To: <cbfc2f45-96d8-4ee7-a12b-5a24bd2f2159@youngman.org.uk>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Wed, 15 Dec 2021 16:05:13 -0600
Message-ID: <CAAMCDeemZO2u_4WW8pHVP2qOxz0HdHQTy2Gsa=zgY-7g4ptw7w@mail.gmail.com>
Subject: Re: Debugging system hangs
To:     Wol <antlists@youngman.org.uk>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

There would be various messages.
 grep -E 'ATA| sd |ata[0-9]' /var/log/messages
might get you details.  It will also show when the disks are first
showing up and being reported.

Timeouts look kind of like this:
ata5: SError: { Handshk }
ata5.00: failed command: WRITE FPDMA QUEUED
ata5.00: cmd 61/40:58:40:e8:88/00:00:e8:00:00/40 tag 11 ncq dma 32768
out#012         res 40/00:6c:00:eb:88/00:00:e8:00:00/40 Emask 0x10
(ATA bus error)
ata5.00: status: { DRDY }
ata5.00: failed command: WRITE FPDMA QUEUED
ata5.00: cmd 61/18:60:48:ea:88/00:00:e8:00:00/40 tag 12 ncq dma 12288
out#012         res 40/00:6c:00:eb:88/00:00:e8:00:00/40 Emask 0x10
(ATA bus error)
ata5.00: status: { DRDY }
ata5.00: failed command: WRITE FPDMA QUEUED
ata5.00: cmd 61/08:68:00:eb:88/00:00:e8:00:00/40 tag 13 ncq dma 4096
out#012         res 40/00:6c:00:eb:88/00:00:e8:00:00/40 Emask 0x10
(ATA bus error)
ata5.00: status: { DRDY }
ata5.00: failed command: WRITE FPDMA QUEUED
ata5.00: cmd 61/08:78:60:ea:88/00:00:e8:00:00/40 tag 15 ncq dma 4096
out#012         res 40/00:6c:00:eb:88/00:00:e8:00:00/40 Emask 0x10
(ATA bus error)
ata5.00: status: { DRDY }
ata5.00: failed command: WRITE FPDMA QUEUED
ata5.00: cmd 61/08:c8:f8:e5:88/02:00:e8:00:00/40 tag 25 ncq dma 266240
out#012         res 40/00:6c:00:eb:88/00:00:e8:00:00/40 Emask 0x10
(ATA bus error)
ata5.00: status: { DRDY }
ata5.00: failed command: WRITE FPDMA QUEUED
ata5.00: cmd 61/40:d0:00:e8:88/00:00:e8:00:00/40 tag 26 ncq dma 32768
out#012         res 40/00:6c:00:eb:88/00:00:e8:00:00/40 Emask 0x10
(ATA bus error)
ata5.00: status: { DRDY }
ata5.00: failed command: WRITE FPDMA QUEUED
ata5.00: cmd 61/c8:d8:80:e8:88/01:00:e8:00:00/40 tag 27 ncq dma 233472
out#012         res 40/00:6c:00:eb:88/00:00:e8:00:00/40 Emask 0x10
(ATA bus error)
ata5.00: status: { DRDY }
ata5.00: failed command: WRITE FPDMA QUEUED
ata5.00: cmd 61/08:f8:90:eb:88/00:00:e8:00:00/40 tag 31 ncq dma 4096
out#012         res 40/00:6c:00:eb:88/00:00:e8:00:00/40 Emask 0x10
(ATA bus error)
ata5.00: status: { DRDY }
ata5: hard resetting link
ata5: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
ata5.00: configured for UDMA/133
ata5: EH complete
[4544065.390549] ata4.00: exception Emask 0x10 SAct 0xc000 SErr
0x400000 action 0x6 frozen
[4544065.392582] ata4.00: irq_stat 0x08000000, interface fatal error
[4544065.394543] ata4: SError: { Handshk }
[4544065.396595] ata4.00: failed command: WRITE FPDMA QUEUED
[4544065.398523] ata4.00: cmd 61/40:70:98:2d:ea/00:00:85:00:00/40 tag
14 ncq dma 32768 out
[4544065.398523]          res 40/00:7c:18:2e:ea/00:00:85:00:00/40
Emask 0x10 (ATA bus error)
[4544065.402441] ata4.00: status: { DRDY }
[4544065.404753] ata4.00: failed command: WRITE FPDMA QUEUED
[4544065.406946] ata4.00: cmd 61/40:78:18:2e:ea/00:00:85:00:00/40 tag
15 ncq dma 32768 out
[4544065.406946]          res 40/00:7c:18:2e:ea/00:00:85:00:00/40
Emask 0x10 (ATA bus error)
[4544065.410850] ata4.00: status: { DRDY }
[4544065.412787] ata4: hard resetting link
[4544065.877609] ata4: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[4544065.880880] ata4.00: configured for UDMA/133
[4544065.882816] ata4: EH complete
ata4.00: exception Emask 0x10 SAct 0xc000 SErr 0x400000 action 0x6 frozen
ata4.00: irq_stat 0x08000000, interface fatal error
ata4: SError: { Handshk }
ata4.00: failed command: WRITE FPDMA QUEUED
ata4.00: cmd 61/40:70:98:2d:ea/00:00:85:00:00/40 tag 14 ncq dma 32768
out#012         res 40/00:7c:18:2e:ea/00:00:85:00:00/40 Emask 0x10
(ATA bus error)
ata4.00: status: { DRDY }
ata4.00: failed command: WRITE FPDMA QUEUED
ata4.00: cmd 61/40:78:18:2e:ea/00:00:85:00:00/40 tag 15 ncq dma 32768
out#012         res 40/00:7c:18:2e:ea/00:00:85:00:00/40 Emask 0x10
(ATA bus error)
ata4.00: status: { DRDY }
ata4: hard resetting link
ata4: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
ata4.00: configured for UDMA/133
ata4: EH complete



The autoreboot only happens after the machine has already 'crashed'
and would have been otherwise unresponsive anyway.

On Wed, Dec 15, 2021 at 3:53 PM Wol <antlists@youngman.org.uk> wrote:
>
> On 15/12/2021 16:45, Roger Heflin wrote:
> > If you cannot login to the machine via ssh, also try pinging it.  If
> > ping works but ssh does not either ssh died, or the machine is paging
> > so heavily that user space cannot respond in a reasonable time.
>
> "Unable to resolve host name 'thewolery'"
>
> Paging is EXTREMELY unlikely with 32GB ram ... :-)
> >
> > If the disk were an issue there should be messages about something in
> > the disk layer timing out, but it sounds like there aren't any of
> > those sorts of messages.  If it was a controller hardware/pci slot/hw
> > issue that will in some cases cause an immediate power cycle and boot
> > back up.
>
> Where do I look for those after a reboot? The system basically is
> completely unresponsive - so no it's not a reset or anything, the system
> just stops...
> >
> > You might also configure kdump, there should be doc's someplace on
> > configuring it for your distribution, once configured then test it
> > with "echo c > /proc/sysrq-trigger" and that should crash the machine
> > and leave you with a kernel core dump + dmesg from the time of the
> > crash.   Also if kdump is configured and working it will crash/dump
> > memory and typically boot back up automatically.
>
> I'll have to try it, although an autoreboot might not be a particularly
> good idea ...
> >
> > On Wed, Dec 15, 2021 at 3:54 AM Wols Lists <antlists@youngman.org.uk> wrote:
> >>
> >> Don't know if this is off-topic or not, seeing as my system is very much
> >> reliant on raid ...
> >>
> >> But basically I'm seeing the system just stop responding. Typically it's
> >> in screensaver mode, I've got a blank screen, and it won't wake up. (I
> >> used to think it was something to do with Thunderbird, it mostly
> >> happened while TB was hammering the system, but no ...)
> >>
> >> Today, I had it happen while the system was idle but not in screensaver,
> >> I run xosview, and everything was clearly frozen - including xosview.
> >>
> >> As you might know, my stack is ext4 over lvm (over raid over
> >> dm-integrity for /home) over spinning rust.
> >>
> >> And I run gentoo/systemd - currently on the latest stable kernel afaik,
> >> 5.10.76-gentoo-r1 SMP x86_64.
> >>
> >> Any advice on how to debug a hang - basically I need something that'll
> >> just sit there so when it crashes (and I press the reset button to
> >> recover) I'll have some sort of trace. It would be nice to prove it's
> >> not the disk stack at fault ...
> >>
> >> Obviously, "set these options in the kernel" won't faze me ...
> >>
> >> Cheers,
> >> Wol
