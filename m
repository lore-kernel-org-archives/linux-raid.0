From: Simon McNair <simonmcnair@gmail.com>
Subject: Re: Linux software RAID assistance
Date: Wed, 16 Feb 2011 13:51:52 +0000
Message-ID: <4D5BD678.2050200@gmail.com>
References: <4D540F6C.6050904@gmail.com> <20110215155315.55d35b8e@notabene.brown> <4D5A92F3.1090004@turmel.org>
Reply-To: simonmcnair@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5A92F3.1090004@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

latest update.  A bit long I'm afraid...

hi, card installed and devices plugged in.  Now have
sda   sda2  sdb1  sdc1  sde   sdf1  sdg1  sdi   sdj1  sdk1  sdl1  sdm1
sda1  sdb   sdc   sdd   sdf   sdg   sdh   sdj   sdk   sdl   sdm


proxmox:/home/simon# ./lsdrv.sh
Controller device @ pci0000:00/0000:00:01.0/0000:01:00.0 [mvsas]
   SCSI storage controller: Marvell Technology Group Ltd.=20
MV64460/64461/64462 Sys                                         tem=20
Controller, Revision B (rev 01)
     host4: /dev/sdf ATA Hitachi HDS72101 {SN: GTA000PAGABXRA}
     host4: /dev/sdg ATA Hitachi HDS72101 {SN: GTA000PAGAA5DA}
     host4: /dev/sdh ATA Hitachi HDS72101 {SN: GTA000PAG9NL9A}
     host4: /dev/sdi ATA Hitachi HDS72101 {SN: GTA000PAGA8V4A}
     host4: /dev/sdj ATA Hitachi HDS72101 {SN: GTD000PAGMT9GD}
     host4: /dev/sdk ATA Hitachi HDS72101 {SN: GTG000PAG18BJC}
     host4: /dev/sdl ATA Hitachi HDS72101 {SN: GTG000PAG1DPLC}
     host4: /dev/sdm ATA Hitachi HDS72101 {SN: GTA000PAG7WMEA}
Controller device @=20
pci0000:00/0000:00:1a.7/usb1/1-4/1-4.1/1-4.1.1/1-4.1.1:1.0=20
[                                         usb-storage]
   Bus 001 Device 007: ID 0424:2228 Standard Microsystems Corp. 9-in-2=20
Card Reade                                         r {SN: 08050920003A}
     host9: /dev/sdd Generic Flash HS-CF
     host9: /dev/sde Generic Flash HS-COMBO
Controller device @ pci0000:00/0000:00:1c.4/0000:04:00.0 [ahci]
   SATA controller: JMicron Technology Corp. JMB362/JMB363 Serial ATA=20
Controller                                          (rev 03)
     host7: [Empty]
     host8: [Empty]
Controller device @ pci0000:00/0000:00:1c.4/0000:04:00.1 [pata_jmicron]
   IDE interface: JMicron Technology Corp. JMB362/JMB363 Serial ATA=20
Controller (r                                         ev 03)
     host5: [Empty]
     host6: [Empty]
Controller device @ pci0000:00/0000:00:1f.2 [ata_piix]
   IDE interface: Intel Corporation 82801JI (ICH10 Family) 4 port SATA=20
IDE Contro                                         ller #1
     host0: /dev/sda ATA STM3500418AS {SN: 9VM3QJ5C}
     host1: /dev/sr0 Optiarc DVD RW AD-5240S
Controller device @ pci0000:00/0000:00:1f.5 [ata_piix]
   IDE interface: Intel Corporation 82801JI (ICH10 Family) 2 port SATA=20
IDE Contro                                         ller #2
     host2: /dev/sdb ATA Hitachi HDS72101 {SN: GTD000PAGMT8DD}
     host3: /dev/sdc ATA Hitachi HDS72101 {SN: GTG000PAG04V0C}


proxmox:/home/simon# parted -l
Model: ATA STM3500418AS (scsi)
Disk /dev/sda: 500GB
Sector size (logical/physical): 512B/512B
Partition Table: msdos

Number  Start   End    Size   Type     File system  Flags
  1      32.8kB  537MB  537MB  primary  ext3         boot
  2      537MB   500GB  500GB  primary               lvm


Error: The backup GPT table is not at the end of the disk, as it should=
=20
be.  This might mean that another operating
system believes the disk is smaller.  Fix, by moving the backup to the=20
end (and removing the old backup)?
=46ix/Cancel? c

