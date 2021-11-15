Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3B06C433EF
	for <linux-raid@archiver.kernel.org>; Mon, 15 Nov 2021 21:02:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABCD161AF0
	for <linux-raid@archiver.kernel.org>; Mon, 15 Nov 2021 21:02:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343659AbhKOVFm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 15 Nov 2021 16:05:42 -0500
Received: from vps.thesusis.net ([34.202.238.73]:46550 "EHLO vps.thesusis.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348308AbhKOTwF (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 15 Nov 2021 14:52:05 -0500
X-Greylist: delayed 518 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Nov 2021 14:52:05 EST
Received: by vps.thesusis.net (Postfix, from userid 1000)
        id 0273266317; Mon, 15 Nov 2021 14:39:44 -0500 (EST)
References: <20211114022924.GA21337@opal1.opalstack.com>
 <20211115025103.GA254223@opal1.opalstack.com>
User-agent: mu4e 1.7.0; emacs 27.1
From:   Phillip Susi <phill@thesusis.net>
To:     David T-G <davidtg+robot@justpickone.org>
Cc:     Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: overlays on dd images of 4T drives
Date:   Mon, 15 Nov 2021 14:32:59 -0500
In-reply-to: <20211115025103.GA254223@opal1.opalstack.com>
Message-ID: <87czn1i4xr.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


David T-G <davidtg+robot@justpickone.org> writes:

>   davidtg@gezebel:/mnt/data/tmp/4Traid> parallel 'size=$(sudo blockdev
> --getsize {}); loop=$(sudo losetup -f --show -- overlay-{/}) ; echo
> $loop' ::: $DEVICES
>   /dev/loop0
>   /dev/loop2
>   /dev/loop1
>
>   davidtg@gezebel:/mnt/data/tmp/4Traid> sudo losetup -a
>   /dev/loop1: [66307]:624372298 (/mnt/data/tmp/4Traid/overlay-sdc1)
>   /dev/loop2: [66307]:624372297 (/mnt/data/tmp/4Traid/overlay-sdb1)
>   /dev/loop0: [66307]:624372296 (/mnt/data/tmp/4Traid/overlay-sda1)
>   ### why are these out of order?!? *sigh*

Because you ran the command to create them with parallel.  Don't do that.

> OK, yeah, we could predict that.  But it gets even more fun:
>
>   diskfarm:/mnt/10Traid50md/tmp # mdadm --assemble --force /dev/md4 /dev/loop{0,1,2}
>   mdadm: no recogniseable superblock on /dev/loop0
>   mdadm: /dev/loop0 has no superblock - assembly aborted
>
> What?!?  Where is my superblock?  This is a bit-for-bit copy of the
> partition itself.
>
> Time to fall back for more help from the RAID gods *sigh*  Any further
> recommendations?

Run mdadm -E /dev/loop{0,1,2}

