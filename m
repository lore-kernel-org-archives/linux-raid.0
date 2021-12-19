Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15383C433EF
	for <linux-raid@archiver.kernel.org>; Sun, 19 Dec 2021 04:31:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233818AbhLSEbx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 18 Dec 2021 23:31:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbhLSEbx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 18 Dec 2021 23:31:53 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBAD6C061574
        for <linux-raid@vger.kernel.org>; Sat, 18 Dec 2021 20:31:52 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id j2so18212958ybg.9
        for <linux-raid@vger.kernel.org>; Sat, 18 Dec 2021 20:31:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=Q34TWpSvH+wB9oWFDBcOiahCrNvBB4k5wOGlhVvReaE=;
        b=oJhTLe8H5CfVYR5TIIrqe/aOsLDudW/K6mDOEATQVsR/alCrLHQZrOAwL6XK9NZh1j
         nHWcMGI8n6YXPwqoRr6155GUq0IZyIq3EKySxZBYFfDwdegvra5Lsv5MPo/4psozOrHw
         9n1ya0IYpf2MdEj/GJeZZFMFqc+j3Yqj2zr+fYcJQmD43+IIkBMXoDplbA4DywTLC5ZC
         Zr6tGYT+3BFuRdu9h3bMHt3F+2XO2QfhgbeXpFKlRs4TAZgZwFcEtwsc1iY98JYS6Az4
         CSrGb55F1nsfLII/GBelz4iilinDRzqmcLeAg3KLNIS9WoJljjPTD//X5xGbjWH7mT+q
         b/SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=Q34TWpSvH+wB9oWFDBcOiahCrNvBB4k5wOGlhVvReaE=;
        b=NdDaSZ5rGiyggwgQq2Z5GZH3bBOugz/ZG4y+O17YMo2O0p4WcGbi0pviREjc+Esp/f
         wCJO/wrcko49MI+R5V8CrttEiNg8W0ge0OS6oB62KLkgSORNcSR51E0F92ZTzzblEHll
         ixnDTDpjSkAvaLPlKtSYby5xg1jqfKySi7m5VuH4G2HMTSBad0IaIDCnuOeNXaVPSeOR
         LLuiaYtLshXBhZROth7ecfixlvKVREKVgvqk409OaN75bXujLK+U5q19E2b8F/6ks05b
         oZ+xTj9H6NYugyiRYugVxMQQ/Oxm4Ro9YGbS0ccCqCkjqtcu/wOJ9CbUTseIxsduNE/n
         g6Mw==
X-Gm-Message-State: AOAM532gr37V4eOWB62kzyakrIZMgPYPiIYWRFJLzFYQaAPbc96wg3ZW
        d1fcgrQbTGZ+V+iODdMyQefCTRHSUJnb+tVW06EPIvNzokE=
X-Google-Smtp-Source: ABdhPJxjHEuBMkw57JWRz1DVFAluyPZu6tpWsfc/sfnBQu5okB+tqd52r3FBPQhaqjky67aw6YOyW07YZEkmyHOGCes=
X-Received: by 2002:a25:ec03:: with SMTP id j3mr14355209ybh.203.1639888311298;
 Sat, 18 Dec 2021 20:31:51 -0800 (PST)
MIME-Version: 1.0
From:   Tony Bush <thecompguru@gmail.com>
Date:   Sat, 18 Dec 2021 23:31:39 -0500
Message-ID: <CAA9kLn1nZZKHLahjkyJzChgTMC2WKEoyJG2PhHzeXbD_qY_-yw@mail.gmail.com>
Subject: Need help Recover raid5 array
To:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I have a small ubuntu server that I was upgrading the hardware to and
in the process lost my raid.  I changed the CPU, MOBO, RAM.  I added a
new-to-this-system SSD also to replace the current SSD(in a future
step).  I forgot that this new-to-this-system SSD had Windows 10 OS on
it and I believe it tried to boot while I was working on hooking up my
monitor.  So I think that it saw my raid drives and tried to fdisk
them.  I did mdadm directly to drive and not to a partition(big
mistake I know now).  So I think the drives were seen as corrupted and
fdisk corrected the formatting.  I lost my super blocks on 4 of 5
drives.  These are shucked external 10TB drives and one even shows up
with 'my drive' partition label and 2 files that came with those
drives.  I want to recover my raid and files but don't want to make it
worse.  I have not mounted the drives as writable.  I think the damage
should be limited, but I don't know mdadm well.  I have been digging
for a few days on options and most advice is generic and bad and I
feel would make it worse.  I don't know the original order the drives
were in.

