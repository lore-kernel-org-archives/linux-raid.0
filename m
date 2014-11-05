From: NeilBrown <neilb@suse.de>
Subject: Re: Trying to get POLICY working
Date: Wed, 5 Nov 2014 16:28:51 +1100
Message-ID: <20141105162851.32d4a366@notabene.brown>
References: <CADvHm=ZLp08Ydp+P=gn+bu1=GgVORx0TSJoRU33z3UNubwQryQ@mail.gmail.com>
	<20141101112001.344e5f20@notabene.brown>
	<20141103125416.629a4810@notabene.brown>
	<CADvHm=bE0zcLbDhcdQFfQG8in1Udb7gWcvR-rb9JeUoFaV-v5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/YhNLAtXMokrEXRK/fOFWG4f"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADvHm=bE0zcLbDhcdQFfQG8in1Udb7gWcvR-rb9JeUoFaV-v5w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Caspar Smit <c.smit@truebit.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/YhNLAtXMokrEXRK/fOFWG4f
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 3 Nov 2014 10:43:29 +0100 Caspar Smit <c.smit@truebit.nl> wrote:

> Hi Neil,
>=20
> Actually BOTH your answers were correct, thank you for that.
>=20
> 1) Your hunge was correct as my disk contained a partition table (in
> my case an msdos label) and was not added with the error in my first
> mail:
>=20
> mdadm: no RAID superblock on /dev/sdd.
>=20
> mdadm -E /dev/sdd shows:
>=20
> /dev/sdd:
>    MBR Magic : aa55
>=20
> So it finds 'something' but clearly unusable to mdadm.
>=20
> Wiping the partition table and trying again resulted in a different
> error message:
>=20
> mdadm: no recognisable superblock on /dev/sdd.
>=20
> Which is better but still the disk was not added to the array.
>=20
> 2) To make it work i also needed the domain=3Ddefault in the POLICY setti=
ng.
>=20
> It still gave me the:
>=20
> mdadm: no recognisable superblock on /dev/sdd.
>=20
> But now the disk got added to the array and started rebuilding.
>=20
> Note: ONLY setting the domain=3Ddefault in POLICY without clearing the
> partition table results in:
> mdadm: no RAID superblock on /dev/sdd. and the disk will not be added
> so BOTH measures were needed.

Thanks for testing and reported.... the patch I posted before (included more
completely below) should allow "domain=3Ddefault" to be enough.


>=20
> Note2: I didn't need the spare-group directive so I think
> domain=3Ddefault is a special case were all disks and arrays are placed
> in the same domain.

"spare-group" is really only for "legacy" support.  If a domain is defined
for disks, the array made up of those disks inherits the domain.


>=20
>=20
> Furthermore i found out something which i think should not happen
> (bug?) or maybe i am wrong:
>=20
> With a working clean array:
>=20
> # more /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 sdd[3] sdc[1] sdb[0]
>       203776 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3] [UUU]
>=20
> # mdadm --fail /dev/md0 /dev/sdd
> mdadm: set /dev/sdd faulty in /dev/md0
>=20
> # mdadm --remove /dev/md0 /dev/sdd
> mdadm: hot removed /dev/sdd from /dev/md0
>=20
> # mdadm --incremental /dev/sdd
> mdadm: failed to add /dev/sdd to /dev/md/0: Invalid argument.
>=20
> So when it actually finds a device with an MD superblock it doesn't
> add it, is this expected behavior as the disk was failed (so probably
> not a good idea to add it back) or is this a bug?

Presumably "action=3Dforce-spare" was still active when you tried this?

In that case it is a bug (I think).  It should clean-out the device and add
it as a spare...

I just tested with mdadm from my 'git', and  it works as expected.
When action=3Dforce-spare  I get

mdadm: /dev/loop2 attached to /dev/md0 which is already active.

When I have "action=3Dre-add" I get:

mdadm: can only add /dev/loop2 to /dev/md0 as a spare, and force-spare is n=
ot set.
mdadm: failed to add /dev/loop2 to existing array /dev/md0: Invalid argumen=
t.

Maybe you need a newer mdadm ...

Thanks,
NeilBrown


From: NeilBrown <neilb@suse.de>
Date: Wed, 5 Nov 2014 16:21:42 +1100
Subject: [PATCH] Incremental: don't be distracted by partition table when
 calling try_spare.

Currently a partition table on a device makes "mdadm -I" think
the array has a particular metadata type and so will only
add it to an array of that (partition table) type .. which doesn't
make any sense.

So tell guess_super to only look for 'array' metadata.

Reported-by: Caspar Smit <c.smit@truebit.nl>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/Incremental.c b/Incremental.c
index c9372587f518..13b68bc0adea 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -196,13 +196,13 @@ int Incremental(struct mddev_dev *devlist, struct con=
text *c,
 	policy =3D disk_policy(&dinfo);
 	have_target =3D policy_check_path(&dinfo, &target_array);
=20
-	if (st =3D=3D NULL && (st =3D guess_super(dfd)) =3D=3D NULL) {
+	if (st =3D=3D NULL && (st =3D guess_super_type(dfd, guess_array)) =3D=3D =
NULL) {
 		if (c->verbose >=3D 0)
 			pr_err("no recognisable superblock on %s.\n",
 			       devname);
 		rv =3D try_spare(devname, &dfd, policy,
 			       have_target ? &target_array : NULL,
-			       st, c->verbose);
+			       NULL, c->verbose);
 		goto out;
 	}
 	st->ignore_hw_compat =3D 1;

--Sig_/YhNLAtXMokrEXRK/fOFWG4f
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVFm1kznsnt1WYoG5AQLR0RAAiUN3u3fBIQgXI5ZtcZFIPS5dSdM/fMy/
A2giYjpJ6NTEfHfBt1hk2v8HgHBi5Wex984nyHvIw74xfdznwBODrrccCSpVs+Yu
8XFmwj+CyZndzgP46KVfLZ+VnlYDC3vvFvIyk6xehisNXfYrh+8GV1qddvAuYiNx
54iCgVGT1gutVAJEmd+yFpxahrYHryvwBKvEmHbBNOrNG1/NOaaE35OIIfbeogYr
oSTm+ZoKnno9ndsXHMBM8RCoep3Ma0BnB4jyJCNqldlk4R0svw9lzJhlRSzpYnr6
KnE8coBsd5ER2JzPK6OLnanRsYUDDmjOcBFp/TY79hs4TY8jAXOoz7nnScgIXq6A
bkkWAeWuWG15FAU/afHkCzDFOftl7Ym+V5viN9e3hv9vaCNqlDR5Ee1UejBVLSN/
owslkWe4V9Oht6zu5nyjxzQxd7pqu4IjIreNxUp5DERLDabXzWBZkkfL7ffdbOeU
69u5f1iHsGe81U6zxGH9CPcHjbyIipNOPzbOFrkXb1Jh+ruomhDpamcMt9DWbi0D
Nibuh/63Vnydt+t2xvFsorHRY/6UY2DONCD2Hk+r18A8jrq7xbKw7RdQeBVMM7gr
HIyXlVqfWKipZqbu0T1+ikv24kNrdy4m75vPUKf7Adeh39McBw1qChID6UvLyZsD
9w28XTtWxs4=
=/NlR
-----END PGP SIGNATURE-----

--Sig_/YhNLAtXMokrEXRK/fOFWG4f--
