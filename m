Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5C3FC433F5
	for <linux-raid@archiver.kernel.org>; Tue, 16 Nov 2021 07:54:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B66F761BF9
	for <linux-raid@archiver.kernel.org>; Tue, 16 Nov 2021 07:54:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbhKPH5f (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 16 Nov 2021 02:57:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:26067 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231683AbhKPH47 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Tue, 16 Nov 2021 02:56:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637049242;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=agWugGb7TZxvlRRQjX98ZiZijFBPClPvfTU+u9UU6fo=;
        b=Us+lVLK9Y9I91iqMk/2sqezY4uvnMyLS3DNCg2kdnxjcBMxOoxvZoIb37CHa/x9zn+Uqaf
        NGDjh+CStk+ryDjzTXZzUzp6aJnIX3F9uEPuvTo6DvDPv9814WLSTBXo0mFn2l/05TDKHg
        jJu2sIj5NpVld0nkv/zDwhfnbl8jqm4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-mBMGrtjmPDiBWxTvv_rivw-1; Tue, 16 Nov 2021 02:53:57 -0500
X-MC-Unique: mBMGrtjmPDiBWxTvv_rivw-1
Received: by mail-ed1-f71.google.com with SMTP id y9-20020aa7c249000000b003e7bf7a1579so5017236edo.5
        for <linux-raid@vger.kernel.org>; Mon, 15 Nov 2021 23:53:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=agWugGb7TZxvlRRQjX98ZiZijFBPClPvfTU+u9UU6fo=;
        b=uQhdu8aqLsm9LX8kwed2Jnwby9WCA+jRcwAymIhBIVottXJLKF/IwkcqDCuO0UR6ur
         S5UXUc8J6vaW9sa5hCBr0IS4X6Un2GBGiggVnqylEl9vaUBtagIc13ygGNKws4qMClhW
         De3QlTpV/lxg+wszghrrH7sSvc2tKkkh6xBTryn07ArHZ729uhAiX2HynWg8bp+hYpJ+
         2s1gS6P2oLQLJF5b4+0PsaZftJPoRqd8MhvHJIRE4Z2bGuUTy7jOUBWu7rH+4TXVgp+e
         t9EhClycZWag9deAsEqOAmn02KvKsja/KRLRt0kxSwAD76lLfOpdmtzPp5MDQsgovJIA
         D6cQ==
X-Gm-Message-State: AOAM531PiAmDBAhtu4mUajwdhfPw0EEa8ncweCzaHtCbVD7XKo/kQ4lI
        2Rkbfpb9HHdd0bNdbW6A0X3u96p+mF2cO+hN2mlNmkjz9TUmmde3hkz3BgEX8C8ynoiRcdk7uym
        3LFfKPwb/qYcocTGVRpd3kyZV2FbuVl0HkhXXVw==
X-Received: by 2002:a17:907:774d:: with SMTP id kx13mr7207289ejc.239.1637049236144;
        Mon, 15 Nov 2021 23:53:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyf+lnExXhqZjZapqE0wb7xDRq2sJby4SQnVV+wUPWuRkINOizZ4hb140IWDU7J9yWxPd5u4WNUyPIKtiRAuic=
X-Received: by 2002:a17:907:774d:: with SMTP id kx13mr7207268ejc.239.1637049235922;
 Mon, 15 Nov 2021 23:53:55 -0800 (PST)
MIME-Version: 1.0
References: <20211112142822.813606-1-markus@hochholdinger.net>
 <CALTww28689G2xbZ9sWFpviXLwB1WKPfQL6Y1girjiBMEvWcQRw@mail.gmail.com> <181899007.qP1mJhO4kW@enterprise>
In-Reply-To: <181899007.qP1mJhO4kW@enterprise>
From:   Xiao Ni <xni@redhat.com>
Date:   Tue, 16 Nov 2021 15:53:44 +0800
Message-ID: <CALTww2-wLq1wvTABUft0hBg1gC2Qx+a_fUX2TZMJg0vve2uLBw@mail.gmail.com>
Subject: Re: [PATCH] md: fix update super 1.0 on rdev size change
To:     Markus Hochholdinger <Markus@hochholdinger.net>
Cc:     Song Liu <song@kernel.org>, linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Nov 16, 2021 at 2:39 AM Markus Hochholdinger
<Markus@hochholdinger.net> wrote:
>
> Hi Xiao,
>
> for 1.0 the super block is at the end of the device, out of "man mdadm":
>     -e, --metadata=
>               [..]
>                      The different sub-versions
>                      store the superblock at different locations  on  the  de-
>                      vice, either at the end (for 1.0), at the start (for 1.1)
>                      or 4K from the start (for 1.2).   "1"  is  equivalent  to
>                      "1.2"  (the commonly preferred 1.x format).  "default" is
>                      equivalent to "1.2".
> (Because of other reasons, we have intentionally choosen the superblock at the
> end of the device.)
>
> We change the device size of raid1 arrays, which are inside a VM, on a regular
> basis. And afterwards we grow the raid1 while the raid1 is online. Therefore,
> the superblock has to be moved.

I c. Thanks for giving the test case.

> This is very neat, because we can grow the raid1 and the filesystem size in a
> very short time frame and don't have to rebuild the raid1 twice (remove one
> device, resize and add with full rebuild because the old superblock is
> somewhere inbetween, then the same for the other device) before we can grow
> the raid1 and the filesystem.
> If this explanation is not enough why we need this feature, I can explain in
> more detail why someone would do the software raid1 within a VM if you like.

