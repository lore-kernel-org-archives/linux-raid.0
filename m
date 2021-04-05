Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EEC4C433ED
	for <linux-raid@archiver.kernel.org>; Mon,  5 Apr 2021 03:47:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00F2261369
	for <linux-raid@archiver.kernel.org>; Mon,  5 Apr 2021 03:47:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbhDEDrG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 4 Apr 2021 23:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbhDEDrG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 4 Apr 2021 23:47:06 -0400
Received: from u17383850.onlinehome-server.com (u17383850.onlinehome-server.com [IPv6:2607:f1c0:83f:ac00::a6:f62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A18A6C061756
        for <linux-raid@vger.kernel.org>; Sun,  4 Apr 2021 20:47:00 -0700 (PDT)
Received: by u17383850.onlinehome-server.com (Postfix, from userid 5001)
        id 4A1C37A0; Sun,  4 Apr 2021 23:46:59 -0400 (EDT)
Date:   Sun, 4 Apr 2021 23:46:59 -0400
From:   David T-G <davidtg-robot@justpickone.org>
To:     Linux RAID list <linux-raid@vger.kernel.org>
Subject: Re: bitmaps on xfs (was "Re: how do i bring this disk back into the
 fold?")
Message-ID: <20210405034659.GG1415@justpickone.org>
References: <20210328021210.GA1415@justpickone.org>
 <20210402004001.GH1711@justpickone.org>
 <62cc89ea-b9cf-d8a3-3d52-499fd84f7cc3@youngman.org.uk>
 <20210402050554.GF1415@justpickone.org>
 <CAAMCDecNM8X9tdWo-WKpQA3BE=_J=XKc1D75rcQiQN0owZ9kJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAMCDecNM8X9tdWo-WKpQA3BE=_J=XKc1D75rcQiQN0owZ9kJQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Roger, et al --

...and then Roger Heflin said...
% 
% The re-add will only work if the array has bitmaps.  For quick disk

Ahhhhh...  Good point.

It didn't really take 9 hours; a few minutes later it was up to 60+
hours, and then it dropped to a couple of hours and was done the next
time I looked.  I also forced the other array using just the last two
drives and saw everything happy, so I then added the "first" drive and
now it's all happy as well.  Woo hoo.


% hiccups the re-add is nice because instead of 9 hours, often it
% finishes in only a few minutes assuming the disk has not been out of
% the array for long.

I love the idea.  I've been reading up, and in addition to questions of
what size bitmap I need for my sizes

  diskfarm:~ # df -kh /mnt/4Traid5md/ /mnt/750Graid5md/
  Filesystem      Size  Used Avail Use% Mounted on
  /dev/md0p1       11T   11T  309G  98% /mnt/4Traid5md
  /dev/md127p1    1.4T  1.4T   14G 100% /mnt/750Graid5md

and how to tell it (or *if* I tell it; that still isn't clear) there's
also the question of whether or not xfs

  diskfarm:~ # grep /mnt/ssd /etc/fstab
  LABEL=diskfarm-ssd      /mnt/ssd        xfs     defaults        0  0

will work for my bitmap files target, since all I see is that it must be
an ext2 or ext3 (not ext4? old news?) device.

Anyway, thanks again for the sanity checks and pointers.  It's good to be
whole again :-)  I look forward to the day when I can dig into growing to
more larger disks and have to contemplate reshaping from RAID5 to RAID6 :-)


HAND

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

