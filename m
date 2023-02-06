Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C36CEC05027
	for <linux-raid@archiver.kernel.org>; Mon,  6 Feb 2023 22:01:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbjBFWBr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Feb 2023 17:01:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjBFWBp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Feb 2023 17:01:45 -0500
Received: from len.romanrm.net (len.romanrm.net [91.121.86.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F0CB10A8C
        for <linux-raid@vger.kernel.org>; Mon,  6 Feb 2023 14:01:42 -0800 (PST)
Received: from nvm (nvm2.home.romanrm.net [IPv6:fd39::4a:3cff:fe57:d6b5])
        by len.romanrm.net (Postfix) with SMTP id AFA47401A8
        for <linux-raid@vger.kernel.org>; Mon,  6 Feb 2023 22:01:40 +0000 (UTC)
Date:   Tue, 7 Feb 2023 03:01:40 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     linux-raid@vger.kernel.org
Subject: Slow discard on RAID1 with --write-mostly: split into 1MB requests
Message-ID: <20230207030140.138f5f75@nvm>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello,

I found that if an mdadm RAID1 is created with a write-mostly device, each
discard request to the array ends up being split into 1MB pieces. My SSD is
capable of processing at most 200 of these per second, so as a result
discarding a 512GB array takes 42 minutes.

The kernel is 6.1.9.

In both cases:

# grep . /sys/block/md0/queue/discard_*
/sys/block/md0/queue/discard_granularity:512
/sys/block/md0/queue/discard_max_bytes:2199023255040
/sys/block/md0/queue/discard_max_hw_bytes:2199023255040
/sys/block/md0/queue/discard_zeroes_data:0

Steps to reproduce:

# wipefs -a /dev/nvme1n1p2 /dev/nvme2n1p2
/dev/nvme1n1p2: 4 bytes were erased at offset 0x00001000 (linux_raid_member): fc 4e 2b a9
/dev/nvme2n1p2: 4 bytes were erased at offset 0x00001000 (linux_raid_member): fc 4e 2b a9

# mdadm --create --level 1 -n2 --assume-clean --metadata=1.2 /dev/md0 /dev/nvme1n1p2 /dev/nvme2n1p2
mdadm: array /dev/md0 started.

# mdadm --grow --array-size 10G /dev/md0 # (so that the test doesn't take forever)

# time blkdiscard -f /dev/md0

real	0m0.335s
user	0m0.000s
sys	0m0.003s

# mdadm --stop /dev/md0 
mdadm: stopped /dev/md0

# wipefs -a /dev/nvme1n1p2 /dev/nvme2n1p2
/dev/nvme1n1p2: 4 bytes were erased at offset 0x00001000 (linux_raid_member): fc 4e 2b a9
/dev/nvme2n1p2: 4 bytes were erased at offset 0x00001000 (linux_raid_member): fc 4e 2b a9

# mdadm --create --level 1 -n2 --assume-clean --metadata=1.2 /dev/md0 /dev/nvme1n1p2 --write-mostly /dev/nvme2n1p2
mdadm: array /dev/md0 started.

# mdadm --grow --array-size 10G /dev/md0

# time blkdiscard -f /dev/md0

real	0m48.744s
user	0m0.000s
sys	0m0.019s

-- 
With respect,
Roman
