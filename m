From: Kasper Dupont <kasperd@daimi.au.dk>
Subject: Re: RAID-6 support in kernel?
Date: Thu, 06 Jun 2002 10:28:28 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3CFF1D2C.5861132C@daimi.au.dk>
References: <Pine.GSO.4.21.0206051716530.16571-100000@gecko.roadtoad.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: Derek Vadala <derek@cynicism.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Derek Vadala wrote:
>=20
>   RAID-1 --------> RAID-5 (D0,D1,D2,D3,P0)
>               |--> RAID-5 (D0,D1,D2,D3,P0)
>    (four disks used for data, only one from each RAID-5 can fail)

Wrong, any three disks can fail. If the one RAID has only
one faulty disk, the other RAID can have any number of
faulty disks without loosing data.

>=20
> With RAID-10:
>=20
>   RAID-0 --------> RAID-1 (D0,D0)
>               |--> RAID-1 (D1,D1)
>               |--> RAID-1 (D2,D2)
>               |--> RAID-1 (D3,D3)
>               |--> RAID-1 (D4,D4)
>    (five disks used for data, one from each mirror can fail)
>=20
> With RAID-50:
>=20
>   RAID-0 --------> RAID-5 (D0,D2,D4,D6,P0)
>               |--> RAID-5 (D1,D3,D5,D7,P0)
>=20
>    (two disks wasted only one from each RAID-5 can fail)
>=20
> I believe that I/O performance would be similar for each
> configuration. I'll try to run some tests in the next few days.

I'd guess that depends on the access patterns.

--=20
Kasper Dupont -- der bruger for meget tid p=E5 usenet.
=46or sending spam use mailto:razor-report@daimi.au.dk
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
