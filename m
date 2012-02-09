From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 08/12] FIX: use md position to reshape restart
Date: Thu, 9 Feb 2012 21:19:30 +1100
Message-ID: <20120209211930.5a899e4b@notabene.brown>
References: <20120207135940.20627.33309.stgit@gklab-128-013.igk.intel.com>
	<20120207140359.20627.10861.stgit@gklab-128-013.igk.intel.com>
	<20120209123625.13dd5ae4@notabene.brown>
	<79556383A0E1384DB3A3903742AAC04A0986DE@IRSMSX101.ger.corp.intel.com>
	<20120209201903.24b899fb@notabene.brown>
	<79556383A0E1384DB3A3903742AAC04A0987B0@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/P6MO3Urg+HEVW=Qm8iQO72G"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <79556383A0E1384DB3A3903742AAC04A0987B0@IRSMSX101.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Dorau, Lukasz" <lukasz.dorau@intel.com>
List-Id: linux-raid.ids

--Sig_/P6MO3Urg+HEVW=Qm8iQO72G
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 9 Feb 2012 09:49:01 +0000 "Kwolek, Adam" <adam.kwolek@intel.com>
wrote:

>=20
>=20
> > -----Original Message-----
> > From: NeilBrown [mailto:neilb@suse.de]
> > Sent: Thursday, February 09, 2012 10:19
> > To: Kwolek, Adam
> > Cc: linux-raid@vger.kernel.org; Ciechanowski, Ed; Labun, Marcin; Willia=
ms, Dan
> > J; Dorau, Lukasz
> > Subject: Re: [PATCH 08/12] FIX: use md position to reshape restart
> >=20
> > On Thu, 9 Feb 2012 08:16:16 +0000 "Kwolek, Adam" <adam.kwolek@intel.com>
> > wrote:
> >=20
> > >
> > >
> > > > -----Original Message-----
> > > > From: NeilBrown [mailto:neilb@suse.de]
> > > > Sent: Thursday, February 09, 2012 02:36
> > > > To: Kwolek, Adam
> > > > Cc: linux-raid@vger.kernel.org; Ciechanowski, Ed; Labun, Marcin;
> > > > Williams, Dan J; Dorau, Lukasz
> > > > Subject: Re: [PATCH 08/12] FIX: use md position to reshape restart
> > > >
> > > > On Tue, 07 Feb 2012 15:03:59 +0100 Adam Kwolek
> > > > <adam.kwolek@intel.com>
> > > > wrote:
> > > >
> > > > > When reshape is broken, it can occur that metadata is not saved p=
roperly.
> > > > > This can cause that reshape process is farther in md than metadat=
a states.
> > > > >
> > > > > On reshape restart use md position as start position, if it is
> > > > > farther than position specified in metadata. Opposite situation t=
reat as
> > error.
> > > > >
> > > > > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> > > > > ---
> > > > >
> > > > >  Grow.c |   86 +++++++++++++++++++++++++++++++++++++++++++++------
> > -----
> > > > --------
> > > > >  1 files changed, 60 insertions(+), 26 deletions(-)
> > > > >
> > > > > diff --git a/Grow.c b/Grow.c
> > > > > index 70bdee1..0668a16 100644
> > > > > --- a/Grow.c
> > > > > +++ b/Grow.c
> > > > > @@ -1862,6 +1862,55 @@ release:
> > > > >  	return rv;
> > > > >  }
> > > > >
> > > > > +/* verify_reshape_position()
> > > > > + *	Function checks if reshape position in metadata is not farther
> > > > > + *	than position in md.
> > > > > + * Return value:
> > > > > + *	 0 : not valid sysfs entry
> > > > > + *		it can be caused by not started reshape, it should be
> > started
> > > > > + *		by reshape array or raid0 array is before takeover
> > > > > + *	-1 :	error, reshape position is obviously wrong
> > > > > + *	 1 :	success, reshape progress correct or updated
> > > > > +*/
> > > > > +static int verify_reshape_position(struct mdinfo *info, int leve=
l) {
> > > > > +	int ret_val =3D 0;
> > > > > +	char buf[40];
> > > > > +
> > > > > +	/* read sync_max, failure can mean raid0 array */
> > > > > +	if (sysfs_get_str(info, NULL, "sync_max", buf, 40) > 0) {
> > > > > +		char *ep;
> > > > > +		unsigned long long position =3D strtoull(buf, &ep, 0);
> > > > > +
> > > > > +		dprintf(Name": Read sync_max sysfs entry is: %s\n", buf);
> > > > > +		if (!(ep =3D=3D buf || (*ep !=3D 0 && *ep !=3D '\n' && *ep !=
=3D ' '))) {
> > > > > +			position *=3D get_data_disks(level,
> > > > > +						   info->new_layout,
> > > > > +						   info->array.raid_disks);
> > > > > +			if (info->reshape_progress < position) {
> > > > > +				dprintf("Corrected reshape progress (%llu) to "
> > > > > +					"md position (%llu)\n",
> > > > > +					info->reshape_progress, position);
> > > > > +				info->reshape_progress =3D position;
> > > > > +				ret_val =3D 1;
> > > > > +			} else if (info->reshape_progress > position) {
> > > > > +				fprintf(stderr, Name ": Fatal error: array "
> > > > > +					"reshape was not properly frozen "
> > > > > +					"(expected reshape position is %llu, "
> > > > > +					"but reshape progress is %llu.\n",
> > > > > +					position, info->reshape_progress);
> > > > > +				ret_val =3D -1;
> > > > > +			} else {
> > > > > +				dprintf("Reshape position in md and metadata "
> > > > > +					"are the same;");
> > > > > +				ret_val =3D 1;
> > > > > +			}
> > > > > +		}
> > > > > +	}
> > > > > +
> > > > > +	return ret_val;
> > > > > +}
> > > > > +
> > > > >  static int reshape_array(char *container, int fd, char *devname,
> > > > >  			 struct supertype *st, struct mdinfo *info,
> > > > >  			 int force, struct mddev_dev *devlist, @@ -2251,9
> > > > +2300,16 @@
> > > > > started:
> > > > >
> > > > >  	sra->new_chunk =3D info->new_chunk;
> > > > >
> > > > > -	if (restart)
> > > > > +	if (restart) {
> > > > > +		/* for external metadata checkpoint saved by mdmon can be
> > > > lost
> > > > > +		 * or missed /due to e.g. crash/. Check if md is not during
> > > > > +		 * restart farther than metadata points to.
> > > > > +		 * If so, this means metadata information is obsolete.
> > > > > +		 */
> > > > > +		if (st->ss->external)
> > > > > +			verify_reshape_position(info, reshape.level);
> > > > >  		sra->reshape_progress =3D info->reshape_progress;
> > > > > -	else {
> > > > > +	} else {
> > > > >  		sra->reshape_progress =3D 0;
> > > > >  		if (reshape.after.data_disks < reshape.before.data_disks)
> > > > >  			/* start from the end of the new array */ @@ -3765,8
> > > > +3821,6 @@
> > > > > int Grow_continue_command(char *devname, int fd,
> > > > >  	char buf[40];
> > > > >  	int cfd =3D -1;
> > > > >  	int fd2 =3D -1;
> > > > > -	char *ep;
> > > > > -	unsigned long long position;
> > > > >
> > > > >  	dprintf("Grow continue from command line called for %s\n",
> > > > >  		devname);
> > > > > @@ -3894,28 +3948,8 @@ int Grow_continue_command(char *devname,
> > > > > int
> > > > fd,
> > > > >  	/* verify that array under reshape is started from
> > > > >  	 * correct position
> > > > >  	 */
> > > > > -	ret_val =3D sysfs_get_str(content, NULL, "sync_max", buf, 40);
> > > > > -	if (ret_val <=3D 0) {
> > > >                     ^^^
> > > >
> > > > This test is '<=3D' however ...
> > > >
> > > >
> > > > > -		fprintf(stderr, Name
> > > > > -			": cannot open verify reshape progress for %s (%i)\n",
> > > > > -			content->sys_name, ret_val);
> > > > > -		ret_val =3D 1;
> > > > > -		goto Grow_continue_command_exit;
> > > > > -	}
> > > > > -	dprintf(Name ": Read sync_max sysfs entry is: %s\n", buf);
> > > > > -	position =3D strtoull(buf, &ep, 0);
> > > > > -	if (ep =3D=3D buf || (*ep !=3D 0 && *ep !=3D '\n' && *ep !=3D '=
 ')) {
> > > > > -		fprintf(stderr, Name ": Fatal error: array reshape was"
> > > > > -			" not properly frozen\n");
> > > > > -		ret_val =3D 1;
> > > > > -		goto Grow_continue_command_exit;
> > > > > -	}
> > > > > -	position *=3D get_data_disks(map_name(pers, mdstat->level),
> > > > > -				   content->new_layout,
> > > > > -				   content->array.raid_disks);
> > > > > -	if (position !=3D content->reshape_progress) {
> > > > > -		fprintf(stderr, Name ": Fatal error: array reshape was"
> > > > > -			" not properly frozen.\n");
> > > > > +	if (verify_reshape_position(content,
> > > > > +				    map_name(pers, mdstat->level)) < 0) {
> > > >
> > > > ^^
> > > >
> > > > this one is just '<'.  However it looks like it should be the same.
> > > >
> > > > Was there a reason for the change, or was it an oversight?
> > > >
> > > > Thanks,
> > > > NeilBrown
> > > >
> > > >
> > > >
> > > >
> > > > >  		ret_val =3D 1;
> > > > >  		goto Grow_continue_command_exit;
> > > > >  	}
> > >
> > >
> > > Removed code is put in to function verify_reshape_position() for use
> > > in current location and reshape_array(), as calculated new position in
> > Grow_continue_command() cannot be passed to reshape_array(), it has to =
be
> > calculated again.
> > >
> > > This is what you are mention above?
> >=20
> > Not exactly.
> >=20
> > The original code would print an error if
> >       sysfs_get_str(content, NULL, "sync_max", buf, 40); returns 0 or n=
egative.
> > The new code will not print an error if that returns zero.
> >=20
> > i.e. you changed a '<=3D' into a '<'.  I wondered if there was some rea=
son for that -
> > something that I was missing.
> >=20
> > NeilBrown
>=20
> Yes, you are right. I've missed '0' case during code reorganization.
> You would fix this or you want me to post additional patch?

Thanks.
I already fixed it - I've just pushed my current tree with all your patches
out.

Thanks,
NeilBrown

--Sig_/P6MO3Urg+HEVW=Qm8iQO72G
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTzOdsjnsnt1WYoG5AQJzbg/9H3ClSnoAX666ZY0b94bwcjPEU+NzUdO9
vMMTFvO5U43LSvUKxOzAcKnkueNO12WaQ6mz/yDnBLfKazcWXxyCiDC/HF6VBeOA
cjIZYKpdFrl3dsj0mpht75sriMl7d9Y7qU54gUsoHrgEqaron8G+mwrXOcb2iJzf
4yft4fzl8uYwaMtAiU8P9gy5S6O3V++5QUgMgbzwi1tgFPd2fNtesps/SuvYlz9z
k/mva2DBiR+Y1TjuAstX5eyTzJ3OCIakiMeofRjDR7JR51N4Ef4kG+c70/vl+Er/
8JmSUfV4OL9Rn13sZz86eOxuNsrZbkyNeD1mMPTZM4FoYQqBpAdepRpy9Q4iXATq
SSDd+V7eAjTu2ZelhckrqSrKeKegNKlkaH57DBNNjIpgHMG3Aq0qvJO+zwMbuQNQ
T0DTMx3+6yWceSr5NlkNHXd8y0qTVhGUwtK2965OJh/YQHxI15Z8FS+zj+7sO05w
ImVoNHx015C6YCCWCIQbcfytKMa7g6V1EmLOlU04xZCHjp32Y0gbGw58+CqltvLX
6ImRFoM1aXYqJxLLE3UHiHjmVkDuaQiByRVe6vhsu9xe7CYvmqCj6pL0H1bLBpTw
U1BZOilRf3+CbmXGWaHRtCQm4E3X0EtykZvgUgE3nqNyZ5ukxApq1DmDQ8IgbWcC
Kghw7deT0eo=
=xYZd
-----END PGP SIGNATURE-----

--Sig_/P6MO3Urg+HEVW=Qm8iQO72G--
