Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2513C433FE
	for <linux-raid@archiver.kernel.org>; Wed, 23 Nov 2022 22:28:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiKWW2d (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 23 Nov 2022 17:28:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbiKWW22 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 23 Nov 2022 17:28:28 -0500
Received: from len.romanrm.net (len.romanrm.net [91.121.86.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F337847330
        for <linux-raid@vger.kernel.org>; Wed, 23 Nov 2022 14:28:24 -0800 (PST)
Received: from nvm (nvm2.home.romanrm.net [IPv6:fd39::4a:3cff:fe57:d6b5])
        by len.romanrm.net (Postfix) with SMTP id 73826400C8;
        Wed, 23 Nov 2022 22:28:21 +0000 (UTC)
Date:   Thu, 24 Nov 2022 03:28:21 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     David T-G <davidtg-robot@justpickone.org>
Cc:     Linux RAID list <linux-raid@vger.kernel.org>
Subject: Re: how do i fix these RAID5 arrays?
Message-ID: <20221124032821.628cd042@nvm>
In-Reply-To: <20221123220736.GD19721@jpo>
References: <20221123220736.GD19721@jpo>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 23 Nov 2022 22:07:36 +0000
David T-G <davidtg-robot@justpickone.org> wrote:

>   diskfarm:~ # mdadm -D /dev/md50
>   /dev/md50:
>              Version : 1.2
>        Creation Time : Thu Nov  4 00:56:36 2021
>           Raid Level : raid0
>           Array Size : 19526301696 (18.19 TiB 19.99 TB)
>         Raid Devices : 6
>        Total Devices : 6
>          Persistence : Superblock is persistent
>   
>          Update Time : Thu Nov  4 00:56:36 2021
>                State : clean 
>       Active Devices : 6
>      Working Devices : 6
>       Failed Devices : 0
>        Spare Devices : 0
>   
>               Layout : -unknown-
>           Chunk Size : 512K
>   
>   Consistency Policy : none
>   
>                 Name : diskfarm:10T  (local to host diskfarm)
>                 UUID : cccbe073:d92c6ecd:77ba5c46:5db6b3f0
>               Events : 0
>   
>       Number   Major   Minor   RaidDevice State
>          0       9       51        0      active sync   /dev/md/51
>          1       9       52        1      active sync   /dev/md/52
>          2       9       53        2      active sync   /dev/md/53
>          3       9       54        3      active sync   /dev/md/54
>          4       9       55        4      active sync   /dev/md/55
>          5       9       56        5      active sync   /dev/md/56

It feels you haven't thought this through entirely. Sequential writes to this
RAID0 array will alternate across all member arrays, and seeing how those are
not of independent disks, but instead are "vertical" across partitions on the
same disks, it will result in a crazy seek load, as first 512K is written to
the array of the *51 partitions, second 512K go to *52, then to *53,
effectively requiring a full stroke of each drive's head across the entire
surface for each and every 3 *megabytes* written.

mdraid in the "linear" mode, or LVM with one large LV across all PVs (which
are the individual RAID5 arrays), or multi-device Btrfs using "single" profile
for data, all of those would avoid the described effect.

But I should clarify, the entire idea of splitting drives like this seems
questionable to begin with, since drives more often fail entirely, not in part,
so you will not save any time on rebuilds; and the "bitmap" already protects
you against full rebuilds due to any hiccups such as a power cut; or even if a
drive failed in part, in your current setup, or even in the proposed ones I
mentioned above, losing even one RAID5 of all these, would result in a
complete loss of data anyway. Not to mention what you have seems like an insane
amount of complexity.

To summarize, maybe it's better to blow away the entire thing and restart from
the drawing board, while it's not too late? :)

>   diskfarm:~ # mdadm -D /dev/md5[13456] | egrep '^/dev|active|removed'
>   /dev/md51:
> 	 0     259        9        0      active sync   /dev/sdb51
> 	 1     259        2        1      active sync   /dev/sdc51
> 	 3     259       16        2      active sync   /dev/sdd51
> 	 -       0        0        3      removed
>   /dev/md53:
> 	 0     259       11        0      active sync   /dev/sdb53
> 	 1     259        4        1      active sync   /dev/sdc53
> 	 3     259       18        2      active sync   /dev/sdd53
> 	 -       0        0        3      removed
>   /dev/md54:
> 	 0     259       12        0      active sync   /dev/sdb54
> 	 1     259        5        1      active sync   /dev/sdc54
> 	 3     259       19        2      active sync   /dev/sdd54
> 	 -       0        0        3      removed
>   /dev/md55:
> 	 0     259       13        0      active sync   /dev/sdb55
> 	 1     259        6        1      active sync   /dev/sdc55
> 	 3     259       20        2      active sync   /dev/sdd55
> 	 -       0        0        3      removed
>   /dev/md56:
> 	 0     259       14        0      active sync   /dev/sdb56
> 	 1     259        7        1      active sync   /dev/sdc56
> 	 3     259       21        2      active sync   /dev/sdd56
> 	 -       0        0        3      removed
> 
> that are obviously the sdk (new disk) slice.  If md52 were also broken,
> I'd figure that the disk was somehow unplugged, but I don't think I can
> plug in one sixth of a disk and leave the rest unhooked :-)  So ...  In
> addition to wondering how I got here, how do I remove the "removed" ones
> and then re-add them to build and grow and finalize this?

If you want to fix it still, without dmesg it's hard to say how this could
have happened, but what does

  mdadm --re-add /dev/md51 /dev/sdk51

say?

-- 
With respect,
Roman
