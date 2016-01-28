From: NeilBrown <neilb@suse.com>
Subject: ANNOUNCE: mdadm 3.4 - A tool for managing md Soft RAID under Linux
Date: Thu, 28 Jan 2016 17:18:36 +1100
Message-ID: <87oac61b2b.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain


I am pleased to announce the availability of
   mdadm version 3.4

It is available at the usual places:
   http://www.kernel.org/pub/linux/utils/raid/mdadm/
and via git at
   git://github.com/neilbrown/mdadm
   git://neil.brown.name/mdadm
   http://git.neil.brown.name/git/mdadm

The new second-level version number reflects significant new
functionality, particular support for journalled RAID5/6 and clustered
RAID1.  This new support is probably still buggy.  Please report bugs.

There are also a number of fixes for Intel's IMSM metadata support,
and an assortment of minor bug fixes.

I plan for this to be the last release of mdadm that I provide as I am
retiring from MD and mdadm maintenance.  Jes Sorensen has volunteered
to oversee mdadm for the next while.  Thanks Jes!

NeilBrown 28th January 2016

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWqbK8AAoJEDnsnt1WYoG5HRIP/jdtVMLp144N2zrVGNiF1r7n
bJCjK+MNQ5HFXK41kwhgSkHsIW/wltniwg7D/f2nwkmgFKfnW0+5SlBxLkmfWNdD
2jZmqBcR5cQid88b5IkdyFNEy+hvbssQoBxomOILowxFqOUXjnFrKA9MI+fzJbVc
v/IlyWCGHWbJyp9RvNNVO/QzOk+LlNAp5zFrMffjMX86WrGdhWFD1xb3VxcnQScQ
4Pwkd3KGhdMEamiS7Qk3p2stv8dAznxgYf97xnhtm3hESrfNMX01ymiG9JU3I1ET
oGUsi28yMCjN58pHufbvCnmWr/tT7DItsHzWfDEnfh99s+VUM+QwpIeAWU2SSxdV
Brnvs8okH2y5ZoGP0+DPbehPHFvaqsKhYA3yW3vTlc/QYsF7ufWlEN8UAEDohxNc
K8ettW53MhmB+tQB4rEDskIn1i1X0H0r09EqzzoS5zfrL8Nby9+U7scn88VBVEPI
1EzyE8W0+2NBfmwSI2xTy5NNqYFd+ATOwXc5Rp0PpcRIGAnBvmexl2MJVU4zE2Z+
hdbpHtpJ7Vecj/XP/M/1YAYqNaMfIc1CoNrSYgd+vLefxpPuGHP8UeEZIRG1aB+4
1tP7wW13MuXjNiCrFi7/DE3Sp68bkIrMWSOJppsfOMok2Kd5N8qxVxEgf2iv71M7
A7E7LT6RoQ3BHEo2+esL
=qZrt
-----END PGP SIGNATURE-----
--=-=-=--
