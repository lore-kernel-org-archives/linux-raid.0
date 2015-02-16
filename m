From: NeilBrown <neilb@suse.de>
Subject: Re: re-add POLICY
Date: Mon, 16 Feb 2015 14:28:45 +1100
Message-ID: <20150216142845.0d50207c@notabene.brown>
References: <loom.20150214T222329-324@post.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/Sz6z0mb+zmEHf=YYI_Jp0XP"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20150214T222329-324@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Chris <email.bug@arcor.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Sz6z0mb+zmEHf=YYI_Jp0XP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 14 Feb 2015 21:59:34 +0000 (UTC) Chris <email.bug@arcor.de> wrote:

>=20
> Hi all,
>=20
> I'd like mdadm to automatically attempt to re-sync raid members after they
> where temporarily removed from the system.=20
>=20
> I would have thought "POLICY domain=3Ddefault action=3Dre-add" should all=
ow this,
> and found a prior post that also seemed to want/test that behaviour.
> But as I understand the answer given there
> http://permalink.gmane.org/gmane.linux.raid/47516
> mdadm is expected to exit with an error (not re-add) upon plugging the
> device back in?
>=20
> with:
> mdadm: can only add /dev/loop2 to /dev/md0 as a spare, and force-spare is
> not set.
> mdadm: failed to add /dev/loop2 to existing array /dev/md0: Invalid argum=
ent.
>=20
> For one, I don't understand what the error messages is trying to tell me,=
 about
> an invalid argument that was never supplied to --incremental?
>=20
> But more importantly, how can priorly diconnected devices (marked failed
> with non-future event count) get re-synced automatically when they are=20
> plugged in again?
> (avoiding manual mdadm /dev/mdX --add /dev/sdYZ hassle)
>=20

Does your array have a write-intent bitmap configured?
If it does, then "POLICY action=3Dre-add" really should work.

If it doesn't, then maybe you need "POLICY action=3Dspare".

This isn't the default, because depending on exactly how/why the device
failed, it may not be safe to treat it as a spare.

If the above does not help, please report:
 - kernel version
 - mdadm version
 - "mdadm --examine" output of at least one good drive and one failed drive.

NeilBrown

--Sig_/Sz6z0mb+zmEHf=YYI_Jp0XP
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVOFj7jnsnt1WYoG5AQJRxxAAr2zBA+ArSfScFS/TJW+XKoGq4ILtnJIT
pchHKFIvOLnj31PBp5n/ZLEgWkm8u6YT6KzaCiM+bUDtxcMx4FOyFMYBlHiealYo
aQrCv5T9Dutp5KRSzDxiSC7gzTiCuJWRS/vbBNMGffDJPJyr2peuBqJ9ChXyY2Hw
wYxMiuJ++THFZvx5aQhIWEOEtuIqRHHd+s1VJBuBkSookiPJNhl5M+93NwarrVxr
TtLPMq0C8xOPOElW3ovPRv0+3CQPe/cbVMcO+FU9/GYEhkdb65VtsBcavHmuAnmU
0Yb7zFNbGkoLJVUo3VAjDJjqN0/kUsj6MU7BJKrOlLXPoBLONDSLG51XmnnYYUT0
HL4pp2Ng76/bIbkBmD3fF4uShDxukteOc9TwDQCxbMPgpJiRYMElrxB2nxE4waLn
1/Pgxbugsom5wbdVurBgetSTB8XEv6NazGH24RvdIYNK7cGlnTW2cvgbLEvjcAuY
lkloCaTqv0mXC08DAffxf3EEEpDNNzmkymAEdPNYpehPZ7Ct5GmuozJ+yZUsBrGo
KRkMSJD2bzoMIrPBwvABB5PDuee21h/k86sOiaecxJnySlYRyHgBOX1CWkU1o/WY
Axlra89MjTK9JVqQwQYQwQ5yop8ZOFHYAJz/pHVHeyT/O2/PyK5b3s0/BF4B1fGI
xb2/G3C55Jo=
=mslp
-----END PGP SIGNATURE-----

--Sig_/Sz6z0mb+zmEHf=YYI_Jp0XP--
