From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 08/12] FIX: use md position to reshape restart
Date: Thu, 9 Feb 2012 20:19:03 +1100
Message-ID: <20120209201903.24b899fb@notabene.brown>
References: <20120207135940.20627.33309.stgit@gklab-128-013.igk.intel.com>
	<20120207140359.20627.10861.stgit@gklab-128-013.igk.intel.com>
	<20120209123625.13dd5ae4@notabene.brown>
	<79556383A0E1384DB3A3903742AAC04A0986DE@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/39kPLXvf0tlU7_CHqoU8+qy"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <79556383A0E1384DB3A3903742AAC04A0986DE@IRSMSX101.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Dorau, Lukasz" <lukasz.dorau@intel.com>
List-Id: linux-raid.ids

--Sig_/39kPLXvf0tlU7_CHqoU8+qy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 9 Feb 2012 08:16:16 +0000 "Kwolek, Adam" <adam.kwolek@intel.com>
wrote:

>=20
>=20
> > -----Original Message-----
> > From: NeilBrown [mailto:neilb@suse.de]
> > Sent: Thursday, February 09, 2012 02:36
> > To: Kwolek, Adam
> > Cc: linux-raid@vger.kernel.org; Ciechanowski, Ed; Labun, Marcin; Willia=
ms, Dan
> > J; Dorau, Lukasz
> > Subject: Re: [PATCH 08/12] FIX: use md position to reshape restart
> >=20
> > On Tue, 07 Feb 2012 15:03:59 +0100 Adam Kwolek <adam.kwolek@intel.com>
> > wrote:
> >=20
> > > When reshape is broken, it can occur that metadata is not saved prope=
rly.
> > > This can cause that reshape process is farther in md than metadata st=
ates.
> > >
> > > On reshape restart use md position as start position, if it is farther
> > > than position specified in metadata. Opposite situation treat as erro=
r.
> > >
> > > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> > > ---
> > >
> > >  Grow.c |   86 +++++++++++++++++++++++++++++++++++++++++++++---------=
--
> > --------
> > >  1 files changed, 60 insertions(+), 26 deletions(-)
> > >
> > > diff --git a/Grow.c b/Grow.c
> > > index 70bdee1..0668a16 100644
> > > --- a/Grow.c
> > > +++ b/Grow.c
> > > @@ -1862,6 +1862,55 @@ release:
> > >  	return rv;
> > >  }
> > >
> > > +/* verify_reshape_position()
> > > + *	Function checks if reshape position in metadata is not farther
> > > + *	than position in md.
> > > + * Return value:
> > > + *	 0 : not valid sysfs entry
> > > + *		it can be caused by not started reshape, it should be started
> > > + *		by reshape array or raid0 array is before takeover
> > > + *	-1 :	error, reshape position is obviously wrong
> > > + *	 1 :	success, reshape progress correct or updated
> > > +*/
> > > +static int verify_reshape_position(struct mdinfo *info, int level) {
> > > +	int ret_val =3D 0;
> > > +	char buf[40];
> > > +
> > > +	/* read sync_max, failure can mean raid0 array */
> > > +	if (sysfs_get_str(info, NULL, "sync_max", buf, 40) > 0) {
> > > +		char *ep;
> > > +		unsigned long long position =3D strtoull(buf, &ep, 0);
> > > +
> > > +		dprintf(Name": Read sync_max sysfs entry is: %s\n", buf);
> > > +		if (!(ep =3D=3D buf || (*ep !=3D 0 && *ep !=3D '\n' && *ep !=3D ' =
'))) {
> > > +			position *=3D get_data_disks(level,
> > > +						   info->new_layout,
> > > +						   info->array.raid_disks);
> > > +			if (info->reshape_progress < position) {
> > > +				dprintf("Corrected reshape progress (%llu) to "
> > > +					"md position (%llu)\n",
> > > +					info->reshape_progress, position);
> > > +				info->reshape_progress =3D position;
> > > +				ret_val =3D 1;
> > > +			} else if (info->reshape_progress > position) {
> > > +				fprintf(stderr, Name ": Fatal error: array "
> > > +					"reshape was not properly frozen "
> > > +					"(expected reshape position is %llu, "
> > > +					"but reshape progress is %llu.\n",
> > > +					position, info->reshape_progress);
> > > +				ret_val =3D -1;
> > > +			} else {
> > > +				dprintf("Reshape position in md and metadata "
> > > +					"are the same;");
> > > +				ret_val =3D 1;
> > > +			}
> > > +		}
> > > +	}
> > > +
> > > +	return ret_val;
> > > +}
> > > +
> > >  static int reshape_array(char *container, int fd, char *devname,
> > >  			 struct supertype *st, struct mdinfo *info,
> > >  			 int force, struct mddev_dev *devlist, @@ -2251,9
> > +2300,16 @@
> > > started:
> > >
> > >  	sra->new_chunk =3D info->new_chunk;
> > >
> > > -	if (restart)
> > > +	if (restart) {
> > > +		/* for external metadata checkpoint saved by mdmon can be
> > lost
> > > +		 * or missed /due to e.g. crash/. Check if md is not during
> > > +		 * restart farther than metadata points to.
> > > +		 * If so, this means metadata information is obsolete.
> > > +		 */
> > > +		if (st->ss->external)
> > > +			verify_reshape_position(info, reshape.level);
> > >  		sra->reshape_progress =3D info->reshape_progress;
> > > -	else {
> > > +	} else {
> > >  		sra->reshape_progress =3D 0;
> > >  		if (reshape.after.data_disks < reshape.before.data_disks)
> > >  			/* start from the end of the new array */ @@ -3765,8
> > +3821,6 @@
> > > int Grow_continue_command(char *devname, int fd,
> > >  	char buf[40];
> > >  	int cfd =3D -1;
> > >  	int fd2 =3D -1;
> > > -	char *ep;
> > > -	unsigned long long position;
> > >
> > >  	dprintf("Grow continue from command line called for %s\n",
> > >  		devname);
> > > @@ -3894,28 +3948,8 @@ int Grow_continue_command(char *devname, int
> > fd,
> > >  	/* verify that array under reshape is started from
> > >  	 * correct position
> > >  	 */
> > > -	ret_val =3D sysfs_get_str(content, NULL, "sync_max", buf, 40);
> > > -	if (ret_val <=3D 0) {
> >                     ^^^
> >=20
> > This test is '<=3D' however ...
> >=20
> >=20
> > > -		fprintf(stderr, Name
> > > -			": cannot open verify reshape progress for %s (%i)\n",
> > > -			content->sys_name, ret_val);
> > > -		ret_val =3D 1;
> > > -		goto Grow_continue_command_exit;
> > > -	}
> > > -	dprintf(Name ": Read sync_max sysfs entry is: %s\n", buf);
> > > -	position =3D strtoull(buf, &ep, 0);
> > > -	if (ep =3D=3D buf || (*ep !=3D 0 && *ep !=3D '\n' && *ep !=3D ' '))=
 {
> > > -		fprintf(stderr, Name ": Fatal error: array reshape was"
> > > -			" not properly frozen\n");
> > > -		ret_val =3D 1;
> > > -		goto Grow_continue_command_exit;
> > > -	}
> > > -	position *=3D get_data_disks(map_name(pers, mdstat->level),
> > > -				   content->new_layout,
> > > -				   content->array.raid_disks);
> > > -	if (position !=3D content->reshape_progress) {
> > > -		fprintf(stderr, Name ": Fatal error: array reshape was"
> > > -			" not properly frozen.\n");
> > > +	if (verify_reshape_position(content,
> > > +				    map_name(pers, mdstat->level)) < 0) {
> >                                                                    ^^
> >=20
> > this one is just '<'.  However it looks like it should be the same.
> >=20
> > Was there a reason for the change, or was it an oversight?
> >=20
> > Thanks,
> > NeilBrown
> >=20
> >=20
> >=20
> >=20
> > >  		ret_val =3D 1;
> > >  		goto Grow_continue_command_exit;
> > >  	}
>=20
>=20
> Removed code is put in to function verify_reshape_position() for use in c=
urrent location and reshape_array(),
> as calculated new position in Grow_continue_command() cannot be passed to=
 reshape_array(), it has to be calculated again.
>=20
> This is what you are mention above?

Not exactly.

The original code would print an error if
      sysfs_get_str(content, NULL, "sync_max", buf, 40);
returns 0 or negative.
The new code will not print an error if that returns zero.

i.e. you changed a '<=3D' into a '<'.  I wondered if there was some reason =
for
that - something that I was missing.

NeilBrown


--Sig_/39kPLXvf0tlU7_CHqoU8+qy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTzOPhznsnt1WYoG5AQKs7A/+P8ia3DpBRTQwrKFawRK62MoHz3bo8qZ5
pCFG8JYsH3meQPvf7OFazVs89hqCv4aCzbo+tJH8cxiW1iL6BkQPQ1Ogr8hO/MZW
cqg98/riXGE0ZXuXQc9BkPJvAEE7BFUGHwTlSwoNBWFulPQnfurZ1uUAlm0GM7f1
Qf5eulpKgygYAR3GqqHd7WU2g16YutatyGxtnBhLlApxVme6D9CgU94rH/0JxoFV
CY6PXnlRJNNa7IySxgRiHkQcXsxfNTIGTJIkJWnGYkY6dKODbTzRlZcl0TF8AaSX
GQ+GwxHq8NcdGy+FvPnaxDZjANyEzevkFKCZxCzChI5SXy5l5sOKoFDIArKctvus
GD9al7OV0c951RjClGZA41jFF3Xc9dtCmGf4KV9KulB/fxZr7RE8RuruoWX7d4uV
1GnUln7iQfnkGwGgksO0sKAGz7njTgKpcoDAKyZLblT1rOHJ7WOtt4mG9N5hYxKD
k9t3VYNanlMI7A+YMBLhB6oIJdRbf+pgcaeHsa6cJ5PBkRaOpFRXUnHAdo/fGm5J
FE9te7z9jTy/46bnD/LPFYBpoTOtYsrTMjYvbUF9DCBLk/qe5ehP9ooTlnxMcQJe
Yo1l8rmE2PC4SV4S13h33HURm9OC/HRto1Ej/XQML42a3HJe5exNmFzozo3ejFn3
Q0UnSfCgRPg=
=9Hz8
-----END PGP SIGNATURE-----

--Sig_/39kPLXvf0tlU7_CHqoU8+qy--
