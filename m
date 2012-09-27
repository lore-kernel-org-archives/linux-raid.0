From: NeilBrown <neilb@suse.de>
Subject: Re: Hello,Re: GPT Table broken on a Raid1
Date: Thu, 27 Sep 2012 12:43:04 +1000
Message-ID: <20120927124304.2db38a82@notabene.brown>
References: <4961154.0TR9MeFlIq@techz>
	<5231765.ZMIFzBOKSc@techz>
	<FABB1E4C-1CAC-429F-96CF-FC563336A913@colorremedies.com>
	<5315095.pvR2SvTGWe@techz>
	<F2C9D196-A5AC-4F35-9177-FDFCA755FB2B@colorremedies.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/5OjI4VEYCasIIjCjjg8LadS"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F2C9D196-A5AC-4F35-9177-FDFCA755FB2B@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/5OjI4VEYCasIIjCjjg8LadS
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On Wed, 26 Sep 2012 13:33:49 -0600 Chris Murphy <lists@colorremedies.com>
wrote:

>=20
> On Sep 26, 2012, at 6:17 AM, G=FCnther J. Niederwimmer wrote:
> >>=20
> >> dirty state.
> >=20
> > OK, I run the Intel Tool in windows two times with the last Tool I foun=
d.
> >=20
> > The Tool don't found any Problem (?) and don't repair, but mdadm=85.
>=20
> I'm going to trim this down:
>=20
> >=20
> > /dev/sda:
> > [Volume0]:
> >           UUID : ec120401:b6ed52e6:3814fac4:48fcf4fc
> >       Map State : normal
> >    Dirty State : clean
> >=20
> >=20
> > /dev/sdb:
> > [Volume0]:
> >           UUID : ec120401:b6ed52e6:3814fac4:48fcf4fc
> >      Map State : normal
> >    Dirty State : dirty
> >                 =B0=B0=B0=B0=B0=B0=B0
>=20
> I don't understand this UI. Are there two Volume0's?=20
>=20
> I can see how the dirty state would apply independently among physical de=
vices /dev/sda and /dev/sdb. But the virtual device, the array volume, "Vol=
ume0" seems like it would have only one instance. So I don't understand how=
 it can be clean in one case and dirty in another.
>=20

It just means that when looking at the metadata on /dev/sda, we see it mark=
ed
'clean', and  when looking at the metadata on /dev/sdb, we see that it is
marked 'dirty'.
Possibly something wrote to Volume0 between these two events, so the volume
got marked 'dirty' so the write could happen.  Wait a few seconds and it
should get marked 'clean' again.

Or possibly there is a bug somewhere.
I would open two windows.  In one run
  watch -d mdadm -E /dev/sda
and  in the other run
  watch -d mdadm -E /dev/sdb

then access the array, or maybe leave it alone, and see how the metadata
changes with time.

NeilBrown

--Sig_/5OjI4VEYCasIIjCjjg8LadS
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGO9ODnsnt1WYoG5AQJiAA/9H2DW+PtLUtVr8ZDGg6YgfKSUlib8/myo
VcMNf7YTR+N3r/lxUc9nKjOVaSAIJUBfRBngz8Wy8GP/gzL8L8S12tmglO6KcZa8
RK98uWmKhvcTrxC8luzvHWBGssjunQuRwQreFlzTubyi6WrepOLU4Lhje3fmpwQs
2ck5enmCa6+fm1p3UVd6AqRIotT+mtG20xKczcdaU/F1O76YBr/ibv+e/pLNo5U2
KrShlepGbNf32OhgJHNT3JzQTk+87ZzxxrM5uomve+fNNAQFx3TZBGLGeY4O5d9M
zU82fOMhw93ClwVhE5yK/599GE/HLdKqhEmOwVGTl/Syr9qmgn/vDl2v4zyOy2Wu
eNotK0JZHi+ht9PkJihgtYRK/xhbfIl5njLkZJ5vGqAjG1P7Q8yxjsE5Jw7ovtFU
8uy2zvDdHnEVRZIXmXpmdb2JuPhQrEHmc2MGU4jES6bujIDGJi8yl/Dg+bcheOLg
7ZSF7lAu+TfZ9PcBQC6soXk3rGA7dyUV6f/AJ0QxEQ4T3lBUZi3RuIGMXH3rsXeR
h0LP/snxKXDTWjJ5GNCydi5WF9qiwjL+/puBmvTUI1gJ969S5OVWDsTjN8AhHk2c
mQ7cCKpr0UyN61TcyC8vnFuV44m8p89/loVZLCQImTg5zARi50sNj3hZfnDfexxQ
Km6hGd+gLIk=
=Fe6Y
-----END PGP SIGNATURE-----

--Sig_/5OjI4VEYCasIIjCjjg8LadS--
