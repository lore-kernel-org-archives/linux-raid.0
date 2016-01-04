From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: Intel IMSM RAID 5 won't start
Date: Mon, 4 Jan 2016 16:14:45 +0100
Message-ID: <568A8C65.3010103@intel.com>
References: <CAEUPnrygMz5qs=Saw4maWOriS7bb72-+RO_CSGd_+neQPhp49g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAEUPnrygMz5qs=Saw4maWOriS7bb72-+RO_CSGd_+neQPhp49g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guido D'Arezzo <gdarrezzo@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/03/2016 08:44 PM, Guido D'Arezzo wrote:
> Hi
>=20
> After 20 months trouble-free Intel IMSM RAID, I had to do a hard rese=
t
> and the array has failed to start.  I don=E2=80=99t know if the faile=
d RAID
> was the cause of the problems before the reset.  The system won=E2=80=
=99t boot
> because everything is on the RAID array.  Booting from a live Fedora
> USB shows no sign that the discs are broken and I was able to copy 1
> GB off each disc with dd.  I hope someone can help me to rescue the
> array.
>=20
> It is a 4 x 1 TB disc RAID 5 array.  The system was running Archlinux
> and I had patched it a day or 2 before for the first time in a few
> months, thought it had been rebooted more than once afterwards withou=
t
> incident.
>=20
> The Intel oROM says disc 2 is =E2=80=9COffline Member=E2=80=9D and 3 =
is =E2=80=9CFailed Disk=E2=80=9D.
>=20
> ---------------------------------------------------------------------=
--
> Intel(R) Rapid Storage Technology - Option ROM - 11.6.0.1702
>=20
> RAID Volumes:
> ID    Name    Level        Strip    Size    Status     Bootable
> O    md0    RAID5(Parity)    128KB    2.6TB    Failed    No
> 1    mdl    RAID5(Parity)    128KB    94.5GB    Failed    No
>=20
> Physical Devices:
> ID    Device    Model        Serial #    Size    Type/Status(Vol ID)
> O    WDC WD10EZEK-00K    WD-ACC1S5684189    931.5GB    Member Disk(0,=
1)
> 1    SAMSUNG HD103UJ        S13PJDAS608384    931.5GB    Member Disk(=
O,1)
> 2    SAMSUNG HD103SJ        SZ46J9GZC04Z67    931.5GB Offline Member
> 3    SAMSUNG HD103UJ        S13PJDAS608386    931.5GB    Unknown Disk
> 4    WDC WD10EZEK-08M    WD-ACC3F1681668    931.5GB    Non-RAID Disk
>=20
> ---------------------------------------------------------------------=
--
>=20
> The 2 RAID volumes were both spread across all 4 discs.  This is how
> it looks now:
>=20
> # mdadm -D /dev/md/imsm0
> /dev/md/imsm0:
>         Version : imsm
>      Raid Level : container
>   Total Devices : 1
>=20
> Working Devices : 1
>=20
>=20
>            UUID : 76cff3f5:1a3a7a83:49fc86a8:84cf6604
>   Member Arrays :
>=20
>     Number   Major   Minor   RaidDevice
>=20
>        0       8       48        -        /dev/sdd
> #
>=20
> # mdadm -D /dev/md/imsm1
> /dev/md/imsm1:
>         Version : imsm
>      Raid Level : container
>   Total Devices : 3
>=20
> Working Devices : 3
>=20
>=20
>            UUID : e8286680:de9642f4:04200a4a:acbdb566
>   Member Arrays :
>=20
>     Number   Major   Minor   RaidDevice
>=20
>        0       8       16        -        /dev/sdb
>        1       8       32        -        /dev/sdc
>        2       8        0        -        /dev/sda
> #
>=20
> # mdadm --detail-platform
>  Platform : Intel(R) Matrix Storage Manager
>  Version : 11.6.0.1702
>  RAID Levels : raid0 raid1 raid10 raid5
>  Chunk Sizes : 4k 8k 16k 32k 64k 128k
>  2TB volumes : supported
>  2TB disks : supported
>  Max Disks : 6
>  Max Volumes : 2 per array, 4 per controller
>  I/O Controller : /sys/devices/pci0000:00/0000:00:1f.2 (SATA)
> #
>=20
>=20
> # mdadm --examine /dev/sd[abcd]
> /dev/sda:
>           Magic : Intel Raid ISM Cfg Sig.
>         Version : 1.3.00
>     Orig Family : d12e9b21
>          Family : d12e9b21
>      Generation : 00695bbd
>      Attributes : All supported
>            UUID : e8286680:de9642f4:04200a4a:acbdb566
>        Checksum : 8f6fe1cb correct
>     MPB Sectors : 2
>           Disks : 4
>    RAID Devices : 2
>=20
>   Disk01 Serial : WD-WCC1S5684189
>           State : active
>              Id : 00000000
>     Usable Size : 1953518862 (931.51 GiB 1000.20 GB)
>=20
> [md0]:
>            UUID : d5bf7ab7:2cda417d:f0c6542f:c77d9289
>      RAID Level : 5
>         Members : 4
>           Slots : [_U_U]
>     Failed disk : 2
>       This Slot : 1
>      Array Size : 5662310400 (2700.00 GiB 2899.10 GB)
>    Per Dev Size : 1887436800 (900.00 GiB 966.37 GB)
>   Sector Offset : 0
>     Num Stripes : 7372800
>      Chunk Size : 128 KiB
>        Reserved : 0
>   Migrate State : idle
>       Map State : failed
>     Dirty State : clean
>=20
> [md1]:
>            UUID : 26671da2:0d23f085:3d12dbbe:f63aad5a
>      RAID Level : 5
>         Members : 4
>           Slots : [__UU]
>     Failed disk : 0
>       This Slot : 2
>      Array Size : 198232064 (94.52 GiB 101.49 GB)
>    Per Dev Size : 66077952 (31.51 GiB 33.83 GB)
>   Sector Offset : 1887440896
>     Num Stripes : 258117
>      Chunk Size : 128 KiB
>        Reserved : 0
>   Migrate State : idle
>       Map State : failed
>     Dirty State : clean
>=20
>   Disk00 Serial : PJDWS608386:0:0
>           State : active
>              Id : ffffffff
>     Usable Size : 1953518862 (931.51 GiB 1000.20 GB)
>=20
>   Disk02 Serial : 6J9GZC04267:0:0
>           State : active failed
>              Id : ffffffff
>     Usable Size : 1953518862 (931.51 GiB 1000.20 GB)
>=20
>   Disk03 Serial : S13PJDWS608384
>           State : active
>              Id : 00000001
>     Usable Size : 1953518862 (931.51 GiB 1000.20 GB)
>=20
> /dev/sdb:
>           Magic : Intel Raid ISM Cfg Sig.
>         Version : 1.3.00
>     Orig Family : d12e9b21
>          Family : d12e9b21
>      Generation : 00695bbd
>      Attributes : All supported
>            UUID : e8286680:de9642f4:04200a4a:acbdb566
>        Checksum : 8f6fe1cb correct
>     MPB Sectors : 2
>           Disks : 4
>    RAID Devices : 2
>=20
>   Disk03 Serial : S13PJDWS608384
>           State : active
>              Id : 00000001
>     Usable Size : 1953518862 (931.51 GiB 1000.20 GB)
>=20
> [md0]:
>            UUID : d5bf7ab7:2cda417d:f0c6542f:c77d9289
>      RAID Level : 5
>         Members : 4
>           Slots : [_U_U]
>     Failed disk : 2
>       This Slot : 3
>      Array Size : 5662310400 (2700.00 GiB 2899.10 GB)
>    Per Dev Size : 1887436800 (900.00 GiB 966.37 GB)
>   Sector Offset : 0
>     Num Stripes : 7372800
>      Chunk Size : 128 KiB
>        Reserved : 0
>   Migrate State : idle
>       Map State : failed
>     Dirty State : clean
>=20
> [md1]:
>            UUID : 26671da2:0d23f085:3d12dbbe:f63aad5a
>      RAID Level : 5
>         Members : 4
>           Slots : [__UU]
>     Failed disk : 0
>       This Slot : 3
>      Array Size : 198232064 (94.52 GiB 101.49 GB)
>    Per Dev Size : 66077952 (31.51 GiB 33.83 GB)
>   Sector Offset : 1887440896
>     Num Stripes : 258117
>      Chunk Size : 128 KiB
>        Reserved : 0
>   Migrate State : idle
>       Map State : failed
>     Dirty State : clean
>=20
>   Disk00 Serial : PJDWS608386:0:0
>           State : active
>              Id : ffffffff
>     Usable Size : 1953518862 (931.51 GiB 1000.20 GB)
>=20
>   Disk01 Serial : WD-WCC1S5684189
>           State : active
>              Id : 00000000
>     Usable Size : 1953518862 (931.51 GiB 1000.20 GB)
>=20
>   Disk02 Serial : 6J9GZC04267:0:0
>           State : active failed
>              Id : ffffffff
>     Usable Size : 1953518862 (931.51 GiB 1000.20 GB)
>=20
> /dev/sdc:
>           Magic : Intel Raid ISM Cfg Sig.
>         Version : 1.3.00
>     Orig Family : d12e9b21
>          Family : d12e9b21
>      Generation : 00695b88
>      Attributes : All supported
>            UUID : e8286680:de9642f4:04200a4a:acbdb566
>        Checksum : a72daa29 correct
>     MPB Sectors : 2
>           Disks : 4
>    RAID Devices : 2
>=20
>   Disk02 Serial : S246J9GZC04267
>           State : active
>              Id : 00000002
>     Usable Size : 1953518862 (931.51 GiB 1000.20 GB)
>=20
> [md0]:
>            UUID : d5bf7ab7:2cda417d:f0c6542f:c77d9289
>      RAID Level : 5
>         Members : 4
>           Slots : [UUUU]
>     Failed disk : none
>       This Slot : 2
>      Array Size : 5662310400 (2700.00 GiB 2899.10 GB)
>    Per Dev Size : 1887436800 (900.00 GiB 966.37 GB)
>   Sector Offset : 0
>     Num Stripes : 7372800
>      Chunk Size : 128 KiB
>        Reserved : 0
>   Migrate State : idle
>       Map State : normal
>     Dirty State : dirty
>=20
> [md1]:
>            UUID : 26671da2:0d23f085:3d12dbbe:f63aad5a
>      RAID Level : 5
>         Members : 4
>           Slots : [UUUU]
>     Failed disk : none
>       This Slot : 0
>      Array Size : 198232064 (94.52 GiB 101.49 GB)
>    Per Dev Size : 66077952 (31.51 GiB 33.83 GB)
>   Sector Offset : 1887440896
>     Num Stripes : 258117
>      Chunk Size : 128 KiB
>        Reserved : 0
>   Migrate State : idle
>       Map State : normal
>     Dirty State : clean
>=20
>   Disk00 Serial : S13PJDWS608386
>           State : active
>              Id : 00000003
>     Usable Size : 1953518862 (931.51 GiB 1000.20 GB)
>=20
>   Disk01 Serial : WD-WCC1S5684189
>           State : active
>              Id : 00000000
>     Usable Size : 1953518862 (931.51 GiB 1000.20 GB)
>=20
>   Disk03 Serial : S13PJDWS608384
>           State : active
>              Id : 00000001
>     Usable Size : 1953518862 (931.51 GiB 1000.20 GB)
>=20
> /dev/sdd:
>           Magic : Intel Raid ISM Cfg Sig.
>         Version : 1.0.00
>     Orig Family : c7e42747
>          Family : c7e42747
>      Generation : 00000000
>      Attributes : All supported
>            UUID : 76cff3f5:1a3a7a83:49fc86a8:84cf6604
>        Checksum : 4f820c2e correct
>     MPB Sectors : 1
>           Disks : 1
>    RAID Devices : 0
>=20
>   Disk00 Serial : S13PJDWS608386
>           State :
>              Id : 00000003
>     Usable Size : 1953518862 (931.51 GiB 1000.20 GB)
> #

