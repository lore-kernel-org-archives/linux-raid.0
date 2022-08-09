Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4750BC19F2D
	for <linux-raid@archiver.kernel.org>; Tue,  9 Aug 2022 15:13:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243282AbiHIPNg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 9 Aug 2022 11:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbiHIPNf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 9 Aug 2022 11:13:35 -0400
X-Greylist: delayed 1385 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 09 Aug 2022 08:13:32 PDT
Received: from www18.qth.com (www18.qth.com [69.16.238.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 911A7C54
        for <linux-raid@vger.kernel.org>; Tue,  9 Aug 2022 08:13:32 -0700 (PDT)
Received: from [::1] (port=45304 helo=www18.qth.com)
        by www18.qth.com with esmtpa (Exim 4.95)
        (envelope-from <davidtg-robot@justpickone.org>)
        id 1oLQYs-0003fH-RJ
        for linux-raid@vger.kernel.org;
        Tue, 09 Aug 2022 09:50:26 -0500
MIME-Version: 1.0
Date:   Tue, 09 Aug 2022 09:50:26 -0500
From:   David T-G <davidtg-robot@justpickone.org>
To:     linux-raid@vger.kernel.org
Subject: mirroring existing boot drive sanity check
User-Agent: Roundcube Webmail/1.5.2
Message-ID: <8319a7ea67dc601c8ca4556ff15702d5@justpickone.org>
X-Sender: davidtg-robot@justpickone.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - www18.qth.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - justpickone.org
X-Get-Message-Sender-Via: www18.qth.com: authenticated_id: dmail@justpickone.org
X-Authenticated-Sender: www18.qth.com: dmail@justpickone.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi, all --

I think that this has been asked before, and so I think that I know 
where I'm
going, but before I take aim at my foot with a large-caliber mdadm ...  
:-)

I have an existing

   diskfarm:~ # parted /dev/sda unit MiB print free
   Model: ATA SanDisk SD6SB1M1 (scsi)
   Disk /dev/sda: 122104MiB
   Sector size (logical/physical): 512B/512B
   Partition Table: gpt
   Disk Flags: pmbr_boot

   Number  Start     End        Size      File system     Name           
Flags
           0.02MiB   1.00MiB    0.98MiB   Free Space
    1      1.00MiB   33793MiB   33792MiB  linux-swap(v1)  diskfarm-swap  
swap
    2      33793MiB  66561MiB   32768MiB  xfs             diskfarmsuse
    3      66561MiB  99329MiB   32768MiB                  diskfarmknop   
legacy_boot
    4      99329MiB  122104MiB  22775MiB  xfs             diskfarm-ssd

128G SSD.  I have obtained a shiny new

   diskfarm:~ # parted /dev/sde unit MiB print free
   Model: ATA SATA SSD (scsi)
   Disk /dev/sde: 244198MiB
   Sector size (logical/physical): 512B/512B
   Partition Table: gpt
   Disk Flags:

   Number  Start      End        Size       File system  Name           
Flags
           0.02MiB    1.00MiB    0.98MiB    Free Space
    1      1.00MiB    33793MiB   33792MiB                diskfarm-swap  
swap
    2      33793MiB   66561MiB   32768MiB                diskfarmsuse
    3      66561MiB   99329MiB   32768MiB                diskfarmknop   
legacy_boot
    4      99329MiB   122104MiB  22775MiB                diskfarm-ssd
           122104MiB  244198MiB  122094MiB  Free Space

256G SSD to use as a mirror.  [You can ignore the sgdisk-copied 
partition
layout for the moment; that was a false start.]  My final-view plan is, 
in
fact, to replace the 128 with another 256 and grow the -ssd data 
partition.

For a typical mirror-an-existing, I think that I need to create all of 
my
slices and the [degraded] mirror on the new, copy over the old, boot 
from new,
and then treat old as just another disk to shove in.  There's the 
question of
making partitions larger for the RAID superblock info, though, and -- 
and
here's where I get confused -- even on the old disk when adding it in.

As you can see, I have no free space on the little guy.  I was thinking 
I'd
bump my slices larger on the new disk so that I have room to spare to 
copy
everything over, with the data slice a little less larger than it would 
have
been, but then ... I think I saw that I need to make the 2nd-drive 
slices
larger, too, so what do I do with the old guy?

And, in fact, does it even matter?  If I understand this correctly, I'll 
be
running entirely from the new disk in the mirror once this is done, and 
so it
doesn't matter whether I put the little old or the other big new in to 
fill out
the mirror.  If that's the case, then I don't really care about 
partition size
because I'm going to start with mirrored partitions.

Oh, and just because I'm a glutton for punishment (even more than using 
this
stupid webmail because we're currently down my home directory disk on 
our mail
server and I'm impatient), if I'm essentially starting from scratch, 
should I
mirror the entire [yes, identical] drive and partition the metadevice,
*BSD-style, or mirror individual partitions?


Thanks as always!

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt
