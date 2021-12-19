Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AA36C433F5
	for <linux-raid@archiver.kernel.org>; Sun, 19 Dec 2021 17:17:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233289AbhLSRRW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 19 Dec 2021 12:17:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbhLSRRU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 19 Dec 2021 12:17:20 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A32AC061574
        for <linux-raid@vger.kernel.org>; Sun, 19 Dec 2021 09:17:20 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id j6-20020a17090a588600b001a78a5ce46aso10688241pji.0
        for <linux-raid@vger.kernel.org>; Sun, 19 Dec 2021 09:17:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=ZXZOOBpR163PwHWJ4xx1lMFloAS284lwzSXutDSwEP4=;
        b=UjdfbSBfFH4xfvbvSZIPJchL4eJCJyFvNKbnvZpvHX5F/+KCxtNF51jiMNt5SkVxY9
         LO58McSshp/X030GWGcES/Su+61hewDqmjRLBS2X2Ebn2wN1gA+E+9wjwBxl5ayEzkIh
         iV/kw/p41TQBxMorx95abCQ0hQYpD8r8nN++PjFPwpCncr17CJi/OQM03KPiDv0uAQXf
         zabJ0lmkeVh7GCJE1EQ2j8SbH9NzjGI0gMP0gLtmawUUnes2/j81A5v/9hp+slBcldfT
         2aVhdP81y5BW6wRVnQyHYBG85yQUFqhgR22H5KUSFspIbXgd0n9Ix/YRIb4GCfnlBJrG
         rcAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=ZXZOOBpR163PwHWJ4xx1lMFloAS284lwzSXutDSwEP4=;
        b=VeNd3PK/QqGNgYvlr6JjkV31hcRrXizbSvcaVnzedIG57ncODMcyk0GxM8m793tXOb
         M2gx74JPA8pZVKCbFnYmD0/M/w5ZuKYRq1wPnS29Nj0YMgeTgPYKqYGCbJkPNXntyOtt
         0O4HnHmSBo+pjzh46eXn0tAIYDiwHa3Bc3vlfwEXGdenFr2kqrlMCzCtnNG8F592sytl
         zTb1SHOqgtnD/G5LiBiQpxoPrR7i5dXhlHPZow/3XG1srvZQ14DRPFM4WM+Qm+sheFKh
         0HPlScGhNPYdz82kbiWIxjobT0d2A6BUC0ageDEU3aAlPOe/QoXY5qK3wO0s+WMuajKm
         iWyA==
X-Gm-Message-State: AOAM5322KWUwLO3bVolz2N0k3XzDylJ6pbAjhSQs9ijIFJP70Ek5OwIm
        JZOWDLNbq5NxEjr1wVB3wpK5G7ZeAh+fNLI43znoOwZ8neI=
X-Google-Smtp-Source: ABdhPJw0KDs3zm2t6BZYD3N+0VXCaLUIVauUDtZZCVA3nwSLfO5F38VkxjTwxnpJ2hR17amQn1tQJvEsgDJSZ4+4AXs=
X-Received: by 2002:a17:902:9343:b0:148:a2e8:2c49 with SMTP id
 g3-20020a170902934300b00148a2e82c49mr13099198plp.152.1639934238280; Sun, 19
 Dec 2021 09:17:18 -0800 (PST)
MIME-Version: 1.0
From:   "David F." <df7729@gmail.com>
Date:   Sun, 19 Dec 2021 09:17:07 -0800
Message-ID: <CAGRSmLugFZo95qAOrGoKcfWN2wxe_h3Nyw8EVa+8sRVvPyu3_g@mail.gmail.com>
Subject: Latest HP ProLiant DL380 G10 RAID1 support?
To:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello,

Is there an update to mdadm to support the latest HP ProLiant DL380 G10 ?

Customer with the system can only see physical drives, the RAID 1
configured logical volumes don't show up.  "Software based raid
controller"

Dec 17 22:58:05 (none) user.info kernel: DMI: HPE ProLiant DL380
Gen10/ProLiant DL380 Gen10, BIOS U30 01/23/2021


Contents of /proc/partitions:
major minor  #blocks  name

   8       16  937692504 sdb
   8       32  937692504 sdc
   8       33     512000 sdc1
   8       34     102400 sdc2
   8       35      16384 sdc3
   8       36  937027911 sdc4
   8        0  937692504 sda
   8       64  937692504 sde
   8       48  937692504 sdd
   8       49     512000 sdd1
   8       50     102400 sdd2
   8       51      16384 sdd3
   8       52  937027911 sdd4
   8       80   31391744 sdf
   8       81   31387648 sdf1
  11        0      96258 sr0

utput of 'fdisk -l' (using fdisk v2.25.2 from util-linux for GPT support)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Partition 2 does not start on physical sector boundary.

GPT PMBR size mismatch (1875319471 != 1875385007) will be corrected by w(rite).
Partition 2 does not start on physical sector boundary.

GPT PMBR size mismatch (1875319471 != 1875385007) will be corrected by w(rite).

Disk /dev/sdb: 894.3 GiB, 960197124096 bytes, 1875385008 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: dos
Disk identifier: 0x00000000

Device     Boot Start        End    Sectors Size Id Type
/dev/sdb1           1 4294967295 4294967295   2T ee GPT


Disk /dev/sdc: 894.3 GiB, 960197124096 bytes, 1875385008 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: gpt
Disk identifier: E23C50B9-758C-45A5-B38E-40732A7C8F5D

Device       Start        End    Sectors   Size Type
/dev/sdc1     2048    1026047    1024000   500M Windows recovery environment
/dev/sdc2  1026048    1230847     204800   100M EFI System
/dev/sdc3  1230848    1263615      32768    16M Microsoft reserved
/dev/sdc4  1263616 1875319438 1874055823 893.6G Microsoft basic data

