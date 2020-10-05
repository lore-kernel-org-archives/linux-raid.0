Return-Path: <SRS0=oy2H=DM=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15D99C4363A
	for <linux-raid@archiver.kernel.org>; Mon,  5 Oct 2020 13:10:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABD6D207BC
	for <linux-raid@archiver.kernel.org>; Mon,  5 Oct 2020 13:10:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nN4NbDN+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbgJENKk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 5 Oct 2020 09:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbgJENKj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 5 Oct 2020 09:10:39 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81CF2C0613CE
        for <linux-raid@vger.kernel.org>; Mon,  5 Oct 2020 06:10:39 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id v8so9027311iom.6
        for <linux-raid@vger.kernel.org>; Mon, 05 Oct 2020 06:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=/LyOHQHqaEjItyl+ZhF14eMN5Bf5oVeQZrNej3HFbqk=;
        b=nN4NbDN+OkzQfGyle3IDbh4u4+C/pYFzewOM/567GIQPdUwcJDEBseVHZrD59fsHNe
         9CDv4G7FffXcUcP7L0rLlJ4JBDVtZ/g1HHw3CgqCMuc8atilfQFPnA/SKSPg3rzPeJld
         PSHtwKxATLAYKykh9HNbIRtE+FA6PPOOnlWLqvg2eRXPD8MgzPrNTe5bvO0J5q1sxetm
         YPze2VPxTJLpvkhVQrwZAsUXV73WHuJqyZWNogqQ3p/OANHCgCUzinuaN9htyE8hjWcZ
         girT3/zRZq1AI4/VWG5Bw6Ig1v7JPWd+C2WoYxH/nVXn+VRXQHzlLu+oZEErjhSQfUK9
         QS5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=/LyOHQHqaEjItyl+ZhF14eMN5Bf5oVeQZrNej3HFbqk=;
        b=N8N4bcSOsZNXeuzy50D41kTaK2r46vmMTICKT+zxj4D/2ATFTjU9o2hqRqetLCSmNq
         YhR5KGxKiVeQNNE1/pgKh7YGyXooZ3LIC3UKlsePcTHhJncMGalUZZhz+zvbu2azdupW
         25EemPGCd/LhhGOOWHKemLVGdwmEiNnN6jDeqBAmIVloUEGvmrdx+NiI4q809fHFe+CK
         FYW6v4GFIRiS9AkSH4EioRNoyIhZsmqZfkbZzYx9z2ndAyAt8m76TKdQUDHfsUe9fuf8
         Bb0cEKHzK6vu++gnhFdwGjNsYbvBGzMcUDm0NFULavTd4Eazr2eU2aHdaqmhMYiA92RT
         mWng==
X-Gm-Message-State: AOAM5319p/21Hoq4uaxNJpRLWmE1EBpECN85NF+Ed3ujjfGawoI7DQqW
        wIrUSsqgt2TPxebBqGX1AQ41hWNSFGzNq+aHvX8WScsoynNJlg==
X-Google-Smtp-Source: ABdhPJwGyYzCRuWZYSp9xyDkOlfg4ts9sZntuQn8wlzB/NEagWOecpPRK48ay/hKSDGfQsQXIDx0SK9foPZ8udXMKcA=
X-Received: by 2002:a6b:d214:: with SMTP id q20mr10961170iob.23.1601903436973;
 Mon, 05 Oct 2020 06:10:36 -0700 (PDT)
MIME-Version: 1.0
From:   Daniel Sanabria <sanabria.d@gmail.com>
Date:   Mon, 5 Oct 2020 14:10:25 +0100
Message-ID: <CAHscji30ACa2d0qz-nr5vqPYOP642dwjS5BY07g2DQS7GBG-2A@mail.gmail.com>
Subject: do i need to give up on this setup
To:     Linux-RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi all,

