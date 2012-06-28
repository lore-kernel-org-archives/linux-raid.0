From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 0/4 v2] optimize raid1 read balance for SSD
Date: Thu, 28 Jun 2012 11:06:16 +1000
Message-ID: <20120628110616.79d4481e@notabene.brown>
References: <20120613090922.971820942@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/selF8pfYEeVwd67yQMCeoBy"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120613090922.971820942@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk
List-Id: linux-raid.ids

--Sig_/selF8pfYEeVwd67yQMCeoBy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 13 Jun 2012 17:09:22 +0800 Shaohua Li <shli@kernel.org> wrote:

> raid1 read balance is an important algorithm to make read performance opt=
imal.
> It's a distance based algorithm, eg, for each request dispatch, choose di=
sk
> whose last finished request is close the request. This is great for hard =
disk.
> But SSD has some special characteristics:
>=20
> 1. nonrotational. Distance means nothing for SSD, though merging small rq=
uests
> to big request is still optimal for SSD. If no merge, distributing rquest=
s to
> raid disks as more as possible is more optimal.

This, of course, has nothing to do with the devices rotating, and everything
to do with there being a seek-penalty.  So why the block-device flag is
called "rotational" I really don't know :-(

Can we make the flags that md uses be "seek_penalty" or "no_seek" or
something, even if the block layer has less meaningful names?

>=20
> 2. Getting too big request isn't always optimal. For hard disk, compared =
to
> spindle move, data transfer overhead is trival, so we always prefer bigger
> request. In SSD, request size exceeds specific value, performance isn't a=
lways
> increased with request size increased.  An example is readahead. If reada=
head
> merges too big request and causes some disks idle, the performance is less
> optimal than that when all disks are busy and running small requests.

I note that the patch doesn't actually split requests, rather it avoids
allocating adjacent requests to the same device - is that right?
That seems sensible but doesn't seem to match your description so I wanted =
to
check.

>=20
> The patches try to address the issues. The first two patches are clean up=
. The
> third patch addresses the first item above. The forth addresses the secon=
d item
> above. The idea can be applied to raid10 too, which is in my todo list.

Thanks for these - there is a lot to like here.

One concern that I have has that they assume that all devices are the same.
i.e. they are all "rotational", or none of them are.
     they all have the same optimal IO size.

md aims to work well on heterogeneous arrays so I'll like to make it more
general if I can.
Whether to "split" adjacent requests or not is decided in the context of a
single device (the device that the first request is queued for) so that
should be able to use the optimal IO size of that devices.

General balancing is a little harder as the decision is made in the context
of all active devices.  In particular we need to know how to choose between=
 a
seek-penalty device and a no-seek-penalty device, if they both have requests
queued to them and the seek-penalty device is a long way from the target.

Maybe:
 - if the last request to some device is within optimal-io-size of this
   requests, then send this request to that device.
 - if either of two possible devices has no seek penalty, choose the one wi=
th
   the fewest outstanding requests.
 - if both of two possible devices have a seek-penalty, then choose the
   closest

I think this will do the same as the current code for 'rotational' devices,
and will be close to what your code does for 'non-rotational' devices.

There may well be room to improve this, but a key point is that it won't wo=
rk
to have two separate balancing routines - one for disks and one for ssds.
I'm certainly happy for raid1_read_balance to be split up if it is too big,
but I don't think that they way the first patch splits it is useful.

Would you be able to try something like that instead?

BTW, in a couple of places you use an 'rdev' taken out of the 'conf'
structure without testing for NULL first.  That isn't safe.
We get the 'rdev' at the top of the loop and test for NULL and other things.
After that you need to always use *that* rdev value, don't try to get it out
of the conf->mirrors structure again.

Thanks,
NeilBrown


--Sig_/selF8pfYEeVwd67yQMCeoBy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT+uuCDnsnt1WYoG5AQITyQ//Si20SeG+ZgFP1YZUdVkbZBdoXRpLUU0l
Qjrs24OxRxemoez/jhZwlsOy/rx6MPflfD8EJWQtaW0t64Ij8xBR16Q1eCTticKc
VgDnRVR165Wr8duv2zggl1TeDlc8lKo7cgYXGMZLVOA7nlFkMNPBt4WT2idrDLRU
1r/BpvXR7SvpilDe/UMRHs4epGOuv0AeW+uUFNVOPv8IL867RDyNp7jVoXF8lV7X
+Ouuf7/tGl1BY3VlDNdkeGHT6zswTl/Iw3W8cn+8ITtQQuJlx0//Be0rn7u++mwy
woOpE5jmLo4z/+46qrkynSlP3nyOfhIlDEohsfBUY/qWrBMC8BdwNRpDCmMmM1Je
QndDcq4T7cbx6D1+8J9q47cOwj7gql7EIs/iqixysJfaljlGvTgSrrq1l7miAl7y
+94MeCZzLBaj4xBC2XtGpguIUCk3SAC6bo3R7Vd+klnVvJlML/veG3ioQ7zLimJH
ROaA0XVXtE/xX090EOH56h5wbsmuQC+Y1pUKJZWVsTmyk6GxGs1bKdtTOssYPWA5
miZx3vLQ3bhHTXuQD8wd6YpfVNVJw1vYHNX7RiClNlRL3WRUETZo/UF3NhrCrKGS
3U5ZhQiSe592tOz8MUBx0cV5fYY3dIio+nekkAuQyg2Q2eVZStQ8QB6SFsFOGpDK
DUlYu9wnzlw=
=DGSW
-----END PGP SIGNATURE-----

--Sig_/selF8pfYEeVwd67yQMCeoBy--
