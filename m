From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [md PATCH 02/36] md/bad-block-log: add sysfs interface for
 accessing bad-block-log.
Date: Tue, 26 Jul 2011 14:17:42 +0900
Message-ID: <1311657462.1522.3.camel@leonhard>
References: <20110721024556.8422.99443.stgit@notabene.brown>
	 <20110721025847.8422.8246.stgit@notabene.brown> <874o2e5nj9.fsf@gmail.com>
	 <20110726122927.311602fb@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110726122927.311602fb@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2011-07-26 (=ED=99=94), 12:29 +1000, NeilBrown:
> On Sat, 23 Jul 2011 00:43:22 +0900 Namhyung Kim <namhyung@gmail.com> =
wrote:
>=20
> > NeilBrown <neilb@suse.de> writes:
> >=20
> > > This can show the log (providing it fits in one page) and
> > > allows bad blocks to be 'acknowledged' meaning that they
> > > have safely been recorded in metadata.
> > >
> > > Clearing bad blocks is not allowed via sysfs (except for
> > > code testing).  A bad block can only be cleared when
> > > a write to the block succeeds.
> > >
> > > Signed-off-by: NeilBrown <neilb@suse.de>
> > > ---
> > >
> > >  drivers/md/md.c |  127 +++++++++++++++++++++++++++++++++++++++++=
++++++++++++++
> > >  1 files changed, 127 insertions(+), 0 deletions(-)
> > >
>=20
> > > +static ssize_t
> > > +badblocks_store(struct badblocks *bb, const char *page, size_t l=
en, int unack)
> > > +{
> > > +	unsigned long long sector;
> > > +	int length;
> > > +	char newline;
> > > +#ifdef DO_DEBUG
> > > +	/* Allow clearing via sysfs *only* for testing/debugging.
> > > +	 * Normally only a successful write may clear a badblock
> > > +	 */
> > > +	int clear =3D 0;
> > > +	if (page[0] =3D=3D '-') {
> > > +		clear =3D 1;
> > > +		page++;
> > > +	}
> > > +#endif /* DO_DEBUG */
> > > +
> > > +	switch (sscanf(page, "%llu %d%c", &sector, &length, &newline)) =
{
> >=20
> > What if user provides negative 'length' here? Should we check that =
case?
> >=20
>=20
> good point.  I've added an appropriate test.
>=20
> Thanks,
> NeilBrown
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 5de0c84..9ba76c7 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7844,6 +7844,8 @@ badblocks_store(struct badblocks *bb, const cha=
r *page, size_t len, int unack)
>  		if (newline !=3D '\n')
>  			return -EINVAL;
>  	case 2:
> +		if (length <=3D 0)
> +			return -EINVAL;
>  		break;
>  	default:
>  		return -EINVAL;

Reviewed-by: Namhyung Kim <namhyung@gmail.com>

Thanks.


--=20
Regards,
Namhyung Kim


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
