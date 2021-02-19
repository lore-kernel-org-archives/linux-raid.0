Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3158FC433DB
	for <linux-raid@archiver.kernel.org>; Fri, 19 Feb 2021 20:46:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD9C364E76
	for <linux-raid@archiver.kernel.org>; Fri, 19 Feb 2021 20:46:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbhBSUqr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 19 Feb 2021 15:46:47 -0500
Received: from vps.thesusis.net ([34.202.238.73]:48060 "EHLO vps.thesusis.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229555AbhBSUqr (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 19 Feb 2021 15:46:47 -0500
Received: from localhost (localhost [127.0.0.1])
        by vps.thesusis.net (Postfix) with ESMTP id 5E33621B2C
        for <linux-raid@vger.kernel.org>; Fri, 19 Feb 2021 15:30:02 -0500 (EST)
Received: from vps.thesusis.net ([IPv6:::1])
        by localhost (vps.thesusis.net [IPv6:::1]) (amavisd-new, port 10024)
        with ESMTP id L0F1mJkIjV-A for <linux-raid@vger.kernel.org>;
        Fri, 19 Feb 2021 15:30:02 -0500 (EST)
Received: by vps.thesusis.net (Postfix, from userid 1000)
        id 1141A21B37; Fri, 19 Feb 2021 15:30:02 -0500 (EST)
User-agent: mu4e 1.5.7; emacs 26.3
From:   Phillip Susi <phill@thesusis.net>
To:     linux-raid@vger.kernel.org
Subject: Raid10 reshape bug
Date:   Fri, 19 Feb 2021 15:13:07 -0500
Message-ID: <87tuq7g5rp.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

In the process of upgrading a xen server I broke the previous raid1 and
used the removed disk to create a new raid10 to prepare the new install.
I think initially I created it in the default near configuration, so I
reshaped it to offset with 1M chunk size.  I got the domUs up and
running again and was pretty happy with the result, so I blew away the
old system disk and added that disk to the new array and allowed it to
sync.  Then I thought that the 1M chunk size was hurting performance, so
I requested a reshape to a 256k chunk size with mdadm -G /dev/md0 -c
256.  It looked like it was proceeding fine so I went home for the
night.

When I came in this morming, mdadm -D showed that the reshape was
complete, but I started getting ELF errors and such running various
programs and I started to get a feeling that something had gone horribly
wrong.  At one point I was trying to run blockdev --getsz and isntead
the system somehow ran findmnt.  mdadm -E showed that there was a very
large unused section of the disk both before and after.  This is
probably because I had used -s to restrict the used size of the device
to be only 256g instead of the full 2tb so it wouldn't take so long to
resync, and since there was plenty of unused space, md decided to just
write back the new layout stripes in unused space further down the disk.
At this point I rebooted and grub could not recognize the filesystem.  I
booted other media and tried an e2fsck but it had so many complaints,
one of which being that the root directory was not, in fact, a directory
so it deleted it that I just gave up and started reinstalling and
restoring the domU from backup.

Clearly somehow the reshape process did NOT write the data back to the
disk in the correct place.  This was using debian testing with linux
5.10.0 and mdadm v4.1.

I will try to reproduce it in a vm at some point.
