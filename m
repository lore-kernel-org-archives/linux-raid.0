From: Alexander Belov <alexb@arctel.ru>
Subject: problems with mounting root fs in latest 2.4 kernels
Date: Wed, 18 Jun 2003 18:46:20 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16112.31548.626037.658852@darkside.no.dom>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello!

I have Linux box with Promise FastTrak TX2000 Ultra ATA/133 RAID PCI Card
and RAID1 configured. And I have no problems with booting Linux from
RAID1 array under kernel-2.4.18. My kernel config is:

-------------------- Begin ---------------------
                [*]   Generic PCI IDE chipset support
                [*]     Sharing PCI IDE interrupts support
                [*]     Generic PCI bus-master DMA support
                [*]       Use PCI DMA by default when available
                [*]     Intel PIIXn chipsets support
                [*]       PIIXn Tuning support
                <*> Support for IDE Raid controllers
                <*>    Support Promise software RAID (Fasttrak(tm))
                < >    Highpoint 370 software RAID
-------------------- End ---------------------


And my /etc/lilo.conf:

-------------------- Begin ---------------------
# Start LILO global section
append="ide2=0xdc00,0xd882,10 ide3=0xd800,0xd482,10"
boot=/dev/ataraid/d0
lba32 # Allow booting past 1024th cylinder with a recent BIOS
disk = /dev/ataraid/d0
  bios = 0x80
prompt
timeout = 50
vga = normal

# Linux bootable partition config begins
image = /boot/vmlinuz
root = /dev/ataraid/d0p1
label = linux
read-only # Non-UMSDOS filesystems should be mounted read-only for checking
-------------------- End ---------------------

But when I try to do this config under 2.4.19/20/21 kernel, the boot process
fails with:

Kernel panic: VFS: Unable to mount root fs on 72:01

I tried to enable/disable the kernel options related to Promise
FastTrak, PDC202xx but result was the same: Kernel panic.

Am I misunderstand something?

Thanks for any help.
-- 
Alexander Belov
