From: NeilBrown <neilb@suse.com>
Subject: Re: [md PATCH 00/10] Simplify bio splitting and related code.
Date: Thu, 20 Apr 2017 11:37:27 +1000
Message-ID: <87vapzsvu0.fsf@notabene.neil.brown.name>
References: <149136485390.25893.1797855041954158826.stgit@noble> <20170411170112.4txdyjdat63qpsi6@kernel.org> <871ssywmno.fsf@notabene.neil.brown.name> <20170412025157.qlodbacq2afuvq6j@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170412025157.qlodbacq2afuvq6j@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 11 2017, Shaohua Li wrote:

> On Wed, Apr 12, 2017 at 09:27:07AM +1000, Neil Brown wrote:
>> On Tue, Apr 11 2017, Shaohua Li wrote:
>>=20
>> > On Wed, Apr 05, 2017 at 02:05:50PM +1000, Neil Brown wrote:
>> >> This is part of my little project to make bio splitting
>> >> in Linux uniform and dead-lock free, in a way that will mean
>> >> that we can get rid of all the bioset threads.
>> >>=20
>> >> The basic approach is that when a bio needs to be split, we call
>> >> bio_split(), bio_chain() and then generic_make_request().
>> >> We then proceed to handle the remainder without further splitting.
>> >> Recent changes to generic_make_request() ensure that this will
>> >> be safe from deadlocks, providing each bioset is used only once
>> >> in the stack.
>> >>=20
>> >> This leads to simpler code in various places.  In particular, the
>> >> splitting of bios that is needed to work around known bad blocks
>> >> is now much less complex.  There is only ever one r1bio per bio.
>> >>=20
>> >> As you can see from
>> >>  10 files changed, 335 insertions(+), 540 deletions(-)
>> >> there is a net reduction in code.
>> >
>> > Looks good and makes code simpler, applied, thanks Neil! The patch 1 a=
nd 6 need
>> > comments in the code to explain how deadlock is avoided though. Care t=
o send a
>> > new patch?
>>=20
>> It isn't clear to me what sort of comment you want, or where it should
>> go.
>> It might make sense to have a comment near bio_split() explaining how to
>> use it (i.e. explaining the pattern used in various patches here), but
>> I don't see what sort of comments would help in raid1.c or raid10.c
>> ??
>
> Both raid1.c and raid10.c have comments why we need offload the bio to
> raid1d/raid10d to avoid deadlock before, we also have comments to explain=
 why
> we do bio_split() and then generic_make_request() before. Now these info =
are
> lost, so I hope we can add it back why the new way (bio_split and follow
> generic_make_request of next part) can avoid deadlock. That will be very
> helpful for others.

Those comments were needed before because of design flaws in
generic_make_request().  It make it too easy to trigger deadlocks.
With the recent changes to generic_make_request(), deadlocks are much
harder to trigger so there is less need for documentation on how to be
careful.

It would be good to have some clear documentation for bio_split()
describing how it should be used.  Once I have tidied up all the users
of bio_split() and removed the bioset work queues, I plan to add that
documentation.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlj4ENcACgkQOeye3VZi
gblYshAAnG7w8o/yFdtRDzlfeNsjJs53DpwHGTsPIvE3Pc8X0dE0HXY6RZ1QToWg
HvowIz4XK81T5Qyvjw4oQGQvMXD3CVcSn1khYjzgQAJj2Pdh3S99/JqiDakCQwdh
9OMaR5NLOevBkZZ2yYKfLbFLkdbMZUYsVLQoAssfpWnJtBmUpdvRfPmx4Z4etKSE
0B5lR6O3qiHnTzlZ7/1qcdrGsapoXKUePpvxOq9FaXp+FuyEiEjz25KYmCZgie69
iFOOoRRPuHdWS8ZXtqPICf4+FhgK5/8kz4VJOyXE70tG4SMWP7hGTSk3Jd7aRoOO
CxVduNmG72/BUdf2ru/VYlOLgzDvE7xoLJXpd3pbUzobS2mioQAnhm0vNW1wn8Ct
SaSwGssN4AI/6BUhq/Fz9hROEtFigk7O1haIo/GmvL2QkOQiIkqXCmS8RfLZkFCe
Z4Q0cUXss7enigmVl32SWBV4zNu9gwAphpLh9lmGefIBZTvRhLYl9VYVASDIVLVq
rQXKOgbPCSjTXBCkYvpOGDDddz2u7qbE8DyvrsA5y/2gFRKITSo0/X4itHHM82fi
ISoA3LjcopMsR8MIL5lxPqmtivLQ2qUNb6NURuNKcHgnOBx71MGLAoiDbxgaCYvr
drnDs5d67/GLsgreEG7BFBztVjYR5Ys3I7Id/umdcT2s49z3RMA=
=bbkf
-----END PGP SIGNATURE-----
--=-=-=--