Hi Guido,

It looks like the metadata on the drives got messed up for some reason.
If you believe the drives are good, you can try recreating the arrays
with the same layout to write fresh metadata to the drives, without
overwriting the actual data. In this case it can be done like this (mak=
e
a backup of the drives using dd before trying it):

# mdadm -Ss
# mdadm -C /dev/md/imsm0 -eimsm -n4 /dev/sdd /dev/sda /dev/sdc /dev/sdb=
 -R
# mdadm -C /dev/md/md0 -l5 -n4 /dev/sdd /dev/sda /dev/sdc /dev/sdb --si=
ze=3D900G
--chunk=3D128 --assume-clean -R
# mdadm -C /dev/md/md1 -l5 -n4 /dev/sdd /dev/sda /dev/sdc /dev/sdb --ch=
unk=3D128
--assume-clean -R

Drives should be listed in the order as they appear in the output from
mdadm -E. Look at the "DiskXX Serial" lines.

Then you can run fsck on the filesystems. Finally, repair any mismatche=
d
parity blocks:

# echo repair > /sys/block/md126/md/sync_action=20
# echo repair > /sys/block/md125/md/sync_action=20

You may have to update places like fstab, bootloader config,
/etc/mdadm.conf, because the array UUIDs will change.

Regards,
Artur

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
