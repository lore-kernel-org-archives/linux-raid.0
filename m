From: NeilBrown <neilb@suse.de>
Subject: ANNOUNCE: mdadm 3.3.1 - A tool for managing md Soft RAID under
 Linux
Date: Thu, 5 Jun 2014 16:47:56 +1000
Message-ID: <20140605164756.4a74b4bf@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_//Ay50u8DOMfSBM_n.ruOReZ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_//Ay50u8DOMfSBM_n.ruOReZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable



I am pleased to announce the availability of
   mdadm version 3.3.1

It is available at the usual places:
   http://www.kernel.org/pub/linux/utils/raid/mdadm/
and via git at
   git://github.com/neilbrown/mdadm
   git://neil.brown.name/mdadm
   http://git.neil.brown.name/git/mdadm.git

The main changes are:
 - lots of work on "DDF" support.  Hopefully it will be more stable
   now.  Bug reports are always welcome.
 - improved interactions with 'systemd'.  Where possible, background
   tasks are run from systemd (if it is present) rather then forking
   disassociationg from the session.  This is important because udev
   doesn't really let you disassociate.

though there are a number of other little bug fixes too.

NeilBrown 5th June 2014

--Sig_//Ay50u8DOMfSBM_n.ruOReZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU5ASnDnsnt1WYoG5AQJg4A//eV5Dp+D50dqh5AU5aUf48SR1S+Vhsxm1
gIWNQyJOA3NmPQY21WKIhvAZshiEphSZ7o0YxUXEWrhDhxR5rBUmrh74Gwh5vupQ
ykMjf+BURvZT7D9xfv8FazF1q8lzRiXI0xCzMiMphpHhn0g5Q3VI4JrgLx2Wp6Cz
ZOS8llGlK+9NSefGFB8r/r8xqkkNiWP/CykQ2doj0P799jDKicIDCLb8yvhrXLFY
ugSYzKaDoMXCZt0468T/dv6zG4jYNYtQOK6kFWeT7OHaAJXZ10dgKrpWMKy3+a0g
DV7m/Z/+BtqxvukWJK7nNMY/mgbdDKTOzXe34hB6dnoZ8qnTni/6kpQD1HjnY39p
EmMo1HjN4kjbHTxZQIhiEhqoGe0VIO7ZKqps81gQf7NdKPT7Vuv8NQiPWgd+Q42M
MAUtWw8d2ikjBvh8syJByqLvD/ctgwuE31EU77of4wbK0yLPgc9NjOWupFXkIzSd
ootgxO2qiL62a7nlgY7cAaRlJLwf2NcgthsWe5Q30fLH4OPFACBK4IkHArf7tEEf
9zP1h7Rn2G37VA41yV1x/Ab64gjycTqzL5TYxPUI336JhSEOL4xND5X7wDMb1YAG
6MYehJ/wl3l4w79N1T3kiQy8G6h79GvtxZy0c4BU1N2uv5iCQlWZjARNqzQO+lx5
OHWGvd4SLfk=
=hhh4
-----END PGP SIGNATURE-----

--Sig_//Ay50u8DOMfSBM_n.ruOReZ--
