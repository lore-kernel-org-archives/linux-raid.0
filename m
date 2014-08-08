From: NeilBrown <neilb@suse.de>
Subject: Re: After reshaping raid1 to raid0 with bitmap, then stop md panic
Date: Fri, 8 Aug 2014 15:45:06 +1000
Message-ID: <20140808154506.544472c2@notabene.brown>
References: <324320204.17911195.1407221719669.JavaMail.zimbra@redhat.com>
	<11051344.17913061.1407222186494.JavaMail.zimbra@redhat.com>
	<20140806163702.15592dc6@notabene.brown>
	<1783178354.19231525.1407405817606.JavaMail.zimbra@redhat.com>
	<20140807202913.570be307@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/eTgI4V3Gn+jx0REs.1A2B9C"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140807202913.570be307@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, Jes Sorensen <jes.sorensen@redhat.com>
List-Id: linux-raid.ids

--Sig_/eTgI4V3Gn+jx0REs.1A2B9C
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 7 Aug 2014 20:29:13 +1000 NeilBrown <neilb@suse.de> wrote:

> On Thu, 7 Aug 2014 06:03:37 -0400 (EDT) Xiao Ni <xni@redhat.com> wrote:
>=20
> >=20
> >=20
> > ----- Original Message -----
> > > From: "NeilBrown" <neilb@suse.de>
> > > To: "Xiao Ni" <xni@redhat.com>
> > > Cc: linux-raid@vger.kernel.org, "Jes Sorensen" <jes.sorensen@redhat.c=
om>
> > > Sent: Wednesday, August 6, 2014 2:37:02 PM
> > > Subject: Re: After reshaping raid1 to raid0 with bitmap, then stop md=
 panic
> > >=20
> > > On Tue, 5 Aug 2014 03:03:06 -0400 (EDT) Xiao Ni <xni@redhat.com> wrot=
e:
> > >=20
> > > > Dear all
> > > >=20
> > > >=20
> > > >    I faced one problem that the system panic after reshaping raid1 =
to raid0
> > > >    with bitmap.
> > > > The dmesg and calltrace information is like this:
> > > >=20
> > > >    You can easily reproduce this by those steps:
> > > >    1. mdadm -CR /dev/md0 -l1 -n2 /dev/loop[0-1] --bitmap=3Dinternal
> > > >    2. mdadm --wait /dev/md0
> > > >    3. mdadm --grow -l0 /dev/md0
> > > >    4. mdadm -S /dev/md0
> > > ...
> > > >=20
> > > > [ 1485.646746] BUG: unable to handle kernel NULL pointer dereferenc=
e at
> > > > 0000000000000038
> > > > [ 1485.654724] IP: [<ffffffff8148db2e>] bitmap_daemon_work+0x24e/0x=
450
> > >=20
> > > Yes, RAID0 doesn't support bitmaps, so this cannot possibly work.
> > >=20
> > > Following patch should turn the crash into a clean failure.
> > >=20
> > > Thanks for the report,
> > > NeilBrown
> > >=20
> > >=20
> > > From 1bdb20e16166240a4ca3b861c48defefaf218874 Mon Sep 17 00:00:00 2001
> > > From: NeilBrown <neilb@suse.de>
> > > Date: Wed, 6 Aug 2014 16:34:27 +1000
> > > Subject: [PATCH] md: check for bitmap compatability when changing raid
> > > levels.
> > >=20
> > > If an array has a bitmap, then it cannot be converted to
> > > a level which does not support bitmaps.
> > >=20
> > > Reported-by: Xiao Ni <xni@redhat.com>
> > > Signed-off-by: NeilBrown <neilb@suse.de>
> > >=20
> > > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > > index 1379b1a3b9ff..3bd13b276e45 100644
> > > --- a/drivers/md/md.c
> > > +++ b/drivers/md/md.c
> > > @@ -3500,6 +3500,12 @@ level_store(struct mddev *mddev, const char *b=
uf,
> > > size_t len)
> > >  		       mdname(mddev), clevel);
> > >  		return -EINVAL;
> > >  	}
> > > +	if (mddev->bitmap && !pers->quiesce) {
> > > +		module_put(pers->owner);
> > > +		printk(KERN_WARNING "md: %s: %s does not support a bitmap\n",
> > > +		       mdname(mddev), clevel);
> > > +		return -EINVAL;
> > > +	}
> > > =20
> > >  	rdev_for_each(rdev, mddev)
> > >  		rdev->new_raid_disk =3D rdev->raid_disk;
> > >=20
> >=20
> > Hi Neil
> >=20
> >    I have tried the patch, but it can reshape to raid0 still, then stop=
 the raid0, the system