Disk /dev/sda: 894.3 GiB, 960197124096 bytes, 1875385008 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk /dev/sde: 894.3 GiB, 960197124096 bytes, 1875385008 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: dos
Disk identifier: 0x00000000

Device     Boot Start        End    Sectors Size Id Type
/dev/sde1           1 4294967295 4294967295   2T ee GPT


Disk /dev/sdd: 894.3 GiB, 960197124096 bytes, 1875385008 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: gpt
Disk identifier: E23C50B9-758C-45A5-B38E-40732A7C8F5D

Device       Start        End    Sectors   Size Type
/dev/sdd1     2048    1026047    1024000   500M Windows recovery environment
/dev/sdd2  1026048    1230847     204800   100M EFI System
/dev/sdd3  1230848    1263615      32768    16M Microsoft reserved
/dev/sdd4  1263616 1875319438 1874055823 893.6G Microsoft basic data

Disk /dev/sdf: 30 GiB, 32145145856 bytes, 62783488 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x00000000

Device     Boot Start      End  Sectors Size Id Type
/dev/sdf1        8192 62783487 62775296  30G  c W95 FAT32 (LBA)

Contents of /proc/mdstat (Linux software RAID status):
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]
[raid4] [multipath]
unused devices: &lt;none&gt;

Contents of /run/mdadm/map (Linux software RAID arrays):
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Contents of /etc/mdadm/mdadm.conf (Linux software RAID config file):
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# mdadm.conf
#
# Please refer to mdadm.conf(5) for information about this file.
#

# by default (built-in), scan all partitions (/proc/partitions) and all
# containers for MD superblocks. alternatively, specify devices to scan, using
# wildcards if desired.
DEVICE partitions containers

# automatically tag new arrays as belonging to the local system
HOMEHOST &lt;system&gt;


Optical drives (srx):
  sr0: iLO      Virtual DVD-ROM  (fw rev =     )
Removable drives (sdx, mmcblkx, nvmex):
  sdf: 30656 MiB Generic- SD/MMC CRW
Fixed hard drives (sdx, mmcblkx, nvmex):
  sda: 894 GiB ATA      VK000960GWSRT
  sdb: 894 GiB ATA      VK000960GWSRT
  sdc: 894 GiB ATA      VK000960GWSRT
  sdd: 894 GiB ATA      INTEL SSDSC2KB96
  sde: 894 GiB ATA      VK000960GWSRT


mdadm - v4.1 - 2018-10-01
Output of 'mdadm --examine --scan'
Output of 'mdadm --assemble --scan --no-degraded -v'
mdadm: looking for devices for further assembly
mdadm: Cannot assemble mbr metadata on /dev/sdf1
mdadm: Cannot assemble mbr metadata on /dev/sdf
mdadm: Cannot assemble mbr metadata on /dev/sdd4
mdadm: Cannot assemble mbr metadata on /dev/sdd3
mdadm: Cannot assemble mbr metadata on /dev/sdd2
mdadm: Cannot assemble mbr metadata on /dev/sdd1
mdadm: Cannot assemble mbr metadata on /dev/sdd
mdadm: Cannot assemble mbr metadata on /dev/sde
mdadm: no recogniseable superblock on /dev/sda
mdadm: Cannot assemble mbr metadata on /dev/sdc4
mdadm: Cannot assemble mbr metadata on /dev/sdc3
mdadm: Cannot assemble mbr metadata on /dev/sdc2
mdadm: Cannot assemble mbr metadata on /dev/sdc1
mdadm: Cannot assemble mbr metadata on /dev/sdc
mdadm: Cannot assemble mbr metadata on /dev/sdb
mdadm: No arrays found in config file or automatically
Output of 'dmesg | grep md:'


Output of 'mdadm --examine /dev/sda'
mdadm: No md superblock detected on /dev/sda.


Output of 'mdadm --examine /dev/sdb'
/dev/sdb:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)


Output of 'mdadm --examine /dev/sdc'
/dev/sdc:
   MBR Magic : aa55
Partition[0] :   1875319471 sectors at            1 (type ee)


Output of 'mdadm --examine /dev/sdd'
/dev/sdd:
   MBR Magic : aa55
Partition[0] :   1875319471 sectors at            1 (type ee)


Output of 'mdadm --examine /dev/sde'
/dev/sde:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)


Output of 'mdadm --examine /dev/sdf'
/dev/sdf:
   MBR Magic : aa55
Partition[0] :     62775296 sectors at         8192 (type 0c)


Output of 'mdadm --detail /dev/md*', if any:
mdadm: cannot open /dev/md*: No such file or directory

Output of dmraid --raid_devices command:
no raid disks

Output of dmraid -s -s command:
no raid disks

Output of blkid command:
/dev/sdc1: UUID="B6C669F7C669B7EF" TYPE="ntfs" PARTLABEL="'Recovery'"
PARTUUID="8713d776-d472-46ef-8023-cb599f2017bf"
/dev/sdc2: UUID="006A-0698" TYPE="vfat" PARTLABEL="'EFI system
partition'" PARTUUID="661cc486-d53a-412c-882e-140aeb126baf"
/dev/sdc3: UUID="4EBEAEE02F3D5ED1" TYPE="ntfs" PARTLABEL="'Microsoft
reserved partition'" PARTUUID="5ef03407-ebcd-4a72-86d1-fd1f5a047b8e"
/dev/sdc4: UUID="3D629FBB15FAC28A" TYPE="ntfs" PARTLABEL="'Basic data
partition'" PARTUUID="e5ef9438-fad4-4ee8-b7c0-c225ecba2173"
/dev/sdd1: UUID="B6C669F7C669B7EF" TYPE="ntfs" PARTLABEL="'Recovery'"
PARTUUID="8713d776-d472-46ef-8023-cb599f2017bf"
/dev/sdd2: UUID="006A-0698" TYPE="vfat" PARTLABEL="'EFI system
partition'" PARTUUID="661cc486-d53a-412c-882e-140aeb126baf"
/dev/sdd3: UUID="4EBEAEE02F3D5ED1" TYPE="ntfs" PARTLABEL="'Microsoft
reserved partition'" PARTUUID="5ef03407-ebcd-4a72-86d1-fd1f5a047b8e"
/dev/sdd4: UUID="3D629FBB15FAC28A" TYPE="ntfs" PARTLABEL="'Basic data
partition'" PARTUUID="e5ef9438-fad4-4ee8-b7c0-c225ecba2173"
/dev/sdf1: UUID="714C-EFFD" TYPE="vfat"
/dev/sdb: PTTYPE="PMBR"
/dev/sde: PTTYPE="PMBR"


