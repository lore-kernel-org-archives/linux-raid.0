From: =?ISO-8859-1?Q?G=FCnther_J=2E?= Niederwimmer <gjn@gjn.priv.at>
Subject: Re: Hello,Re: GPT Table broken on a Raid1
Date: Mon, 24 Sep 2012 23:06:32 +0200
Message-ID: <2286535.1cCOBDZvYY@techz>
References: <4961154.0TR9MeFlIq@techz> <3192749.CyYuocktFM@techz> <C21D75CB-9991-4FE2-8B9C-DD7F53AE60F1@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C21D75CB-9991-4FE2-8B9C-DD7F53AE60F1@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Chris,

Am Montag, 24. September 2012, 14:18:27 schrieb Chris Murphy:
> On Sep 24, 2012, at 1:06 PM, G=FCnther J. Niederwimmer wrote:
> > Disk /dev/sda: 320.1 GB, 320072933376 bytes
> > 256 K=F6pfe, 63 Sektoren/Spur, 38761 Zylinder, zusammen 625142448 S=
ektoren
> > Einheiten =3D Sektoren von 1 =D7 512 =3D 512 Bytes
> > Sector size (logical/physical): 512 bytes / 512 bytes
> > I/O size (minimum/optimal): 512 bytes / 512 bytes
> > Disk identifier: 0x00000000
> >=20
> >   Ger=E4t  boot.     Anfang        Ende     Bl=F6cke   Id  System
> >=20
> > /dev/sda1               1  4294967295  2147483647+  ee  GPT
>=20
> Well that's screwy. But at least the PMBR is protecting all sectors (=
and
> quite a bit more that don't exist) of this disk.
>=20
> Last time we checked, the array state was dirty. Is that still the ca=
se?
> Report the results from these two:

Yes Sir ;).
=20
> mdadm -D /dev/md126

/dev/md126:
      Container : /dev/md/imsm0, member 0
     Raid Level : raid1
     Array Size : 312568832 (298.09 GiB 320.07 GB)
  Used Dev Size : 312568964 (298.09 GiB 320.07 GB)
   Raid Devices : 2
  Total Devices : 2

          State : active=20
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0


           UUID : ec120401:b6ed52e6:3814fac4:48fcf4fc
    Number   Major   Minor   RaidDevice State
       1       8        0        0      active sync   /dev/sda
       0       8       16        1      active sync   /dev/sdb

=20
> mdadm -Ds

ARRAY /dev/md/imsm0 metadata=3Dimsm UUID=3D363f146f:e7f29dc8:f05996c3:5=
77ead6a
ARRAY /dev/md/Volume0 container=3D/dev/md/imsm0 member=3D0=20
UUID=3Dec120401:b6ed52e6:3814fac4:48fcf4fc


Question: Why create mdadm also a md127, I found this now ?

/dev/md127:
        Version : imsm
     Raid Level : container
  Total Devices : 2

Working Devices : 2


           UUID : 363f146f:e7f29dc8:f05996c3:577ead6a
  Member Arrays : /dev/md/Volume0

    Number   Major   Minor   RaidDevice

       0       8       16        -        /dev/sdb
       1       8        0        -        /dev/sda



--=20
mit freundlichen Gr=FC=DFen / best Regards.

  G=FCnther J. Niederwimmer
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
