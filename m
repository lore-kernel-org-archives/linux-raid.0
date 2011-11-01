From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] kill-subarray: fix, IMSM cannot kill-subarray with
 unsupported metadata
Date: Tue, 1 Nov 2011 15:48:07 +1100
Message-ID: <20111101154807.0cf42aa5@notabene.brown>
References: <F9123E44003394499FDD2B17C60621D4043755@IRSMSX101.ger.corp.intel.com>
	<20111031113151.64f566b1@notabene.brown>
	<F9123E44003394499FDD2B17C60621D4043D80@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/6V7duoXccxXBVJ0ksAhLKrv"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F9123E44003394499FDD2B17C60621D4043D80@IRSMSX101.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Labun, Marcin" <Marcin.Labun@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

--Sig_/6V7duoXccxXBVJ0ksAhLKrv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 31 Oct 2011 16:52:22 +0000 "Labun, Marcin" <Marcin.Labun@intel.com>
wrote:

>=20
>=20
> > -----Original Message-----
> > From: NeilBrown [mailto:neilb@suse.de]
> > Sent: Monday, October 31, 2011 1:32 AM
> > To: Labun, Marcin
> > Cc: linux-raid@vger.kernel.org; Williams, Dan J
> > Subject: Re: [PATCH] kill-subarray: fix, IMSM cannot kill-subarray with
> > unsupported metadata
> >=20
> > On Fri, 28 Oct 2011 14:46:57 +0000 "Labun, Marcin"
> > <Marcin.Labun@intel.com>
> > wrote:
> >=20
> > > Hi Neil,
> > > Please review modified patch in response for your comments.
> > > I have introduced two flags, one for activation blocking, second for
> > > container wide reshapes
> > > Blocking:
> > > - some arrays in container are blocked, the others can be activated
> > > and reshaped,
> > > - some arrays are blocked, others can be activated but container wide
> > reshaped is blocked for all.
> > >
> > > Thanks,
> > > Marcin Labun
> >=20
> > Thanks.  This looks mostly OK.
> > I have applied it -  with a number of formatting improvements and the
> > removal for a debugging printf :-)
>=20
> Thanks!
> It seems that map_lock call appeared from *nowhere* in the modified patch=
 :). Please see the context below.

Thanks for checking and noticing that.
It was a merge error on my part.  As your patch added a map_unlock call I
reasoned that the map_lock call which you patch left unchanged needed to be
added back - I obviously wasn't thinking clearly.
I have removed it and the map_unlock that your patch added.


>=20
> -	/* do not assemble arrays that might have bad blocks */
> -	if (list && list->array.state & (1<<MD_SB_BBM_ERRORS)) {
> -		fprintf(stderr, Name ": BBM log found in metadata. "
> -					"Cannot activate array(s).\n");
> -		/* free container data and exit */
> -		sysfs_free(list);
> -		return 2;
> -	}
> -
> +	/* when nothing to activate - quit */
> +	if (list =3D=3D NULL)
> +		return 0;
> +	if (map_lock(&map))
> +		fprintf(stderr, Name ": failed to get exclusive lock on "
> +			"mapfile\n");
>=20
> >=20
> > However this bit looks wrong:
> >=20
> > > +/*
> > > + * helper routine to check metadata reshape avalability
> > > + * 1. Do not "grow" arrays with volume activation blocked
> > > + * 2. do not reshape containers with container reshape blocked
> > > + *
> > > + * IN:
> > > + *	subarray - array name or NULL for container wide reshape
> > > + *	content - md device info from container_content
> > > + * OUT:
> > > + *	0 - block reshape
> > > + */
> > > +static int check_reshape(char *subarray, struct mdinfo *content) {
> > > +	char *ep;
> > > +	unsigned int idx;
> > > +	printf("subarray: %s\n", subarray);
> > > +
> > > +
> > > +	if (!subarray) {
> > > +		if (content->array.state &
> > (1<<MD_SB_BLOCK_CONTAINER_RESHAPE))
> > > +			return 0;
> > > +	}
> > > +	else {
> > > +		/* do not "grow" arrays with volume activation blocked */
> > > +		idx =3D strtoul(subarray, &ep, 10);
> > > +		if ((*ep =3D=3D '\0') && (content->container_member =3D=3D (int)
> > idx) &&
> > > +		    (content->array.state & (1<<MD_SB_BLOCK_VOLUME)))
> > > +			return 0;
> > > +	}
> > > +
> > > +	return 1;
> > > +}
> >=20
> > Grow.c shouldn't be doing a 'strtoul' here.  The subarray string
> > belongs to the metadata handler, mdadm core code shouldn't interpret it
> > at all.
> >=20
> > What exactly is the point of that bit of code?
> >=20
> > Thanks,
> > NeilBrown
> Grow.c generates subarray string in super_by_fd() function.Derived from (=
struct mdinfo) sra->text_version.
>=20
> In check_reshape function I want to know on which subarray grow operates =
to get subarray blocking bits.