Error: The backup GPT table is not at the end of the disk, as it should=
=20
be.  This might mean that another operating
system believes the disk is smaller.  Fix, by moving the backup to the=20
end (and removing the old backup)?
=46ix/Cancel? c

Error: The backup GPT table is not at the end of the disk, as it should=
=20
be.  This might mean that another operating
system believes the disk is smaller.  Fix, by moving the backup to the=20
end (and removing the old backup)?
=46ix/Cancel? c

Model: Linux device-mapper (linear) (dm)
Disk /dev/mapper/pve-data: 380GB
Sector size (logical/physical): 512B/512B
Partition Table: loop

Number  Start  End    Size   File system  Flags
  1      0.00B  380GB  380GB  ext3


cModel: Linux device-mapper (linear) (dm)
Disk /dev/mapper/pve-root: 103GB
Sector size (logical/physical): 512B/512B
Partition Table: loop

Number  Start  End    Size   File system  Flags
  1      0.00B  103GB  103GB  ext3


Model: Linux device-mapper (linear) (dm)
Disk /dev/mapper/pve-swap: 11.8GB
Sector size (logical/physical): 512B/512B
Partition Table: loop

Number  Start  End     Size    File system  Flags
  1      0.00B  11.8GB  11.8GB  linux-swap


Error: The backup GPT table is not at the end of the disk, as it should=
=20
be.  This might mean that another operating
system believes the disk is smaller.  Fix, by moving the backup to the=20
end (and removing the old backup)?
=46ix/Cancel? c

Error: /dev/sdh: unrecognised disk label

Error: /dev/sdi: unrecognised disk label

Error: The backup GPT table is not at the end of the disk, as it should=
=20
be.  This might mean that another operating
system believes the disk is smaller.  Fix, by moving the backup to the=20
end (and removing the old backup)?
=46ix/Cancel? c

Error: The backup GPT table is not at the end of the disk, as it should=
=20
be.  This might mean that another operating
system believes the disk is smaller.  Fix, by moving the backup to the=20
end (and removing the old backup)?
=46ix/Cancel? c

Error: The backup GPT table is not at the end of the disk, as it should=
=20
be.  This might mean that another operating
system believes the disk is smaller.  Fix, by moving the backup to the=20
end (and removing the old backup)?
=46ix/Cancel? c

Error: The backup GPT table is not at the end of the disk, as it should=
=20
be.  This might mean that another operating
system believes the disk is smaller.  Fix, by moving the backup to the=20
end (and removing the old backup)?
=46ix/Cancel? c

Error: /dev/md0: unrecognised disk label


