From: NeilBrown <neilb@suse.de>
Subject: Re: md raid5 fsync deadlock
Date: Thu, 1 Mar 2012 12:53:25 +1100
Message-ID: <20120301125325.2b17e5f8@notabene.brown>
References: <4F4EB53C.6060901@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/2SqlMth+_MA3zEkg3r90y7N"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F4EB53C.6060901@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/2SqlMth+_MA3zEkg3r90y7N
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 01 Mar 2012 00:31:08 +0100 Milan Broz <mbroz@redhat.com> wrote:

> Hi Neil,
>=20
> I am repeatedly getting deadlock with MD raid5 & running fio check.
>=20
> array created just this way
> # mdadm -C -l 5 -n 4 -c 64 --assume-clean /dev/md0 /dev/sd[bcde]
>=20
> and running this test (on quadcore CPU)
>=20
> # fio --name=3Dglobal --rw=3Drandwrite --size=3D1G --bsrange=3D1k-128k --=
filename=3D/dev/md0 --name=3Djob1 --name=3Djob2 --name=3Djob3 --name=3Djob4=
 --end_fsync=3D1
>=20
> deadlocks in final fsync()
>=20
> I can reproduce it on Fedora 3.2.7 kernel (and also 3.3.0-rc5),
> below is part of the sysrq trace (full sysrq in attached gz archive)
>=20
> I was able to simulate it even when resync is running, it stopped
> resync process as well.
>=20
> Please let me know if you need more information.
>=20

Are you certain it is a deadlock?  No forward progress at all?

What is in md/stripe_cache_size?  Does it change?
What happens if you double the number in stripe_cache_size?  What if you
double it again?

NeilBrown

--Sig_/2SqlMth+_MA3zEkg3r90y7N
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT07WlTnsnt1WYoG5AQLS8A/+M9uekq7+hKjf1e8CEfkqAgyB0V+C6hbl
FXvhi10k1sm2TTFXAR2PS6NP+OpMBKLmDkabY/CviW3dtg/Kz5+CzFEuwCwAb1Ce
aRZIgxMRqjvCfKQh9oqWZZqWQpc4L7jFuvt84ZHV+7cySoB5gRtyg6cbjqre/y2e
FvU08xLt6+wtA0fDSj1i7bwH6jSwUjUDYOP+sLqHZCZyK3wI/RbcWXn2PATZPh1e
Begmg2bZthWg5Q1gfgDFVBHHVJ13K/0H4PSh0eYw4lZJyter5X+QUYHagIdsfThO
EMKEk/egcuyna2iLGEEnpWWsL62eRjNKfRSj11Z6okuUTKtpRJKmDyKfZcRIndAs
rN6fC6fTqr6TCQCIEBxNX3EZ3jvzuzFnESKTRl2ihb1GhTcket5ZGf5JGuT9dVF7
HWdn2td20ifTarmS426aobroFhkmH3amLnJAj0ELX29UEx5ZNAuaiemkkBtfM9Gj
BSSYNPCfkohNl2W1syADXKstgs3cUZf/ODL2nZItUpSijh8PF18iCUyeta2TZtF4
4vpjzBeUt/d1sUKkqaJEC4DXnymprABOcHk0XsGONtkcm8sz64vzgiQAHgkHt/8Z
sENAzvd9SVFspZlhIUpaNiwqaEAL27mkoLhmWeRyf90RGC5VfSsMWEb8RwOocZB0
j+hE9Uals74=
=IZeU
-----END PGP SIGNATURE-----

--Sig_/2SqlMth+_MA3zEkg3r90y7N--
