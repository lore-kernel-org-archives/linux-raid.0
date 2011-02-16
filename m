From: Simon McNair <simonmcnair@gmail.com>
Subject: Re: Linux software RAID assistance
Date: Wed, 16 Feb 2011 19:07:13 +0000
Message-ID: <4D5C2061.4060106@gmail.com>
References: <4D540F6C.6050904@gmail.com> <20110215155315.55d35b8e@notabene.brown> <4D5A92F3.1090004@turmel.org> <4D5BD678.2050200@gmail.com> <4D5BE119.7000804@turmel.org> <4D5C0E17.3060306@gmail.com> <4D5C140F.9010301@turmel.org> <4D5C1508.3040308@gmail.com> <4D5C15D3.1070608@turmel.org> <4D5C167C.7000101@turmel.org> <4D5C1CF8.1020507@gmail.com> <4D5C1E0B.9060300@turmel.org>
Reply-To: simonmcnair@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5C1E0B.9060300@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

pvscan is:
proxmox:/home/simon# pvscan --verbose
     Wiping cache of LVM-capable devices
     Wiping internal VG cache
     Walking through all physical volumes
   PV /dev/sda2   VG pve        lvm2 [465.26 GB / 4.00 GB free]
   PV /dev/md0    VG lvm-raid   lvm2 [8.19 TB / 0    free]
   Total: 2 [655.05 GB] / in use: 2 [655.05 GB] / in no VG: 0 [0   ]

lvm-raid is there ....

proxmox:/home/simon# fsck.ext4 -n /dev/md0
e2fsck 1.41.3 (12-Oct-2008)
fsck.ext4: Superblock invalid, trying backup blocks...
Superblock has an invalid ext3 journal (inode 8).
Clear? no

fsck.ext4: Illegal inode number while checking ext3 journal for /dev/md0

I thought I needed to run fsck against the lvm group ?  I used to do... 
fsck.ext4 /dev/lvm-raid/RAID so do I need to mount it or something ?

cheers
Simon


