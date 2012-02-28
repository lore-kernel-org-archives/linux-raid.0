From: NeilBrown <neilb@suse.de>
Subject: Re: Raid5 device hangs in active state
Date: Wed, 29 Feb 2012 08:46:07 +1100
Message-ID: <20120229084607.29c63965@notabene.brown>
References: <4F0A129E.5020706@nuclearwinter.com>
	<20120109112644.489e4a48@notabene.brown>
	<4F4D1B33.3010308@nuclearwinter.com>
	<20120229065206.60d1e2ea@notabene.brown>
	<4F4D4844.3010805@nuclearwinter.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/To2lif3/7X67WaaobYs2R.5"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F4D4844.3010805@nuclearwinter.com>
Sender: linux-raid-owner@vger.kernel.org
To: Larkin Lowrey <llowrey@nuclearwinter.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/To2lif3/7X67WaaobYs2R.5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 28 Feb 2012 15:33:56 -0600 Larkin Lowrey <llowrey@nuclearwinter.com>
wrote:

> Thank you for taking a look.
>=20
> I should be able to move the drives to a completely different controller
> (and driver) so that will be a good test.
>=20
> Could NCQ be an issue? IOW, do you think it would be worth disabling NCQ
> and re-running this scenario?
>=20

At this point I wouldn't want to exclude anything as a possible issue.  So
anything that you can turn off or on fairly easily would be worth checking.

If you turn off NCQ and the problem goes away, that isn't proof that NCQ is
the problem.  If it is a race condition, then removing NCQ could upset
timings just enough that you stop hitting the race window.  However if you
get acceptable performance without NFQ then it could turn out to be an
effective work-around even if it isn't the real problem.

NeilBrown

--Sig_/To2lif3/7X67WaaobYs2R.5
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT01LHznsnt1WYoG5AQJ2aQ//cUbwEujBeTSUh1flTyvVDgKQq+RtpyO1
1yDsrxwROieKSFY5BUrOrskV3hRMO7Kysy6c+sMCBAeTdUOYlir9AK4nxD2X8VAH
YW3PRR4e6t4wM+m4M7M1CdsH/zHNigsQ2OA42Fhk9E2KNATBj1Ww9aPt+oy8+oxW
kT1sGKEjBsw9DwpcjW7PHxlesr4xNlt5JDpDvPFYVxM1nGvfpVZiOoYybmPvgUQt
7v2Ll0sHcoGf9CbnQeVvcb/EhCzG7g7Db8/xSRbVTjDKN9Byml5no/xM1gqxzD3n
QCFpJV7KdHDFUWZMxJ7wboE2u7kn/mYiXok5Dsu7VvgMW8+0uJ7bIt/MS/JT3WUO
vHjmR/pyZa+BEdAYDhSDIo8qibE3LPAbQv5huLCS9s3IKXVH/Vvwka4UxMckG3dI
vKXg4c7eY0TUfhTM1U1IKDzARwSNMFgc+ahYoixFwGAME/y2B6pTRckBJw0qDGDi
vaWQC+PNEzg1uyF6cd/szXvogKX7cKMQ2i8odfweLi8i6rnZ+mZ8pEGngQxyaurY
/+XOexGzhfWyv/U72kBx3C5+F449UB3dHg8B/hrAGcsha86N0PqzVRE6Qx0rzwvg
TCHcnwbXcyPOmReXuj6PrBBuAUqxiN1tVYqdC9fwJqm48gUsm+OZBkX9sl1I8bMm
s2T12671Bqw=
=l0vd
-----END PGP SIGNATURE-----

--Sig_/To2lif3/7X67WaaobYs2R.5--
