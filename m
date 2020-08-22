Return-Path: <SRS0=RtKw=CA=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC373C433DF
	for <linux-raid@archiver.kernel.org>; Sat, 22 Aug 2020 19:22:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADBDD2072D
	for <linux-raid@archiver.kernel.org>; Sat, 22 Aug 2020 19:22:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="Vto9YoLC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728631AbgHVTWj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 22 Aug 2020 15:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728611AbgHVTWi (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 22 Aug 2020 15:22:38 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4DE0C061573
        for <linux-raid@vger.kernel.org>; Sat, 22 Aug 2020 12:22:37 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id u18so4803144wmc.3
        for <linux-raid@vger.kernel.org>; Sat, 22 Aug 2020 12:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SkE5E6RfPJupnIixJ+G0Ob14vJltAP5WRguUmF5dVmQ=;
        b=Vto9YoLCGn3z8HmBYrQaEaHvY3gMNdxr0yB9VXXsg8lNe19KtIbyVnl60EgJL2JoZP
         mBbmito73jVFFjnY7fEz142kI1lAb16JttGgWV6JYGMuNtTxDvpud4bseyFkdtdq4V3y
         UDOyloUjilK3wv+5K3v9hVOir8NMGjkl91eJPVMpHMjedt0O6muqu+G/G6U8hRzVqDcU
         D/tmA12xeWyQeFBkC/mcw4xowEgT5oWmQWmzN5mqSpISg8K9j8nweJTuFS1W+MwMTlqe
         w75U+eiaqcb1NU5Bdv1PC9V12+qg8KSKrq6oHLkvFbeBKBJmtn3aQcZmqlTrVrmFiWPj
         6qcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SkE5E6RfPJupnIixJ+G0Ob14vJltAP5WRguUmF5dVmQ=;
        b=LxKjR+Qz2bhZUxLJeooJkgLcpk9qpvDZe2H+pyxen9OsWyG48drJu/HyBfoIiLOlDB
         QYOhALjN+XuQB7NYxKXs0gHVxrRJI6Pi97sduTM36FLWzDQ8mTuVMDPIr9tEqSW74ctI
         L+BYXO8uocPOTmaO5AXd3rs/zUd8VKMWy85AoYwZQrHRfRCbJRQar0QhC7StopZGtS3C
         +IQrMqQEfe7aCa5G2FCxdE/n8X3GXwPB0HKhekpxpUq7nJjtWxJbRa8N2RtZaSd03nqg
         Bi16ShrcuFU/hV697ViGPftsBgEGAu7pXA0UvtABsmp8UXS/vRmlFxATQ/LzsZJ2Xfvw
         PJ4A==
X-Gm-Message-State: AOAM533gAc4qnGL1Ap1tdnYgG0Ib2Q9HCau/g45WQ7ML5RvTYRnbuR7P
        IEk+yIfdQYfWmcfhbvxhUKzCDiMba3UIcvN1HkWgp1RyWF9G0A==
X-Google-Smtp-Source: ABdhPJyu2/gjSayBpn5487GFeCZB4aZDo5w7IPmzlm48/9LAwTxuIzo4WIQW167xXJmdk6DKD+nFvhYLoDIHX15pYQM=
X-Received: by 2002:a7b:cc13:: with SMTP id f19mr8512979wmh.168.1598124156088;
 Sat, 22 Aug 2020 12:22:36 -0700 (PDT)
MIME-Version: 1.0
References: <CAF-KpgYcEF5juR9nFPifZunPPGW73kWVG9fjR3=WpufxXJcewg@mail.gmail.com>
 <1381759926.21710099.1597158389614.JavaMail.zimbra@karlsbakk.net>
 <4a7bfca8-af6e-cbd1-0dc4-feaf1a0288be@fritscher.net> <5F32F56C.7040603@youngman.org.uk>
 <05661c44-8193-6bba-67c9-4e0d220eb348@suddenlinkmail.com> <24384.51317.30569.169686@cyme.ty.sabi.co.uk>
 <5F40E7A0.8040802@youngman.org.uk>
In-Reply-To: <5F40E7A0.8040802@youngman.org.uk>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Sat, 22 Aug 2020 13:21:55 -0600
Message-ID: <CAJCQCtQeFv1PXUbLzv6S3-2UY3Fi=drFaad+0crf72FdqgrNMw@mail.gmail.com>
Subject: Re: Recommended filesystem for RAID 6
To:     Wols Lists <antlists@youngman.org.uk>
Cc:     Peter Grandi <pg@mdraid.list.sabi.co.uk>,
        list Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, Aug 22, 2020 at 3:38 AM Wols Lists <antlists@youngman.org.uk> wrote:
>
> On 22/08/20 08:25, Peter Grandi wrote:
> >>> [...] Note that it IS a shingled drive, so fine for backup,
> >>> >> much less so for anything else.
> > It is fine for backup especially if used as a tape that is say
> > divided into partitions and backup is done using 'dd' (but
> > careful if using Btrfs) or 'tar' or similar. If using 'rsync' or
> > similar those still write a lot of inodes and often small files
> > if they are present in the source.
> >
> The idea is an "in place" rsync, with lvm or btrfs or something
> providing snapshots.
>
> That way, I have full backups each of which only takes up the marginal
> space required by an incremental :-)

In the case where the source and the destination are Btrfs, there can
be an advantage to using 'btrfs send' and 'btrfs receive'. No deep
traversal is required on either send or receive side, to determine the
incremental changes between two snapshots.


-- 
Chris Murphy
