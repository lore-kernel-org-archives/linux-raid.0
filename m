From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Bad sequential performance of RAID5 with a lot of disk seeks
Date: Tue, 7 Oct 2014 10:25:48 +0100
Message-ID: <20141007092548.GC18786@cthulhu.home.robinhill.me.uk>
References: <54336FC1.6080306@gautschi.net>
 <20141007074347.GA18786@cthulhu.home.robinhill.me.uk>
 <20141007095422.Horde.3l6BckPhfY5U8dchaOdLNA1@webmail.gautschi.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GPJrCs/72TxItFYR"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141007095422.Horde.3l6BckPhfY5U8dchaOdLNA1@webmail.gautschi.net>
Sender: linux-raid-owner@vger.kernel.org
To: "P. Gautschi" <linuxlist@gautschi.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--GPJrCs/72TxItFYR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Oct 07, 2014 at 09:54:22AM +0200, P. Gautschi wrote:

> Quoting Robin Hill <robin@robinhill.me.uk>:
> > On Tue Oct 07, 2014 at 06:44:49AM +0200, P. Gautschi wrote:
> >
> >> I've created a RAID5 on 5 identical SATA disks. Doing some =20
> >> performance measurements
> >> with dd I get a disappointing performance.
> >> A dd with bs=3D1M on a btrfs created on md0 transfers about 110 MB/s. =
=20
> >> (both read and write)
> >> A dd on md0 has the same write speed but only about 20 MB/s on read.
> >> In all of the tests I hear the disk constantly seeking. This was =20
> >> also the case
> >> during creation of the array.
> >> I also created a RAID4 to make sure that I doesn't get fooled by =20
> >> the stripe layout of RAID5.
> >> Now I get about 110 MB/s for write and 230 MB/s for read on md0. =20
> >> But the constant
> >> seeking is still present for both read and write and during =20
> >> creation of the array.
> >>
> >> Why are the disk perform so many seek operations? I think a =20
> >> sequential access on md0 should
> >> cause a sequential access on the individual disk.
> >>
> >> I have to add that I did something unusual: I created the RAID4/5 =20
> >> with a chunk size of 4KiB.
> >> The idea of this was that when I'm going to use btrfs with the =20
> >> default nodesize of 16KiB
> >> all node write will fill a full stripe and there won't be any RMW =20
> >> at all. (both fortunate
> >> for performance and integrity in a power loss situation.)
> >> Nevertheless I think a sequential access on the array should cause =20
> >> a sequential access on the
> >> disks for any chunk size if the read/write block size is a exact multi=
ple of
> >> the (numdisks-1)*chunk size.
> >>
> >> Is there any explanation for the seeks and how do I get rid of them?
> >>
> > After creating the arrays did you wait for them to finish syncing? The
> > array is created in degraded mode initially and then rebuilds onto the
> > additional disk (this is the fastest way to do things, unless you know
> > the disks are all zeroed initially). Until this rebuild is complete then
> > it'll be competing with any other disk activity.
> >
> Yes I did wait for the syncing to complete before accessing md0.
> I had the seeks during the syncing and afterwards when reading or =20
> writing to the array.
>=20
Hmm, shouldn't be seeking then.

What does the SMART info show for the drives - are there any reallocated
blocks? A large number of those scattered over the disk would certainly
cause seeking for both reads and writes.

It's also worth checking whether there's anything else that would be
accessing the disks in the background (monitoring/indexing/etc).

I can't think of anything else that would be causing reads to seek - SMR
disks or write-intent bitmaps would only affect writes.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--GPJrCs/72TxItFYR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlQzsZsACgkQShxCyD40xBJhawCgp3TqpjBDv5hMBLvm8npvMfXd
OpIAnRU9nAi4Udnt3kZ+4ZW8RDR+Wcr+
=XHPQ
-----END PGP SIGNATURE-----

--GPJrCs/72TxItFYR--
