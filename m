From: =?UTF-8?Q?Micha=C5=82?= Sawicz <michal@sawicz.net>
Subject: Re: RAID5 broke during reshape...
Date: Sat, 02 Jan 2010 19:26:39 +0100
Message-ID: <1262456799.10047.33.camel@michal-laptop.sawicz.net>
References: <1262451347.10047.14.camel@michal-laptop.sawicz.net>
	 <70ed7c3e1001020933x7ac028a5n42af404eb5e23e30@mail.gmail.com>
	 <1262454630.10047.23.camel@michal-laptop.sawicz.net>
	 <70ed7c3e1001021001g7e7a17b6ufb431ddfd563eae6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-+gsYQSj/A1EEsMnJHKgD"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e1001021001g7e7a17b6ufb431ddfd563eae6@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-+gsYQSj/A1EEsMnJHKgD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dnia 2010-01-02, sob o godzinie 21:01 +0300, Majed B. pisze:
> The output of mdadm -E is incomplete. Please make sure the whole
> output is included, including the table of devices.

Unfortunately that's all I get from mdadm :/ On another array it does
report the device table.

> All your disks report a lot of ECC errors: 195 Hardware_ECC_Recovered
> 0x001a   100   100   000    Old_age   Always       -       139150990
>=20
> You may wanna check your cables and/or RAM (RAM can be tested with a
> free tool called memtest86). Also, if you don't have smartmontools (or
> smartd to be specific) configured to run periodical polling and
> testing, you may wanna run: smartctl -t offline /dev/sdx for all disks
> and wait till it's finished, then you should be able to see whether
> you have bad sectors or not.

Will do the memtest after the self tests are done.

> Have you tried force-assembling the array again?
> mdadm -Af /dev/md0

media ~ # mdadm -Af /dev/md5
mdadm: /dev/md5 assembled from 2 drives and 3 spares - not enough to
start the array.

> P.S.: Make sure you reply to all not just me. Re-send the email with
> the files to the mailing list so that others can look at them as well
> :)=20

Of course, didn't notice no Reply-To was set.

--=20
Regards
Micha=C5=82 (Saviq) Sawicz

--=-+gsYQSj/A1EEsMnJHKgD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: To jest =?UTF-8?Q?cz=C4=99=C5=9B=C4=87?=
 =?UTF-8?Q?_wiadomo=C5=9Bci?= podpisana cyfrowo

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAks/j98ACgkQzQlUjpZYlbce3gCgha3j4iHKVs9HnQORvcj4l5Z/
oT8AnRDzlpVcENeMGxSGqXFGJXiKW5zH
=U+/m
-----END PGP SIGNATURE-----

--=-+gsYQSj/A1EEsMnJHKgD--

