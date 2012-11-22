From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm: ARRAY <ignore> lines not correctly handled
Date: Thu, 22 Nov 2012 17:05:06 +1100
Message-ID: <20121122170506.1da4303f@notabene.brown>
References: <201211110342.36095.vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ykewigtIeg0zplb17WURkN8"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201211110342.36095.vapier@gentoo.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/ykewigtIeg0zplb17WURkN8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 11 Nov 2012 03:42:35 -0500 Mike Frysinger <vapier@gentoo.org> wrote:

> the mdadm.conf man page states:
> The ARRAY lines identify actual arrays.  The second word on the line may =
be=20
> the name of the device where the array is normally assembled, [...]. =20
> Alternately the word <ignore> (complete with angle brackets) can be given=
 in=20
> which case any array which matches the rest of the line will never be=20
> automatically assembled.
>=20
> so let's say i have a raid that looks like:
> /dev/md0:
>         Version : 1.2
>   Creation Time : Wed Oct 31 16:05:49 2012
>      Raid Level : raid6
>      Array Size : 1953522688 (1863.02 GiB 2000.41 GB)
>   Used Dev Size : 976761344 (931.51 GiB 1000.20 GB)
>    Raid Devices : 4
>   Total Devices : 4
>     Persistence : Superblock is persistent
>=20
>     Update Time : Sun Nov 11 03:35:26 2012
>           State : clean=20
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 0
>=20
>          Layout : left-symmetric
>      Chunk Size : 512K
>=20
>            Name : vapier:0  (local to host vapier)
>            UUID : 51b812dc:094ea54b:f8f7b331:9982b16c
>          Events : 112048
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8       32        0      active sync   /dev/sdc
>        1       8        0        1      active sync   /dev/sda
>        4       8       16        2      active sync   /dev/sdb
>        5       8       64        3      active sync   /dev/sde
>=20
> the man page says i should be able to prevent this from being auto-assemb=
led=20
> via `mdamd -As` by doing something like:
> ARRAY <ignore> uuid=3D51b812dc:094ea54b:f8f7b331:9982b16c
>=20
> or perhaps:
> DEVICE /dev/sd[abce]
> ARRAY <ignore> devices=3D/dev/sda,/dev/sdb,/dev/sde,/dev/sdc
>=20
> unfortunately, this turns out to not be the case.  mdadm goes ahead and a=
uto-
> assembles things anyways.  looking at the code, it seems that it's due to=
 the=20
> code falling back if nothing was detected:
> mdadm.c
> ...
>     do {
>         failures =3D 0;
>         successes =3D 0;
>         rv =3D 0;
>         for (a =3D array_list; a ; a =3D a->next) {
>             int r;
>             if (a->assembled)
>                 continue;
>             if (a->devname &&  =20
>                 strcasecmp(a->devname, "<ignore>") =3D=3D 0)
>                 continue;
>=20
>             r =3D Assemble(ss, a->devname,
>                      a, NULL, c);
>             if (r =3D=3D 0) {
>                 a->assembled =3D 1;
>                 successes++;
>             } else
>                 failures++;
>             rv |=3D r;
>             cnt++;
>         }
>     } while (failures && successes);
>     if (c->homehost && cnt =3D=3D 0) {
>         /* Maybe we can auto-assemble something.
>          * Repeatedly call Assemble in auto-assemble mode
>          * until it fails
>          */
>         int rv2;
>         int acnt;
>         ident->autof =3D c->autof;
>         do {
>             struct mddev_dev *devlist =3D conf_get_devs();
>             acnt =3D 0;
>             do {
>                 rv2 =3D Assemble(ss, NULL,
>                            ident,
>                            devlist, c);
> ...
>=20
> the idea is to be able to have a system with multiple raids (some of whic=
h are=20
> dormant/backups), blacklist the ones that you want to keep idle, and brin=
g=20
> online all the rest.
> -mike

Thanks for the report.
Fixed by the following patch.

Thanks,
NeilBrown

=46rom 66eb2c93a619eb1d79dc653fd91add159aa3d1ff Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Thu, 22 Nov 2012 17:04:20 +1100
Subject: [PATCH] Assemble: ensure that <ignore>d arrays are not
 auto-assembled.

It isn't enough to simply not assemble arrays found to be called
<ignore>, as the final stage of auto-assemble doesn't check for names
in mdadm.conf.

So add a check to Assemble, similar to the check in Incremental()

Reported-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/Assemble.c b/Assemble.c
index c2fa096..9ef1bf0 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -362,6 +362,8 @@ static int select_devices(struct mddev_dev *devlist,
 			tmpdev =3D NULL;
 			goto loop;
 		} else {
+			int rv =3D 0;
+			struct mddev_ident *match;
=20
 			content =3D *contentp;
 			tst->ss->getinfo_super(tst, content, NULL);
@@ -370,7 +372,20 @@ static int select_devices(struct mddev_dev *devlist,
 					   c->homehost, c->update,
 					   report_missmatch ? devname : NULL))
 				goto loop;
-			=09
+
+			match =3D conf_match(tst, content, devname,
+					   report_missmatch ? c->verbose : -1,
+					   &rv);
+			if (!match && rv =3D=3D 2)
+				goto loop;
+			if (match && match->devname &&
+			    strcasecmp(match->devname, "<ignore>") =3D=3D 0) {
+				if (report_missmatch)
+					pr_err("%s is a member of an explicitly ignored array\n",
+					       devname);
+				goto loop;
+			}
+
 			/* should be safe to try an exclusive open now, we
 			 * have rejected anything that some other mdadm might
 			 * be looking at

--Sig_/ykewigtIeg0zplb17WURkN8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUK3Akjnsnt1WYoG5AQJ8QRAAxBnVvwfyKXvqFWcwjn89DrzIZHP1XsXk
vuJsHh4OczgmturpwR2BH6aA//k4/2RVul/BvdXIVWVj6RXwDrBiE4Zudb7RxVI2
08VVxx4yFJAb14nVIExdBxM/5cg/R5O8BjU8CQFoAJOAIWWTzmAkKMhVHi6oKn8j
vNczS7mjcNlZfyt72s5SUs3XpmZbcTXoFIeHjW65u0bX4hyki+ZNthUUUHS8Abgz
ry/rX531Okv+5AfxVIpB2ArSAnO3icVfqH4zDfkhXeyNU2MFExFIFTEp1VU43QRE
yVgMkkA3x74PlER0IMJuvuUoioA63gcWf887q3n9020GqtZ1N+eKgQfKN3vERtfs
GL3zkEYNB27fzwhP7+yTVJhI721+thWtEqPyq8LJ0ZMu6XRjRa6RtwQy6jtEHC6c
BvcHw49OT8GFlfz21pIT1RnKPEraimz4Tro2tyntLiBnF47XqHQyyQU3ZjJEw8WU
/yMroHjEkSYinPMHfyL9ht1C8A+9iopb4gOPzCUmsWJXVFcsn0sxHW1jqdfa7aCn
9L9D8PhkaupvKjjCEyeNnbzcPmMQLBMQdOivnmh1zNAK+IOT/A8lQOwxJzV0cVjC
di7gEJSB8OZoUvBbLJDH8NVLEtjSRJVSwitM5QAbih3VQoc1elaklHUAm/gDnqV5
c4m8cL322QY=
=bb5B
-----END PGP SIGNATURE-----

--Sig_/ykewigtIeg0zplb17WURkN8--
