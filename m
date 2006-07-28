From: Sander Smeenk <ssmeenk@freshdot.net>
Subject: Weird blocks at fsync() calls using md
Date: Fri, 28 Jul 2006 12:16:45 +0200
Message-ID: <20060728101645.GA32686@freshdot.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello list,

I've recently subscribed to this list as i'm facing a little problem
using md v0.90.3 (bitmap v4.39) on Linux 2.6.17.1, Debian 'sid', mdadm
2.4.1...

While the system is under heavy disk IO, calls to fsync() made by vim
(for example) block for a LONG time. Like 30 seconds or more. I'm not
sure if it also blocks other IO during that fsync() wait, but it's nasty
enough to have your :w action take 30+ secs...

My system is running in RAID1 on two SCSI U320 disks:
Personalities : [raid1]=20
md0 : active raid1 sdb[0] sdc[1]
      71819392 blocks [2/2] [UU]

Some guy on IRC told me he had the same problem once, and it was related
to some whacky locking mechanism used in the software raid code? I'd
really like to know if this is a common problem and what i can do about
it.

Any ideas are welcomed!

Thanks alot,
Sander Smeenk.
--=20
| Show me a piano falling down a mine shaft and I'll show you A-flat miner.
| 1024D/08CEC94D - 34B3 3314 B146 E13C 70C8  9BDB D463 7E41 08CE C94D

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQFEyeQN1GN+QQjOyU0RAj0TAJ4xa3x1P9K1yX0WnOpS/qjjjn/58ACeKO9N
Q1jGcGqeoM0S5lL38WvRN5A=
=84Gb
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