1 drive is fully intact, probably due to a BIOS sata config not
enabling all drives when i first booted.

The size makes this impractical to dd onto new disks.  The drives were
99% full and I was about to add 2 new drives.  Now if i can recover
this, i will be starting a new array correctly and transfering files
to that.

To fix, I have been leaning toward making the drives ready only and
using an overlay file. Like here:
https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Ma=
king_the_harddisks_read-only_using_an_overlay_file
But i dont understand all the commands well enough to work this for my
situation.  Seems like since I don't know the original drive
arrangement that may be adding an additional level of complexity.  If
I can figure out the read only and overlay, I still don't know exactly
the right way to proceed on the mdadm front.  Please anyone who has a
handle on a situation like this, let me know what I should do.  Thanks


**Original command history for array:
sudo mdadm --create --verbose /dev/md0 --level=3D5 --raid-devices=3D3
/dev/sdc /dev/sdd /dev/sde
cat /proc/mdstat
sudo mkfs.ext4 -F /dev/md0
sudo mkdir -p /media/raid
sudo mount /dev/md0 /media/raid
df -h -x devtmpfs -x tmpfs
cat /proc/mdstat
sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf
sudo update-initramfs -u

sudo  umount /dev/md0
sudo  umount /dev/md0 -f
sudo  umount /dev/md0
sudo  fsck.ext4 -f /dev/md0
sudo  fsck.ext4
sudo  fsck.ext4 -f /dev/md0 -p
sudo  fsck.ext4 -f /dev/md0 -p -y
sudo  fsck.ext4 -f /dev/md0 -y
sudo  resize2fs /dev/md0
sudo fdisk -l
sudo parted -a optimal /dev/sdf
sudo -i mdadm --add /dev/md0 /dev/sdf
watch cat /proc/mdstat
sudo mdadm --grow /dev/md0 --raid-devices=3D4
sudo thunar
watch cat /proc/mdstat
sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf

cat /proc/mdstat
sudo mount /dev/md0 /media/raid
sudo mdadm --assemble --scan
sudo mount /dev/md0 /media/raid

sudo fdisk -l
sudo parted -s -a optimal /dev/sdb mklabel gpt
parted /dev/sdb
sudo parted /dev/sdb
sudo mdadm --add /dev/md0 /dev/sdb1
sudo mdadm --add /dev/md0 /dev/sdb
cat /proc/mdstat
mdadm --grow --raid-devices=3D4 /dev/md0
sudo mdadm --grow --raid-devices=3D4 /dev/md0
sudo mdadm --grow --raid-devices=3D5 /dev/md0
cat /proc/mdstat
sudo e2fsck -f /dev/md0
cat /proc/mdstat
sudo resize2fs /dev/md0
cat /proc/mdstat
sudo e2fsck -f /dev/md0
sudo resize2fs /dev/md0




**Here are some current details:
uname -a
Linux server 5.11.0-40-generic #44-Ubuntu SMP Wed Oct 20 16:16:42 UTC
2021 x86_64 x86_64 x86_64 GNU/Linux

mdadm --version
mdadm - v4.1 - 2018-10-01

**
sudo smartctl -H -i -l scterc /dev/sda
smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.11.0-41-generic] (local build=
)
Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Western Digital Ultrastar He10/12
Device Model:     WDC WD100EZAZ-11TDBA0
Serial Number:    1EK7U77Z
LU WWN Device Id: 5 000cca 27eedd3d5
Firmware Version: 83.H0A83
User Capacity:    10,000,831,348,736 bytes [10.0 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Form Factor:      3.5 inches
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2, ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.2, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Tue Nov 30 00:07:28 2021 EST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read: Disabled
          Write: Disabled

**
sudo smartctl -H -i -l scterc /dev/sdb
smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.11.0-41-generic] (local build=
)
Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Western Digital Ultrastar He10/12
Device Model:     WDC WD100EMAZ-00WJTA0
Serial Number:    JEHXKMMM
LU WWN Device Id: 5 000cca 267db1416
Firmware Version: 83.H0A83
User Capacity:    10,000,831,348,736 bytes [10.0 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Form Factor:      3.5 inches
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2, ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.2, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Tue Nov 30 00:08:34 2021 EST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

**
sudo smartctl -H -i -l scterc /dev/sdc
smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.11.0-41-generic] (local build=
)
Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Western Digital Ultrastar He10/12
Device Model:     WDC WD100EMAZ-00WJTA0
Serial Number:    2YHVAJ8D
LU WWN Device Id: 5 000cca 273da10a9
Firmware Version: 83.H0A83
User Capacity:    10,000,831,348,736 bytes [10.0 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Form Factor:      3.5 inches
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2, ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.2, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Tue Nov 30 00:11:29 2021 EST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

**
sudo smartctl -H -i -l scterc /dev/sdd
smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.11.0-41-generic] (local build=
)
Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Western Digital Ultrastar He10/12
Device Model:     WDC WD100EMAZ-00WJTA0
Serial Number:    2YHVABZD
LU WWN Device Id: 5 000cca 273da1024
Firmware Version: 83.H0A83
User Capacity:    10,000,831,348,736 bytes [10.0 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Form Factor:      3.5 inches
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2, ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.2, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Tue Nov 30 00:11:58 2021 EST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

**
sudo smartctl -H -i -l scterc /dev/sde
smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.11.0-41-generic] (local build=
)
Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Western Digital Ultrastar He10/12
Device Model:     WDC WD100EMAZ-00WJTA0
Serial Number:    2YHV9GVD
LU WWN Device Id: 5 000cca 273da0cbc
Firmware Version: 83.H0A83
User Capacity:    10,000,831,348,736 bytes [10.0 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Form Factor:      3.5 inches
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2, ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.2, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Tue Nov 30 00:12:53 2021 EST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

***************
sudo mdadm --examine /dev/sda
/dev/sda:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)

