Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 743A7C19F2A
	for <linux-raid@archiver.kernel.org>; Thu, 11 Aug 2022 21:35:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235075AbiHKVfG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 11 Aug 2022 17:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235079AbiHKVfF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 11 Aug 2022 17:35:05 -0400
X-Greylist: delayed 517 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 11 Aug 2022 14:35:01 PDT
Received: from smtp-delay1.nerim.net (mailhost-w2-m3.nerim.net [78.40.49.226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 74CDD9F0FA
        for <linux-raid@vger.kernel.org>; Thu, 11 Aug 2022 14:35:01 -0700 (PDT)
Received: from mallaury.nerim.net (smtp-104-thursday.noc.nerim.net [178.132.17.104])
        by smtp-delay1.nerim.net (Postfix) with ESMTP id C4A3DC7AA1
        for <linux-raid@vger.kernel.org>; Thu, 11 Aug 2022 23:26:23 +0200 (CEST)
Received: from [192.168.0.252] (plouf.fr.eu.org [213.41.155.166])
        by mallaury.nerim.net (Postfix) with ESMTP id DA825DB17C;
        Thu, 11 Aug 2022 23:26:20 +0200 (CEST)
Message-ID: <014ce113-3c6d-ea1d-a576-cb06e5126748@plouf.fr.eu.org>
Date:   Thu, 11 Aug 2022 23:26:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
From:   Pascal Hambourg <pascal@plouf.fr.eu.org>
Subject: Re: mirroring existing boot drive sanity check
To:     David T-G <davidtg-robot@justpickone.org>,
        linux-raid@vger.kernel.org
References: <8319a7ea67dc601c8ca4556ff15702d5@justpickone.org>
Content-Language: en-US
Organization: Plouf !
In-Reply-To: <8319a7ea67dc601c8ca4556ff15702d5@justpickone.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Le 09/08/2022 à 16:50, David T-G a écrit :
> 
> I have an existing 128G SSD.
> 
>    Disk /dev/sda: 122104MiB
>    Sector size (logical/physical): 512B/512B
>    Partition Table: gpt
>    Disk Flags: pmbr_boot
> 
>    Number  Start     End        Size      File system     Name Flags
>            0.02MiB   1.00MiB    0.98MiB   Free Space
>     1      1.00MiB   33793MiB   33792MiB  linux-swap(v1)  diskfarm-swap swap
>     2      33793MiB  66561MiB   32768MiB  xfs             diskfarmsuse
>     3      66561MiB  99329MiB   32768MiB                  diskfarmknop  legacy_boot
>     4      99329MiB  122104MiB  22775MiB  xfs             diskfarm-ssd
> 
> I have obtained a shiny new 256G SSD to use as a mirror.
> My final-view plan is, in
> fact, to replace the 128 with another 256 and grow the -ssd data partition.
> 
> For a typical mirror-an-existing, I think that I need to create all of my
> slices and the [degraded] mirror on the new, copy over the old, boot from new,
> and then treat old as just another disk to shove in.  There's the question of
> making partitions larger for the RAID superblock info
If you choose to copy existing block device content (with dd or the 
like) into a RAID array, then the RAID array device size must be at 
least the same this, which implies that the RAID member devices is 
sligthly bigger to take the RAID superblock into account.

If you choose to copy filesystem content (with cp, rsync or the like) 
into a new filesystem, then you only need the RAID array device to be 
big enough to fit the content.

> As you can see, I have no free space on the little guy.

Actually no, we cannot see. We can only see that there is no free space 
outside the partitions. But we cannot see if there is any free space 
inside the partitions.

> what do I do with the old guy?

Do whatever you like with the old drive except using it in the RAID 
array. Why bother doing this and having to resize the RAID array when 
you add the 2nd new drive ? Resizing a RAID array is a pain in the ass. 
Just build the RAID array on the 2 new drives from the start.

> if I'm essentially starting from scratch, should I
> mirror the entire [yes, identical] drive and partition the metadevice,
> *BSD-style, or mirror individual partitions?

IMO a single RAID array is simpler. If your distribution supports it, 
you can either partition it with a partition table or use it as a LVM 
physical volume and create logical volumes.

However I do not think it is possible to cleanly boot from an 
unpartitioned drive used as a software RAID member, as a RAID capable 
boot loader could hardly fit in the 4-KiB area before the RAID 
superblock. So you still have to create a partition table on the raw 
drives. Also, if you use GPT format and GRUB boot loader, you need to 
create a small (100 kB to 1 MB) partition with type "BIOS boot" (or 
libparted bios_grub flag).
