From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 3/3] raid5: allow r5l_io_unit allocations to fail
Date: Mon, 21 Dec 2015 09:51:15 +1100
Message-ID: <87y4co68f0.fsf@notabene.neil.brown.name>
References: <1450390197-19479-1-git-send-email-hch@lst.de> <1450390197-19479-4-git-send-email-hch@lst.de> <20151217234748.GA1860175@devbig084.prn1.facebook.com> <874mfg8qyc.fsf@notabene.neil.brown.name> <20151218112312.GA28224@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20151218112312.GA28224@lst.de>
Sender: linux-raid-owner@vger.kernel.org
Cc: Shaohua Li <shli@fb.com>, Christoph Hellwig <hch@lst.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 18 2015, Christoph Hellwig wrote:

> On Fri, Dec 18, 2015 at 12:51:07PM +1100, NeilBrown wrote:
>> > if the reclaim thread doesn't have anything to reclaim,
>> > r5l_run_no_space_stripes isn't called. we might miss the retry.
>>=20
>> so something like this:
>
> that looks fine to me.  I'll give a spin on my QA setup.
>
>> > I'm a little worrying about the GFP_ATOMIC allocation. In the first tr=
y,
>> > GFP_NOWAIT is better. And on the other hand, why sleep is bad here? We
>> > could use GFP_NOIO | __GFP_NORETRY, there is no deadlock risk.
>> >
>> > In the retry, GFP_NOIO looks better. No deadlock too, since it's not
>> > called from raid5d (maybe we shouldn't call from reclaim thread if usi=
ng
>> > GFP_NOIO, a workqueue is better). Otherwise we could keep retring but =
do
>> > nothing.
>>=20
>> I did wonder a little bit about that.
>> GFP_ATOMIC is (__GFP_HIGH)
>> GFP_NOIO | __GFP_NORETRY is  (__GFP_WAIT | __GFP_NORETRY)
>>=20
>> It isn't clear that we need 'HIGH', and WAIT with NORETRY should be OK.
>> It allows __alloc_pages_direct_reclaim, but only once and never waits
>> for other IO.
>
> In general we go for HIGH on non-sleeping allocation to avoid having
> the stalled.  This is especially important in the I/O path.
>
> WAIT means we will reclaim and wait for it, which looks a little dangerous
> to me.  In general I'd prefer not to use obscure gfp flag combination
> unless there is a real need, and it's clearly documented.

I don't think "will reclaim and wait for it" is accurate.

Certainly page_alloc will only try direct reclaim when WAIT is set, but
I don't think it actually waits for anything particular.

There are various waits in the direct reclaim path such as
throttle_vm_writeout(), but they seem to be throttling delays rather
than "wait for something particular" delays.
Also direct reclaim (e.g. in shrinkers) are allows to sleep (as long as
they don't violate NOFS or NOIO), so waiting can definitely happen for
non-throttling reasons.

I *think* (not 100% sure) that __GFP_WAIT means that the alloc code is
allowed to schedule().  Without that flag it mustn't.

So it makes sense to use WAIT when it is appropriate for a delay to be
introduce to throttle allocations.  I don't think that is the case in
raid5d.  raid5d is too low level - throttling it will not directly
affect higher level allocations.

So while my reasoning is a bit different, I agree that we don't really
want WAIT in an allocation in raid5d.

.... oh.  I just noticed that __GFP_WAIT was renamed to __GFP_RECLAIM
last month.  And there is a new __GFP_DIRECT_RECLAIM.  I think I'm going
to have to learn how this stuff works again.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWdzDjAAoJEDnsnt1WYoG5FD8P/0ypYxM65SgWLWR94U7HWYY1
6K9l0xas0rkskf521ZPhs0CtIaXOgwtyccXcu92W7tJoApzpjCI3i1a9jwPSSpNn
45I/1TtKqPaYbVU4zTf2wL+3MnEiB125FAG/AFF1+l7e/LbjKoqaasHyYUf7QdBb
2gH4oi0oXo4UUKMFc+JTInDyYs2WvBaxRAnNKk2NHvdpT8tSsxmNumWII/Eph1/L
DvRP0KjSigNyIemPWPuZlKouMibAufECMDJSL1Av0z/L81y15qYd0eD4oacRpHmA
EbRY42ud8qmSdSpGhyYIQ1e7NWJ3p9w77pGeYsQt5BkSAEcmyc5Z8e7vTuTyDAPB
oYOe5LkCJoSvZ6Ql0jshnD3/btnZtqvUH1vEmcQgZPFczntjumlGup6EfCyvejUw
6AStp4gZnC/U5wuyAHX4cdX17ob9ywFuWApbyJzhUQ2HJ3f1ejaRVWctJk1b5RsE
tbp0I75q249Bqvlh3sMohev0nFhsHRbRMisSWV+is5MKAb7+MY9TTVP/gEX12c7m
jB3nwP+lo8ieyP4qYcj28M/Ce/NshyX9wFLvV4tIzys1So3bxGF9FJz/cPaOEXOj
ArJYGPem1IjAA1aQorA0dGR8+xg0Yeeul9RKzMH7lDTkz+UzPF97lbFJhJVG0CZJ
P7YXv98ISgWwng0wsMOS
=KHK9
-----END PGP SIGNATURE-----
--=-=-=--
