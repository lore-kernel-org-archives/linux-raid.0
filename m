From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm --fail requires writeable drive.
Date: Fri, 15 Nov 2013 15:46:27 +1100
Message-ID: <20131115154627.14364eb3@notabene.brown>
References: <52836DD1.8080605@mpstor.com>
	<20131114114449.27f3c746@notabene.brown>
	<5285094D.9070904@mpstor.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/YvzcpMJ/aj3q9Xgj5TUZHrh"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5285094D.9070904@mpstor.com>
Sender: linux-raid-owner@vger.kernel.org
To: Benjamin ESTRABAUD <be@mpstor.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/YvzcpMJ/aj3q9Xgj5TUZHrh
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 14 Nov 2013 17:33:01 +0000 Benjamin ESTRABAUD <be@mpstor.com> wrote:

> Hi Neil,
>=20
> This does work but I was looking for a way to explicitely set a=20
> particular device as Failed (I want to process devices one by one).
>=20
> But right now I was reading from the array to force it detecting the=20
> failure as opposed to using "detached" which orders of magnitude better.
>=20
> Thanks for the tip, I'll use that for now.

If you really want to just fail one of them you can used the "kernel name"
like "sda1".
If you
   ls -d /sys/block/mdXX/md/dev-*

you will see the devices that are though to be part of the array.  The part
of the name after "dev-" is the "kernel name".
"mdadm /dev/mdXX --fail" will accept a "kernel name" and will mark just that
device as faulty.

NeilBrown


--Sig_/YvzcpMJ/aj3q9Xgj5TUZHrh
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUoWnIznsnt1WYoG5AQIGwQ//cYmIaZbk63ThzQXHvbQXeln8o7tmRLQg
NGaUiWm0oDQRrhjQ5hBTL+CgyxFq4RTof3hvfuLXdbt147MbtD6SJSP8ksqk5AWm
DpoLAfiLs2nxn8y97CaqkISrSjqceSsWE7UlftJKd+awQt1Z+HwyzTphF62hzeuk
awmunVO1tzG3QkpIHMMObf25/E33fAH2JjAiSQajnP3CAnW28ITkoQM1B64Essd0
7e1K8b3V7M6V1VvijwHeaelGx1Q9aiyU2293AJ65rFGS87xqkTiGcYwqu+t03JBa
MS83tC9MheNlSVtHmMxPqiQnoYAY9x6ZPyUjnvun2SdZVe32vcVfjC4U1K9+xbe0
q5FKEX+UEUNJUI70BSVT9b4SVrahIziCgGP0G48kXWULmfh+362Jkpf7eghrgyqi
0T7XCk+vf89qKBhvzPky3DWx/D+iXgglgmI5g7F8MP82Ldi3cOEwm2MlmlTlDwmQ
XkaRe4BKlRetgOGVQfOAfEzXKnRsqMe8+mTz/Ku1M2Bbh8dWVy8Ix+YmVdkcL2Vf
leGmoOm4yPGcDlBIuvekUFNPoi3R9GwqU2dhQFl/01lStOU70LfE/92O3WhqTqV7
vNG1sgchEHepWFUVcVX7V95jKyR2+CcgloypG4LpxZsxvoStYUZOkddnEg+NumMo
wuclxpHJQ+k=
=7W3P
-----END PGP SIGNATURE-----

--Sig_/YvzcpMJ/aj3q9Xgj5TUZHrh--