Output of lsmod command (loaded modules):

Module                  Size  Used by
sr_mod                 24576  0
cdrom                  28672  1 sr_mod
usb_storage            57344  0
hid_generic            16384  0
usbhid                 28672  0
hid                   102400  2 usbhid,hid_generic
pcspkr                 16384  0
i40e                  290816  0
evdev                  20480  2
hpsa                   77824  0
ehci_pci               16384  0
ehci_hcd               49152  1 ehci_pci
sg                     28672  0
scsi_transport_sas     32768  1 hpsa
xhci_pci               16384  0
xhci_hcd              118784  1 xhci_pci
sd_mod                 32768  0
button                 16384  0
loop                   24576  0
ahci                   40960  0
libahci                24576  1 ahci
dm_mod                 94208  0
dax                    28672  1 dm_mod

Contents of /sys/module:
8250                     keyboard                 scsi_transport_fc
acpi                     libahci                  scsi_transport_sas
acpiphp                  libata                   sd_mod
ahci                     lockd                    sg
auth_rpcgss              loop                     speakup
block                    md_mod                   speakup_acntsa
button                   module                   speakup_apollo
cdrom                    mousedev                 speakup_audptr
cifs                     nfs                      speakup_bns
cpufreq                  nfs_layout_flexfiles     speakup_decext
cpuidle                  nfs_layout_nfsv41_files  speakup_dectlk
cpuidle_haltpoll         nfsv4                    speakup_dummy
crc_t10dif               nmi_backtrace            speakup_ltlk
cryptomgr                nvme                     speakup_soft
dax                      nvme_core                speakup_spkout
dm_mod                   pci_hotplug              speakup_txprt
dns_resolver             pcie_aspm                spurious
ehci_hcd                 pciehp                   sr_mod
ehci_pci                 pcspkr                   srcutree
evdev                    printk                   sunrpc
fb                       processor                tcp_cubic
firmware_class           raid0                    usb_storage
fscache                  raid1                    usbcore
fuse                     raid10                   usbhid
gpiolib_acpi             raid456                  vt
hid                      random                   workqueue
hid_generic              rcupdate                 xhci_hcd
hpsa                     rcutree                  xhci_pci
i40e                     rfkill                   xz_dec
i8042                    rtc_cmos
kernel                   scsi_mod

Output of lspci -knn command:

00:00.0 Host bridge [0600]: Intel Corporation Sky Lake-E DMI3
Registers [8086:2020] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
00:04.0 System peripheral [0880]: Intel Corporation Sky Lake-E CBDMA
Registers [8086:2021] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
00:04.1 System peripheral [0880]: Intel Corporation Sky Lake-E CBDMA
Registers [8086:2021] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
00:04.2 System peripheral [0880]: Intel Corporation Sky Lake-E CBDMA
Registers [8086:2021] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
00:04.3 System peripheral [0880]: Intel Corporation Sky Lake-E CBDMA
Registers [8086:2021] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
00:04.4 System peripheral [0880]: Intel Corporation Sky Lake-E CBDMA
Registers [8086:2021] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
00:04.5 System peripheral [0880]: Intel Corporation Sky Lake-E CBDMA
Registers [8086:2021] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
00:04.6 System peripheral [0880]: Intel Corporation Sky Lake-E CBDMA
Registers [8086:2021] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
00:04.7 System peripheral [0880]: Intel Corporation Sky Lake-E CBDMA
Registers [8086:2021] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
00:05.0 System peripheral [0880]: Intel Corporation Sky Lake-E MM/Vt-d
Configuration Registers [8086:2024] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
00:05.2 System peripheral [0880]: Intel Corporation Sky Lake-E RAS
[8086:2025] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
00:05.4 PIC [0800]: Intel Corporation Sky Lake-E IOAPIC [8086:2026] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:18a9]
00:08.0 System peripheral [0880]: Intel Corporation Sky Lake-E Ubox
Registers [8086:2014] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
00:08.1 Performance counters [1101]: Intel Corporation Sky Lake-E Ubox
Registers [8086:2015] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
00:08.2 System peripheral [0880]: Intel Corporation Sky Lake-E Ubox
Registers [8086:2016] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
00:11.0 Unassigned class [ff00]: Intel Corporation C620 Series Chipset
Family MROM 0 [8086:a1ec] (rev 09)
    Subsystem: Hewlett Packard Enterprise Device [1590:00eb]
00:11.1 Unassigned class [ff00]: Intel Corporation C620 Series Chipset
Family MROM 1 [8086:a1ed] (rev 09)
    Subsystem: Hewlett Packard Enterprise Device [1590:00eb]
00:11.5 RAID bus controller [0104]: Intel Corporation C620 Series
Chipset Family SSATA Controller [RAID mode] [8086:a1d6] (rev 09)
    Subsystem: Hewlett Packard Enterprise Device [1590:00e6]
    Kernel driver in use: ahci
