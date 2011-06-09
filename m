From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH] md/raid10: share pages between read and write bio's
 during recovery
Date: Thu, 09 Jun 2011 11:33:51 +0900
Message-ID: <1307586831.1336.3.camel@leonhard>
References: <1307556273-16730-1-git-send-email-namhyung@gmail.com>
	 <20110609122109.080e82de@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110609122109.080e82de@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2011-06-09 (=EB=AA=A9), 12:21 +1000, NeilBrown:
> On Thu,  9 Jun 2011 03:04:33 +0900 Namhyung Kim <namhyung@gmail.com> =
wrote:
>=20
> > When performing a recovery, only first 2 slots in r10_bio are in us=
e,
> > for read and write respectively. However all of pages in the write =
bio
> > are never used and just replaced to read bio's when the read comple=
tes.
> >=20
> > Get rid of those unused pages and share read pages properly.
> >=20
> > Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> > ---
> >  drivers/md/raid10.c |   13 ++++++++++---
> >  1 files changed, 10 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> > index a53779ffdf89..621594981339 100644
> > --- a/drivers/md/raid10.c
> > +++ b/drivers/md/raid10.c
> > @@ -116,6 +116,13 @@ static void * r10buf_pool_alloc(gfp_t gfp_flag=
s, void *data)
> >  			goto out_free_bio;
> >  		r10_bio->devs[j].bio =3D bio;
> >  	}
> > +
> > +	/*
> > +	 * We can share bv_page's during the recovery
> > +	 */
> > +	if (!test_bit(MD_RECOVERY_SYNC, &conf->mddev->recovery))
> > +		nalloc--;
> > +
> >  	/*
> >  	 * Allocate RESYNC_PAGES data pages and attach them
> >  	 * where needed.
> > @@ -1363,16 +1370,16 @@ static void recovery_request_write(mddev_t =
*mddev, r10bio_t *r10_bio)
> >  	int i, d;
> >  	struct bio *bio, *wbio;
> > =20
> > -
> > -	/* move the pages across to the second bio
> > +	/*
> > +	 * share the pages with the first bio
> >  	 * and submit the write request
> >  	 */
> >  	bio =3D r10_bio->devs[0].bio;
> >  	wbio =3D r10_bio->devs[1].bio;
> >  	for (i=3D0; i < wbio->bi_vcnt; i++) {
> >  		struct page *p =3D bio->bi_io_vec[i].bv_page;
> > -		bio->bi_io_vec[i].bv_page =3D wbio->bi_io_vec[i].bv_page;
> >  		wbio->bi_io_vec[i].bv_page =3D p;
> > +		get_page(p);
> >  	}
> >  	d =3D r10_bio->devs[1].devnum;
> > =20
>=20
>=20
> Thanks.   Interesting idea, but I don't think this code is safe.
>=20
> We end up calling bio_add_page on with an uninitialised 'page' (in
> sync_request()).  This could result on BIOVEC_PHYS_MERGEABLE doing fu=
nny
> things.
>=20

Arrrh, right. I missed that part.


> It would be OK to set up the two links to the one page in r10buf_pool=
_alloc,
> so recovery_request_write doesn't need to do anything with pages.
> That would probably be even more safe than the current code.
>=20

Agreed, will resend v2. Thanks for the review.


--=20
Regards,
Namhyung Kim


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