proxmox:/home/simon# mdadm --assemble --scan --verbose
mdadm: looking for devices for /dev/md/0
mdadm: cannot open device /dev/dm-2: Device or resource busy
mdadm: /dev/dm-2 has wrong uuid.
mdadm: cannot open device /dev/dm-1: Device or resource busy
mdadm: /dev/dm-1 has wrong uuid.
mdadm: cannot open device /dev/dm-0: Device or resource busy
mdadm: /dev/dm-0 has wrong uuid.
mdadm: no RAID superblock on /dev/sdf1
mdadm: /dev/sdf1 has wrong uuid.
mdadm: no RAID superblock on /dev/sdf
mdadm: /dev/sdf has wrong uuid.
mdadm: no RAID superblock on /dev/sdm1
mdadm: /dev/sdm1 has wrong uuid.
mdadm: no RAID superblock on /dev/sdm
mdadm: /dev/sdm has wrong uuid.
mdadm: no RAID superblock on /dev/sdl1
mdadm: /dev/sdl1 has wrong uuid.
mdadm: no RAID superblock on /dev/sdl
mdadm: /dev/sdl has wrong uuid.
mdadm: no RAID superblock on /dev/sdk1
mdadm: /dev/sdk1 has wrong uuid.
mdadm: no RAID superblock on /dev/sdk
mdadm: /dev/sdk has wrong uuid.
mdadm: no RAID superblock on /dev/sdj1
mdadm: /dev/sdj1 has wrong uuid.
mdadm: no RAID superblock on /dev/sdj
mdadm: /dev/sdj has wrong uuid.
mdadm: /dev/sdi has wrong uuid.
mdadm: /dev/sdh has wrong uuid.
mdadm: no RAID superblock on /dev/sdg1
mdadm: /dev/sdg1 has wrong uuid.
mdadm: no RAID superblock on /dev/sdg
mdadm: /dev/sdg has wrong uuid.
mdadm: no RAID superblock on /dev/sdc1
mdadm: /dev/sdc1 has wrong uuid.
mdadm: no RAID superblock on /dev/sdc
mdadm: /dev/sdc has wrong uuid.
mdadm: no RAID superblock on /dev/sdb1
mdadm: /dev/sdb1 has wrong uuid.
mdadm: no RAID superblock on /dev/sdb
mdadm: /dev/sdb has wrong uuid.
mdadm: cannot open device /dev/sda2: Device or resource busy
mdadm: /dev/sda2 has wrong uuid.
mdadm: cannot open device /dev/sda1: Device or resource busy
mdadm: /dev/sda1 has wrong uuid.
mdadm: cannot open device /dev/sda: Device or resource busy
mdadm: /dev/sda has wrong uuid.
mdadm: no devices found for /dev/md/0
mdadm: looking for devices for further assembly
mdadm: cannot open device /dev/dm-2: Device or resource busy
mdadm: cannot open device /dev/dm-1: Device or resource busy
mdadm: cannot open device /dev/dm-0: Device or resource busy
mdadm: no recogniseable superblock on /dev/sdf1
mdadm: no recogniseable superblock on /dev/sdf
mdadm: no recogniseable superblock on /dev/sdm1
mdadm: no recogniseable superblock on /dev/sdm
mdadm: no recogniseable superblock on /dev/sdl1
mdadm: no recogniseable superblock on /dev/sdl
mdadm: no recogniseable superblock on /dev/sdk1
mdadm: no recogniseable superblock on /dev/sdk
mdadm: no recogniseable superblock on /dev/sdj1
mdadm: no recogniseable superblock on /dev/sdj
mdadm: /dev/sdi is not built for host proxmox.
mdadm: /dev/sdh is not built for host proxmox.
mdadm: no recogniseable superblock on /dev/sdg1
mdadm: no recogniseable superblock on /dev/sdg
mdadm: no recogniseable superblock on /dev/sdc1
mdadm: no recogniseable superblock on /dev/sdc
mdadm: no recogniseable superblock on /dev/sdb1
mdadm: no recogniseable superblock on /dev/sdb
mdadm: cannot open device /dev/sda2: Device or resource busy
mdadm: cannot open device /dev/sda1: Device or resource busy
mdadm: cannot open device /dev/sda: Device or resource busy

proxmox:/home/simon# apt-show-versions -a mdadm
mdadm 2.6.7.2-3 install ok installed
mdadm 2.6.7.2-3       lenny ftp.uk.debian.org
No stable version
No testing version
mdadm 3.1.4-1+8efb9d1 sid   ftp.uk.debian.org
mdadm/lenny uptodate 2.6.7.2-3

anything else you want ?

Simon

On 15/02/2011 14:51, Phil Turmel wrote:
> Hi Neil,
>
> Since Simon has responded, let me summarize the assistance I provided=
 per his off-list request:
>
> On 02/14/2011 11:53 PM, NeilBrown wrote:
>> On Thu, 10 Feb 2011 16:16:44 +0000 Simon McNair<simonmcnair@gmail.co=
m>  wrote:
>>
>>> Hi all
>>>
>>> I use a 3ware 9500-12 port sata card (JBOD) which will not work wit=
hout a
>>> 128mb sodimm.  The sodimm socket is flakey and the result is that t=
he
>>> machine occasionally crashes.  Yesterday I finally gave in and put
>>> together another
>>> machine so that I can rsync between them.  When I turned the machin=
e
>>> on today to set up rync, the RAID array was not gone, but corrupted=
=2E
>>>    Typical...
>> Presumably the old machine was called 'ubuntu' and the new machine '=
pro=C3=B8lox'
>>
>>
>>> I built the array in Aug 2010 using the following command:
>>>
>>> mdadm --create --verbose /dev/md0 --metadata=3D1.1 --level=3D5
>>> --raid-devices=3D10 /dev/sd{b,c,d,e,f,g,h,i,j,k}1 --chunk=3D64
>>>
>>> Using LVM, I did the following:
>>> pvscan
>>> pvcreate -M2 /dev/md0
>>> vgcreate lvm-raid /dev/md0
>>> vgdisplay lvm-raid
>>> vgscan
>>> lvscan
>>> lvcreate -v -l 100%VG -n RAID lvm-raid
>>> lvdisplay /dev/lvm-raid/lvm0
>>>
>>> I then formatted using:
>>> mkfs -t ext4 -v -m .1 -b 4096 -E stride=3D16,stripe-width=3D144
>>> /dev/lvm-raid/RAID
>>>
>>> This worked perfectly since I created the array.  Now mdadm is comi=
ng up
>>> with
>>>
>>> proxmox:/dev/md# mdadm --assemble --scan --verbose
>>> mdadm: looking for devices for further assembly
>>> mdadm: no recogniseable superblock on /dev/md/ubuntu:0
>> And it seems that ubuntu:0 have been successfully assembled.
>> It is missing one device for some reason (sdd1) but RAID can cope wi=
th that.
> 3ware card is compromised, with a loose buffer memory dimm.  Some of =
its ECC errors were caught and reported in dmesg.  Its likely, based on=
 the loose memory socket, that many multiple-bit errors got through.
