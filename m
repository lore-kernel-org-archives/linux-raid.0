From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/2] Fixes for dm-raid faulty device restoration
Date: Thu, 9 May 2013 10:29:47 +1000
Message-ID: <20130509102947.7093ff25@notabene.brown>
References: <1368053697.2890.5.camel@f16>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/OIbXgVvuY.OWF0t98X0aGbI"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1368053697.2890.5.camel@f16>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/OIbXgVvuY.OWF0t98X0aGbI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 08 May 2013 17:54:57 -0500 Jonathan Brassow <jbrassow@redhat.com>
wrote:

> Neil,
>=20
> I've discovered a bug in the recently accepted (for 3.11) patch:
> "[PATCH - v2] DM RAID: Add ability to restore transiently failed devices
> on resume"
>=20
> I have two follow-on patches to fix the issue:
> - [PATCH 1/2] DM RAID:  Break-up untidy function
> - [PATCH 2/2] DM RAID:  Fix raid_resume not reviving failed devices in
> all cases
>=20
> Thanks,
>  brassow

Thanks.  I've applied these.

I also fixed that compiler warning.

NeilBrown

--Sig_/OIbXgVvuY.OWF0t98X0aGbI
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUYrt+znsnt1WYoG5AQLmGA//Q8NjKVIjLkJbdJeHM7/UDqU0Nv/1gBtw
VhENWjGeg/CUfqcoeiL7Semvj9uZWrnT8zPW1hmEGW7njw1A1vlgA8mncdQVyZKr
IaPCywzKYJ7fGb3sPv4AvD+xu4/BfDAxkOgxrE1itB4v8J9UwHHjBcLneX6FAscG
LyJdPyFRCPDPWzgjT7yPmpw9UvyLjzmUDEJHz34mZDsvuCUSWcrtS/F9rjN5hAc1
NboMpedjCaGyblGrura+vV3Q2c3aLcwLXCvz5dKsOniMYnqq5fRDMe8a0L7lWuEW
Q/vCqqayQYV3IYVdjHayxcWHqsUSplUdTQKGsFc66eCZ74sBw+/+fU2iUH2MG+bp
OU0kqUHAFXK1Qd76fzuHQOlCY96YHAUCLRbwS3biiE1de9WuBypvls40dw0fxILy
rOn1k7rBj9gCIKdZAFgP6yYWiKlxy/wTDLJwgeDOs3NjGRzKxBx4+tw3c2SWqmQB
aHf7COvcZzh1evSUHTgdCjKRd0XF8kWEPcoFu3QPHhqo6la31YgCcfbeprUGHZSx
tjkG7ZXR8FBBcIyeNhmMmjet1TVd5At9fyIezEkUBATYtpJPtF5J8b6EI4N3LNOv
DH8rvDr/ok5IlwkfS24O5O5ZsknCe8uq74nB5xFYnAd9bItnz6XlbS4IWvpCCL+r
tIPerlmiXXc=
=WfDB
-----END PGP SIGNATURE-----

--Sig_/OIbXgVvuY.OWF0t98X0aGbI--
