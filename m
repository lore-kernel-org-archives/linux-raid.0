From: =?ISO-8859-1?Q?G=FCnther_J=2E?= Niederwimmer <gjn@gjn.priv.at>
Subject: Re: Hello,Re: GPT Table broken on a Raid1
Date: Tue, 25 Sep 2012 10:27:52 +0200
Message-ID: <5231765.ZMIFzBOKSc@techz>
References: <4961154.0TR9MeFlIq@techz> <2286535.1cCOBDZvYY@techz> <505B736A-B9FE-4DB5-BA22-FEFDF1F9EE47@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <505B736A-B9FE-4DB5-BA22-FEFDF1F9EE47@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Chris,

Am Montag, 24. September 2012, 15:12:22 schrieb Chris Murphy:
> On Sep 24, 2012, at 3:06 PM, G=FCnther J. Niederwimmer wrote:
> >> mdadm -D /dev/md126
> >=20
> > /dev/md126:
> >      Container : /dev/md/imsm0, member 0
> >    =20
> >     Raid Level : raid1
> >     Array Size : 312568832 (298.09 GiB 320.07 GB)
> > =20
> >  Used Dev Size : 312568964 (298.09 GiB 320.07 GB)
> > =20
> >   Raid Devices : 2
> > =20
> >  Total Devices : 2
> > =20
> >          State : active
>=20
> Probably clean. Try:
>=20
> mdadm -E /dev/sda

/dev/sda:
          Magic : Intel Raid ISM Cfg Sig.
        Version : 1.1.00
    Orig Family : e3958f4b
         Family : e3958f4b
     Generation : 00017ffe
     Attributes : All supported
           UUID : 363f146f:e7f29dc8:f05996c3:577ead6a
       Checksum : 3e9e9e6b correct
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


=20
> > ARRAY /dev/md/imsm0 metadata=3Dimsm UUID=3D363f146f:e7f29dc8:f05996=
c3:577ead6a
> > ARRAY /dev/md/Volume0 container=3D/dev/md/imsm0 member=3D0
> > UUID=3Dec120401:b6ed52e6:3814fac4:48fcf4fc
> >=20
> >=20
> > Question: Why create mdadm also a md127, I found this now ?
>=20
> Kernel is mapping /dev/md/Volume0 to /dev/md126. It's doing the same =
on my
> system, although it's using md126. Not sure if that's controllable or=
 not.
> Maybe someone else can answer it.

No Problem, but i tell it to you, for me it is mystery. ;)
=20
--=20
mit freundlichen Gr=FC=DFen / best Regards.

  G=FCnther J. Niederwimmer
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
