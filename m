Return-Path: <SRS0=RtKw=CA=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8350C433E1
	for <linux-raid@archiver.kernel.org>; Sat, 22 Aug 2020 19:04:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C3562075E
	for <linux-raid@archiver.kernel.org>; Sat, 22 Aug 2020 19:04:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="MIA298aN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728580AbgHVTE7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 22 Aug 2020 15:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728398AbgHVTE6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 22 Aug 2020 15:04:58 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E09C061573
        for <linux-raid@vger.kernel.org>; Sat, 22 Aug 2020 12:04:58 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id 88so4893208wrh.3
        for <linux-raid@vger.kernel.org>; Sat, 22 Aug 2020 12:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j9Z2ZW6Cctw5BgbGpw2TWHiuWxHrSuFhMcYLxXqX6aU=;
        b=MIA298aNce5S++c1MkcdGxO7y9ZAvb3VOAYzZoCORMi777ATyr9b5g75QQ1JURvGuB
         Z5pGc3IALynxLlINFHrWKSIbcQy91w68PjlnnRmJyCgCvcz9u2/Ae66lYO8FQyadnNPO
         AT9UgUJ8Ageptxycw15TqwUdWz5MY2NycHqnRdxhcil6kVlfKWhimVEYgNJhQAReQWG0
         O3ntwTsf1x8hgmVq4xWuKmmUwmg/f1NsUURB+gNNrm28rXObypl6MD9jRrguFhSr33XJ
         nL3AM13HmzYftZQeWVO8YhAjOiZyMMCDcd8OSWWVcf8Bm/3kitnTe5ciGTcaifBJQh3R
         gBIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j9Z2ZW6Cctw5BgbGpw2TWHiuWxHrSuFhMcYLxXqX6aU=;
        b=glt/zX+UhNMmXR6MsGJudY35hEX5qN9CULo1LxtfbKLeQPGCi1q+H8KbsJxQ84SGOR
         sxYdmnaqvPiU2aXWSxYq6TDBBmWfXqluPGEqmtj7D7hSpkZ5XdgacYfw2biBo1lG2Vt3
         tspCN36jD5+lrQ0wG4tG+lwxm9nIiW4aHkDlXVxNYDINXQ6rLXflaOtiZz4NhDyNyHe5
         0XhIMn2byWAF36XkAUakvTMZKRt/s7fcGnjq5muVOkhHSOj1dWWpRFW+sHRLFztRzTqB
         3YML2qNPRJ1fBlqQE7VlAG+1REvc5bGVghQDczY3c+BO/7qVaW/BhvXN+fjaKiHe2FTx
         FMBg==
X-Gm-Message-State: AOAM5303dVVHpnY6msUphpWpLKvJ/zCfKdVCpKYYI4/j/kafzOq9V1GG
        Xbx2KcM4fmbz6pDvjuXuk7LOfSi6Ic2dWfEA3L2Zn9AWHlGOZSqY
X-Google-Smtp-Source: ABdhPJySjdUyJZYKUnhR/V0LZehbY0THQnJGGjM7FP0ynjMsAtLWXDCdKFpzBt7dGx9/6viKHdT9ywe1wo+BzKK/jLI=
X-Received: by 2002:adf:8401:: with SMTP id 1mr2074500wrf.274.1598123095653;
 Sat, 22 Aug 2020 12:04:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAF-KpgYcEF5juR9nFPifZunPPGW73kWVG9fjR3=WpufxXJcewg@mail.gmail.com>
 <1381759926.21710099.1597158389614.JavaMail.zimbra@karlsbakk.net>
 <4a7bfca8-af6e-cbd1-0dc4-feaf1a0288be@fritscher.net> <5F32F56C.7040603@youngman.org.uk>
 <05661c44-8193-6bba-67c9-4e0d220eb348@suddenlinkmail.com> <24384.51317.30569.169686@cyme.ty.sabi.co.uk>
In-Reply-To: <24384.51317.30569.169686@cyme.ty.sabi.co.uk>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Sat, 22 Aug 2020 13:04:15 -0600
Message-ID: <CAJCQCtSvxiT2eQwJ6z1LA8Qv5km0HM9w2HNd1fMzhWoFiUHY3Q@mail.gmail.com>
Subject: Re: Recommended filesystem for RAID 6
To:     Peter Grandi <pg@mdraid.list.sabi.co.uk>
Cc:     list Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, Aug 22, 2020 at 1:25 AM Peter Grandi <pg@mdraid.list.sabi.co.uk> wrote:
>
> >> [...] Note that it IS a shingled drive, so fine for backup,
> >> much less so for anything else.
>
> It is fine for backup especially if used as a tape that is say
> divided into partitions and backup is done using 'dd' (but
> careful if using Btrfs) or 'tar' or similar. If using 'rsync' or
> similar those still write a lot of inodes and often small files
> if they are present in the source.
>
> >> I'm not sure whether btrfs would be a good choice or not ...
>
> > [...] btrfs did NOT play well with raid 5/6. It may be old
> > info, but:
> > https://superuser.com/questions/1131701/btrfs-over-mdadm-raid6
>
> That seems based on some misunderstanding: native Btrfs 5/6 has
> some "limitations", like most of its volume management, but
> running over MS RAID 5/6 is much the same as running on top of a
> single disk, so fine. MD RAID 5/6 takes care of redundancy so
> there is no need to have metadata in 'dup' mode.

True but dup metadata is a small cost to have self-healing file system
metadata. While read errors mean md will reconstruct from parity, and
Btrfs would be none the wiser, Btrfs is more sensitive to certain
kinds of metadata loss than other file systems.

Where dup is pointless is the case of deduplication by SSDs with
concurrent writes, and dup metadata uses concurrent writes - i.e. it's
not going to delay writing one of the copies which is what it'd take
to thwart common internal SSD optimizations. Even those that don't
dedup, concurrent writes end up on the same erase block. And if
there's a hardware failure, it tends to affect an entire erase block.

> Using RAID 5/6 with SMR drives can result in pretty huge delays
> (IIRC a previous poster has given some relevant URL) on writing
> or on rebuilding, as the "chunk" size is very likely not to be
> very congruent with the SMT zones.

At least hmzoned Btrfs will disable features considered incompatible
with SMR: raid56, nodatacow (overwrites), and fallocate which also
implies overwrites.

-- 
Chris Murphy
