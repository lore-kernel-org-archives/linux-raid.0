From: NeilBrown <neilb@suse.de>
Subject: Re: One patch just review the code
Date: Thu, 7 Aug 2014 20:26:05 +1000
Message-ID: <20140807202605.4e6a2b1e@notabene.brown>
References: <705044700.17914512.1407222497904.JavaMail.zimbra@redhat.com>
	<1122994629.17915693.1407222727992.JavaMail.zimbra@redhat.com>
	<20140806164420.09e4df13@notabene.brown>
	<835401588.19232017.1407405979159.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/CXf4agHBbSZ1N0dLCzxdDRo"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <835401588.19232017.1407405979159.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, Jes Sorensen <jes.sorensen@redhat.com>
List-Id: linux-raid.ids

--Sig_/CXf4agHBbSZ1N0dLCzxdDRo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 7 Aug 2014 06:06:19 -0400 (EDT) Xiao Ni <xni@redhat.com> wrote:

>=20
>=20
> ----- Original Message -----
> > From: "NeilBrown" <neilb@suse.de>
> > To: "Xiao Ni" <xni@redhat.com>
> > Cc: linux-raid@vger.kernel.org, "Jes Sorensen" <jes.sorensen@redhat.com>
> > Sent: Wednesday, August 6, 2014 2:44:20 PM
> > Subject: Re: One patch just review the code
> >=20
> > On Tue, 5 Aug 2014 03:12:07 -0400 (EDT) Xiao Ni <xni@redhat.com> wrote:
> >=20
> > > Hi all
> > >=20
> > >    I'm reading the code of md. I find there is a problem. I know now =
there
> > >    are arrays mark[SYNC_MARKS] mark_cnt[SYNC_MARKS]
> > > store the information about how many sectors finish recovery and the
> > > moment.
> > >=20
> > >=20
> > > 7825       currspeed =3D ((unsigned
> > > long)(io_sectors-mddev->resync_mark_cnt))/2
> > > 7826          /((jiffies-mddev->resync_mark)/HZ +1) +1;
> > >  =20
> > >    But when calculate the speed of recovery, the sectors used to calc=
ulate
> > >    contains
> > > the sectors which are not finished recovery.
> > >=20
> > >    When assign value to mark_cnt[next], it subtract the sectors which=
 don't
> > >    finish recovery.
> > > So I think when calculate the recovery speed we should subtract the s=
ectors
> > > not finishing
> > > recovery too.
> > >=20
> > > 7638          mark_cnt[next] =3D io_sectors -
> > > atomic_read(&mddev->recovery_active);
> > >=20
> > >    So I try to modify and the patch is:
> > >=20
> > > --- linux-stable/drivers/md/md.c 2014-07-30 14:36:37.327535805 +0800
> > > +++ fix/md.c   2014-07-31 16:40:57.151493177 +0800
> > > @@ -7652,7 +7652,7 @@
> > >        */
> > >       cond_resched();
> > > =20
> > > -     currspeed =3D ((unsigned long)(io_sectors-mddev->resync_mark_cn=
t))/2
> > > +     currspeed =3D ((unsigned
> > > long)(io_sectors-atomic_read(&mddev->recovery_active)-mddev->resync_m=
ark_cnt))/2
> > >          /((jiffies-mddev->resync_mark)/HZ +1) +1;
> > > =20
> > >       if (currspeed > speed_min(mddev)) {
> > >=20
> > >    Am I right?
> >=20
> > Yes, that looks right.
> > If you create a properly formatted patch, and wrap that long line nicel=
y I'll
> > apply it.
> >=20
> > Thanks,
> > NeilBrown
> >=20
>=20
> I definite a new variable, do you allow me to do by this way?

Certainly, nothing wrong with a new variable.

But when you post a patch, please create a new email message with a short
description of the patch as the subject, any extra details or explanation in
the body, then the signed-off-by line and the patch. Then I can just apply
that email without editing it.

Thanks,
NeilBrown

>=20
> Signed-off-by: Xiao Ni <xni@redhat.com>
>=20
> diff -urN linux-stable/drivers/md/md.c fix/md.c
> --- linux-stable/drivers/md/md.c 2014-07-30 14:36:37.327535805 +0800
> +++ fix/md.c   2014-08-07 16:07:12.559503942 +0800
> @@ -7376,7 +7376,7 @@
>    struct mddev *mddev2;
>    unsigned int currspeed =3D 0,
>        window;
> -  sector_t max_sectors,j, io_sectors;
> +  sector_t max_sectors,j, io_sectors, recovery_done;
>    unsigned long mark[SYNC_MARKS];
>    unsigned long update_time;
>    sector_t mark_cnt[SYNC_MARKS];
> @@ -7652,7 +7652,8 @@
>        */ =20
>       cond_resched();
> =20
> -     currspeed =3D ((unsigned long)(io_sectors-mddev->resync_mark_cnt))/2
> +     recovery_done =3D io_sectors - atomic_read(&mddev->recovery_active);
> +     currspeed =3D ((unsigned long)recovery_done - mddev->resync_mark_cn=
t)/2=20
>          /((jiffies-mddev->resync_mark)/HZ +1) +1;=20
> =20
>       if (currspeed > speed_min(mddev)) {


--Sig_/CXf4agHBbSZ1N0dLCzxdDRo
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU+NUPTnsnt1WYoG5AQIFfhAAnYEXjA65iGBrzmNxZU9eM93endbyT0Ks
GD1VdYM2Tyj1BDR5h5isXgJ5VnHHFUeOohpRUjTaD/q+J2q/ofBy5OVpF34l1UrN
zNZYarmtP+oTQJSW0ov8dqXgVNBzuipZC6QJuuxC2Iz5QsxzmvzRkOWcrkZIpFS9
9szeEKG2FMyTKJNGCMCaUq6hgKy26x3ygzfB1xmenkzPkh4WztLWDDiDCLdbNMi9
3TeX8IAgokI83V46rlUSMA51MF6yKrMVVIJsEBxwlbLvEdG5a8xBb6HRtQLWJx25
2q9NBlgak8iX3P05cwVr5xw8ZjDuYTTnQVYf9lUb0mTjKjlVe75Gj+k0/yLY05qs
V9xum/xysHvEc7MhQ8KTAug/r16/LFA+I1i9W4rKGlNVBMuOZb/siQA3XQ76iDRj
Wgijw8Zwk4VZhL2IG5uZA2JbUjCXnFlm2W71Dmkz414MgBC2WQ+UCFN5OsCjghtX
mDoqAaHpYukmiz4Rl+UjwYeohDs4KKj+koXDMQpuAVPHxTs19p/rODzLJ2qtGL/E
SkndY0Hfm+ZI/iAHEFbNPsvAqn5iS7viwQEYIAul/i0PNZRFI5X0StZmjDHm0z6B
pk8p/9uMzCCrXq3dsMlqUEa64XM+CMLpxLjhR1E8DqHyJa7LdtoR8m13DDdiCHp+
VC4hhOiqwEo=
=KET0
-----END PGP SIGNATURE-----

--Sig_/CXf4agHBbSZ1N0dLCzxdDRo--
