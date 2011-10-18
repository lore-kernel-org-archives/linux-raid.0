From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm r/w operations without TEMP_FAILURE_RETRY()
Date: Tue, 18 Oct 2011 20:30:16 +1100
Message-ID: <20111018203016.4536708f@notabene.brown>
References: <2AC2FDB9F3686F48962B2B65E2040CCC3D155FA0@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/hU8=U0b.VnDcmwRkGwIYt3X"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2AC2FDB9F3686F48962B2B65E2040CCC3D155FA0@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Orlowski, Lukasz" <lukasz.orlowski@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/hU8=U0b.VnDcmwRkGwIYt3X
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 18 Oct 2011 10:16:41 +0100 "Orlowski, Lukasz"
<lukasz.orlowski@intel.com> wrote:

> Hi,
>=20
> I was going through mdadm code and got to realize that r/w operations are=
 invoked without TEMP_FAILURE_RETRY() macro, which protects from unexpected=
 operation termination, case SIGINT is thrown. According to my knowledge it=
s POSIX best-practice to call the r/w operations within that macro, lest so=
me sporadic unexpected behaviors occur.
>=20
> Any particular reason for not using it?

I've never heard of TEMP_FAILURE_RETRY.

And having looked in to it I would certainly try to avoid using it.

If the SA_RESTART flag is set with sigaction() then it should be totally
unnecessary.

mdadm doesn't use signals much - only in mdmon.
It probably would make sense to set SA_RESTART when setting up those signal=
s.

But SIGINT is not a problem because mdadm doesn't catch it.  If SIGINT was
set, mdadm would simply exit.  Whatever operation was happening at the time
wouldn't see a TEMP_FAILURE that is worth RETRYing.  Rather the whole proce=
ss
would die.

Thanks,
NeilBrown

--Sig_/hU8=U0b.VnDcmwRkGwIYt3X
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTp1HNjnsnt1WYoG5AQLSKA/9F1wYJUdplDgV78pstunvvoxhPa1Jm1OT
fHWbFr/B0kPWl++e1fdDrjGLgeXWp/nrj5IY8F0RgJRElbo/5XYoFpE2x6790rAx
255XePUW8pUNvTDoDqJTbHx68qlfHGS4wTNTDss3Vdms/kF5Z56z99R0gUuXD9Oi
lQo0GnK3AVbrvrfJMYl5m0smGaFS2NKbK/1qRKxMYPl+bO9+DA6Yywu/opWm6/wo
X5zjl5F981BX9t7r1K+jF7bem0LhSY8KsNIOQI2uJYM2532Q9qq+xLKQtmBc9U3f
Xz8cvwvs5+bWphx81m50Qc9OurG+8iDObmK5kU6rpbNDMJLNO6xH06O67opjXILY
NFs1bglbcJ7/+vrzwy/UqlK3LK27b8ZvyZNuNiN6qHdrIsNhNhG9VW5vDDdsvZO5
KUuuAh14GgsSXImRuULQAS6WOTMhz1wLwgX0DtQTROjbPAnnvoBuJBa/ekdmVjzp
ddLGrCVv4QKHjODjPy/QeAUoqnVqmtGZ13xwOGWoFzipPkF6Aw9LnCsai9om3+pH
kqgNc9vMxlijrp4ZYAYGKzNm6556Hjz010Hm7IcLIJMbG2A4ToJUDWXJb5xfsGPp
0fwsIAEU5vw39vzk3LERG7kdV5hXE/zwIRhlYfLBmk+9nCH9TVfhs8ilngklm0PO
Zua/nzMAQuk=
=RD5l
-----END PGP SIGNATURE-----

--Sig_/hU8=U0b.VnDcmwRkGwIYt3X--
