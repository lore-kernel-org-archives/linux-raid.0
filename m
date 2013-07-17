From: NeilBrown <neilb@suse.de>
Subject: Re: shown disk sizes
Date: Thu, 18 Jul 2013 09:43:27 +1000
Message-ID: <20130718094327.7d46949e@notabene.brown>
References: <1374071867.25339.14.camel@heisenberg.scientia.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/p6ovKCF5mty5FPojS46Q6=F"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1374071867.25339.14.camel@heisenberg.scientia.net>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/p6ovKCF5mty5FPojS46Q6=F
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 17 Jul 2013 16:37:47 +0200 Christoph Anton Mitterer
<calestyo@scientia.net> wrote:

> Hi Neil, et al...
>=20
> (btw: do we have an issue tracker somewhere?)

Yes - this mailing list.
The protocol is that as long as you care about the issue and haven't had
satisfactory response, you post a "Can anyone help with this" every week or
so.
That way we don't have a problem with lots of stale entries that no-one car=
es
about.

>=20
> I was experimenting a bit... created two GPT partitions exactly 10 GiB
> (aka 20971520 sectors a 512B).
>=20
> Created a raid 1 on them:
> mdadm --create /dev/md/data --verbose --metadata=3D1.2 --raid-devices=3D2
> --spare-devices=3D0 --size=3Dmax --chunk=3D32 --level=3Draid1 --bitmap=3D=
internal
> --name=3Ddata /dev/sda1 /dev/sdb1
>=20
> The size is a multiple of the 32KiB so no rounding effects should kick
> in.

chunksize is not very meaningful for RAID1.  If you add '-v' mdadm should
tell you:
  mdadm: chunk size ignored for this level

Maybe it should round the size down to a multiple of the given chunk size,
but as you said "--size=3Dmax", maybe not..  Not sure.

>=20
>=20
> Now:
> --examine gives for both devices:
> Avail Dev Size : 20969472 (10.00 GiB 10.74 GB)
>      Array Size : 20969328 (10.00 GiB 10.74 GB)
>   Used Dev Size : 20969328 (10.00 GiB 10.74 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>=20
> =3D> Avail is the available payload size on each component device,... so
> given that we have the first 2048S for the superblock/bitmap/etc... that
> fits exactly.
>=20
> =3D> Why is the array size / used dev size smaller?

Good question.  Not easy to answer ... it is rather convoluted.  Different
bits of code try to reserve space for things differently and they don't end
up agreeing.  I might try to simplify that.

>=20
>=20
>=20
> --detail gives:
>      Array Size : 10484664 (10.00 GiB 10.74 GB)
>   Used Dev Size : 10484664 (10.00 GiB 10.74 GB)
>=20
> =3D> That's half of the Array Size from above? Is that a bug?

The number is in K rather than sectors.  Sorry :-(
The numbers if brackets, which have units, match.

>=20
>=20
> --query gives even another value:
> /dev/md/data: 9.100GiB raid1 2 devices, 0 spares. Use mdadm --detail for
> more detail.
> =3D> But the device really has 20969328S it seems... so the 9.1 GiB seems
> a bit bogus as well?

I think this is fixed in 3.3-rc1 by commit 570abc6f3881b5152cb1244

http://git.neil.brown.name/git?p=3Dmdadm.git;a=3Dcommitdiff;h=3D570abc6f388=
1b5152cb1244

>=20
>=20
> Last but not least... when the tools print values like "10.00 GiB 10.74
> GB"... wouldn't it be better if they printed "~10.00 GiB ~10.74 GB" or
> something like this to show that the values are rounded and not
> _exactly_ 10 GiB... could be helpful to avoid misalignment issues.

Would that really help?  Given that 10.00GiB is not exactly the same as
10.74GB, isn't it obvious that they must be approximations?

I'm not exactly against adding '~' but it doesn't seem necessary.
Does anyone else have thoughts?

Thanks,
NeilBrown

--Sig_/p6ovKCF5mty5FPojS46Q6=F
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUecsHznsnt1WYoG5AQKEDRAAhLBWWpFHlOf3JEPIKrZIXvLW6o/8lMwh
Iv0vpuTv2iURq44fGSp3y0KeDGL2KyzYwMv6YHX0CNIcUC6IygTNWtOvn15QlPs/
rNoR1D5PWUcTXaMy8Ccqp8wxRANOJRuV+VfmAC9BntzC6W6kHLv3JD+bjfMHnQN+
pJeDaC4HBrfNgNa9cf3aF8b7WmjH7U5kr+GjQhfImu9M+yjSjIKc9ISHYyyK5Vtq
SeGAjQ4ffApo+FMy4SblRJv2YzQgimZOolhqMP0s2h9i+fiAvGAflqG/rHSEHSV/
UxjLT/ILyMPjwbT2T/uJ46qXDzSg8Op69knWY4tyHdQaochmrAIQiG1RhJsp/GZd
3pb/GM6BCTzF5YwKuxJ94H490hK/vgWv4O3nSM7tSGak0HTpwPZNaoPv98/UbGXM
jpI5HpvXUcCg98NfOA9nJUSxrKgrApK5CihNlMilO9CpQMoliWHuIqfGsqLSAV3q
Mf2sXjGFq3bOXAUcejnIio92OorzAYt2ujT8ekUdva6SG2jP69FgtJI4KDz1nFzT
wOVtAl5ainfk6ENxcCk19BBmKyZb6xAs71av69x/jRfs4f+Z77bxcT3PtVwamPdA
wjHlyXuWoqDO0ldX2gdz8luEebe0bmcB26LYsOOUpBaz5NqzfYwYZVwW87n1L0sO
+m3NZYZn0YE=
=WYoh
-----END PGP SIGNATURE-----

--Sig_/p6ovKCF5mty5FPojS46Q6=F--
