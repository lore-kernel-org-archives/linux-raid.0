Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ED75C07E95
	for <linux-raid@archiver.kernel.org>; Sun, 11 Jul 2021 03:12:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 368CD61356
	for <linux-raid@archiver.kernel.org>; Sun, 11 Jul 2021 03:12:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbhGKDOz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 10 Jul 2021 23:14:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbhGKDOy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 10 Jul 2021 23:14:54 -0400
Received: from u17383850.onlinehome-server.com (u17383850.onlinehome-server.com [IPv6:2607:f1c0:83f:ac00::a6:f62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07DCEC0613DD
        for <linux-raid@vger.kernel.org>; Sat, 10 Jul 2021 20:12:08 -0700 (PDT)
Received: by u17383850.onlinehome-server.com (Postfix, from userid 5001)
        id 4279D796; Sat, 10 Jul 2021 23:12:08 -0400 (EDT)
Date:   Sat, 10 Jul 2021 23:12:08 -0400
From:   David T-G <davidtg-robot@justpickone.org>
To:     Linux RAID list <linux-raid@vger.kernel.org>
Subject: Re: 1T and 500+500 mirror, but different speeds
Message-ID: <20210711031208.GP1415@justpickone.org>
References: <20210709122732.GB27083@justpickone.org>
 <60E87BAF.9020706@youngman.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60E87BAF.9020706@youngman.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Wol, et al --

...and then Wols Lists said...
% 
% On 09/07/21 13:27, David T-G wrote:
% > Hi, all --
% > 
% > I have a 1T drive
% > 
% >   jpo:~ # parted /dev/sdb print
% >   Model: ATA ST31000524AS (scsi)
...
% >   jpo:~ # smartctl -i /dev/sdb
...
% >   Model Family:     Seagate Barracuda 7200.12
% 
% Barracuda ... DO NOT USE THIS IN A PARITY RAID ARRAY !!!

I am aware of the general problem, and I run the handy timeout script

  # set the timeouts on the local drives
  printf "${CBLU}Drive timeouts${CBLK}: "
  for DISK in sda sdb sdc sdd sde sdf sdg sdh     # a-d on mobo ; e-h on card
  do
    printf "$DISK "
    smartctl -q errorsonly -l scterc,70,70 /dev/$DISK
    if [ 4 -eq $? ]
    then
      echo 180 > /sys/block/$DISK/device/timeout
      printf "${CYLO}180"
    else
      printf "${CGRN}Y"
    fi
    printf "${CBLK} ; "
  done
  echo ''

to reset as needed, and I even have no plans to parity this drive, but I
didn't realize that it was a problem disk!  Thanks for the heads-up.


% 
% Mirroring as you plan here is okay.

That's good.  Of course, that then makes me scratch my head a bit since
it's still paired with other and needs to not blow up ...  I'll have to
back and read more to see why mirror is safe.


% 
...
% > and also two 500G drives
% > 
% >   jpo:~ # parted /dev/sdc print
% >   Model: ATA WDC WD5000AAVS-0 (scsi)
...
% >   jpo:~ # smartctl -i /dev/sdc
...
% >   Model Family:     Western Digital Caviar Green
...
% > that I plan to stripe together to use to protect the first.  The Caviars
% > are listed as variable speed, but in practice they apparently are just
% > 5400 rpm, so I'd like to take advantage of striping to make them as fast
% > as possible. 
% 
% Caviar Green ??? Caviars should be okay, but the "green" moniker makes

Yeah, I'm not too happy about that ...  Supposedly they will vary speed
based on demand, so they can deliver 7200rpm performance, but apparently
they always stay at 5400rpm and so they're just basic drives.  Meh.


% me nervous. Check SCT/ERC, but striping/mirroring will be fine.

More of that confusion stuff :-) but happy.


% 
% > This isn't the black magic ;-) of RAID10-on-two-drives,
% > so I don't have to think of one as "front" and one as "back", but do I
% > want more than one partition on each to stripe 4 or 6 slices to avoid
% > hammering on one, or do I just go with each device as a whole and let
% > mdadm handle the magic for me?
% > 
...
% Okay, the simple approach.
% 
% Create a single-device mirror using the 1TB and the special device
% "missing". Copy everything across and make sure it's all okay. (I'm
% assuming you can safely wipe this drive as it has nothing on it you wish
% to keep.)

Correct.


