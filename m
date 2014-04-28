From: NeilBrown <neilb@suse.de>
Subject: Re: [RFC]raid5: add an option to avoid copy data from bio to stripe
 cache
Date: Mon, 28 Apr 2014 20:08:43 +1000
Message-ID: <20140428200843.5b32cf8b@notabene.brown>
References: <20140428065841.GA28726@kernel.org>
	<20140428170628.5587b6a1@notabene.brown>
	<20140428072821.GB28726@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/cYKkyLuiYErul9wkqMtkyId"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140428072821.GB28726@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/cYKkyLuiYErul9wkqMtkyId
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 28 Apr 2014 15:28:21 +0800 Shaohua Li <shli@kernel.org> wrote:

> On Mon, Apr 28, 2014 at 05:06:28PM +1000, NeilBrown wrote:
> > On Mon, 28 Apr 2014 14:58:41 +0800 Shaohua Li <shli@kernel.org> wrote:
> >=20
> > >=20
> > > The stripe cache has two goals:
> > > 1. cache data, so next time if data can be found in stripe cache, dis=
k access
> > > can be avoided.
> > > 2. stable data. data is copied from bio to stripe cache and calculate=
d parity.
> > > data written to disk is from stripe cache, so if upper layer changes =
bio data,
> > > data written to disk isn't impacted.
> > >=20
> > > In my environment, I can guarantee 2 will not happen. For 1, it's not=
 common
> > > too. block plug mechanism will dispatch a bunch of sequentail small r=
equests
> > > together. And since I'm using SSD, I'm using small chunk size. It's r=
are case
> > > stripe cache is really useful.
> > >=20
> > > So I'd like to avoid the copy from bio to stripe cache and it's very =
helpful
> > > for performance. In my 1M randwrite tests, avoid the copy can increas=
e the
> > > performance more than 30%.
> > >=20
> > > Of course, this shouldn't be enabled by default, so I added an option=
 to
> > > control it.
> >=20
> > I'm happy to avoid copying when we know that we can.
> >=20
> > I'm not really happy about using a sysfs attribute to control it.
> >=20
> > How do you guarantee that '2' won't happen?
> >=20
> > BTW I don't see '1' as important.  The stripe cache is really for gathe=
ring
> > writes together to increase the chance of full-stripe writes, and for
> > handling synchronisation between IO and resync/reshape/etc. The copying=
 is
> > primarily for stability.
>=20
> We are using raid5 in a SCSI target appliance. BIO is dispatched from a S=
CSI
> target layer (like LIO) and no filesytem is involved, so I can guarantee =
the
> BIO data is stable.
>=20
> What's your favorite way to control it?

I would like a bio flag with the meaning "this data is stable until bi_end_=
io
is called".

I had hoped something like that would come of out the stable-pages effort,
but that focussed on meeting the needs for filesystems more than that needs
of devices.
Maybe we just need to make one ourselves.

NeilBrown

--Sig_/cYKkyLuiYErul9wkqMtkyId
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU14oqznsnt1WYoG5AQLm+w/7B6kdUBM+YZj5pPTP+8lfITFzhYCQDJbT
s3JRNhrudp3K4AJaWYMqpRerj0/gZwdpol2IPMz718vIQt0v/nxm5cO9V7ZtwbgA
oiSbvCnKCIbjckLf7FfLrcbNU+Ui5HBvyx5Hyf3mRZClMAuWT6Yhbav7gBeoSDve
Hu33DbvnvhfygVxLE4Z1rWSnQQmvShS93d+GrJqZ7XL0uM5rhjKTnmqVxsOmK57+
xwWl+mb6OtxOKUQCBp0qVyNa6LzH/F/o9KPjEdcm+x5WIKWnlnPrFT/y9VBt2OWZ
5FHJBnmrK5dyTVftCjSudertpbcxuIhJld6qmT0R6L6jRKLbShRn/tpS2AvNa/zm
7XXEae/NuwaWyEsbhq0jk4MXKgGYi7+PyEFp2ynvwNajIvJZsTxeKM9hWYJocDJC
BGWyxnuvDgs/W4MywbKHsQnTiBNV6GJstS+spDwc02ObPF2xAZIByXamvMQ6OCiF
4JM23SZCSEZowrzXpK+mVTK9CQKJCgUZQKf2kd1kF7wiUzrmqn9q7CVev6cz383n
oQC+BbspCHalfN4L95Ror1ak1LvgS4BOWvujMQmEG6YLO/DO5iBgfjv/dW4bz2cN
3mGE5U1FUAPo2H80Q0mKKrtv+SB9tje54OapbTgYV07MCOgqL7EchkzzRtPgI1Vo
bsxlp3Jkyww=
=my+o
-----END PGP SIGNATURE-----

--Sig_/cYKkyLuiYErul9wkqMtkyId--
