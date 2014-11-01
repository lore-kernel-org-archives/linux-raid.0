From: NeilBrown <neilb@suse.de>
Subject: Re: Trying to get POLICY working
Date: Sat, 1 Nov 2014 11:20:01 +1100
Message-ID: <20141101112001.344e5f20@notabene.brown>
References: <CADvHm=ZLp08Ydp+P=gn+bu1=GgVORx0TSJoRU33z3UNubwQryQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/TWcSk+ooE10G7FCRjG3F7Id"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADvHm=ZLp08Ydp+P=gn+bu1=GgVORx0TSJoRU33z3UNubwQryQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Caspar Smit <c.smit@truebit.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/TWcSk+ooE10G7FCRjG3F7Id
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 31 Oct 2014 16:19:04 +0100 Caspar Smit <c.smit@truebit.nl> wrote:

> Hi all,
>=20
> I'm trying to get the POLICY framework of mdadm working but I can't seem =
to.
>=20
> As i understand in the man page of mdadm the Incremental and POLICY
> directives could allow adding a new disk without MD superblock as
> spare to an already active array:
>=20
> "Note that mdadm will normally only add devices to an array which were
> previously working (active or spare) parts of that array.  The support
> for automatic inclusion of a new drive as a spare in some array
> requires a configuration through POLICY in config file."
>=20
> Furthermore:
>=20
> "If no md metadata is found, the device may be still added to an array
> as a spare if POLICY allows."
>=20
>=20
> To get the basics working I created a system with 3 disks /dev/sdb,
> /dev/sdc and /dev/sdd
>=20
> Created a RAID5 with one missing disk:
>=20
> mdadm -C /dev/md0 -l 5 -n 3 /dev/sd[b-c] missing
>=20
> I set the POLICY in mdadm.conf to:
>=20
> POLICY action=3Dforce-spare
>=20
> This should add any device (passed through mdadm --incremental) as
> spare no matter what (Am i correct?)

That is the theory, yes.

>=20
> Now when I do:
>=20
> #mdadm --incremental /dev/sdd
> mdadm: no RAID superblock on /dev/sdd.

The message suggests that 'guess_super' found something on the device, but
it didn't turn out to be something useful.... not very helpful I know.

What does "mdadm --examine /dev/sdd" report?
I suspect there is a partition table and that is causing the confusion.
Try removing the partition table (dd /dev/zero to the device for a few K).
Then try again.

Probably need a fix like:

diff --git a/Incremental.c b/Incremental.c
index c9372587f518..3156190c4603 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -196,7 +196,7 @@ int Incremental(struct mddev_dev *devlist, struct conte=
xt *c,
 	policy =3D disk_policy(&dinfo);
 	have_target =3D policy_check_path(&dinfo, &target_array);
=20
-	if (st =3D=3D NULL && (st =3D guess_super(dfd)) =3D=3D NULL) {
+	if (st =3D=3D NULL && (st =3D guess_super_type(dfd, guess_array)) =3D=3D =
NULL) {
 		if (c->verbose >=3D 0)
 			pr_err("no recognisable superblock on %s.\n",
 			       devname);


and probably should improve the error messages...

Thanks for the report.  Please let me know if that works, and what other
difficulties you hit.

Thanks,
NeilBrown


>=20
> Well, i know there is no MD superblock on /dev/sdd but shouldn't the
> policy setting kick in here and add /dev/sdd as spare (and hence start
> rebuilding) to /dev/md0?
>=20
> mdadm version: 3.2.5-5 (latest debian wheezy stable)
> kernel version: 3.2.63-2 (latest debian wheezy stable)
>=20
> Kind regards,
> Caspar Smit
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/TWcSk+ooE10G7FCRjG3F7Id
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVFQnMTnsnt1WYoG5AQJQ1xAAwcWXKdzDVGy7/9/W5RP5RlJNf+AWWG8M
ca38nQo1S62lZPAEw0B/OERnlaYXtr33Is0Mb3iv0JBCIu9doqsj6ZsZSGTCjsWw
SuzMChnv7FAp2wKVzXrITjK75zEUUUGAIGLyHetPDlt+pWTHed6dX+wYvYe64zA5
fImGrAtbRY1Acrqn1q7O/QOsQTqYLhhsMjq8a47gmbBg15zkqEtqWIk5LziTb7Nx
yDPGpymnPG0ZMCnKlKtrXiw0WtLvGjyLEf3gbQhlPt13voaDCfRscrDQ+1afp1XD
sERNaYHFeHs1q7zzj9cXG74iU65eqtjKvejdGox/sTQUxXt6E1RZvyUrqH/YVVEm
TraTfzCKYhpOLVF4ILJyEFLW3Zwz17rUVsTWpAS1CTFFzfOp4mhy7ofXBHPxhJoL
fcGIdHlkMnJWoBSNdonovRhiGik5l8rvlHcPTrQxF0nYDCHjr0HHEV6WWmmOjfHk
2uOSltyrZjjZQOxVwDlYymSw47xyoDAXExLKwpMdURNuyJYk6a8Ncf556Q54C0P8
rxBvughxvBIuS4ClEokwbX5PNA8/6d+kR2eCP2+eEX7a1IIVIOYMqkeVFiMM3nwH
FABGIwTY1mLlW5dNB5Zw4Tz2ePsbCYjPH3v1rwc1Mu7RVig3KyKMxQnPdsw4xHmo
Cve5EFR9lls=
=tc3s
-----END PGP SIGNATURE-----

--Sig_/TWcSk+ooE10G7FCRjG3F7Id--