00:14.0 USB controller [0c03]: Intel Corporation C620 Series Chipset
Family USB 3.0 xHCI Controller [8086:a1af] (rev 09)
    Subsystem: Hewlett Packard Enterprise Device [1590:00eb]
    Kernel driver in use: xhci_hcd
00:14.2 Signal processing controller [1180]: Intel Corporation C620
Series Chipset Family Thermal Subsystem [8086:a1b1] (rev 09)
    Subsystem: Hewlett Packard Enterprise Device [1590:00eb]
00:16.0 Communication controller [0780]: Intel Corporation C620 Series
Chipset Family MEI Controller #1 [8086:a1ba] (rev 09)
    Subsystem: Hewlett Packard Enterprise Device [1590:00eb]
00:16.4 Communication controller [0780]: Intel Corporation C620 Series
Chipset Family MEI Controller #3 [8086:a1be] (rev 09)
    Subsystem: Hewlett Packard Enterprise Device [1590:00eb]
00:17.0 RAID bus controller [0104]: Intel Corporation C620 Series
Chipset Family SATA Controller [RAID mode] [8086:a186] (rev 09)
    Subsystem: Hewlett Packard Enterprise Device [1590:00e5]
    Kernel driver in use: ahci
00:1c.0 PCI bridge [0604]: Intel Corporation C620 Series Chipset
Family PCI Express Root Port #1 [8086:a190] (rev f9)
    Kernel driver in use: pcieport
00:1c.4 PCI bridge [0604]: Intel Corporation C620 Series Chipset
Family PCI Express Root Port #5 [8086:a194] (rev f9)
    Kernel driver in use: pcieport
00:1f.0 ISA bridge [0601]: Intel Corporation C621 Series Chipset
LPC/eSPI Controller [8086:a1c1] (rev 09)
    Subsystem: Hewlett Packard Enterprise Device [1590:00eb]
00:1f.2 Memory controller [0580]: Intel Corporation C620 Series
Chipset Family Power Management Controller [8086:a1a1] (rev 09)
    Subsystem: Hewlett Packard Enterprise Device [1590:00eb]
01:00.0 System peripheral [0880]: Hewlett-Packard Company Integrated
Lights-Out Standard Slave Instrumentation &amp; System Support
[103c:3306] (rev 07)
    Subsystem: Hewlett Packard Enterprise iLO5 [1590:00e4]
01:00.1 VGA compatible controller [0300]: Matrox Electronics Systems
Ltd. MGA G200eH3 [102b:0538] (rev 02)
    Subsystem: Hewlett Packard Enterprise iLO5 VGA [1590:00e4]
01:00.2 System peripheral [0880]: Hewlett-Packard Company Integrated
Lights-Out Standard Management Processor Support and Messaging
[103c:3307] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00e4]
01:00.4 USB controller [0c03]: Hewlett-Packard Company iLO5 Virtual
USB Controller [103c:22f6]
    Subsystem: Hewlett Packard Enterprise iLO5 Standard Virtual USB
Controller [1590:00e4]
    Kernel driver in use: ehci-pci
01:00.7 RAID bus controller [0104]: Hewlett-Packard Company Device
[103c:193f] (rev 01)
    Subsystem: Hewlett Packard Enterprise Device [1590:00e4]
11:00.0 PCI bridge [0604]: Intel Corporation Sky Lake-E PCI Express
Root Port A [8086:2030] (rev 07)
    Kernel driver in use: pcieport
11:02.0 PCI bridge [0604]: Intel Corporation Sky Lake-E PCI Express
Root Port C [8086:2032] (rev 07)
    Kernel driver in use: pcieport
11:05.0 System peripheral [0880]: Intel Corporation Sky Lake-E VT-d
[8086:2034] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:05.2 System peripheral [0880]: Intel Corporation Sky Lake-E RAS
Configuration Registers [8086:2035] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:05.4 PIC [0800]: Intel Corporation Sky Lake-E IOxAPIC Configuration
Registers [8086:2036] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:18a9]
11:08.0 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:08.1 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:08.2 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:08.3 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:08.4 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:08.5 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:08.6 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:08.7 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:09.0 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:09.1 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:09.2 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:09.3 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:09.4 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:09.5 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:09.6 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:09.7 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:0a.0 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:0a.1 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:0a.2 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:0a.3 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:0a.4 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:0a.5 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:0a.6 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:0a.7 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:0b.0 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:0b.1 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:0b.2 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:0b.3 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:0e.0 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:0e.1 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:0e.2 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:0e.3 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:0e.4 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:0e.5 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:0e.6 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:0e.7 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:0f.0 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:0f.1 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:0f.2 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:0f.3 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:0f.4 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:0f.5 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:0f.6 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:0f.7 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:10.0 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:10.1 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:10.2 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:10.3 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:10.4 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:10.5 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:10.6 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:10.7 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:11.0 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:11.1 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:11.2 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:11.3 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:1d.0 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:2054] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:1d.1 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:2055] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:1d.2 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:2056] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:1d.3 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:2057] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:1e.0 System peripheral [0880]: Intel Corporation Sky Lake-E PCU
Registers [8086:2080] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:1e.1 System peripheral [0880]: Intel Corporation Sky Lake-E PCU
Registers [8086:2081] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:1e.2 System peripheral [0880]: Intel Corporation Sky Lake-E PCU
Registers [8086:2082] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:1e.3 System peripheral [0880]: Intel Corporation Sky Lake-E PCU
Registers [8086:2083] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:1e.4 System peripheral [0880]: Intel Corporation Sky Lake-E PCU
Registers [8086:2084] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:1e.5 System peripheral [0880]: Intel Corporation Sky Lake-E PCU
Registers [8086:2085] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
11:1e.6 System peripheral [0880]: Intel Corporation Sky Lake-E PCU
Registers [8086:2086] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
36:00.0 PCI bridge [0604]: Intel Corporation Sky Lake-E PCI Express
Root Port A [8086:2030] (rev 07)
    Kernel driver in use: pcieport