> > panics.
> >=20
> >    What does pers->quiesce mean? I'm not familiar with md code.=20
> >=20
> > Best Regards
> > Xiao
>=20
>=20
> "quiesce" is a function that makes the array "quiescent" - it stops all IO
> from happening.
> The set_bitmap_file() function has:
>=20
> 	if (mddev->pers) {
> 		if (!mddev->pers->quiesce)
> 			return -EBUSY;
>=20
>=20
> So I thought it was safe to assume that if there was a quiesce function t=
hen
> the personality handled bitmaps.  Obviously not.
> I'll have to fix that up...

Can you confirm that this works please?
Thanks.

NeilBrown

=46rom a8461a61c241a25afedbe493c13d98a6e0cf4246 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Wed, 6 Aug 2014 16:34:27 +1000
Subject: [PATCH] md/raid0: check for bitmap compatability when changing raid
 levels.

If an array has a bitmap, then it cannot be converted to raid0.

Reported-by: Xiao Ni <xni@redhat.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 407a99e46f69..cf91f5910c7c 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -685,6 +685,12 @@ static void *raid0_takeover(struct mddev *mddev)
 	 *  raid10 - assuming we have all necessary active disks
 	 *  raid1 - with (N -1) mirror drives faulty
 	 */
+
+	if (mddev->bitmap) {
+		printk(KERN_ERR "md/raid0: %s: cannot takeover array with bitmap\n",
+		       mdname(mddev));
+		return ERR_PTR(-EBUSY);
+	}
 	if (mddev->level =3D=3D 4)
 		return raid0_takeover_raid45(mddev);
=20



--Sig_/eTgI4V3Gn+jx0REs.1A2B9C
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU+Rj4jnsnt1WYoG5AQLWVxAAnK7azVYzxU+5HU4yOwatjx9csF6a7kbH
csd+zNvCw9kh0UGyMkdGcNj0eE16oh1Fx4ujeBgHzfmgK60FI355DONeGrhjLLAK
lUOsZAsNXFXtjv3ccZdc82VIn+WMJC/9TzG+Kz4qSMjX207tHlkfXPJlbeB6yUZu
fOP2MW4PSHq7F37+YxzQrMFOKSGa4fr8ysGSabYcEry0UMu9HpVs7jK5/ITNhNpv
ucHedc0TsDJnMcufgMoVgl+A00vXisB06uC3VX0DmbIJs8t2LfeJSy4cnt3GIcFu
dNr/PmRRP5sC/IcnqunxFg7pINPwC3wMKjIQAmbw7zo5huBWQ6XlQzFycnqamHXA
23plPR/HgyU7wFafXN5v+3RoGMwtXPT0t080Q5AKN/Q1p2YxknD9q2pnHyvEhXIq
bC5E+Fx0yUTFgj8j+vrpia8LsFXJTW+FsQ5fT87NzfBU8tdpk96h/rXLWVIJC3hL
59ihxDPL8/pvgwQ0Nm7Mc0J+tZOoMxzQUe4t+CpiQ5EIVGYXoA5m53jIFkvY8K7r
yAT6Z0D7P2lbERZc8OwHbJcZQncy23C5XjGMbeqxMR85Z/A/R9eGKZEniZQkC3H4
vjVO40eLIiNKP7rptsBjePpiBy/X+rxhaXx1QWb7hhJCh8DrGK406KHoGdYit/dV
Px2gH3RAzXs=
=dccY
-----END PGP SIGNATURE-----

--Sig_/eTgI4V3Gn+jx0REs.1A2B9C--
