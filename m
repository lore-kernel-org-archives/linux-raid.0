From: Michael Ole Olsen <gnu@gmx.net>
Subject: reshape raid5 to raid6
Date: Wed, 24 Jun 2009 12:27:29 +0200
Message-ID: <20090624102729.GY2828@rlogin.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uc35eWnScqDcQrv5"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--uc35eWnScqDcQrv5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Is it possible to reshape my /dev/md0 raid5 into raid6?

I found the following recipe in the docs:
mdadm --create /dev/md0 -l6 -n4 /dev/sdb1 /dev/sdc1 /dev/sdd1 missing

I have 9 disks in my raid5, would i then do:
[1] mdadm --create /dev/md0 -l6 -n10 /dev/sda /dev/sdb ... missing

i.e. only the first 9 drives and then hot add a new device to get it to
reshape and add the extra parity to all drives?

mdadm --add /dev/md0 /dev/sdk ?

I would guess  command [1] would give problems as md0 is an active array
will it work if i --stop the array first so that i can reshape to raid6?

I couldn't really find much information on this, some say it is impossible
without recreating the array? (So i ask here first before i try, as I dont
want to risk my data, even though I have backups of the important
data)

Any advice would be nice

/Michael Ole Olsen

--uc35eWnScqDcQrv5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQIcBAEBAgAGBQJKQf+QAAoJECXlragqp/ZI3UkQAIus04vyFtFhKC2U7e5PO4g3
V7bVWgO5fUrO+p4Xwssw1yz2teoMhFnM2Od0b2cbBQlnCW09Pe4qaF5Azc8t0yHi
yjWCpoTWcwiYoYCIRfekjQcazb52tKsi1ZPHU6FQUxcQ/H5y+fWAd4bbwAzQasr9
aEURn+ASecXRTgjDlzabVtxQapiUNoIxmQPvKPP3FUqtkC47C4ADR4hQeVKU3Jh0
eFtGft5Jmeml1RReITq/fkQyEHOuptDEQq2TXORX258UsR7u/ZpSOFQij9+Ytgxc
vPtbjMaKm3nhqVxz4XOhISz5KcEjgEGI+UdIUiT3JciBGtxv/ug5H6WyO9syZZ5z
UZXJ+9MtRS251Jg3zR7QkXZvqMshdfBJEIBWgXr6QmTGLjwfZwV6i2/8AvcVR7V6
LtMUdZ3rH5/+Ep0FShRXtT1sUlOcGUGB09ubdxPpBAhxWkFZMw6G9+Fhg3ynqsq6
HrkZ0wuoGDww5Ks77XYa/I6Zecoq9g7UxqMqFem7U0oQz5Wz3pIuEpMT7zfhHQ9/
6thNJJx+fwxcQmbfUdh2HT60ALlweXNAshaWh4tnKQtQeo0eGhg7jWbZqiNnk+ZA
KIx3/E8z/dZIUwsY8Zccacy798AUQTebOiS99e+mGy+FdtGXpcucDItTGsSe7wI/
7xHi7GPROC6EmtcWA6Ul
=kBNa
-----END PGP SIGNATURE-----

--uc35eWnScqDcQrv5--