36:05.0 System peripheral [0880]: Intel Corporation Sky Lake-E VT-d
[8086:2034] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
36:05.2 System peripheral [0880]: Intel Corporation Sky Lake-E RAS
Configuration Registers [8086:2035] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
36:05.4 PIC [0800]: Intel Corporation Sky Lake-E IOxAPIC Configuration
Registers [8086:2036] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:18a9]
36:08.0 System peripheral [0880]: Intel Corporation Sky Lake-E
Integrated Memory Controller [8086:2066] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
    Kernel driver in use: skx_uncore
36:09.0 System peripheral [0880]: Intel Corporation Sky Lake-E
Integrated Memory Controller [8086:2066] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
    Kernel driver in use: skx_uncore
36:0a.0 System peripheral [0880]: Intel Corporation Sky Lake-E
Integrated Memory Controller [8086:2040] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
36:0a.1 System peripheral [0880]: Intel Corporation Sky Lake-E
Integrated Memory Controller [8086:2041] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
36:0a.2 System peripheral [0880]: Intel Corporation Sky Lake-E
Integrated Memory Controller [8086:2042] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
    Kernel driver in use: skx_uncore
36:0a.3 System peripheral [0880]: Intel Corporation Sky Lake-E
Integrated Memory Controller [8086:2043] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
36:0a.4 System peripheral [0880]: Intel Corporation Sky Lake-E
Integrated Memory Controller [8086:2044] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
36:0a.5 System peripheral [0880]: Intel Corporation Sky Lake-E LM
Channel 1 [8086:2045] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
36:0a.6 System peripheral [0880]: Intel Corporation Sky Lake-E LMS
Channel 1 [8086:2046] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
    Kernel driver in use: skx_uncore
36:0a.7 System peripheral [0880]: Intel Corporation Sky Lake-E LMDP
Channel 1 [8086:2047] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
36:0b.0 System peripheral [0880]: Intel Corporation Sky Lake-E DECS
Channel 2 [8086:2048] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
36:0b.1 System peripheral [0880]: Intel Corporation Sky Lake-E LM
Channel 2 [8086:2049] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
36:0b.2 System peripheral [0880]: Intel Corporation Sky Lake-E LMS
Channel 2 [8086:204a] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
    Kernel driver in use: skx_uncore
36:0b.3 System peripheral [0880]: Intel Corporation Sky Lake-E LMDP
Channel 2 [8086:204b] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
36:0c.0 System peripheral [0880]: Intel Corporation Sky Lake-E
Integrated Memory Controller [8086:2040] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
36:0c.1 System peripheral [0880]: Intel Corporation Sky Lake-E
Integrated Memory Controller [8086:2041] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
36:0c.2 System peripheral [0880]: Intel Corporation Sky Lake-E
Integrated Memory Controller [8086:2042] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
    Kernel driver in use: skx_uncore
36:0c.3 System peripheral [0880]: Intel Corporation Sky Lake-E
Integrated Memory Controller [8086:2043] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
36:0c.4 System peripheral [0880]: Intel Corporation Sky Lake-E
Integrated Memory Controller [8086:2044] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
36:0c.5 System peripheral [0880]: Intel Corporation Sky Lake-E LM
Channel 1 [8086:2045] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
36:0c.6 System peripheral [0880]: Intel Corporation Sky Lake-E LMS
Channel 1 [8086:2046] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
    Kernel driver in use: skx_uncore
36:0c.7 System peripheral [0880]: Intel Corporation Sky Lake-E LMDP
Channel 1 [8086:2047] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
36:0d.0 System peripheral [0880]: Intel Corporation Sky Lake-E DECS
Channel 2 [8086:2048] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
36:0d.1 System peripheral [0880]: Intel Corporation Sky Lake-E LM
Channel 2 [8086:2049] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
36:0d.2 System peripheral [0880]: Intel Corporation Sky Lake-E LMS
Channel 2 [8086:204a] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
    Kernel driver in use: skx_uncore
36:0d.3 System peripheral [0880]: Intel Corporation Sky Lake-E LMDP
Channel 2 [8086:204b] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
5b:00.0 PCI bridge [0604]: Intel Corporation Sky Lake-E PCI Express
Root Port A [8086:2030] (rev 07)
    Kernel driver in use: pcieport
5b:02.0 PCI bridge [0604]: Intel Corporation Sky Lake-E PCI Express
Root Port C [8086:2032] (rev 07)
    Kernel driver in use: pcieport
5b:05.0 System peripheral [0880]: Intel Corporation Sky Lake-E VT-d
[8086:2034] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
5b:05.2 System peripheral [0880]: Intel Corporation Sky Lake-E RAS
Configuration Registers [8086:2035] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
5b:05.4 PIC [0800]: Intel Corporation Sky Lake-E IOxAPIC Configuration
Registers [8086:2036] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:18a9]
5b:0e.0 Performance counters [1101]: Intel Corporation Sky Lake-E KTI
0 [8086:2058] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
    Kernel driver in use: skx_uncore
5b:0e.1 System peripheral [0880]: Intel Corporation Sky Lake-E UPI
Registers [8086:2059] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
5b:0f.0 Performance counters [1101]: Intel Corporation Sky Lake-E KTI
0 [8086:2058] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
    Kernel driver in use: skx_uncore
5b:0f.1 System peripheral [0880]: Intel Corporation Sky Lake-E UPI
Registers [8086:2059] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
5b:10.0 Performance counters [1101]: Intel Corporation Sky Lake-E KTI
0 [8086:2058] (rev 07)
    Kernel driver in use: skx_uncore
