From: NeilBrown <neilb@suse.de>
Subject: Re: Some md/mdadm bugs
Date: Tue, 7 Feb 2012 09:20:05 +1100
Message-ID: <20120207092005.7c11171a@notabene.brown>
References: <4F2ADF45.4040103@shiftmail.org>
	<20120203081717.195bfec8@notabene.brown>
	<4F2B1519.5010500@shiftmail.org>
	<4F3008DA.8060402@shiftmail.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.stEbyvfr_uh_.LucY6NFEp"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F3008DA.8060402@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/.stEbyvfr_uh_.LucY6NFEp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 06 Feb 2012 18:07:38 +0100 Asdo <asdo@shiftmail.org> wrote:

> On 02/02/12 23:58, Asdo wrote:
> >
> >>> Now it doesn't happen:
> >>> When I reinserted the disk, udev triggered the --incremental, to
> >>> reinsert the device, but mdadm refused to do anything because the old
> >>> slot was still occupied with a failed+detached device. I manually
> >>> removed the device from the raid then I ran --incremental, but mdadm
> >>> still refused to re-add the device to the RAID because the array was
> >>> running. I think that if it is a re-add, and especially if the=20
> >>> bitmap is
> >>> active, I can't think of a situation in which the user would *not* wa=
nt
> >>> to do an incremental re-add even if the array is running.
> >> Hmmm.. that doesn't seem right.  What version of mdadm are you running?
> >
> > 3.1.4
> >
> >> Maybe a newer one would get this right.
> > I need to try...
> > I think I need that.
>=20
> Hi Neil,
>=20
> Still some problems on mdadm 3.2.2 (from Ubuntu Precise) apparently:
>=20
> Problem #1:
>=20
> # mdadm -If /dev/sda4
> mdadm: incremental removal requires a kernel device name, not a file:=20
> /dev/sda4
>=20
> however this works:
>=20
> # mdadm -If sda4
> mdadm: set sda4 faulty in md3
> mdadm: hot removed sda4 from md3
>=20
> Is this by design?

Yes.

>                     Would your udev rule
> ACTION=3D=3D"remove", RUN+=3D"/sbin/mdadm -If $name"
> trigger the first or the second kind of invocation?

Yes.

>=20
>=20
> Problem #2:
>=20
> by reinserting sda, it became sdax, and the array is still running like=20
> this:
>=20
> md3 : active raid1 sdb4[2]
>        10485688 blocks super 1.0 [2/1] [_U]
>        bitmap: 0/160 pages [0KB], 32KB chunk
>=20
> please note the bitmap is active

True, but there is nothing in it (0 pages).  That implies that no bits are
set.  I guess that is possible if nothing has been written to the array sin=
ce
the other device was removed.

>=20
> so now I'm trying auto hot-add:
>=20
> # mdadm  -I /dev/sdax4
> mdadm: not adding /dev/sdax4 to active array (without --run) /dev/md3
>=20
> still the old problem I mentioned with 3.1.4.

I need to see -E and -X output on both drives to be able to see what is
happening here.  Also the content of /etc/mdadm.conf might be relevant.
If you could supply that info I might be able to explain what is happening.



> Trying more ways: (even with the "--run" which is suggested)
>=20
> # mdadm --run -I /dev/sdax4
> mdadm: -I would set mdadm mode to "incremental", but it is already set=20
> to "misc".
>=20
> # mdadm -I --run /dev/sdax4
> mdadm: failed to add /dev/sdax4 to /dev/md3: Invalid argument.
>=20

Hmm... I'm able to reproduce something like this.

Following patch seems to fix it, but I need to check the code more
thoroughly to be sure.  Note that this will *not* fix the "not adding ... n=
ot
active array" problem.

NeilBrown


diff --git a/Incremental.c b/Incremental.c
index 60175af..2be0d05 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -415,19 +415,19 @@ int Incremental(char *devname, int verbose, int runst=
op,
 				goto out_unlock;
 			}
 		}
-		info2.disk.major =3D major(stb.st_rdev);
-		info2.disk.minor =3D minor(stb.st_rdev);
+		info.disk.major =3D major(stb.st_rdev);
+		info.disk.minor =3D minor(stb.st_rdev);
 		/* add disk needs to know about containers */
 		if (st->ss->external)
 			sra->array.level =3D LEVEL_CONTAINER;
-		err =3D add_disk(mdfd, st, sra, &info2);
+		err =3D add_disk(mdfd, st, sra, &info);
 		if (err < 0 && errno =3D=3D EBUSY) {
 			/* could be another device present with the same
 			 * disk.number. Find and reject any such
 			 */
 			find_reject(mdfd, st, sra, info.disk.number,
 				    info.events, verbose, chosen_name);
-			err =3D add_disk(mdfd, st, sra, &info2);
+			err =3D add_disk(mdfd, st, sra, &info);
 		}
 		if (err < 0) {
 			fprintf(stderr, Name ": failed to add %s to %s: %s.\n",

--Sig_/.stEbyvfr_uh_.LucY6NFEp
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTzBSFTnsnt1WYoG5AQL0Mg/+JKTPX05RyXDwFdJesHBwYUYLocOKpCbT
9+AeIREWw6FV03WAPRc3BMI52a1VQKkYht1LQgzlbkPMOr6zy4ca1fnuEEog0FGO
cJQ34GNsbDW+kvSkm2V3Rvlwhg/PKqCJf0iUTATbmyWpcKnvea3Q8CqmvXDzBtbR
o8TOeYzIVpLiuMURyeN6ucFp3UqDA2REJswsohzOCLqLH/63+agurjFYv0crmIOa
LOXyDx0zddiN6PMqIyxp9JY0D39rDpzyx5l4rvekcaGbgC1paesACdZ9CL7IAhtz
5uK0le3rVP7TfxLa62r3QshXnaD3q/0yKpj1F+O+7+bvAfNPj8gJjJ/HEWZNx+Pt
Ic1HWddvvePtv2OT+0UQBMg8r8WFQf4H/QFBB5VrzYlkFq4cFYelPWBQcnmx3OTm
y9ai7mKgpj+1u3PsVlAfbNZImyiDXONR0om4n0N/Ssa+3wZHvbWbIPfwQanad6Pi
UUaI6SiKlj1Yvc/5bhblqHMAmqcbhYIawiSYYC3syGcgJOjS+MtE1v2XMHMNh8r5
Iq8D/aJun3+p3AGbHwuhb8bC2WQ2+Hw0hP2S3K13PepE1Y7vs/x6ElrkQSJsjYj6
SkDUPvIL88F6oFCXnz96+MJz6DK94uIWN506+iXJXslxMQRJt9vbgLJsiZDonLXY
CxMsyDrXqCw=
=HDyF
-----END PGP SIGNATURE-----

--Sig_/.stEbyvfr_uh_.LucY6NFEp--