sudo mdadm --examine /dev/sda1
/dev/sda1:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at   4294967295 (type ff)
Partition[1] :   4294967295 sectors at   4294967295 (type ff)
Partition[2] :   4294967295 sectors at   4294967295 (type ff)
Partition[3] :    740229375 sectors at   4294967295 (type ff)

sudo mdadm --examine /dev/sdb
/dev/sdb:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)

sudo mdadm --examine /dev/sdb1
mdadm: cannot open /dev/sdb1: No such file or directory

sudo mdadm --examine /dev/sdc
/dev/sdc:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)

sudo mdadm --examine /dev/sdc1
mdadm: cannot open /dev/sdc1: No such file or directory

sudo mdadm --examine /dev/sdd
/dev/sdd:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 93e81091:84ba78f0:eb8232d9:c3c995f0
           Name : bushserver:0  (local to host bushserver)
  Creation Time : Fri Nov 16 13:20:25 2018
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 19532616704 (9313.88 GiB 10000.70 GB)
     Array Size : 39065219072 (37255.50 GiB 40002.78 GB)
  Used Dev Size : 19532609536 (9313.87 GiB 10000.70 GB)
    Data Offset : 257024 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D256944 sectors, after=3D7168 sectors
          State : clean
    Device UUID : 2abcf2dc:f786e3fd:d22b7da9:7e8eec53

Internal Bitmap : 8 sectors from superblock
    Update Time : Sun Nov 28 15:27:11 2021
  Bad Block Log : 512 entries available at offset 48 sectors
       Checksum : e27debbf - correct
         Events : 213198

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D r=
eplacing)
$ sudo mdadm --examine /dev/sdd1
mdadm: cannot open /dev/sdd1: No such file or directory


sudo mdadm --examine /dev/sde
/dev/sde:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
$ sudo mdadm --examine /dev/sde1
mdadm: cannot open /dev/sde1: No such file or directory

****************************************************
sudo mdadm --detail /dev/md0
/dev/md0:
           Version : 1.2
        Raid Level : raid0
     Total Devices : 1
       Persistence : Superblock is persistent

             State : inactive
   Working Devices : 1

              Name : bushserver:0  (local to host bushserver)
              UUID : 93e81091:84ba78f0:eb8232d9:c3c995f0
            Events : 213198

    Number   Major   Minor   RaidDevice

       -       8       48        -        /dev/sdd
*******************************************************

./lsdrv
**Warning** The following utility(ies) failed to execute:
  sginfo
  pvs
  lvs
Some information may be missing.

PCI [nvme] 41:00.0 Non-Volatile memory controller: Phison Electronics
Corporation E12 NVMe Controller (rev 01)
=E2=94=94nvme nvme0 Force MP510                              {2111829300012=
91838A6}
 =E2=94=94nvme0n1 447.13g [259:0] Empty/Unknown
  =E2=94=9Cnvme0n1p1 431.03g [259:1] Empty/Unknown
  =E2=94=82=E2=94=94Mounted as /dev/nvme0n1p1 @ /
  =E2=94=9Cnvme0n1p2 1.00k [259:2] Empty/Unknown
  =E2=94=94nvme0n1p5 15.87g [259:3] Empty/Unknown
