From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Hello,Re: GPT Table broken on a Raid1
Date: Mon, 24 Sep 2012 15:12:22 -0600
Message-ID: <505B736A-B9FE-4DB5-BA22-FEFDF1F9EE47@colorremedies.com>
References: <4961154.0TR9MeFlIq@techz> <3192749.CyYuocktFM@techz> <C21D75CB-9991-4FE2-8B9C-DD7F53AE60F1@colorremedies.com> <2286535.1cCOBDZvYY@techz>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2286535.1cCOBDZvYY@techz>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Sep 24, 2012, at 3:06 PM, G=FCnther J. Niederwimmer wrote:

>=20
>> mdadm -D /dev/md126
>=20
> /dev/md126:
>      Container : /dev/md/imsm0, member 0
>     Raid Level : raid1
>     Array Size : 312568832 (298.09 GiB 320.07 GB)
>  Used Dev Size : 312568964 (298.09 GiB 320.07 GB)
>   Raid Devices : 2
>  Total Devices : 2
>=20
>          State : active=20

Probably clean. Try:

mdadm -E /dev/sda

>=20
> ARRAY /dev/md/imsm0 metadata=3Dimsm UUID=3D363f146f:e7f29dc8:f05996c3=
:577ead6a
> ARRAY /dev/md/Volume0 container=3D/dev/md/imsm0 member=3D0=20
> UUID=3Dec120401:b6ed52e6:3814fac4:48fcf4fc
>=20
>=20
> Question: Why create mdadm also a md127, I found this now ?

Kernel is mapping /dev/md/Volume0 to /dev/md126. It's doing the same on=
 my system, although it's using md126. Not sure if that's controllable =
or not. Maybe someone else can answer it.


Chris Murphy--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
