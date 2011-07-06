From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: `pvmove stuck' in RH bugzilla
Date: Wed, 6 Jul 2011 12:53:10 +0300
Message-ID: <20110706095310.GA3225@swordfish>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

I think we just trapped into the same trouble with pvmove as described in=
=20

https://bugzilla.redhat.com/show_bug.cgi?id=3D602516
https://bugzilla.redhat.com/show_bug.cgi?id=3D706036
etc.

Comment says, that
> I found a series of problems with pvmove which I have fixed in the upstre=
am
> repository.  However, I would like to wait some time to see that no unint=
ended
> side-effects show up before seeing the change back-ported to RHEL.  An au=
dit
> for similar bugs found a problem in lvremove, which I have also fixed.=20
> lvconvert still needs to be audited.


Alasdair, could you please point are those patches in vanilla kernel=20
(3.0-rc*) or linux-next, or some RH internal tree?=20
This is not critical, though I'd like to try out patches.


Thanks,
	Sergey

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iJwEAQECAAYFAk4UMIYACgkQfKHnntdSXjSrNQQA1VUekaYX7C1n1u/fEuWFwNIk
oUxXXvwja8ICVuS7/3Ofy1/ahtDh/YSxj7pN91geIRPgP1fMkxepl52R5Qvwxuky
+dcT+qTfihWEzaho/OH3YgpzJ6/3+LC4EszPnjqfHBCNR831LbnlvqeuOOX4LTlW
XO7kxlGxwWmtqWslpaM=
=iwTa
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
