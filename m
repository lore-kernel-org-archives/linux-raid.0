From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm --wait returns while array under construction? [patch
 question]
Date: Wed, 28 Nov 2012 08:30:46 +1100
Message-ID: <20121128083046.31bfa6e4@notabene.brown>
References: <1353434141.27671.13.camel@corn.betterworld.us>
	<20121121084357.41f2f9d9@notabene.brown>
	<1354040913.27664.11.camel@corn.betterworld.us>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Yq5WObgxqzML8bs/JVOriA2"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1354040913.27664.11.camel@corn.betterworld.us>
Sender: linux-raid-owner@vger.kernel.org
To: Ross Boylan <ross@biostat.ucsf.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Yq5WObgxqzML8bs/JVOriA2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 27 Nov 2012 10:28:33 -0800 Ross Boylan <ross@biostat.ucsf.edu> wrot=
e:

> On Wed, 2012-11-21 at 08:43 +1100, NeilBrown wrote:
> > On Tue, 20 Nov 2012 09:55:41 -0800 Ross Boylan <ross@biostat.ucsf.edu> =
wrote:
> >=20
> > > While switching the disks a RAID 1 is based on I used the --wait comm=
and
> > > to wait for the rebuild to finish.  It returned immediately, but a
> > > subsequent query showed it had not been rebuilt.  Have I misunderstood
> > > something, or is this an error?
> > >=20
> > > While doing these commands a much larger rebuild was going on with a
> > > different array, involving some of the same physical disks but differ=
ent
> > > partitions.  The partitions being rebuilt are on different physical
> > > disks for the different arrays.
> > >=20
> > > Here are the logs, with version info at the end (Debian Lenny + more
> > > recent kernel):
> > ....
> >=20
> > > markov:~# uname -a
> > > Linux markov 2.6.32-5-amd64 #1 SMP Wed Jan 12 03:40:32 UTC 2011 x86_6=
4 GNU/Linux
> > > markov:~# mdadm --version
> > > mdadm - v2.6.7.2 - 14th November 2008
> > >=20
> > >=20
> > > I notice that in this case, unlike the other array, the message during
> > > the rebuild (the last detail report) does not include a line like
> > > Rebuild Status : 0% complete
> > >=20
> > > I just tried --wait again to see if there was some kind of race, but
> > > once again it returned immediately, though detail says the spare is
> > > rebuilding.
> >=20
> > Can you test this patch to see if it fixes the problem?
> >=20
> > diff --git a/Monitor.c b/Monitor.c
> > index c4d57c3..a5e7aaa 100644
> > --- a/Monitor.c
> > +++ b/Monitor.c
> > @@ -973,7 +973,7 @@ int Wait(char *dev)
> >  			if (e->devnum =3D=3D devnum)
> >  				break;
> > =20
> > -		if (!e || e->percent < 0) {
> > +		if (!e || e->percent =3D=3D RESYNC_NONE) {
> >  			if (e && e->metadata_version &&
> >  			    strncmp(e->metadata_version, "external:", 9) =3D=3D 0) {
> >  				if (is_subarray(&e->metadata_version[9]))
> >=20
> >=20
> > NeilBrown
> My source for 2.6.7.2 looks somewhat different.  It only has 627 lines;
> I think this is the relevant code (at the end of the file):
> /* Not really Monitor but ... */
> int Wait(char *dev)
> {
>         struct stat stb;
>         int devnum;
>         int rv =3D 1;
>=20
>         if (stat(dev, &stb) !=3D 0) {
>                 fprintf(stderr, Name ": Cannot find %s: %s\n", dev,
>                         strerror(errno));
>                 return 2;
>         }
>         if (major(stb.st_rdev) =3D=3D MD_MAJOR)
>                 devnum =3D minor(stb.st_rdev);
>         else
>                 devnum =3D -1-(minor(stb.st_rdev)/64);
>=20
>         while(1) {
>                 struct mdstat_ent *ms =3D mdstat_read(1, 0);
>                 struct mdstat_ent *e;
>=20
>                 for (e=3Dms ; e; e=3De->next)
>                         if (e->devnum =3D=3D devnum)
>                                 break;
>=20
>                 if (!e || e->percent < 0) {
>                         free_mdstat(ms);
>                         return rv;
>                 }
>                 free(ms);
>                 rv =3D 0;
>                 mdstat_wait(5);
>         }
> }
>=20
>=20
> The section
>                 if (!e || e->percent < 0) {
>                         free_mdstat(ms);
>                         return rv;
>  is the only one with e->percent < 0.  Is it OK to change that to=20
> if (!e || e->percent =3D=3D RESYNC_NONE) {?
>=20
>

That's the right place to make the change, bit it won't compile.
RESYNC_NONE isn't defined in that version of mdadm, and you would need to
make some changes in mdstat.c where ent->percent is set.
Current code has


				if (l > 8 && strcmp(w+l-8, "=3DDELAYED") =3D=3D 0)
					ent->percent =3D RESYNC_DELAYED;
				if (l > 8 && strcmp(w+l-8, "=3DPENDING") =3D=3D 0)
					ent->percent =3D RESYNC_PENDING;

which is completely missing from 2.6.7.2.  You'd be a lot better off starti=
ng
with 3.2.6 and adding the patch to that.

NeilBrown

--Sig_/Yq5WObgxqzML8bs/JVOriA2
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBULUxBjnsnt1WYoG5AQKisRAAjEr+xNEJB7gp9yCfUGVtGWCsGUBWGSu4
KAzFhWUxNup3iyXgNCKWJoXvQSikMCBmBsnIfY3FEG+d7s+7x24OjcwuizzXmYoT
xs1NYwqS0MdUeV49uMMvSqWNXKqQ4OD6ilR+SUG3rGdQdyEyRbwfJ9ialV30fljx
A9EZvrcZ0ffdYaYbukTPKk+zCGicQSsNnWjPQ3Cwbr2rXIWuhg2/90KYWoPUEDWg
5Dd8gP+zu1shbl51iENXiTks3bIrN+mca6mwIdYS373BloLSgiJl2S7n94fJWcgE
NxKtemMwc/m7UT+woRqj1Ibl+flIm1dADRINFObxoS1mtVgqtTbRc+qFOKsyjqo7
BYdMSCGMEUMgjyfFdIr6/JNVlQertpIc2TJFQAv1xnvezffiCVrCPa557L08Ev4g
hX78HpO8f1JuGuGB4NORUKbXWmtnIbnSKgeOk2YJk5LkxuwLNR8D6COr6D0bbHI0
eYxNuuTp0pbUZJ9H1KvotN7xCIy5XLG/Efg/ALcakun1vg+4hxdqNUJ/greInVI2
Q/fw2VDsic7WS1D3Qmxl90aDEhGtn/uV1IaslkPAag56Vkmp0jtwxmRRqIvm6YfZ
bLnsWa2wNiizUKANzhLfxYH6X0CVI8ghSfXxlSipsCablArKaeQDQMAdAf2M4W/a
OKM1wkhfsVY=
=ku18
-----END PGP SIGNATURE-----

--Sig_/Yq5WObgxqzML8bs/JVOriA2--
