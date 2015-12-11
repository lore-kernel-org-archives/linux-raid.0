From: NeilBrown <neilb@suse.com>
Subject: Re: [RFC] using mempools for raid5-cache
Date: Fri, 11 Dec 2015 12:56:04 +1100
Message-ID: <87k2old9zf.fsf@notabene.neil.brown.name>
References: <1449072638-15409-1-git-send-email-hch@lst.de> <876108qwz5.fsf@notabene.neil.brown.name> <20151209012812.GA2403138@devbig084.prn1.facebook.com> <87vb88p1tm.fsf@notabene.neil.brown.name> <20151210234047.GA3596673@devbig084.prn1.facebook.com> <87poyddew9.fsf@notabene.neil.brown.name> <20151211011049.GA3810341@devbig084.prn1.facebook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20151211011049.GA3810341@devbig084.prn1.facebook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 11 2015, Shaohua Li wrote:

> On Fri, Dec 11, 2015 at 11:09:58AM +1100, NeilBrown wrote:
>> On Fri, Dec 11 2015, Shaohua Li wrote:
>>=20
>> > On Wed, Dec 09, 2015 at 05:34:45PM +1100, NeilBrown wrote:
>> >> On Wed, Dec 09 2015, Shaohua Li wrote:
>> >>=20
>> >> > On Wed, Dec 09, 2015 at 11:36:30AM +1100, NeilBrown wrote:
>> >> >> On Thu, Dec 03 2015, Christoph Hellwig wrote:
>> >> >>=20
>> >> >> > Currently the raid5-cache code is heavily relying on GFP_NOFAIL =
allocations.
>> >> >> >
>> >> >> > I've looked into replacing these with mempools and biosets, and =
for the
>> >> >> > bio and the meta_page that's pretty trivial as they have short l=
ife times
>> >> >> > and do make guaranteed progress.  I'm massively struggling with =
the iounit
>> >> >> > allocation, though.  These can live on for a long time over log =
I/O, cache
>> >> >> > flushing and last but not least RAID I/O, and every attempt at s=
omething
>> >> >> > mempool-like results in reproducible deadlocks.  I wonder if we =
need to
>> >> >> > figure out some more efficient data structure to communicate the=
 completion
>> >> >> > status that doesn't rely on these fairly long living allocations=
 from
>> >> >> > the I/O path.
>> >> >>=20
>> >> >> Presumably the root cause of these deadlocks is that the raid5d th=
read
>> >> >> has called
>> >> >>    handle_stripe -> ops_run_io ->r5l_write_stripe -> r5l_log_stripe
>> >> >>       -> r5l_get_meta -> r5l_new_meta
>> >> >>=20
>> >> >> and r5l_new_meta is blocked on memory allocation, which won't comp=
lete
>> >> >> until some raid5 stripes get written out, which requires raid5d to=
 do
