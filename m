From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: tests/03r5assemV1 issues
Date: Wed, 11 Jul 2012 10:28:53 +0600
Message-ID: <20120711102853.2a8bbd95@natsu>
References: <wrfjtxxqcn38.fsf@redhat.com>
	<20120703114459.29c21b8f@notabene.brown>
	<wrfjpq8c96c9.fsf@redhat.com>
	<20120704152327.30dcf73e@notabene.brown>
	<wrfjehop1a8e.fsf@redhat.com>
	<20120711142053.36d33f61@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/h.bVdijMYyzuHlAu/ZYzjDU"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120711142053.36d33f61@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/h.bVdijMYyzuHlAu/ZYzjDU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 11 Jul 2012 14:20:53 +1000
NeilBrown <neilb@suse.de> wrote:

> On Fri, 06 Jul 2012 11:59:13 +0200 Jes Sorensen <Jes.Sorensen@redhat.com>
> wrote:
>=20
> > NeilBrown <neilb@suse.de> writes:
> > > On Tue, 03 Jul 2012 18:07:02 +0200 Jes Sorensen <Jes.Sorensen@redhat.=
com>
> > > wrote:
> > >
> > >> NeilBrown <neilb@suse.de> writes:
> > >> > On Mon, 02 Jul 2012 15:24:43 +0200 Jes Sorensen <Jes.Sorensen@redh=
at.com>
> > >> > wrote:
> > >> >
> > >> >> Hi Neil,
> > >> >>=20
> > >> >> I am trying to get the test suite stable on RHEL, but I see a lot=
 of
> > >> >> failures in 03r5assemV1, in particular between these two cases:
> > >> >>=20
> > >> >> mdadm -A $md1 -u $uuid $devlist
> > >> >> check state U_U
> > >> >> eval $tst
> > >> >>=20
> > >> >> mdadm -A $md1 --name=3Done $devlist
> > >> >> check state U_U
> > >> >> check spares 1
> > >> >> eval $tst
> > >> >>=20
> > >> >> I have tested it with the latest upstream kernel as well and see =
the
> > >> >> same problems. I suspect it is simply the box that is too fast, e=
nding
> > >> >> up with the raid check completing inbetween the two test cases?
> > >> >>=20
> > >> >> Are you seeing the same thing there? I tried playing with the max=
 speed
> > >> >> variable but it doesn't really seem to make any difference.
> > >> >>=20
> > >> >> Any ideas for what we can be done to make this case more resilien=
t to
> > >> >> false positives? I guess one option would be to re-create the arr=
ay
> > >> >> inbetween each test?
> > >> >
> > >> > Maybe it really is a bug?
> > >> > The test harness set the resync speed to be very slow.  A fast box=
 will get
> > >> > through the test more quickly and be more likely to see the array =
still
> > >> > syncing.
> > >> >
> > >> > I'll try to make time to look more closely.
> > >> > But I wouldn't discount the possibility that the second "mdadm -A"=
 is
> > >> > short-circuiting the recovery somehow.
> > >>=20
> > >> That could certainly explain what I am seeing. I noticed it doesn't
> > >> happen every single time in the same place (from memory), but it is
> > >> mostly in that spot in my case.
> > >>=20
> > >> Even if I trimmed the max speed down to 50 it still happens.
> > >
> > > I cannot easily reproduce this.
> > > Exactly which kernel and which mdadm do you find it with - just to ma=
ke sure
> > > I'm testing the same thing as you?
> >=20
> > Hi Neil,
> >=20
> > Odd - I see it with
> > mdadm:  721b662b5b33830090c220bbb04bf1904d4b7eed
> > kernel: ca24a145573124732152daff105ba68cc9a2b545
> >=20
> > I've seen this happen for a while fwiw.
> >=20
> > Note the box has a number of external drives with a number of my scratch
> > raid arrays on it. It shouldn't affect this, but just in case.
> >=20
> > The system installed mdadm is a 3.2.3 derivative, but I checked running
> > with PATH=3D. as well.
>=20
> Thanks.
> I think I figured out what is happening.
>=20
> It seems that setting the max_speed down to 1000 is often enough, but not
> always.  So we need to set it lower.
> But setting max_speed lowers is not effective unless you also set min_spe=
ed
> lower.  This is the tricky bit that took me way too long to realised.
>=20
> So with this patch, it is quite reliable.
>=20
> NeilBrown
>=20
> diff --git a/tests/03r5assemV1 b/tests/03r5assemV1
> index 52b1107..bca0c58 100644
> --- a/tests/03r5assemV1
> +++ b/tests/03r5assemV1
> @@ -60,7 +60,8 @@ eval $tst
>  ### Now with a missing device
>  # We don't want the recovery to complete while we are
>  # messing about here.
> -echo 1000 > /proc/sys/dev/raid/speed_limit_max
> +echo 100 > /proc/sys/dev/raid/speed_limit_max
> +echo 100 > /proc/sys/dev/raid/speed_limit_min

Purely from an armchair perspective, don't you need to reduce 'min' first, =
and
only then lower 'max'? As it is currently, depending on the kernel side the
first "echo" has every right to fail with "Invalid argument" (or something
similar), if there'd be a check that max can not be lower than min.

> =20
>  mdadm -AR $md1 $dev0 $dev2 $dev3 $dev4 #
>  check state U_U
> @@ -124,3 +125,4 @@ mdadm -I -c $conf $dev1
>  mdadm -I -c $conf $dev2
>  eval $tst
>  echo 2000 > /proc/sys/dev/raid/speed_limit_max
> +echo 1000 > /proc/sys/dev/raid/speed_limit_min


--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/h.bVdijMYyzuHlAu/ZYzjDU
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEUEARECAAYFAk/9AQUACgkQTLKSvz+PZwgABgCWObZZOXa9wXVm1wSn6wjRYgIa
3gCfSSJTBMY5cswyt+vHz0ForeI9vPY=
=k8R+
-----END PGP SIGNATURE-----

--Sig_/h.bVdijMYyzuHlAu/ZYzjDU--
