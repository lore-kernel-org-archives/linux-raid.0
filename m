From: NeilBrown <neilb@suse.de>
Subject: Re: RAID1 removing failed disk returns EBUSY
Date: Thu, 29 Jan 2015 14:52:17 +1100
Message-ID: <20150129145217.1cb31d5c@notabene.brown>
References: <20141027162748.593451be@jlaw-desktop.mno.stratus.com>
	<20141029133604.59f9549a@jlaw-desktop.mno.stratus.com>
	<20141113090549.296a13ee@jlaw-desktop.mno.stratus.com>
	<20141117100349.1d1ae1fa@notabene.brown>
	<54B663EC.8090607@redhat.com>
	<20150115082210.31bd3ea5@jlaw-desktop.mno.stratus.com>
	<2054919975.10444188.1421385612513.JavaMail.zimbra@redhat.com>
	<20150116101031.30c04df3@jlaw-desktop.mno.stratus.com>
	<1924199853.11308787.1421634830810.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/p/Vo/O_qewkgKU96Klb=JIY"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1924199853.11308787.1421634830810.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: Joe Lawrence <joe.lawrence@stratus.com>, linux-raid@vger.kernel.org, Bill Kuzeja <william.kuzeja@stratus.com>
List-Id: linux-raid.ids

--Sig_/p/Vo/O_qewkgKU96Klb=JIY
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 18 Jan 2015 21:33:50 -0500 (EST) Xiao Ni <xni@redhat.com> wrote:

>=20
>=20
> ----- Original Message -----
> > From: "Joe Lawrence" <joe.lawrence@stratus.com>
> > To: "Xiao Ni" <xni@redhat.com>
> > Cc: "NeilBrown" <neilb@suse.de>, linux-raid@vger.kernel.org, "Bill Kuze=
ja" <william.kuzeja@stratus.com>
> > Sent: Friday, January 16, 2015 11:10:31 PM
> > Subject: Re: RAID1 removing failed disk returns EBUSY
> >=20
> > On Fri, 16 Jan 2015 00:20:12 -0500
> > Xiao Ni <xni@redhat.com> wrote:
> > >=20
> > > Hi Joe
> > >=20
> > >    Thanks for reminding me. I didn't do that. Now it can remove
> > >    successfully after writing
> > > "idle" to sync_action.
> > >=20
> > >    I thought wrongly that the patch referenced in this mail is fixed =
for
> > >    the problem.
> >=20
> > So it sounds like even with 3.18 and a new mdadm, this bug still
> > persists?
> >=20
> > -- Joe
> >=20
> > --
>=20
> Hi Joe
>=20
>    I'm a little confused now. Does the patch 45eaf45dfa4850df16bc2e8e7903=
d89021137f40 from linux-stable
> resolve the problem?
>=20
>    My environment is:
>=20
> [root@dhcp-12-133 mdadm]# mdadm --version
> mdadm - v3.3.2-18-g93d3bd3 - 18th December 2014  (this is the newest upst=
ream)
> [root@dhcp-12-133 mdadm]# uname -r
> 3.18.2
>=20
>=20
>    My steps are:
>=20
> [root@dhcp-12-133 mdadm]# lsblk=20
> sdb                       8:16   0 931.5G  0 disk=20
> =E2=94=94=E2=94=80sdb1                    8:17   0     5G  0 part=20
> sdc                       8:32   0 186.3G  0 disk=20
> sdd                       8:48   0 931.5G  0 disk=20
> =E2=94=94=E2=94=80sdd1                    8:49   0     5G  0 part=20
> [root@dhcp-12-133 mdadm]# mdadm -CR /dev/md0 -l1 -n2 /dev/sdb1 /dev/sdd1 =
--assume-clean
> mdadm: Note: this array has metadata at the start and
>     may not be suitable as a boot device.  If you plan to
>     store '/boot' on this device please ensure that
>     your boot-loader understands md/v1.x metadata, or use
>     --metadata=3D0.90
> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md0 started.
>=20
>    Then I unplug the disk.
>=20
> [root@dhcp-12-133 mdadm]# lsblk=20
> sdc                       8:32   0 186.3G  0 disk =20
> sdd                       8:48   0 931.5G  0 disk =20
> =E2=94=94=E2=94=80sdd1                    8:49   0     5G  0 part =20
>   =E2=94=94=E2=94=80md0                   9:0    0     5G  0 raid1=20
> [root@dhcp-12-133 mdadm]# echo faulty > /sys/block/md0/md/dev-sdb1/state=
=20
> [root@dhcp-12-133 mdadm]# echo remove > /sys/block/md0/md/dev-sdb1/state=
=20
> -bash: echo: write error: Device or resource busy
> [root@dhcp-12-133 mdadm]# echo idle > /sys/block/md0/md/sync_action=20
> [root@dhcp-12-133 mdadm]# echo remove > /sys/block/md0/md/dev-sdb1/state=
=20
>=20

I cannot reproduce this - using linux 3.18.2.  I'd be surprised if mdadm
version affects things.

