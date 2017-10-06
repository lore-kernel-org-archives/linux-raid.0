From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md: raid10: remove VLAIS
Date: Fri, 06 Oct 2017 13:22:12 +1100
Message-ID: <87a81510dn.fsf@notabene.neil.brown.name>
References: <20171005182847.3368-1-mka@chromium.org> <87k209170c.fsf@notabene.neil.brown.name> <20171006001917.GQ173745@google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171006001917.GQ173745@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthias Kaehlcke <mka@chromium.org>
Cc: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Michael Davidson <md@google.com>, Guenter Roeck <groeck@chromium.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 05 2017, Matthias Kaehlcke wrote:

> Hi Neil,
>
> El Fri, Oct 06, 2017 at 10:58:59AM +1100 NeilBrown ha dit:
>
>> On Thu, Oct 05 2017, Matthias Kaehlcke wrote:
>>=20
>> > The raid10 driver can't be built with clang since it uses a variable
>> > length array in a structure (VLAIS):
>> >
>> > drivers/md/raid10.c:4583:17: error: fields must have a constant size:
>> >   'variable length array in structure' extension will never be support=
ed
>> >
>> > Allocate the r10bio struct with kmalloc instead of using the VLAIS
>> > construct.
>> >
>> > Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
>> > ---
>> >  drivers/md/raid10.c | 13 ++++++++-----
>> >  1 file changed, 8 insertions(+), 5 deletions(-)
>> >
>> > diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> > index 374df5796649..9616163eaf8c 100644
>> > --- a/drivers/md/raid10.c
>> > +++ b/drivers/md/raid10.c
>> > @@ -4578,15 +4578,16 @@ static int handle_reshape_read_error(struct md=
dev *mddev,
>> >  	/* Use sync reads to get the blocks from somewhere else */
>> >  	int sectors =3D r10_bio->sectors;
>> >  	struct r10conf *conf =3D mddev->private;
>> > -	struct {
>> > -		struct r10bio r10_bio;
>> > -		struct r10dev devs[conf->copies];
>> > -	} on_stack;
>> > -	struct r10bio *r10b =3D &on_stack.r10_bio;
>> > +	struct r10bio *r10b;
>> >  	int slot =3D 0;
>> >  	int idx =3D 0;
>> >  	struct page **pages;
>> >=20=20
>> > +	r10b =3D kmalloc(sizeof(*r10b) +
>> > +	       sizeof(struct r10dev) * conf->copies, GFP_KERNEL);
>>=20
>> GFP_KERNEL isn't a good idea here.
>> This could wait for writeback, and if writeback tries to write to the
>> region of the array which is being reshaped, it might deadlock.
>>=20
>> GFP_NOIO is safer.
>
> Good point, thanks!
>
>> given that conf->copies is almost always 2 it might be nicer to
>> have
>>=20
>> 	struct {
>> 		struct r10bio r10_bio;
>> 		struct r10dev devs[2];
>> 	} on_stack;
>>=20
>>         struct r10bio *r10b;
>>=20
>> 	if (conf->copies <=3D ARRAY_SIZE(on_stack.devs))
>>         	r10b =3D &on_stack.r10_bio;
>>         else
>>         	r10b =3D kmalloc(sizeof(*r10b) +
>> 			       sizeof(struct r10dev) * conf->copies, GFP_NOIO);
>
> It would add also add an extra condition to determine if r10b needs to
> be freed or not.

True.

>
> Given that array reshaping is a rare operation and an error during
> this operation is an exceptional condition I think the simpler code
> with always dynamic allocation is preferable. That said I'm fine with
> reworking the patch according to your suggestion if you or Shaohua
> prefer it.

I don't feel strongly about it.  As long as the GFP_KERNEL->GFP_NOIO
change happens I'm OK with this patch.

Thanks,
NeilBrown

>
> Matthias
>
>> > +	if (!r10b)
>> > +		return -ENOMEM;
>> > +
>> >  	/* reshape IOs share pages from .devs[0].bio */
>> >  	pages =3D get_resync_pages(r10_bio->devs[0].bio)->pages;
>> >=20=20
>> > @@ -4635,11 +4636,13 @@ static int handle_reshape_read_error(struct md=
dev *mddev,
>> >  			/* couldn't read this block, must give up */
>> >  			set_bit(MD_RECOVERY_INTR,
>> >  				&mddev->recovery);
>> > +			kfree(r10b);
>> >  			return -EIO;
>> >  		}
>> >  		sectors -=3D s;
>> >  		idx++;
>> >  	}
>> > +	kfree(r10b);
>> >  	return 0;
>> >  }
>> >=20=20

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnW6NQACgkQOeye3VZi
gbmuShAApCr/YRyTdKqGFFR3WUfHPAz5+wG6ZmGN8UODRbgZHO0yxa8nIjHFl+bY
yxBJ5t20y6tHIK6zo/zHcpVhKYlIx56FQ9YSEWcoQ94j9qkyWp2mYNPDFwnrmnPC
EW0GOr9n/EcdMvdPH+Nu0fTrRADjnZu0dFxlfKfPJGSesOFKZP/pNH4saWdul0eL
LBV47FdVjFdWZkUocYxWGa+bVzKGZtLQxXXMoVH9f2LcTUoFJ79vEhGQ6vlFpqsh
8aw89nrgYQW9ThGuG1cFNFns8ahmMlz2f2NwUDf/rWQwHD3zAGso9XukQ/5MZApK
9sGFuycXvnOW15x7wN/tlAg9SyuAbfxtpkrleITP/h2ghUpCQjm8qy0pFvhKVcd1
eB9v2mWEpgESTxgNc8V5dwv/lTtms/nIZg90wbsFYkpCV6SWsP9NlBhfp5Aqdc48
PO+VYB15/QKoASBbFLyKgyvj5yaFJm0z8dNP1KaYGd4swe1Qjjn0pM6jxk5BGuxJ
+m2wXjdqEuIFCUXpnWsehZyCKsxGA04VYMo0MlXZrG/2DAijWyYNEbK02kITLWcD
CvujnaeCB6QEuGfZIH2YyT/WGD/rOINnZtOUAfWhWPU88Jx0ZqFR1uzbxj7cchQF
0QVvT61aJEgZw9rK0DlYDQkmRYOjJ6KnaNHNr+98ZuThDP2kISs=
=/X9O
-----END PGP SIGNATURE-----
--=-=-=--