I think I see - thanks.

I have changed the code to do what I think it should.  Please review patch
below.

Thanks,
NeilBrown


commit 446894ea8db17a2dfc740f81d58190c5ac8167d5
Author: NeilBrown <neilb@suse.de>
Date:   Tue Nov 1 15:45:46 2011 +1100

    Grow: fix check_reshape and open_code it.
   =20
    check_reshape should not try to parse the subarray string - only
    metadata handlers are allowed to do that.
   =20
    The common code and only interpret a subarray string by passing it to
    "container_content" which will then return only the member for that
    subarray.
   =20
    So remove check_reshape and place similar logic explicitly at the two
    call-sites.  They are different enough that it is probably clearer to
    have explicit code.
   =20
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/Grow.c b/Grow.c
index 598fd59..8df4ac4 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1358,36 +1358,6 @@ static int reshape_container(char *container, char *=
devname,
 			     char *backup_file,
 			     int quiet, int restart, int freeze_reshape);
=20
-/*
- * helper routine to check metadata reshape avalability
- * 1. Do not "grow" arrays with volume activation blocked
- * 2. do not reshape containers with container reshape blocked
- *
- * IN:
- *	subarray - array name or NULL for container wide reshape
- *	content - md device info from container_content
- * OUT:
- *	0 - block reshape
- */
-static int check_reshape(char *subarray, struct mdinfo *content)
-{
-	char *ep;
-	unsigned int idx;
-
-	if (!subarray) {
-		if (content->array.state & (1<<MD_SB_BLOCK_CONTAINER_RESHAPE))
-			return 0;
-	} else {
-		/* do not "grow" arrays with volume activation blocked */
-		idx =3D strtoul(subarray, &ep, 10);
-		if (*ep =3D=3D '\0'
-		    && content->container_member =3D=3D (int) idx
-		    && (content->array.state & (1<<MD_SB_BLOCK_VOLUME)))
-			return 0;
-	}
-	return 1;
-}
-
 int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 		 long long size,
 		 int level, char *layout_str, int chunksize, int raid_disks,
