Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61A92C433ED
	for <linux-raid@archiver.kernel.org>; Mon,  5 Apr 2021 17:58:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 340D86113D
	for <linux-raid@archiver.kernel.org>; Mon,  5 Apr 2021 17:58:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbhDER6c (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 5 Apr 2021 13:58:32 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:20655 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232452AbhDER6c (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 5 Apr 2021 13:58:32 -0400
Received: from host86-156-102-23.range86-156.btcentralplus.com ([86.156.102.23] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1lTTUV-0006dN-CU; Mon, 05 Apr 2021 18:58:24 +0100
Subject: Re: bitmaps on xfs
To:     David T-G <davidtg-robot@justpickone.org>,
        Linux RAID list <linux-raid@vger.kernel.org>
References: <20210328021210.GA1415@justpickone.org>
 <20210402004001.GH1711@justpickone.org>
 <62cc89ea-b9cf-d8a3-3d52-499fd84f7cc3@youngman.org.uk>
 <20210402050554.GF1415@justpickone.org>
 <CAAMCDecNM8X9tdWo-WKpQA3BE=_J=XKc1D75rcQiQN0owZ9kJQ@mail.gmail.com>
 <20210405034659.GG1415@justpickone.org>
 <CAAMCDecX3nawcYC4hFX+VjQTiHPaZDUb1RcM66=OBFoxhLwY4Q@mail.gmail.com>
 <5f58e78d-8d8c-c66c-7674-79832e22f200@youngman.org.uk>
 <20210405174649.GH1415@justpickone.org>
From:   antlists <antlists@youngman.org.uk>
Message-ID: <583e250c-09f2-6c95-c62a-623e29cf0179@youngman.org.uk>
Date:   Mon, 5 Apr 2021 18:58:24 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210405174649.GH1415@justpickone.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 05/04/2021 18:46, David T-G wrote:
> Wol & Roger, et al --
> 
> ...and then antlists said...
> %
> % On 05/04/2021 12:30, Roger Heflin wrote:
> % >>   diskfarm:~ # grep /mnt/ssd /etc/fstab
> % >>   LABEL=diskfarm-ssd      /mnt/ssd        xfs     defaults        0  0
> % >>
> % >>will work for my bitmap files target, since all I see is that it must be
> % >>an ext2 or ext3 (not ext4? old news?) device.
> %
> % Bear in mind you're better off using a journal (and bitmaps and
> % journals are incompatible).
> 
> A journal of the filesystem (XFS or ReiserFS) on the RAID5 device?  Or a journal
> of the actual md?

Journal of the md. I'm thinking raid journal, which fixes the raid-5 
write hole (I don't understand it, but if a system crashes in the middle 
of a raid-5 write it can apparently mess things up something horrid).
> 
>    diskfarm:~ # df -kh /mnt/4Traid5md/ /mnt/750Graid5md/
>    Filesystem      Size  Used Avail Use% Mounted on
>    /dev/md0p1       11T   11T  309G  98% /mnt/4Traid5md
>    /dev/md127p1    1.4T  1.4T   14G 100% /mnt/750Graid5md
> 
>    diskfarm:~ # mount | grep /dev/md
>    /dev/md0p1 on /mnt/4Traid5md type xfs (rw,relatime,attr2,inode64,logbufs=8,logbsize=32k,sunit=1024,swidth=2048,noquota)
>    /dev/md127p1 on /mnt/750Graid5md type reiserfs (rw,relatime)
> 
> 
> %
> ...
> % >I am about to do some array reworks to go from all 3tb disks to start
> % >using some 6tb disks.   If the file was pre-allocated I would not
> ...
> % >
> % Umm... don't use all the space on your 6TB disks. I'm planning to
> % build my arrays on dm-integrity, which will make raid 5 a bit more
> % trustworthy.
> [snip]
> 
> Oooh, something else to learn :-)  I hope to go from 4 drives to 6 when I
> do, and I'll be buying the best GB/$ at the time, but it will also be a
> grow-over-time thing.
> 
dm-integrity is nothing to do with raid per-se, but it does a checksum 
of the data on disk. If your data is corrupted (rather than lost) 
there's no way you can get it back with raid-5. dm-integrity turns 
corruption into data loss allowing raid-5 to recover.

Read my journey building my new system ... :-)
https://raid.wiki.kernel.org/index.php/System2020

I've got a little more to add, but it's stalled for the perennial 
problem of finding time to do and concentrate.

Cheers,
Wol
