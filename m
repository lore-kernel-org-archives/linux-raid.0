From: Bryan Mesich <bryan.mesich@ndsu.edu>
Subject: Re: Why does one get mismatches?
Date: Thu, 11 Feb 2010 11:51:33 -0600
Message-ID: <20100211175133.GA30187@atlantis.cc.ndsu.nodak.edu>
References: <869541.92104.qm@web51304.mail.re2.yahoo.com> <4B67451F.8040206@tmr.com> <20100202093738.44b4fece@notabene.brown> <4B684087.50001@tmr.com> <20100211161444.7a0ea7bb@notabene.brown>
Reply-To: Bryan Mesich <bryan.mesich@ndsu.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100211161444.7a0ea7bb@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Bill Davidsen <davidsen@tmr.com>, Jon@eHardcastle.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 11, 2010 at 04:14:44PM +1100, Neil Brown wrote:
> > This whole discussion simply shows that for RAID-1 software RAID is les=
s=20
> > reliable than hardware RAID (no, I don't mean fake-RAID), because it=20
> > doesn't pin the data buffer until all copies are written.
>=20
> That doesn't make it less reliable.  It just makes it more confusing.

I agree that linux software RAID is no less reliable than
hardware RAID with regards to the above conversation.  It's
however confusing to have a counter that indicates there are
problems with a RAID 1 array when in fact there is not.

I (and I'm sure others) value your expertise on this matter, but
it's hard to feel at ease when the car you're driving across the
country has the check engine light on.  In this case, I believe the=20
mechanic when you say the car is okay, but it might be difficult=20
for others to believe as I do.

I rely heavily on software RAID as I'm sure many others are.  I
believe this is quite evident in the amount of email that has been
circulated about the mismatch_cnt "problem".  IMO, a users perception=20
of reliability is really the root of the problem in this case. No
one who depends on this stuff wants to see weakness.  Those who
do are going to be concerned.  Especially those who are running
distributions such as RedHat/Fedora that do weekly checks on the=20
arrays.=20

Neil, you had mentioned some time ago that you were going to
create a patch that would show where the mismatches were located
on disk.  Did you do this and if so where can I find the patch?

Bryan

--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkt0Q6UACgkQlSl3SAlkhEeKnACeIRADGA307ZE/GgvkP2qOPkjD
IXwAn2fLt/669JW0Hu1LlBJgGORXopZd
=0iJC
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--
