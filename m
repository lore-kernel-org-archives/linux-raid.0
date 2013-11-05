From: NeilBrown <neilb@suse.de>
Subject: Re: [RFC] md raid resync counter
Date: Tue, 5 Nov 2013 16:12:55 +1100
Message-ID: <20131105161255.130a9c52@notabene.brown>
References: <5273A5BC.5060109@gmail.com>
	<20131102104808.47834bdc@notabene.brown>
	<52776852.3020309@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/GKTs/STblj+iSh9kxEbNn=8"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52776852.3020309@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jack Wang <xjtuwjp@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/GKTs/STblj+iSh9kxEbNn=8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 04 Nov 2013 10:26:42 +0100 Jack Wang <xjtuwjp@gmail.com> wrote:

> On 11/02/2013 12:48 AM, NeilBrown wrote:
> > On Fri, 01 Nov 2013 13:59:40 +0100 Jack Wang <xjtuwjp@gmail.com> wrote:
> >=20
> >> Hi Neil and all,
> >>
> >> Is there anyway to know:
> >>
> >> 1. How often does a raid start to resync?
> >=20
> > Look at your logs?
> >=20
> >> 2. How many bytes did it resync?
> >=20
> > Look at "mismatch_cnt" in sysfs (and multiply by 512).
> >=20
> > NeilBrown
> >=20
> >
> Thanks Neil,
>=20
> You're always very helpful :)
>=20
> About the second one. As I checked in my system kernel 3.4.51
>=20
> when raid is resync:
> cat /proc/mdstat
> Personalities : [raid1]
> md1 : active raid1 dm-1[3] dm-2[2]
>       23762944 blocks super 1.2 [2/1] [_U]
>       [=3D=3D>..................]  recovery =3D 10.7% (2562240/23762944)
> finish=3D7.5min speed=3D46565K/sec

This array is doing "recovery", not "resync".

"Resync" is when the devices should all contains the same data but maybe
don't due to some  error.  So md/raid1 checks and fixes the errors.
"recovery" is when a spare has been added and data is being copied  onto it.


> # cat /sys/block/md1/md/mismatch_cnt
> 0
>=20
> cat /sys/block/md1/md/degraded
> 1
>  cat /sys/block/md1/md/mismatch_cnt
> 0
> # cat /sys/block/md1/md/sync_completed
> 8911488 / 47525888
>=20
> mismatch_cnt is 0, sync_completed look what I want?

"sync_completed" is a number which is somewhat smaller than the number of
sectors that have been be processed by the current
sync/repair/recover/whatever.

Slightly smaller because it is only updated occasionally.

I don't really know what you want because you didn't say what you would do
with the information, but it is possible that this is what you want.


>=20
> Jack


NeilBrown

--Sig_/GKTs/STblj+iSh9kxEbNn=8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUnh+Vznsnt1WYoG5AQL+ew//TTpjTwfmCLbp5Kn//7bQJGEZ3tpy0yz6
nSHxPLJGnyY0lKbFNfTY0junCxaW50F56yjv5NKTGjRJQskx8ILOB3zZHUg/V/Os
CK3EOyB9io5P7nvW/rOO9glcOEz030XSEJYtXEb/avuYeINARJTHUatTRxT4/yBG
d6WnUk786pUGVLOU8ksTpZCgoIRutJdH7sQh2wJcXiAnnRXpB7bgBg5ZoM7NNQZC
iuJ71yXABreqoMyoEXm1sMQ0g8ygNAexCLdl4Ms7Sxs7XeNfX8xiiFaxgafsPg99
VV5/g2yAbnm48cHFFwHVN8raNm7psPmeR2V9YXJLGEB4jPvDLOyEkXPHBukCCcZf
M+phNv+1eZTSxqy4ml3nuNfTPkwFuGT/jAb6ZXtiqJKYQ9cRHm1xPehTKvCT850U
oucbogR76i8LWfv6c0+Vf0MYD2FNLD0o2Z+pgA6SCsc7yaqaJhG5KhnYwre3DSnq
S9aCaS/u8zX8/Udih2fFz417DapCMHpajx8hVaMGrQ1nmYQ64uYjA8VqKu5lw1Pd
rtAa92/x1khSYW8gORSwGdRiG7+J9Hz74FHr61Y3ZwqjpyyZpfmOu530D3up98Pg
5xEBcT7o5ep557QwcVcrQjH8vVhWW4dtstK0U6jUIkJ+HROy7YQm+uvtYfL3OcdM
MXDOwd7+NWs=
=kzSo
-----END PGP SIGNATURE-----

--Sig_/GKTs/STblj+iSh9kxEbNn=8--
