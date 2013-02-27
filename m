From: Stone <stone@heisl.org>
Subject: Re: Brocken Raid & LUKS
Date: Wed, 27 Feb 2013 20:04:41 +0100
Message-ID: <512E58C9.8080701@heisl.org>
References: <5123A1CC.2000003@heisl.org> <51269DE0.5070905@heisl.org> <512748FA.2000709@heisl.org> <51277876.30008@turmel.org> <51278793.80904@heisl.org> <512790AE.2080102@turmel.org> <5127B64A.3000808@heisl.org> <5127D857.9090204@heisl.org> <5127F2B8.4050601@turmel.org> <5127F45F.5020608@heisl.org> <512827FC.7010403@turmel.org> <5128336E.5060809@heisl.org> <51284762.2080202@turmel.org> <51289798.7050500@heisl.org> <5128E9F4.5040700@turmel.org> <5129421C.7070105@heisl.org> <51295599.5040907@turmel.org> <51295B1B.2030404@heisl.org> <51299135.1000206@turmel.org> <5129BCCC.7090202@heisl.org> <512A2094.3020008@turmel.org> <512A5A5A.5020904@heisl.org> <512A5CFA.6020205@turmel.org> <512A6897.3040809@heisl.org> <512A6F39.7090008@turmel.org> <512A74FA.8000100@heisl.org> <512A7730.7010600@turmel.or
 g> <512A7A2D.3040109@heisl.org> <512A7BC6.5010406@turmel.org> <512BAE16.1020205@heisl.org> <512BC570.20609@heisl.org> <512BFF83.20004@turmel.org> <512DB532.2080306@heisl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <512DB532.2080306@heisl.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

should i try a fsck -a?
>> No, go to case #2.
> i dont understand anything
>
> i have now three more disks an the mainboard for the spare copy.
> here now my new systeminfo:
> sda - system
> sdb - new spare
> sdc - new space
> sdd - new space
> sde - old raid
> sdf - old raid
> sdg - missing
> sdh - old raid
>
> i have take a copy from the sde sdf sdh to the new spare devices.
> ddrescue /dev/sde /dev/sdb --force
> ddrescue /dev/sdf /dev/sdc --force
> ddrescue /dev/sdh /dev/sdd --force
>
> now i would test case #2 with fsck -y and i have a look with parted 
> over the devices.
> ALL devices (new space and old raid) have now the start sector at 34 
> and not on 2048
> here a example:
> parted /dev/sdh unit s print
> Model: ATA WDC WD20EARS-00M (scsi)
> Disk /dev/sdh: 3907029168s
> Sector size (logical/physical): 512B/512B
> Partition Table: gpt
>
> Number  Start  End          Size         File system  Name  Flags
>  1      34s    3907029118s  3907029085s                     raid
>
> i dont understand this. all devices had his start sector on 2048 also 
> the one i changed for the case #1 test.
> how can this happend?
> if i try a
> mdadm --create /dev/md2 --assume-clean --chunk=512 --verbose --level=5 
> --raid-devices=4 /dev/sde1 /dev/sdf1 missing /dev/sdh1
> cryptsetup luksOpen /dev/md2 md2_nas
> i cant open luks because -> No key available with this passphrase
>
> i dont understand this.
> should i change the sector on all devices back to 2048 to check case #2?
>
>
sorry :-)
the last night was very short...

know i have tested case #2
for x in /dev/sd[efh] ; do parted $x unit s print ; done
Model: ATA WDC WD20EARS-00M (scsi)
Disk /dev/sde: 3907029168s
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start  End          Size         File system  Name  Flags
  1      34s    3907029118s  3907029085s                     raid

Model: ATA WDC WD20EARS-00M (scsi)
Disk /dev/sdf: 3907029168s
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start  End          Size         File system  Name     Flags
  1      2048s  3907029118s  3907027071s               prmiary

Model: ATA WDC WD20EARS-00M (scsi)
Disk /dev/sdh: 3907029168s
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start  End          Size         File system  Name  Flags
  1      34s    3907029118s  3907029085s                     raid

fsck -y /dev/mapper/md2_nas
fsck from util-linux 2.19.1
e2fsck 1.41.14 (22-Dec-2010)
fsck.ext4: Group descriptors look bad... trying backup blocks...
The filesystem size (according to the superblock) is 1465134336 blocks
The physical size of the device is 1465133568 blocks
Either the superblock or the partition table is likely to be corrupt!
Abort? yes

no success.

do you have any idea?

