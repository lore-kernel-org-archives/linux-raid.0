From: martin f krafft <madduck@madduck.net>
Subject: mdadm 2.6.3 segfaults on assembly (v1 superblocks)
Date: Fri, 7 Sep 2007 10:09:01 +0200
Message-ID: <20070907080901.GA16012@piper.oerlikon.madduck.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

preparing the Debian package for mdadm 2.6.3, I found a segfault in
mdadm/Assemble.c:254, in the line:

  } else if (tst->ss->load_super(tst,dfd, &super, NULL)) {

the problem is that tst->ss is NULL, due to reasons I have not yet
uncovered. The segfault happens only in the second iteration of the
for loop at line 212 and the load_super1 call, caused by the above
load_super in the first iteration, causes tst->ss to be set to NULL.

This happens in the first recursion (load_super1 calls itself), at
which point the

  if (dsize < 24) {

check in super1.c:1033 fails and thus returns 1, which causes the
outer load_super1 function to return 1 after setting st->ss to NULL
in line super1.c:1013.

This all happens while the dfd variable in Assemble.c:254 has value
8, and assuming this is a file descriptor, then lsof says:

  mdadm     25664     root    8r      BLK       22,3 2806 /dev/hdc3

/dev/hdc3 is an extended partition on the disk.

/dev/hdc1   *           1           8       64228+  83  Linux
/dev/hdc2               9         132      996030   82  Linux swap / Solaris
/dev/hdc3             133       30401   243135742+   5  Extended
/dev/hdc5             133         256      995998+  83  Linux
/dev/hdc6             257         505     2000061   83  Linux
/dev/hdc7             506       28347   223640833+  83  Linux
/dev/hdc8           28348       30339    16000708+  83  Linux
/dev/hdc9           30340       30401      497983+  83  Linux

I am failing to reproduce this on v0.9 superblock systems.

Neil, could this be a bug?

--=20
martin;              (greetings from the heart of the sun.)
  \____ echo mailto: !#^."<*>"|tr "<*> mailto:" net@madduck
=20
"nothing can cure the soul but the senses,
 just as nothing can cure the senses but the soul."
                                                        -- oscar wilde
=20
spamtraps: madduck.bogus@madduck.net

--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFG4QcdIgvIgzMMSnURAkoLAJ0XQy+tMJQJelIZt7qkpYlH1N67fQCfWGm1
Zh67SP76j1Uu5cUkz5BcHIQ=
=jIG/
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
