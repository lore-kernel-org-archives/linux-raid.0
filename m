From: "NeilBrown" <neilb@suse.de>
Subject: Re: mdadm cannot open devices
Date: Mon, 29 Dec 2008 08:35:10 +1100 (EST)
Message-ID: <f1ba3787cda05ba24f9f60e7b058cb5d.squirrel@neil.brown.name>
References: <4956CBB2.7030805@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4956CBB2.7030805@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, December 28, 2008 11:43 am, Richard Scobie wrote:
> Just assembled a new Fedora 9 machine - md1-5 created OK, but am having
> trouble putting md6 together - machine rebooted after partitioning):
>
> [root@hugo2 ~]# mdadm -C /dev/md6 -l 1 -n 2 /dev/sda1 /dev/sdb1
> mdadm: Cannot open /dev/sda1: No such device or address
> mdadm: Cannot open /dev/sdb1: No such device or address
> mdadm: create aborted
>

This typically happens because /dev/sda and /dev/sdb have md superblocks
on them and mdadm attempts to assemble an array from those and in the
process tell the kernel to forget about the partitions.
Can you:

  blockdev --rereadpt /dev/sda
  blockdev --rereadpt /dev/sdb
  mdadm -E /dev/sda* /dev/sdb*

and report the result?

Thanks,
NeilBrown


> dmesg:
>
> ------------------------------------------------
>
> scsi0 : sata_sil
> scsi1 : sata_sil
> ata1: SATA max UDMA/100 mmio m512@0xf0401000 tf 0xf0401080 irq 21
> ata2: SATA max UDMA/100 mmio m512@0xf0401000 tf 0xf04010c0 irq 21
> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
> ata1.00: ATA-8: ST31000340NS, SN05, max UDMA/133
> ata1.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 0/32)
> ata1.00: configured for UDMA/100
> ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
> ata2.00: ATA-8: ST31000340NS, SN05, max UDMA/133
> ata2.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 0/32)
> ata2.00: configured for UDMA/100
> scsi 0:0:0:0: Direct-Access     ATA      ST31000340NS     SN05 PQ: 0 ANSI:
> 5
> sd 0:0:0:0: [sda] 1953525168 512-byte hardware sectors (1000205 MB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA
> sd 0:0:0:0: [sda] 1953525168 512-byte hardware sectors (1000205 MB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA
>   sda: sda1
> sd 0:0:0:0: [sda] Attached SCSI disk
> scsi 1:0:0:0: Direct-Access     ATA      ST31000340NS     SN05 PQ: 0 ANSI:
> 5
> sd 1:0:0:0: [sdb] 1953525168 512-byte hardware sectors (1000205 MB)
> sd 1:0:0:0: [sdb] Write Protect is off
> sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA
> sd 1:0:0:0: [sdb] 1953525168 512-byte hardware sectors (1000205 MB)
> sd 1:0:0:0: [sdb] Write Protect is off
> sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA
>   sdb: sdb1
> sd 1:0:0:0: [sdb] Attached SCSI disk
>
> --------------------------------------------------
>
> [root@hugo2 ~]# fdisk /dev/sda
>
> The number of cylinders for this disk is set to 121601.
> There is nothing wrong with that, but this is larger than 1024,
> and could in certain setups cause problems with:
> 1) software that runs at boot time (e.g., old versions of LILO)
> 2) booting and partitioning software from other OSs
>     (e.g., DOS FDISK, OS/2 FDISK)
>
> Command (m for help): p
>
> Disk /dev/sda: 1000.2 GB, 1000204886016 bytes
> 255 heads, 63 sectors/track, 121601 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
> Disk identifier: 0x2ef7934e
>
>     Device Boot      Start         End      Blocks   Id  System
> /dev/sda1               1      121585   976631481   83  Linux
>
>
> Kernel is 2.6.25-14.fc9.i686 and mdadm is mdadm-2.6.4-4.fc9.i386.
>
> Thanks,
>
> Richard
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

