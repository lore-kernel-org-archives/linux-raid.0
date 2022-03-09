Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FDB5C433EF
	for <linux-raid@archiver.kernel.org>; Wed,  9 Mar 2022 16:24:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233086AbiCIQZ1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 9 Mar 2022 11:25:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238044AbiCIQVP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 9 Mar 2022 11:21:15 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 376032B27E
        for <linux-raid@vger.kernel.org>; Wed,  9 Mar 2022 08:17:52 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id m12so3492282edc.12
        for <linux-raid@vger.kernel.org>; Wed, 09 Mar 2022 08:17:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=knigga.com; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=aWLnVj/5SgaPQuJGxWYhAsFHxjT9Ft7ppHurqfelK6I=;
        b=SO9eWE5Fm653ywy9gcGGTvhykDkrm+rEQ7G0xmFGwwK3RHfDDIbWmMWDEW8BkkGiyp
         CkM3co8PLKNe5AIbgdZ6Xu5a1oUHfrxaFLXw4IpN5D9pa/5peoIXmu/ae10DAvF5YfsR
         cD7Sj7XnrtEzRQj0ZcHgTkOCVkvnOfeKXOhNA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=aWLnVj/5SgaPQuJGxWYhAsFHxjT9Ft7ppHurqfelK6I=;
        b=yZ9qjXfHBhMt9NoB8PZtvXgmfFHumoEzqldVuuvCYDzVxtaAzk/FXiCdQ5HvY9p5QV
         HngwyclUf43XzjzU6nK5IczI/Cl1YgNPJO8Vq/L0vsouQaxfMC7ulqfl7CeStM7qDTcz
         R4C+EytKvOxt9DqOla/1NhkixSGHG+7vrARDRdHEe3t0w7bzsC1wpNMDnjFfvxF0tElF
         fmllxJ1D8yw2/n8Hmn+JM73USZ1UGqj77PhFlSk9Pl5nrOZYD2HaxHqhzxUclS3Bd8+V
         VqlwWJxGLtk1nhb7ovzLUhA4GPzRP/YY8EKIHHxYfgByG9e5GMkYcr95y6s9NE5oeTBU
         wGvQ==
X-Gm-Message-State: AOAM532NG42dR7awDeGke4+xeyEhLROGHJ6ESY0MHtnA3OaC1bWnOzPf
        Srqp32eRXyRRfXosxYS0l43chEXAYr6g3UOa5W4R6LnIYjVOgQ==
X-Google-Smtp-Source: ABdhPJzX/hq5iO1etCDHUaNW1sAUmjenqibO7qv80V78v//NQIFmG0nfoNbW5QofeKR+3jMz8zWX4JxJK7q5nVb0Tnk=
X-Received: by 2002:a50:ab53:0:b0:415:d2cc:de46 with SMTP id
 t19-20020a50ab53000000b00415d2ccde46mr173809edc.193.1646842670452; Wed, 09
 Mar 2022 08:17:50 -0800 (PST)
MIME-Version: 1.0
From:   Kristoffer Knigga <kris@knigga.com>
Date:   Wed, 9 Mar 2022 10:17:14 -0600
Message-ID: <CAKhSdW1zghNFqn2qemMZ7FJpiBcbAd0BcYifHmcM8WWPnai-=g@mail.gmail.com>
Subject: mdadm is unable to see Alder Lake IMSM array
To:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello,

