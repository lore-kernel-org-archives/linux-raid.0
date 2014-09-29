From: NeilBrown <neilb@suse.de>
Subject: Re: /sys/block/md126 still exists even after stopping the array
Date: Tue, 30 Sep 2014 07:56:43 +1000
Message-ID: <20140930075643.34e864fa@notabene.brown>
References: <53A99B76.3020603@gmail.com>
	<20140625110348.48ab2d7a@notabene.brown>
	<54243ED7.6090904@gmail.com>
	<20140926103348.5f5ea568@notabene.brown>
	<54253E9F.4070505@gmail.com>
	<20140926204445.1ec830b9@notabene.brown>
	<54255A30.9010406@gmail.com>
	<20140929143735.5fa54253@notabene.brown>
	<54291C1D.7010005@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/6bCFpd6Cza_=yuj__Bjd5Bw"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54291C1D.7010005@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, sebastian.riemer@profitbricks.com
List-Id: linux-raid.ids

--Sig_/6bCFpd6Cza_=yuj__Bjd5Bw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 29 Sep 2014 10:45:17 +0200 Francis Moreau <francis.moro@gmail.com>
wrote:

> > So what were pids 930 and 459?
> > One was presumably the "mdadm -Ss"  - probably 930.
> > Is 459 the "mdadm --monitor" ??  That might be useful hint.
> >=20
>=20
> yes.
>=20
> [456] is:  /sbin/mdadm --monitor --scan --daemonise --syslog
> --pid-file=3D/run/mdadm/mdadm.pid
>=20
> and [930] is 'mdamd -Ss'.

Good.  Please try the patch below.

> >=20
> >>
> >>
> >>> Probably there is a 'change' event happening just before the 'remove'=
 event,
> >>> and udev runs "mdadm" on the 'change' event, and that ends up happeni=
ng after
> >>> the device has been removed.
> >>>
> >>> Is this really a problem?  Can't you just ignore it and pretend it is=
n't
> >>> there?
> >>
> >> Well, if you list the block devices that the kernel detected in order =
to
> >> operate on them, it could. I don't know exactly what would be the resu=
lt
> >> to use it but it could confuse some tools.
> >>
> >> Is there a way to check that the 'ghost' device has been removed by
> >> poking sysfs ?
> >=20
> > If you look at /sys/block/md*/md/array_state, those that contain 'inact=
ive'
> > or 'clear' might be 'ghosts', or might be in the process of being assem=
bled.
> > If you write 'clear' to the same file they should disappear.... unless =
udev
> > does something to re-create them.
> >=20
>=20
> It's in 'clear' state, and writing 'clear' doesn't make the device disape=
ar.
>=20
> [root@localhost ~]# dmesg -c >/dev/null
> [root@localhost ~]# echo clear >/sys/block/md125/md/array_state
> [root@localhost ~]# dmesg
> [  254.106252] md: md125 stopped.
> [  254.108182] md_open(): mdX opened by mdadm [968]
>=20
> [  254.109103] md_open(): md125 opened by mdadm [459]
>   [  254.109127] md_open(): md125 opened by mdadm [459]
>   [  254.109281] md_release(): md125 released by mdadm [459]
>=20
>   [  254.109337] md_open(): md125 opened by mdadm [968]
>   [  254.109572] md_release(): md125 released by mdadm [968]
>=20
>   [  254.109847] md_open(): md125 opened by systemd-udevd [967]
>   [  254.109986] md_release(): md125 released by systemd-udevd [967]
>=20
> In that sequence, it seems that mdadm [459] is missing a md_release()
> here. Is this expected ?

Presumably the first md_open returned an error.  You could add another prin=
tk
at each 'return' to check.

Thanks,
NeilBrown


diff --git a/Monitor.c b/Monitor.c
index 5cb24fab8f2a..971d2ecbea72 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -460,7 +460,7 @@ static int check_array(struct state *st, struct mdstat_=
ent *mdstat,
 	mdu_array_info_t array;
 	struct mdstat_ent *mse =3D NULL, *mse2;
 	char *dev =3D st->devname;
-	int fd;
+	int fd =3D -1;
 	int i;
 	int remaining_disks;
 	int last_disk;
@@ -468,6 +468,27 @@ static int check_array(struct state *st, struct mdstat=
_ent *mdstat,
=20
 	if (test)
 		alert("TestMessage", dev, NULL, ainfo);
+	if (st->devnm[0])
+		fd =3D open("/sys/block", O_RDONLY|O_DIRECTORY);
+	if (fd >=3D 0) {
+		/* Don't open the device unless it is present and
+		 * active in sysfs.
+		 */
+		char buf[10];
+		close(fd);
+		fd =3D sysfs_open(st->devnm, NULL, "array_state");
+		if (fd < 0 ||
+		    read(fd, buf, 10) < 5 ||
+		    strncmp(buf,"clear",5) =3D=3D 0 ||
+		    strncmp(buf,"inact",5) =3D=3D 0) {
+			if (fd >=3D 0)
+				close(fd);
+			if (!st->err)
+				alert("DeviceDisappeared", dev, NULL, ainfo);
+			st->err++;
+			return 0;
+		}
+	}
 	fd =3D open(dev, O_RDONLY);
 	if (fd < 0) {
 		if (!st->err)

--Sig_/6bCFpd6Cza_=yuj__Bjd5Bw
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVCnVmznsnt1WYoG5AQIBxhAAoxFR6Q4CfVDa5UQ/nwMsHSDy6OaqzjIG
5QaoRgv1dslYAmGm5wCpv3H/zH6x/k1LyIWwMhtwSGSu15nL35/gqaYLnnXHoKvH
AevGGzEmr5iXyMI14un/vLzphtgd70YWRfvYFGjtcWsEQUBbHekSxNLG2xrM1TW9
pfCZsLR2CiIHOyK3p9f53g5F+xb0hHqVOfe/x8OsCDlKVW72mlUXzBZZihg4zbVx
Kjhs1xUwAW4IzaF2eTKEYVvp6SGuBLzFHuWRqExCU9KWaO0pmmyeQ70GyEPzYQ9q
opN3m64GyScD0BD2qzPD+9kpKU1SjQ6pY1qc1+xkN3aK72IWU5dXf3tYRJN1JBuk
fOkakUU+f0OF2RVRNtWZQw+CnDTJ0NO7LIEQed70/zjdZ9Soco1ZaJ/W3H0BeCwF
jIE5WJjThI4IMmJRdjrHrlTzIXA2jHy6Av17/rUMRpYrdO9mA10zhVl/Bp7XdnyE
szRmKHymtj2TB+1z8+2qKhOmxWd+kLCwZWGazLXy4z1WhBAOzABoRY7afbzN1ZJe
ZBlA7EIZLZF3Cj2TYcgUeiHpkzOv8TD62cwbBpJgY2PXU4lOYqciQyi7RkVwGcJK
KuK4DFbdI5ZVbawVuuDDN5ciqrcZkpFPhIzQLB4ih9jA82TFz1HDTNyzkxb69Qdd
xxUFbsDKNYY=
=q1Kf
-----END PGP SIGNATURE-----

--Sig_/6bCFpd6Cza_=yuj__Bjd5Bw--
