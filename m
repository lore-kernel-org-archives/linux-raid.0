Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE25FC433F5
	for <linux-raid@archiver.kernel.org>; Mon, 11 Oct 2021 07:50:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90D2B6056B
	for <linux-raid@archiver.kernel.org>; Mon, 11 Oct 2021 07:50:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234656AbhJKHwA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 11 Oct 2021 03:52:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55030 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234625AbhJKHv5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 11 Oct 2021 03:51:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633938597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3qqrv9XMwmyzSCAT9HOBEBajfN1wyU+0aKu4BbhD+WY=;
        b=PrVUHj93IefNOnf5De+11wg4w7xrBl7L+DTB8o7RCmxF5DOuOJLeadrpQc4R75CoYIYf4R
        mxHQ4YHQQNnUZrPmhWoZqR42OvJhMFJN6/Mp/cet0tO9YW63KSPw/omvgqkAC2RRyapy94
        4l68D66Xqs/tURTiKrr1h5ToKlyXh20=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-602-n2BekMOAMlq98zZdoS66MQ-1; Mon, 11 Oct 2021 03:49:56 -0400
X-MC-Unique: n2BekMOAMlq98zZdoS66MQ-1
Received: by mail-ed1-f72.google.com with SMTP id h19-20020aa7de13000000b003db6ad5245bso6490359edv.9
        for <linux-raid@vger.kernel.org>; Mon, 11 Oct 2021 00:49:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3qqrv9XMwmyzSCAT9HOBEBajfN1wyU+0aKu4BbhD+WY=;
        b=L2vB2KyZbm1cavpUauJ0+/c+eLeY15lRaWEdoTx+wHfRJa0k7HQhOTctNBKD9CpLdi
         sKBBtvrOxYc+IOq+ImEYYMRzvW9N7hkU7FCr1c/1XgJhEhCREfyA81FC9NK9zXl1XFSr
         gUhQoGg3PuaSaSK3doi2S1CBEu0odWeGQsoFNp9cRFbiCDWk1x2SKofS1pOsMeiWAqQK
         f4gFXwPHUrQ2D+RpYA5tDYoAFlT6YpDB5hbesr8mQt4IoGbRlLmaSLaYemfUhxR5xCxm
         LzOq6JKxQAdJREP25oLgyjmYfuTSFIxO1b2DvDNLpHVb665zVZ9wrqyq11hkhEsSOdhe
         7SVg==
X-Gm-Message-State: AOAM533gamI8MMJfYuAIs1jaLCwc9V1DIqJZhn8zjZHnaSmu0GXZBS/C
        iZ4+XFOPGwQ9UDJ6194FEw3A3auG1LoCTME9zzjZUvuWjd13Sbqhbbd3abOsYVrLFh1FrUsqoxP
        P6Hk6NN8ah8pz+q/O7GByNLSSV7Ko/HMm8CYADg==
X-Received: by 2002:a17:906:712:: with SMTP id y18mr23264720ejb.408.1633938595522;
        Mon, 11 Oct 2021 00:49:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxcsgmGkDj767ghqvU3WJZCfGbpa7roToTs6zdyTFywS44/zg0bJae92rBiiw0MC/WXlSU3j02FTgJK8XhuKx4=
X-Received: by 2002:a17:906:712:: with SMTP id y18mr23264703ejb.408.1633938595351;
 Mon, 11 Oct 2021 00:49:55 -0700 (PDT)
MIME-Version: 1.0
References: <20211008032231.1143467-1-fengli@smartx.com> <CAPhsuW5+bdQwsyjBP=QDGRbtnF021291D_XrhNtV+v-geVouVg@mail.gmail.com>
In-Reply-To: <CAPhsuW5+bdQwsyjBP=QDGRbtnF021291D_XrhNtV+v-geVouVg@mail.gmail.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Mon, 11 Oct 2021 15:49:45 +0800
Message-ID: <CALTww28b0HGzSTTNGVzeZdRp0nGMDAyY8sQ+cBsSCuYJ4jMaqw@mail.gmail.com>
Subject: Re: [PATCH RESEND] md: allow to set the fail_fast on RAID1/RAID10
To:     Song Liu <song@kernel.org>
Cc:     Li Feng <fengli@smartx.com>,
        "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" 
        <linux-raid@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi all

Now the per device sysfs interface file state can change failfast. Do
we need a new file for failfast?

I did a test. The steps are:

mdadm -CR /dev/md0 -l1 -n2 /dev/sdb /dev/sdc --assume-clean
cd /sys/block/md0/md/dev-sdb
echo failfast > state
cat state
in_sync,failfast

Best Regards
Xiao

On Sat, Oct 9, 2021 at 7:36 AM Song Liu <song@kernel.org> wrote:
>
> On Thu, Oct 7, 2021 at 8:22 PM Li Feng <fengli@smartx.com> wrote:
> >
> > When the running RAID1/RAID10 need to be set with the fail_fast flag,
> > we have to remove each device from RAID and re-add it again with the
> > --fail_fast flag.
> >
> > Export the fail_fast flag to the userspace to support the read and
> > write.
> >
> > Signed-off-by: Li Feng <fengli@smartx.com>
>
> Thanks for the patch! I applied it to md-next, with some changes in the
> commit log.
>
> Thanks,
> Song
>

