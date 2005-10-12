From: =?ISO-8859-2?Q?Karsten_R=F6mke?= <biermann-roemke@onlinehome.de>
Subject: Re: big fault :-)
Date: Wed, 12 Oct 2005 16:08:47 +0200
Message-ID: <434D18EF.6060507@onlinehome.de>
References: <434BE7CA.4040707@gmx.de> <Pine.LNX.4.61.0510121136250.27472@desktop.agenda.si>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0510121136250.27472@desktop.agenda.si>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

danci@agenda.si schrieb:
> On Tue, 11 Oct 2005, Karsten R=F6mke wrote:
>=20
>=20
>>Oct 11 18:15:44 hhbgate kernel: end_request: I/O error, dev hda, sect=
or
>>97562304
>>Oct 11 18:15:44 hhbgate kernel: raid1: hda: unrecoverable I/O read er=
ror for
>>block 94440448
>>
>>the recovering prozess starts again and again.
>>
>>Any hints what to do?
>=20
>=20
> Try to save as much data as possible to a new, known good disk - as s=
oon=20
> as possible. You might be lucky and the data is not spread over those=
 bad=20
> sectors...
>=20
> Syncing the array will *always* hit bad sectors and thus will *always=
*=20
> fail.
>=20
>  D.
>=20
>=20
Hi and thanks for all the hints.
The problem is solved in the following way:
- checking all cables and power-connectors -> no success =3D> hda has b=
ad sectors
- booting with a rescue cd based on gentoo
- synching again: it runs with errors but completes
- removing hda3 from the array md1
- check reiserfs on md1 =3D> errors and the hint to use --rebuild-tree
- backup as much as possible from md1 unsing rsync -> works, only a few=
 files can't be
   read
- running reiserfsck on md1 with build-tree =3D> success
- hoping that I get a new hard-disk in short time :-)
Thanks again
     Karsten
By the way: is it possible to make a raid1 array SMALLER?
  I found hints howto get it bigger and the way seems very easy, but
  to shrink it? Reason: When I set up the server I have some people beh=
ind
  me, who mostly say: can't it be faster? - so I accepted the partions =
which are
  recommended by Suse (and which are not really suitable for my needs)


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
