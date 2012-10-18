From: NeilBrown <neilb@suse.de>
Subject: Planning a bug-fix release for mdadm: mdadm 3.2.6
Date: Thu, 18 Oct 2012 15:48:07 +1100
Message-ID: <20121018154807.461ddd29@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/65.Vm613IO6xuvmkKnrkQPu"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/65.Vm613IO6xuvmkKnrkQPu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi all,
 I had hoped to be close to releasing mdadm-3.3 by now but that doesn't look
 like it'll happen for a couple of months.
 So I'm planning on releasing 3.2.6 which just has bug-fixes on top of 3.2.5
 - no new features or possible breakage.

 The "mdadm-3.2.x" branch of my git tree (git://neil.brown.name/mdadm)
 contains what I have so far.  If anyone knows of bugs in current mdadm that
 really should be fixed for the next release and aren't in that tree, please
 let me know (or even send me a patch).
 If nothing happens to change my mind I'll release 3.2.6  seven days from n=
ow
 (which is Thursday afternoon in my time zone - GMT+11).

NeilBrown

--Sig_/65.Vm613IO6xuvmkKnrkQPu
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUH+KBznsnt1WYoG5AQKUwQ//T+qbSHuiaG5ll/Ha2fgog+4rmQD9EYyi
QWPYDI0R0eng3b2NWYNSjo3GPW2bdBgvPatCNPJpDOykFUPCmhaQ8ZB2nP7mRyvz
0XVQxHjFUTcgq0sberErHqc2CFwwCCrmj2AvkYBDPmWkUWDnvM6m7SZuGdIWe90J
+JYou7or0fRlQS56TwfA0UHR/zDHDK/9SRfjeVWEJi9gsL3qCSAMZuFwKjO6VLjF
HTJPS3kQOtgT080JeG+px+BYPUqE+nOQNBSXsWL7fBj19WeAQtQULDP3z3tMxoVg
WX2FGqaoMILiRqEEtIDBgJ+c5FtEwtp+vUIU83JvBkzWwQyxqzVeK8q6gf1+9nd4
F9y9Tq7EkNt1Rx8yWKKKgtNgC7p3UxRfDncYn5DDXheLzZyt7qqNYfrYMCQvlFwG
DTbtFHbz7hj7BIlqaBFOGj6SFAwCAsRN6VqLnbg/phyEZ6cZMeXbXdcZvwhzoXR2
J+O43BhZC5nZHGGmHu7+4XrSZCI6ugnqdmxes/i9aNiaB/WeRt58RpcHX0levSQX
IdHwo5vpALH5tLWVTfj7BCIZjTCp4J2ZVox/T8iitwekDN01hvMtN10GrUIvMJo3
a6M90rXLpE/wWzQU3KKyaEghxsGOcFS0/HOxpga67xwB9dSLrajTUnHVICGjJaSy
a63n77kZSRk=
=9kF4
-----END PGP SIGNATURE-----

--Sig_/65.Vm613IO6xuvmkKnrkQPu--
