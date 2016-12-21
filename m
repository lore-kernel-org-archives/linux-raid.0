From: NeilBrown <neilb@suse.com>
Subject: Re: RAID without dev size prevents adding a new member
Date: Thu, 22 Dec 2016 10:27:01 +1100
Message-ID: <87h95wrhh6.fsf@notabene.neil.brown.name>
References: <CAANLjFo09x0VMj2KbPZzWwpgXebS0d1ZGNTwDqi7fiVsKvFJ+g@mail.gmail.com> <8760mdswsn.fsf@notabene.neil.brown.name> <CAANLjFpYKFNG8mmBfVmXuOGwcs5BvMwiqjsy9nLw3LpkhGtLyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAANLjFpYKFNG8mmBfVmXuOGwcs5BvMwiqjsy9nLw3LpkhGtLyg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robert LeBlanc <robert@leblancnet.us>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Thu, Dec 22 2016, Robert LeBlanc wrote:

> It looks like it is still there on the latest master.

Thanks for checking!

>
> # ./mdadm --version
> mdadm - v3.4-88-gfa219dd - 22nd September 2016
>
> # ./mdadm --detail /dev/md_root
> /dev/md_root:
>         Version : 1.0
>   Creation Time : Wed Sep  7 15:58:30 2016
>      Raid Level : raid1
>      Array Size : 5368708928 (5120.00 GiB 5497.56 GB)
>   Used Dev Size : unknown

This implies that mdadm is opening /dev/md_root/md/component_size ....

Ah-ha.  get_component_size() hasn't been updated to work with named
arrays. it will only open
			"/sys/block/md%d/md/component_size",
or
			"/sys/block/md_d%d/md/component_size",

Please try with the following patch.  I'll send a proper version to Jes.

Thanks,
NeilBrown

diff --git a/sysfs.c b/sysfs.c
index 84c7348526c9..b0657a04b3a3 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -400,14 +400,8 @@ unsigned long long get_component_size(int fd)
 	int n;
 	if (fstat(fd, &stb))
 		return 0;
-	if (major(stb.st_rdev) != (unsigned)get_mdp_major())
-		snprintf(fname, MAX_SYSFS_PATH_LEN,
-			"/sys/block/md%d/md/component_size",
-			(int)minor(stb.st_rdev));
-	else
-		snprintf(fname, MAX_SYSFS_PATH_LEN,
-			"/sys/block/md_d%d/md/component_size",
-			(int)minor(stb.st_rdev)>>MdpMinorShift);
+	snprintf(fname, MAX_SYSFS_PATH_LEN,
+		 "/sys/block/%s/md/component_size", stat2devnm(&stb));
 	fd = open(fname, O_RDONLY);
 	if (fd < 0)
 		return 0;

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhbD8UACgkQOeye3VZi
gbl4DA/+OfMfLTIF+uYZrgsdRqtPenKk1JbwlbH8CdXXltOn1SXxDc+QU4++GZhG
gnG3y9AyF5P7kwk6GYLvmsV3qAT/iBrq6Dtn/AfKrD30vwwtrY2KKCyHYb0dmuf+
lTiSMM4G+BRmWPIQ3WLSsu2YWWfW45V5NxzMw2QqA5u8/IULGQZCAsWBL1IFkUY+
9enxyWkCSrkkd+W4hoyuEn6gfyKUXfaf+Dp4KJgwGQxuFj8YIFeieFucjbh2dHfY
3XeikG78sMfFH/CDm6qCkgFk4fljWwAnBJC1xYMqX7glXxKcuDRUiusNUigMN2mw
TG7ELOkciwjUxH3xcKmGbQ/kVR9BHW2h0WdlM2UpH50ZuxLimsSKdPYZwDEcnTTa
hwWn7dnOOT9v21nhSbjgWQWSXmBJJGG1P5xqNk1kn+z1YieGuyPWUawPUIRbf3oN
E7AODvsCl6jgYun7zagLKGkj3MwDzDAV277fCs2RHjK17EUuvTLcIqE3yI/Sqoxe
sA5e+kV9ExFcOaSbsmaHuSMeGtRlRqhxV9cpB2HdgOtdLgPlz1uIMIswf/iUljR0
jUXz5qISa9kvNzZgepz+pICXOcWp++HqSbycn0ElU28YPzUT4gWbp32O7WTy4jmM
Mpce0YyRgBFv1PmMd0WdloA7sPaAc/iTKl5rIi/mE37G47EHfsE=
=TM+i
-----END PGP SIGNATURE-----
--=-=-=--
