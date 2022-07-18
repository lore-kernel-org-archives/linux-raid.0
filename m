Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9FC9C43334
	for <linux-raid@archiver.kernel.org>; Mon, 18 Jul 2022 15:56:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbiGRP4L (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 18 Jul 2022 11:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiGRP4L (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 18 Jul 2022 11:56:11 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 584D42983E
        for <linux-raid@vger.kernel.org>; Mon, 18 Jul 2022 08:56:10 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id a9so9011395qtw.10
        for <linux-raid@vger.kernel.org>; Mon, 18 Jul 2022 08:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rp2+eUc3BKWHV/TysS0FTzDZ4/cvLyoQ0lM1ZAm7XnU=;
        b=aygfO83u/+ZbwbL2OX+YetnIj07t/+B8wBrMEkPCn1hNiFjXVklnwGZG9AfglpwD+i
         PQ38l+WIlRMF79xKwlngoN2i7Jf0qQc4knjPm+n7OZftXKch0tz7oV0fofaaAs1owczd
         r5jV7A/eqb0To25I4Oq8QkHjUO543TK7M8FME9L7SV/6kJspviXDjgds3G/2rxv14MRA
         GyvcAdfRwqk7ecBV39pTRs/9LnJdvJXrUixixxBgAxvJekFCA0GAo5q1EFz5IjCx5++P
         3IQNmweMLlda4hqcu7CsL73vWzrIFc9OS+dvle48JJtdyiBSNoIc3Z9AtLz43gD+1OyJ
         yH6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rp2+eUc3BKWHV/TysS0FTzDZ4/cvLyoQ0lM1ZAm7XnU=;
        b=CyfdMNWl/ZHteBJBDGkl1NVMXHQK0vvT7fgDU+xUP4iKssAPJPFgisjS4T3fxZN9pe
         PSbqMLxwmv0u90ebxfb5xAbSfkJquAgScbFnM501zwM7vNJ6YybIFl+Ti6mYm/qUdP7Q
         ddJhdwvVToLlthHdSEmi+eUriVEAy+2x+wioH7GKWLqn4uw3D+PzSsP0UsYsoejrJBCB
         o1OztRM6WHN2PD1pFKckC5v+rQMMOflqRbEfZLrQup/KFnEDqn2UL/wihISUxr8T2ICn
         sCIevtnDjqfWAKfi1an5DZRE4sfKY1/gsXE5LWrkA3CmsDpXE3zTEX5o4ipEHOUdkIQf
         sW8g==
X-Gm-Message-State: AJIora8c7pvIi4FV0MnqSD7QXFJME4YDzjJNDTAHLent7Mk9gOi7eqIt
        QTBhFtd3PsPBHDYEAUbSsMg2K8tVtYpEa9DKBqsqhzUg
X-Google-Smtp-Source: AGRyM1sgAUo9DKvcxoImE6VoE/npbA93V4L84bcPzggp6cY4Yc3cJ0LGaXUa25ySmN6w0VGTeJ9UfP4dEEf1F2Faha4=
X-Received: by 2002:ac8:5a84:0:b0:31e:f60e:3449 with SMTP id
 c4-20020ac85a84000000b0031ef60e3449mr2086911qtc.57.1658159769320; Mon, 18 Jul
 2022 08:56:09 -0700 (PDT)
MIME-Version: 1.0
References: <87o7xmsjcv.fsf@esperi.org.uk>
In-Reply-To: <87o7xmsjcv.fsf@esperi.org.uk>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Mon, 18 Jul 2022 10:55:58 -0500
Message-ID: <CAAMCDedjxExrNv7wke97+UgCbUv8=8H+d1DTKBz-xJSRY7g-tg@mail.gmail.com>
Subject: Re: 5.18: likely useless very preliminary bug report: mdadm raid-6
 boot-time assembly failure
To:     Nix <nix@esperi.org.uk>
Cc:     Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Did it drop you into the dracut shell (since you do not have
scroll-back this seem the case?  or the did the machine fully boot up
and simply not find the arrays?

If it dropped you to the dracut shell, add nofail on the fstab
filesystem entries for the raids so it will let you boot up and debug.
Also make sure you don't have rd_lvm_(vg|lv)= set to the devices used
for the raid on the kernel command like (this will also drop you to
dracut).

I have done that on my main server, the goal is to avoid the
no-network/no-logging dracut shell if at all possible so it can be
debugged on the network.

If it is inside the dracut shell it sounds like something in the
initramfs might be missing.  I have seen a dracut (re)build "fail" to
determining that a device driver is required and not include it in the
initramfs, and/or have seen the driver name change and the new kernel
and dracut not find the new name.  If it is this then building a
hostonly=no (include all drivers) would likely make it work for the
immediate future.

I have also seen newer versions of software stacks/kernels
create/ignore underlying partitions that worked on older versions (ie
a partition on a device that has the data also--sometimes a
partitioned partition).

Newer version have suddenly saw that /dev/sda1 was partitioned and
created a /dev/sda1p1 and "hidden" sda1 from scanning causing LVM not
not find pvs.

I have also seen where the in-use/data device was /dev/sda1p1 and an
update broke partitioning a partition so only showed /dev/sda1, and so
no longer sees the devices.





On Mon, Jul 18, 2022 at 8:16 AM Nix <nix@esperi.org.uk> wrote:
>
> So I have a pair of RAID-6 mdraid arrays on this machine (one of which
> has a bcache layered on top of it, with an LVM VG stretched across
> both). Kernel 5.16 + mdadm 4.0 (I know, it's old) works fine, but I just
> rebooted into 5.18.12 and it failed to assemble. mdadm didn't display
> anything useful: an mdadm --assemble --scan --auto=md --freeze-reshape
> simply didn't find anything to assemble, and after that nothing else was
> going to work. But rebooting into 5.16 worked fine, so everything was
> (thank goodness) actually still there.
>
> Alas I can't say what the state of the blockdevs was (other than that
> they all seemed to be in /dev, and I'm using DEVICE partitions so they
> should all have been spotted) or anything else about the boot because
> console scrollback is still a nonexistent thing (as far as I can tell),
> it scrolls past too fast for me to video it, and I can't use netconsole
> because this is the NFS and loghost server for the local network so all
> the other machines are more or less frozen waiting for NFS to come back.
>
> Any suggestions for getting more useful info out of this thing? I
> suppose I could get a spare laptop and set it up to run as a netconsole
> server for this one boot... but even that won't tell me what's going on
> if the error (if any) is reported by some userspace process rather than
> in the kernel message log.
>
> I'll do some mdadm --examine's and look at /proc/partitions next time I
> try booting (which won't be before this weekend), but I'd be fairly
> surprised if mdadm itself was at fault, even though it's the failing
> component and it's old, unless the kernel upgrade has tripped some bug
> in 4.0 -- or perhaps 4.0 built against a fairly old musl: I haven't even
> recompiled it since 2019. So this looks like something in the blockdev
> layer, which at this stage in booting is purely libata-based. (There is
> an SSD on the machine, but it's used as a bcache cache device and for
> XFS journals, both of which are at layers below mdadm so can't possibly
> be involved in this.)
>
> --
> NULL && (void)
