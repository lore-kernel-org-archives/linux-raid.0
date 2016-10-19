From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] badblocks: fix overlapping check for clearing
Date: Wed, 19 Oct 2016 13:36:35 +1100
Message-ID: <87funtxdxo.fsf@notabene.neil.brown.name>
References: <1473152338-30539-1-git-send-email-tomasz.majchrzak@intel.com> <87wphk3gpx.fsf@notabene.neil.brown.name> <CAA9_cmcnQjKv=tdBF+Jkd6WoFh+aKCVzq7NPQBStwtcv_j0Qyg@mail.gmail.com> <20161012102621.GA30839@proton.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20161012102621.GA30839@proton.igk.intel.com>
Sender: linux-block-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>, Dan Williams <dan.j.williams@intel.com>, linux-block@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 12 2016, Tomasz Majchrzak wrote:

> On Mon, Oct 10, 2016 at 03:32:58PM -0700, Dan Williams wrote:
>> > On Tue, Sep 06 2016, Tomasz Majchrzak wrote:
>> >> ---
>> >>  block/badblocks.c | 6 ++++--
>> >>  1 file changed, 4 insertions(+), 2 deletions(-)
>> >>
>> >> diff --git a/block/badblocks.c b/block/badblocks.c
>> >> index 7be53cb..b2ffcc7 100644
>> >> --- a/block/badblocks.c
>> >> +++ b/block/badblocks.c
>> >> @@ -354,7 +354,8 @@ int badblocks_clear(struct badblocks *bb, sector_=
t s, int sectors)
>> >>                * current range.  Earlier ranges could also overlap,
>> >>                * but only this one can overlap the end of the range.
>> >>                */
>> >> -             if (BB_OFFSET(p[lo]) + BB_LEN(p[lo]) > target) {
>> >> +             if ((BB_OFFSET(p[lo]) + BB_LEN(p[lo]) > target) &&
>> >> +                 (BB_OFFSET(p[lo]) <=3D target)) {
>> >
>> > hmmm..
>> > 'target' is the sector just beyond the set of sectors to remove from t=
he
>> > list.
>> > BB_OFFSET(p[lo]) is the first sector in a range that was found in the
>> > list.
>> > If these are equal, then are aren't clearing anything in this range.
>> > So I would have '<', not '<=3D'.
>> >
>> > I don't think this makes the code wrong as we end up assigning to p[lo]
>> > the value that is already there.  But it might be confusing.
>> >
>> >
>> >>                       /* Partial overlap, leave the tail of this rang=
e */
>> >>                       int ack =3D BB_ACK(p[lo]);
>> >>                       sector_t a =3D BB_OFFSET(p[lo]);
>> >> @@ -377,7 +378,8 @@ int badblocks_clear(struct badblocks *bb, sector_=
t s, int sectors)
>> >>                       lo--;
>> >>               }
>> >>               while (lo >=3D 0 &&
>> >> -                    BB_OFFSET(p[lo]) + BB_LEN(p[lo]) > s) {
>> >> +                    (BB_OFFSET(p[lo]) + BB_LEN(p[lo]) > s) &&
>> >> +                    (BB_OFFSET(p[lo]) <=3D target)) {
>> >
>> > Ditto.
>> >
>> > But the code is, I think, correct. Just not how I would have written i=
t.
>> > So
>> >
>> >  Acked-by: NeilBrown <neilb@suse.com>
>>=20
>> I agree with the comments to change "<=3D" to "<".  Tomasz, care to
>> re-send with those changes?
>
> I have just resent the patch with your suggestions included.
>
>> > In the original md context, it would only ever be called on a block th=
at
>> > was already in the list.
>
> Actually MD RAID10 calls it this way. See handle_write_completed, it iter=
ates
> over all copies and clears the bad block if error has not been returned. =
I have
> a test case which fails for that reason - existing bad block is modified =
by
> clear block. It is very unlikely to happen in real life as it depends on
> specific layout of bad blocks and their discovery order, however it's a g=
ap that
> needs to be closed.

Ahh, I didn't realize that.  I see that you are correct though.

>
> I had put some effort to see if clearing of non-existing bad block in RAI=
D10 can
> lead to some incorrect behaviour but I haven't found any. It seems that m=
y patch
> is sufficient to fix the problem.

Yes.  Thanks for a lot for sorting this out :-)

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYBtw0AAoJEDnsnt1WYoG51PwP/R/Jv8g+AaRl47H9J8dydiq/
8paOyCdq5oHulOM3g7e+bYrj8nerINW0hUIoHbOUSMwKJNJ6OGd2ACxhC3XsGjAH
p/AGrqekXTbu0zwuwe9104ZbXD35o0EhGv8NxOvCodgBHrqzP6CzyJ1tO5zMQYE+
7fRuQSXAr2gB9j1y5TlkB654ckJPdR1JJco1tWzuoHzh3g5mXgLHCmO8DRKg7iJv
jRQnhTI7+1pXO8Zs9lir84sjl00BI9qUlv0q+F8Ll7tArHeDHljiQx9hPfmwUC86
zvZny7o1KKw44fpsPtAWzrYRTY03tftIJQgzxhczeIDbOHICZKXloFVK/upafwBI
F5ugaCFF13M3LwGirel+htp77h6PMMP1IT4htvDuAC5oKbdvg1e3vRmxCiVku2SY
13RQan6oRCP4EGNjqlRZPqAzg0HJFmSawr6DUs2eNg8e6Cb1Yct8wSxN6NQiGI1G
VRZ3i7ihMkyho503yhNl99r4WoOKvnGVEhPGqVgYeYjsy3J9EYhGKg2HMMFZDuyG
ITysp3hYl3lzY29C4RjxQLnYwu08uQ6Z2lCyVTtoH63gEffV1bEI9KMRosxXjim6
yRLzxmuR9b52f26ZfF5talmCMs5clP9rDKxAEzr9p18HH5CRM28dg+uxy8+FX8Ql
MKARAtLyIUJ4Jz1lqwzr
=qVGP
-----END PGP SIGNATURE-----
--=-=-=--
