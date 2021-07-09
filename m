Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8A30C07E99
	for <linux-raid@archiver.kernel.org>; Fri,  9 Jul 2021 12:33:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9775A61376
	for <linux-raid@archiver.kernel.org>; Fri,  9 Jul 2021 12:33:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbhGIMgZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 9 Jul 2021 08:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbhGIMgY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 9 Jul 2021 08:36:24 -0400
X-Greylist: delayed 367 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 09 Jul 2021 05:33:41 PDT
Received: from u17383850.onlinehome-server.com (u17383850.onlinehome-server.com [IPv6:2607:f1c0:83f:ac00::a6:f62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A8BC0613DD
        for <linux-raid@vger.kernel.org>; Fri,  9 Jul 2021 05:33:41 -0700 (PDT)
Received: by u17383850.onlinehome-server.com (Postfix, from userid 5001)
        id DFA8D79B; Fri,  9 Jul 2021 08:27:32 -0400 (EDT)
Date:   Fri, 9 Jul 2021 08:27:32 -0400
From:   David T-G <davidtg-robot@justpickone.org>
To:     Linux RAID list <linux-raid@vger.kernel.org>
Subject: 1T and 500+500 mirror, but different speeds
Message-ID: <20210709122732.GB27083@justpickone.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi, all --

I have a 1T drive

  jpo:~ # parted /dev/sdb print
  Model: ATA ST31000524AS (scsi)
  Disk /dev/sdb: 1000GB
  Sector size (logical/physical): 512B/512B
  Partition Table: msdos
  Disk Flags:

  Number  Start   End     Size    Type     File system  Flags
   1      1049kB  1000GB  1000GB  primary  ntfs         type=07

  jpo:~ # smartctl -i /dev/sdb
  smartctl 7.0 2019-05-21 r4917 [x86_64-linux-5.3.18-lp152.78-default] (SUSE RPM)
  Copyright (C) 2002-18, Bruce Allen, Christian Franke, www.smartmontools.org

  === START OF INFORMATION SECTION ===
  Model Family:     Seagate Barracuda 7200.12
  Device Model:     ST31000524AS
  Serial Number:    9VPG4SHD
  LU WWN Device Id: 5 000c50 04d20d244
  Firmware Version: JC45
  User Capacity:    1,000,204,886,016 bytes [1.00 TB]
  Sector Size:      512 bytes logical/physical
  Rotation Rate:    7200 rpm
  Device is:        In smartctl database [for details use: -P show]
  ATA Version is:   ATA8-ACS T13/1699-D revision 4
  SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
  Local Time is:    Thu Jul  8 11:32:27 2021 UTC
  SMART support is: Available - device has SMART capability.
  SMART support is: Enabled

and also two 500G drives

  jpo:~ # parted /dev/sdc print
  Model: ATA WDC WD5000AAVS-0 (scsi)
  Disk /dev/sdc: 500GB
  Sector size (logical/physical): 512B/512B
  Partition Table: gpt
  Disk Flags:

  Number  Start   End    Size    File system  Name                                  Flags
   1      1049kB  356GB  356GB                ata-WDC_WD5000AAVS-00ZTB0_WD-WMASU06  raid
   2      356GB   495GB  139GB                                                      raid
   4      495GB   500GB  5001MB  reiserfs     wwn-0x50014ee055b724ad

  jpo:~ # smartctl -i /dev/sdc
  smartctl 7.0 2019-05-21 r4917 [x86_64-linux-5.3.18-lp152.78-default] (SUSE RPM)
  Copyright (C) 2002-18, Bruce Allen, Christian Franke, www.smartmontools.org

  === START OF INFORMATION SECTION ===
  Model Family:     Western Digital Caviar Green
  Device Model:     WDC WD5000AAVS-00ZTB0
  Serial Number:    WD-WMASU0686160
  LU WWN Device Id: 5 0014ee 055b724ad
  Firmware Version: 01.01B01
  User Capacity:    500,107,862,016 bytes [500 GB]
  Sector Size:      512 bytes logical/physical
  Device is:        In smartctl database [for details use: -P show]
  ATA Version is:   ATA8-ACS (minor revision not indicated)
  SATA Version is:  SATA 2.5, 3.0 Gb/s
  Local Time is:    Thu Jul  8 11:32:35 2021 UTC
  SMART support is: Available - device has SMART capability.
  SMART support is: Enabled

that I plan to stripe together to use to protect the first.  The Caviars
are listed as variable speed, but in practice they apparently are just
5400 rpm, so I'd like to take advantage of striping to make them as fast
as possible.  This isn't the black magic ;-) of RAID10-on-two-drives,
so I don't have to think of one as "front" and one as "back", but do I
want more than one partition on each to stripe 4 or 6 slices to avoid
hammering on one, or do I just go with each device as a whole and let
mdadm handle the magic for me?

I also plan to use a partition on the 1T drive, but once I have the
striped metadevice do I particularly want or particlularly not want to
slice a partition out of it?  I figured I would partition since that
would let me exactly match the mirror halves to each other.

Oh, and to make this more fun the two 500s are actually part of a 3-dev
RAID5 set holding the data to migrate to the 1T to then mirror, so I
don't get to destructively play with this a dozen times :-)


Thanks in advance & have a great day!

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

