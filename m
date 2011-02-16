From: Phil Turmel <philip@turmel.org>
Subject: Re: Linux software RAID assistance
Date: Wed, 16 Feb 2011 09:37:13 -0500
Message-ID: <4D5BE119.7000804@turmel.org>
References: <4D540F6C.6050904@gmail.com> <20110215155315.55d35b8e@notabene.brown> <4D5A92F3.1090004@turmel.org> <4D5BD678.2050200@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5BD678.2050200@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: simonmcnair@gmail.com
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good morning, Simon,

On 02/16/2011 08:51 AM, Simon McNair wrote:
> latest update.  A bit long I'm afraid...
> 
> hi, card installed and devices plugged in.  Now have
> sda   sda2  sdb1  sdc1  sde   sdf1  sdg1  sdi   sdj1  sdk1  sdl1  sdm1
> sda1  sdb   sdc   sdd   sdf   sdg   sdh   sdj   sdk   sdl   sdm

Hmmm.

> proxmox:/home/simon# ./lsdrv.sh
> Controller device @ pci0000:00/0000:00:01.0/0000:01:00.0 [mvsas]
>   SCSI storage controller: Marvell Technology Group Ltd. MV64460/64461/64462 Sys                                         tem Controller, Revision B (rev 01)
>     host4: /dev/sdf ATA Hitachi HDS72101 {SN: GTA000PAGABXRA}
>     host4: /dev/sdg ATA Hitachi HDS72101 {SN: GTA000PAGAA5DA}
>     host4: /dev/sdh ATA Hitachi HDS72101 {SN: GTA000PAG9NL9A}
>     host4: /dev/sdi ATA Hitachi HDS72101 {SN: GTA000PAGA8V4A}
>     host4: /dev/sdj ATA Hitachi HDS72101 {SN: GTD000PAGMT9GD}
>     host4: /dev/sdk ATA Hitachi HDS72101 {SN: GTG000PAG18BJC}
>     host4: /dev/sdl ATA Hitachi HDS72101 {SN: GTG000PAG1DPLC}
>     host4: /dev/sdm ATA Hitachi HDS72101 {SN: GTA000PAG7WMEA}
> Controller device @ pci0000:00/0000:00:1a.7/usb1/1-4/1-4.1/1-4.1.1/1-4.1.1:1.0 [                                         usb-storage]
>   Bus 001 Device 007: ID 0424:2228 Standard Microsystems Corp. 9-in-2 Card Reade                                         r {SN: 08050920003A}
>     host9: /dev/sdd Generic Flash HS-CF
>     host9: /dev/sde Generic Flash HS-COMBO
> Controller device @ pci0000:00/0000:00:1c.4/0000:04:00.0 [ahci]
>   SATA controller: JMicron Technology Corp. JMB362/JMB363 Serial ATA Controller                                          (rev 03)
>     host7: [Empty]
>     host8: [Empty]
> Controller device @ pci0000:00/0000:00:1c.4/0000:04:00.1 [pata_jmicron]
>   IDE interface: JMicron Technology Corp. JMB362/JMB363 Serial ATA Controller (r                                         ev 03)
>     host5: [Empty]
>     host6: [Empty]
> Controller device @ pci0000:00/0000:00:1f.2 [ata_piix]
>   IDE interface: Intel Corporation 82801JI (ICH10 Family) 4 port SATA IDE Contro                                         ller #1
>     host0: /dev/sda ATA STM3500418AS {SN: 9VM3QJ5C}
>     host1: /dev/sr0 Optiarc DVD RW AD-5240S
> Controller device @ pci0000:00/0000:00:1f.5 [ata_piix]
>   IDE interface: Intel Corporation 82801JI (ICH10 Family) 2 port SATA IDE Contro                                         ller #2
>     host2: /dev/sdb ATA Hitachi HDS72101 {SN: GTD000PAGMT8DD}
>     host3: /dev/sdc ATA Hitachi HDS72101 {SN: GTG000PAG04V0C}

