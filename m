From: martin f krafft <madduck@madduck.net>
Subject: Safely swapping a disk in a RAID456
Date: Fri, 30 Sep 2011 17:42:17 +0200
Message-ID: <20110930154217.GA11732@albatross.gern.madduck.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Dear list,

I would like to swap out a drive in a RAID6 (4 drives), but ideally
without letting the RAID degrade. I was thinking that it should be
possible to declare the new disk a copy of the old one, let it sync,
then remove the old one and let the new one take over, but MD does
not seem to support that.

Next, I thought that I could add the new disk as a spare, grow the
array to 5 disks, and somehow shrink it back to 4 again, but of
course that does not work either, since 4=E2=86=925 is a reshape, and there
seems to be no way to control which disk to remove from the RAID6 on
a shrink (making it a spare), without degrading the array in the
process.

Does anyone have any ideas? This should not be so hard=E2=80=A6

--=20
martin | http://madduck.net/ | http://two.sentenc.es/
=20
"courage is not the absence of fear, but the decision
 that something else is more important than fear."
                                                  -- ambrose redmoon
=20
spamtraps: madduck.bogus@madduck.net

--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/sig-policy/999bbcc4/current)

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQLvBAEBCgDZBQJOheNZwBEaaHR0cDovL21hcnRpbi1rcmFmZnQubmV0L2dwZy9z
aWctcG9saWN5LzU1Yzk4ODJkOTk5YmJjYzQvMjAxMTAxMjQxMTI1P3NoYTUxMnN1
bT0xY2FkOTZmZDI3ZDMyMzNmNTNlMjI4NDk1MzM2NDgxMDdlNWVlOGQ1YmU2NTUy
NTFkNzRjOGYxYzVjM2JjNDJmMjMwNGZhNTE1MTUwZjdiZDRkZDA1ZTk4MTk5MjRm
MDQ5NTEzZWU5OTYyY2E3MTcwOWY4MWQ5NDUxNTg1MmJkOAAKCRBVyYgtmZu8xFhV
D/9bGaPsQVZzcuSnQDwq21EEyKc1ENoayS6Ph4K3ae+caMSf5tAD3LbCJExshWO2
YYjBN32bAJ7ElFWWaLjcET63A3XoSD6FRf/2q439Gd4Qko9H0xbwdmiYpGkFaAnK
SrpzBuUESduY76LU90FJMiVFuJyBPrSWDy1KSMFiqA6ztrqLxBqyxzNK211Fno77
/kK+yQT6kxJN7xp/VzoDPltc8AsrIcfbR+lTPnFBS5Oya01fcVvxbb+IMTEhtvSO
BmtOBD8dbcTC1tynJrLu7AUlqOHwgOPza/W51bg3rZR+5e9QGZyKE5kJl/Ztw5xS
HS/APItbTO3AGzAXjEB6LPdATAZNC/LsJmpGu8Fkcqmx4uPGQPGy9c/8ye/xWbjP
VMQyZuAOl0c2fb6g7+WyQsN+N6XNj7Nr2XGxg/nIBDZQ8ehg5cmPukv5JzEuFhoX
8tjX+XaUMuA1A4wciWGmnFaqaD5Srndi6K81+PuWMJeBe9DAclCdHa4NxIl8clNQ
rf7QTLN/5Gj0XSSOP5z2ecFpGOWmfZDGlHh1tFt72MkcHwajxiKJvkmSWbrqTxRx
eg8wwkN3dijYbvAT+K+OXE7nIPL4oS9Pqt0okiSq7xUx8BOedBRJNA4m/AIAINd0
q7U/1Hj2mk2XadVx/EKPO+ft0UVrk2h35+aC1/ETn6kv3w==
=s8sw
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--

