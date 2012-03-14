From: NeilBrown <neilb@suse.de>
Subject: Re: [md PATCH 15/23] md/raid10 - support resizing some RAID10
 arrays.
Date: Wed, 14 Mar 2012 19:32:15 +1100
Message-ID: <20120314193215.267f2d83@notabene.brown>
References: <20120314043555.7978.75486.stgit@notabene.brown>
	<20120314044040.7978.69754.stgit@notabene.brown>
	<20120314061746.GA28196@www5.open-std.org>
	<20120314172712.3aa9310a@notabene.brown>
	<4F604E10.20605@westcontrol.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/0JyhhWXt6bDiaKEFlbDSSDK"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F604E10.20605@westcontrol.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: keld@keldix.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/0JyhhWXt6bDiaKEFlbDSSDK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 14 Mar 2012 08:51:44 +0100 David Brown <david@westcontrol.com> wrot=
e:

> On 14/03/2012 07:27, NeilBrown wrote:
> > On Wed, 14 Mar 2012 07:17:46 +0100 keld@keldix.com wrote:
> >
> >> Hi Neil
> >>
> >> What is the problem with adding space to the 'far' layout?
> >>
> >> I would think you could just create the new array part 1 from the
> >> old array part 2, and then sync the new array part 2 with the new
> >> array part 1. (in the case of a far=3D2 array, for n>2 similar
> >> constructs would apply).
> >
> > If I understand your proposal correctly, you would lose redundancy
> > during the process, which is not acceptable.
> >
>=20
> That's how I understood the suggestion too.  And in some cases, that=20
> might be a good choice for the user - if they have good backups, they=20
> might be happy to risk such a re-shape.  Of course, they would have to=20
> use the "--yes-I-really-understand-the-risks" flag to mdadm, but other=20
> than that it should be pretty simple to implement.

Patches welcome :-)

(well, actually not - I really don't like the idea.  But my point is that
these things turn out to be somewhat more complicated than they appear at
first).

>=20
> For a safe re-shape of raid10, you would need to move the "far" copy=20
> backwards to the right spot on the growing disk (or forwards if you are=20
> shrinking the array).  It could certainly be done safely, and would be=20
> very useful for users, but it is not quite as simple as an unsafe re-size.

Reshaping a raid10-far to use a different amount of the device would
certainly be possibly, but is far from trivial.
One interesting question is how to record all the intermediate states in the
metadata.

NeilBrown



>=20
> mvh.,
>=20
> David
>=20
>=20
> > If I don't understand properly - please explain in a bit more
> > detail.
> >
> > Thanks, NeilBrown
> >


--Sig_/0JyhhWXt6bDiaKEFlbDSSDK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT2BXjznsnt1WYoG5AQKwRBAAiVfpLncDTymQU0HcDqKMoBqhxeTkvxz8
UN7/i9s5QzPAENJzjmH06cReITkTeNYUQP4fd1/CZq/mC/mufPCKon6epNcy8EHc
nZMlhZLj7oJud2uUtm4Ws2biuc33gyix3XWMHVB0DZFp6aMsKMuly5f+dSXn9cQg
ZfpzR4VcSDVow+xWGLM2dxBVQXgzWvpVCHhw4Jdvv/8uh1gTDQwaTOnd4+bRlyGB
62Q+9f5MSfE2CvEGw+pBnUnSXP4n+6WaO2/mI8qOO7kf302UFhcgYieAwNocyzNo
uzJ7vv1/HLcJ4BpyYLIVlQKyeNhxb/et5IsuO80hooDhUKsP7sBoozgBWoR6BSsZ
da+DFguXl2fRUyGlu2vvCWeVt01hH9tnqWWGfFtDOYZzggVlbD2e/Wl2LDGU1pJg
0ZdrIfdcoHKGgKM1aLb/UAXz9IejXNWKjGqkhdbef4hvgodYbcqzgv9w8P/DSlK4
9SokADYOpcgLXu0HzD4pN0D2oNN++MQLXsrj3jgfS1c1f/n+bM7DprLD5vJ7sZKz
T2cxjtoxcNzsI0c3AUamK9cJ5ZFMPJDVldlxF/jYP+AvLFn7I3rNcjOqPZ3NIpIx
ZyUXkpqBmJGsQScHygtx5S6j1D0R2NcT8+opOHqlkzTkWQmqua/rUoxuiM3rRjif
KzSXQbMTaHo=
=ZqG7
-----END PGP SIGNATURE-----

--Sig_/0JyhhWXt6bDiaKEFlbDSSDK--