On 16/02/2011 18:57, Phil Turmel wrote:
> On 02/16/2011 01:52 PM, Simon McNair wrote:
>> have done this....  Results are:
>>
>> proxmox:/home/simon# ./lsdrv.sh
>> Controller device @ pci0000:00/0000:00:01.0/0000:01:00.0 [mvsas]
>>    SCSI storage controller: Marvell Technology Group Ltd. MV64460/64461/64462 System Controller, Revision B (rev 01)
>>      host0: /dev/sdf ATA Hitachi HDS72101 {SN: GTA000PAGABXRA}
>>      host0: /dev/sdg ATA Hitachi HDS72101 {SN: GTA000PAGAA5DA}
>>      host0: /dev/sdh ATA Hitachi HDS72101 {SN: GTA000PAG9NL9A}
>>      host0: /dev/sdi ATA Hitachi HDS72101 {SN: GTA000PAGA8V4A}
>>      host0: /dev/sdj ATA Hitachi HDS72101 {SN: GTD000PAGMT9GD}
>>      host0: /dev/sdk ATA Hitachi HDS72101 {SN: GTG000PAG18BJC}
>>      host0: /dev/sdl ATA Hitachi HDS72101 {SN: GTG000PAG1DPLC}
>>      host0: /dev/sdm ATA Hitachi HDS72101 {SN: GTA000PAG7WMEA}
>> Controller device @ pci0000:00/0000:00:1a.7/usb1/1-4/1-4.1/1-4.1.1/1-4.1.1:1.0 [usb-storage]
>>    Bus 001 Device 007: ID 0424:2228 Standard Microsystems Corp. 9-in-2 Card Reader {SN: 08050920003A}
>>      host11: /dev/sdb Generic Flash HS-CF
>>      host11: /dev/sdc Generic Flash HS-COMBO
>> Controller device @ pci0000:00/0000:00:1c.4/0000:04:00.0 [ahci]
>>    SATA controller: JMicron Technology Corp. JMB362/JMB363 Serial ATA Controller (rev 03)
>>      host9: [Empty]
>>      host10: [Empty]
>> Controller device @ pci0000:00/0000:00:1c.4/0000:04:00.1 [pata_jmicron]
>>    IDE interface: JMicron Technology Corp. JMB362/JMB363 Serial ATA Controller (rev 03)
>>      host1: [Empty]
>>      host2: [Empty]
>> Controller device @ pci0000:00/0000:00:1f.2 [ahci]
>>    SATA controller: Intel Corporation 82801JI (ICH10 Family) SATA AHCI Controller
>>      host3: /dev/sda ATA STM3500418AS {SN: 9VM3QJ5C}
>>      host4: /dev/sr0 Optiarc DVD RW AD-5240S
>>      host5: [Empty]
>>      host6: [Empty]
>>      host7: /dev/sdd ATA Hitachi HDS72101 {SN: GTD000PAGMT8DD}
>>      host8: /dev/sde ATA Hitachi HDS72101 {SN: GTG000PAG04V0C}
>>
>> enabling achi has switched the drive letters around for a couple of drives again
>>
>> parted list is:
>>
>> proxmox:/home/simon# for x in /dev/sd{i,h,g,f,m,l,k,j,d,e} ; do parted -s $x unit s print ; done
>> Model: ATA Hitachi HDS72101 (scsi)
>> Disk /dev/sdi: 1953525168s
>> Sector size (logical/physical): 512B/512B
>> Partition Table: gpt
>>
>> Number  Start  End          Size         File system  Name     Flags
>>   1      2048s  1953101823s  1953099776s               primary  raid
>>
>> Model: ATA Hitachi HDS72101 (scsi)
>> Disk /dev/sdh: 1953525168s
>> Sector size (logical/physical): 512B/512B
>> Partition Table: gpt
>>
>> Number  Start  End          Size         File system  Name     Flags
>>   1      2048s  1953101823s  1953099776s               primary  raid
>>
>> Model: ATA Hitachi HDS72101 (scsi)
>> Disk /dev/sdg: 1953525168s
>> Sector size (logical/physical): 512B/512B
>> Partition Table: gpt
>>
>> Number  Start  End          Size         File system  Name     Flags
>>   1      2048s  1953101823s  1953099776s               primary  raid
>>
>> Model: ATA Hitachi HDS72101 (scsi)
>> Disk /dev/sdf: 1953525168s
>> Sector size (logical/physical): 512B/512B
>> Partition Table: gpt
>>
>> Number  Start  End          Size         File system  Name     Flags
>>   1      2048s  1953101823s  1953099776s               primary  raid
>>
>> Model: ATA Hitachi HDS72101 (scsi)
>> Disk /dev/sdm: 1953525168s
>> Sector size (logical/physical): 512B/512B
>> Partition Table: gpt
>>
>> Number  Start  End          Size         File system  Name     Flags
>>   1      2048s  1953101823s  1953099776s               primary  raid
>>
>> Model: ATA Hitachi HDS72101 (scsi)
>> Disk /dev/sdl: 1953525168s
>> Sector size (logical/physical): 512B/512B
>> Partition Table: gpt
>>
>> Number  Start  End          Size         File system  Name     Flags
>>   1      2048s  1953101823s  1953099776s               primary  raid
>>
>> Model: ATA Hitachi HDS72101 (scsi)
>> Disk /dev/sdk: 1953525168s
>> Sector size (logical/physical): 512B/512B
>> Partition Table: gpt
>>
>> Number  Start  End          Size         File system  Name     Flags
>>   1      2048s  1953101823s  1953099776s               primary  raid
>>
>> Model: ATA Hitachi HDS72101 (scsi)
>> Disk /dev/sdj: 1953525168s
>> Sector size (logical/physical): 512B/512B
>> Partition Table: gpt
>>
>> Number  Start  End          Size         File system  Name     Flags
>>   1      2048s  1953101823s  1953099776s               primary  raid
>>
>> Model: ATA Hitachi HDS72101 (scsi)
>> Disk /dev/sdd: 1953525168s
>> Sector size (logical/physical): 512B/512B
>> Partition Table: gpt
>>
>> Number  Start  End          Size         File system  Name     Flags
>>   1      2048s  1953101823s  1953099776s               primary  raid
>>
>> Model: ATA Hitachi HDS72101 (scsi)
>> Disk /dev/sde: 1953525168s
>> Sector size (logical/physical): 512B/512B
>> Partition Table: gpt
>>
>> Number  Start  End          Size         File system  Name     Flags
>>   1      2048s  1953101823s  1953099776s               primary  raid
> All looks good.
>
>> is it now:
>>
>> mdadm --create --verbose --assume-clean /dev/md0 --metadata=1.1 --level=5 --raid-devices=10 /dev/sd{i,h,g,f,m,l,k,j,d,e}1 --chunk=64
> Yes.
>
> Phil
