Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02F38C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 20 Jul 2022 16:18:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237271AbiGTQSG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 20 Jul 2022 12:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235444AbiGTQSF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 20 Jul 2022 12:18:05 -0400
Received: from mail.esperi.org.uk (icebox.esperi.org.uk [81.187.191.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E629419AA
        for <linux-raid@vger.kernel.org>; Wed, 20 Jul 2022 09:18:04 -0700 (PDT)
Received: from loom (nix@sidle.srvr.nix [192.168.14.8])
        by mail.esperi.org.uk (8.16.1/8.16.1) with ESMTPS id 26KGI1nS018562
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Wed, 20 Jul 2022 17:18:01 +0100
From:   Nix <nix@esperi.org.uk>
To:     Roger Heflin <rogerheflin@gmail.com>
Cc:     Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: 5.18: likely useless very preliminary bug report: mdadm raid-6
 boot-time assembly failure
References: <87o7xmsjcv.fsf@esperi.org.uk>
        <CAAMCDedjxExrNv7wke97+UgCbUv8=8H+d1DTKBz-xJSRY7g-tg@mail.gmail.com>
Emacs:  a compelling argument for pencil and paper.
Date:   Wed, 20 Jul 2022 17:18:01 +0100
In-Reply-To: <CAAMCDedjxExrNv7wke97+UgCbUv8=8H+d1DTKBz-xJSRY7g-tg@mail.gmail.com>
        (Roger Heflin's message of "Mon, 18 Jul 2022 10:55:58 -0500")
Message-ID: <877d47pxl2.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC--Metrics: loom 1480; Body=2 Fuz1=2 Fuz2=2
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 18 Jul 2022, Roger Heflin told this:

Oh I was hoping you'd weigh in :)

> Did it drop you into the dracut shell (since you do not have
> scroll-back this seem the case?  or the did the machine fully boot up
> and simply not find the arrays?

Well, I'm not using dracut, which is a horrifically complex
failure-prone nightmare as you note: I wrote my own (very simple) early
init script, which failed as it is designed to do when mdadm doesn't
assemble any arrays and dropped me into an emergency ash shell
(statically linked against musl). As a result I can be absolutely
certain that nothing has changed or been rebuilt in early init since I
built my last working kernel. (It's all assembled into an initramfs by
the in-kernel automated assembly stuff under the usr/ subdirectory in
the kernel source tree.)

Having the initramfs linked into the kernel is *such a good thing* in
situations like this: I can be absolutely certain that as long as the
data on disk is not fubared nothing can possibly have messed up the
initramfs or early boot in general after the kernel is linked, because
nothing can change it at all. :)

(I just diffed both initramfses from the working and non-working
kernels: the one in the running kernel I keep mounted under
/run/initramfs after boot is over because it also gets used during late
shutdown, and the one from the new broken one is still in the cpio
archive in the build tree, so this was easy. They're absolutely
identical.)

> If it dropped you to the dracut shell, add nofail on the fstab
> filesystem entries for the raids so it will let you boot up and debug.

Well... the rootfs is *on* the raid, so that's not going to work.
(Actually, it's under a raid -> bcache -> lvm stack, with one of two
raid arrays bcached and the lvm stretching across both of them. If only
the raid had come up, I have a rescue fs on the non-bcached half of the
lvm so I could have assembled it in degraded mode and booted from that.
But it didn't, so I couldn't.)

Assembly does this:

    /sbin/mdadm --assemble --scan --auto=md --freeze-reshape

The initramfs includes this mdadm.conf:

DEVICE partitions
ARRAY /dev/md/transient UUID=28f4c81c:f44742ea:89d4df21:6aea852b
ARRAY /dev/md/slow UUID=a35c9c54:bcdbff37:4f18163e:a93e9aa2
ARRAY /dev/md/fast UUID=4eb6bf4e:7458f1f1:d05bdfe4:6d38ca23

MAILADDR postmaster@esperi.org.uk

(which is again identical on the working kernels.)

> If it is inside the dracut shell it sounds like something in the
> initramfs might be missing.

Definitely not, thank goodness.

>                              I have seen a dracut (re)build "fail" to
> determining that a device driver is required and not include it in the
> initramfs, and/or have seen the driver name change and the new kernel

Oh yes: this is one of many horrible things about dracut. It assumes the
new kernel is similar enough to the running one that it can use the one
to configure the other. This is extremely not true when (as this machine
is) it's building kernels for *other* machines in containers :) but the
thing that failed was the machine's native kernel.

(It is almost non-modular. I only have fat and vfat modules loaded right
now: everything else is built in.)

> I have also seen newer versions of software stacks/kernels
> create/ignore underlying partitions that worked on older versions (ie
> a partition on a device that has the data also--sometimes a
> partitioned partition).

I think I can be sure that only the kernel itself has changed here.
I wonder if make oldconfig messed up and I lost libata or something? ...
no, it's there.

> Newer version have suddenly saw that /dev/sda1 was partitioned and
> created a /dev/sda1p1 and "hidden" sda1 from scanning causing LVM not
> not find pvs.
>
> I have also seen where the in-use/data device was /dev/sda1p1 and an
> update broke partitioning a partition so only showed /dev/sda1, and so
> no longer sees the devices.

Ugh. That would break things indeed! This is all atop GPT...

CONFIG_EFI_PARTITION=y

no it's still there.

I doubt anyone can conclude anything until I collect more info. This bug
report is mostly useless for a reason!