% 
% Create a striped device using the two 500GB drives.

That's the fun part ...  I'm thinkin' I'm just going to have to do sector
math to predict how large the new dev can be so that I can back into a
proper partition size on the 1T so that both halves can match.

How much overhead does md need for striping (RAID0)?  Given these two

  jpo:~ # parted /dev/sdc unit s print free
  Model: ATA WDC WD5000AAVS-0 (scsi)
  Disk /dev/sdc: 976773168s
  Sector size (logical/physical): 512B/512B
  Partition Table: gpt
  Disk Flags: 

  Number  Start       End         Size        File system  Name                                  Flags
          34s         2047s       2014s       Free Space
   1      2048s       696250367s  696248320s               ata-WDC_WD5000AAVS-00ZTB0_WD-WMASU06  raid
   2      696250368s  967006207s  270755840s                                                     raid
   4      967006208s  976773119s  9766912s    reiserfs     wwn-0x50014ee055b724ad
          976773120s  976773134s  15s         Free Space

500G disks (976773100 total sectors each, right?), how large a partition
can I create on this

  jpo:~ # parted /dev/sdb unit s print free
  Model: ATA ST31000524AS (scsi)
  Disk /dev/sdb: 1953525168s
  Sector size (logical/physical): 512B/512B
  Partition Table: msdos
  Disk Flags: 

  Number  Start        End          Size         Type     File system  Flags
          63s          2047s        1985s                 Free Space
   1      2048s        1953521663s  1953519616s  primary  ntfs         type=07
          1953521664s  1953525167s  3504s                 Free Space

1T disk (1953525104 sectors, which is 21096 less than the 2ea others
together) can I create and expect to be able to match it across the pair?

Is this something I could mock up with overlays without destroying the
existing data?


% 
% Add the striped device to the 1TB mirror.

At that point it becomes easy :-)


% 
% Plan to replace all the disks with something like Seagate Ironwolves or
% Toshiba N300s in the near future :-)

Actually, I have four Seagate 4T drives

  diskfarm:~ # parted /dev/sdd print
  Model: ATA ST4000DM000-1F21 (scsi)
  Disk /dev/sdd: 4001GB
  Sector size (logical/physical): 512B/4096B
  Partition Table: gpt
  Disk Flags: 

  Number  Start   End     Size    File system  Name                             Flags
   1      1049kB  4001GB  4001GB  xfs          ata-ST4000DM000-1F2168_W300EYNA  raid
   2      4001GB  4001GB  134MB   reiserfs     wwn-0x5000c50069a8d76f

  diskfarm:~ # smartctl -i /dev/sdd
  smartctl 7.0 2019-05-21 r4917 [x86_64-linux-5.3.18-lp152.63-default] (SUSE RPM)
  Copyright (C) 2002-18, Bruce Allen, Christian Franke, www.smartmontools.org

  === START OF INFORMATION SECTION ===
  Model Family:     Seagate Desktop HDD.15
  Device Model:     ST4000DM000-1F2168
  Serial Number:    W300EYNA
  LU WWN Device Id: 5 000c50 069a8d76f
  Firmware Version: CC52
  User Capacity:    4,000,787,030,016 bytes [4.00 TB]
  Sector Sizes:     512 bytes logical, 4096 bytes physical
  Rotation Rate:    5900 rpm
  Form Factor:      3.5 inches
  Device is:        In smartctl database [for details use: -P show]
  ATA Version is:   ATA8-ACS T13/1699-D revision 4
  SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
  Local Time is:    Sat Jul 10 21:38:12 2021 UTC
  SMART support is: Available - device has SMART capability.
  SMART support is: Enabled

in another machine that I plan to upgrade to larger disks and hand down
to this one.  They're older, and they don't

  diskfarm:~ # smartctl -l scterc /dev/sdd
  smartctl 7.0 2019-05-21 r4917 [x86_64-linux-5.3.18-lp152.63-default] (SUSE RPM)
  Copyright (C) 2002-18, Bruce Allen, Christian Franke, www.smartmontools.org

  SCT Error Recovery Control command not supported

have SMART error handling, but at least they aren't SMR :-)


% 
% https://raid.wiki.kernel.org/index.php/Linux_Raid
% 
% Read especially the page on timeout mismatch as this DOES apply to your
% Barracuda !!!

I'll go back again :-)


% 
% Cheers,
% Wol


Have a great weekend!

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