>> >> >> something more useful than sitting and waiting.
>> >> >>=20
>> >> >> I suspect a good direction towards a solution would be to allow the
>> >> >> memory allocation to fail, to cleanly propagate that failure indic=
ation
>> >> >> up through r5l_log_stripe to r5l_write_stripe which falls back to =
adding
>> >> >> the stripe_head to ->no_space_stripes.
>> >> >>=20
>> >> >> Then we only release stripes from no_space_stripes when a memory
>> >> >> allocation might succeed.
>> >> >>=20
>> >> >> There are lots of missing details, and possibly we would need a se=
parate
>> >> >> list rather than re-using no_space_stripes.
>> >> >> But the key idea is that raid5d should never block (except beneath
>> >> >> submit_bio on some other device) and when it cannot make progress
>> >> >> without blocking, it should queue the stripe_head for later handli=
ng.
>> >> >>=20
>> >> >> Does that make sense?
>> >> >
>> >> > It does remove the scary __GFP_NOFAIL, but the approach is essentia=
lly
>> >> > idential to a 'retry after allocation failure'. Why not just let th=
e mm
>> >> > (with __GFP_NOFAIL) to do the retry then?
>> >> >
>> >>=20
>> >> Because deadlocks.
>> >>=20
>> >> If raid5d is waiting for the mm to allocated memory, then it cannot
>> >> retire write requests which could free up memory.
>> >
>> > Ok, I missed the deadlock issue. Looks raid5d can't sleep waitting for
>> > memory. That means the mempool for metadata page/bio doesn't work too,
>> > as raid5d might block and not dispatch previous IO. Your proposal looks
>> > reasonable.
>>=20
>> raid5d mustn't sleep waiting for something that only raid5d can provide.
>>=20
>> A bio allocated from a mempool will be returned to that mempool when the
>> IO request completes (if the end_io routine calls bio_put, which it
>> does).
>> So when waiting on a mempool for a bio, you are only waiting for some
>> underlying device to perform IO, you are not waiting for anything that
>> raid5d might do.  So that is safe.
>>=20
>> Similarly the meta_page is freed in the end_io function, so it is safe
>> to wait for that.
>> Note that the important feature of a mempool is not so much that it
>> pre-allocates some memory.  The important point is that when that
>> pre-allocated memory is freed it can *only* be used by the owner of the
>> mempool.
>> By contrast memory allocated with NOFAIL, when freed might be used by
>> any other caller anywhere in the kernel.
>> So waiting on a mempool means waiting for certain well defined events.
>> Waiting in NOFAIL could end up waiting for almost anything.  So it is
>> much harder to reason about deadlocks.
>>=20
>> The bio and the meta_page contrast with the r5l_io_unit which isn't
>> freed by the first end_io, but remains until raid5d has done some more
>> work.  So raid5d cannot wait for a r5l_io_unit to be freed.
>
> I'm confused 2 bios are already enough to avoid deadlock, sorry. Can you
> peek Christoph's patches? I'll work on a patch for r5l_io_unit.
>

I don't understand what you are tring to say.
Yes, a bio pool of 2 bios is (I believe) enough to avoid a deadlock when
allocation a bio.  It no affect on any deadlock involved in allocating
an r5l_io_unit.
I have looked at Christoph's patches.  What in particular did you hope I
would see?

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWai00AAoJEDnsnt1WYoG5ETMP/i7WBNg3zoHJMeiVLYDuDemD
yjYfZk1BOn05UQHROlqLYrnsuglaylggvadIL0FqTftto0ID59NYY+TerUWsb2I3
juQoW0uG2KApNRpKK24cjKkMz5htOoGDxgovwU4zqpg3gKy8lr4apvqq4pPDPzm1
LTVd/0Jt2VLv7gHN/AZdHzdEUCDNFElVmC++AsO2wY6SRu8ZUWaGV4W7I6quFTHO
K2lnOmTTs66RNYDqcxRHytUHFY0e/dA3E1/PHP3k3sZ1viuKcP/xP1JWcDMxIyt2
2mrUYr1RkYA61bbPx3o4F3bn5XACAc1CTnnlk3Pr7OZG5/U/Dv19ZugBQyY929aX
0P2oVwk83g2FRithgLTidGeg7oGfi0m+cybMpzWPWotvARuW5APnX+tCObok2S/y
ZpppqHW4VxHz1KhjkcbT5e0iM9e6re86EXjLjdG54REbV0YUZRlfofI7f6ZArkfp
cyPEcyKePF/2Z/E/QcszWdZdc5mf4tj0OBIjBoBZ9hn/MsTB99jOguhknt88R0+2
JkzI1X1ZmZgEFl7lQLOJKCKqjYFHKOP1+7hNzHJ4Jh4cgn5zLHCGywOBC+Gzq9F2
7K6CJE3RFaYQIFnqghJrRM5n1V6yiyxkhqCizTPc1u3QqOzU/NLzFrxTdP3/kNrY
93mutAB+jgeBnzTJKRj8
=rpe+
-----END PGP SIGNATURE-----
--=-=-=--
