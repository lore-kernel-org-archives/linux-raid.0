From: g.esp@free.fr
Subject: Re: [PATCH 1/3] Align FAILED to test name to be parsable
Date: Mon, 22 Oct 2012 10:31:23 +0200 (CEST)
Message-ID: <364625821.319540709.1350894683732.JavaMail.root@zimbra33-e6.priv.proxad.net>
References: <20121022090855.1bb52c91@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121022090855.1bb52c91@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



----- Mail original -----
> De: "NeilBrown" <neilb@suse.de>
> =C3=80: "Gilles Espinasse" <g.esp@free.fr>
> Cc: linux-raid@vger.kernel.org
> Envoy=C3=A9: Lundi 22 Octobre 2012 00:08:55
> Objet: Re: [PATCH 1/3] Align FAILED to test name to be parsable
>=20
> On Sat, 20 Oct 2012 18:03:22 +0200 Gilles Espinasse <g.esp@free.fr>
> wrote:
>=20
> > Signed-off-by: Gilles Espinasse <g.esp@free.fr>
> >=20
> > So 'grep FAILED log' is now meaningfull.
> > Let both stdout and sderr be displayed after a failed test
> > ---
> >  test |    5 +++--
> >  1 files changed, 3 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/test b/test
> > index 9340afe..2bb482c 100755
> > --- a/test
> > +++ b/test
> > @@ -222,12 +222,13 @@ do_test() {
> >      # source script in a subshell, so it has access to our
> >      # namespace, but cannot change it.
> >      echo -ne "$_script... "
> > -    if ( set -ex ; . $_script )  2> $targetdir/log
> > +    if ( set -ex ; . $_script ) &> $targetdir/log
> >      then
> >        echo "succeeded"
> >        _fail=3D0
> >      else
> > -      echo "FAILED - see $targetdir/log for details"
> > +      echo "FAILED"
> > +      cat $targetdir/log
> >        _fail=3D1
> >      fi
> >      if [ "$savelogs" =3D=3D "1" ]; then
>=20
> Hi,
>  the patch makes some sense, but it doesn't seem to match the
>  description,
>  though maybe I'm just being dense.
>=20
>  How does the patch "Align FAILED to test name" ?
>=20
> Thanks,
> NeilBrown
>=20
I have a test that failed with
tests/06r5swap... --- /var/tmp/d1	2012-10-20 08:36:12.000000000 +0200
+++ /var/tmp/d1s	2012-10-20 08:36:12.000000000 +0200
@@ -1,32 +0,0 @@
-/dev/loop1:
-          Magic : a92b4efc
-        Version : 0.90.00
-           UUID : 3a6a4fbd:b6c09cce:37479202:ddc39261 (local to host a=
7n8x-e)
-  Creation Time : Sat Oct 20 08:36:07 2012
-     Raid Level : raid5
-  Used Dev Size : 19456 (19.00 MiB 19.92 MB)
-     Array Size : 58368 (57.01 MiB 59.77 MB)
-   Raid Devices : 4
-  Total Devices : 4
-Preferred Minor : 0
-
-    Update Time : Sat Oct 20 08:36:11 2012
-          State : clean
- Active Devices : 3
-Working Devices : 4
- Failed Devices : 1
-  Spare Devices : 1
-       Checksum : 506e39b6 - correct
-         Events : 9
-
-         Layout : left-symmetric
-     Chunk Size : 512K
-
-      Number   Major   Minor   RaidDevice State
-this     1       7        8        1      active sync   /dev/loop1
-
-   0     0       7        0        0      active sync   /dev/loop0
-   1     1       7        8        1      active sync   /dev/loop1
-   2     2       7       16        2      active sync   /dev/loop2
-   3     3       0        0        3      faulty removed
-   4     4       7       24        4      spare   /dev/loop3
Personalities : [linear] [multipath] [raid0] [raid1] [raid10] [raid6] [=
raid5] [raid4]=20
unused devices: <none>
=46AILED - see /var/tmp/log for details

When standard output is redirected like in the patch, diff output goes =
to $targetdir/log and FAILED would be printed one the same line as the =
test name.

I hadn't yet reported that failure as I am only recently trying to run =
mdadm test suite and I had some issues to solve before on my build chro=
ot scripts. I suppose there is less value to run that test suite if the=
 running kernel is not from the same version as the=20
Once using the same kernel (3.4.14), first failure is the one above.

Gilles
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
