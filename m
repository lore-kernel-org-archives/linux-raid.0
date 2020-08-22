Return-Path: <SRS0=RtKw=CA=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA573C433E1
	for <linux-raid@archiver.kernel.org>; Sat, 22 Aug 2020 18:51:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7614320714
	for <linux-raid@archiver.kernel.org>; Sat, 22 Aug 2020 18:51:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="OMKNzwZ1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728329AbgHVSvf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 22 Aug 2020 14:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727856AbgHVSve (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 22 Aug 2020 14:51:34 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F3FC061573
        for <linux-raid@vger.kernel.org>; Sat, 22 Aug 2020 11:51:34 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id z18so4852384wrm.12
        for <linux-raid@vger.kernel.org>; Sat, 22 Aug 2020 11:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SC0SypEUcxsLxkFtndQhHjNjwmhauWaHSMv7bSyTACg=;
        b=OMKNzwZ1YdR58/NPLV88OFNLYzH9zsqddVlF7Rp395+j8YyB6vj8MS7dfR3iS+ZvGL
         PcHkzU+789FKTJxsIbqeJW+SHVIipkawvfkyOmREDvURWCs/g850//swWmy36jkH6Saf
         nh3+7J/3DRmTOddZZoIQtNGJf9qVPE39Uyq1SpDwzMQ477V/7HIrrihsYGccJD4mm+BB
         yLvjwVKdVtSfAUK/e1Lo2slSZEJBimdNjCb4vNQbP3aH9DJrqkJmogHLj1jexPGsGyyM
         kV4l5PtcehRkHDA1ys2CETBES43kQT/7yNzSX4QthZCpiOmXX5jxYc4YVVQ3mIITXfQv
         ArRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SC0SypEUcxsLxkFtndQhHjNjwmhauWaHSMv7bSyTACg=;
        b=OfbOSeUtZXqYct+MgqXBlDLCKqUNFth8g2ibGPa5U2DUk8rohWqbQau6ofRflDJfcP
         SppR1KUWxMvx4XWUI+0am5V/0qliHES2bMsZ4Qf+NUHGeLv8vemrVeFtKIgLOtd+HA1s
         jjEc3C+88RABpamQYmB4BwIpngOQb7uVnDobasOckSM4kJhvE1amVL+Ed+0dXFyXQIf0
         FIzP7DzuW94CVoMylawECt6l4QCIsZ83diaqxKptxRf8gPb2H5RYSBfBd86FhAX28dys
         o/+Mq3Z/djQvcqjzOBaOYA2mwFwfF7Bshk6Iw+z1G9OSjsWyPUcVf7SEdbvVNs4aNhGS
         jecA==
X-Gm-Message-State: AOAM533P/jd3awMaS7UcyFznCl+QRGJpX5o/vbvRim/rcP6Bt4fmCeln
        KjMF7Oo9DB2PtNGmCTF2ORjiulaJ2vGqMrAQXnAtnoGg5btv4n2P
X-Google-Smtp-Source: ABdhPJzSk8qCZ4d3rQLEMcNEBJKuYsD6trRG2/cu9fSHE7qCiurk9ArxoQP++mOQOhLk9UI1+/9KzItMtpMwwE1ZAWw=
X-Received: by 2002:adf:aace:: with SMTP id i14mr7848954wrc.236.1598122290731;
 Sat, 22 Aug 2020 11:51:30 -0700 (PDT)
MIME-Version: 1.0
References: <CAF-KpgYcEF5juR9nFPifZunPPGW73kWVG9fjR3=WpufxXJcewg@mail.gmail.com>
 <1381759926.21710099.1597158389614.JavaMail.zimbra@karlsbakk.net>
 <4a7bfca8-af6e-cbd1-0dc4-feaf1a0288be@fritscher.net> <5F32F56C.7040603@youngman.org.uk>
In-Reply-To: <5F32F56C.7040603@youngman.org.uk>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Sat, 22 Aug 2020 12:50:50 -0600
Message-ID: <CAJCQCtRkLmfQ9BHy1ymYU=LC95LA2b2-Pyf_Gm8X06cza1YUjw@mail.gmail.com>
Subject: Re: Recommended filesystem for RAID 6
To:     Wols Lists <antlists@youngman.org.uk>
Cc:     Linux-RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Aug 11, 2020 at 1:47 PM Wols Lists <antlists@youngman.org.uk> wrote:
>
> On 11/08/20 20:19, Michael Fritscher wrote:
> > Hi,
> >
> > if you really want to use these tiny 2 TB HDDs - yes, RAID 6 (2x - the
> > second for the backup system on a physically different location) is a
> > good choice.
> >
> > But: If you can, buy some 8-12 TB HDDs and forget the old rusty tiny
> > HDDs. You'll save a lot at the system - and power.
> >
> I'm looking at one of these ...
> https://www.amazon.co.uk/Seagate-ST8000DM004-Barracuda-internal-Silver/dp/B075WYBQXJ/ref=pd_ybh_a_8?_encoding=UTF8&psc=1&refRID=WF1CTS2K9RWY96D1RENJ
>
> Note that it IS a shingled drive, so fine for backup, much less so for
> anything else.

How can you tell? From the spec, I can't find anything that indicates
it. Let alone which of three varieties it is.
https://www.seagate.com/www-content/product-content/barracuda-fam/barracuda-new/en-us/docs/100805918d.pdf

>I'm not sure whether btrfs would be a good choice or not ...

Btrfs tries to write sequentially, both data and metadata, which
favors SMR drives.

For device managed SMR there are some likely optimizations to help
avoid random writes. Top on that list is for the workload to avoid
fsync. And also using mount options: longer commit time, notreelog,
space_cache v2, and nossd. If the drive reports rotational in sysfs,
then nossd is used by default. Space cache v2 is slated to become the
default soon.

For host managed SMR there are significant requirements. Including a
log structured super block.
https://lwn.net/Articles/806327/

Quite a lot of preparatory work has been happening before this series
lands in mainline. For other file systems, I'm not sure, but my guess
is using dm-zoned, basically making non-sequential writes from XFS and
ext4 into sequential writes and ensuring the various alignment
requirements.


-- 
Chris Murphy
