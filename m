From: NeilBrown <neilb@suse.de>
Subject: Re: md:When opened /proc/mdstat, increase the refcount of
Date: Sun, 26 Feb 2012 19:36:06 +1100
Message-ID: <20120226193606.567a04d6@notabene.brown>
References: <201202261255005786849@gmail.com>
	<20120226162659.5aeb1d4e@notabene.brown>
	<201202261339544531130@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/F88btwxoDzS6JigAdMya//h"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201202261339544531130@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/F88btwxoDzS6JigAdMya//h
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 26 Feb 2012 13:39:57 +0800 "majianpeng" <majianpeng@gmail.com> wrot=
e:

> Yes,I know this.But I can't to fix procfs,so using this patch.
>=20

I wonder if this will fix it.


diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 7737c54..fc89842 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -449,7 +449,8 @@ struct inode *proc_get_inode(struct super_block *sb, st=
ruct proc_dir_entry *de)
 		if (de->proc_iops)
 			inode->i_op =3D de->proc_iops;
 		if (de->proc_fops) {
-			if (S_ISREG(inode->i_mode)) {
+			if (S_ISREG(inode->i_mode) &&
+			    !de->proc_fops->owner) {
 #ifdef CONFIG_COMPAT
 				if (!de->proc_fops->compat_ioctl)
 					inode->i_fop =3D


however I don't really understand the point of proc_ref_file_ops, so maybe
I'm missing something.

NeilBrown

--Sig_/F88btwxoDzS6JigAdMya//h
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT0nu9jnsnt1WYoG5AQLz2A/9GZGagDB359fek+NQq9Mn9wAFr8nswu8a
6T4uWqnRuyswAB1JQ8Eh4MZfdt0ofKwbowXq008po7exX/yOuyOXjzoX+wrMZoRQ
NA33oGZnb/I0AmDW6y21M92s1yECK+Iv+Id+/ZCqvoeQr0fUZPVgwUtHu0W3Y0nw
V9wmokHkVJ3Io2CF/UpY4l5FdA7XPOT/3pv5oXCJzRiy+VjR5441wyiT3fJl2+E2
FDKanaYA2PhN4/egscmB7DdVIwsZOcZBYnIUx5tKNHZnQ9h3qCsWZf0p7OwYVvzv
uYKa4xId2vLwxBcp/pHQ6N/9DGWW2ZQpG4lna4QIbXnFR1N7Wzvp/TrQ384cdn29
CfGsxtyfJQFLtHAjrU8N3KtQKCs0fKb4UVu0a62IKCu7DbjRROIBmb2ovEuQJaMm
frIg6EkBFfb5RZ6QMgkO0h3EQ6qaSZtD4EkFAiwoPiQmwgs5hIIukr5wMJZbiI+2
3n9Km69n3CMnRDU0Qd0nrKUblzukTRgEL4T1e+/ifzJ/ZiHvraJzW98/N/itGhA/
TgkxZaw0zIiwsgP1zYgkwBgSTKiSu02YHbuAcnJ8Q5PllSTjvWL3hJR/ElXFMslO
u8b1/9GXalREl2WMfh1bytDfqgEbsyU04mR96sUQhVoLHYcIlg5ez9cG/Mj0u76I
K+bkPOkA7q8=
=9cFt
-----END PGP SIGNATURE-----

--Sig_/F88btwxoDzS6JigAdMya//h--