5b:10.1 System peripheral [0880]: Intel Corporation Sky Lake-E UPI
Registers [8086:2059] (rev 07)
5b:12.0 Performance counters [1101]: Intel Corporation Sky Lake-E
M3KTI Registers [8086:204c] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
5b:12.1 Performance counters [1101]: Intel Corporation Sky Lake-E
M3KTI Registers [8086:204d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
    Kernel driver in use: skx_uncore
5b:12.2 System peripheral [0880]: Intel Corporation Sky Lake-E M3KTI
Registers [8086:204e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
    Kernel driver in use: skx_uncore
5b:12.4 Performance counters [1101]: Intel Corporation Sky Lake-E
M3KTI Registers [8086:204c] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
5b:12.5 Performance counters [1101]: Intel Corporation Sky Lake-E
M3KTI Registers [8086:204d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
    Kernel driver in use: skx_uncore
5b:15.0 System peripheral [0880]: Intel Corporation Sky Lake-E M2PCI
Registers [8086:2018] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
5b:15.1 Performance counters [1101]: Intel Corporation Sky Lake-E
DDRIO Registers [8086:2088] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
    Kernel driver in use: skx_uncore
5b:16.0 System peripheral [0880]: Intel Corporation Sky Lake-E M2PCI
Registers [8086:2018] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
5b:16.1 Performance counters [1101]: Intel Corporation Sky Lake-E
DDRIO Registers [8086:2088] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
    Kernel driver in use: skx_uncore
5b:16.4 System peripheral [0880]: Intel Corporation Sky Lake-E M2PCI
Registers [8086:2018] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
5b:16.5 Performance counters [1101]: Intel Corporation Sky Lake-E
DDRIO Registers [8086:2088] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
5b:17.0 System peripheral [0880]: Intel Corporation Sky Lake-E M2PCI
Registers [8086:2018] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
5b:17.1 Performance counters [1101]: Intel Corporation Sky Lake-E
DDRIO Registers [8086:2088] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
    Kernel driver in use: skx_uncore
5d:00.0 Ethernet controller [0200]: Intel Corporation Ethernet
Controller X710 for 10GbE SFP+ [8086:1572] (rev 02)
    Subsystem: Hewlett-Packard Company Ethernet 10Gb 2-port
562FLR-SFP+ Adapter [103c:22fc]
    Kernel driver in use: i40e
5d:00.1 Ethernet controller [0200]: Intel Corporation Ethernet
Controller X710 for 10GbE SFP+ [8086:1572] (rev 02)
    Subsystem: Hewlett-Packard Company Ethernet 10Gb 562SFP+ Adapter [103c:0000]
    Kernel driver in use: i40e
80:04.0 System peripheral [0880]: Intel Corporation Sky Lake-E CBDMA
Registers [8086:2021] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
80:04.1 System peripheral [0880]: Intel Corporation Sky Lake-E CBDMA
Registers [8086:2021] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
80:04.2 System peripheral [0880]: Intel Corporation Sky Lake-E CBDMA
Registers [8086:2021] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
80:04.3 System peripheral [0880]: Intel Corporation Sky Lake-E CBDMA
Registers [8086:2021] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
80:04.4 System peripheral [0880]: Intel Corporation Sky Lake-E CBDMA
Registers [8086:2021] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
80:04.5 System peripheral [0880]: Intel Corporation Sky Lake-E CBDMA
Registers [8086:2021] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
80:04.6 System peripheral [0880]: Intel Corporation Sky Lake-E CBDMA
Registers [8086:2021] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
80:04.7 System peripheral [0880]: Intel Corporation Sky Lake-E CBDMA
Registers [8086:2021] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
80:05.0 System peripheral [0880]: Intel Corporation Sky Lake-E MM/Vt-d
Configuration Registers [8086:2024] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
80:05.2 System peripheral [0880]: Intel Corporation Sky Lake-E RAS
[8086:2025] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
80:05.4 PIC [0800]: Intel Corporation Sky Lake-E IOAPIC [8086:2026] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:18a9]
80:08.0 System peripheral [0880]: Intel Corporation Sky Lake-E Ubox
Registers [8086:2014] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
80:08.1 Performance counters [1101]: Intel Corporation Sky Lake-E Ubox
Registers [8086:2015] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
80:08.2 System peripheral [0880]: Intel Corporation Sky Lake-E Ubox
Registers [8086:2016] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:00.0 PCI bridge [0604]: Intel Corporation Sky Lake-E PCI Express
Root Port A [8086:2030] (rev 07)
    Kernel driver in use: pcieport
85:05.0 System peripheral [0880]: Intel Corporation Sky Lake-E VT-d
[8086:2034] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:05.2 System peripheral [0880]: Intel Corporation Sky Lake-E RAS
Configuration Registers [8086:2035] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:05.4 PIC [0800]: Intel Corporation Sky Lake-E IOxAPIC Configuration
Registers [8086:2036] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:18a9]
85:08.0 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:08.1 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:08.2 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:08.3 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:08.4 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:08.5 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:08.6 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:08.7 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:09.0 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:09.1 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:09.2 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:09.3 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:09.4 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:09.5 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:09.6 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:09.7 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:0a.0 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:0a.1 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:0a.2 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:0a.3 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:0a.4 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:0a.5 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:0a.6 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:0a.7 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:0b.0 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:0b.1 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:0b.2 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:0b.3 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:0e.0 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:0e.1 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:0e.2 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:0e.3 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:0e.4 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:0e.5 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:0e.6 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:0e.7 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:0f.0 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:0f.1 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:0f.2 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:0f.3 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:0f.4 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:0f.5 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:0f.6 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:0f.7 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:10.0 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:10.1 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:10.2 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:10.3 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:10.4 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:10.5 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:10.6 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:10.7 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:11.0 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:11.1 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:11.2 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:11.3 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:208e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:1d.0 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:2054] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:1d.1 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:2055] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:1d.2 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:2056] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:1d.3 System peripheral [0880]: Intel Corporation Sky Lake-E CHA
Registers [8086:2057] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:1e.0 System peripheral [0880]: Intel Corporation Sky Lake-E PCU
Registers [8086:2080] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:1e.1 System peripheral [0880]: Intel Corporation Sky Lake-E PCU
Registers [8086:2081] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:1e.2 System peripheral [0880]: Intel Corporation Sky Lake-E PCU
Registers [8086:2082] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:1e.3 System peripheral [0880]: Intel Corporation Sky Lake-E PCU
Registers [8086:2083] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:1e.4 System peripheral [0880]: Intel Corporation Sky Lake-E PCU
Registers [8086:2084] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:1e.5 System peripheral [0880]: Intel Corporation Sky Lake-E PCU
Registers [8086:2085] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
85:1e.6 System peripheral [0880]: Intel Corporation Sky Lake-E PCU
Registers [8086:2086] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
ae:00.0 PCI bridge [0604]: Intel Corporation Sky Lake-E PCI Express
Root Port A [8086:2030] (rev 07)
    Kernel driver in use: pcieport
