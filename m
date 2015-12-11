From: NeilBrown <neilb@suse.com>
Subject: Re: [RFC] using mempools for raid5-cache
Date: Fri, 11 Dec 2015 11:09:58 +1100
Message-ID: <87poyddew9.fsf@notabene.neil.brown.name>
References: <1449072638-15409-1-git-send-email-hch@lst.de> <876108qwz5.fsf@notabene.neil.brown.name> <20151209012812.GA2403138@devbig084.prn1.facebook.com> <87vb88p1tm.fsf@notabene.neil.brown.name> <20151210234047.GA3596673@devbig084.prn1.facebook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20151210234047.GA3596673@devbig084.prn1.facebook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 11 2015, Shaohua Li wrote:

> On Wed, Dec 09, 2015 at 05:34:45PM +1100, NeilBrown wrote:
>> On Wed, Dec 09 2015, Shaohua Li wrote:
>>=20
>> > On Wed, Dec 09, 2015 at 11:36:30AM +1100, NeilBrown wrote:
>> >> On Thu, Dec 03 2015, Christoph Hellwig wrote:
>> >>=20
>> >> > Currently the raid5-cache code is heavily relying on GFP_NOFAIL all=
ocations.
>> >> >
>> >> > I've looked into replacing these with mempools and biosets, and for=
 the
>> >> > bio and the meta_page that's pretty trivial as they have short life=
 times
>> >> > and do make guaranteed progress.  I'm massively struggling with the=
 iounit
>> >> > allocation, though.  These can live on for a long time over log I/O=
, cache
>> >> > flushing and last but not least RAID I/O, and every attempt at some=
thing
>> >> > mempool-like results in reproducible deadlocks.  I wonder if we nee=
d to
>> >> > figure out some more efficient data structure to communicate the co=
mpletion
>> >> > status that doesn't rely on these fairly long living allocations fr=
om
>> >> > the I/O path.
>> >>=20
>> >> Presumably the root cause of these deadlocks is that the raid5d thread
>> >> has called
>> >>    handle_stripe -> ops_run_io ->r5l_write_stripe -> r5l_log_stripe
>> >>       -> r5l_get_meta -> r5l_new_meta
>> >>=20
>> >> and r5l_new_meta is blocked on memory allocation, which won't complete
>> >> until some raid5 stripes get written out, which requires raid5d to do
>> >> something more useful than sitting and waiting.
>> >>=20
>> >> I suspect a good direction towards a solution would be to allow the
>> >> memory allocation to fail, to cleanly propagate that failure indicati=
on
>> >> up through r5l_log_stripe to r5l_write_stripe which falls back to add=
ing
>> >> the stripe_head to ->no_space_stripes.
>> >>=20
>> >> Then we only release stripes from no_space_stripes when a memory
>> >> allocation might succeed.
>> >>=20
>> >> There are lots of missing details, and possibly we would need a separ=
ate
>> >> list rather than re-using no_space_stripes.
>> >> But the key idea is that raid5d should never block (except beneath
>> >> submit_bio on some other device) and when it cannot make progress
>> >> without blocking, it should queue the stripe_head for later handling.
>> >>=20
>> >> Does that make sense?
>> >
>> > It does remove the scary __GFP_NOFAIL, but the approach is essentially
>> > idential to a 'retry after allocation failure'. Why not just let the mm
>> > (with __GFP_NOFAIL) to do the retry then?
>> >
>>=20
>> Because deadlocks.
>>=20
>> If raid5d is waiting for the mm to allocated memory, then it cannot
>> retire write requests which could free up memory.
>
> Ok, I missed the deadlock issue. Looks raid5d can't sleep waitting for
> memory. That means the mempool for metadata page/bio doesn't work too,
> as raid5d might block and not dispatch previous IO. Your proposal looks
> reasonable.

raid5d mustn't sleep waiting for something that only raid5d can provide.

A bio allocated from a mempool will be returned to that mempool when the
IO request completes (if the end_io routine calls bio_put, which it
does).
So when waiting on a mempool for a bio, you are only waiting for some
underlying device to perform IO, you are not waiting for anything that
raid5d might do.  So that is safe.

Similarly the meta_page is freed in the end_io function, so it is safe
to wait for that.
Note that the important feature of a mempool is not so much that it
pre-allocates some memory.  The important point is that when that
pre-allocated memory is freed it can *only* be used by the owner of the
mempool.
By contrast memory allocated with NOFAIL, when freed might be used by
any other caller anywhere in the kernel.
So waiting on a mempool means waiting for certain well defined events.
Waiting in NOFAIL could end up waiting for almost anything.  So it is
much harder to reason about deadlocks.

The bio and the meta_page contrast with the r5l_io_unit which isn't
freed by the first end_io, but remains until raid5d has done some more
work.  So raid5d cannot wait for a r5l_io_unit to be freed.

NeilBrown

>
> Would keeping NOFAIL and having a separate thread got r5l_log_stripe
> work too?
>
> Thanks,
> Shaohua

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWahRWAAoJEDnsnt1WYoG5c+YP/2VbdmApZgTdJH81jlti7weo
QcKrtxEtAcX2VmOnhs+w9e/xqyybPOf4h5O5AAvhZsnMOmc0vNnBgyEMXvEYrI2X
yZbGUxo2LkO79EHfusFg0/FWvY87QX+yKZpuqpDl33QXn1yBZ6Zws6jy5z0M0sAH
d7N+n7l9p1eNz6Nd5uvK5JR8YZ7tP/g/oG0IPX8nBeXPmPYvc7n2B2Rkaj4qIRYq
6kUNgnOsQF9WDTTBU2VxDQpVs161CGGnCMVbkU+quqGSoxbnyCBsISeuMojZfg5b
ydQgjbXjHBd7prgAoi9gYIn1Ssehy5MgsMFY4iHNY6boHVIYr4VnVTMixwWLUBC5
eEzJ+MkzV8GESo2bcDiMyzu+9pf4E315fiemD2WLQcode/ZDZ5NKKbIO8kxCD2pw
OsEDRqX15gPp0Ck8qkb2qteC71Q3utaJ+YtI7PNuFkMTcv+KiegMmSFkV1o5cafj
e7CZa3egv9/oWOHN6eI0aoFSiXR1XCdzEZUCw4dlM/bsWwCoaVxNh6xU+rEDHjZ3
b8p6uC1dvoVy4ladzH1nUzNCN+YlZ1HFZJF2P2YTJu9XGT7dsHR4a/Pm8nShbDe/
mTXlWJk1aqQHA0XaiArWnc8cCfyG+z7rCwjHKh2MHe3l/Xa0jbRAtZDeiCMZ0RoC
/6ulBCeFIpagO165n/Dz
=f32c
-----END PGP SIGNATURE-----
--=-=-=--
