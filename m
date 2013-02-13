From: NeilBrown <neilb@suse.de>
Subject: Re: Set disk faulty / hot disk remove ioctl bug for read-only MD?
Date: Thu, 14 Feb 2013 09:01:13 +1100
Message-ID: <20130214090113.01bc6788@notabene.brown>
References: <alpine.DEB.2.02.1302121559540.11804@jlaw-desktop.mno.stratus.com>
	<20130213133820.6496b074@notabene.brown>
	<511B7CE6.5060806@profitbricks.com>
	<alpine.DEB.2.02.1302131255510.11804@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/gfe0BEoX720bOGr=Ntw8yB5"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1302131255510.11804@jlaw-desktop.mno.stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Lawrence <Joe.Lawrence@stratus.com>
Cc: Sebastian Riemer <sebastian.riemer@profitbricks.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/gfe0BEoX720bOGr=Ntw8yB5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 13 Feb 2013 13:56:45 -0500 (EST) Joe Lawrence
<Joe.Lawrence@stratus.com> wrote:

> On Wed, 13 Feb 2013, Sebastian Riemer wrote:
>=20
> > On 13.02.2013 03:38, NeilBrown wrote:
> > > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > > index 8b557d2..292cc2f 100644
> > > --- a/drivers/md/md.c
> > > +++ b/drivers/md/md.c
> > > @@ -6529,7 +6529,17 @@ static int md_ioctl(struct block_device *bdev,=
 fmode_t mode,
> > >  			mddev->ro =3D 0;
> > >  			sysfs_notify_dirent_safe(mddev->sysfs_state);
> > >  			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> > > -			md_wakeup_thread(mddev->thread);
> > > +			/* mddev_unlock will wake thread */
> > > +			/* If a device failed while we were read-only, we
> > > +			 * need to make sure the metadata is updated now.
> > > +			 */
> > > +			if (test_bit(MD_CHANGE_DEVS, &mddev->flags)) {
> > > +				mddev_unlock(mddev);
> > > +				wait_event(mddev->sb_wait,
> > > +					   !test_bit(MD_CHANGE_DEVS, &mddev->flags) &&
> > > +					   !test_bit(MD_CHANGE_PENDING, &mddev->flags));
> > > +				mddev_lock(mddev);
> > > +			}
> > >  		} else {
> > >  			err =3D -EROFS;
> > >  			goto abort_unlock;
> > >=20
> >=20
> > Thanks, Neil!
> >=20
> > I can confirm the issue on 3.4.y and that your patch fixes it reliably.
> >=20
> > Acked-by: Sebastian Riemer <sebastian.riemer@profitbricks.com>
>=20
> Running with this patch against 3.8.0rc7 with the following results:
>=20
>   auto-read-only
>   * mdadm --fail   - success
>   * mdadm --remove - success
>=20
>   read-only
>   * mdadm --fail   - success
>   * mdadm --remove - EROFS

That all looks good.  I could probably argue that removing a device from a
read-only array should be permitted but I don't know that it is really
important.


>=20
> Quick question for Neil -- should the sysfs MD component device state=20
> file interface perform the same transition from auto-read-only to=20
> read-write, or is that route intended for more granular changes?
>=20

Good question.
I think they should definitely transition from auto-read-only to read-write.
Whether they should be denied  for read-only devices I'm less certain of.
I'll look into that.

Thanks,
NeilBrown


--Sig_/gfe0BEoX720bOGr=Ntw8yB5
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBURwNKTnsnt1WYoG5AQLLKQ//Ziwi1vgPVnOBGlDdL6xUBheI7xsniLzk
XrQNoFAVCY1imdhAXwRN2NKeojaqMjaUZJE2Rek06hnBhnUFjn2v1l7Ka8u7JwhP
Dc737AKkQOqk+gVOXmKNaGYqnQnQPvRa+bCaLasPMTxuXXXYIIEfMKGI0SPZdUWP
QOJDzZCyt4u09Tm0Zo4bmSRUCBU3Un7CI+9V+GYeizRhOaQ4q2VF7moCoMDL5H6S
o/hlQQNMMVh1u2+YDscV0e4eRkDA6vO/HhC2xG+PI0Y6EIH2wW4bftxOh9Oohvzd
+DfpA+UIkVWKnDwjKOTbcBS1KeEJ1Ky+/1duSkJfLeCLonEMLbDIfJORi0uVg5jl
NXFjUmYR5Gk/k+qb+gcwLKL0LFlaCqaDIxHuIwlrhIf/7wuuOL/qlHHPBK1+L4Ib
vidGG4NDP+QZBWVESNVmUigx8Fqbf+jPuO4sRNQ8IwjnAUuaC/AtXXtgBVTzdcEW
ncL7DCQUoc2bWjN9sH6yF2Ss1hl0ehtTmLrqGhoGLbfgigZwHJcL2MBdEp6OHhPK
XFJWNwV5yzCCD9u85cAxG1k6AXj4KQrtDzqUN5kUVjqLEg6g/lHfC1xnE+Fx0ZwP
EAUyIKgFvn6f1bVupkfIvaFBt3cY6hqFTKY+ekUV/dtGB+rBFgBeMqcK/w1fxXA8
X6uQoEMSByg=
=fLQL
-----END PGP SIGNATURE-----

--Sig_/gfe0BEoX720bOGr=Ntw8yB5--
