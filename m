From: NeilBrown <neilb@suse.de>
Subject: Re: Status of discard support in MD RAID
Date: Mon, 15 Sep 2014 13:44:55 +1000
Message-ID: <20140915134455.342e5f80@notabene.brown>
References: <1ED0286A-56DA-491D-853A-1C1045449201@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/utvr6Q1aSlb+Td7K5mTwP0W"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1ED0286A-56DA-491D-853A-1C1045449201@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brassow Jonathan <jbrassow@redhat.com>
Cc: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/utvr6Q1aSlb+Td7K5mTwP0W
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 11 Sep 2014 18:38:11 -0500 Brassow Jonathan <jbrassow@redhat.com>
wrote:

> Neil (or anyone else),
>=20
> I know that trim/discard support was added back in 2012 (commit 9db90880)=
.  However, I thought there were still issues regarding what happens when v=
arious sync operations occur.  I'd like to turn on discard support in dm-ra=
id.c (a oneline patch) if things are in order.  I can enable any, all or no=
ne depending on your recommendation.  (I assume RAID1/10 is easier than the=
 parity RAIDs.)

The worst that a sync operation can do is report mismatches and "un-trim"
some (or all) of some devices.
It certainly should never corrupt data.

My perception is that enabling discard support in the filesystem can be good
for some devices and bad for other devices but should always be "safe" even
when not "optimal".  I think the same is true for md/raid.

For raid5/6, we only honour discard if the underlying devices report
discarded regions as all-zeros.  That make it safe enough I believe.

So I'd suggest: turn it on!

NeilBrown

--Sig_/utvr6Q1aSlb+Td7K5mTwP0W
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVBZguDnsnt1WYoG5AQKfLw/+IAbB/AgKefKpfS5NPrx04F+E3W/1dJrD
cH6+fJqGgK/bZWK32XHCubqqZcBzHLlQi0iL/lBfLeko8Gv5QtHdulGqZ6P4QP4k
iwk+aWiaUZKuGXsgFnlSaV6CwBeLZEzmzrAiyQNBJdTde7SsNp10w/3TX0vFxSSl
kVBhjWHEFmRQo7qFnD03FxnP/nm3mL1VoT6hbXEx1qjKpKKvIS0G3goVq3j4hAAh
gV2/NOMu4EkRqkzDIuqAnzEhPmt0/3swW+GEfUlph1DocVCVnzLo1jzZXdRjA2fy
AseWnbtMEPA/8OdTKPyqOM6eYLrFbon6PMIdzzdFCStOhJt6vuKk1AK5CKZSSPkc
fXfIkCbZeRd4j2LOX+skGVlHIxLpGWdfWPCZCHhbZDbXnp1F35VHA63/qopRJUwY
Mb81KYh5kQru2o+DwtSZq5xW2PdHYp8zPInmNmxN80WUX6RV4hD0zo28XHhDk0gZ
wYJmDmaerNFOVjuynems791CqikePDP0ILhPBpiYS0wzN3G6GA1+xu8BVxBcuvsE
IxvPydZbgEApojm8TbR5gPFFyL8wvbYlEotiZg6kHh5zfb7k4pUdYZk7qvGzMHAo
ZFOBZnKsKGJDLMyB1JFZU8Afy2oTGxm+qh5Nmso62yc3PdAa7DeQpkzFRDg/028t
n7I50+pNt9Y=
=Ersm
-----END PGP SIGNATURE-----

--Sig_/utvr6Q1aSlb+Td7K5mTwP0W--
