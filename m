From: Benjamin Schieder <blindcoder@scavenger.homeip.net>
Subject: Nice Sideeffect of growing (was: RAID5 Resize Experience)
Date: Wed, 24 Jan 2007 11:02:56 +0100
Message-ID: <20070124100256.GA11354@scavenger.homeip.net>
References: <20070120085621.GA5028@scavenger.homeip.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070120085621.GA5028@scavenger.homeip.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 20.01.2007 09:56:21, Benjamin Schieder wrote:
> md3 : active raid5 hda6[0] hdf6[3] hdb6[2] hdc6[1]
>       12000192 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]

I just noticed something.

Before I grew the md3 array, it did NOT assemble with
	# mdadm -As --auto=3Dyes --symlink=3Dyes
It also didn't appear in
	# mdadm -Ebsc partitions
I could - however - assembly it manually:
	# mdadm -A /dev/md/3 /dev/hd[abc]6 --auto=3Dmd --symlink=3Dyes

After the resize, md3 is recognized again by the first two commands.


Greetings,
	Benjamin
--=20
Benjamin 'blindCoder' Schieder
Registered Linux User #289529: http://counter.li.org
finger blindcoder@scavenger.homeip.net | gpg --import
--=20
/lusr/bin/brain: received signal: SIGIDIOT

--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQFFty7QAsME5O4xgqgRAtHtAJ9JgSeiFxtFfNLkh/3jIYo2OMb9GACgtqKS
wZ5CohAGvTwOa9T8yDPIPc4=
=D0Ra
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
