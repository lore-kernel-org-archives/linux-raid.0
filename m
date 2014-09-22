From: Martin Senebald <martin@senebald.de>
Subject: Re: raid5 missing disks during chunk size grow
Date: Mon, 22 Sep 2014 13:55:24 +0200
Message-ID: <719BBDB5-4E57-49D9-AFA2-0552141D7C41@senebald.de>
References: <374D34B3-E7F5-48AD-9A22-23C76AA0A60F@senebald.de> <alpine.DEB.2.02.1409221342090.14735@uplift.swm.pp.se>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1409221342090.14735@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am 22.09.2014 um 13:44 schrieb Mikael Abrahamsson <swmike@swm.pp.se>:

> On Mon, 22 Sep 2014, Martin Senebald wrote:
>=20
>> My idea was, first bringing back the disks in the array then continu=
e the grow (using the backup file)
>> add / re-add disk was not working, so i assumed recreate the array w=
ith =97assume-clean would bring me closer.
>=20
> Was this an idea you had that you didn't do, or did you actually exec=
ute on it?

I did ..=20

>=20
>> What would be the best way to tackle this problem?
>=20
> Send mdadm --examine from all 6 component drives to the list and let'=
s take it from there.

the current state of the disks:

https://gist.github.com/daquan/94239614fc3b67789c9a#file-current-state

the state before the =97create=20

https://gist.github.com/daquan/94239614fc3b67789c9a#file-before-create-=
assume-clean


> Under no circumstances do --create on the components.

that sounds not so promising anymore :-/

>=20
> What kernel version and mdadm version do you have?
>=20
> --=20
> Mikael Abrahamsson    email: swmike@swm.pp.se
>=20


BR Martin

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