ae:05.0 System peripheral [0880]: Intel Corporation Sky Lake-E VT-d
[8086:2034] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
ae:05.2 System peripheral [0880]: Intel Corporation Sky Lake-E RAS
Configuration Registers [8086:2035] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
ae:05.4 PIC [0800]: Intel Corporation Sky Lake-E IOxAPIC Configuration
Registers [8086:2036] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:18a9]
ae:08.0 System peripheral [0880]: Intel Corporation Sky Lake-E
Integrated Memory Controller [8086:2066] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
    Kernel driver in use: skx_uncore
ae:09.0 System peripheral [0880]: Intel Corporation Sky Lake-E
Integrated Memory Controller [8086:2066] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
    Kernel driver in use: skx_uncore
ae:0a.0 System peripheral [0880]: Intel Corporation Sky Lake-E
Integrated Memory Controller [8086:2040] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
ae:0a.1 System peripheral [0880]: Intel Corporation Sky Lake-E
Integrated Memory Controller [8086:2041] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
ae:0a.2 System peripheral [0880]: Intel Corporation Sky Lake-E
Integrated Memory Controller [8086:2042] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
    Kernel driver in use: skx_uncore
ae:0a.3 System peripheral [0880]: Intel Corporation Sky Lake-E
Integrated Memory Controller [8086:2043] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
ae:0a.4 System peripheral [0880]: Intel Corporation Sky Lake-E
Integrated Memory Controller [8086:2044] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
ae:0a.5 System peripheral [0880]: Intel Corporation Sky Lake-E LM
Channel 1 [8086:2045] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
ae:0a.6 System peripheral [0880]: Intel Corporation Sky Lake-E LMS
Channel 1 [8086:2046] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
    Kernel driver in use: skx_uncore
ae:0a.7 System peripheral [0880]: Intel Corporation Sky Lake-E LMDP
Channel 1 [8086:2047] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
ae:0b.0 System peripheral [0880]: Intel Corporation Sky Lake-E DECS
Channel 2 [8086:2048] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
ae:0b.1 System peripheral [0880]: Intel Corporation Sky Lake-E LM
Channel 2 [8086:2049] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
ae:0b.2 System peripheral [0880]: Intel Corporation Sky Lake-E LMS
Channel 2 [8086:204a] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
    Kernel driver in use: skx_uncore
ae:0b.3 System peripheral [0880]: Intel Corporation Sky Lake-E LMDP
Channel 2 [8086:204b] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
ae:0c.0 System peripheral [0880]: Intel Corporation Sky Lake-E
Integrated Memory Controller [8086:2040] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
ae:0c.1 System peripheral [0880]: Intel Corporation Sky Lake-E
Integrated Memory Controller [8086:2041] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
ae:0c.2 System peripheral [0880]: Intel Corporation Sky Lake-E
Integrated Memory Controller [8086:2042] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
    Kernel driver in use: skx_uncore
ae:0c.3 System peripheral [0880]: Intel Corporation Sky Lake-E
Integrated Memory Controller [8086:2043] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
ae:0c.4 System peripheral [0880]: Intel Corporation Sky Lake-E
Integrated Memory Controller [8086:2044] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
ae:0c.5 System peripheral [0880]: Intel Corporation Sky Lake-E LM
Channel 1 [8086:2045] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
ae:0c.6 System peripheral [0880]: Intel Corporation Sky Lake-E LMS
Channel 1 [8086:2046] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
    Kernel driver in use: skx_uncore
ae:0c.7 System peripheral [0880]: Intel Corporation Sky Lake-E LMDP
Channel 1 [8086:2047] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
ae:0d.0 System peripheral [0880]: Intel Corporation Sky Lake-E DECS
Channel 2 [8086:2048] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
ae:0d.1 System peripheral [0880]: Intel Corporation Sky Lake-E LM
Channel 2 [8086:2049] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
ae:0d.2 System peripheral [0880]: Intel Corporation Sky Lake-E LMS
Channel 2 [8086:204a] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
    Kernel driver in use: skx_uncore
ae:0d.3 System peripheral [0880]: Intel Corporation Sky Lake-E LMDP
Channel 2 [8086:204b] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
d7:00.0 PCI bridge [0604]: Intel Corporation Sky Lake-E PCI Express
Root Port A [8086:2030] (rev 07)
    Kernel driver in use: pcieport
