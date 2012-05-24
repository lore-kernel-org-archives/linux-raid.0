From: NeilBrown <neilb@suse.de>
Subject: Re: Sequential writing to degraded RAID6 causing a lot of reading
Date: Thu, 24 May 2012 14:48:22 +1000
Message-ID: <20120524144822.747b446b@notabene.brown>
References: <CAAOsTSmnbtejYvjoMpdOzrGFM0+PW45uuf-uBNkR4HUkgyaWDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/n6kiB0_4bvA4/eD7mrCS=17"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAOsTSmnbtejYvjoMpdOzrGFM0+PW45uuf-uBNkR4HUkgyaWDg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: patrik@dsl.sk
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/n6kiB0_4bvA4/eD7mrCS=17
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, 23 May 2012 21:01:09 +0200 Patrik Horn=EDk <patrik@dsl.sk> wrote:

> Hello boys,
>=20
> I am running some RAID6 arrays in degraded mode, one with
> left-symmetry layout and one with left-symmetry-6 layout. I am
> experiencing (potentially strange) behavior that degrades performance
> of both arrays.
>=20
> When I am writing sequentially a lot of data to healthy RAID5 array,
> it also reads internally a bit of data. I have data on arrays, so I
> only write through the filesystem. So I am not sure what causing the
> reads, if writing through filesystem potentially causes skipping and
> not writing whole stripes  or sometimes timing causes that the whole
> stripe is not written at the same time. But anyway there is only a
> small ratio of reads and the performance is almost OK.
>=20
> I cant test it with full healthy RAID6 array, because I dont have any
> at the moment.
>=20
> But when I write sequentially to RAID6 without one drive (again
> through filesystem) I get almost exactly the same amount of internal
> reads as writes. Is it by design and is this expected behaviour? Why
> does it behave like this? It should behave exactly like healthy RAID5,
> it should detect the writing of whole stripe and should not read
> (almost) anything.

"It should behave exactly like healthy RAID5"

Why do you say that?  Have you examined the code or imagined carefully how
the code would work?

I think what you meant to say "I expect it would behave exactly like healthy
READ5".  That is a much more sensible statement.  It is even correct.  It
just your expectations that are wrong :-)
(philosophical note: always avoid the word "should" except when applying it
to yourself).

Firstly, degraded RAID6 with a left-symmetric layout is quite different from
an optimal RAID5 because there are Q blocks sprinkled around and some D
blocks missing.  So there will always be more work to do.

Degraded left-symmetric-6 is quite similar to optimal RAID5 as the same data
is stored in the same place - so reading should be exactly the same.
However writing is generally different and the code doesn't make any attempt
to notice and optimise cases that happen to be similar to RAID5.

A particular issue is that while RAID5 does read-modify-write when updating=
 a
single block in an array with 5 or more devices (i.e. it reads the old data
block and the parity block, subtracts the old from parity and adds the new,
then writes both back), RAID6 does not. It always does a reconstruct-write,
so on a 6-device RAID6 it will read the other 4 data blocks, compute P and =
Q,
and write them out with the new data.
If it did read-modify-write it might be able to get away with reading just =
P,
Q, and the old data block - 3 reads instead of 4.  However subtracting from
the Q block is more complicated that subtracting from the P block and has n=
ot
been implemented.


But that might not be the issue you are hitting - it simply shows that RAID6
is different from RAID5 in important but non-obvious ways.

Yes, RAID5 and RAID6 do try to detect whole-stripe write and write them out
without reading.  This is not always possible though.
Maybe if you told us how many devices were in your arrays (which may be
import to understand exactly what is happening), what the chunk size is, and
exactly what command you use to write "lots of data".  That might help
understand what is happening.

NeilBrown

--Sig_/n6kiB0_4bvA4/eD7mrCS=17
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT729lznsnt1WYoG5AQIvwQ//bCU1BdGYKWzmeQjgpuaYpuwZI4TfO9/7
dCAz/qc/Ux6Loqaf/1Zp7gOuDRB/xuFYhHJkfGeGg5qPZFTMgk3aJn0QMaUrr6iQ
Rg3jWtOmcydEFydCwv67ME4JGO7rzJwdrn3GMXAIzWsrLcXofhWBBBvwtOy4VVXv
fNcMQFNZcXESzXVEZiNSVNhXgjIWeDTC5FT4p2GCMQmX+NB8TdbgzBxW1X7AQygf
swcnvmHFWHxHcwqqXMzGcoQHSmf+rjQEf0le8LIp/szKJRGxN8QFD0AoJY4Vwdl7
UUK7Wbe13pcRBLl4SraPeutsJ4PxiSTXpWXJvGl/JgTtnTXGm+5fq2Gn5AAkq+C0
jnfPDLv3BGIMGYmtTlKoBz9rNAPuyHqWCowoq/N4EJ1ym+Au6uzbrTU4FDMfcHiE
8KnDnGb0ZNh2MlbCe9qSGbXqwK7dUJS6n2hF6o8DYqcxfexCF5ZuRsUcyN/uIZvk
77jDFyuSioK7lNE+56yeifUhBeUkihQW/L7p0TbvJhxWXYT4j0pAm9R1cPgA9Yxy
gfictFRShpYU6og1IJOiwP/qG76h292wLqDz2Vg0OpleY7TxxBP319shAadZ4Lc8
KRxpFr6ya8Ty6b8ce5Co5CnNVFIp+mAfHgozjeiLzE41rOSPqkqC7xTE+ECPVs+6
P5BVrdFHA58=
=HQSs
-----END PGP SIGNATURE-----

--Sig_/n6kiB0_4bvA4/eD7mrCS=17--
