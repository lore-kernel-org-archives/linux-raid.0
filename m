Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0AE8C433B4
	for <linux-raid@archiver.kernel.org>; Mon,  5 Apr 2021 17:46:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BB6961396
	for <linux-raid@archiver.kernel.org>; Mon,  5 Apr 2021 17:46:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233140AbhDERq5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 5 Apr 2021 13:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232131AbhDERq4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 5 Apr 2021 13:46:56 -0400
Received: from u17383850.onlinehome-server.com (u17383850.onlinehome-server.com [IPv6:2607:f1c0:83f:ac00::a6:f62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6089DC061756
        for <linux-raid@vger.kernel.org>; Mon,  5 Apr 2021 10:46:50 -0700 (PDT)
Received: by u17383850.onlinehome-server.com (Postfix, from userid 5001)
        id B8A2779A; Mon,  5 Apr 2021 13:46:49 -0400 (EDT)
Date:   Mon, 5 Apr 2021 13:46:49 -0400
From:   David T-G <davidtg-robot@justpickone.org>
To:     Linux RAID list <linux-raid@vger.kernel.org>
Subject: Re: bitmaps on xfs
Message-ID: <20210405174649.GH1415@justpickone.org>
References: <20210328021210.GA1415@justpickone.org>
 <20210402004001.GH1711@justpickone.org>
 <62cc89ea-b9cf-d8a3-3d52-499fd84f7cc3@youngman.org.uk>
 <20210402050554.GF1415@justpickone.org>
 <CAAMCDecNM8X9tdWo-WKpQA3BE=_J=XKc1D75rcQiQN0owZ9kJQ@mail.gmail.com>
 <20210405034659.GG1415@justpickone.org>
 <CAAMCDecX3nawcYC4hFX+VjQTiHPaZDUb1RcM66=OBFoxhLwY4Q@mail.gmail.com>
 <5f58e78d-8d8c-c66c-7674-79832e22f200@youngman.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f58e78d-8d8c-c66c-7674-79832e22f200@youngman.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Wol & Roger, et al --

...and then antlists said...
% 
% On 05/04/2021 12:30, Roger Heflin wrote:
% >>   diskfarm:~ # grep /mnt/ssd /etc/fstab
% >>   LABEL=diskfarm-ssd      /mnt/ssd        xfs     defaults        0  0
% >>
% >>will work for my bitmap files target, since all I see is that it must be
% >>an ext2 or ext3 (not ext4? old news?) device.
% 
% Bear in mind you're better off using a journal (and bitmaps and
% journals are incompatible).

A journal of the filesystem (XFS or ReiserFS) on the RAID5 device?  Or a journal
of the actual md?

  diskfarm:~ # df -kh /mnt/4Traid5md/ /mnt/750Graid5md/
  Filesystem      Size  Used Avail Use% Mounted on
  /dev/md0p1       11T   11T  309G  98% /mnt/4Traid5md
  /dev/md127p1    1.4T  1.4T   14G 100% /mnt/750Graid5md

  diskfarm:~ # mount | grep /dev/md
  /dev/md0p1 on /mnt/4Traid5md type xfs (rw,relatime,attr2,inode64,logbufs=8,logbsize=32k,sunit=1024,swidth=2048,noquota)
  /dev/md127p1 on /mnt/750Graid5md type reiserfs (rw,relatime)


% 
...
% >I am about to do some array reworks to go from all 3tb disks to start
% >using some 6tb disks.   If the file was pre-allocated I would not
...
% >
% Umm... don't use all the space on your 6TB disks. I'm planning to
% build my arrays on dm-integrity, which will make raid 5 a bit more
% trustworthy.
[snip]

Oooh, something else to learn :-)  I hope to go from 4 drives to 6 when I
do, and I'll be buying the best GB/$ at the time, but it will also be a
grow-over-time thing.


Thanks again & HAND

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

