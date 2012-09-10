From: NeilBrown <neilb@suse.de>
Subject: Re: question about bitmap for raid6
Date: Tue, 11 Sep 2012 09:07:48 +1000
Message-ID: <20120911090748.59087250@notabene.brown>
References: <2CE44BD3DBCF9541909CCB42F11CA39284A4F5@SFO1EXC-MBXP06.nbttech.com>
	<20120910085035.3fe12f99@notabene.brown>
	<2CE44BD3DBCF9541909CCB42F11CA39284A942@SFO1EXC-MBXP06.nbttech.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/HF9TqpEz00_uyr_wfAIhN=g"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2CE44BD3DBCF9541909CCB42F11CA39284A942@SFO1EXC-MBXP06.nbttech.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ming Lei <Ming.Lei@riverbed.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/HF9TqpEz00_uyr_wfAIhN=g
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 10 Sep 2012 16:43:14 +0000 Ming Lei <Ming.Lei@riverbed.com> wrote:

> Neil,
>=20
> How about the other scenario: I plug out a drive and put aside for a whil=
e and put it back to the same machine with bitmap enabled for the raid6 arr=
ay? Does it do full-recovery or fast resync?

If the array has been degraded that whole time, it will do a fast resync.

>=20
> I noticed either md superblock or bitmap superblock has events recorded a=
nd I guess it may be used to identify the up-to-date drive or the old drive=
 put back again.=20

Correct.

NeilBrown


>=20
> Thanks
> Ming
>=20
> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]=20
> Sent: Sunday, September 09, 2012 3:51 PM
> To: Ming Lei
> Subject: Re: question about bitmap for raid6
>=20
> On Sat, 8 Sep 2012 21:07:46 +0000 Ming Lei <Ming.Lei@riverbed.com> wrote:
>=20
> > Hi Neil,
> >=20
> > We use 2.6.32 in house and most recently we found something bad happen =
when we turn on bitmap for raid6 array. Let me ask a question to help me to=
 understand our situation.
> >=20
> > Say I have two hardware identical PCs(name them A and B) running with t=
he same linux distribution. Both box has an raid6 array assmeblying 7 drive=
s with internal bitmap. If I yank out one drive from PC B to make this driv=
e slot empty, and then yank out a drive from PC A and move it to PC B, woul=
d md driver force the raid6 array on PC B rebuild(take a long time) or just=
 do resync(very short time)? What's the condition on bitmap code to check i=
f it is really the drive I just pull out from the same machine or it is the=
 drive pulled out from different machine?
> >=20
> > Thanks
> > Ming
>=20
> PC B would not do anything to drive that you moved from PC A until you ad=
d it as a spare.  Then it will perform a complete rebuild of the missing de=
vice to the new device.  It will not do a partial recovery.
>=20
> 'md' knows it is a device from a different array because the 'uuid' store=
d in the metadata is different.
> If you managed to create two arrays on two different PCs which both had t=
he same UUID, then you could  definitely get strange data corruption happen=
ing, but that is very unlikely.
>=20
> NeilBrown
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/HF9TqpEz00_uyr_wfAIhN=g
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUE5yxDnsnt1WYoG5AQJIuw//UE/zpjcOOqTYLG0KuyHDtSnYf+++zdJv
3qzKDFf7H0CvcXFkkTubuEJgUUetUgSZFXpBYBr5tcoUYsGWRHMYVLFUl8DtIX2K
uz4ACpw0G6wuO5GYrrI9viIoRqmzrHyvAE9JF2ZA9QdsKXilo5FvUQfwLznccQgZ
YvnS6ULt1OHzEbvqTjLW/SopNe5M/N/cEo2plyfVZnZs/6el7twtksaLLBMHNdTj
x6yZsyNgoPCaLY6EwbNpYesy1iFIK7sWuQ8kAbillooWhWAgEPC9jMupTV/jAN/2
W0Jq4in0+KhR3hYyQbT+tR6QIdTr+IJvANsjBPC8EKcQw4oHhO8Razjb7pA7SkaY
VgjrhJM6Bm2IkopFg0mRKOAefGVJlOr/ehfmFke9Lhmf2NFYMIX1AU7aCiWy1nQs
Y+lAZbVidNiktAeWSgzJpBsIZynMdLpa5OST3/JIHI/pv4z/rbk/tcyx0mijxIuI
H7rSk0EYGyxd7oQ8vzU3TSjMwnHUbodBu54eqd1aHOlKZH6sG2BT2i3wn4tWdw0n
HprGFt07ZtXCW/Oa3U3p2I/BAznhXaCnmPrMuQOyDWKBiwnhg+yQBBZLtQdYJWAv
dRl2OCWlErlYSOdnYk35EobvfaYQmNqHlId4Jqp/HC7ipoiKd6zHtGpw9KN7fulW
nqKAFp98oxg=
=uR3c
-----END PGP SIGNATURE-----

--Sig_/HF9TqpEz00_uyr_wfAIhN=g--
