From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 2/2] md: raid1/raid10: initialize bvec table via bio_add_page()
Date: Fri, 14 Jul 2017 08:08:25 +1000
Message-ID: <878tjs2dnq.fsf@notabene.neil.brown.name>
References: <20170712082912.491-1-ming.lei@redhat.com> <87zic92oiq.fsf@notabene.neil.brown.name> <20170713013710.GC670@ming.t460p> <87inix2ftj.fsf@notabene.neil.brown.name> <20170713092050.GG670@ming.t460p> <20170713163909.whltvlms2zwgevkf@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170713163909.whltvlms2zwgevkf@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Ming Lei <ming.lei@redhat.com>
Cc: linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 13 2017, Shaohua Li wrote:

> On Thu, Jul 13, 2017 at 05:20:52PM +0800, Ming Lei wrote:
>> On Thu, Jul 13, 2017 at 01:09:28PM +1000, NeilBrown wrote:
>> > On Thu, Jul 13 2017, Ming Lei wrote:
>> >=20
>> > > On Thu, Jul 13, 2017 at 10:01:33AM +1000, NeilBrown wrote:
>> > >> On Wed, Jul 12 2017, Ming Lei wrote:
>> > >>=20
>> > >> > We will support multipage bvec soon, so initialize bvec
>> > >> > table using the standardy way instead of writing the
>> > >> > talbe directly. Otherwise it won't work any more once
>> > >> > multipage bvec is enabled.
>> > >> >
>> > >> > Acked-by: Guoqing Jiang <gqjiang@suse.com>
>> > >> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
>> > >> > ---
>> > >> >  drivers/md/md.c     | 21 +++++++++++++++++++++
>> > >> >  drivers/md/md.h     |  3 +++
>> > >> >  drivers/md/raid1.c  | 16 ++--------------
>> > >> >  drivers/md/raid10.c |  4 ++--
>> > >> >  4 files changed, 28 insertions(+), 16 deletions(-)
>> > >> >
>> > >> > diff --git a/drivers/md/md.c b/drivers/md/md.c
>> > >> > index 8cdca0296749..cc8dcd928dde 100644
>> > >> > --- a/drivers/md/md.c
>> > >> > +++ b/drivers/md/md.c
>> > >> > @@ -9130,6 +9130,27 @@ void md_reload_sb(struct mddev *mddev, int=
 nr)
>> > >> >  }
>> > >> >  EXPORT_SYMBOL(md_reload_sb);
>> > >> >=20=20
>> > >> > +/* generally called after bio_reset() for reseting bvec */
>> > >> > +void md_bio_reset_resync_pages(struct bio *bio, struct resync_pa=
ges *rp,
>> > >> > +			       int size)
>> > >> > +{
>> > >> > +	int idx =3D 0;
>> > >> > +
>> > >> > +	/* initialize bvec table again */
>> > >> > +	do {
>> > >> > +		struct page *page =3D resync_fetch_page(rp, idx);
>> > >> > +		int len =3D min_t(int, size, PAGE_SIZE);
>> > >> > +
>> > >> > +		/*
>> > >> > +		 * won't fail because the vec table is big
>> > >> > +		 * enough to hold all these pages
>> > >> > +		 */
>> > >> > +		bio_add_page(bio, page, len, 0);
>> > >> > +		size -=3D len;
>> > >> > +	} while (idx++ < RESYNC_PAGES && size > 0);
>> > >> > +}
>> > >> > +EXPORT_SYMBOL(md_bio_reset_resync_pages);
>> > >>=20
>> > >> I really don't think this is a good idea.
>> > >> This code is specific to raid1/raid10.  It is not generic md code. =
 So
>> > >> it doesn't belong here.
>> > >
>> > > We already added 'struct resync_pages' in drivers/md/md.h, so I think
>> > > it is reasonable to add this function into drivers/md/md.c
>> >=20
>> > Alternative perspective: it was unreasonable to add "resync_pages" to
>> > md.h.
>> >=20
>> > >
>> > >>=20
>> > >> If you want to remove code duplication, then work on moving all rai=
d1
>> > >> functionality into raid10.c, then discard raid1.c
>> > >
>> > > This patch is for avoiding new code duplication, not for removing cu=
rrent
>> > > duplication.
>> > >
>> > >>=20
>> > >> Or at the very least, have a separate "raid1-10.c" file for the com=
mon
>> > >> code.
>> > >
>> > > You suggested it last time, but looks too overkill to be taken. But =
if
>> > > someone wants to refactor raid1 and raid10, I think it can be a good=
 start,
>> > > but still not belong to this patch.
>> >=20
>> > You are trying to create common code for raid1 and raid10.  This does
>> > not belong in md.c.
>> > If you really want to have a single copy of common code, then it exact=
ly
>> > is the role of this patch to create a place to put it.
>> > I'm not saying you should put all common code in raid1-10.c.   Just the
>> > function that you have identified.
>>=20
>> I really don't want to waste time on this kind of thing, I can do
>> either one frankly.
>>=20
>> Shaohua, could you share me which way you like to merge? I can do it in
>> either way.
>
> I don't have strong preference, but Neil's suggestion does make the code a
> little better. Of course, only put the function into the raid1-10.c right=
 now.

To make it as easy as possible, I would suggest creating raid1-10.c
containing just this function (and maybe the definitions from md.h),
and declare the function "static" and #include raid1-10.c into raid1.c
and raid10.c.  i.e. no worrying about modules and exporting symbols.

Anyone who cares (and that might even be me) could move functionality
gradually out of raid1.c and raid10.c in raid1-10.c.  Maybe where would
come a tipping-point where it is easy to just discard raid1.c and raid10.c
and finish the job.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlln71sACgkQOeye3VZi
gblN2BAAp6D9lIBJFxjj5SISCmErLr/5bfNOdeMEl9PWDgPDz5PqeVuGfEnHpnSb
23CNJJT+njFRGYVjr+vUT7qjB2855R5UCF1U40yye6lNIvSCeearGvxIQ9zoLKXR
XS0Az+GlQjqWBp1VKii76ISoNPwyXBrEZrbJcQ1PoQS0dbOBRMDG80SQXddKAD0A
+hLLGz96+UxlwCFmICttB3/5eYU1VsPYKyhitClh9AcO9/TeccSKQ6hOVLBYTZ7b
oKKUCUzMgyEu4WM6UYT+SHv42j9gSjoUqLApQ2smWVK05y8SqarLt+WBgw2Idt8I
Hf2bK9hjE4w8nY8+nhhNnaBOH+ub/902ePFcRLuvugqTn9NfptrOCq4C9/27zpET
wea+e3SizccTD25UseX9f9CXxE6u1ad9v/x2tTABcnQLY2cEbJYbObnsTIeQWxFR
AHBjldX/hysXGDiq8tAaodcIAnL7WMeoDuBu4jz7+nQrgcCr4MlYQQJQTfgfLTQv
p+6pHt8YMZuGWiHFCyNzyKI9tIoXjnLOCPj0hsEYytgu2GEQLW+ljZMeAfpM5OZI
EebawjpmoFcxKBytOaISlTknA3ULzvCJrha9b8lAC9j8Maz+DkrJVh5E3qTnuS7v
Kg8s4ES/PvlOjlgYTEEDop+X3xV7ymX6seb0QxRwqZDzHTq1yHo=
=J+2C
-----END PGP SIGNATURE-----
--=-=-=--