>
> [trim /]
>
>>> mdadm: no uptodate device for slot 8 of /dev/md/pro=EF=BF=BDlox:0
>>> mdadm: no uptodate device for slot 9 of /dev/md/pro=EF=BF=BDlox:0
>>> mdadm: failed to add /dev/sdd1 to /dev/md/pro=EF=BF=BDlox:0: Invali=
d argument
>>> mdadm: /dev/md/pro=EF=BF=BDlox:0 assembled from 0 drives - not enou=
gh to start
>>> the array.
>> This looks like it is *after* to trying the --create command you giv=
e
>> below..  It is best to report things in the order they happen, else =
you can
>> confuse people (or get caught out!).
> Yes, this was after.
>
>>> mdadm: looking for devices for further assembly
>>> mdadm: no recogniseable superblock on /dev/sdd
>>> mdadm: No arrays found in config file or automatically
>>>
>>> pvscan and vgscan show nothing.
>>>
>>> So I tried running mdadm --create --verbose /dev/md0 --metadata=3D1=
=2E1
>>> --level=3D5 --raid-devices=3D10 missing /dev/sde1 /dev/sdf1 /dev/sd=
g1
>>> /dev/sdh1 /dev/sdi1 /dev/sdj1 /dev/sdk1 /dev/sdl1 /dev/sdm1 --chunk=
=3D64
>>>
>>> as it seemed that /dev/sdd1 failed to be added to the array.  This =
did
>>> nothing.
>> It did not to nothing.  It wrote a superblock to /dev/sdd1 and compl=
ained
>> that it couldn't write to all the others --- didn't it?
> There were multiple attempts to create.  One wrote to just sdd1, anot=
her succeeded with all but sdd1.
>
>>> dmesg contains:
>>>
>>> md: invalid superblock checksum on sdd1
>> I guess that is why sdd1 was missing from 'ubuntu:0'.  Though as I c=
annot
>> tell if this happened before or after any of the various things repo=
rted
>> above, it is hard to be sure.
>>
>>
>> The  real mystery is why 'pvscan' reports nothing.
> The original array was created with mdadm v2.6.7, and had a data offs=
et of 264 sectors.  After Simon's various attempts to --create, he ende=
d up with data offset of 2048, using mdadm v3.1.4.  The mdadm -E report=
s he posted to the list showed the 264 offset.  We didn't realize the o=
ffset had been updated until somewhat later in our troubleshooting effo=
rts.
>
> In any case, pvscan couldn't see the LVM signature because it wasn't =
there (at offset 2048).
>
>> What about
>>    pvscan --verbose
>>
>> or
>>
>>    blkid -p /dev/md/ubuntu:0
>>
>> or even
>>
>>    dd of=3D/dev/md/ubuntu:0 count=3D8 | od -c
> Fortunately, Simon did have a copy of his LVM configuration.  With th=
e help of dd, strings, and grep, we did locate his LVM sig at the corre=
ct location on sdd1 (for data offset 264).  After a number of attempts =
to bypass LVM and access his single LV with dmsetup (based on his backe=
d up configuration, on the assembled new array less sdd1), I realized t=
hat the data offset was wrong on the recreated array, and went looking =
for the cause.  I found your git commit that changed that logic last sp=
ring, and recommended that Simon revert to the default package for his =
ubuntu install, which is v2.6.7.
>
> Simon has now attempted to recreate the array with v2.6.7, but the co=
ntroller is throwing too many errors to succeed, and I suggested it was=
 too flakey to trust any further.  Based on the existence of the LVM si=
g on sdd1, I believe Simon's data is (mostly) intact, and only needs a =
successful create operation with a properly functioning controller.  (H=
e might also need to perform an lvm vgcfgrestore, but he has the necess=
ary backup file.)
>
> A new controller is on order.
>
> Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
