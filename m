From: NeilBrown <neilb@suse.de>
Subject: Re: split brain mode after reboot
Date: Wed, 21 Nov 2012 08:22:52 +1100
Message-ID: <20121121082252.3a9bb7db@notabene.brown>
References: <50AB8EED.4000005@aei.mpg.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/JccA+KBrVBF4T76CJErKEl+"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50AB8EED.4000005@aei.mpg.de>
Sender: linux-raid-owner@vger.kernel.org
To: Carsten Aulbert <Carsten.Aulbert@aei.mpg.de>
Cc: linux-raid@vger.kernel.org, "gerrit.kuehn@aei.mpg.de" <gerrit.kuehn@aei.mpg.de>
List-Id: linux-raid.ids

--Sig_/JccA+KBrVBF4T76CJErKEl+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 20 Nov 2012 15:08:45 +0100 Carsten Aulbert
<Carsten.Aulbert@aei.mpg.de> wrote:

> Hi all
>=20
> a colleague of mine created a raid 1 on a fairly recent machine
>=20
> Kernel 3.5.0-sabayon
>=20
> mdadm - v3.2.3 - 23rd December 2011
>=20
> During operation sda seemed to have been disconnected by the
> system/motherboard/whatever but this was not detected before a reboot
> was done, after the reboot, sda re-appeared but of course with a much
> older version of the mirror:
>=20
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]
> [raid4] [multipath] [faulty]
> md126 : active raid1 sdb1[1]
>       4194240 blocks [2/1] [_U]
>=20
> md127 : active raid1 sdb3[1]
>       235808704 blocks [2/1] [_U]
>=20
> md0 : active raid1 sda1[0]
>       4194240 blocks [2/1] [U_]
>=20
> md1 : active raid0 sda2[0] sdb2[1]
>       8387584 blocks 512k chunks
>=20
> md2 : active raid1 sda3[0]
>       235808704 blocks [2/1] [U_]
>=20
> unused devices: <none>
>=20
> As no vital information were on these disks, my question for the list is
> just if this is an expected/wanted behavior after such an event and what
> one could do to prevent this (besides monitoring via mdadm).
>=20

Expected - probably.
Wanted - no.

I think one half gets assembled by "mdadm --incremental" run from udev, and
the other by a subsequence "mdadm -As" or similar.

mdadm-3.3, which is still under development, has a fix for this so that
--incremental and --assemble don't trip over each other.

http://git.neil.brown.name/?p=3Dmdadm.git;a=3Dcommitdiff;h=3D0431869cec4c67=
3309d9aa

NeilBrown

--Sig_/JccA+KBrVBF4T76CJErKEl+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUKv0rDnsnt1WYoG5AQKcDQ/7BMaFqvD1eZOkHQSKm/27XB0wvlJ/AhAT
5HwuKcaXqa2Vze6f6mA3AjBwvP1vnuPIPnjt7A/PnD2fZLX256+sglrSfplo9Cv9
QzwtAahPo8o/FWKxXZTDMoCpaMOae7a+/fmHHPjJpeMseR+g4ND9RObdndpCU7Cu
Ey5qfLfiyyxnmVfzFlAi3Yryusen32eBVWGcn/H+lo7NIv9qE5C7s2vgyVUy9r/x
cu8849CbZXjCv9Nsmyq+qSxovwzYfDxjLeU0J97cYxewYm93BKaxYz46Okty2z7y
5oibAG/VrVMaNQfXIySvma7eL2CgWTELyBRW6cxrqt+jje9Yf/WUwK6DwDI41/LK
CPt1YJ3kDZae/RTA7X8z1RoMs0Y7mKlkN3p3SFdBPgBHy1Im470XC92y/WLEpdyq
FY913Zv9h1qH21lf91PkxlUG5d683SM3g9byUPU+wX1Y7rWt62o8f+ZMrG/o/nue
wq0djGG5R/alVK+YyHY6Bfrle6MDuXxM3kA3QLq35KBE8BeAf3Yn/ifCCfF1qGxW
4aZNsRlVv3U5en+eTr2ww650+IEzzU13+B0OVTpQWvhiXuQCfEA/ZBVP3OZ7tYbf
glfmnJ/UnBHIwr02gKZsdnDIdOYOYe/H9tm61dRnvlMKB/Ra0nV8SmXgOrSBvmpt
f142XZpG4Kw=
=uOxP
-----END PGP SIGNATURE-----

--Sig_/JccA+KBrVBF4T76CJErKEl+--
