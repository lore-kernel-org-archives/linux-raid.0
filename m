Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2930FC433EF
	for <linux-raid@archiver.kernel.org>; Sun, 19 Dec 2021 10:14:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232809AbhLSKOB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 19 Dec 2021 05:14:01 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:56348 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229585AbhLSKOA (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sun, 19 Dec 2021 05:14:00 -0500
Received: from host81-132-12-162.range81-132.btcentralplus.com ([81.132.12.162] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1mytCX-000BIO-5w; Sun, 19 Dec 2021 10:13:58 +0000
Message-ID: <86a0fad4-ac0d-f36f-4d5a-589f2df4fe1b@youngman.org.uk>
Date:   Sun, 19 Dec 2021 10:13:56 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: Need help Recover raid5 array
Content-Language: en-US
To:     Tony Bush <thecompguru@gmail.com>, linux-raid@vger.kernel.org
References: <CAA9kLn1nZZKHLahjkyJzChgTMC2WKEoyJG2PhHzeXbD_qY_-yw@mail.gmail.com>
Cc:     Phil Turmel <philip@turmel.org>, NeilBrown <neilb@suse.com>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <CAA9kLn1nZZKHLahjkyJzChgTMC2WKEoyJG2PhHzeXbD_qY_-yw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Good report, thanks! :-)

Looks promising. I'm not going to advise much here, but I've punted this 
to two people I know will be able to help. Of course, it's Christmas, 
they might not be around for a bit so you may have to wait.

This is a situation we've recovered a fair few raids from. The 
superblock may well still be there, just not accessible because of the 
new gpt/mbr.

First things first. You're talking about getting new drives? Can you get 
THREE? Back up three of your four corrupted drives. That way, you've got 
four corrupted drives you can attempt to recover, and four backups as 
insurance. That'll take a long time, the sooner the better.

Then move all your raid drives safely out the way, build your new 
working system, and play with loopbacks as per the recovery 
instructions. You understand what it's trying to do? Put a read/write 
layer over the underlying read-only disk? Search the list archives for 
people who've done this, it's not difficult although I'm with you on it 
feeling scary and overwhelming - if you're in a "I need this to work" 
situation it's a bit frightening. Once you're happy it's working, you 
can put your four damaged disks back in and recreate the array.

The one bad bit of news is we don't know what the GPT/MBR has stomped 
over. If it's stomped over the working array, then you've probably got 
some data loss - hopefully not much.

(NB don't blame Windows. It may well have been, but the frightening 
thing is it could have been the new mobo! or Ubuntu. Both have been 
implicated in previous incidents.)

I'll bow out now,
Cheers,
Wol

On 19/12/2021 04:31, Tony Bush wrote:
> I have a small ubuntu server that I was upgrading the hardware to and
> in the process lost my raid.  I changed the CPU, MOBO, RAM.  I added a
> new-to-this-system SSD also to replace the current SSD(in a future
> step).  I forgot that this new-to-this-system SSD had Windows 10 OS on
> it and I believe it tried to boot while I was working on hooking up my
> monitor.  So I think that it saw my raid drives and tried to fdisk
> them.  I did mdadm directly to drive and not to a partition(big
> mistake I know now).  So I think the drives were seen as corrupted and
> fdisk corrected the formatting.  I lost my super blocks on 4 of 5
> drives.  These are shucked external 10TB drives and one even shows up
> with 'my drive' partition label and 2 files that came with those
> drives.  I want to recover my raid and files but don't want to make it
> worse.  I have not mounted the drives as writable.  I think the damage
> should be limited, but I don't know mdadm well.  I have been digging
> for a few days on options and most advice is generic and bad and I
> feel would make it worse.  I don't know the original order the drives
> were in.
> 
> 1 drive is fully intact, probably due to a BIOS sata config not
> enabling all drives when i first booted.
> 
> The size makes this impractical to dd onto new disks.  The drives were
> 99% full and I was about to add 2 new drives.  Now if i can recover
> this, i will be starting a new array correctly and transfering files
> to that.
> 
> To fix, I have been leaning toward making the drives ready only and
> using an overlay file. Like here:
> https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Making_the_harddisks_read-only_using_an_overlay_file
> But i dont understand all the commands well enough to work this for my
> situation.  Seems like since I don't know the original drive
> arrangement that may be adding an additional level of complexity.  If
> I can figure out the read only and overlay, I still don't know exactly
> the right way to proceed on the mdadm front.  Please anyone who has a
> handle on a situation like this, let me know what I should do.  Thanks
> 
> 
> **Original command history for array:
> sudo mdadm --create --verbose /dev/md0 --level=5 --raid-devices=3
> /dev/sdc /dev/sdd /dev/sde
> cat /proc/mdstat
> sudo mkfs.ext4 -F /dev/md0
> sudo mkdir -p /media/raid
> sudo mount /dev/md0 /media/raid
> df -h -x devtmpfs -x tmpfs
> cat /proc/mdstat
> sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf
> sudo update-initramfs -u
> 
> sudo  umount /dev/md0
> sudo  umount /dev/md0 -f
> sudo  umount /dev/md0
> sudo  fsck.ext4 -f /dev/md0
> sudo  fsck.ext4
> sudo  fsck.ext4 -f /dev/md0 -p
> sudo  fsck.ext4 -f /dev/md0 -p -y
> sudo  fsck.ext4 -f /dev/md0 -y
> sudo  resize2fs /dev/md0
> sudo fdisk -l
> sudo parted -a optimal /dev/sdf
> sudo -i mdadm --add /dev/md0 /dev/sdf
> watch cat /proc/mdstat
> sudo mdadm --grow /dev/md0 --raid-devices=4
> sudo thunar
> watch cat /proc/mdstat
> sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf
> 
> cat /proc/mdstat
> sudo mount /dev/md0 /media/raid
> sudo mdadm --assemble --scan
> sudo mount /dev/md0 /media/raid
> 
> sudo fdisk -l
> sudo parted -s -a optimal /dev/sdb mklabel gpt
> parted /dev/sdb
> sudo parted /dev/sdb
> sudo mdadm --add /dev/md0 /dev/sdb1
> sudo mdadm --add /dev/md0 /dev/sdb
> cat /proc/mdstat
> mdadm --grow --raid-devices=4 /dev/md0
> sudo mdadm --grow --raid-devices=4 /dev/md0
> sudo mdadm --grow --raid-devices=5 /dev/md0
> cat /proc/mdstat
> sudo e2fsck -f /dev/md0
> cat /proc/mdstat
> sudo resize2fs /dev/md0
> cat /proc/mdstat
> sudo e2fsck -f /dev/md0
> sudo resize2fs /dev/md0
> 
> 
> 
> 
> **Here are some current details:
> uname -a
> Linux server 5.11.0-40-generic #44-Ubuntu SMP Wed Oct 20 16:16:42 UTC
> 2021 x86_64 x86_64 x86_64 GNU/Linux
> 
> mdadm --version
> mdadm - v4.1 - 2018-10-01
> 
> **
> sudo smartctl -H -i -l scterc /dev/sda
> smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.11.0-41-generic] (local build)
> Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org
> 
> === START OF INFORMATION SECTION ===
> Model Family:     Western Digital Ultrastar He10/12
> Device Model:     WDC WD100EZAZ-11TDBA0
> Serial Number:    1EK7U77Z
> LU WWN Device Id: 5 000cca 27eedd3d5
> Firmware Version: 83.H0A83
> User Capacity:    10,000,831,348,736 bytes [10.0 TB]
> Sector Sizes:     512 bytes logical, 4096 bytes physical
> Rotation Rate:    5400 rpm
> Form Factor:      3.5 inches
> Device is:        In smartctl database [for details use: -P show]
> ATA Version is:   ACS-2, ATA8-ACS T13/1699-D revision 4
> SATA Version is:  SATA 3.2, 6.0 Gb/s (current: 6.0 Gb/s)
> Local Time is:    Tue Nov 30 00:07:28 2021 EST
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
> 
> === START OF READ SMART DATA SECTION ===
> SMART overall-health self-assessment test result: PASSED
> 
> SCT Error Recovery Control:
>             Read: Disabled
>            Write: Disabled
> 
> **
> sudo smartctl -H -i -l scterc /dev/sdb
> smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.11.0-41-generic] (local build)
> Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org
> 
> === START OF INFORMATION SECTION ===
> Model Family:     Western Digital Ultrastar He10/12
> Device Model:     WDC WD100EMAZ-00WJTA0
> Serial Number:    JEHXKMMM
> LU WWN Device Id: 5 000cca 267db1416
> Firmware Version: 83.H0A83
> User Capacity:    10,000,831,348,736 bytes [10.0 TB]
> Sector Sizes:     512 bytes logical, 4096 bytes physical
> Rotation Rate:    5400 rpm
> Form Factor:      3.5 inches
> Device is:        In smartctl database [for details use: -P show]
> ATA Version is:   ACS-2, ATA8-ACS T13/1699-D revision 4
> SATA Version is:  SATA 3.2, 6.0 Gb/s (current: 6.0 Gb/s)
> Local Time is:    Tue Nov 30 00:08:34 2021 EST
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
> 
> === START OF READ SMART DATA SECTION ===
> SMART overall-health self-assessment test result: PASSED
> 
> SCT Error Recovery Control:
>             Read:     70 (7.0 seconds)
>            Write:     70 (7.0 seconds)
> 
> **
> sudo smartctl -H -i -l scterc /dev/sdc
> smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.11.0-41-generic] (local build)
> Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org
> 
> === START OF INFORMATION SECTION ===
> Model Family:     Western Digital Ultrastar He10/12
> Device Model:     WDC WD100EMAZ-00WJTA0
> Serial Number:    2YHVAJ8D
> LU WWN Device Id: 5 000cca 273da10a9
> Firmware Version: 83.H0A83
> User Capacity:    10,000,831,348,736 bytes [10.0 TB]
> Sector Sizes:     512 bytes logical, 4096 bytes physical
> Rotation Rate:    5400 rpm
> Form Factor:      3.5 inches
> Device is:        In smartctl database [for details use: -P show]
> ATA Version is:   ACS-2, ATA8-ACS T13/1699-D revision 4
> SATA Version is:  SATA 3.2, 6.0 Gb/s (current: 6.0 Gb/s)
> Local Time is:    Tue Nov 30 00:11:29 2021 EST
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
> 
> === START OF READ SMART DATA SECTION ===
> SMART overall-health self-assessment test result: PASSED
> 
> SCT Error Recovery Control:
>             Read:     70 (7.0 seconds)
>            Write:     70 (7.0 seconds)
> 
> **
> sudo smartctl -H -i -l scterc /dev/sdd
> smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.11.0-41-generic] (local build)
> Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org
> 
> === START OF INFORMATION SECTION ===
> Model Family:     Western Digital Ultrastar He10/12
> Device Model:     WDC WD100EMAZ-00WJTA0
> Serial Number:    2YHVABZD
> LU WWN Device Id: 5 000cca 273da1024
> Firmware Version: 83.H0A83
> User Capacity:    10,000,831,348,736 bytes [10.0 TB]
> Sector Sizes:     512 bytes logical, 4096 bytes physical
> Rotation Rate:    5400 rpm
> Form Factor:      3.5 inches
> Device is:        In smartctl database [for details use: -P show]
> ATA Version is:   ACS-2, ATA8-ACS T13/1699-D revision 4
> SATA Version is:  SATA 3.2, 6.0 Gb/s (current: 6.0 Gb/s)
> Local Time is:    Tue Nov 30 00:11:58 2021 EST
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
> 
> === START OF READ SMART DATA SECTION ===
> SMART overall-health self-assessment test result: PASSED
> 
> SCT Error Recovery Control:
>             Read:     70 (7.0 seconds)
>            Write:     70 (7.0 seconds)
> 
> **
> sudo smartctl -H -i -l scterc /dev/sde
> smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.11.0-41-generic] (local build)
> Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org
> 
> === START OF INFORMATION SECTION ===
> Model Family:     Western Digital Ultrastar He10/12
> Device Model:     WDC WD100EMAZ-00WJTA0
> Serial Number:    2YHV9GVD
> LU WWN Device Id: 5 000cca 273da0cbc
> Firmware Version: 83.H0A83
> User Capacity:    10,000,831,348,736 bytes [10.0 TB]
> Sector Sizes:     512 bytes logical, 4096 bytes physical
> Rotation Rate:    5400 rpm
> Form Factor:      3.5 inches
> Device is:        In smartctl database [for details use: -P show]
> ATA Version is:   ACS-2, ATA8-ACS T13/1699-D revision 4
> SATA Version is:  SATA 3.2, 6.0 Gb/s (current: 6.0 Gb/s)
> Local Time is:    Tue Nov 30 00:12:53 2021 EST
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
> 
> === START OF READ SMART DATA SECTION ===
> SMART overall-health self-assessment test result: PASSED
> 
> SCT Error Recovery Control:
>             Read:     70 (7.0 seconds)
>            Write:     70 (7.0 seconds)
> 
> ***************
> sudo mdadm --examine /dev/sda
> /dev/sda:
>     MBR Magic : aa55
> Partition[0] :   4294967295 sectors at            1 (type ee)
> 
> sudo mdadm --examine /dev/sda1
> /dev/sda1:
>     MBR Magic : aa55
> Partition[0] :   4294967295 sectors at   4294967295 (type ff)
> Partition[1] :   4294967295 sectors at   4294967295 (type ff)
> Partition[2] :   4294967295 sectors at   4294967295 (type ff)
> Partition[3] :    740229375 sectors at   4294967295 (type ff)
> 
> sudo mdadm --examine /dev/sdb
> /dev/sdb:
>     MBR Magic : aa55
> Partition[0] :   4294967295 sectors at            1 (type ee)
> 
> sudo mdadm --examine /dev/sdb1
> mdadm: cannot open /dev/sdb1: No such file or directory
> 
> sudo mdadm --examine /dev/sdc
> /dev/sdc:
>     MBR Magic : aa55
> Partition[0] :   4294967295 sectors at            1 (type ee)
> 
> sudo mdadm --examine /dev/sdc1
> mdadm: cannot open /dev/sdc1: No such file or directory
> 
> sudo mdadm --examine /dev/sdd
> /dev/sdd:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x1
>       Array UUID : 93e81091:84ba78f0:eb8232d9:c3c995f0
>             Name : bushserver:0  (local to host bushserver)
>    Creation Time : Fri Nov 16 13:20:25 2018
>       Raid Level : raid5
>     Raid Devices : 5
> 
>   Avail Dev Size : 19532616704 (9313.88 GiB 10000.70 GB)
>       Array Size : 39065219072 (37255.50 GiB 40002.78 GB)
>    Used Dev Size : 19532609536 (9313.87 GiB 10000.70 GB)
>      Data Offset : 257024 sectors
>     Super Offset : 8 sectors
>     Unused Space : before=256944 sectors, after=7168 sectors
>            State : clean
>      Device UUID : 2abcf2dc:f786e3fd:d22b7da9:7e8eec53
> 
> Internal Bitmap : 8 sectors from superblock
>      Update Time : Sun Nov 28 15:27:11 2021
>    Bad Block Log : 512 entries available at offset 48 sectors
>         Checksum : e27debbf - correct
>           Events : 213198
> 
>           Layout : left-symmetric
>       Chunk Size : 512K
> 
>     Device Role : Active device 1
>     Array State : AAAAA ('A' == active, '.' == missing, 'R' == replacing)
> $ sudo mdadm --examine /dev/sdd1
> mdadm: cannot open /dev/sdd1: No such file or directory
> 
> 
> sudo mdadm --examine /dev/sde
> /dev/sde:
>     MBR Magic : aa55
> Partition[0] :   4294967295 sectors at            1 (type ee)
> $ sudo mdadm --examine /dev/sde1
> mdadm: cannot open /dev/sde1: No such file or directory
> 
> ****************************************************
> sudo mdadm --detail /dev/md0
> /dev/md0:
>             Version : 1.2
>          Raid Level : raid0
>       Total Devices : 1
>         Persistence : Superblock is persistent
> 
>               State : inactive
>     Working Devices : 1
> 
>                Name : bushserver:0  (local to host bushserver)
>                UUID : 93e81091:84ba78f0:eb8232d9:c3c995f0
>              Events : 213198
> 
>      Number   Major   Minor   RaidDevice
> 
>         -       8       48        -        /dev/sdd
> *******************************************************
> 
> ./lsdrv
> **Warning** The following utility(ies) failed to execute:
>    sginfo
>    pvs
>    lvs
> Some information may be missing.
> 
> PCI [nvme] 41:00.0 Non-Volatile memory controller: Phison Electronics
> Corporation E12 NVMe Controller (rev 01)
> └nvme nvme0 Force MP510                              {211182930001291838A6}
>   └nvme0n1 447.13g [259:0] Empty/Unknown
>    ├nvme0n1p1 431.03g [259:1] Empty/Unknown
>    │└Mounted as /dev/nvme0n1p1 @ /
>    ├nvme0n1p2 1.00k [259:2] Empty/Unknown
>    └nvme0n1p5 15.87g [259:3] Empty/Unknown
> PCI [ahci] 00:17.0 SATA controller: Intel Corporation
> Q170/Q150/B150/H170/H110/Z170/CM236 Chipset SATA Controller [AHCI
> Mode] (rev 31)
> ├scsi 0:0:0:0 ATA      WDC WD100EZAZ-11
> │└sda 9.10t [8:0] Empty/Unknown
> │ └sda1 9.10t [8:1] Empty/Unknown
> ├scsi 1:0:0:0 ATA      WDC WD100EMAZ-00
> │└sdb 9.10t [8:16] Empty/Unknown
> ├scsi 3:0:0:0 ATA      WDC WD100EMAZ-00
> │└sdc 9.10t [8:32] Empty/Unknown
> ├scsi 4:0:0:0 ATA      WDC WD100EMAZ-00
> │└sdd 9.10t [8:48] Empty/Unknown
> │ └md0 0.00k [9:0] MD v1.2  () inactive, None (None) None
> {00000000:-0000-00:00-0000-:000000000000}
> │                  Empty/Unknown
> └scsi 5:0:0:0 ATA      WDC WD100EMAZ-00
>   └sde 9.10t [8:64] Empty/Unknown
> PCI [ahci] 04:00.0 SATA controller: ASMedia Technology Inc. ASM1062
> Serial ATA Controller (rev 02)
> └scsi 6:x:x:x [Empty]
> USB [usb-storage] Bus 001 Device 004: ID 1d6b:0104 Linux Foundation
> Multifunction Composite Gadget {CAFEBABE}
> └scsi 8:0:0:0 Linux    File-CD Gadget
>   └sr0 1.00g [11:0] Empty/Unknown
> Other Block Devices
> ├loop0 4.00k [7:0] Empty/Unknown
> │└Mounted as /dev/loop0 @ /snap/bare/5
> ├loop1 144.60m [7:1] Empty/Unknown
> │└Mounted as /dev/loop1 @ /snap/chromium/1810
> ├loop2 99.44m [7:2] Empty/Unknown
> │└Mounted as /dev/loop2 @ /snap/core/11798
> ├loop3 99.44m [7:3] Empty/Unknown
> │└Mounted as /dev/loop3 @ /snap/core/11993
> ├loop4 147.80m [7:4] Empty/Unknown
> │└Mounted as /dev/loop4 @ /snap/chromium/1827
> ├loop5 55.49m [7:5] Empty/Unknown
> │└Mounted as /dev/loop5 @ /snap/core18/2253
> ├loop6 55.50m [7:6] Empty/Unknown
> │└Mounted as /dev/loop6 @ /snap/core18/2246
> ├loop7 65.21m [7:7] Empty/Unknown
> │└Mounted as /dev/loop7 @ /snap/gtk-common-themes/1519
> ├loop8 164.76m [7:8] Empty/Unknown
> │└Mounted as /dev/loop8 @ /snap/gnome-3-28-1804/161
> ├loop9 65.10m [7:9] Empty/Unknown
> │└Mounted as /dev/loop9 @ /snap/gtk-common-themes/1515
> ├loop10 162.87m [7:10] Empty/Unknown
> │└Mounted as /dev/loop10 @ /snap/gnome-3-28-1804/145
> ├loop11 0.00k [7:11] Empty/Unknown
> ├zram0 1.96g [252:0] Empty/Unknown
> ├zram1 1.96g [252:1] Empty/Unknown
> ├zram2 1.96g [252:2] Empty/Unknown
> ├zram3 1.96g [252:3] Empty/Unknown
> ├zram4 1.96g [252:4] Empty/Unknown
> ├zram5 1.96g [252:5] Empty/Unknown
> ├zram6 1.96g [252:6] Empty/Unknown
> └zram7 1.96g [252:7] Empty/Unknown
> 
> ***********************************
> at /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md0 : inactive sdd[1](S)
>        9766308352 blocks super 1.2
> 
> unused devices: <none>