Scrubbing ( # echo check >
/sys/devices/virtual/block/md1/md/sync_action) is killing my array :(

I'm attaching details of the array and disks (bloody wd greens) as
well as journalctl errors providing some details about the issue.

If you have any pointers on what might be the cause of this as well as
any recommendations on how to improve things please let me thank you
in advance ...

I have backups of the data so happy to move this to a different setup
you might recommend (apps will be mostly reading from the array via
NFS since most of the content will be media).

My suspicion is that a timer service is kicking in and disrupting the
scrubbing somehow but can't pinpoint what causes this.

Thanks again,

Dan

PD. Apologies for the verbosity of the logs but wasn't really sure if
you guys accept links from paste services


[dan@lamachine ~]$ sudo mdadm --detail /dev/md1
[sudo] password for dan:
/dev/md1:
           Version : 1.2
     Creation Time : Fri Feb 15 12:26:56 2019
        Raid Level : raid5
        Array Size : 4194039808 (3.91 TiB 4.29 TB)
     Used Dev Size : 2097019904 (1999.87 GiB 2147.35 GB)
      Raid Devices : 3
     Total Devices : 3
       Persistence : Superblock is persistent

     Intent Bitmap : Internal

       Update Time : Mon Oct  5 11:35:31 2020
             State : clean, degraded
    Active Devices : 2
   Working Devices : 2
    Failed Devices : 1
     Spare Devices : 0

            Layout : left-symmetric
        Chunk Size : 512K

Consistency Policy : bitmap

    Number   Major   Minor   RaidDevice State
       0       8       33        0      active sync   /dev/sdc1
       1       8       49        1      active sync   /dev/sdd1
       -       0        0        2      removed

       3       8       65        -      faulty   /dev/sde1
[dan@lamachine ~]$

[dan@lamachine ~]$ sudo hdparm -I /dev/sdc
[sudo] password for dan:

/dev/sdc:

ATA device, with non-removable media
Model Number:       WDC WD30EZRX-00D8PB0
Serial Number:      WD-WCC4NCWT13RF
Firmware Revision:  80.00A80
Transport:          Serial, SATA 1.0a, SATA II Extensions, SATA Rev
2.5, SATA Rev 2.6, SATA Rev 3.0
Standards:
Supported: 9 8 7 6 5
Likely used: 9
Configuration:
Logical max current
cylinders 16383 16383
heads 16 16
sectors/track 63 63
--
CHS current addressable sectors:    16514064
LBA    user addressable sectors:   268435455
LBA48  user addressable sectors:  5860531055
Logical  Sector size:                   512 bytes
Physical Sector size:                  4096 bytes
device size with M = 1024*1024:     2861587 MBytes
device size with M = 1000*1000:     3000591 MBytes (3000 GB)
cache/buffer size  = unknown
Nominal Media Rotation Rate: 5400
Capabilities:
LBA, IORDY(can be disabled)
Queue depth: 32
Standby timer values: spec'd by Standard, with device specific minimum
R/W multiple sector transfer: Max = 16 Current = 0
DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6
     Cycle time: min=120ns recommended=120ns
PIO: pio0 pio1 pio2 pio3 pio4
     Cycle time: no flow control=120ns  IORDY flow control=120ns
Commands/features:
Enabled Supported:
   * SMART feature set
    Security Mode feature set
   * Power Management feature set
   * Write cache
   * Look-ahead
   * Host Protected Area feature set
   * WRITE_BUFFER command
   * READ_BUFFER command
   * NOP cmd
   * DOWNLOAD_MICROCODE
    Power-Up In Standby feature set
   * SET_FEATURES required to spinup after power up
    SET_MAX security extension
   * 48-bit Address feature set
   * Device Configuration Overlay feature set
   * Mandatory FLUSH_CACHE
   * FLUSH_CACHE_EXT
   * SMART error logging
   * SMART self-test
   * General Purpose Logging feature set
   * 64-bit World wide name
   * WRITE_UNCORRECTABLE_EXT command
   * {READ,WRITE}_DMA_EXT_GPL commands
   * Segmented DOWNLOAD_MICROCODE
   * Gen1 signaling speed (1.5Gb/s)
   * Gen2 signaling speed (3.0Gb/s)
   * Gen3 signaling speed (6.0Gb/s)
   * Native Command Queueing (NCQ)
   * Host-initiated interface power management
   * Phy event counters
   * NCQ priority information
   * READ_LOG_DMA_EXT equivalent to READ_LOG_EXT
   * DMA Setup Auto-Activate optimization
    Device-initiated interface power management
   * Software settings preservation
   * SMART Command Transport (SCT) feature set
   * SCT Write Same (AC2)
   * SCT Features Control (AC4)
   * SCT Data Tables (AC5)
    unknown 206[12] (vendor specific)
    unknown 206[13] (vendor specific)
    unknown 206[14] (vendor specific)
Security:
Master password revision code = 65534
supported
not enabled
not locked
not frozen
not expired: security count
supported: enhanced erase
414min for SECURITY ERASE UNIT. 414min for ENHANCED SECURITY ERASE UNIT.
Logical Unit WWN Device Identifier: 50014ee25fc9e460
NAA : 5
IEEE OUI : 0014ee
Unique ID : 25fc9e460
Checksum: correct
[dan@lamachine ~]$ sudo hdparm -I /dev/sde

/dev/sde:

ATA device, with non-removable media
Model Number:       WDC WD30EZRX-00D8PB0
Serial Number:      WD-WCC4N1294906
Firmware Revision:  80.00A80
Transport:          Serial, SATA 1.0a, SATA II Extensions, SATA Rev
2.5, SATA Rev 2.6, SATA Rev 3.0
Standards:
Supported: 9 8 7 6 5
Likely used: 9
Configuration:
Logical max current
cylinders 16383 16383
heads 16 16
sectors/track 63 63
--
CHS current addressable sectors:    16514064
LBA    user addressable sectors:   268435455
LBA48  user addressable sectors:  5860531055
Logical  Sector size:                   512 bytes
Physical Sector size:                  4096 bytes
device size with M = 1024*1024:     2861587 MBytes
device size with M = 1000*1000:     3000591 MBytes (3000 GB)
cache/buffer size  = unknown
Nominal Media Rotation Rate: 5400
Capabilities:
LBA, IORDY(can be disabled)
Queue depth: 32
Standby timer values: spec'd by Standard, with device specific minimum
R/W multiple sector transfer: Max = 16 Current = 0
DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6
     Cycle time: min=120ns recommended=120ns
PIO: pio0 pio1 pio2 pio3 pio4
     Cycle time: no flow control=120ns  IORDY flow control=120ns
Commands/features:
Enabled Supported:
   * SMART feature set
    Security Mode feature set
   * Power Management feature set
   * Write cache
   * Look-ahead
   * Host Protected Area feature set
   * WRITE_BUFFER command
   * READ_BUFFER command
   * NOP cmd
   * DOWNLOAD_MICROCODE
    Power-Up In Standby feature set
   * SET_FEATURES required to spinup after power up
    SET_MAX security extension
   * 48-bit Address feature set
   * Device Configuration Overlay feature set
   * Mandatory FLUSH_CACHE
   * FLUSH_CACHE_EXT
   * SMART error logging
   * SMART self-test
   * General Purpose Logging feature set
   * 64-bit World wide name
   * WRITE_UNCORRECTABLE_EXT command
   * {READ,WRITE}_DMA_EXT_GPL commands
   * Segmented DOWNLOAD_MICROCODE
   * Gen1 signaling speed (1.5Gb/s)
   * Gen2 signaling speed (3.0Gb/s)
   * Gen3 signaling speed (6.0Gb/s)
   * Native Command Queueing (NCQ)
   * Host-initiated interface power management
   * Phy event counters
   * NCQ priority information
   * READ_LOG_DMA_EXT equivalent to READ_LOG_EXT
   * DMA Setup Auto-Activate optimization
    Device-initiated interface power management
   * Software settings preservation
   * SMART Command Transport (SCT) feature set
   * SCT Write Same (AC2)
   * SCT Features Control (AC4)
   * SCT Data Tables (AC5)
    unknown 206[12] (vendor specific)
    unknown 206[13] (vendor specific)
    unknown 206[14] (vendor specific)
Security:
Master password revision code = 65534
supported
not enabled
not locked
not frozen
not expired: security count
supported: enhanced erase
458min for SECURITY ERASE UNIT. 458min for ENHANCED SECURITY ERASE UNIT.
Logical Unit WWN Device Identifier: 50014ee25f968120
NAA : 5
IEEE OUI : 0014ee
Unique ID : 25f968120
Checksum: correct
[dan@lamachine ~]$ sudo hdparm -I /dev/sdd

/dev/sdd:

ATA device, with non-removable media
Model Number:       WDC WD30EZRX-00D8PB0
Serial Number:      WD-WCC4NPRDD6D7
Firmware Revision:  80.00A80
Transport:          Serial, SATA 1.0a, SATA II Extensions, SATA Rev
2.5, SATA Rev 2.6, SATA Rev 3.0
Standards:
Supported: 9 8 7 6 5
Likely used: 9
Configuration:
Logical max current
cylinders 16383 16383
heads 16 16
sectors/track 63 63
--
CHS current addressable sectors:    16514064
LBA    user addressable sectors:   268435455
LBA48  user addressable sectors:  5860533168
Logical  Sector size:                   512 bytes
Physical Sector size:                  4096 bytes
device size with M = 1024*1024:     2861588 MBytes
device size with M = 1000*1000:     3000592 MBytes (3000 GB)
cache/buffer size  = unknown
Nominal Media Rotation Rate: 5400
Capabilities:
LBA, IORDY(can be disabled)
Queue depth: 32
Standby timer values: spec'd by Standard, with device specific minimum
R/W multiple sector transfer: Max = 16 Current = 0
DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6
     Cycle time: min=120ns recommended=120ns
PIO: pio0 pio1 pio2 pio3 pio4
     Cycle time: no flow control=120ns  IORDY flow control=120ns
Commands/features:
Enabled Supported:
   * SMART feature set
    Security Mode feature set
   * Power Management feature set
   * Write cache
   * Look-ahead
   * Host Protected Area feature set
   * WRITE_BUFFER command
   * READ_BUFFER command
   * NOP cmd
   * DOWNLOAD_MICROCODE
    Power-Up In Standby feature set
   * SET_FEATURES required to spinup after power up
    SET_MAX security extension
   * 48-bit Address feature set
   * Device Configuration Overlay feature set
   * Mandatory FLUSH_CACHE
   * FLUSH_CACHE_EXT
   * SMART error logging
   * SMART self-test
   * General Purpose Logging feature set
   * 64-bit World wide name
   * WRITE_UNCORRECTABLE_EXT command
   * {READ,WRITE}_DMA_EXT_GPL commands
   * Segmented DOWNLOAD_MICROCODE
   * Gen1 signaling speed (1.5Gb/s)
   * Gen2 signaling speed (3.0Gb/s)
   * Gen3 signaling speed (6.0Gb/s)
   * Native Command Queueing (NCQ)
   * Host-initiated interface power management
   * Phy event counters
   * NCQ priority information
   * READ_LOG_DMA_EXT equivalent to READ_LOG_EXT
   * DMA Setup Auto-Activate optimization
    Device-initiated interface power management
   * Software settings preservation
   * SMART Command Transport (SCT) feature set
   * SCT Write Same (AC2)
   * SCT Features Control (AC4)
   * SCT Data Tables (AC5)
    unknown 206[12] (vendor specific)
    unknown 206[13] (vendor specific)
    unknown 206[14] (vendor specific)
Security:
Master password revision code = 65534
supported
not enabled
not locked
not frozen
not expired: security count
supported: enhanced erase
414min for SECURITY ERASE UNIT. 414min for ENHANCED SECURITY ERASE UNIT.
Logical Unit WWN Device Identifier: 50014ee25fca27b1
NAA : 5
IEEE OUI : 0014ee
Unique ID : 25fca27b1
Checksum: correct
[dan@lamachine ~]$


truncated journalctl logs:

Oct 05 10:57:11 lamachine systemd-logind[1571]: Session 8 logged out.
Waiting for processes to exit.
Oct 05 10:57:11 lamachine systemd-logind[1571]: Removed session 8.
Oct 05 11:00:35 lamachine kernel: ata7: SATA link up 6.0 Gbps (SStatus
133 SControl 300)
Oct 05 11:00:35 lamachine smartd[1480]: Device: /dev/sdc [SAT], failed
to read SMART Attribute Data
Oct 05 11:00:35 lamachine kernel: ata7.00: configured for UDMA/133
Oct 05 11:00:35 lamachine smartd[1480]: Sending warning via
/usr/libexec/smartmontools/smartdnotify to root ...
Oct 05 11:00:35 lamachine smartd[1480]: Warning via
/usr/libexec/smartmontools/smartdnotify to root: successful
Oct 05 11:00:35 lamachine postfix/pickup[2347]: EFF87608EF11: uid=0 from=<root>
Oct 05 11:00:35 lamachine postfix/cleanup[4225]: EFF87608EF11:
message-id=<20201005100035.EFF87608EF11@lamachine.localdomain>
Oct 05 11:00:36 lamachine postfix/qmgr[2080]: EFF87608EF11:
from=<root@lamachine.localdomain>, size=524, nrcpt=1 (queue active)
Oct 05 11:00:36 lamachine postfix/local[4228]: EFF87608EF11:
to=<root@lamachine.localdomain>, orig_to=<root>, relay=local,
delay=0.15, delays=0.09/0.02/0/0.04, dsn=2.0.0, status=sent (delivered
to mailbox)
Oct 05 11:00:36 lamachine postfix/qmgr[2080]: EFF87608EF11: removed
Oct 05 11:08:36 lamachine sshd[3936]: Timeout, client not responding
from user dan 192.168.1.113 port 54226
Oct 05 11:08:36 lamachine sshd[3933]: pam_unix(sshd:session): session
closed for user dan
Oct 05 11:08:36 lamachine systemd-logind[1571]: Session 7 logged out.
Waiting for processes to exit.
Oct 05 11:08:36 lamachine sudo[3990]: pam_unix(sudo:session): session
closed for user root
Oct 05 11:08:36 lamachine systemd-logind[1571]: Removed session 7.
Oct 05 11:29:33 lamachine smartd[1480]: Device: /dev/sdc [SAT], read
SMART Attribute Data worked again, warning condition reset after 1
email
Oct 05 11:30:43 lamachine kernel: ata9: link is slow to respond,
please be patient (ready=0)
Oct 05 11:30:47 lamachine kernel: ata9: COMRESET failed (errno=-16)
Oct 05 11:30:53 lamachine kernel: ata9: link is slow to respond,
please be patient (ready=0)
Oct 05 11:30:57 lamachine kernel: ata9: COMRESET failed (errno=-16)
Oct 05 11:31:03 lamachine kernel: ata9: link is slow to respond,
please be patient (ready=0)
Oct 05 11:31:32 lamachine kernel: ata9: COMRESET failed (errno=-16)
Oct 05 11:31:32 lamachine kernel: ata9: limiting SATA link speed to 3.0 Gbps
Oct 05 11:31:37 lamachine smartd[1480]: Device: /dev/sde [SAT], failed
to read SMART Attribute Data
Oct 05 11:31:37 lamachine smartd[1480]: Sending warning via
/usr/libexec/smartmontools/smartdnotify to root ...
Oct 05 11:31:37 lamachine kernel: ata9: COMRESET failed (errno=-16)
Oct 05 11:31:37 lamachine kernel: ata9: reset failed, giving up
Oct 05 11:31:37 lamachine kernel: ata9.00: disabled
Oct 05 11:31:37 lamachine kernel: sd 8:0:0:0: [sde] tag#7 FAILED
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK cmd_age=0s
Oct 05 11:31:37 lamachine kernel: sd 8:0:0:0: [sde] tag#6 FAILED
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK cmd_age=124s
Oct 05 11:31:37 lamachine kernel: sd 8:0:0:0: [sde] tag#6 CDB:
Read(16) 88 00 00 00 00 00 45 29 f4 d8 00 00 05 40 00 00
Oct 05 11:31:37 lamachine kernel: sd 8:0:0:0: [sde] tag#7 CDB:
Read(16) 88 00 00 00 00 00 45 2a 78 18 00 00 05 40 00 00
Oct 05 11:31:37 lamachine kernel: blk_update_request: I/O error, dev
sde, sector 1160411160 op 0x0:(READ) flags 0x4000 phys_seg 168 prio
class 0
Oct 05 11:31:37 lamachine kernel: blk_update_request: I/O error, dev
sde, sector 1160377560 op 0x0:(READ) flags 0x4000 phys_seg 168 prio
class 0
Oct 05 11:31:37 lamachine kernel: sd 8:0:0:0: [sde] tag#9 FAILED
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK cmd_age=0s
Oct 05 11:31:37 lamachine kernel: sd 8:0:0:0: [sde] tag#16 FAILED
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK cmd_age=0s
Oct 05 11:31:37 lamachine kernel: sd 8:0:0:0: [sde] tag#9 CDB:
Read(16) 88 00 00 00 00 00 45 29 fa 18 00 00 05 40 00 00
Oct 05 11:31:37 lamachine kernel: sd 8:0:0:0: [sde] tag#16 CDB:
Read(16) 88 00 00 00 00 00 45 2a 82 98 00 00 05 40 00 00
Oct 05 11:31:37 lamachine kernel: blk_update_request: I/O error, dev
sde, sector 1160413848 op 0x0:(READ) flags 0x4000 phys_seg 168 prio
class 0
Oct 05 11:31:37 lamachine kernel: blk_update_request: I/O error, dev
sde, sector 1160378904 op 0x0:(READ) flags 0x4000 phys_seg 168 prio
class 0
Oct 05 11:31:37 lamachine kernel: sd 8:0:0:0: [sde] tag#10 FAILED
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK cmd_age=0s
Oct 05 11:31:37 lamachine kernel: sd 8:0:0:0: [sde] tag#18 FAILED
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK cmd_age=0s
Oct 05 11:31:37 lamachine kernel: sd 8:0:0:0: [sde] tag#10 CDB:
Read(16) 88 00 00 00 00 00 45 29 ff 58 00 00 05 40 00 00
Oct 05 11:31:37 lamachine kernel: sd 8:0:0:0: [sde] tag#18 CDB:
Read(16) 88 00 00 00 00 00 45 2a 8d 18 00 00 05 40 00 00
Oct 05 11:31:37 lamachine kernel: blk_update_request: I/O error, dev
sde, sector 1160416536 op 0x0:(READ) flags 0x4000 phys_seg 168 prio
class 0
Oct 05 11:31:37 lamachine kernel: blk_update_request: I/O error, dev
sde, sector 1160380248 op 0x0:(READ) flags 0x4000 phys_seg 168 prio
class 0
Oct 05 11:31:37 lamachine kernel: sd 8:0:0:0: [sde] tag#11 FAILED
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK cmd_age=0s
Oct 05 11:31:37 lamachine kernel: sd 8:0:0:0: [sde] tag#31 FAILED
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK cmd_age=0s
Oct 05 11:31:37 lamachine kernel: sd 8:0:0:0: [sde] tag#11 CDB:
Read(16) 88 00 00 00 00 00 45 2a 04 98 00 00 05 40 00 00
Oct 05 11:31:37 lamachine kernel: sd 8:0:0:0: [sde] tag#31 CDB:
Read(16) 88 00 00 00 00 00 45 2a 97 98 00 00 05 40 00 00
Oct 05 11:31:37 lamachine kernel: blk_update_request: I/O error, dev
sde, sector 1160419224 op 0x0:(READ) flags 0x4000 phys_seg 168 prio
class 0
Oct 05 11:31:37 lamachine kernel: blk_update_request: I/O error, dev
sde, sector 1160381592 op 0x0:(READ) flags 0x4000 phys_seg 168 prio
class 0
Oct 05 11:31:37 lamachine kernel: sd 8:0:0:0: [sde] tag#18 FAILED
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK cmd_age=0s
Oct 05 11:31:37 lamachine kernel: sd 8:0:0:0: [sde] tag#18 CDB:
Read(16) 88 00 00 00 00 00 45 2a b7 18 00 00 05 40 00 00
Oct 05 11:31:37 lamachine kernel: blk_update_request: I/O error, dev
sde, sector 1160427288 op 0x0:(READ) flags 0x4000 phys_seg 168 prio
class 0
Oct 05 11:31:37 lamachine kernel: sd 8:0:0:0: [sde] tag#12 FAILED
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK cmd_age=0s
Oct 05 11:31:37 lamachine kernel: sd 8:0:0:0: [sde] tag#12 CDB:
Read(16) 88 00 00 00 00 00 45 2a 09 d8 00 00 05 40 00 00
Oct 05 11:31:37 lamachine kernel: blk_update_request: I/O error, dev
sde, sector 1160382936 op 0x0:(READ) flags 0x4000 phys_seg 168 prio
class 0
Oct 05 11:31:37 lamachine smartd[1480]: Warning via
/usr/libexec/smartmontools/smartdnotify to root: successful
Oct 05 11:31:38 lamachine postfix/pickup[4381]: 00E50608EF11: uid=0 from=<root>
Oct 05 11:31:38 lamachine postfix/cleanup[4522]: 00E50608EF11:
message-id=<20201005103138.00E50608EF11@lamachine.localdomain>
Oct 05 11:31:38 lamachine postfix/qmgr[2080]: 00E50608EF11:
from=<root@lamachine.localdomain>, size=524, nrcpt=1 (queue active)
Oct 05 11:31:38 lamachine postfix/local[4524]: 00E50608EF11:
to=<root@lamachine.localdomain>, orig_to=<root>, relay=local,
delay=0.11, delays=0.08/0.01/0/0.03, dsn=2.0.0, status=sent (delivered
to mailbox)
Oct 05 11:31:38 lamachine postfix/qmgr[2080]: 00E50608EF11: removed
Oct 05 11:31:47 lamachine kernel: INFO: task md1_resync:3091 blocked
for more than 120 seconds.
Oct 05 11:31:47 lamachine kernel:       Not tainted
4.18.0-193.14.2.el8_2.x86_64 #1
Oct 05 11:31:47 lamachine kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 05 11:31:47 lamachine kernel: md1_resync      D    0  3091      2 0x80004080
Oct 05 11:31:47 lamachine kernel: Call Trace:
Oct 05 11:31:47 lamachine kernel:  ? __schedule+0x24f/0x650
Oct 05 11:31:47 lamachine kernel:  schedule+0x2f/0xa0
Oct 05 11:31:47 lamachine kernel:  raid5_get_active_stripe+0x469/0x5f0 [raid456]
Oct 05 11:31:47 lamachine kernel:  ? finish_wait+0x80/0x80
Oct 05 11:31:47 lamachine kernel:  raid5_sync_request+0x387/0x3b0 [raid456]
Oct 05 11:31:47 lamachine kernel:  ? cpumask_next+0x17/0x20
Oct 05 11:31:47 lamachine kernel:  ? is_mddev_idle+0xcc/0x12a
Oct 05 11:31:47 lamachine kernel:  md_do_sync.cold.83+0x424/0x953
Oct 05 11:31:47 lamachine kernel:  ? xfrm_user_net_init+0x90/0xa0
Oct 05 11:31:47 lamachine kernel:  ? __switch_to_asm+0x41/0x70
Oct 05 11:31:47 lamachine kernel:  ? finish_wait+0x80/0x80
Oct 05 11:31:47 lamachine kernel:  ? md_register_thread+0xd0/0xd0
Oct 05 11:31:47 lamachine kernel:  md_thread+0x94/0x150
Oct 05 11:31:47 lamachine kernel:  kthread+0x112/0x130
Oct 05 11:31:47 lamachine kernel:  ? kthread_flush_work_fn+0x10/0x10
Oct 05 11:31:47 lamachine kernel:  ret_from_fork+0x35/0x40
Oct 05 11:32:41 lamachine kernel: ata10: SATA link up 3.0 Gbps
(SStatus 123 SControl 300)
Oct 05 11:32:46 lamachine kernel: ata10.00: qc timeout (cmd 0xec)
Oct 05 11:32:47 lamachine kernel: ata10.00: failed to IDENTIFY (I/O
error, err_mask=0x4)
Oct 05 11:32:47 lamachine kernel: ata10.00: revalidation failed (errno=-5)
Oct 05 11:32:48 lamachine kernel: ata10: SATA link up 3.0 Gbps
(SStatus 123 SControl 300)
Oct 05 11:32:58 lamachine kernel: ata10.00: qc timeout (cmd 0xec)
Oct 05 11:32:59 lamachine kernel: ata10.00: failed to IDENTIFY (I/O
error, err_mask=0x4)
Oct 05 11:32:59 lamachine kernel: ata10.00: revalidation failed (errno=-5)
Oct 05 11:32:59 lamachine kernel: ata10: limiting SATA link speed to 1.5 Gbps
Oct 05 11:32:59 lamachine kernel: ata10: SATA link up 3.0 Gbps
(SStatus 123 SControl 310)
Oct 05 11:33:30 lamachine kernel: ata10.00: qc timeout (cmd 0xec)
Oct 05 11:33:30 lamachine kernel: ata10.00: failed to IDENTIFY (I/O
error, err_mask=0x4)
Oct 05 11:33:30 lamachine kernel: ata10.00: revalidation failed (errno=-5)
Oct 05 11:33:30 lamachine kernel: ata10.00: disabled
Oct 05 11:33:32 lamachine kernel: ata10: SATA link up 3.0 Gbps
(SStatus 123 SControl 310)
Oct 05 11:33:50 lamachine kernel: INFO: task md1_raid5:1304 blocked
for more than 120 seconds.
Oct 05 11:33:50 lamachine kernel:       Not tainted
4.18.0-193.14.2.el8_2.x86_64 #1
Oct 05 11:33:50 lamachine kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 05 11:33:50 lamachine kernel: md1_raid5       D    0  1304      2 0x80004000
Oct 05 11:33:50 lamachine kernel: Call Trace:
Oct 05 11:33:50 lamachine kernel:  ? __schedule+0x24f/0x650
Oct 05 11:33:50 lamachine kernel:  schedule+0x2f/0xa0
Oct 05 11:33:50 lamachine kernel:  io_schedule+0x12/0x40
Oct 05 11:33:50 lamachine kernel:  blk_mq_get_tag+0x119/0x250
Oct 05 11:33:50 lamachine kernel:  ? finish_wait+0x80/0x80
Oct 05 11:33:50 lamachine kernel:  blk_mq_get_request+0xb7/0x3c0
Oct 05 11:33:50 lamachine kernel:  blk_mq_make_request+0x134/0x5a0
Oct 05 11:33:50 lamachine kernel:  generic_make_request+0xcf/0x310
Oct 05 11:33:50 lamachine kernel:  ops_run_io+0x881/0xd30 [raid456]
Oct 05 11:33:50 lamachine kernel:  ? ops_complete_check+0x50/0x50 [raid456]
Oct 05 11:33:50 lamachine kernel:  handle_stripe+0xc47/0x1f80 [raid456]
Oct 05 11:33:50 lamachine kernel:  ? __wake_up_common+0x7a/0x190
Oct 05 11:33:50 lamachine kernel:
handle_active_stripes.isra.73+0x3e7/0x5c0 [raid456]
Oct 05 11:33:50 lamachine kernel:  raid5d+0x392/0x5b0 [raid456]
Oct 05 11:33:50 lamachine kernel:  ? schedule_timeout+0x20d/0x310
Oct 05 11:33:50 lamachine kernel:  ? _raw_spin_unlock_irqrestore+0x11/0x20
Oct 05 11:33:50 lamachine kernel:  ? md_register_thread+0xd0/0xd0
Oct 05 11:33:50 lamachine kernel:  md_thread+0x94/0x150
Oct 05 11:33:50 lamachine kernel:  ? finish_wait+0x80/0x80
Oct 05 11:33:50 lamachine kernel:  kthread+0x112/0x130
Oct 05 11:33:50 lamachine kernel:  ? kthread_flush_work_fn+0x10/0x10
Oct 05 11:33:50 lamachine kernel:  ret_from_fork+0x35/0x40
Oct 05 11:33:50 lamachine kernel: INFO: task md1_resync:3091 blocked
for more than 120 seconds.
Oct 05 11:33:50 lamachine kernel:       Not tainted
4.18.0-193.14.2.el8_2.x86_64 #1
Oct 05 11:33:50 lamachine kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 05 11:33:50 lamachine kernel: md1_resync      D    0  3091      2 0x80004080
Oct 05 11:33:50 lamachine kernel: Call Trace:
Oct 05 11:33:50 lamachine kernel:  ? __schedule+0x24f/0x650
Oct 05 11:33:50 lamachine kernel:  schedule+0x2f/0xa0
Oct 05 11:33:50 lamachine kernel:  raid5_get_active_stripe+0x469/0x5f0 [raid456]
Oct 05 11:33:50 lamachine kernel:  ? finish_wait+0x80/0x80
Oct 05 11:33:50 lamachine kernel:  raid5_sync_request+0x387/0x3b0 [raid456]
Oct 05 11:33:50 lamachine kernel:  ? cpumask_next+0x17/0x20
Oct 05 11:33:50 lamachine kernel:  ? is_mddev_idle+0xcc/0x12a
Oct 05 11:33:50 lamachine kernel:  md_do_sync.cold.83+0x424/0x953
Oct 05 11:33:50 lamachine kernel:  ? xfrm_user_net_init+0x90/0xa0
Oct 05 11:33:50 lamachine kernel:  ? __switch_to_asm+0x41/0x70
Oct 05 11:33:50 lamachine kernel:  ? finish_wait+0x80/0x80
Oct 05 11:33:50 lamachine kernel:  ? md_register_thread+0xd0/0xd0
Oct 05 11:33:50 lamachine kernel:  md_thread+0x94/0x150
Oct 05 11:33:50 lamachine kernel:  kthread+0x112/0x130
Oct 05 11:33:50 lamachine kernel:  ? kthread_flush_work_fn+0x10/0x10
Oct 05 11:33:50 lamachine kernel:  ret_from_fork+0x35/0x40
Oct 05 11:34:39 lamachine kernel: ata8.00: exception Emask 0x0 SAct
0xffffffff SErr 0x0 action 0x6 frozen
Oct 05 11:34:39 lamachine kernel: ata8.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata8.00: cmd
60/40:00:d8:2f:2b/05:00:45:00:00/40 tag 0 ncq dma 688128 in
                                           res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata8.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata8.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata8.00: cmd
60/40:08:18:35:2b/05:00:45:00:00/40 tag 1 ncq dma 688128 in
                                           res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata8.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata8.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata8.00: cmd
60/40:10:58:3a:2b/05:00:45:00:00/40 tag 2 ncq dma 688128 in
                                           res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata8.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata8.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata8.00: cmd
60/40:18:98:3f:2b/05:00:45:00:00/40 tag 3 ncq dma 688128 in
                                           res
40/00:00:01:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata8.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata8.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata8.00: cmd
60/40:20:d8:44:2b/05:00:45:00:00/40 tag 4 ncq dma 688128 in
                                           res
40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata8.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata8.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata8.00: cmd
60/40:28:18:4a:2b/05:00:45:00:00/40 tag 5 ncq dma 688128 in
                                           res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata8.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata8.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata8.00: cmd
60/40:30:58:4f:2b/05:00:45:00:00/40 tag 6 ncq dma 688128 in
                                           res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata8.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata8.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata8.00: cmd
60/40:38:98:54:2b/05:00:45:00:00/40 tag 7 ncq dma 688128 in
                                           res
40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata8.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata8.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata8.00: cmd
60/40:40:d8:59:2b/05:00:45:00:00/40 tag 8 ncq dma 688128 in
                                           res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata8.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata8.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata8.00: cmd
60/40:48:18:5f:2b/05:00:45:00:00/40 tag 9 ncq dma 688128 in
                                           res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata8.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata8.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata8.00: cmd
60/40:50:58:64:2b/05:00:45:00:00/40 tag 10 ncq dma 688128 in
                                           res
40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata8.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata8.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata8.00: cmd
60/40:58:98:69:2b/05:00:45:00:00/40 tag 11 ncq dma 688128 in
                                           res
40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata8.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata8.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata8.00: cmd
60/40:60:d8:6e:2b/05:00:45:00:00/40 tag 12 ncq dma 688128 in
                                           res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata8.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata8.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata8.00: cmd
60/40:68:18:74:2b/05:00:45:00:00/40 tag 13 ncq dma 688128 in
                                           res
40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata8.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata8.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata8.00: cmd
60/40:70:58:79:2b/05:00:45:00:00/40 tag 14 ncq dma 688128 in
                                           res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata8.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata8.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata8.00: cmd
60/40:78:98:7e:2b/05:00:45:00:00/40 tag 15 ncq dma 688128 in
                                           res
40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata8.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata8.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata8.00: cmd
60/40:80:18:b3:2b/05:00:45:00:00/40 tag 16 ncq dma 688128 in
                                           res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata8.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata8.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata8.00: cmd
60/40:88:58:b8:2b/05:00:45:00:00/40 tag 17 ncq dma 688128 in
                                           res
40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata8.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata8.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata8.00: cmd
60/40:90:98:bd:2b/05:00:45:00:00/40 tag 18 ncq dma 688128 in
                                           res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata8.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata8.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata8.00: cmd
60/40:98:d8:c2:2b/05:00:45:00:00/40 tag 19 ncq dma 688128 in
                                           res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata8.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata8.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata8.00: cmd
60/40:a0:18:c8:2b/05:00:45:00:00/40 tag 20 ncq dma 688128 in
                                           res
40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata8.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata8.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata8.00: cmd
60/40:a8:58:cd:2b/05:00:45:00:00/40 tag 21 ncq dma 688128 in
                                           res
40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata8.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata8.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata8.00: cmd
60/40:b0:d8:83:2b/05:00:45:00:00/40 tag 22 ncq dma 688128 in
                                           res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata8.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata8.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata8.00: cmd
60/40:b8:18:89:2b/05:00:45:00:00/40 tag 23 ncq dma 688128 in
                                           res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata8.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata8.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata8.00: cmd
60/40:c0:58:8e:2b/05:00:45:00:00/40 tag 24 ncq dma 688128 in
                                           res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata8.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata8.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata8.00: cmd
60/40:c8:98:93:2b/05:00:45:00:00/40 tag 25 ncq dma 688128 in
                                           res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata8.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata8.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata8.00: cmd
60/40:d0:d8:98:2b/05:00:45:00:00/40 tag 26 ncq dma 688128 in
                                           res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata8.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata8.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata8.00: cmd
60/40:d8:18:9e:2b/05:00:45:00:00/40 tag 27 ncq dma 688128 in
                                           res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata8.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata8.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata8.00: cmd
60/40:e0:58:a3:2b/05:00:45:00:00/40 tag 28 ncq dma 688128 in
                                           res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata8.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata8.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata8.00: cmd
60/40:e8:98:a8:2b/05:00:45:00:00/40 tag 29 ncq dma 688128 in
                                           res
40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata8.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata8.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata8.00: cmd
60/40:f0:d8:ad:2b/05:00:45:00:00/40 tag 30 ncq dma 688128 in
                                           res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata8.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata8.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata8.00: cmd
60/40:f8:98:d2:2b/05:00:45:00:00/40 tag 31 ncq dma 688128 in
                                           res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata8.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata8: hard resetting link
Oct 05 11:34:39 lamachine kernel: ata7.00: exception Emask 0x0 SAct
0xffffffff SErr 0x0 action 0x6 frozen
Oct 05 11:34:39 lamachine kernel: ata7.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata7.00: cmd
60/40:00:d8:98:2b/05:00:45:00:00/40 tag 0 ncq dma 688128 in
                                           res
40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata7.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata7.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata7.00: cmd
60/40:08:18:9e:2b/05:00:45:00:00/40 tag 1 ncq dma 688128 in
                                           res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata7.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata7.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata7.00: cmd
60/40:10:58:a3:2b/05:00:45:00:00/40 tag 2 ncq dma 688128 in
                                           res
40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata7.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata7.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata7.00: cmd
60/40:18:d8:2f:2b/05:00:45:00:00/40 tag 3 ncq dma 688128 in
                                           res
40/00:00:01:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata7.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata7.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata7.00: cmd
60/40:20:18:35:2b/05:00:45:00:00/40 tag 4 ncq dma 688128 in
                                           res
40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata7.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata7.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata7.00: cmd
60/40:28:58:3a:2b/05:00:45:00:00/40 tag 5 ncq dma 688128 in
                                           res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata7.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata7.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata7.00: cmd
60/40:30:98:3f:2b/05:00:45:00:00/40 tag 6 ncq dma 688128 in
                                           res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata7.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata7.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata7.00: cmd
60/40:38:d8:44:2b/05:00:45:00:00/40 tag 7 ncq dma 688128 in
                                           res
40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata7.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata7.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata7.00: cmd
60/40:40:18:4a:2b/05:00:45:00:00/40 tag 8 ncq dma 688128 in
                                           res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata7.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata7.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata7.00: cmd
60/40:48:58:4f:2b/05:00:45:00:00/40 tag 9 ncq dma 688128 in
                                           res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata7.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata7.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata7.00: cmd
60/40:50:98:54:2b/05:00:45:00:00/40 tag 10 ncq dma 688128 in
                                           res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata7.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata7.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata7.00: cmd
60/40:58:d8:59:2b/05:00:45:00:00/40 tag 11 ncq dma 688128 in
                                           res
40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata7.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata7.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata7.00: cmd
60/40:60:18:5f:2b/05:00:45:00:00/40 tag 12 ncq dma 688128 in
                                           res
40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata7.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata7.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata7.00: cmd
60/40:68:58:64:2b/05:00:45:00:00/40 tag 13 ncq dma 688128 in
                                           res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata7.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata7.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata7.00: cmd
60/40:70:98:69:2b/05:00:45:00:00/40 tag 14 ncq dma 688128 in
                                           res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata7.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata7.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata7.00: cmd
60/40:78:d8:6e:2b/05:00:45:00:00/40 tag 15 ncq dma 688128 in
                                           res
40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata7.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata7.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata7.00: cmd
60/40:80:98:a8:2b/05:00:45:00:00/40 tag 16 ncq dma 688128 in
                                           res
40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata7.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata7.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata7.00: cmd
60/40:88:d8:ad:2b/05:00:45:00:00/40 tag 17 ncq dma 688128 in
                                           res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata7.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata7.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata7.00: cmd
60/40:90:18:74:2b/05:00:45:00:00/40 tag 18 ncq dma 688128 in
                                           res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata7.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata7.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata7.00: cmd
60/40:98:58:79:2b/05:00:45:00:00/40 tag 19 ncq dma 688128 in
                                           res
40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata7.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata7.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata7.00: cmd
60/40:a0:98:7e:2b/05:00:45:00:00/40 tag 20 ncq dma 688128 in
                                           res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata7.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata7.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata7.00: cmd
60/40:a8:d8:83:2b/05:00:45:00:00/40 tag 21 ncq dma 688128 in
                                           res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata7.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata7.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata7.00: cmd
60/40:b0:18:89:2b/05:00:45:00:00/40 tag 22 ncq dma 688128 in
                                           res
40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata7.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata7.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata7.00: cmd
60/40:b8:58:8e:2b/05:00:45:00:00/40 tag 23 ncq dma 688128 in
                                           res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata7.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata7.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata7.00: cmd
60/40:c0:18:b3:2b/05:00:45:00:00/40 tag 24 ncq dma 688128 in
                                           res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata7.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata7.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata7.00: cmd
60/40:c8:58:b8:2b/05:00:45:00:00/40 tag 25 ncq dma 688128 in
                                           res
40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata7.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata7.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata7.00: cmd
60/40:d0:98:bd:2b/05:00:45:00:00/40 tag 26 ncq dma 688128 in
                                           res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata7.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata7.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata7.00: cmd
60/40:d8:d8:c2:2b/05:00:45:00:00/40 tag 27 ncq dma 688128 in
                                           res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata7.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata7.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata7.00: cmd
60/40:e0:18:c8:2b/05:00:45:00:00/40 tag 28 ncq dma 688128 in
                                           res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata7.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata7.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata7.00: cmd
60/40:e8:58:cd:2b/05:00:45:00:00/40 tag 29 ncq dma 688128 in
                                           res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata7.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata7.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata7.00: cmd
60/40:f0:98:d2:2b/05:00:45:00:00/40 tag 30 ncq dma 688128 in
                                           res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata7.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata7.00: failed command: READ FPDMA QUEUED
Oct 05 11:34:39 lamachine kernel: ata7.00: cmd
60/40:f8:98:93:2b/05:00:45:00:00/40 tag 31 ncq dma 688128 in
                                           res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 05 11:34:39 lamachine kernel: ata7.00: status: { DRDY }
Oct 05 11:34:39 lamachine kernel: ata7: hard resetting link
Oct 05 11:34:40 lamachine kernel: ata8: SATA link up 6.0 Gbps (SStatus
133 SControl 300)
Oct 05 11:34:40 lamachine kernel: ata7: SATA link up 6.0 Gbps (SStatus
133 SControl 300)
Oct 05 11:34:45 lamachine kernel: ata7.00: qc timeout (cmd 0xec)
Oct 05 11:34:45 lamachine kernel: ata8.00: qc timeout (cmd 0xec)
Oct 05 11:34:46 lamachine kernel: ata7.00: failed to IDENTIFY (I/O
error, err_mask=0x4)
Oct 05 11:34:46 lamachine kernel: ata7.00: revalidation failed (errno=-5)
Oct 05 11:34:46 lamachine kernel: ata7: hard resetting link
Oct 05 11:34:46 lamachine kernel: ata8.00: failed to IDENTIFY (I/O
error, err_mask=0x4)
Oct 05 11:34:46 lamachine kernel: ata8.00: revalidation failed (errno=-5)
Oct 05 11:34:46 lamachine kernel: ata8: hard resetting link
Oct 05 11:34:46 lamachine kernel: ata7: SATA link up 6.0 Gbps (SStatus
133 SControl 300)
Oct 05 11:34:46 lamachine kernel: ata8: SATA link up 6.0 Gbps (SStatus
133 SControl 300)
Oct 05 11:34:57 lamachine kernel: ata7.00: qc timeout (cmd 0xec)
Oct 05 11:34:57 lamachine kernel: ata8.00: qc timeout (cmd 0xec)
Oct 05 11:34:57 lamachine kernel: ata8.00: failed to IDENTIFY (I/O
error, err_mask=0x4)
Oct 05 11:34:57 lamachine kernel: ata8.00: revalidation failed (errno=-5)
Oct 05 11:34:57 lamachine kernel: ata8: limiting SATA link speed to 3.0 Gbps
Oct 05 11:34:57 lamachine kernel: ata8: hard resetting link
Oct 05 11:34:57 lamachine kernel: ata7.00: failed to IDENTIFY (I/O
error, err_mask=0x4)
Oct 05 11:34:57 lamachine kernel: ata7.00: revalidation failed (errno=-5)
Oct 05 11:34:57 lamachine kernel: ata7: limiting SATA link speed to 3.0 Gbps
Oct 05 11:34:57 lamachine kernel: ata7: hard resetting link
Oct 05 11:34:58 lamachine kernel: ata7: SATA link up 6.0 Gbps (SStatus
133 SControl 320)
Oct 05 11:34:58 lamachine kernel: ata8: SATA link up 6.0 Gbps (SStatus
133 SControl 320)
Oct 05 11:35:29 lamachine kernel: ata7.00: qc timeout (cmd 0xec)
Oct 05 11:35:29 lamachine kernel: ata8.00: qc timeout (cmd 0xec)
Oct 05 11:35:29 lamachine kernel: ata8.00: failed to IDENTIFY (I/O
error, err_mask=0x4)
Oct 05 11:35:29 lamachine kernel: ata8.00: revalidation failed (errno=-5)
Oct 05 11:35:29 lamachine kernel: ata8.00: disabled
Oct 05 11:35:29 lamachine kernel: ata7.00: failed to IDENTIFY (I/O
error, err_mask=0x4)
Oct 05 11:35:29 lamachine kernel: ata7.00: revalidation failed (errno=-5)
Oct 05 11:35:29 lamachine kernel: ata7.00: disabled
Oct 05 11:35:30 lamachine kernel: ata7: SATA link up 6.0 Gbps (SStatus
133 SControl 320)
Oct 05 11:35:30 lamachine kernel: ata8: SATA link up 6.0 Gbps (SStatus
133 SControl 320)
Oct 05 11:35:31 lamachine kernel: ata8: EH complete
Oct 05 11:35:31 lamachine kernel: ata7: EH complete
Oct 05 11:35:31 lamachine kernel: scsi_io_completion_action: 115
callbacks suppressed
Oct 05 11:35:31 lamachine kernel: sd 7:0:0:0: [sdd] tag#12 FAILED
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK cmd_age=0s
Oct 05 11:35:31 lamachine kernel: sd 7:0:0:0: [sdd] tag#12 CDB:
Read(16) 88 00 00 00 00 00 45 2b d7 d8 00 00 05 40 00 00
Oct 05 11:35:31 lamachine kernel: print_req_error: 115 callbacks suppressed
Oct 05 11:35:31 lamachine kernel: blk_update_request: I/O error, dev
sdd, sector 1160501208 op 0x0:(READ) flags 0x4000 phys_seg 168 prio
class 0
Oct 05 11:35:31 lamachine kernel: sd 6:0:0:0: [sdc] tag#18 FAILED
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK cmd_age=0s
Oct 05 11:35:31 lamachine kernel: sd 6:0:0:0: [sdc] tag#18 CDB:
Read(16) 88 00 00 00 00 00 45 2b d7 d8 00 00 05 40 00 00
Oct 05 11:35:31 lamachine kernel: blk_update_request: I/O error, dev
sdc, sector 1160501208 op 0x0:(READ) flags 0x4000 phys_seg 168 prio
class 0
Oct 05 11:35:31 lamachine kernel: sd 7:0:0:0: [sdd] tag#13 FAILED
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK cmd_age=0s
Oct 05 11:35:31 lamachine kernel: sd 7:0:0:0: [sdd] tag#13 CDB:
Read(16) 88 00 00 00 00 00 45 2b dd 18 00 00 05 40 00 00
Oct 05 11:35:31 lamachine kernel: blk_update_request: I/O error, dev
sdd, sector 1160502552 op 0x0:(READ) flags 0x4000 phys_seg 168 prio
class 0
Oct 05 11:35:31 lamachine kernel: sd 6:0:0:0: [sdc] tag#19 FAILED
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK cmd_age=0s
Oct 05 11:35:31 lamachine kernel: sd 6:0:0:0: [sdc] tag#19 CDB:
Read(16) 88 00 00 00 00 00 45 2b dd 18 00 00 05 40 00 00
Oct 05 11:35:31 lamachine kernel: blk_update_request: I/O error, dev
sdc, sector 1160502552 op 0x0:(READ) flags 0x4000 phys_seg 168 prio
class 0
Oct 05 11:35:31 lamachine kernel: sd 7:0:0:0: [sdd] tag#14 FAILED
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK cmd_age=0s
Oct 05 11:35:31 lamachine kernel: sd 7:0:0:0: [sdd] tag#14 CDB:
Read(16) 88 00 00 00 00 00 45 2b e2 58 00 00 05 40 00 00
Oct 05 11:35:31 lamachine kernel: blk_update_request: I/O error, dev
sdd, sector 1160503896 op 0x0:(READ) flags 0x4000 phys_seg 168 prio
class 0
Oct 05 11:35:31 lamachine kernel: sd 6:0:0:0: [sdc] tag#20 FAILED
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK cmd_age=0s
Oct 05 11:35:31 lamachine kernel: sd 6:0:0:0: [sdc] tag#20 CDB:
Read(16) 88 00 00 00 00 00 45 2b e2 58 00 00 05 40 00 00
Oct 05 11:35:31 lamachine kernel: blk_update_request: I/O error, dev
sdc, sector 1160503896 op 0x0:(READ) flags 0x4000 phys_seg 168 prio
class 0
Oct 05 11:35:31 lamachine kernel: sd 7:0:0:0: [sdd] tag#15 FAILED
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK cmd_age=0s
Oct 05 11:35:31 lamachine kernel: sd 7:0:0:0: [sdd] tag#15 CDB:
Read(16) 88 00 00 00 00 00 45 2b e7 98 00 00 05 40 00 00
Oct 05 11:35:31 lamachine kernel: blk_update_request: I/O error, dev
sdd, sector 1160505240 op 0x0:(READ) flags 0x4000 phys_seg 168 prio
class 0
Oct 05 11:35:31 lamachine kernel: sd 6:0:0:0: [sdc] tag#21 FAILED
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK cmd_age=0s
Oct 05 11:35:31 lamachine kernel: sd 6:0:0:0: [sdc] tag#21 CDB:
Read(16) 88 00 00 00 00 00 45 2b e7 98 00 00 05 40 00 00
Oct 05 11:35:31 lamachine kernel: blk_update_request: I/O error, dev
sdc, sector 1160505240 op 0x0:(READ) flags 0x4000 phys_seg 168 prio
class 0
Oct 05 11:35:31 lamachine kernel: sd 7:0:0:0: [sdd] tag#16 FAILED
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK cmd_age=0s
Oct 05 11:35:31 lamachine kernel: sd 7:0:0:0: [sdd] tag#16 CDB:
Read(16) 88 00 00 00 00 00 45 2b ec d8 00 00 05 40 00 00
Oct 05 11:35:31 lamachine kernel: blk_update_request: I/O error, dev
sdd, sector 1160506584 op 0x0:(READ) flags 0x4000 phys_seg 168 prio
class 0
Oct 05 11:35:31 lamachine kernel: sd 6:0:0:0: [sdc] tag#22 FAILED
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK cmd_age=0s
Oct 05 11:35:31 lamachine kernel: sd 6:0:0:0: [sdc] tag#22 CDB:
Read(16) 88 00 00 00 00 00 45 2b ec d8 00 00 05 40 00 00
Oct 05 11:35:31 lamachine kernel: blk_update_request: I/O error, dev
sdc, sector 1160506584 op 0x0:(READ) flags 0x4000 phys_seg 168 prio
class 0
Oct 05 11:35:31 lamachine kernel: md/raid:md1: 23277 read_errors > 23276 stripes
Oct 05 11:35:31 lamachine kernel: md/raid:md1: Too many read errors,
failing device sde1.
Oct 05 11:35:31 lamachine kernel: md/raid:md1: Disk failure on sde1,
disabling device.
                                  md/raid:md1: Operation continuing on
2 devices.
Oct 05 11:35:31 lamachine kernel: md/raid:md1: read error not
correctable (sector 1160433448 on sde1).
Oct 05 11:35:31 lamachine kernel: md/raid:md1: read error not
correctable (sector 1160433456 on sde1).
Oct 05 11:35:31 lamachine kernel: md/raid:md1: read error not
correctable (sector 1160433336 on sde1).
Oct 05 11:35:31 lamachine kernel: md/raid:md1: read error not
correctable (sector 1160433464 on sde1).
Oct 05 11:35:31 lamachine kernel: md/raid:md1: read error not
correctable (sector 1160433472 on sde1).
Oct 05 11:35:31 lamachine kernel: md/raid:md1: read error not
correctable (sector 1160433344 on sde1).
Oct 05 11:35:31 lamachine kernel: md/raid:md1: read error not
correctable (sector 1160433480 on sde1).
Oct 05 11:35:31 lamachine kernel: md/raid:md1: read error not
correctable (sector 1160433352 on sde1).
Oct 05 11:35:31 lamachine kernel: md/raid:md1: read error not
correctable (sector 1160433488 on sde1).
Oct 05 11:35:31 lamachine kernel: md/raid:md1: read error not
correctable (sector 1160433360 on sde1).
Oct 05 11:35:31 lamachine kernel: md: super_written gets error=10
Oct 05 11:35:31 lamachine kernel: md: super_written gets error=10
Oct 05 11:35:31 lamachine kernel: md: super_written gets error=10
Oct 05 11:35:31 lamachine kernel: md: super_written gets error=10
Oct 05 11:35:31 lamachine kernel: md: super_written gets error=10
