From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: high throughput storage server?
Date: Tue, 22 Mar 2011 09:46:58 +0000
Message-ID: <20110322094658.GA21078@cthulhu.home.robinhill.me.uk>
References: <20110318140509.GA26226@infradead.org>
 <4D837DAF.6060107@hardwarefreak.com>
 <20110319090101.1786cc2a@notabene.brown>
 <4D8559A2.6080209@hardwarefreak.com>
 <20110320144147.29141f04@notabene.brown>
 <AANLkTi=2k2=YuZAggonLfKmRFxFd-rXvNo=xkpqWyQNU@mail.gmail.com>
 <4D868C36.5050304@hardwarefreak.com>
 <20110321024452.GA23100@www2.open-std.org>
 <4D875E51.50807@hardwarefreak.com>
 <20110321221304.GA900@www2.open-std.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110321221304.GA900@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, Mdadm <linux-raid@vger.kernel.org>, Roberto Spadim <roberto@spadim.com.br>, NeilBrown <neilb@suse.de>, Christoph Hellwig <hch@infradead.org>, Drew <drew.kay@gmail.com>
List-Id: linux-raid.ids


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon Mar 21, 2011 at 11:13:04 +0100, Keld J=F8rn Simonsen wrote:

> On Mon, Mar 21, 2011 at 09:18:57AM -0500, Stan Hoeppner wrote:
> >=20
> > > Anyway, with 384 spindles and only 50 users, each user will have in
> > > average 7 spindles for himself. I think much of the time this would m=
ean=20
> > > no random IO, as most users are doing large sequential reading.=20
> > > Thus on average you can expect quite close to striping speed if you
> > > are running RAID capable of striping.=20
> >=20
> > This is not how large scale shared RAID storage works under a
> > multi-stream workload.  I thought I explained this in sufficient detail.
> >  Maybe not.
>=20
> Given that the whole array system is only lightly loaded, this is how I
> expect it to function. Maybe you can explain why it would not be so, if
> you think otherwise.
>=20
If you have more than one system accessing the array simultaneously then
your sequential IO immediately becomes random (as it'll interleave the
requests from the multiple systems). The more systems accessing
simultaneously, the more random the IO becomes. Of course, there will
still be an opportunity for some readahead, so it's not entirely random
IO.

> it is probably not the concurrency of XFS that makes the parallelism of
> the IO. It is more likely the IO system, and that would also work for
> other file system types, like ext4. I do not see anything in the XFS allo=
cation
> blocks with any knowledge of the underlying disk structure.=20
> What the file system does is only to administer the scheduling of the
> IO, in combination with the rest of the kernel.
>=20
XFS allows for splitting the single filesystem into multiple allocation
groups. It can then allocate blocks from each group simultaneously
without worrying about collisions. If the allocation groups are on
separate physical spindles then (apart from the initial mapping of a
request to an allocation group, which should be a very quick operation),
the entire write process is parallelised.  Most filesystems have only a
single allocation group, so the block allocation is single threaded and
can easily become a bottleneck. It's only once the blocks are allocated
(assuming the filesystem knows about the physical layout) that the
writes can be parallelised. I've not looked into the details of ext4
though, so I don't know whether it makes any moves towards parallelising
block allocation.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk2IcBEACgkQShxCyD40xBIHwACgq/Nabna31PJwMf5mZwGLIKS0
opAAn2wN5gmwDZl/s02fyDPDVz5zeCzN
=o2xQ
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