d7:05.0 System peripheral [0880]: Intel Corporation Sky Lake-E VT-d
[8086:2034] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
d7:05.2 System peripheral [0880]: Intel Corporation Sky Lake-E RAS
Configuration Registers [8086:2035] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
d7:05.4 PIC [0800]: Intel Corporation Sky Lake-E IOxAPIC Configuration
Registers [8086:2036] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:18a9]
d7:0e.0 Performance counters [1101]: Intel Corporation Sky Lake-E KTI
0 [8086:2058] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
    Kernel driver in use: skx_uncore
d7:0e.1 System peripheral [0880]: Intel Corporation Sky Lake-E UPI
Registers [8086:2059] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
d7:0f.0 Performance counters [1101]: Intel Corporation Sky Lake-E KTI
0 [8086:2058] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
    Kernel driver in use: skx_uncore
d7:0f.1 System peripheral [0880]: Intel Corporation Sky Lake-E UPI
Registers [8086:2059] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
d7:10.0 Performance counters [1101]: Intel Corporation Sky Lake-E KTI
0 [8086:2058] (rev 07)
    Kernel driver in use: skx_uncore
d7:10.1 System peripheral [0880]: Intel Corporation Sky Lake-E UPI
Registers [8086:2059] (rev 07)
d7:12.0 Performance counters [1101]: Intel Corporation Sky Lake-E
M3KTI Registers [8086:204c] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
d7:12.1 Performance counters [1101]: Intel Corporation Sky Lake-E
M3KTI Registers [8086:204d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
    Kernel driver in use: skx_uncore
d7:12.2 System peripheral [0880]: Intel Corporation Sky Lake-E M3KTI
Registers [8086:204e] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
    Kernel driver in use: skx_uncore
d7:12.4 Performance counters [1101]: Intel Corporation Sky Lake-E
M3KTI Registers [8086:204c] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
d7:12.5 Performance counters [1101]: Intel Corporation Sky Lake-E
M3KTI Registers [8086:204d] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
    Kernel driver in use: skx_uncore
d7:15.0 System peripheral [0880]: Intel Corporation Sky Lake-E M2PCI
Registers [8086:2018] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
d7:15.1 Performance counters [1101]: Intel Corporation Sky Lake-E
DDRIO Registers [8086:2088] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
    Kernel driver in use: skx_uncore
d7:16.0 System peripheral [0880]: Intel Corporation Sky Lake-E M2PCI
Registers [8086:2018] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
d7:16.1 Performance counters [1101]: Intel Corporation Sky Lake-E
DDRIO Registers [8086:2088] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
    Kernel driver in use: skx_uncore
d7:16.4 System peripheral [0880]: Intel Corporation Sky Lake-E M2PCI
Registers [8086:2018] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
d7:16.5 Performance counters [1101]: Intel Corporation Sky Lake-E
DDRIO Registers [8086:2088] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
d7:17.0 System peripheral [0880]: Intel Corporation Sky Lake-E M2PCI
Registers [8086:2018] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
d7:17.1 Performance counters [1101]: Intel Corporation Sky Lake-E
DDRIO Registers [8086:2088] (rev 07)
    Subsystem: Hewlett Packard Enterprise Device [1590:00ea]
    Kernel driver in use: skx_uncore

ps search of raid:

  529 root         0 IW&lt;  [raid5wq]


messages with "raid" or "mdadm":

Dec 17 22:58:05 (none) user.info kernel: raid6: avx512x4 gen() 15285 MB/s
Dec 17 22:58:05 (none) user.info kernel: raid6: avx512x4 xor() 11901 MB/s
Dec 17 22:58:05 (none) user.info kernel: raid6: avx512x2 gen() 17465 MB/s
Dec 17 22:58:05 (none) user.info kernel: raid6: avx512x2 xor() 25409 MB/s
Dec 17 22:58:05 (none) user.info kernel: raid6: avx512x1 gen() 17302 MB/s
Dec 17 22:58:05 (none) user.info kernel: raid6: avx512x1 xor() 22598 MB/s
Dec 17 22:58:05 (none) user.info kernel: raid6: avx2x4   gen() 17109 MB/s
Dec 17 22:58:05 (none) user.info kernel: raid6: avx2x4   xor() 11145 MB/s
Dec 17 22:58:05 (none) user.info kernel: raid6: avx2x2   gen() 17103 MB/s
Dec 17 22:58:05 (none) user.info kernel: raid6: avx2x2   xor() 18629 MB/s
Dec 17 22:58:05 (none) user.info kernel: raid6: avx2x1   gen() 12703 MB/s
Dec 17 22:58:05 (none) user.info kernel: raid6: avx2x1   xor() 14857 MB/s
Dec 17 22:58:05 (none) user.info kernel: raid6: sse2x4   gen() 10412 MB/s
Dec 17 22:58:05 (none) user.info kernel: raid6: sse2x4   xor()  6425 MB/s
Dec 17 22:58:05 (none) user.info kernel: raid6: sse2x2   gen() 11107 MB/s
Dec 17 22:58:05 (none) user.info kernel: raid6: sse2x2   xor()  6840 MB/s
Dec 17 22:58:05 (none) user.info kernel: raid6: sse2x1   gen() 10501 MB/s
Dec 17 22:58:05 (none) user.info kernel: raid6: sse2x1   xor()  5755 MB/s
Dec 17 22:58:05 (none) user.info kernel: raid6: using algorithm
avx512x2 gen() 17465 MB/s
Dec 17 22:58:05 (none) user.info kernel: raid6: .... xor() 25409 MB/s,
rmw enabled
Dec 17 22:58:05 (none) user.info kernel: raid6: using avx512x2
recovery algorithm
Dec 17 22:58:08 (none) user.info kernel: ahci 0000:00:11.5: AHCI
0001.0301 32 slots 6 ports 6 Gbps 0x3f impl RAID mode
Dec 17 22:58:08 (none) user.info kernel: ahci 0000:00:17.0: AHCI
0001.0301 32 slots 8 ports 6 Gbps 0xff impl RAID mode
