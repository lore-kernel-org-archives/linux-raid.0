From: =?ISO-8859-1?Q?G=FCnther_J=2E?= Niederwimmer <gjn@gjn.priv.at>
Subject: Re: GPT Table broken on a Raid1
Date: Sat, 22 Sep 2012 10:37:19 +0200
Message-ID: <1718683.C0AtuyUDq1@techz>
References: <4961154.0TR9MeFlIq@techz> <E9C051A7-65EB-48F5-8D3B-1C374F271E0C@colorremedies.com> <3EC7177F-9973-4D2E-988B-7020298E1727@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3EC7177F-9973-4D2E-988B-7020298E1727@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Chris,

Am Freitag, 21. September 2012, 16:43:52 schrieb Chris Murphy:
> On Sep 21, 2012, at 1:35 PM, Chris Murphy wrote:
> > If you're making the RAID with that, it defaults to metadata versio=
n 1.2.
> > But to be sure mdadm -E /dev/mdX
>=20
> Scratch that. I was confused. Try these instead:

This is the output from a openSUSE 12.2 (DX58SO2)
=20
> mdadm -=E2=80=93detail-platform

       Platform : Intel(R) Matrix Storage Manager
        Version : 11.0.0.1339
    RAID Levels : raid0 raid1 raid10 raid5
    Chunk Sizes : 4k 8k 16k 32k 64k 128k
    2TB volumes : supported
      2TB disks : supported
      Max Disks : 6
    Max Volumes : 2 per array, 4 per controller
 I/O Controller : /sys/devices/pci0000:00/0000:00:1f.2 (SATA)


> mdadm =E2=80=93D /dev/md/imsm
On my system I have a /imsm0

/dev/md/imsm0:
        Version : imsm
     Raid Level : container
  Total Devices : 2

Working Devices : 2


           UUID : 363f146f:e7f29dc8:f05996c3:577ead6a
  Member Arrays : /dev/md/Volume0

    Number   Major   Minor   RaidDevice

       0       8        0        -        /dev/sda
       1       8       16        -        /dev/sdb



> mdadm =E2=80=93E /dev/sdX
/dev/sda:
          Magic : Intel Raid ISM Cfg Sig.
        Version : 1.1.00
    Orig Family : e3958f4b
         Family : e3958f4b
     Generation : 00013417
     Attributes : All supported
           UUID : 363f146f:e7f29dc8:f05996c3:577ead6a
       Checksum : 3e9e527c correct
    MPB Sectors : 1
          Disks : 2
   RAID Devices : 1

  Disk00 Serial : 6QF4WDE3
          State : active
             Id : 00000000
    Usable Size : 625137928 (298.09 GiB 320.07 GB)

[Volume0]:
           UUID : ec120401:b6ed52e6:3814fac4:48fcf4fc
     RAID Level : 1
        Members : 2
          Slots : [UU]
    Failed disk : none
      This Slot : 0
     Array Size : 625137664 (298.09 GiB 320.07 GB)
   Per Dev Size : 625137928 (298.09 GiB 320.07 GB)
  Sector Offset : 0
    Num Stripes : 2441944
     Chunk Size : 64 KiB
       Reserved : 0
  Migrate State : idle
      Map State : normal
    Dirty State : dirty

  Disk01 Serial : 6QF4WF5Z
          State : active
             Id : 00000001
    Usable Size : 625137928 (298.09 GiB 320.07 GB)


/dev/sdb:
          Magic : Intel Raid ISM Cfg Sig.
        Version : 1.1.00
    Orig Family : e3958f4b
         Family : e3958f4b
     Generation : 0001342f
     Attributes : All supported
           UUID : 363f146f:e7f29dc8:f05996c3:577ead6a
       Checksum : 3e9e5294 correct
    MPB Sectors : 1
          Disks : 2
   RAID Devices : 1

  Disk01 Serial : 6QF4WF5Z
          State : active
             Id : 00000001
    Usable Size : 625137928 (298.09 GiB 320.07 GB)

[Volume0]:
           UUID : ec120401:b6ed52e6:3814fac4:48fcf4fc
     RAID Level : 1
        Members : 2
          Slots : [UU]
    Failed disk : none
      This Slot : 1
     Array Size : 625137664 (298.09 GiB 320.07 GB)
   Per Dev Size : 625137928 (298.09 GiB 320.07 GB)
  Sector Offset : 0
    Num Stripes : 2441944
     Chunk Size : 64 KiB
       Reserved : 0
  Migrate State : idle
      Map State : normal
    Dirty State : dirty

  Disk00 Serial : 6QF4WDE3
          State : active
             Id : 00000000
    Usable Size : 625137928 (298.09 GiB 320.07 GB)

=20
> Anyway, I'm suspicious that you've got either your SATA controller al=
so with
> RAID enabled, or you're also using dmraid and it's conflicting with t=
he md
> driver. Or you've misconfigured mdadm for imsm. The result is the sec=
ondary
> GPT is getting squished. I think you should read this document, as it
> proposes creating a container first, then RAID within that. If you're
> creating the RAID entirely from within Windows this may not be what i=
t
> does.
>=20
> http://download.intel.com/design/intarch/PAPERS/326024.pdf

I working on this, to read all.

I installed with YaST2 and I hope it is only mdadm not all together ;).

But I mean I have read in the changelog from parted 3.1, it is a Raid(1=
) GPT=20
Error Bug corrected ?

I hope I can create a working mdadm 3.1 package witch is working with o=
penSUSE=20
12.2. (I am not a programmer) =20

Thanks for the hint to fedora, for the tool gdisk I don't found it befo=
re.=20
--=20
mit freundlichen Gr=C3=BC=C3=9Fen / best Regards.

  G=C3=BCnther J. Niederwimmer
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
