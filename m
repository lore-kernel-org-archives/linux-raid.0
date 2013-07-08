From: NeilBrown <neilb@suse.de>
Subject: Re: some general questions on RAID
Date: Mon, 8 Jul 2013 14:48:23 +1000
Message-ID: <20130708144823.5cc872b9@notabene.brown>
References: <1372962602.8716.56.camel@heisenberg.scientia.net>
	<51D5F22C.70007@turmel.org>
	<1372980882.5249.88.camel@fermat.scientia.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/U.Enegi5HHzv9xqqOGQWJAS"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372980882.5249.88.camel@fermat.scientia.net>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/U.Enegi5HHzv9xqqOGQWJAS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 05 Jul 2013 01:34:42 +0200 Christoph Anton Mitterer
<calestyo@scientia.net> wrote:


>=20
> > > 2) Chunks / Chunk size
> > > a) How does MD work in that matter... is it that it _always_ reads
> > > and/or writes FULL chunks?
> >
> > No.  It does not.  It doesn't go below 4k though.
> So what does that mean exactly? It always reads/writes at least 4k
> blocks?

RAID1 reads or writes whatever block size the filesystem sends
RAID0,10 read or write whatever block size the filesystem sends up to the
chunk size (and obviously less than chunksize when not aligned with the
chunksize).

RAID4/5/6 read the same as RAID0 when not degraded.
When degraded or when writing, RAID4/5/6 does all IO in 4K blocks (hoping
that the lower layers will merge as appropriate).

>=20
>=20
> > > Guess it must at least do so on _write_ for the RAID levels with pari=
ty
> > > (5/6)... but what about read?
> > No, not even for write.
> :-O
>=20
> > If an isolated 4k block is written to a raid6,
> > the corresponding 4k blocks from the other data drives in that stripe
> > are read, both corresponding parity blocks are computed, and the three
> > blocks are written.
> okay that's clear... but uhm... why having chuk sizes then? I mean
> what's the difference when having a 128k chunk vs. a 256k one... when
> the parity/data blocks seem to be split in 4k blocks,... or did I get
> that completely wrong?

A sequential read that only hits one chunk will be served faster than one
which hits two chunks.  So making the chunksize 1-2 times your typical block
size for random reads can help read performance.
For very large sequential reads it shouldn't really matter though large chu=
nk
sizes tend to result in larger IO requests to the underlying devices.
For very small random reads it shouldn't really matter either.

For writes, you want the stripe size (chunksize * (drives - parity_drives))
to match the typical size for writes - and you want those writes to be
aligned.

So the ideal load is smallish reads and largish writes with a chunksize
between the two.

>=20
>=20
> > > And what about read/write with the non-parity RAID levels (1, 0, 10,
> > > linear)... is the chunk size of any real influence here (in terms of
> > > reading/writing)?
> > Not really.  At least, I've seen nothing on this list that shows any
> > influence.
> So AFAIU now:
> a) Regardless the RAID level and regardless the chunk size,
>    - data blocks are read/written in 4KiB blocks
>    - when there IS parity information... then that parity information is =
_ALWAYS_ read/computed/written in 4KiB blocks.
> b) The chunks basically just control how much consecutive data is on one
> device, thereby allowing to speed up / slow down reads/write for small /
> large files.
> But that should basically only matter on seeking devices, i.e. not on
> SSDs... thus the chunk size is irrelevant on SSDs...

Seeks are cheaper in SSDs than on spinning rust but the cost is not zero.

If you are concerned about the effect of chunksize on performance, you shou=
ld
measure the performance of your hardware with your workload with differing
chunk sizes and come to your own conclusion.
All anyone else can do is offer generalities.

NeilBrown

--Sig_/U.Enegi5HHzv9xqqOGQWJAS
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUdpElznsnt1WYoG5AQL3Bg//Z5FHYghLw+jRKrwGfc/HFXgVrFGj+xnl
Nzy1rcgAeznFy2tvdxwVWwVicr7+DqKhnRGU0rOelZ9FGkyCu95RKS83iuYJrk31
EJ7rBDRs5KQll7VGM7DfsSs1KHTXSdEZTz3tkk4RdZL0IbPj6VMSA85ai/+jiC+m
bZis4TISLqPsAHePplya6eOf4XLK+lbhAkQhm0Wc9tyCPQ/16I3BUq0j9lU1f0f/
0bvaaCUNBYyINkeotlrgmZf4FkRoKnmYNtiCNeUifBlHoy3nhZVATF18X0P3/YsC
QO3EB+sDW6djAxiWT3BAfjdn1Znw2+nDWTRMiNEwsB6ScFTecdrVHWVQAP4SDj+D
of9FFEErTUDgXJKVNIW3we6h29jTti6QjiBgw3Gr981PdNVbBVFtk1E4X+vHCCeK
sKiwCyKf1Gyy9eXB9KqW+hOkqUjD+ykZtrTJzrS26F0nTcOs7sNFhAZW7+jFTa5H
SUVx5IjYDBAxEkhknLbUk4kttAcERTDH8SU1noU2S6jkvlHLG0KmOURKkdamO/2M
kjr8uvCHppPV5e1nN0QAd+3WIB0wASzo19hy0Tt4KUL49GgfeCZl+VguzF/DDNt5
bTGynCxfDPhypL/dDbgCgWsTz7XXSUgziFc3SS5csvtYG8KqDfFVxwfRR3987hOR
baf3nTFo8c4=
=kPar
-----END PGP SIGNATURE-----

--Sig_/U.Enegi5HHzv9xqqOGQWJAS--
