From: NeilBrown <neilb@suse.de>
Subject: Re: [md PATCH 08/23] md: don't set md arrays to readonly on
 shutdown.
Date: Fri, 20 Apr 2012 22:01:51 +1000
Message-ID: <20120420220151.623df648@notabene.brown>
References: <20120314043555.7978.75486.stgit@notabene.brown>
	<20120314044040.7978.64156.stgit@notabene.brown>
	<CAGRgLy5UYf27335hQmEQQ8V2GSatQ-1aev9DdTia0j-Hv4wsEg@mail.gmail.com>
	<20120419084833.39379a6f@notabene.brown>
	<CAGRgLy6LXB34JtmfZYQEdAK4GLCV-hn-V8cT1zCwo_=ERyK90A@mail.gmail.com>
	<20120419195740.6e35ea02@notabene.brown>
	<CACVpCE5mpJcY5u=8Kqp7TkCHN63aMfncDwbnP77NOFjubhqoPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/hDjEjPU+9EPrBG.b=_fDVBJ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACVpCE5mpJcY5u=8Kqp7TkCHN63aMfncDwbnP77NOFjubhqoPA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Pawe=C5=82?= Brodacki <pawel.brodacki@googlemail.com>
Cc: Alexander Lyakas <alex.bolshoy@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/hDjEjPU+9EPrBG.b=_fDVBJ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 20 Apr 2012 13:30:39 +0200 Pawe=C5=82 Brodacki
<pawel.brodacki@googlemail.com> wrote:

> 2012/4/19 NeilBrown <neilb@suse.de>:
> > On Thu, 19 Apr 2012 12:11:43 +0300 Alexander Lyakas <alex.bolshoy@gmail=
.com>
> > wrote:
> >
> >> Hi Neil,
> >> Thanks for the clarification.
> >> However, from your commit message, it stems that during a normal
> >> reboot (without -f -n), writes can still arrive after your reboot
> >> notifier has cleaned the array. In such case, array might be dirty
> >> after reboot. Is that so? If yes, then that's kind of regression.
> >
> > Why do you think that?
> >
> > I don't think that is the case.
> >
> > NeilBrown
>=20
> Hello,
>=20
> The way I read the message agrees with Alexander's perception. My
> impression from reading the commit message is, that normal shutdown
> may result in unclean array, which I would perceive as a regression.

I don't think you'll find the word "normal" in the original message :-)

>=20
> I would really appreciate clear statement, whether this behaviour
> (writeback during shutdown, with possibility of poweroff/reboot while
> array is dirty) can or cannot occur during normal shutdown process.

Define "normal".
If you kill any processes that could generate write-out, and then do a
'sync', then everything should be fine.

I suspend a "normal" shutdown sequence does this.

NeilBrown



>=20
> I would bet, that only forced reboot/poweroff (reboot --force) may
> result in dirty array on boot, but I'd rather not bet my data.
>=20
> Best regards,
> Pawe=C5=82 Brodacki


--Sig_/hDjEjPU+9EPrBG.b=_fDVBJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5FQLznsnt1WYoG5AQK6Hw/+IzopWXnvr3PTvDK1XzOoOlQQYWlcWYlz
TtFbnzhkhk6FVNw2rsch8yUj6C3P/g5sguQRTQS0sY3ZFpd0eJRg0xViG7uQBhWq
5JoH85VELpl8qsNw/qeW+J29kjGLkxTwpym4+PCzSqiykNJ6sOR3ocGqnvWrfxB5
Lm32+YdR/ljTCI/Gx5eVwh4URzHbKGmvtql0iUH8AHJCT+rIiSSlAX84YjfxeIeC
m0xMJDk8kEZPVZoK4k8rA/A+UvBj2DAlbamRWkfSV35OQB/Si4OtEQ42A/9B1KVI
9Z9Drpzku8aai8S2EGg/2I9IqkGdjdk4xU8QEKm4gk9rXXrJ2HI8L1xwf5Sqj0qW
WLfp4KFgrsKgnfJjMFfbgTOBiK5LgzLjPZw/NW5WPbYNUEQ469q29RViz38bJp3/
rI2DX2WOhm+y2ZdccdNbffNqWys43YYQtwe7OQWMO+rpt/4CFASGLiQmFk2nHJ+X
qCCHzaQTBz7QIe+f0BFjaVfhUnJh5FxfKOPHMi17KwOx+Irg7lyJOEmH4CEiyraq
eORwXcVcWKc6IL95TYUJk5JLYnL/xCdsjcX225O2RrPXFor5v5DD/FOQsJB2rIEN
k2Nl5iXegN07lWj2B1tBDfvHw2ovbTtAM2QU/5eMQqFFg+RZxpQdGF3alE0JELRg
hm/hUEd8VRk=
=AXUD
-----END PGP SIGNATURE-----

--Sig_/hDjEjPU+9EPrBG.b=_fDVBJ--