Good thing we recorded the serial numbers.  From an earlier run of "lsdrv":

> Phil,
> sg3-utils did the job :-)
> Sorry for doubting you.
> 
>     host6: /dev/sdd AMCC 9500S-12 DISK {SN: PAGA8V4A3B8378002254}
>     host6: /dev/sde AMCC 9500S-12 DISK {SN: PAG9NL9A3B8387004C88}
>     host6: /dev/sdf AMCC 9500S-12 DISK {SN: PAGAA5DA3B8396001AE0}
>     host6: /dev/sdg AMCC 9500S-12 DISK {SN: PAGABXRA3B83A0005EFB}
>     host6: /dev/sdh AMCC 9500S-12 DISK {SN: PAG7WMEA3B83AA003E4F}
>     host6: /dev/sdi AMCC 9500S-12 DISK {SN: PAG1DPLC3B83B40026E6}
>     host6: /dev/sdj AMCC 9500S-12 DISK {SN: PAG18BJC3B83C3004760}
>     host6: /dev/sdk AMCC 9500S-12 DISK {SN: PAGMT9GD3B83CD004B18}
>     host6: /dev/sdl AMCC 9500S-12 DISK {SN: PAGMT8DD3B83D70021FF}
>     host6: /dev/sdm AMCC 9500S-12 DISK {SN: PAG04V0C3B83E100ACA0}
> 
> Simon

I don't know why the serial numbers are formatted differently, but we can still tell them apart (the eight characters starting with "PAG").

So, our device order in your new setup is: [ihgfmlkjbc], where /dev/sdi corresponds to the original report's /dev/sdd, which matches the sig grep in your other note.

Another note:  The controller for sd[abc] is still showing ata_piix as its controller.  That means you cannot hot-plug those ports.  If you change your BIOS to AHCI mode instead of "Compatibility" or "Emulation", the full-featured ahci driver will run those ports.  Not urgent, but I highly recommend it.

> proxmox:/home/simon# parted -l
> Model: ATA STM3500418AS (scsi)
> Disk /dev/sda: 500GB
> Sector size (logical/physical): 512B/512B
> Partition Table: msdos
> 
> Number  Start   End    Size   Type     File system  Flags
>  1      32.8kB  537MB  537MB  primary  ext3         boot
>  2      537MB   500GB  500GB  primary               lvm
> 
> 
> Error: The backup GPT table is not at the end of the disk, as it should be.  This might mean that another operating
> system believes the disk is smaller.  Fix, by moving the backup to the end (and removing the old backup)?
> Fix/Cancel? c

The 3ware controller must have reserved some space at the end of each drive for its own use.  Didn't know it'd do that.  You will have to fix that.

[trim /]

> Error: /dev/sdh: unrecognised disk label
> 
> Error: /dev/sdi: unrecognised disk label

It seems the flaky controller took out these partition tables.  Hope that's all it got.  They'll have to be re-created with parted.

Please run parted on each of the ten drives, and make sure they end up like so:

> proxmox:/home/simon# for x in sd{d..m} ; do parted -s /dev/$x unit s
> print ; done
> Model: AMCC 9500S-12 DISK (scsi)
> Disk /dev/sdd: 1953103872s
> Sector size (logical/physical): 512B/512B
> Partition Table: gpt
> 
> Number  Start  End          Size         File system  Name     Flags
>  1      2048s  1953101823s  1953099776s               primary  raid

Make sure you request "unit s" before your other commands so we can make sure it matches.

When you think you are done, check them all:

for x in /dev/sd{i,h,g,f,m,l,k,j,b,c} ; do parted -s $x unit s print ; done

After that, create:

mdadm --create --verbose --assume-clean /dev/md0 --metadata=1.1 --level=5 --raid-devices=10 /dev/sd{i,h,g,f,m,l,k,j,b,c}1 --chunk=64

And finally:

pvscan --verbose

Phil
