Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF226C433ED
	for <linux-raid@archiver.kernel.org>; Mon, 17 May 2021 06:29:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F36161209
	for <linux-raid@archiver.kernel.org>; Mon, 17 May 2021 06:29:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233316AbhEQGaT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 17 May 2021 02:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbhEQGaS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 17 May 2021 02:30:18 -0400
Received: from rin.romanrm.net (rin.romanrm.net [IPv6:2001:bc8:2dd2:1000::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1C12C061573
        for <linux-raid@vger.kernel.org>; Sun, 16 May 2021 23:28:48 -0700 (PDT)
Received: from natsu (natsu2.home.romanrm.net [IPv6:fd39::e99e:8f1b:cfc9:ccb8])
        by rin.romanrm.net (Postfix) with SMTP id E6C8B66D;
        Mon, 17 May 2021 06:28:44 +0000 (UTC)
Date:   Mon, 17 May 2021 11:28:44 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Christopher Thomas <youkai@earthlink.net>
Cc:     linux-raid@vger.kernel.org
Subject: Re: My superblocks have gone missing, can't reassemble raid5
Message-ID: <20210517112844.388d2270@natsu>
In-Reply-To: <CA+o1gzBcQF_JeiC7Nv_zEBmJU2ypwQ_+RkbcZOOt0qOK1MkQww@mail.gmail.com>
References: <CA+o1gzBcQF_JeiC7Nv_zEBmJU2ypwQ_+RkbcZOOt0qOK1MkQww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sun, 16 May 2021 21:16:22 -0700
Christopher Thomas <youkai@earthlink.net> wrote:

> Disk /dev/sdd: 2.7 TiB, 3000592982016 bytes, 5860533168 sectors
> Disk model: VBOX HARDDISK
> Units: sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disklabel type: gpt
> Disk identifier: 9DB2C3F2-F93D-4A6D-AE0E-CE28A8B8C4A2
> 
> Device     Start    End Sectors  Size Type
> /dev/sdd1     34 262177  262144  128M Microsoft reserved
> ==========
> 
> Note: I always intended to use the whole disk, so I don't know why I
> would have created a single large partition on each, and I don't
> recall doing so.  But it's been a while, so I just might not be
> remembering.

Unless you mean "why I *wouldn't* have created"... There isn't a single large
partition on each, the partitions are only 128 MB in size, and these are the
Microsoft Reserved partitions (MSR)[1]. And a GPT partition table, which
shouldn't be there either, if you used whole disks for md RAID. I guess either
of these have overwritten your superblocks, which with version 1.2 are stored
4k from the beginning of the device.
 
I'm not sure if Windows would just quietly create these on it's on, but it
certainly would if the user opened "Disk Manager", was prompted that there are
3 new uninitialized drives and clicked "OK" to initialize them as GPT.

For that exact reason it is not a good idea to use whole disks for RAID, since
other OSes see them as empty/uninitialized which they can use as they see fit.

As for recovery, you really might need to play with --create; to prevent the
chance of data loss, there's a way to experiment using "overlays", keeping the
original drives untouched; see [2] for more background on that, and [3]
provides steps for your actual situation. Don't forget to use "--assume-clean"
and "--readonly".

There also might be some filesystem damage on the array, depending on how much
and how important were the pieces overwritten at the beginning of all disks by
data stored in the 128 MB MSR.

[1]
https://superuser.com/questions/942065/is-msr-partition-required-on-secondary-gpt-drives

[2] https://raid.wiki.kernel.org/index.php/Recovering_a_damaged_RAID
[3] https://raid.wiki.kernel.org/index.php/Irreversible_mdadm_failure_recovery

-- 
With respect,
Roman
