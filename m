From: NeilBrown <neilb@suse.de>
Subject: Re: MD Raid10 recovery results in "attempt to access beyond end of
 device"
Date: Mon, 25 Jun 2012 14:07:54 +1000
Message-ID: <20120625140754.44536553@notabene.brown>
References: <20120622160632.7dfbbb9d@batzmaru.gol.ad.jp>
	<20120622180748.5f78339c@notabene.brown>
	<20120622174257.03a17e81@batzmaru.gol.ad.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/WgCh8pU5+=28VKuNsEzoHiA"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120622174257.03a17e81@batzmaru.gol.ad.jp>
Sender: linux-raid-owner@vger.kernel.org
To: Christian Balzer <chibi@gol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/WgCh8pU5+=28VKuNsEzoHiA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 22 Jun 2012 17:42:57 +0900 Christian Balzer <chibi@gol.com> wrote:

>=20
> Hello,
>=20
> On Fri, 22 Jun 2012 18:07:48 +1000 NeilBrown wrote:
>=20
> > On Fri, 22 Jun 2012 16:06:32 +0900 Christian Balzer <chibi@gol.com>
> > wrote:
> >=20
> > >=20
> > > Hello,
> > >=20
> > > the basics first:
> > > Debian Squeeze, custom 3.2.18 kernel.
> > >=20
> > > The Raid(s) in question are:
> > > ---
> > > Personalities : [raid1] [raid10]=20
> > > md4 : active raid10 sdd1[0] sdb4[5](S) sdl1[4] sdk1[3] sdj1[2] sdi1[1]
> > >       3662836224 blocks super 1.2 512K chunks 2 near-copies [5/5]
> > > [UUUUU]
> >=20
> > I'm stumped by this.  It shouldn't be possible.
> >=20
> > The size of the array is impossible.
> >=20
> > If there are N chunks per device, then there are 5*N chunks on the whole
> > array, and there are are two copies of each data chunk, so
> > 5*N/2 distinct data chunks, so that should be the size of the array.
> >=20
> > So if we take the size of the array, divide by chunk size, multiply by =
2,
> > divide by 5, we get N =3D the number of chunks per device.
> > i.e.
> >   N =3D (array_size / chunk_size)*2 / 5
> >=20
> > If we plug in 3662836224 for the array size and 512 for the chunk size,
> > we get 2861590.8, which is not an integer.
> > i.e. impossible.
> >=20
> Quite right, though I never bothered to check that number of course,
> pretty much assuming after using Linux MD since the last millennium that
> it would get things right. ^o^
>=20
> > What does "mdadm --examine" of the various devices show?
> >=20
> They looks all identical and sane to me:
> ---
> /dev/sdc1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 2b46b20b:80c18c76:bcd534b5:4d1372e4
>            Name : borg03b:3  (local to host borg03b)
>   Creation Time : Sat May 19 01:07:34 2012
>      Raid Level : raid10
>    Raid Devices : 5
>=20
>  Avail Dev Size : 2930269954 (1397.26 GiB 1500.30 GB)
>      Array Size : 5860538368 (2794.52 GiB 3000.60 GB)
>   Used Dev Size : 2930269184 (1397.26 GiB 1500.30 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : fe922c1c:35319892:cc1e32e9:948d932c
>=20
>     Update Time : Fri Jun 22 17:12:05 2012
>        Checksum : 27a61d9a - correct
>          Events : 90893
>=20
>          Layout : near=3D2
>      Chunk Size : 512K
>=20
>    Device Role : Active device 0
>    Array State : AAAAA ('A' =3D=3D active, '.' =3D=3D missing)

Thanks.
With this extra info - and the clearer perspective that morning provides - I
see what is happening.

The following kernel patch should make it work for you.  It was made and
tested against 3.4. but should apply to your 3.2 kernel.

The problem only occurs when recovering the last device in certain RAID10
arrays.  If you had > 2 copies (e.g. --layout=3Dn3) it could be more than j=
ust
the last device.

RAID10 with an odd number of devices (5 in this case) lays out chunks like
this:

 A A B B C
 C D D E E
 F F G G H
 H I I J J

If you have an even number of stripes, everything is happy.
If you have an odd number of stripes - as is the case with your problem arr=
ay
- then the last stripe might look like:

 F F G G H

The 'H' chunk only exists once.  There is no mirror for it.
md does not store any data in this chunk - the size of the array is calcula=
ted
to finish after 'G'.
However the recovery code isn't quite so careful.  It tries to recover this
chunk and loads it from beyond the end of the first device - which is where
it would be if the devices were all a bit bigger.

So there is no risk of data corruption here - just that md tries to recover=
 a
block that isn't in the array, fails, and aborts the recovery.

This patch gets it to complete the recovery earlier so that it doesn't try
(and fail) to do the impossible.

If you could test and confirm, I'd appreciate it.

Thanks,
NeilBrown

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 99ae606..bcf6ea8 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2890,6 +2890,12 @@ static sector_t sync_request(struct mddev *mddev, se=
ctor_t sector_nr,
 			/* want to reconstruct this device */
 			rb2 =3D r10_bio;
 			sect =3D raid10_find_virt(conf, sector_nr, i);
+			if (sect >=3D mddev->resync_max_sectors) {
+				/* last stripe is not complete - don't
+				 * try to recover this sector.
+				 */
+				continue;
+			}
 			/* Unless we are doing a full sync, or a replacement
 			 * we only need to recover the block if it is set in
 			 * the bitmap

--Sig_/WgCh8pU5+=28VKuNsEzoHiA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT+fkGjnsnt1WYoG5AQKngxAAt3RqsLbHs7wN6P1H5kLyM1NRocFY24aK
Yye7jaENn959TQ1HRMQw+87AGyCI2HnyjqBPFRrUI//FmUfTzXDlim9pmwAlCQxN
cVEQnTVE4zNtst/I9NQZ85HIrnUFeo6Jrqi1WAiuCqXghiFOJMX9/dVHyNjVQdo2
loGFuep3ydDdcY/jfoZXpsywDIn0xq5n2VrnAIRJP+vTB7hl9w751Hpv4pZokt92
XsIR6etMnd1poRX5y0UVSGrlPKF5aX2FnoK+B5YFTJAlyPLtU4JlqAT3LXJYonKp
3jQ6arB+rCMJLif2pNv7/ny9mI/SLBoFuo2LuUW64EcwxpaquEfsMITHdnZUG2cQ
722IXkseR0zXpDPa6h6zAMw4ckFuhgtXtBKg/aoTpbF/pOKMzXIjAM2EyLLS6I76
nBwVUnm6u7iNZEHtby/8PPPk0XrnbjPBvXWqKlrmPWzimMRguS6SFeHw5WsaSKyM
+1Q9Oi0shj9IF7yJyfC/OSX/zTh8lwIzu9+kmlKK7usOQHG5VGUCo7Xw2XtEHb6T
M1okKqJa5PfKzVTA7HKkJvShRzaVVFKCrtDEF/mvituCxpGeMI0xD8n6VfDUHGkN
6cxqTzy/mcUGuQTfCQHQiyZiecz6LDC5wKZAca2QbhnfhKMYtQFr/B+g59zcC/4j
fcwRKSwlmL0=
=1Ddg
-----END PGP SIGNATURE-----

--Sig_/WgCh8pU5+=28VKuNsEzoHiA--
