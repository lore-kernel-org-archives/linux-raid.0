From: Benjamin Schieder <blindcoder@scavenger.homeip.net>
Subject: Problem with --manage
Date: Mon, 17 Jul 2006 13:26:18 +0200
Message-ID: <20060717112618.GA25114@scavenger.homeip.net>
Reply-To: linux-raid@vger.kernel.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi list.

Just recently I set up a few Arrays over 3 250 GB harddisks like this:

Personalities : [linear] [raid0] [raid1] [raid5] [raid4]=20
md5 : active raid5 hdb8[0] hda8[1] hdc8[2]
      451426304 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
     =20
md4 : active raid5 hdb7[0] hda7[1] hdc7[2]
      13992320 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
     =20
md3 : active raid5 hdb6[2] hdc6[1] hda6[0]
      8000128 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
     =20
md2 : active raid5 hdb5[0] hda5[1] hdc5[2]
      5991936 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
     =20
md1 : active raid5 hdb3[0] hda3[1] hdc3[2]
      5992064 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
     =20
md0 : active raid1 hdb1[0] hdc1[2] hda1[1]
      497856 blocks [3/3] [UUU]
     =20
unused devices: <none>

These are mounted at various parts of the filesystem:

/dev/md/0 on /boot type ext2 (rw,nogrpid)
/dev/md/1 on / type reiserfs (rw)
/dev/md/2 on /var type reiserfs (rw)
/dev/md/3 on /opt type reiserfs (rw)
/dev/md/4 on /usr type reiserfs (rw)
/dev/md/5 on /data type reiserfs (rw)

I'm running the following kernel:
Linux ceres 2.6.16.18-rock #1 SMP PREEMPT Sun Jun 25 10:47:51 CEST 2006 i68=
6 GNU/Linux

and mdadm 2.4.
Now, hdb seems to be broken, even though smart says everything's fine.
After a day or two, hdb would fail:

Jul 16 16:58:41 ceres kernel: raid5: Disk failure on hdb3, disabling device=
=2E Operation continuing on 2 devices
Jul 16 16:58:41 ceres kernel: raid5: Disk failure on hdb5, disabling device=
=2E Operation continuing on 2 devices
Jul 16 16:59:06 ceres kernel: raid5: Disk failure on hdb7, disabling device=
=2E Operation continuing on 2 devices
Jul 16 16:59:37 ceres kernel: raid5: Disk failure on hdb8, disabling device=
=2E Operation continuing on 2 devices
Jul 16 17:02:22 ceres kernel: raid5: Disk failure on hdb6, disabling device=
=2E Operation continuing on 2 devices

Strange enough, this never happens to the raid1 md0 device, so maybe I'm
totally wrong about hdb failing after all.

The problem now is, the machine hangs after the last message and I can only
turn it off by physically removing the power plug.

When I now reboot the machine, `mdadm -A /dev/md[1-5]' will not start the
arrays cleanly. They will all be lacking the hdb device and be 'inactive'.
`mdadm -R' will not start them in this state. According to
`mdadm --manage --help' using `mdadm --manage /dev/md/3 -a /dev/hdb6'
should add /dev/hdb6 to /dev/md/3, but nothing really happens.
After some trying, I realised that `mdadm /dev/md/3 -a /dev/hdb6' actually
works. So where's the problem? The help message? The parameter parsing code?
My understanding?

Btw, I read the diff between mdadm 2.4 and 2.5.2 and couldn't find a hint
that this will work in 2.5.2, but I don't really understand the parsing
that much and could be wrong.


Greetings,
	Benjamin
--=20
#!/bin/sh #!/bin/bash #!/bin/tcsh #!/bin/csh #!/bin/kiss #!/bin/ksh
#!/bin/pdksh #!/usr/bin/perl #!/usr/bin/python #!/bin/zsh #!/bin/ash

Feel at home? Got some of them? Want to show some magic?

	http://shellscripts.org

--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQFEu3Par0OTeImXvg8RApDDAJ9KYe0loNmzwhsakDm2u1P3BpakZQCdEBeF
6X5uOVLCXjfZgN5DKnwktl0=
=g2p4
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--
