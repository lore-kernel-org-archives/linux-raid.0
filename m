From: NeilBrown <neilb@suse.de>
Subject: Re: tests/03r5assemV1 issues
Date: Wed, 11 Jul 2012 14:20:53 +1000
Message-ID: <20120711142053.36d33f61@notabene.brown>
References: <wrfjtxxqcn38.fsf@redhat.com>
	<20120703114459.29c21b8f@notabene.brown>
	<wrfjpq8c96c9.fsf@redhat.com>
	<20120704152327.30dcf73e@notabene.brown>
	<wrfjehop1a8e.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/TGxYAALA0n5KdLePQSc+Pxq"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjehop1a8e.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/TGxYAALA0n5KdLePQSc+Pxq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 06 Jul 2012 11:59:13 +0200 Jes Sorensen <Jes.Sorensen@redhat.com>
wrote:

> NeilBrown <neilb@suse.de> writes:
> > On Tue, 03 Jul 2012 18:07:02 +0200 Jes Sorensen <Jes.Sorensen@redhat.co=
m>
> > wrote:
> >
> >> NeilBrown <neilb@suse.de> writes:
> >> > On Mon, 02 Jul 2012 15:24:43 +0200 Jes Sorensen <Jes.Sorensen@redhat=
.com>
> >> > wrote:
> >> >
> >> >> Hi Neil,
> >> >>=20
> >> >> I am trying to get the test suite stable on RHEL, but I see a lot of
> >> >> failures in 03r5assemV1, in particular between these two cases:
> >> >>=20
> >> >> mdadm -A $md1 -u $uuid $devlist
> >> >> check state U_U
> >> >> eval $tst
> >> >>=20
> >> >> mdadm -A $md1 --name=3Done $devlist
> >> >> check state U_U
> >> >> check spares 1
> >> >> eval $tst
> >> >>=20
> >> >> I have tested it with the latest upstream kernel as well and see the
> >> >> same problems. I suspect it is simply the box that is too fast, end=
ing
> >> >> up with the raid check completing inbetween the two test cases?
> >> >>=20
> >> >> Are you seeing the same thing there? I tried playing with the max s=
peed
> >> >> variable but it doesn't really seem to make any difference.
> >> >>=20
> >> >> Any ideas for what we can be done to make this case more resilient =
to
> >> >> false positives? I guess one option would be to re-create the array
> >> >> inbetween each test?
> >> >
> >> > Maybe it really is a bug?
> >> > The test harness set the resync speed to be very slow.  A fast box w=
ill get
> >> > through the test more quickly and be more likely to see the array st=
ill
> >> > syncing.
> >> >
> >> > I'll try to make time to look more closely.
> >> > But I wouldn't discount the possibility that the second "mdadm -A" is
> >> > short-circuiting the recovery somehow.
> >>=20
> >> That could certainly explain what I am seeing. I noticed it doesn't
> >> happen every single time in the same place (from memory), but it is
> >> mostly in that spot in my case.
> >>=20
> >> Even if I trimmed the max speed down to 50 it still happens.
> >
> > I cannot easily reproduce this.
> > Exactly which kernel and which mdadm do you find it with - just to make=
 sure
> > I'm testing the same thing as you?
>=20
> Hi Neil,
>=20
> Odd - I see it with
> mdadm:  721b662b5b33830090c220bbb04bf1904d4b7eed
> kernel: ca24a145573124732152daff105ba68cc9a2b545
>=20
> I've seen this happen for a while fwiw.
>=20
> Note the box has a number of external drives with a number of my scratch
> raid arrays on it. It shouldn't affect this, but just in case.
>=20
> The system installed mdadm is a 3.2.3 derivative, but I checked running
> with PATH=3D. as well.

Thanks.
I think I figured out what is happening.

It seems that setting the max_speed down to 1000 is often enough, but not
always.  So we need to set it lower.
But setting max_speed lowers is not effective unless you also set min_speed
lower.  This is the tricky bit that took me way too long to realised.

So with this patch, it is quite reliable.

NeilBrown

diff --git a/tests/03r5assemV1 b/tests/03r5assemV1
index 52b1107..bca0c58 100644
--- a/tests/03r5assemV1
+++ b/tests/03r5assemV1
@@ -60,7 +60,8 @@ eval $tst
 ### Now with a missing device
 # We don't want the recovery to complete while we are
 # messing about here.
-echo 1000 > /proc/sys/dev/raid/speed_limit_max
+echo 100 > /proc/sys/dev/raid/speed_limit_max
+echo 100 > /proc/sys/dev/raid/speed_limit_min
=20
 mdadm -AR $md1 $dev0 $dev2 $dev3 $dev4 #
 check state U_U
@@ -124,3 +125,4 @@ mdadm -I -c $conf $dev1
 mdadm -I -c $conf $dev2
 eval $tst
 echo 2000 > /proc/sys/dev/raid/speed_limit_max
+echo 1000 > /proc/sys/dev/raid/speed_limit_min

--Sig_/TGxYAALA0n5KdLePQSc+Pxq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/z/Jjnsnt1WYoG5AQLn8Q//e5JoNvGAw1WaEhA6lAdrrIj7eAGJ7RnM
KCsdAD5skDW2eCYKWIj/YAjPvjzKSSKZklN+PUpplxFKrO/YNoPIThstdklkIMPv
mtTZr13Q2wAalMZd6L4zObfxeLwAppwCfS0u3qh4eFskbae31lvAarRwC42M3psU
eaXrygkpdk3atMYoy1UXaqU5GheEWETT9BRdthxxXKBl/W29h85ACMS+vXYwDqX2
9Bjb+yD+f7jw4UmxY/hbppjwQTMI5UxvPFDrk+cFOa92ivT6hc6Ih6xHvD+sPRqz
5ybObBoiz3GyNg6pGE8r50av8aPyFU59liQ3Fu3vGNLbH4GJHQXsPr4+F19Fwmbc
hYh8iMn6PQ31p9FdV0fpbqCaJfcDQtNRa73IkczR8O1tmvu7KwQb/dnSFIb2Kx6C
a+iN0XmvHqHQu7tdHjSScRRkMmO+jEFsklWMtaSJ87Lfe1CA1TJOuPvP7ZO3QeR5
uUa1z4iuATjsJ4oG9Vx8EKokSAzKyy2/Pblv9M1alImLB3SNBA8qPR6O4preqNqc
z93KIQ3PROmL65gbC+7tsz4Tx8y2JPFuuClyrcdC+mfl1uHQsChmlzZzNeeh9Tbd
Uk6m2RrUBHwhCn3h6jVEEisjItwa2fdlx2iqDrRYxVsJ8JsQD21L2kCvSdUZZsy3
9IM3eEOtHpE=
=dwl5
-----END PGP SIGNATURE-----

--Sig_/TGxYAALA0n5KdLePQSc+Pxq--
