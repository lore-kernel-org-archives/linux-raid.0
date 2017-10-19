From: Wols Lists <antlists@youngman.org.uk>
Subject: [PATCH] mdadm: Fix typos in various printed messages
Date: Thu, 19 Oct 2017 23:31:52 +0100
Message-ID: <59E927D8.3030907@youngman.org.uk>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070909010006040008040100"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>, Jes Sorensen <jes.sorensen@gmail.com>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------070909010006040008040100
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Enigmail
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJZ6SfFAAoJENxtD9pn8rRupAcH/jgpHuB1ztmxGnf/xLKhn0H0
fTrTARSnOtKdaAcbwh8p4iZ7SICZcPHuA6KuNzi1MJlJi66IZo+NCOmQaxJBrMmp
AyhklBrjOD5865Otra5z2SL5HTq1uYtKEgyzBhoM8zGZe6hTZygRAdKemXVOfim4
iVw+K3EiBzFKKwRbeeS9r+myMkDDBeONYeW4raZxkhUdHYkc/NnF6lN4gx0qWZUy
+AiawIhvTPTLBZN/hg/FjEW2aKGRVWd6yPDPrlDG3E8AgMUzk0vAN2lntBCMiT7k
8Txf6Xt1oVdC8WvDMNF8gZzvOUpdGvJ1oAKVtDab0SVdQVU7SW2J2hFPz5ts3Mc=
=dumz
-----END PGP SIGNATURE-----

--------------070909010006040008040100
Content-Type: text/x-patch;
 name="0001-Fix-typos-in-various-printed-messages.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-Fix-typos-in-various-printed-messages.patch"

From 03b8d08ba898ae473e77572ecff5714afa2aae1a Mon Sep 17 00:00:00 2001
From: Wol <anthony@youngman.org.uk>
Date: Thu, 19 Oct 2017 23:21:33 +0100
Subject: [PATCH] Fix typos in various printed messages

---
 Grow.c  |  8 ++++----
 mdadm.c | 10 +++++-----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/Grow.c b/Grow.c
index 4d79d83..2621a49 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1253,7 +1253,7 @@ char *analyse_change(char *devname, struct mdinfo *info, struct reshape *re)
 
 	switch (info->array.level) {
 	default:
-		return "No reshape is possibly for this RAID level";
+		return "No reshape is possible for this RAID level";
 	case LEVEL_LINEAR:
 		if (info->delta_disks != UnSet)
 			return "Only --add is supported for LINEAR, setting --raid-disks is not needed";
@@ -1302,7 +1302,7 @@ char *analyse_change(char *devname, struct mdinfo *info, struct reshape *re)
 		/* Could do some multi-stage conversions, but leave that to
 		 * later.
 		 */
-		return "Impossibly level change request for RAID1";
+		return "Impossible level change request for RAID1";
 
 	case 10:
 		/* RAID10 can be converted from near mode to
@@ -1549,7 +1549,7 @@ char *analyse_change(char *devname, struct mdinfo *info, struct reshape *re)
 		 * with appropriate layout and one extra device
 		 */
 		if (re->level != 4 && re->level != 5)
-			return "Cannot covert to RAID0 from this level";
+			return "Cannot convert to RAID0 from this level";
 
 		switch (re->level) {
 		case 4:
@@ -1726,7 +1726,7 @@ static int set_array_size(struct supertype *st, struct mdinfo *sra,
 		}
 		sysfs_free(info);
 	} else
-		dprintf("Error: set_array_size(): info pointer in NULL\n");
+		dprintf("Error: set_array_size(): info pointer is NULL\n");
 
 	return ret_val;
 }
diff --git a/mdadm.c b/mdadm.c
index 7cdcdba..4dedcec 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -474,7 +474,7 @@ int main(int argc, char *argv[])
 		case O(CREATE,DataOffset):
 		case O(GROW,DataOffset):
 			if (data_offset != INVALID_SECTORS) {
-				pr_err("data-offset may only be specified one. Second value is %s.\n", optarg);
+				pr_err("data-offset may only be specified once. Second value is %s.\n", optarg);
 				exit(2);
 			}
 			if (mode == CREATE && strcmp(optarg, "variable") == 0)
@@ -878,7 +878,7 @@ int main(int argc, char *argv[])
 		case O(MONITOR,'p'): /* alert program */
 		case O(MONITOR,ProgramOpt): /* alert program */
 			if (program)
-				pr_err("only specify one alter program. %s ignored.\n",
+				pr_err("only specify one alert program. %s ignored.\n",
 					optarg);
 			else
 				program = optarg;
@@ -2010,18 +2010,18 @@ int SetAction(char *dev, char *action)
 	int retval;
 
 	if (fd < 0) {
-		pr_err("Couldn't open %s: %s\n", dev, strerror(errno));
+		pr_err("Could not open %s: %s\n", dev, strerror(errno));
 		return 1;
 	}
 	retval = sysfs_init(&mdi, fd, NULL);
 	close(fd);
 	if (retval) {
-		pr_err("%s is no an md array\n", dev);
+		pr_err("%s is not an md array\n", dev);
 		return 1;
 	}
 
 	if (sysfs_set_str(&mdi, NULL, "sync_action", action) < 0) {
-		pr_err("Count not set action for %s to %s: %s\n",
+		pr_err("Could not set action for %s to %s: %s\n",
 		       dev, action, strerror(errno));
 		return 1;
 	}
-- 
2.7.3


--------------070909010006040008040100
Content-Type: application/pgp-signature;
 name="0001-Fix-typos-in-various-printed-messages.patch.sig"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="0001-Fix-typos-in-various-printed-messages.patch.sig"

iQEcBAABCAAGBQJZ6SfYAAoJENxtD9pn8rRuFfAIAKMbjcxqi08NhXLasudZb8XfhNdIa7ve
Qam/T0BJ+QSZT3mSyxpGqAOemb5YE4HAB0t1M1MHmosyglqjtIOzF3NOWtvind8PCG2lrtu2
YiTSDx3/dc1UW88W3M/l56FsNtX7Ykn6urwgx9H+zlJRow+0AHLqXQpPMrnO3KwqRll+Cnto
XTeuhkGd25goN5DxcRMjl8DFGAFo4GZ7HNy79GQpK5oARxLTJKBOlky4Zv8iZqH0cyRkCfRK
srFE7bINPOU8Y9QHly821IGq05K9vBuqnFRv3urQ/0nS/sa8zHgoY/cayFmfBkD4u6MEK5+y
aJ1LuIzi2AcMb/wCwLt0RAo=
--------------070909010006040008040100--
