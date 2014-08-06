From: NeilBrown <neilb@suse.de>
Subject: Re: One patch just review the code
Date: Wed, 6 Aug 2014 16:44:20 +1000
Message-ID: <20140806164420.09e4df13@notabene.brown>
References: <705044700.17914512.1407222497904.JavaMail.zimbra@redhat.com>
	<1122994629.17915693.1407222727992.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/kXW0LF48JvsWV+bTwCLswRT"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1122994629.17915693.1407222727992.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, Jes Sorensen <jes.sorensen@redhat.com>
List-Id: linux-raid.ids

--Sig_/kXW0LF48JvsWV+bTwCLswRT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 5 Aug 2014 03:12:07 -0400 (EDT) Xiao Ni <xni@redhat.com> wrote:

> Hi all
>=20
>    I'm reading the code of md. I find there is a problem. I know now ther=
e are arrays mark[SYNC_MARKS] mark_cnt[SYNC_MARKS]=20
> store the information about how many sectors finish recovery and the mome=
nt.
>=20
>=20
> 7825       currspeed =3D ((unsigned long)(io_sectors-mddev->resync_mark_c=
nt))/2
> 7826          /((jiffies-mddev->resync_mark)/HZ +1) +1;
>  =20
>    But when calculate the speed of recovery, the sectors used to calculat=
e contains
> the sectors which are not finished recovery.
>=20
>    When assign value to mark_cnt[next], it subtract the sectors which don=
't finish recovery.
> So I think when calculate the recovery speed we should subtract the secto=
rs not finishing
> recovery too.
>=20
> 7638          mark_cnt[next] =3D io_sectors - atomic_read(&mddev->recover=
y_active);
>=20
>    So I try to modify and the patch is:
>=20
> --- linux-stable/drivers/md/md.c 2014-07-30 14:36:37.327535805 +0800
> +++ fix/md.c   2014-07-31 16:40:57.151493177 +0800
> @@ -7652,7 +7652,7 @@
>        */ =20
>       cond_resched();
> =20
> -     currspeed =3D ((unsigned long)(io_sectors-mddev->resync_mark_cnt))/2
> +     currspeed =3D ((unsigned long)(io_sectors-atomic_read(&mddev->recov=
ery_active)-mddev->resync_mark_cnt))/2
>          /((jiffies-mddev->resync_mark)/HZ +1) +1;
> =20
>       if (currspeed > speed_min(mddev)) {
>=20
>    Am I right?

Yes, that looks right.
If you create a properly formatted patch, and wrap that long line nicely I'=
ll
apply it.

Thanks,
NeilBrown

--Sig_/kXW0LF48JvsWV+bTwCLswRT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU+HOxDnsnt1WYoG5AQLhBRAAvQfIPRztV4/XzxkwE8tH3H+SIxPs5mE2
onsBIAlW0biAlOsq05W3kAv4bz8gCtL2KvTZzHH8irsdWgBQlANTUXZV3lsg98eZ
CMhDwsooqfM/hsnGVufDIrrYFc8XT5yKCUvoPM9jBIUVBlsp1fwKQdtrPQtIJZyO
0o/LiLhOO+lfLKm4LKNZc74uFjEoSajubPG9H+//Yfa+B8HPsgPhum5RZ2LxIVEZ
cxI+YCKHS2PhJsqcMREKMoOrxZizvpPaKQtWqU31v/vsqIY4N4QpSXy2/s6G6IuS
8MLtR5AnMqderj5kaSxFxdBQHtqtgw0pA/IvmK/ZGb1VZkr1wOzW3cUWN5FrVFW+
8c7wG42zs3Ga25ZLYHJ3yG/TYp3VzkO2ZDNvsRuxrV91cL9TFYAGfGNBl3ZLGERR
6HOpaSkGbWpCM9k6grI2esp8xtIMjKmp7/4QUuj0YHETMx1EffHXimTBs+ex2XOW
LmKacwIyoviJm00tqpUu4NAkX12AUtfBlP1EEyeoXry2rTt/w7obh4HmVSTsKIde
OZc+9O7PJa50W4dW7wB6e3GFl3K3ucpRzHcaA/vC+pPyYgsFf8sv66QjxX0nxFHo
uBceNbp3hBCPMVXG7zcKGy3zBogfM5pCCOdGVwf0sGHJR7vqEAnyZ05hqrGfL5qy
/9GSJkCqm6A=
=Gsyb
-----END PGP SIGNATURE-----

--Sig_/kXW0LF48JvsWV+bTwCLswRT--
