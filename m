From: Martin Senebald <martin@senebald.de>
Subject: Re: raid5 missing disks during chunk size grow
Date: Mon, 22 Sep 2014 14:50:05 +0200
Message-ID: <2146127B-50ED-46E6-AE63-BAC9DA35DBDC@senebald.de>
References: <374D34B3-E7F5-48AD-9A22-23C76AA0A60F@senebald.de> <alpine.DEB.2.02.1409221342090.14735@uplift.swm.pp.se> <719BBDB5-4E57-49D9-AFA2-0552141D7C41@senebald.de> <alpine.DEB.2.02.1409221400070.14735@uplift.swm.pp.se>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: multipart/signed; boundary="Apple-Mail=_CF34F30B-50A3-436F-B4A9-12B01B829F14"; protocol="application/pgp-signature"; micalg=pgp-sha512
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1409221400070.14735@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--Apple-Mail=_CF34F30B-50A3-436F-B4A9-12B01B829F14
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252


Am 22.09.2014 um 14:02 schrieb Mikael Abrahamsson <swmike@swm.pp.se>:

> On Mon, 22 Sep 2014, Martin Senebald wrote:
>=20
>>> Was this an idea you had that you didn't do, or did you actually execut=
e on it?
>>=20
>> I did ..
>=20
> What made you think that was a good idea?

Good question, i can=92t point to a specific source. I guess this was more =
the "out of options=93 decision that time. (at least it looked that way)=20

> I have been re-writing text on the linux-raid wiki to discourage people f=
rom doing that. Wherefrom did you get the information?

And obviously i didn=92t find that either. I just quickly looked over it an=
d didn=92t find it.=20

>=20
>> the state before the =97create
>>=20
>> https://gist.github.com/daquan/94239614fc3b67789c9a#file-before-create-a=
ssume-clean
>=20
> I have no idea how to get you from there.

That was maybe what lead me to believe =97create might help. I understand t=
hat recreating the array was maybe the worst thing (destroying the reshape =
state information of the array)=20
but generally speaking i think the data itself is not yet lost. The positio=
ns of the reshape is available for each disk(what i see from the examine). =
The Data on the md2 didn=92t change while reshape was ongoing (is a lvm pvd=
isk and lvm was not active). But i have no clue how to bring the raid to th=
e state of grow when the raid failed.  I don=92t understand to much how the=
 grow process for chunk size works.=20

>=20
>>> Under no circumstances do --create on the components.
>>=20
>> that sounds not so promising anymore :-/
>=20
> Indeed.
>>>=20
>>> What kernel version and mdadm version do you have?
>=20
> Why didn't you answer this crucial question?

I just forgot :)=20

	Debian 3.2.60-1+deb7u3 x86_64

>=20
> --=20
> Mikael Abrahamsson    email: swmike@swm.pp.se
>=20






--Apple-Mail=_CF34F30B-50A3-436F-B4A9-12B01B829F14
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQIcBAEBCgAGBQJUIBr+AAoJEHcuczTXL/sp0J0P/AhGrSa3REIedUiC0F5RhKpT
GBZupI4sUaMRMTJeTZDUj5Pp2GqkVuweqjUGx/tv/qECl2vy5xEkzFhk98jkOQOi
af5tD6vHMSCs4XrSoh5UtbE2gWxmXo4FbAC0jQAa0BUVO6HbdpFye+uniaoWkx5c
SEsoCGZrTOQOo+LCtUcjmQw1/iuB2cynIfx/H+JUOz5N3K1Y14c4uY8HoWLKrRt6
FbomdRoGtd/CDlErGmEVKLNgv9piGPTeIrWCtyiwt4+mtMqJ3RvkCsygw066rdVq
/gWMu6ExQEjjYVOdl65W2fKBnel7FZ9pOMcvEQMHSQUTa49RmjLIPNb002B4wPso
7/LqMKBSExspVMvtdTnv8sx+KtfD1VQaI+HIWxdoIvSTkfsLTVti1PIyXOg9tpGK
NQ1qGsA442lOcZh98JaGvMQRLrv4z5O8nNhuPFZj3y+Rz6W3iGnL8dd2v9yvfn42
I8+K4Sv4naW0hamOR0frojhwFWJep1JOuhMj0ICYV7jp/qXOj/iTwuSgOHA7LqEr
GJryGkxNvrJb9sj14G0picNtvv74dnjzS8M2twQCtL9rcBRpIkdXNM4Cr2AokA/3
/cOFkT+Z8gWP+SrSLojH5lrEn6gO+23U6WQdBj/3lWaxrtKHVNm8kgRFVgu71ftD
2cW26Sp0w1C/QLo1NGbc
=8DLa
-----END PGP SIGNATURE-----

--Apple-Mail=_CF34F30B-50A3-436F-B4A9-12B01B829F14--

