From: Nigel Croxon <ncroxon@redhat.com>
Subject: [PATCH] allow RAID5 to grow to RAID6 with a backup_file
Date: Mon,  4 May 2020 12:31:38 -0400
Message-ID: <20200504163138.22787-1-ncroxon@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes@trained-monkey.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This problem came in, as the user did not specify a full path with
the backup_file option when growing an RAID5 array to RAID6.
When the full path is specified, the symbolic link is created
properly (/run/mdadm/backup_file-mdX). But the code did not support
the symbolic link when looking for the backup_file. Added two
checks for symlink.

This addresses https://www.spinics.net/lists/raid/msg48910.html
and numerous customer reported problems.

Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
---
 Grow.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/Grow.c b/Grow.c
index 764374f..6dce71c 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1135,6 +1135,16 @@ int reshape_open_backup_file(char *backup_file,
 	unsigned int dev;
 	int i;
=20
+	if (lstat(backup_file, &stb) !=3D -1) {
+		switch (stb.st_mode & S_IFMT) {
+		case S_IFLNK:
+			return 1;
+			break;
+		default:
+			break;
+		}
+	}
+
 	*fdlist =3D open(backup_file, O_RDWR|O_CREAT|(restart ? O_TRUNC : O_EXC=
L),
 		       S_IRUSR | S_IWUSR);
 	*offsets =3D 8 * 512;
@@ -5236,8 +5246,17 @@ char *locate_backup(char *name)
 	char *fl =3D make_backup(name);
 	struct stat stb;
=20
-	if (stat(fl, &stb) =3D=3D 0 && S_ISREG(stb.st_mode))
+	lstat(fl, &stb);
+	switch (stb.st_mode & S_IFMT) {
+	case S_IFLNK:
 		return fl;
+		break;
+	case S_IFREG:
+		return fl;
+		break;
+	default:
+		break;
+	}
=20
 	free(fl);
 	return NULL;
--=20
2.20.1
