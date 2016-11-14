From: NeilBrown <neilb@suse.com>
Subject: Re: "creative" bio usage in the RAID code
Date: Mon, 14 Nov 2016 20:51:38 +1100
Message-ID: <87polyie39.fsf@notabene.neil.brown.name>
References: <20161110194636.GA32241@infradead.org> <20161111190223.4xrq3vvvvohzgs5e@kernel.org> <20161112174238.GA11518@infradead.org> <87vavrj8jp.fsf@notabene.neil.brown.name> <20161114085720.GB8405@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161114085720.GB8405@infradead.org>
Sender: linux-raid-owner@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 14 2016, Christoph Hellwig wrote:

> On Mon, Nov 14, 2016 at 09:53:46AM +1100, NeilBrown wrote:
>> > While we're at it - I find the way MD_RECOVERY_REQUESTED is used highly
>> > confusing, and I'm not 100% sure it's correct.  After all we check it
>> > in r1buf_pool_alloc, which is a mempool alloc callback, so we rely
>> > on these callbacks being done after the flag has been raise / cleared,
>> > which makes me bit suspicious, and also question why we even need the
>> > mempool.
>>=20
>> MD_RECOVERY_REQUEST is only set or cleared when no recovery is running.
>> The ->reconfig_mutex and MD_RECOVERY_RUNNING flags ensure there are no
>> races there.
>> The r1buf_pool mempool is created are the start of resync, so at that
>> time MD_RECOVERY_RUNNING will be stable, and it will remain stable until
>> after the mempool is freed.
>>=20
>> To perform a resync we need a pool of memory buffers.  We don't want to
>> have to cope with kmalloc failing, but are quite able to cope with
>> mempool_alloc() blocking.
>> We probably don't need nearly as many bufs as we allocate (4 is probably
>> plenty), but having a pool is certainly convenient.
>
> Would it be good to create/delete the pool explicitly through methods
> to start/emd the sync?  Right now the behavior looks very, very
> confusing.

Maybe.  It is created the first time ->sync_request is called,
and destroyed when it is called with a sector_nr at-or-beyond the end of
the device.  I guess some of that could be made a bit more obvious.
I'm not strongly against adding new methods for "start_sync" and "stop_sync"
but I don't see that it is really needed.

>
>> The "bigger bio" might cover a large number of sectors.  If there are
>> media errors, there might be only one sector that is bad.  So we repeat
>> the read with finer granularity (pages in the current code, though
>> device block would be ideal) and only recovery bad blocks for individual
>> pages which are bad and cannot be fixed.
>
> i have no problems with the behavior - the point is that these days
> this should be without poking into the bio internals, but by using
> a bio iterator for just the range you want to re-read.  Potentially
> using a bio clone if we can't reusing the existing bio, although I'm
> not sure we even need that from looking at the code.

Fair enough.  The code predates bio iterators and "if it ain't broke,
don't fix it".  If it is now causing problems, then maybe it is now
"broke" and should be "fixed".

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYKYkqAAoJEDnsnt1WYoG5mmIP/RIa/DJLZgOdiDCOFogGCyzq
3tzcxDxJoqePmNx6O+uL23eCR+vrBEq1HIGhpwcyKjCNjpKjVPKYyoZu207Sjc+Z
6Ykx55s1nvksi8ghcKtC5gO9BynPKQsWkENH9ZvNWMbaUVJCso78ZXqzsdcICLi2
wT3RFdvmhLGL4xZvuiJ5SDrPe5yO91SJMx5jDlPkTvKUqFB4khd9gcDnwvTs2YyC
NuNywC2zXX27AKzRjXNrK7kMUpGeF4taG279t1RYS4Xkhwp9HMpRKbF9kujRYyi8
sBUtWqHWPXpv7iBcD43jC6BEBcaZ07PADjdi67Z5YUpwVUcKUs0oiFz63lEghllk
SVYFnhWLbJxOQsT1tu5KEDs/RFWBi+4eIaJvXFSRv+qRSXSUb73/XLo+oOOWS+d8
jRlsZH01bLtJr5Xc/YLAq6NQi0TDrofkDXKGgZmYHhwsTJab0emRCXSFtND+IyQg
h9U4/znhyRy0W9aPXBkHBzkUW1PhUUWMtdBJHx8Tyq6fOHNDAW1Dll/2Sn7S2vXD
i1z5en+1CVk19HTzZNfI/XVMcK2+/QcRwfDm+cGs/OFRVZdgYq4E98lbfkvYknX9
ZlvxdfTCtcUOGQ8Pi4DJlc0MKnRMEtpjeEHosuUrg5DWHZQE1mv08ffPiCaLPTAt
hfiofXDYwvKfQTwC5ZVv
=mLZV
-----END PGP SIGNATURE-----
--=-=-=--
