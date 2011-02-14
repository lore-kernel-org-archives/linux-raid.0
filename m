From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm: can't removed failed/detached drives when using metadata
 1.x
Date: Mon, 14 Feb 2011 14:27:01 +1100
Message-ID: <20110214142701.28950b00@notabene.brown>
References: <4D54040C.4040201@lacie.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D54040C.4040201@lacie.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?B?UultaSBS6XJvbGxl?= <rrerolle@lacie.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 10 Feb 2011 16:28:12 +0100 R=E9mi R=E9rolle <rrerolle@lacie.com=
> wrote:

> Hi Neil,
>=20
> I recently came across what I believe is a regression in mdadm, which
> has been introduced in version 3.1.3.
>=20
> It seems that, when using metadata 1.x, the handling of failed/detach=
ed
> drives isn't effective anymore.
>=20
> Here's a quick example:
>=20
> [root@GrosCinq ~]# mdadm -C /dev/md4 -l1 -n2 --metadata=3D1.0 /dev/sd=
c1=20
> /dev/sdd1
> mdadm: array /dev/md4 started.
> [root@GrosCinq ~]#
> [root@GrosCinq ~]# mdadm --wait /dev/md4
> [root@GrosCinq ~]#
> [root@GrosCinq ~]# mdadm -D /dev/md4
> /dev/md4:
>          Version : 1.0
>    Creation Time : Thu Feb 10 13:56:31 2011
>       Raid Level : raid1
>       Array Size : 1953096 (1907.64 MiB 1999.97 MB)
>    Used Dev Size : 1953096 (1907.64 MiB 1999.97 MB)
>     Raid Devices : 2
>    Total Devices : 2
>      Persistence : Superblock is persistent
>=20
>      Update Time : Thu Feb 10 13:56:46 2011
>            State : clean
>   Active Devices : 2
> Working Devices : 2
>   Failed Devices : 0
>    Spare Devices : 0
>=20
>             Name : GrosCinq:4  (local to host GrosCinq)
>             UUID : bbfef508:252e7ce1:c95d4a03:8beb3cbd
>           Events : 17
>=20
>      Number   Major   Minor   RaidDevice State
>         0       8        1        0      active sync   /dev/sdc1
>         1       8       49        1      active sync   /dev/sdd1
>=20
> [root@GrosCinq ~]# mdadm --fail /dev/md4 /dev/sdc1
> mdadm: set /dev/sdc1 faulty in /dev/md4
> [root@GrosCinq ~]#
> [root@GrosCinq ~]# mdadm -D /dev/md4 | tail -n 6
>=20
>      Number   Major   Minor   RaidDevice State
>         0       0        0        0      removed
>         1       8       49        1      active sync   /dev/sdd1
>=20
>         0       8        1        -      faulty spare   /dev/sdc1
> [root@GrosCinq ~]#
> [root@GrosCinq ~]# mdadm --remove /dev/md4 failed
> [root@GrosCinq ~]#
> [root@GrosCinq ~]# mdadm -D /dev/md4 | tail -n 6
>=20
>      Number   Major   Minor   RaidDevice State
>         0       0        0        0      removed
>         1       8       49        1      active sync   /dev/sdd1
>=20
>         0       8        1        -      faulty spare   /dev/sdc1
> [root@GrosCinq ~]#
>=20
> This is with mdadm 3.1.4, 3.1.3 or even 3.2, but not 3.1.2. I did a g=
it=20
> bisect to try and isolate the regression and it appears the guilty=20
> commit is :
>=20
> b3b4e8a : "Avoid skipping devices where removing all faulty/detached
>             devices."
>=20
> As stated in the commit, this is only true with metadata 1.x. With 0.=
9,=20
> there is no problem. I also tested with detached drives as well as=20
> raid5/6 and encountered the same issue. Actually, with detached drive=
s,=20
> it's even more annoying, since using --remove detached is the only wa=
y=20
> to remove the device without restarting the array. For a failed drive=
,=20
> there is still the possibility to use the device name.
>=20
> Do you have any idea of the reason behind that regression ? Shall thi=
s=20
> patch only apply in the case of 0.9 metadata ?
>=20
> Regards,
>=20


Thanks for the report - especially for bitsecting it down to the errone=
ous
commit!

This patch should fix the regression.  I'll ensure it is in all future
releases.

Thanks,
NeilBrown


diff --git a/Manage.c b/Manage.c
index 481c165..8c86a53 100644
--- a/Manage.c
+++ b/Manage.c
@@ -421,7 +421,7 @@ int Manage_subdevs(char *devname, int fd,
 				dnprintable =3D dvname;
 				break;
 			}
-			if (jnext =3D=3D 0)
+			if (next !=3D dv)
 				continue;
 		} else if (strcmp(dv->devname, "detached") =3D=3D 0) {
 			if (dv->disposition !=3D 'r' && dv->disposition !=3D 'f') {
@@ -461,7 +461,7 @@ int Manage_subdevs(char *devname, int fd,
 				dnprintable =3D dvname;
 				break;
 			}
-			if (jnext =3D=3D 0)
+			if (next !=3D dv)
 				continue;
 		} else if (strcmp(dv->devname, "missing") =3D=3D 0) {
 			if (dv->disposition !=3D 'a' || dv->re_add =3D=3D 0) {
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
