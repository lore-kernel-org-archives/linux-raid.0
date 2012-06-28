From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 0/4 v2] optimize raid1 read balance for SSD
Date: Thu, 28 Jun 2012 13:40:04 +1000
Message-ID: <20120628134004.729fb77f@notabene.brown>
References: <20120613090922.971820942@kernel.org>
	<20120628110616.79d4481e@notabene.brown>
	<20120628032901.GA21233@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/9_eSDjV8A4Jozzdc5dmGtYc"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120628032901.GA21233@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk
List-Id: linux-raid.ids

--Sig_/9_eSDjV8A4Jozzdc5dmGtYc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 28 Jun 2012 11:29:01 +0800 Shaohua Li <shli@kernel.org> wrote:

> On Thu, Jun 28, 2012 at 11:06:16AM +1000, NeilBrown wrote:
> > On Wed, 13 Jun 2012 17:09:22 +0800 Shaohua Li <shli@kernel.org> wrote:
> >=20
> > > raid1 read balance is an important algorithm to make read performance=
 optimal.
> > > It's a distance based algorithm, eg, for each request dispatch, choos=
e disk
> > > whose last finished request is close the request. This is great for h=
ard disk.
> > > But SSD has some special characteristics:
> > >=20
> > > 1. nonrotational. Distance means nothing for SSD, though merging smal=
l rquests
> > > to big request is still optimal for SSD. If no merge, distributing rq=
uests to
> > > raid disks as more as possible is more optimal.
> >=20
> > This, of course, has nothing to do with the devices rotating, and every=
thing
> > to do with there being a seek-penalty.  So why the block-device flag is
> > called "rotational" I really don't know :-(
> >=20
> > Can we make the flags that md uses be "seek_penalty" or "no_seek" or
> > something, even if the block layer has less meaningful names?
>=20
> purely borrowed from block layer. I'm ok to change it.
> =20
> > >=20
> > > 2. Getting too big request isn't always optimal. For hard disk, compa=
red to
> > > spindle move, data transfer overhead is trival, so we always prefer b=
igger
> > > request. In SSD, request size exceeds specific value, performance isn=
't always
> > > increased with request size increased.  An example is readahead. If r=
eadahead
> > > merges too big request and causes some disks idle, the performance is=
 less
> > > optimal than that when all disks are busy and running small requests.
> >=20
> > I note that the patch doesn't actually split requests, rather it avoids
> > allocating adjacent requests to the same device - is that right?
> > That seems sensible but doesn't seem to match your description so I wan=
ted to
> > check.
>=20
> Yes, it doesn't do split, sorry for the misleading. I used to think about
> split, but gave up later, but forgot to change the description. There are=
 two
> types of IO driving big request size: buffered read (readahead) buffered =
write
> and direct read or write I assume buffered write and direct read/write can
> drive high iodepth, so doing split is useless. buffered read split makes =
sense,
> which really should be 'prevent merging to big request'
>=20
> > >=20
> > > The patches try to address the issues. The first two patches are clea=
n up. The
> > > third patch addresses the first item above. The forth addresses the s=
econd item
> > > above. The idea can be applied to raid10 too, which is in my todo lis=
t.
> >=20
> > Thanks for these - there is a lot to like here.
> >=20
> > One concern that I have has that they assume that all devices are the s=
ame.
> > i.e. they are all "rotational", or none of them are.
> >      they all have the same optimal IO size.
> >=20
> > md aims to work well on heterogeneous arrays so I'll like to make it mo=
re
> > general if I can.
> > Whether to "split" adjacent requests or not is decided in the context o=
f a
> > single device (the device that the first request is queued for) so that
> > should be able to use the optimal IO size of that devices.
> >=20
> > General balancing is a little harder as the decision is made in the con=
text
> > of all active devices.  In particular we need to know how to choose bet=
ween a
> > seek-penalty device and a no-seek-penalty device, if they both have req=
uests
> > queued to them and the seek-penalty device is a long way from the targe=
t.
> >=20
> > Maybe:
> >  - if the last request to some device is within optimal-io-size of this
> >    requests, then send this request to that device.
> >  - if either of two possible devices has no seek penalty, choose the on=
e with
> >    the fewest outstanding requests.
> >  - if both of two possible devices have a seek-penalty, then choose the
> >    closest
> >=20
> > I think this will do the same as the current code for 'rotational' devi=
ces,
> > and will be close to what your code does for 'non-rotational' devices.
>=20
> This is close to what I did except for the case of one hard disk and one =
SSD.
> Talking about heterogeneous arrary, I assume people only do it with two
> different hard disks or two different ssd. Will people really mix hard di=
sk and
> SSD? A hard disk can only drive 600 IOPS while a lowend SATA SSD can driv=
e 20k
> ~ 40k IOPS. Plusing 600 to 20k doesn't significantly change IOPS.

I'm fairly sure people will try it, even if it doesn't make sense. :-)

It possibly would make sense if the slower device was marked "write-mostly",
but that disables read-balance, so what we do with read balance might be
irrelevant.

I don't want to assume devices have different speeds unless explicitly told
so, and the "rotational" flag doesn't clearly imply anything about the speed
of the device, only about seek latency.  So e.g. I wouldn't want to always
assume that a non-rotational device were faster than a rotational device,
even though that may be the case in lots of situations.

I'd be less concerned about heterogeneous arrays with RAID10 as it makes le=
ss
sense there.  But I certainly want to at least acknowledge the possibility
for RAID1.

thanks,
NeilBrown


--Sig_/9_eSDjV8A4Jozzdc5dmGtYc
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT+vSFDnsnt1WYoG5AQIOOxAAwBFQkQug9bSLcYkS42lhiaDf/PdmPAxw
UD7NVA+Dk1NJaY1g4z2+4tdEwxT4aK8SO+Cr3ZHqVMHV7Enbug4sOmR82PgDrIOm
KdDuiDV0fxuRE/U/tiyXdPEWqaOazhn8uY8CZjSk+XprQHNPCXwB3rCMUhLMP0SX
nUP0s3+77WBmvJsGxFL0gqemo5+zNxkw1VWHcw+ZotKd+B1VToxPsNK10qJrxcNj
WP8FvzOYTurD+sVOD1sgd9F/o9LgwRJaxj7p4gf5GOufVuBZ9U9VsYTNsbsMLh8+
6II4aOdtbJQNlmIaakSkUHzYnqIGaNhnPnF76rHi45nejT1DJDreM4C7sdwf2Xj/
AIWdltz0xTjwWSjpyyb6tXxtdafn47H1+LowXmOmZfz5G3xRwBK44J7jb3+XNvkV
JIWBAHCQAr83k7uoOJWYoXHINH8Ac96FJwYAdpbe4w3qkf3hIZsgrdEweHJV+PZY
oQN1AP6tfJ6aFTISKJ7W5iD8Hp/svC3JAiZnyMQi1kzla7fguQTECm2qWsc3uLBZ
SxZvTmPrmvJMit5Z1J8fMo9IrTwoKipTm65soaHVOQmtQqakUgV2aloKb8TdqAi+
sGz7GwMTeMrOGvlZPGZqa6abPJ5BHdY/Jq+RHtqOVqTUabsHjjFzDeI29vRivlLg
HknbGFKpGrk=
=lY5P
-----END PGP SIGNATURE-----

--Sig_/9_eSDjV8A4Jozzdc5dmGtYc--
