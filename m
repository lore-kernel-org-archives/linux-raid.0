Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F786C07E96
	for <linux-raid@archiver.kernel.org>; Sun, 11 Jul 2021 04:09:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C8636120D
	for <linux-raid@archiver.kernel.org>; Sun, 11 Jul 2021 04:09:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhGKEL5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 11 Jul 2021 00:11:57 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:53063 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229485AbhGKEL5 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sun, 11 Jul 2021 00:11:57 -0400
Received: from host86-159-54-55.range86-159.btcentralplus.com ([86.159.54.55] helo=[192.168.1.64])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1m2QmD-0002tN-8F; Sun, 11 Jul 2021 05:09:10 +0100
Subject: Re: 1T and 500+500 mirror, but different speeds
To:     David T-G <davidtg-robot@justpickone.org>,
        Linux RAID list <linux-raid@vger.kernel.org>
References: <20210709122732.GB27083@justpickone.org>
 <60E87BAF.9020706@youngman.org.uk> <20210711031208.GP1415@justpickone.org>
From:   Wols Lists <antlists@youngman.org.uk>
X-Enigmail-Draft-Status: N1110
Message-ID: <60EA6EE4.8070107@youngman.org.uk>
Date:   Sun, 11 Jul 2021 05:09:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.7.0
MIME-Version: 1.0
In-Reply-To: <20210711031208.GP1415@justpickone.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/07/21 04:12, David T-G wrote:
> Wol, et al --
> 
> ...and then Wols Lists said...
> % 


> 
> 
> % 
> % Mirroring as you plan here is okay.
> 
> That's good.  Of course, that then makes me scratch my head a bit since
> it's still paired with other and needs to not blow up ...  I'll have to
> back and read more to see why mirror is safe.
> 
Mirroring is safe because, whatever happens to the mirror, you only need
one disk to recover. So if the raid falls apart your data is not in danger.
> 
> % 
> ...
> % > and also two 500G drives
> % > 
> % >   jpo:~ # parted /dev/sdc print
> % >   Model: ATA WDC WD5000AAVS-0 (scsi)
> ...
> % >   jpo:~ # smartctl -i /dev/sdc
> ...
> % >   Model Family:     Western Digital Caviar Green
> ...
> % > that I plan to stripe together to use to protect the first.  The Caviars
> % > are listed as variable speed, but in practice they apparently are just
> % > 5400 rpm, so I'd like to take advantage of striping to make them as fast
> % > as possible. 
> % 
> % Caviar Green ??? Caviars should be okay, but the "green" moniker makes
> 
> Yeah, I'm not too happy about that ...  Supposedly they will vary speed
> based on demand, so they can deliver 7200rpm performance, but apparently
> they always stay at 5400rpm and so they're just basic drives.  Meh.
> 
> 
> % me nervous. Check SCT/ERC, but striping/mirroring will be fine.
> 
> More of that confusion stuff :-) but happy.
> 
> 
> % 
> % > This isn't the black magic ;-) of RAID10-on-two-drives,
> % > so I don't have to think of one as "front" and one as "back", but do I
> % > want more than one partition on each to stripe 4 or 6 slices to avoid
> % > hammering on one, or do I just go with each device as a whole and let
> % > mdadm handle the magic for me?
> % > 
> ...
> % Okay, the simple approach.
> % 
> % Create a single-device mirror using the 1TB and the special device
> % "missing". Copy everything across and make sure it's all okay. (I'm
> % assuming you can safely wipe this drive as it has nothing on it you wish
> % to keep.)
> 
> Correct.
> 
> 
> % 
> % Create a striped device using the two 500GB drives.
> 
> That's the fun part ...  I'm thinkin' I'm just going to have to do sector
> math to predict how large the new dev can be so that I can back into a
> proper partition size on the 1T so that both halves can match.

Do you need the entire space? Can you create a 900GB mirror on the 1TB?
You can always grow the mirror and the filesystem later.
> 


> 
> % 
> % Plan to replace all the disks with something like Seagate Ironwolves or
> % Toshiba N300s in the near future :-)
> 
> Actually, I have four Seagate 4T drives
> 
>   diskfarm:~ # parted /dev/sdd print
>   Model: ATA ST4000DM000-1F21 (scsi)
>   Disk /dev/sdd: 4001GB
>   Sector size (logical/physical): 512B/4096B
>   Partition Table: gpt
>   Disk Flags: 
> 
>   Number  Start   End     Size    File system  Name                             Flags
>    1      1049kB  4001GB  4001GB  xfs          ata-ST4000DM000-1F2168_W300EYNA  raid
>    2      4001GB  4001GB  134MB   reiserfs     wwn-0x5000c50069a8d76f
> 
>   diskfarm:~ # smartctl -i /dev/sdd
>   smartctl 7.0 2019-05-21 r4917 [x86_64-linux-5.3.18-lp152.63-default] (SUSE RPM)
>   Copyright (C) 2002-18, Bruce Allen, Christian Franke, www.smartmontools.org
> 
>   === START OF INFORMATION SECTION ===
>   Model Family:     Seagate Desktop HDD.15
>   Device Model:     ST4000DM000-1F2168
>   Serial Number:    W300EYNA
>   LU WWN Device Id: 5 000c50 069a8d76f
>   Firmware Version: CC52
>   User Capacity:    4,000,787,030,016 bytes [4.00 TB]
>   Sector Sizes:     512 bytes logical, 4096 bytes physical
>   Rotation Rate:    5900 rpm
>   Form Factor:      3.5 inches
>   Device is:        In smartctl database [for details use: -P show]
>   ATA Version is:   ATA8-ACS T13/1699-D revision 4
>   SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
>   Local Time is:    Sat Jul 10 21:38:12 2021 UTC
>   SMART support is: Available - device has SMART capability.
>   SMART support is: Enabled
> 
> in another machine that I plan to upgrade to larger disks and hand down
> to this one.  They're older, and they don't
> 
>   diskfarm:~ # smartctl -l scterc /dev/sdd
>   smartctl 7.0 2019-05-21 r4917 [x86_64-linux-5.3.18-lp152.63-default] (SUSE RPM)
>   Copyright (C) 2002-18, Bruce Allen, Christian Franke, www.smartmontools.org
> 
>   SCT Error Recovery Control command not supported
> 
> have SMART error handling, but at least they aren't SMR :-)
> 
They're no better! "SCT Error Recovery Control command not supported".
This is the red flag. This is the same problem as with the Barracudas.
> 
> % 
> % https://raid.wiki.kernel.org/index.php/Linux_Raid
> % 
> % Read especially the page on timeout mismatch as this DOES apply to your
> % Barracuda !!!
> 
> I'll go back again :-)
> 
And it applies to your 4TBs as well. I wouldn't worry too much - I'm
running a mirror on two 3TB Barracudas (I wouldn't have bought them if
I'd realised, but I was a raid newbie back then ...)

Cheers,
Wol