It's enough. But could you talk more about the reason why create a
raid1 in a vm?
I want to know more scenarios that use raid devices.

>
> As I understand, if the superblock isn't moved and we have grown the array and
> the filesystem on it, the superblock will now be updated inbetween the
> filesystem and may corrupt the filesystem and data.
>
> Funny thing, after both devices are resized, the raid1 is still online and the
> grow does work. But afterwards, one can't do anything with the raid1, you get
> errors about the superblock, e.g. mdadm -D .. works, but mdadm -E .. for both
> devices doesn't. You can remove one device from the raid1, but you can't add
> it anymore, mdadm --add .. says: "mdadm: cannot load array metadata from /dev/
> md0". And you can't re-assemble the raid1 after it is stopped.

mdadm -D reads information from files under /sys/block/md. mdadm -E reads data
from disk. So one works and the other doesn't. And in kernel space, it
doesn't update
the superblock offset, and it still reads superblock from the old
position. But in userspace
it calculates the superblock position based on the disk size. It's in
a mess now.

>
> I can reproduce this: With kernel version <= 5.8.18 the above works as
> expected. Since kernel version 5.9.x it doesn't anymore.
> I tested this patch with kernel 5.15.1 and 5.10.46 and the above works again.
>
>
> Here is a minimal setup to test this (but in real life we use it in a VM with
> virtual disks which can be resized online):
> # truncate -s 1G /var/tmp/rdev1
> # truncate -s 1G /var/tmp/rdev2
> # losetup -f /var/tmp/rdev1
> # losetup -f /var/tmp/rdev2
> # losetup -j /var/tmp/rdev1
> /dev/loop0: [2304]:786663 (/var/tmp/rdev1)
> # losetup -j /var/tmp/rdev2
> /dev/loop1: [2304]:788462 (/var/tmp/rdev2)
> # mdadm --create --assume-clean /dev/md9 --metadata=1.0 --level=1 --raid-
> disks=2 /dev/loop0 /dev/loop1
> mdadm: array /dev/md9 started.
> # mdadm -E /dev/loop0
> /dev/loop0:
>           Magic : a92b4efc
>         Version : 1.0
>     Feature Map : 0x0
> [..]
> # # grow the first loop device by 100MB
> # dd if=/dev/zero bs=1M count=100 >> /var/tmp/rdev1
> 100+0 records in
> 100+0 records out
> 104857600 bytes (105 MB, 100 MiB) copied, 0.0960313 s, 1.1 GB/s
> # losetup -c /dev/loop0
>
> ### with kernel <= 5.8.18 ###
> # mdadm -E /dev/loop0
> mdadm: No md superblock detected on /dev/loop0.
> # echo 0 > /sys/block/md9/md/rd0/size
> # mdadm -E /dev/loop0
> /dev/loop0:
>           Magic : a92b4efc
>         Version : 1.0
>     Feature Map : 0x0
> [..]
> #
>
> ### with kernel >= 5.9.x ###
> # mdadm -E /dev/loop0
> mdadm: No md superblock detected on /dev/loop0.
> # echo 0 > /sys/block/md9/md/rd0/size
> # mdadm -E /dev/loop0
> mdadm: No md superblock detected on /dev/loop0.
> #

Thanks again for those detail steps.
Xiao

