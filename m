From: Andy Smith <andy@strugglers.net>
Subject: Choosing the right RAID 5 chunk size and filesystem
Date: Thu, 9 Dec 2004 21:53:16 +0000
Message-ID: <20041209215316.GX43390@caffreys.strugglers.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BCHI4S30Oax4KlK/"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--BCHI4S30Oax4KlK/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I currently have a freebsd fileserver with just one disk containing
mostly large media files, software mirrors and backups.

Wanting some experience now with linux raid and LVM I'm building a
new system to replace this machine.

I know that RAID 5 chunk size can make a big difference and should
be tuned based on needs, so I was wondering if anyone has any tips
on what I could do to calculate the best chunk size based on my
existing filesystem?

Also, under what circumstances would you recommend using reiserfs
over ext3?  Are there any parameters to mke2fs/mkreiserfs that
should also be tuned based on the existing filesystem?

Thanks,
Andy

--BCHI4S30Oax4KlK/
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (FreeBSD)

iD8DBQFBuMlMIJm2TL8VSQsRAmOCAKCDuGwv/taN4Auv33LlHwDWQS95hwCg5Bn7
KISsN/Q4dv54if3KQ5Jxz2E=
=wZgz
-----END PGP SIGNATURE-----

--BCHI4S30Oax4KlK/--
