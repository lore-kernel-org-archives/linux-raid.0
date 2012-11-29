From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm --wait returns while array under construction? [patch
 question]
Date: Thu, 29 Nov 2012 12:35:11 +1100
Message-ID: <20121129123511.71a53bc8@notabene.brown>
References: <1353434141.27671.13.camel@corn.betterworld.us>
	<20121121084357.41f2f9d9@notabene.brown>
	<1354040913.27664.11.camel@corn.betterworld.us>
	<20121128083046.31bfa6e4@notabene.brown>
	<1354068620.27664.65.camel@corn.betterworld.us>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ocONzRADWf4plWIsbDgeQsO"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1354068620.27664.65.camel@corn.betterworld.us>
Sender: linux-raid-owner@vger.kernel.org
To: Ross Boylan <ross@biostat.ucsf.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/ocONzRADWf4plWIsbDgeQsO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 27 Nov 2012 18:10:20 -0800 Ross Boylan <ross@biostat.ucsf.edu> wrot=
e:

> On Wed, 2012-11-28 at 08:30 +1100, NeilBrown wrote:
> > On Tue, 27 Nov 2012 10:28:33 -0800 Ross Boylan <ross@biostat.ucsf.edu> =
wrote:
> >=20
> > > On Wed, 2012-11-21 at 08:43 +1100, NeilBrown wrote:
> > > > On Tue, 20 Nov 2012 09:55:41 -0800 Ross Boylan <ross@biostat.ucsf.e=
du> wrote:
> > > >=20
> > > > > While switching the disks a RAID 1 is based on I used the --wait =
command
> > > > > to wait for the rebuild to finish.  It returned immediately, but a
> > > > > subsequent query showed it had not been rebuilt.  Have I misunder=
stood
> > > > > something, or is this an error?
> > > > >=20
> > > > > While doing these commands a much larger rebuild was going on wit=
h a
> > > > > different array, involving some of the same physical disks but di=
fferent
> > > > > partitions.  The partitions being rebuilt are on different physic=
al
> > > > > disks for the different arrays.
> > > > >=20
> > > > > Here are the logs, with version info at the end (Debian Lenny + m=
ore
> > > > > recent kernel):
> > > > ....
> > > >=20
> > > > > markov:~# uname -a
> > > > > Linux markov 2.6.32-5-amd64 #1 SMP Wed Jan 12 03:40:32 UTC 2011 x=
86_64 GNU/Linux
> > > > > markov:~# mdadm --version
> > > > > mdadm - v2.6.7.2 - 14th November 2008
> > > > >=20
> > > > >=20
> > > > > I notice that in this case, unlike the other array, the message d=
uring
> > > > > the rebuild (the last detail report) does not include a line like
> > > > > Rebuild Status : 0% complete
> > > > >=20
> > > > > I just tried --wait again to see if there was some kind of race, =
but
> > > > > once again it returned immediately, though detail says the spare =
is
> > > > > rebuilding.
> > > >=20
> > > > Can you test this patch to see if it fixes the problem?
> > > >=20
> > > > diff --git a/Monitor.c b/Monitor.c
> > > > index c4d57c3..a5e7aaa 100644
> > > > --- a/Monitor.c
> > > > +++ b/Monitor.c
> > > > @@ -973,7 +973,7 @@ int Wait(char *dev)
> > > >  			if (e->devnum =3D=3D devnum)
> > > >  				break;
> > > > =20
> > > > -		if (!e || e->percent < 0) {
> > > > +		if (!e || e->percent =3D=3D RESYNC_NONE) {
> > > >  			if (e && e->metadata_version &&
> > > >  			    strncmp(e->metadata_version, "external:", 9) =3D=3D 0) {
> > > >  				if (is_subarray(&e->metadata_version[9]))
> > > >=20
> > > >=20
> > > > NeilBrown
> > > My source for 2.6.7.2 looks somewhat different.  It only has 627 line=
s;
> > > I think this is the relevant code (at the end of the file):
> > > /* Not really Monitor but ... */
> > > int Wait(char *dev)
> > > {
> > >         struct stat stb;
> > >         int devnum;
> > >         int rv =3D 1;
> > >=20
> > >         if (stat(dev, &stb) !=3D 0) {
> > >                 fprintf(stderr, Name ": Cannot find %s: %s\n", dev,
> > >                         strerror(errno));
> > >                 return 2;
> > >         }
> > >         if (major(stb.st_rdev) =3D=3D MD_MAJOR)
> > >                 devnum =3D minor(stb.st_rdev);
> > >         else
> > >                 devnum =3D -1-(minor(stb.st_rdev)/64);
> > >=20
> > >         while(1) {
> > >                 struct mdstat_ent *ms =3D mdstat_read(1, 0);
> > >                 struct mdstat_ent *e;
> > >=20
> > >                 for (e=3Dms ; e; e=3De->next)
> > >                         if (e->devnum =3D=3D devnum)
> > >                                 break;
> > >=20
> > >                 if (!e || e->percent < 0) {
> > >                         free_mdstat(ms);
> > >                         return rv;
> > >                 }
> > >                 free(ms);
> > >                 rv =3D 0;
> > >                 mdstat_wait(5);
> > >         }
> > > }
> > >=20
> > >=20
> > > The section
> > >                 if (!e || e->percent < 0) {
> > >                         free_mdstat(ms);
> > >                         return rv;
> > >  is the only one with e->percent < 0.  Is it OK to change that to=20
> > > if (!e || e->percent =3D=3D RESYNC_NONE) {?
> > >=20
> > >
> >=20
> > That's the right place to make the change, bit it won't compile.
> > RESYNC_NONE isn't defined in that version of mdadm, and you would need =
to
> > make some changes in mdstat.c where ent->percent is set.
> > Current code has
> >=20
> >=20
> > 				if (l > 8 && strcmp(w+l-8, "=3DDELAYED") =3D=3D 0)
> > 					ent->percent =3D RESYNC_DELAYED;
> > 				if (l > 8 && strcmp(w+l-8, "=3DPENDING") =3D=3D 0)
> > 					ent->percent =3D RESYNC_PENDING;
> >=20
> > which is completely missing from 2.6.7.2.  You'd be a lot better off st=
arting
> > with 3.2.6 and adding the patch to that.
> >=20
> > NeilBrown
> I think I'm going to have to pass on testing for now, as the
> alternatives appear too high risk:
> 1) I got the debianized source for 3.2.5 (for some reason 3.2.6 is not
> there yet).  It depends on a variety of package versions that post-date
> my lenny system.  So it will not install unless I override those, or
> located/backport more recent versions of the other packages.  Since this
> is messing with core areas of the system (grub, udev, initscripts) it
> seems unwise to attempt backports.
>=20
> 2) I considered patching 2.6.7.2 in place with the additional info you
> provided, but I'm not sure if you're sayiing the mdstat.c changes alone
> are sufficient, or if I need to change Monitor.c in some way.

Looks like I communicated quite effectively :-)  I'm not sure.  I thought
about making a patch fro 2.6.7.2 and quickly decided that just upgrading
would be easiest.
You don't need to use the debian version.   Just
  git clone git://neil.brown.name/mdadm
  cd mdadm
  git checkout 3.2.5
  make
  make install

Of course you would void your support contract with Debian....

>=20
> 3) I could just dump your 3.2.6 upstream source over my current 2.6.7.2
> Debianized directory.  But then I'd need to figure out what Debian
> patches I need to reapply, and wonder if it would all work in a Lenny
> environment.

I don't think you need any Debian patches.

>=20
> I'd like to help, but since this is just a reporting problem for me I
> don't want to risk screwing things up further.  I might be able to do 2)
> with a little more information.
>=20
> BTW, I reviewed the udev rules for mdadm on my system and in the 2.6.7.2
> package, and it does not  appear that incremental assembly is being
> attempted.  That's not relevant to this  thread, but does matter for
> some of my other ones.  Also, the 3.2.5 Debian package's udev rules say
> ## DISABLED: Incremental udev assembly disabled
> ## ** this is a Debian-specific change **
> GOTO=3D"md_inc_skip"
>=20
>=20

Ahhh.. "make install" will change the udev script.  So maybe "make install"
wouldn't quite be such a good idea.

NeilBrown



--Sig_/ocONzRADWf4plWIsbDgeQsO
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBULa7zznsnt1WYoG5AQJyxxAAm85Uro7sF0YsWMdRfylrB9fQImm6O7lu
fzb5Mxln8XtuyKmTv04BYZKO+JNB0e6pw3a09EpLrLwt2ZpG71HYshuV/r7OqfbR
+NSca995hIX71/Rb50WEoCWqApTtvzrds/7cxL7qPOe5zkWAk/uFEjUlKj2aa1Gv
sp11dhiBhN3tvJ9FDl3mIupCZcKdjXO+VKPYTKUOZkM8baM6Z3R+cZ5JaHIhuJQh
uypUNJq5SlVms5dU8j8v4OrLNIGJWae9pO6hPGX3/LMrc2dwGXEdMDG/y6E0ocLh
mYx1fn0BPp4dkDHQVnO0238A9SXLaZzjDt1Z1k+SemuuGxBqckmfIRGfIcA7QkLS
w/rpjZd2Fkl/pqtuE0e3EQftheAQ+cQh6tEO+EYTg1KtSHm4+dQJ73V3KjDrbMB7
OB4v5rHYb710nQSvIhUvWinzz+uUkN36cF/sq/2IynCmD8Fy0wLwefaESJ+oR/dy
EOceAw8NSSCYQ80JbBzERvcGpuzzAm9jjP+wBQuyiUXx/SOwyN2HOF2aMzDX9HB/
Mi+3d9CoW74zp45YGfeOYRqUgxxPOMrIniuGGvVeaymJqMEa4n76iXwfiBFzTKGh
pHANQeklV88IxN3Gkpykm6diAxqr35EGhfX2EjqfQi92hd1aHs03iy2XAw0IgyiY
fcilzuhYf7g=
=GTk8
-----END PGP SIGNATURE-----

--Sig_/ocONzRADWf4plWIsbDgeQsO--