This error (Device or resoource busy) implies that rdev->raid_disk is >=3D 0
(tested in state_store()).

->raid_disk is set to -1 by remove_and_add_spares() providing:
  1/ it isn't Blocked (which is very unlikely)
  2/ hot_remove_disk succeeds, which it will if nr_pending is zero, and
  3/ nr_pending is zero.

So it seems most likely that either:
 1/ nr_pending is non-zero, or
 2/ remove_and_add_spares() didn't run.

nr_pending can only get set if IO is generated, and your sequence of steps
don't show any IO.  It is possible that something else (e.g. started by ude=
v)
triggered some IO.  How long that IO can stay pending might depend on exact=
ly
how you unplug the device.
In my tests I used
   echo 1 > /sys/block/sdXX/../../delete
which may have a different effect to what you do.

However the fact that writing 'idle' to sync_action releases the device see=
ms
to suggest the nr_pending has dropped to zero.  So either
  - remove_and_add_spares didn't run, or
  - remove_and_add_spares ran during a small window when nr_pending was
    elevated, and then didn't run again when nr_pending was reduced to zero.

Ahh.... that rings bells....

I have the following patch in the SLES kernel which I have applied to
mainline yet (and given how old it is, that is really slack of me).

Can you apply the following and see if the symptom goes away please?

Thanks,
NeilBrown

From: Hannes Reinecke <hare@suse.de>
Date: Thu, 26 Jul 2012 11:12:18 +0200
Subject: [PATCH] md: wakeup thread upon rdev_dec_pending()

After each call to rdev_dec_pending() we should wakeup the
md thread if the device is found to be faulty.
Otherwise we'll incur heavy delays on failing devices.

Signed-off-by: Neil Brown <nfbrown@suse.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/md/md.h b/drivers/md/md.h
index 03cec5bdcaae..4cc2f59b2994 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -439,13 +439,6 @@ struct mddev {
 	void (*sync_super)(struct mddev *mddev, struct md_rdev *rdev);
 };
=20
-static inline void rdev_dec_pending(struct md_rdev *rdev, struct mddev *md=
dev)
-{
-	int faulty =3D test_bit(Faulty, &rdev->flags);
-	if (atomic_dec_and_test(&rdev->nr_pending) && faulty)
-		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
-}
-
 static inline void md_sync_acct(struct block_device *bdev, unsigned long n=
r_sectors)
 {
 	atomic_add(nr_sectors, &bdev->bd_contains->bd_disk->sync_io);
@@ -624,4 +617,14 @@ static inline int mddev_check_plugged(struct mddev *md=
dev)
 	return !!blk_check_plugged(md_unplug, mddev,
 				   sizeof(struct blk_plug_cb));
 }
+
+static inline void rdev_dec_pending(struct md_rdev *rdev, struct mddev *md=
dev)
+{
+	int faulty =3D test_bit(Faulty, &rdev->flags);
+	if (atomic_dec_and_test(&rdev->nr_pending) && faulty) {
+		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+		md_wakeup_thread(mddev->thread);
+	}
+}
+
 #endif /* _MD_MD_H */


--Sig_/p/Vo/O_qewkgKU96Klb=JIY
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVMmucTnsnt1WYoG5AQJK4w/9GrPKtOyeqRHqx0C073gr2OPSHS0tXlMD
STHTyOUAEsoR828It9StYYwaCOInCZ941xAL+ERrQbCQHicLFC+JS0ixqzzFvAzH
3bwHnzSDEHNwwOQI1rG8YvCgwcc/QzoZ3M0Dzhd9UlTXiwr2fZFnMlI2BmL0CGqV
u7R0wcY//eRIyPXdRB/a/Q1EXWEkAlnbr16LM87Sh5bGlgA5j1uZieOWUN/jKPwM
s1F5KHyxvCnHXzUHyLbV64Vd3Wi2cKb4eih4qt2hq9LvTaDWkfznpDco++boLji8
AJdZtrwQ9PPyyyUwrD4KhhWBAd3Or8t0Jf1bxgIy6oELhnYhh8hhWTqFxusbqjyS
Dgo1ljLEmErUweZF9duxJAA85iPFSrq9oEQWCNtBRAgfe5AdJ4nmmh6rZLUB2TiS
MaN8GF5qkNsqtaPozWgTOiBUYBcUitTcUSN/rYFtFccGd3kEuvaxSmU9mMTuxHz1
CUiUX4puGSccBAYv19c34LkHv8pGY2rjoJM68IPp8ldQx/FLLbs3BGCXyo+SpZgH
BMEaBrR4IoWmuAOWVi4AsgaelC8dYiAWMagXtJxa9AmWJZzQkTxNFocLtmHlPDNK
o1/EZ/ToJP8I2J8/xtl7GZcSqssxd5Fay+u4LnXoRwPAqlKz2mXkt3r2tSw4QXiO
0mUV0Rh4nsU=
=cd4I
-----END PGP SIGNATURE-----

--Sig_/p/Vo/O_qewkgKU96Klb=JIY--
