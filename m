From: NeilBrown <neilb@suse.de>
Subject: Re: Raid 1 vs Raid 10 single thread performance
Date: Thu, 11 Sep 2014 15:46:16 +1000
Message-ID: <20140911154616.06a86595@notabene.brown>
References: <CAEp_DRAVPBvA34kgdjWqO6f6489SbmHQf-dFXC_SwSQd8e0C2w@mail.gmail.com>
	<20140911103110.42449c9e@notabene.brown>
	<CAEp_DRANDtdBCmRCqfiMeyfDg2+-q_EGsrs97QcE744Otqg0Og@mail.gmail.com>
	<20140911145911.47c0d857@notabene.brown>
	<CAEp_DRBOeg8r8qUnMKM7tR9YbcP6Yb2HupUzSb1zzFPv7Q3ePA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/lPMU4xLA49+0ZQx4q.rMlGn"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAEp_DRBOeg8r8qUnMKM7tR9YbcP6Yb2HupUzSb1zzFPv7Q3ePA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bostjan Skufca <bostjan@a2o.si>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/lPMU4xLA49+0ZQx4q.rMlGn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 11 Sep 2014 07:20:48 +0200 Bostjan Skufca <bostjan@a2o.si> wrote:

> On 11 September 2014 06:59, NeilBrown <neilb@suse.de> wrote:
> > On Thu, 11 Sep 2014 06:48:31 +0200 Bostjan Skufca <bostjan@a2o.si> wrot=
e:
> >
> >> On 11 September 2014 02:31, NeilBrown <neilb@suse.de> wrote:
> >> > On Wed, 10 Sep 2014 23:24:11 +0200 Bostjan Skufca <bostjan@a2o.si> w=
rote:
> >> >> What does "properly" actually mean?
> >> >> I was doing some benchmarks with various raid configurations and
> >> >> figured out that the order of devices submitted to creation command=
 is
> >> >> significant. It also makes raid10 created in such mode reliable or
> >> >> unreliable to a device failure (not partition failure, device failu=
re,
> >> >> which means that two raid underlying devices fail at once).
> >> >
> >> > I don't think you've really explained what "properly" means.  How ex=
actly do
> >> > you get better throughput?
> >> >
> >> > If you want double-speed single-thread throughput on 2 devices, then=
 create a
> >> > 2-device RAID10 with "--layout=3Df2".
> >>
> >> I went and retested a few things and I see I must have done something
> >> wrong before:
> >> - regardless whether I use --layout flag or not, and
> >> - regardless of device cli arg order at array creation time,
> >> =3D I always get double-speed single-thread throughput. Yaay!
> >>
> >> Anyway, the thing is that regardless of -using -layout=3Df2 or not,
> >> redundancy STILL depends on the order of command line arguments passed
> >> to mdadm --create.
> >> If I do:
> >> - "sda1 sdb1 sda2 sdb2" - redundandcy is ok
> >> - "sda1 sda2 sdb1 sdb2" - redundancy fails
> >>
> >> Is there a flag that ensures redundancy in this particular case?
> >> If not, don't you think the naive user (me, for example) would assume
> >> that code is smart enough to ensure basic redundancy, if there are at
> >> least two devices available?
> >
> > I cannot guess what other people will assume.  I certainly cannot guard
> > against all possible incorrect assumptions.
> >
> > If you create an array which doesn't have true redundancy you will get a
> > message from the kernel saying:
> >
> >   %s: WARNING: %s appears to be on the same physical disk as %s.
> >   True protection against single-disk failure might be compromised.
> >
> > Maybe mdadm could produce a similar message...
>=20
> I've seen it. Kernel produces this message in both cases.
>=20
>=20
> >> Because, if someone wants only performance and no redundancy, they
> >> will look no further than raid 0. But raid10 strongly hints at
> >> redundancy being incorporated in it. (I admit this is anecdotal, based
> >> on my own experience and thought flow.)
> >
> > I really don't think there is any value is splitting a device into mult=
iple
> > partitions and putting more than one partition per device into an array.
> > Have you tried using just one partition per device, making a RAID10 with
> > --layout=3Df2 ??
>=20
> Yep, I tried raid10 on 4 devices with layout=3Df2, it works as expected.
> No problem there.

But did you try RAID10 with just 2 devices?


> And I know it is better if you have 4 devices for raid10, you are
> right there. That is the expected use case.
>=20
> But if you only have 2, you are limited to the options with those two.

You can still use RAID10 on 2 devices - that is not a limit (just like you =
can
use RAID5 on 2 devices).

NeilBrown


> Now, if I create raid1 on those two, I get bad single-threaded read
> performance. This usually does not happen with hardware RAIDs.
>=20
> This is the reason I started looking into posibility of using multiple
> partitions per disk, to get something which reads off both disks even
> for single "client". Raid10 seemed an option, and it works, albeit a
> bit hackish ATM.
>=20
> This is also the reason I asked for code locations, to look at it and
> maybe send in patches for review which make a bit more inteligent
> data-placement guesses in the case mentioned above. Would this be an
> option of interest to actually pull it it?
>=20
> b.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/lPMU4xLA49+0ZQx4q.rMlGn
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVBE3LDnsnt1WYoG5AQKSBA/9HuDetaXL1Kd6GoI5H+VvaTxb4hml1RSS
ibD3EeJ1rTjDdO+h1E4GisaJipG2d9rr2SEHXaDXW7ksVgpHagI4HZjBNITqJt63
1fqRbbsix4M6FI6loF1A13pN56tkR93rlxHY7+r271ZJjPhSASBWk/0nnHGzAAPh
yxTbD4Ez/FvbuJyroIRdTdW1nj9Sq+VN7h2zfxTVVyuKHRwGQ9Q05L1SBLg0wZ6c
bUQ+dJg+5y6UKs252uZbg2xz3azgNyND8ocNEQoMsvKm2MgMtZ3p2UOSy2cu2J4p
qSGXMXXO0Z/GUO8Cdwn5VHyB6184gQ2wsdIV4tUBwCVrwOfvLoYKA00C7S3JhJxV
YE9s+9QbgVjrd7uuHsyDO7TquTpzAcld7wtBDJ5RhpEX/iRAxvSZaS92x+6FwWMn
FvwATneCouG2abeeXxLkme8Y7oRTl+t6/zBIUuwcVkV39nqB2cFjZA60qrBz6plS
OlSc7HG6ne/7LDaCE8h0Yo9zZX7PoTTKCSLxlVz3GiJzKtrKkqirr1KCkn8jvxLi
nIASnXMUEhUYGm7SDhrDqOHKx3S9chj1rC1d1IXBqPXKENak3Ty5/97dtGO+ZLdt
sCr4G3K4OAIVrbt4uv349snlgEzsHxkDkOKLpPjdtQGefy8mG5FwRFY7y9yqF6wN
2s9N37ebnU0=
=1GzC
-----END PGP SIGNATURE-----

--Sig_/lPMU4xLA49+0ZQx4q.rMlGn--
