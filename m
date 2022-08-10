Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 799D4C00140
	for <linux-raid@archiver.kernel.org>; Wed, 10 Aug 2022 07:03:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbiHJHDJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 10 Aug 2022 03:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbiHJHDI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 10 Aug 2022 03:03:08 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B72F274DF1
        for <linux-raid@vger.kernel.org>; Wed, 10 Aug 2022 00:03:06 -0700 (PDT)
Received: from host86-128-157-135.range86-128.btcentralplus.com ([86.128.157.135] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1oLfk8-0001d5-7g;
        Wed, 10 Aug 2022 08:03:04 +0100
Message-ID: <d2901788-91bd-265f-e016-89496e9b1c74@youngman.org.uk>
Date:   Wed, 10 Aug 2022 08:03:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: mirroring existing boot drive sanity check
Content-Language: en-GB
To:     David T-G <davidtg-robot@justpickone.org>,
        linux-raid@vger.kernel.org
References: <8319a7ea67dc601c8ca4556ff15702d5@justpickone.org>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <8319a7ea67dc601c8ca4556ff15702d5@justpickone.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 09/08/2022 15:50, David T-G wrote:
> Hi, all --
> 
> I think that this has been asked before, and so I think that I know 
> where I'm
> going, but before I take aim at my foot with a large-caliber mdadm ... :-)
> 
> I have an existing
> 
>    diskfarm:~ # parted /dev/sda unit MiB print free
>    Model: ATA SanDisk SD6SB1M1 (scsi)
>    Disk /dev/sda: 122104MiB
>    Sector size (logical/physical): 512B/512B
>    Partition Table: gpt
>    Disk Flags: pmbr_boot
> 
>    Number  Start     End        Size      File system     Name Flags
>            0.02MiB   1.00MiB    0.98MiB   Free Space
>     1      1.00MiB   33793MiB   33792MiB  linux-swap(v1)  diskfarm-swap 
> swap
>     2      33793MiB  66561MiB   32768MiB  xfs             diskfarmsuse
>     3      66561MiB  99329MiB   32768MiB                  diskfarmknop 
> legacy_boot
>     4      99329MiB  122104MiB  22775MiB  xfs             diskfarm-ssd
> 
> 128G SSD.  I have obtained a shiny new
> 
>    diskfarm:~ # parted /dev/sde unit MiB print free
>    Model: ATA SATA SSD (scsi)
>    Disk /dev/sde: 244198MiB
>    Sector size (logical/physical): 512B/512B
>    Partition Table: gpt
>    Disk Flags:
> 
>    Number  Start      End        Size       File system  Name Flags
>            0.02MiB    1.00MiB    0.98MiB    Free Space
>     1      1.00MiB    33793MiB   33792MiB                diskfarm-swap swap
>     2      33793MiB   66561MiB   32768MiB                diskfarmsuse
>     3      66561MiB   99329MiB   32768MiB                diskfarmknop 
> legacy_boot
>     4      99329MiB   122104MiB  22775MiB                diskfarm-ssd
>            122104MiB  244198MiB  122094MiB  Free Space
> 
> 256G SSD to use as a mirror.  [You can ignore the sgdisk-copied partition
> layout for the moment; that was a false start.]  My final-view plan is, in
> fact, to replace the 128 with another 256 and grow the -ssd data partition.
> 
> For a typical mirror-an-existing, I think that I need to create all of my
> slices and the [degraded] mirror on the new, copy over the old, boot 
> from new,
> and then treat old as just another disk to shove in.  There's the 
> question of
> making partitions larger for the RAID superblock info, though, and -- and
> here's where I get confused -- even on the old disk when adding it in.

https://raid.wiki.kernel.org/index.php/Converting_an_existing_system
> 
> As you can see, I have no free space on the little guy.  I was thinking I'd
> bump my slices larger on the new disk so that I have room to spare to copy
> everything over, with the data slice a little less larger than it would 
> have
> been, but then ... I think I saw that I need to make the 2nd-drive slices
> larger, too, so what do I do with the old guy?

Yup. If your old system is full (or even if it isn't), if you're moving 
a straight partition on to raid, it's easier just to create all your 
slices new on the new system and move across.

If you really want to re-use the old drive, then you've got some maths 
ahead of you ...

You need to allocate the planned partition to your raid.
Then you create the raid, telling it to only use a space equal or less 
than your original disk.
Then you copy your original filesystem into the raid, except it probably 
doesn't quite fit, so you have to shrink it (not a simple matter) or use 
cp or rsync instead, equally unpleasant.
Then you wipe your old drive and add it as the new raid member.

It's probably not hard. But it's got vastly more scope for error, 
cock-up, fat-finger, or plain hardware hiccup. Is it worth it ...
> 
> And, in fact, does it even matter?  If I understand this correctly, I'll be
> running entirely from the new disk in the mirror once this is done, and 
> so it
> doesn't matter whether I put the little old or the other big new in to 
> fill out
> the mirror.  If that's the case, then I don't really care about 
> partition size
> because I'm going to start with mirrored partitions.

Yup again. You're better off just putting in a new 256GB.

Then you can just dd your old root (and whatever else) filesystem(s) 
across, and grow them into the new space.

Plus your old drive is now just sitting there as a backup.
> 
> Oh, and just because I'm a glutton for punishment (even more than using 
> this
> stupid webmail because we're currently down my home directory disk on 
> our mail
> server and I'm impatient), if I'm essentially starting from scratch, 
> should I
> mirror the entire [yes, identical] drive and partition the metadevice,
> *BSD-style, or mirror individual partitions?
> 
As my wife says about my driving, she trusts me, but there are too many 
idiots out there. Advice is *ALWAYS* partition your hard drive. raid 
couldn't care, but there are too many idiots out there that assume an 
unpartitioned drive is empty, and will stomp on it without asking. It's 
fallen off, but probably the biggest single cause of raid recoveries 
here is "something overwrote my superblock with a partition table" or 
the like - it's usually partition-related ...

Cheers,
Wol
