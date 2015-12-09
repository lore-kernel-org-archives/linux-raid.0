From: NeilBrown <neilb@suse.com>
Subject: Re: [RFC] using mempools for raid5-cache
Date: Wed, 09 Dec 2015 17:34:45 +1100
Message-ID: <87vb88p1tm.fsf@notabene.neil.brown.name>
References: <1449072638-15409-1-git-send-email-hch@lst.de> <876108qwz5.fsf@notabene.neil.brown.name> <20151209012812.GA2403138@devbig084.prn1.facebook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20151209012812.GA2403138@devbig084.prn1.facebook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 09 2015, Shaohua Li wrote:

> On Wed, Dec 09, 2015 at 11:36:30AM +1100, NeilBrown wrote:
>> On Thu, Dec 03 2015, Christoph Hellwig wrote:
>>=20
>> > Currently the raid5-cache code is heavily relying on GFP_NOFAIL alloca=
tions.
>> >
>> > I've looked into replacing these with mempools and biosets, and for the
>> > bio and the meta_page that's pretty trivial as they have short life ti=
mes
>> > and do make guaranteed progress.  I'm massively struggling with the io=
unit
>> > allocation, though.  These can live on for a long time over log I/O, c=
ache
>> > flushing and last but not least RAID I/O, and every attempt at somethi=
ng
>> > mempool-like results in reproducible deadlocks.  I wonder if we need to
>> > figure out some more efficient data structure to communicate the compl=
etion
>> > status that doesn't rely on these fairly long living allocations from
>> > the I/O path.
>>=20
>> Presumably the root cause of these deadlocks is that the raid5d thread
>> has called
>>    handle_stripe -> ops_run_io ->r5l_write_stripe -> r5l_log_stripe
>>       -> r5l_get_meta -> r5l_new_meta
>>=20
>> and r5l_new_meta is blocked on memory allocation, which won't complete
>> until some raid5 stripes get written out, which requires raid5d to do
>> something more useful than sitting and waiting.
>>=20
>> I suspect a good direction towards a solution would be to allow the
>> memory allocation to fail, to cleanly propagate that failure indication
>> up through r5l_log_stripe to r5l_write_stripe which falls back to adding
>> the stripe_head to ->no_space_stripes.
>>=20
>> Then we only release stripes from no_space_stripes when a memory
>> allocation might succeed.
>>=20
>> There are lots of missing details, and possibly we would need a separate
>> list rather than re-using no_space_stripes.
>> But the key idea is that raid5d should never block (except beneath
>> submit_bio on some other device) and when it cannot make progress
>> without blocking, it should queue the stripe_head for later handling.
>>=20
>> Does that make sense?
>
> It does remove the scary __GFP_NOFAIL, but the approach is essentially
> idential to a 'retry after allocation failure'. Why not just let the mm
> (with __GFP_NOFAIL) to do the retry then?
>

Because deadlocks.

If raid5d is waiting for the mm to allocated memory, then it cannot
retire write requests which could free up memory.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWZ8uFAAoJEDnsnt1WYoG5bbcQAJeCT0EerxejgSKWQID+WchG
CJJO1sSG/S1eBd26efJ/74y19n8LEPe2IL4FaZD2RoUTmkcNTFMSaQEbxyxYdu/d
uEkKL52QIX2lKJMxNlnfr7gm/Xi/AraoHoycbgu+XeN5K+236F7LVRN6EUcOaTP7
G3VV2WraJvVRVCAhqHeGhSkqfOlSjFihfIA0fHoWJFusll+ALE3G27hZisgOaIcC
UGYLQLdig4nbMKTmpd1YllERGdLLw9JRRshaKCDXDpIDtyXoIq3t5h56oeen0gLM
3zsHaqcvQXSMvBez9rUbwlMTrGb/FayAHwk7SCN5PHa27uRnfZEo4GB+n9zkXdtL
7tWom0FJGgqAjB8QOtBzOd9EWQDesVMx8uznZi1echgnyUYNe39uPnl/nkXoBBHF
2+MZqg5h/GhRU3Tb5w1c7pWMph2LDgvCmj9116mXhg0czfLFZMd6aHQ1juAl7YdD
q8WviQA/XnGAaOqhHk53oRrWmyvebVrnnoxJnuY63GtjwJwpGdMHBzrpMX5lvZKd
QIi2k0kqqvwc2laxD9wpmLDTOX4RynQXdmSJojk1MFiMIdgbSrvjFVy6GlGcNVqr
q3X3rXbiAGhUtdpyQllohcSfty/1tUa1T40rSuUbZ7ssBb9YY7W+aN2lI+Mru8pO
W/fza0XCSSCxWHG6LSS8
=vIcR
-----END PGP SIGNATURE-----
--=-=-=--