@@ -1505,12 +1475,16 @@ int Grow_reshape(char *devname, int fd, int quiet, =
char *backup_file,
=20
 			cc =3D st->ss->container_content(st, subarray);
 			for (content =3D cc; content ; content =3D content->next) {
-				int allow_reshape;
+				int allow_reshape =3D 1;
=20
 				/* check if reshape is allowed based on metadata
 				 * indications stored in content.array.status
 				 */
-				allow_reshape =3D check_reshape(subarray, content);
+				if (content->array.state & (1<<MD_SB_BLOCK_VOLUME))
+					allow_reshape =3D 0;
+				if (content->array.state
+				    & (1<<MD_SB_BLOCK_CONTAINER_RESHAPE))
+					allow_reshape =3D 0;
 				if (!allow_reshape) {
 					fprintf(stderr, Name
 						" cannot reshape arrays in"
@@ -3788,10 +3762,10 @@ int Grow_continue_command(char *devname, int fd,
 			goto Grow_continue_command_exit;
 		}
=20
-		cc =3D st->ss->container_content(st, NULL);
+		cc =3D st->ss->container_content(st, subarray);
 		for (content =3D cc; content ; content =3D content->next) {
 			char *array;
-			int allow_reshape;
+			int allow_reshape =3D 1;
=20
 			if (content->reshape_active =3D=3D 0)
 				continue;
@@ -3800,10 +3774,14 @@ int Grow_continue_command(char *devname, int fd,
 			 * content->reshape_active state, therefore we
 			 * need to check_reshape based on
 			 * reshape_active and subarray name
-			*/
-			allow_reshape =3D
-			  check_reshape((content->reshape_active =3D=3D CONTAINER_RESHAPE)? NUL=
L : subarray,
-					content);
+			 */
+			if (content->array.state & (1<<MD_SB_BLOCK_VOLUME))
+				allow_reshape =3D 0;
+			if (content->reshape_active =3D=3D CONTAINER_RESHAPE &&
+			    (content->array.state
+			     & (1<<MD_SB_BLOCK_CONTAINER_RESHAPE)))
+				allow_reshape =3D 0;
+
 			if (!allow_reshape) {
 				fprintf(stderr, Name
 					": cannot continue reshape of an array"
diff --git a/super-intel.c b/super-intel.c
index 1caee70..34a4b34 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5759,8 +5759,8 @@ static struct mdinfo *container_content_imsm(struct s=
upertype *st, char *subarra
 						 map->num_members, /* raid disks */
 						 &chunk,
 						 1 /* verbose */)) {
-			fprintf(stderr, Name ": IMSM RAID gemetry validation failed. "
-				"Array %s activation is blocked.\n",
+			fprintf(stderr, Name ": IMSM RAID geometry validation"
+				" failed.  Array %s activation is blocked.\n",
 				dev->volume);
 			this->array.state |=3D
 			  (1<<MD_SB_BLOCK_CONTAINER_RESHAPE) |

--Sig_/6V7duoXccxXBVJ0ksAhLKrv
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTq96DDnsnt1WYoG5AQIU2w//eR8f6IM5XFeIbjMbH7dk2oht1DbFiN21
A/Ft8F1hmFsuHDmzAX8PIWjsRbBtsdwjhc5Vza0AH9F10zh3r0aPgTRNhs0g+soQ
aRzE9Yl056I3XrTRRZB0Rh2CnVYvR4kDZveKA9mYDJM9f4NOXvxHGIjaFHK0Sy9r
K0quMHrEk6FC2MElSx8ICEVEA0o2GYql/aRwTEP5ZHwI5zzrYkwbvEOCJqeuuw7Z
xTgIcr32jdbtOHJyocK3QpAQwCrFFTJ0WZ+jDY/UcU8StZm5QnaN2fD7ZdMwqITK
+Krc9JU5fj9UxzbCEidapoHzj+aOKnp3T2+/A2hZNXaUl30DDhAVobit9+j+jtih
Lox5Fs6ViOHOjtAgBWm4NFrhQUWtIIaIm/DylbwQZYpKGw3Fto/waLtITErecb+e
7lpK/BD7GToTXcKSX37TIJe71EX4l+svZkl59WJmrhVmvVBnwddB5kCzmXKv++qo
tH7FJIehxquERLTwN0Vj6FbcSvIWaosWGGIoXxvG1+JiC4aKfabXwRmNQ6JRxz1q
fer5POX3mDUdFDhZPBYFkyH74p9YR8MJkYHr8TxPrnR5wI7AqSXeAC/PY0fiG2kE
LZxVMbsDIyrpGlZXiZIH/PFF3brtSx8lU45fphX1ZGIiEdfsrLOv6ZmeJ8fyoVXX
+vd3gFDc7Oc=
=bIXB
-----END PGP SIGNATURE-----

--Sig_/6V7duoXccxXBVJ0ksAhLKrv--