PCI [ahci] 00:17.0 SATA controller: Intel Corporation
Q170/Q150/B150/H170/H110/Z170/CM236 Chipset SATA Controller [AHCI
Mode] (rev 31)
=E2=94=9Cscsi 0:0:0:0 ATA      WDC WD100EZAZ-11
=E2=94=82=E2=94=94sda 9.10t [8:0] Empty/Unknown
=E2=94=82 =E2=94=94sda1 9.10t [8:1] Empty/Unknown
=E2=94=9Cscsi 1:0:0:0 ATA      WDC WD100EMAZ-00
=E2=94=82=E2=94=94sdb 9.10t [8:16] Empty/Unknown
=E2=94=9Cscsi 3:0:0:0 ATA      WDC WD100EMAZ-00
=E2=94=82=E2=94=94sdc 9.10t [8:32] Empty/Unknown
=E2=94=9Cscsi 4:0:0:0 ATA      WDC WD100EMAZ-00
=E2=94=82=E2=94=94sdd 9.10t [8:48] Empty/Unknown
=E2=94=82 =E2=94=94md0 0.00k [9:0] MD v1.2  () inactive, None (None) None
{00000000:-0000-00:00-0000-:000000000000}
=E2=94=82                  Empty/Unknown
=E2=94=94scsi 5:0:0:0 ATA      WDC WD100EMAZ-00
 =E2=94=94sde 9.10t [8:64] Empty/Unknown
PCI [ahci] 04:00.0 SATA controller: ASMedia Technology Inc. ASM1062
Serial ATA Controller (rev 02)
=E2=94=94scsi 6:x:x:x [Empty]
USB [usb-storage] Bus 001 Device 004: ID 1d6b:0104 Linux Foundation
Multifunction Composite Gadget {CAFEBABE}
=E2=94=94scsi 8:0:0:0 Linux    File-CD Gadget
 =E2=94=94sr0 1.00g [11:0] Empty/Unknown
Other Block Devices
=E2=94=9Cloop0 4.00k [7:0] Empty/Unknown
=E2=94=82=E2=94=94Mounted as /dev/loop0 @ /snap/bare/5
=E2=94=9Cloop1 144.60m [7:1] Empty/Unknown
=E2=94=82=E2=94=94Mounted as /dev/loop1 @ /snap/chromium/1810
=E2=94=9Cloop2 99.44m [7:2] Empty/Unknown
=E2=94=82=E2=94=94Mounted as /dev/loop2 @ /snap/core/11798
=E2=94=9Cloop3 99.44m [7:3] Empty/Unknown
=E2=94=82=E2=94=94Mounted as /dev/loop3 @ /snap/core/11993
=E2=94=9Cloop4 147.80m [7:4] Empty/Unknown
=E2=94=82=E2=94=94Mounted as /dev/loop4 @ /snap/chromium/1827
=E2=94=9Cloop5 55.49m [7:5] Empty/Unknown
=E2=94=82=E2=94=94Mounted as /dev/loop5 @ /snap/core18/2253
=E2=94=9Cloop6 55.50m [7:6] Empty/Unknown
=E2=94=82=E2=94=94Mounted as /dev/loop6 @ /snap/core18/2246
=E2=94=9Cloop7 65.21m [7:7] Empty/Unknown
=E2=94=82=E2=94=94Mounted as /dev/loop7 @ /snap/gtk-common-themes/1519
=E2=94=9Cloop8 164.76m [7:8] Empty/Unknown
=E2=94=82=E2=94=94Mounted as /dev/loop8 @ /snap/gnome-3-28-1804/161
=E2=94=9Cloop9 65.10m [7:9] Empty/Unknown
=E2=94=82=E2=94=94Mounted as /dev/loop9 @ /snap/gtk-common-themes/1515
=E2=94=9Cloop10 162.87m [7:10] Empty/Unknown
=E2=94=82=E2=94=94Mounted as /dev/loop10 @ /snap/gnome-3-28-1804/145
=E2=94=9Cloop11 0.00k [7:11] Empty/Unknown
=E2=94=9Czram0 1.96g [252:0] Empty/Unknown
=E2=94=9Czram1 1.96g [252:1] Empty/Unknown
=E2=94=9Czram2 1.96g [252:2] Empty/Unknown
=E2=94=9Czram3 1.96g [252:3] Empty/Unknown
=E2=94=9Czram4 1.96g [252:4] Empty/Unknown
=E2=94=9Czram5 1.96g [252:5] Empty/Unknown
=E2=94=9Czram6 1.96g [252:6] Empty/Unknown
=E2=94=94zram7 1.96g [252:7] Empty/Unknown

***********************************
at /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md0 : inactive sdd[1](S)
      9766308352 blocks super 1.2

unused devices: <none>
