Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA2E8C43217
	for <linux-raid@archiver.kernel.org>; Sat, 26 Nov 2022 20:24:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbiKZUYf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 26 Nov 2022 15:24:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiKZUYe (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 26 Nov 2022 15:24:34 -0500
Received: from len.romanrm.net (len.romanrm.net [91.121.86.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE00017A95
        for <linux-raid@vger.kernel.org>; Sat, 26 Nov 2022 12:24:32 -0800 (PST)
Received: from nvm (nvm2.home.romanrm.net [IPv6:fd39::4a:3cff:fe57:d6b5])
        by len.romanrm.net (Postfix) with SMTP id 5C8AB400E1
        for <linux-raid@vger.kernel.org>; Sat, 26 Nov 2022 20:24:30 +0000 (UTC)
Date:   Sun, 27 Nov 2022 01:24:29 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Linux RAID list <linux-raid@vger.kernel.org>
Subject: LVM on top of mdraid of LVM thin volumes on top of LUKS, aka
 LUKS+LVM+mdraid Tower of Babel
Message-ID: <20221127012429.694fe510@nvm>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello,

I am almost half-seriously considering this setup:

Disk 1
=> LUKS encrypted volume 1
==> LVM PV 1
===> LVM thin pool 1
====> LVM thin LV 1

Disk 2
=> LUKS encrypted volume 2
==> LVM PV 2
===> LVM thin pool 2
====> LVM thin LV 2

=====> mdadm RAID1 of LV-1 and LV-2
======> LVM PV
=======> LVM LVs (for individual VMs)

What leads me to this, is:

I want to store VM images, with a requirement that after trimming free space
on those VMs, their free space contains only zeroes, and as such is highly
compressible during backup.

This is apparently not possible directly on top of LUKS, since a trimmed
encrypted disk (with TRIM pass-through) returns random binary garbage in the
trimmed areas, by design of how the encryption works.

So one solution is to use LVM thin instead. A thinned thin LV always returns
zeros in the presently unmapped areas, and that also can be further ensured
with pre-zeroing on allocation (lvchange -Z).

Next, I only want to mirror a part of Disk 1 and Disk 2, not the entire disks.
But the encryption should span them entirely.
And it would be sweet to be able to dynamically resize the mirrored part in
both directions. Mirroring of thin LVs allows for that.

My main concern is will this all bring up itself successfully on boot,
probably it will, or can be made to.

What do you think, is there any other simpler topology that would satisfy all
the requirements?

Thanks

-- 
With respect,
Roman