I just built a new PC using an Intel i5-12600K CPU and an Asus Prime
H670-PLUS D4 motherboard.  Attached to the SATA ports on the
motherboard are two HDDs and an SSD.  I have enabled VMD, mapped the
SATA controller under VMD, and created a RAID1 array from the two HDDs
following the steps in Asus's RAID Configuration Guide
(https://dlcdnets.asus.com/pub/ASUS/mb/13MANUAL/RAID_Configuration_Guide_V2-EN.pdf).

However, mdadm doesn't seem to know what to do with the array.  I've
tried the stock Fedora 35 version of mdadm (mdadm-4.2-rc2.fc35) and
I've built mdadm 4.2 from source, most recently with DEBUG on.

When asked to assemble the array an error is reported on the member
disks about not having OROM/EFI properties or RAID superblock.

$ sudo mdadm --verbose --assemble --scan
mdadm: Assemble: looking for devices for further assembly
mdadm: select_devices: no recogniseable superblock on /dev/zram0
mdadm: select_devices: no recogniseable superblock on /dev/dm-0
mdadm: select_devices: no recogniseable superblock on /dev/sdd1
mdadm: path_attached_to_hba: hba:
/sys/devices/pci0000:00/0000:00:0e.0/pci10000:e0/10000:e0:17.0 - disk:
/sys/devices/pci0000:00/0000:00:14.0/usb2/2-8/2-8:1.0/host24/target24:0:0/24:0:0:0
mdadm: select_devices: Cannot assemble mbr metadata on /dev/sdd
mdadm: path_attached_to_hba: hba:
/sys/devices/pci0000:00/0000:00:0e.0/pci10000:e0/10000:e0:17.0 - disk:
/sys/devices/pci0000:00/0000:00:0e.0/pci10000:e0/10000:e0:17.0/ata32/host32/target32:0:0/32:0:0:0
mdadm: scan: cannot find pciExpDataStruct
mdadm: path_attached_to_hba: hba:
/sys/devices/pci0000:00/0000:00:0e.0/pci10000:e0/10000:e0:17.0 - disk:
/sys/devices/pci0000:00/0000:00:0e.0/pci10000:e0/10000:e0:17.0/ata32/host32/target32:0:0/32:0:0:0
mdadm: scan: cannot find pciExpDataStruct
mdadm: getinfo_super_imsm: enough: 0
mdadm: path_attached_to_hba: hba:
/sys/devices/pci0000:00/0000:00:0e.0/pci10000:e0/10000:e0:17.0 - disk:
/sys/devices/pci0000:00/0000:00:0e.0/pci10000:e0/10000:e0:17.0/ata32/host32/target32:0:0/32:0:0:0
mdadm: scan: cannot find pciExpDataStruct
mdadm: path_attached_to_hba: hba:
/sys/devices/pci0000:00/0000:00:0e.0/pci10000:e0/10000:e0:17.0 - disk:
/sys/devices/pci0000:00/0000:00:0e.0/pci10000:e0/10000:e0:17.0/ata32/host32/target32:0:0/32:0:0:0
mdadm: scan: cannot find pciExpDataStruct
mdadm: path_attached_to_hba: hba:
/sys/devices/pci0000:00/0000:00:0e.0/pci10000:e0/10000:e0:17.0 - disk:
/sys/devices/pci0000:00/0000:00:0e.0/pci10000:e0/10000:e0:17.0/ata32/host32/target32:0:0/32:0:0:0
mdadm: scan: cannot find pciExpDataStruct
mdadm: load_super_imsm: No OROM/EFI properties for /dev/sdc
mdadm: select_devices: no RAID superblock on /dev/sdc
mdadm: path_attached_to_hba: hba:
/sys/devices/pci0000:00/0000:00:0e.0/pci10000:e0/10000:e0:17.0 - disk:
/sys/devices/pci0000:00/0000:00:0e.0/pci10000:e0/10000:e0:17.0/ata31/host31/target31:0:0/31:0:0:0
mdadm: scan: cannot find pciExpDataStruct
mdadm: path_attached_to_hba: hba:
/sys/devices/pci0000:00/0000:00:0e.0/pci10000:e0/10000:e0:17.0 - disk:
/sys/devices/pci0000:00/0000:00:0e.0/pci10000:e0/10000:e0:17.0/ata31/host31/target31:0:0/31:0:0:0
mdadm: scan: cannot find pciExpDataStruct
mdadm: getinfo_super_imsm: enough: 0
mdadm: path_attached_to_hba: hba:
/sys/devices/pci0000:00/0000:00:0e.0/pci10000:e0/10000:e0:17.0 - disk:
/sys/devices/pci0000:00/0000:00:0e.0/pci10000:e0/10000:e0:17.0/ata31/host31/target31:0:0/31:0:0:0
mdadm: scan: cannot find pciExpDataStruct
mdadm: path_attached_to_hba: hba:
/sys/devices/pci0000:00/0000:00:0e.0/pci10000:e0/10000:e0:17.0 - disk:
/sys/devices/pci0000:00/0000:00:0e.0/pci10000:e0/10000:e0:17.0/ata31/host31/target31:0:0/31:0:0:0
mdadm: scan: cannot find pciExpDataStruct
mdadm: path_attached_to_hba: hba:
/sys/devices/pci0000:00/0000:00:0e.0/pci10000:e0/10000:e0:17.0 - disk:
/sys/devices/pci0000:00/0000:00:0e.0/pci10000:e0/10000:e0:17.0/ata31/host31/target31:0:0/31:0:0:0
mdadm: scan: cannot find pciExpDataStruct
mdadm: load_super_imsm: No OROM/EFI properties for /dev/sdb
mdadm: select_devices: no RAID superblock on /dev/sdb
mdadm: select_devices: no recogniseable superblock on /dev/sda3
mdadm: select_devices: no recogniseable superblock on /dev/sda2
mdadm: select_devices: Cannot assemble mbr metadata on /dev/sda1
mdadm: path_attached_to_hba: hba:
/sys/devices/pci0000:00/0000:00:0e.0/pci10000:e0/10000:e0:17.0 - disk:
/sys/devices/pci0000:00/0000:00:0e.0/pci10000:e0/10000:e0:17.0/ata29/host29/target29:0:0/29:0:0:0
mdadm: scan: cannot find pciExpDataStruct
mdadm: select_devices: Cannot assemble mbr metadata on /dev/sda
mdadm: select_devices: cannot open device /dev/sr1: No medium found
mdadm: select_devices: cannot open device /dev/sr0: No medium found
mdadm: scan_assemble: No arrays found in config file or automatically


However, when asked to examine the array members mdadm seems to see
the RAID information.

$ sudo mdadm --examine /dev/sdc
/dev/sdc:
          Magic : Intel Raid ISM Cfg Sig.
        Version : 1.3.00
    Orig Family : efb1dfab
         Family : efb1dfab
     Generation : 0000003b
  Creation Time : Unknown
     Attributes : All supported
           UUID : 0d6d6f84:7dc5c9bf:c813c382:07d52193
       Checksum : 0ce5c877 correct
    MPB Sectors : 2
          Disks : 2
   RAID Devices : 1

  Disk01 Serial : Z302PZ9Q
          State : active
             Id : 00000002
    Usable Size : 7814031360 (3.64 TiB 4.00 TB)

[Volume1]:
       Subarray : 0
           UUID : 095000c5:c6a0218c:307e4085:704eafdd
     RAID Level : 1 <-- 1
        Members : 2 <-- 2
          Slots : [UU] <-- [UU]
    Failed disk : none
      This Slot : 1
    Sector Size : 512
     Array Size : 7814031360 (3.64 TiB 4.00 TB)
   Per Dev Size : 7814031624 (3.64 TiB 4.00 TB)
  Sector Offset : 0
    Num Stripes : 30523560
     Chunk Size : 64 KiB <-- 64 KiB
       Reserved : 0
  Migrate State : initialize
      Map State : normal <-- uninitialized
     Checkpoint : 2406092 (512)
    Dirty State : clean
     RWH Policy : off
      Volume ID : 1

  Disk00 Serial : Z302Q06H
          State : active
             Id : 00000001
    Usable Size : 7814031360 (3.64 TiB 4.00 TB)


And running the 'assemble' command with IMSM_NO_PLATFORM set does work
as a workaround, but this makes it very difficult to install the OS to
the RAID array.

I've read that this problem can come from being unable to read EFI
vars from /sys/firmware/efi/efivars, but that doesn't seem to be the
case here.

$ ll /sys/firmware/efi/efivars | egrep -i 'rst|vmd'
-rw-r--r--. 1 root root     5 Feb 11 08:40
FirstBootFlag-ec87d643-eba4-4bb5-a1e5-3f3e36b20da9
-rw-r--r--. 1 root root    12 Feb 11 08:40
IntelRstFeatures-ca2fc9c8-71e7-4f72-b433-c284456ff72b
-rw-r--r--. 1 root root    68 Feb 11 08:40
IntelVmdOsVariable-61a14fe8-4dab-4a19-b1e3-97fb23d09212
-rw-r--r--. 1 root root    42 Feb 11 08:40
RstVmdV-193dfefa-a445-4302-99d8-ef3aad1a04c6
-rw-r--r--. 1 root root    16 Feb 11 08:40
VARSTORE_OCMR_SETTINGS_AP_DATA_NAME-a3a3b874-7636-4182-ba1e-f52c584494e3
-rw-r--r--. 1 root root 19135 Feb 11 08:40
VARSTORE_OCMR_SETTINGS_NAME-a3a3b874-7636-4182-ba1e-f52c584494e3


I'm running Fedora 35 fully up-to-date as of 9:00 CST 2022/03/09.

$ cat /etc/fedora-release
Fedora release 35 (Thirty Five)

$ uname -r
5.16.12-200.fc35.x86_64

$ mdadm --version
mdadm - v4.2 - 2021-12-30


Hardware information:

$ head /proc/cpuinfo
processor : 0
vendor_id : GenuineIntel
cpu family : 6
model : 151
model name : 12th Gen Intel(R) Core(TM) i5-12600K
stepping : 2
microcode : 0x18
cpu MHz : 800.073
cache size : 20480 KB
physical id : 0

$ sudo lspci | grep -i intel
0000:00:00.0 Host bridge: Intel Corporation Device 4648 (rev 02)
0000:00:02.0 VGA compatible controller: Intel Corporation AlderLake-S
GT1 (rev 0c)
0000:00:0a.0 Signal processing controller: Intel Corporation Platform
Monitoring Technology (rev 01)
0000:00:0e.0 RAID bus controller: Intel Corporation Volume Management
Device NVMe RAID Controller
0000:00:14.0 USB controller: Intel Corporation Alder Lake-S PCH USB
3.2 Gen 2x2 XHCI Controller (rev 11)
0000:00:14.2 RAM memory: Intel Corporation Alder Lake-S PCH Shared SRAM (rev 11)
0000:00:15.0 Serial bus controller: Intel Corporation Alder Lake-S PCH
I2C Controller #0 (rev 11)
0000:00:15.2 Serial bus controller: Intel Corporation Device 7ace (rev 11)
0000:00:16.0 Communication controller: Intel Corporation Alder Lake-S
PCH HECI Controller #1 (rev 11)
0000:00:17.0 System peripheral: Intel Corporation Device 09ab
0000:00:1a.0 PCI bridge: Intel Corporation Device 7ac8 (rev 11)
0000:00:1b.0 PCI bridge: Intel Corporation Device 7ac0 (rev 11)
0000:00:1c.0 PCI bridge: Intel Corporation Device 7ab8 (rev 11)
0000:00:1c.1 PCI bridge: Intel Corporation Device 7ab9 (rev 11)
0000:00:1c.2 PCI bridge: Intel Corporation Device 7aba (rev 11)
0000:00:1c.4 PCI bridge: Intel Corporation Device 7abc (rev 11)
0000:00:1f.0 ISA bridge: Intel Corporation Device 7a85 (rev 11)
0000:00:1f.3 Audio device: Intel Corporation Alder Lake-S HD Audio
Controller (rev 11)
0000:00:1f.4 SMBus: Intel Corporation Alder Lake-S PCH SMBus Controller (rev 11)
0000:00:1f.5 Serial bus controller: Intel Corporation Alder Lake-S PCH
SPI Controller (rev 11)
0000:04:00.0 Ethernet controller: Intel Corporation 82574L Gigabit
Network Connection
10000:e0:17.0 SATA controller: Intel Corporation Alder Lake-S PCH SATA
Controller [AHCI Mode] (rev 11)

$ sudo lspci -vs 0000:00:0e.0
0000:00:0e.0 RAID bus controller: Intel Corporation Volume Management
Device NVMe RAID Controller
DeviceName: Onboard - Other
Subsystem: ASUSTeK Computer Inc. Device 8694
Flags: bus master, fast devsel, latency 0
Memory at 6000000000 (64-bit, non-prefetchable) [size=32M]
Memory at 82000000 (32-bit, non-prefetchable) [size=32M]
Memory at 6003100000 (64-bit, non-prefetchable) [size=1M]
Capabilities: [80] MSI-X: Enable+ Count=19 Masked-
Capabilities: [90] Express Root Complex Integrated Endpoint, MSI 00
Capabilities: [e0] Power Management version 3
Kernel driver in use: vmd
Kernel modules: vmd

$ sudo lspci -vs 10000:e0:17.0
10000:e0:17.0 SATA controller: Intel Corporation Alder Lake-S PCH SATA
Controller [AHCI Mode] (rev 11) (prog-if 01 [AHCI 1.0])
Subsystem: ASUSTeK Computer Inc. Device 8694
Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 149
Memory at 82000000 (32-bit, non-prefetchable) [size=8K]
Memory at 82002800 (32-bit, non-prefetchable) [size=256]
I/O ports at <unassigned> [disabled]
I/O ports at <unassigned> [disabled]
I/O ports at <unassigned> [disabled]
Memory at 82002000 (32-bit, non-prefetchable) [size=2K]
Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
Capabilities: [70] Power Management version 3
Capabilities: [a8] SATA HBA v1.0
Kernel driver in use: ahci


I'm having a hard time figuring out where to go from here.  Does mdadm
not know how to deal with IMSM on this new hardware?  Or is hardware
not behaving correctly?

Any pointers are appreciated!

Kris Knigga
