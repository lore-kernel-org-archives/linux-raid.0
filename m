From: NeilBrown <neilb@suse.de>
Subject: Re: After reshaping raid1 to raid0 with bitmap, then stop md panic
Date: Thu, 7 Aug 2014 20:29:13 +1000
Message-ID: <20140807202913.570be307@notabene.brown>
References: <324320204.17911195.1407221719669.JavaMail.zimbra@redhat.com>
	<11051344.17913061.1407222186494.JavaMail.zimbra@redhat.com>
	<20140806163702.15592dc6@notabene.brown>
	<1783178354.19231525.1407405817606.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/t6kx7n88xdXIOTlhDTF7Byz"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1783178354.19231525.1407405817606.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, Jes Sorensen <jes.sorensen@redhat.com>
List-Id: linux-raid.ids

--Sig_/t6kx7n88xdXIOTlhDTF7Byz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 7 Aug 2014 06:03:37 -0400 (EDT) Xiao Ni <xni@redhat.com> wrote:

>=20
>=20
> ----- Original Message -----
> > From: "NeilBrown" <neilb@suse.de>
> > To: "Xiao Ni" <xni@redhat.com>
> > Cc: linux-raid@vger.kernel.org, "Jes Sorensen" <jes.sorensen@redhat.com>
> > Sent: Wednesday, August 6, 2014 2:37:02 PM
> > Subject: Re: After reshaping raid1 to raid0 with bitmap, then stop md p=
anic
> >=20
> > On Tue, 5 Aug 2014 03:03:06 -0400 (EDT) Xiao Ni <xni@redhat.com> wrote:
> >=20
> > > Dear all
> > >=20
> > >=20
> > >    I faced one problem that the system panic after reshaping raid1 to=
 raid0
> > >    with bitmap.
> > > The dmesg and calltrace information is like this:
> > >=20
> > >    You can easily reproduce this by those steps:
> > >    1. mdadm -CR /dev/md0 -l1 -n2 /dev/loop[0-1] --bitmap=3Dinternal
> > >    2. mdadm --wait /dev/md0
> > >    3. mdadm --grow -l0 /dev/md0
> > >    4. mdadm -S /dev/md0
> > ...
> > >=20
> > > [ 1485.646746] BUG: unable to handle kernel NULL pointer dereference =
at
> > > 0000000000000038
> > > [ 1485.654724] IP: [<ffffffff8148db2e>] bitmap_daemon_work+0x24e/0x450
> >=20
> > Yes, RAID0 doesn't support bitmaps, so this cannot possibly work.
> >=20
> > Following patch should turn the crash into a clean failure.
> >=20
> > Thanks for the report,
> > NeilBrown
> >=20
> >=20
> > From 1bdb20e16166240a4ca3b861c48defefaf218874 Mon Sep 17 00:00:00 2001
> > From: NeilBrown <neilb@suse.de>
> > Date: Wed, 6 Aug 2014 16:34:27 +1000
> > Subject: [PATCH] md: check for bitmap compatability when changing raid
> > levels.
> >=20
> > If an array has a bitmap, then it cannot be converted to
> > a level which does not support bitmaps.
> >=20
> > Reported-by: Xiao Ni <xni@redhat.com>
> > Signed-off-by: NeilBrown <neilb@suse.de>
> >=20
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 1379b1a3b9ff..3bd13b276e45 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -3500,6 +3500,12 @@ level_store(struct mddev *mddev, const char *buf,
> > size_t len)
> >  		       mdname(mddev), clevel);
> >  		return -EINVAL;
> >  	}
> > +	if (mddev->bitmap && !pers->quiesce) {
> > +		module_put(pers->owner);
> > +		printk(KERN_WARNING "md: %s: %s does not support a bitmap\n",
> > +		       mdname(mddev), clevel);
> > +		return -EINVAL;
> > +	}
> > =20
> >  	rdev_for_each(rdev, mddev)
> >  		rdev->new_raid_disk =3D rdev->raid_disk;
> >=20
>=20
> Hi Neil
>=20
>    I have tried the patch, but it can reshape to raid0 still, then stop t=
he raid0, the system
> panics.
>=20
>    What does pers->quiesce mean? I'm not familiar with md code.=20
>=20
> Best Regards
> Xiao


"quiesce" is a function that makes the array "quiescent" - it stops all IO
from happening.
The set_bitmap_file() function has:

	if (mddev->pers) {
		if (!mddev->pers->quiesce)
			return -EBUSY;


So I thought it was safe to assume that if there was a quiesce function then
the personality handled bitmaps.  Obviously not.
I'll have to fix that up...

Thanks,
NeilBrown

--Sig_/t6kx7n88xdXIOTlhDTF7Byz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU+NU+Tnsnt1WYoG5AQJssBAAhQikQx033gPy/OUbWSOs60hOcYuL+No7
4+A6gGvxaDqY86EY4EQjB1gpjZgubhtrEwKrb1FDoLgoAmiHXHeCE6PA/Xm0Mfge
yODLfEkKCStibSBKJMNZ/6LYPWy6wrOpsoOPuNDeNlLV/WKTu/h26D+piBo5Kr52
bU3vm+RV1ARRRydmfKbeQ9IWXvn+lPSQvSX2zspsVf9bRxXlz9DJX/LDnNmbUjRC
lwHxcTbKymmcKYBNRtYudCuTYEr57i/HT149BleZM334MYmH9o6oSCS0V8BAWmCa
JZM56hB7G+RzRV8NsYTeIi43aCmX8n8UABJiKQBf9cgs+gAF6lHexQA+ANoRfKAo
80wAEM/JuSXdS/6B3AT6+cUKQEF+x7DVmID6Cwl16YS0tCxPOEKevOgVF5mBg5wc
FQrU1f1qqZCiOlwA6aZiNVfT3laGgfal6bIVNunvM0wZ851ZVVlvsQA1upds0Fe6
oKOmMqmihrC1uIIajFZb15+Di+aEgwb1/pcbvr5izMH2Bsg7lq2qMZmgtBpqGidt
Lgp09008R7SyxQNacq+RBmi0687hsmqYFUfdYQzi6hYAioOfiYpGmhF5qPuYWvPI
+PySv1HVOlMg5f927rlaQoO26YLrU52ZDNp4uSpVyptyGo+o/cBPx4oeGGJwTunr
5hWlOXOgHIE=
=8xec
-----END PGP SIGNATURE-----

--Sig_/t6kx7n88xdXIOTlhDTF7Byz--
