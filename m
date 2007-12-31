From: Nagilum <nagilum@nagilum.org>
Subject: PROBLEM: RAID5 reshape data corruption
Date: Mon, 31 Dec 2007 13:04:20 +0100
Message-ID: <20071231130420.kivbehcc0o0wk008@cakebox.homeunix.net>
Mime-Version: 1.0
Content-Type: multipart/signed;
	boundary="=_4qe2wzfgfj40";
	protocol="application/pgp-signature";
	micalg="pgp-sha1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-raid.ids

This message is in MIME format and has been PGP signed.

--=_4qe2wzfgfj40
Content-Type: text/plain;
	charset=ISO-8859-2;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Ok, since my previous thread didn't seem to attract much attention,
let me try again.
An interrupted RAID5 reshape will cause the md device in question to
contain one corrupt chunk per stripe if resumed in the wrong manner.
A testcase can be found at http://www.nagilum.de/md/ .
The first testcase can be initialized with "start.sh" the real test
can then be run with "test.sh". The first testcase also uses dm-crypt
and xfs to show the corruption.
The second testcase uses nothing but mdadm and "testpat" - a small
program to write and verify a simple testpattern designed to find
block data corruptions. Use "v2_start.sh && v2_test.sh" to run.
At the end it will point out all the wrong bytes on the md device.
I'm not just interested in a simple behaviour fix I'm also interested
in what actually happens and if possible a repair program for that
kind of data corruption.
The bug is architectural agnostic. I first came across it using =20
2.6.23.8 on amd64 but I verified it on 2.6.23.[8-12] and =20
2.6.24-rc[5,6] on ppc. Always using mdadm 2.6.4.
The situation the bug first showed up was as follows:
1. A RAID5 reshape from 5->6 device was started.
2. After about 4% one disk failed, the machine appeared unresponsive =20
and was rebooted.
3. A spare disk was added to the array.
4. The bad drive was re-added to the array in a different bay and the =20
reshape resumed.
5. The drive failed again but the reshape continued.
6. The reshaped finished and after that the resync. The data after at =20
about 4% on the md device is broken as described above.

Kind regards,
Alex.


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
#    _  __          _ __     http://www.nagilum.org/ \n icq://69646724 #
#   / |/ /__ ____ _(_) /_ ____ _  nagilum@nagilum.org \n +491776461165 #
#  /    / _ `/ _ `/ / / // /  ' \  Amiga (68k/PPC): AOS/NetBSD/Linux   #
# /_/|_/\_,_/\_, /_/_/\_,_/_/_/_/   Mac (PPC): MacOS-X / NetBSD /Linux #
#           /___/     x86: FreeBSD/Linux/Solaris/Win2k  ARM9: EPOC EV6 #
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D




----------------------------------------------------------------
cakebox.homeunix.net - all the machine one needs..


--=_4qe2wzfgfj40
Content-Type: application/pgp-signature
Content-Description: PGP Digital Signature
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (FreeBSD)

iD8DBQBHeNrDAKWN2UY+sLwRAhDwAJ0aKgBss1xLHBvDOXYEoMqv8zpmKACbBmvk
h0d8bwc5y9vQinWdF8Aqklk=
=RmXO
-----END PGP SIGNATURE-----

--=_4qe2wzfgfj40--
